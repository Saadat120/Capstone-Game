class_name wolfAlpha extends CharacterBody2D

signal health_changed(new_health: int)

#References
@onready var healthBar: ProgressBar = $"../../UI/BossUI/VBoxContainer/Healths/Boss/HealthBar"
@onready var healthVal: Label = $"../../UI/BossUI/VBoxContainer//Healths/Boss/HealthVal"
@onready var bossTitle: Label = $"../../UI/BossUI/VBoxContainer/BossTitle"
@onready var animationTree: AnimationTree = $AnimationTree
@onready var stats: StatsComponent = $StatsComponent
@onready var hit_flash: AnimationPlayer = $HitFlash
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin
@onready var attackTimer: Timer = $AttackTimer
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
const EnemyScene := preload("res://Entities/scenes/WolfBeta.tscn")
const largeMinionscene := preload("res://Entities/scenes/WolfBoss.tscn")

#Movement & positioning
var direction : Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.DOWN
var distance: float
var targetPosition: Vector2
var repositioning := false
var howl_spots : Array

#Combat & State Flags
var dead :bool = false
var follow: bool = false
var attacking: bool = false
var recentHit := false
var howl: bool = true
var playerInSafeZone : bool = false
var phase := 1
var summoning := false
var summonedWolves := 0

func _ready() -> void:
	health_changed.connect(healthBar._set_health)
	healthBar.initHealth(stats.health)
	healthBar.show()
	bossTitle.text = "Wolf Alpha"
	bossTitle.show()
	healthVal.show()
	add_to_group("Enemy")
	SignalBus.applyBleed.connect(bleed)
	await get_tree().create_timer(1.4).timeout
	howl = false

func _physics_process(_delta: float) -> void:
	handler()

func handler() -> void:
	if dead:
		handleDeath()
	else:
		if repositioning and !howl and !summoning: handleRepostioning()
		else:
			if phase == 1 and stats.health <= stats.maxHealth *  (2.0/3.0) and attackTimer.is_stopped():
				handleSummons()
			elif  phase == 2 and stats.health <= stats.maxHealth *  (1.0/3.0) and attackTimer.is_stopped():
				handleSummons()
			elif !howl:
				handleCombatMovement()
			
	
	updateAnimations()
	move_and_slide()
	
func handleCombatMovement() -> void:
	#Handle movement and combat if not attacking or repositioning
	if attackTimer.is_stopped() and !playerInSafeZone:
		distance = global_position.distance_to(player.global_position)
		direction = (player.global_position - global_position).normalized()
		if distance > 80: #Chase the player
			velocity = direction * stats.speed
			recentHit = false
		elif distance <= 80: #Attack the player
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

func handleSummons() -> void:
	if !summoning: #calculate howl spot once and then go there
		getSummonSpot()
	distance = global_position.distance_to(targetPosition)
	if distance > 30:
		velocity = direction * stats.speed * 1.5
	else:
		velocity = Vector2.ZERO
		direction = (player.global_position - global_position).normalized()
		howl = true
		if phase == 1:
			for spot in howl_spots:
				if spot.global_position.distance_to(global_position) < 30:
					continue  # skip the boss's location
				if summonedWolves >= 3:
					break
				spot.add_child(EnemyScene.instantiate())
				summonedWolves += 1
					
			if summonedWolves >= 3:
				var enemy_count := get_tree().get_nodes_in_group("Enemy").size()
				if enemy_count <= 1: # only boss is left
					summoning = false
					howl = false
					phase = 2
					summonedWolves = 0
		elif phase == 2:
			for spot in howl_spots:
				if spot.global_position.distance_to(global_position) < 30:
					continue  # skip the boss's location
				if summonedWolves >= 1:
					break
				spot.add_child(largeMinionscene.instantiate())
				summonedWolves += 1
					
			if summonedWolves >= 1:
				var enemy_count := get_tree().get_nodes_in_group("Enemy").size()
				if enemy_count <= 1: # only boss is left
					summoning = false
					howl = false
					phase = 3

func handleDeath() -> void:
	velocity = Vector2.ZERO
	# Optional: Delay before removal
	await get_tree().create_timer(2).timeout
	healthBar.queue_free()
	healthVal.hide()
	bossTitle.hide()
	remove_from_group("Enemy")
	queue_free()
	SignalBus.bossDefeated.emit()
	set_process(false)

func updateAnimations() -> void:
	if direction != Vector2.ZERO:
		cardinal_direction = direction
	animationTree.set("parameters/Chase/blend_position", cardinal_direction)
	animationTree.set("parameters/Attack/blend_position", cardinal_direction)
	animationTree.set( "parameters/Howl/blend_position", cardinal_direction)
	animationTree.set("parameters/Death/blend_position", cardinal_direction)
	
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

func getSummonSpot() -> void:
	var max_distance := -1.0
	howl_spots = get_tree().get_nodes_in_group("SummonSpots")
	
	for spot: Node2D in howl_spots:
		if spot is Node2D:
			var dist := global_position.distance_to(spot.global_position)
			if dist > max_distance:
				max_distance = dist
				targetPosition = spot.global_position
	
	direction = (targetPosition - global_position).normalized()
	summoning = true

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
