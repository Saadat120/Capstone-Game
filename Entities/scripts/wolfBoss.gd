class_name wolfBoss extends CharacterBody2D

signal health_changed(new_health: int)
#References
@onready var healthBar: ProgressBar = $"../../UI/BossUI/VBoxContainer/Healths/MiniBoss/HealthBar"
@onready var healthVal: Label = $"../../UI/BossUI/VBoxContainer/Healths/MiniBoss/HealthVal"
@onready var bossTitle: Label = $"../../UI/BossUI/VBoxContainer/BossTitle"
@onready var animationTree: AnimationTree = $AnimationTree
@onready var stats: StatsComponent = $StatsComponent
@onready var hit_flash: AnimationPlayer = $HitFlash
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin
@onready var attackTimer: Timer = $AttackTimer
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

#Movement & positioning
var direction : Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.DOWN
var distance: float
var targetPosition: Vector2
var repositioning := false

#Combat & State Flags
var dead :bool = false
var follow: bool = false
var attacking: bool = false
var recentHit := false
var howl: bool = true
var playerInSafeZone : bool = false
var boss: bool = true

func _ready() -> void:
	if get_tree().get_node_count_in_group("Enemy") > 0:
		boss = false
		healthBar = $"../../../UI/BossUI/VBoxContainer/Healths/MiniBoss/HealthBar"
		healthVal = $"../../../UI/BossUI/VBoxContainer/Healths/MiniBoss/HealthVal"
		bossTitle = $"../../../UI/BossUI/VBoxContainer/BossTitle"
	else:
		boss = true
		bossTitle.show()
		bossTitle.text = "Wolf"
	health_changed.connect(healthBar._set_health)
	healthBar.initHealth(stats.health)
	healthBar.show()
	healthVal.show()
	SignalBus.applyBleed.connect(bleed)
	add_to_group("Enemy")
	await get_tree().create_timer(1.4).timeout
	howl = false
	
func _physics_process(_delta: float) -> void:
	handler()

func handler() -> void:
	if dead: handleDeath()
	else:
		if repositioning: handleRepostioning()
		elif !howl: handleCombatMovement()
	
	updateAnimations()
	move_and_slide()
	
func handleCombatMovement() -> void:
	#Handle movement and combat if not attacking or repositioning
	if attackTimer.is_stopped() and !playerInSafeZone:
		distance = global_position.distance_to(player.global_position)
		direction = (player.global_position - global_position).normalized()
		if distance > 65: #Chase the player
			velocity = direction * stats.speed
			recentHit = false
		elif distance <= 65: #Attack the player
			attackTimer.start()
			attacking = true
			#If already lunged and still in attack phase -> stationary attack
			if !recentHit: recentHit = true
			elif recentHit: 
				velocity = Vector2.ZERO
				direction = (player.global_position - global_position).normalized()

#Make sure wolf reaches position before redirecting back to player
func handleRepostioning() -> void:
	distance = global_position.distance_to(targetPosition)
	if distance > 30:
		velocity = direction * stats.speed * 1.5
	else:
		repositioning = false

func handleDeath() -> void:
	velocity = Vector2.ZERO
	# Optional: Delay before removal
	await get_tree().create_timer(2).timeout
	healthBar.queue_free()
	bossTitle.hide()
	healthVal.hide()
	remove_from_group("Enemy")
	queue_free()
	if boss:
		SignalBus.bossDefeated.emit()
		PlayerData.addMarks(6)
		PlayerData.addTreats(2)
	set_process(false)

func updateAnimations() -> void:
	if direction != Vector2.ZERO:
		cardinal_direction = direction
	animationTree.set("parameters/Chase/blend_position", cardinal_direction)
	animationTree.set("parameters/Attack/blend_position", cardinal_direction)
	animationTree.set("parameters/Death/blend_position", cardinal_direction)
	
func bleed() -> void:
	$BleedTimer.start()
	while !$BleedTimer.is_stopped():
		DamageManager.applyBleed(self)
		player.playerManager.abilitiesManager.lifeSteal(self)
		health_changed.emit(stats.health)
		hit_flash.play("hitFlash")
		await get_tree().create_timer(1).timeout #Proc bleed every second
		if stats.health <= 0:
			dead = true

func _on_attack_timer_timeout() -> void:
	attacking = false

func _on_safe_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !repositioning:
		playerInSafeZone = true
		if attacking:
			await attackTimer.timeout
			if playerInSafeZone:
				reposition()
		else:
			reposition()

func _on_safe_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerInSafeZone = false

#Helper Functions
func reposition() -> void:
	var can_move_left := not ray_cast_left.is_colliding()
	var can_move_right := not ray_cast_right.is_colliding()
	var side := 1
	
	if can_move_left and !can_move_right: side = -1
	elif !can_move_left and can_move_right: side = 1
	elif can_move_left and can_move_right: side = -1

	var offset := Vector2(1 * side, 1).normalized() * 130
	targetPosition = global_position + offset
	direction = (targetPosition - global_position).normalized()
	distance = global_position.distance_to(targetPosition)
	repositioning = true
