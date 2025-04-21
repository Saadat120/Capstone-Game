class_name wolfAlpha extends CharacterBody2D

#References
@onready var healthBar: ProgressBar = $"BossUI/HUD/HealthBar"
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

func _ready() -> void:
	stats.initialize(1500, 40, 90, 1.2, 60)
	SignalBus.enemyHealthChanged.connect(healthBar._set_health)
	healthBar.initHealth(stats.health)
	healthBar.visible = true
	add_to_group("Enemy")
	set_physics_process(false)
	await get_tree().create_timer(1.4).timeout
	howl = false
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	handler()

func handler() -> void:
	if dead:
		handleDeath()
	else:
		if repositioning: handleRepostioning()
		else: handleCombatMovement()
	
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
		
func handleDeath() -> void:
	velocity = Vector2.ZERO
	# Optional: Delay before removal
	await get_tree().create_timer(2).timeout
	healthBar.queue_free()
	get_tree().get_first_node_in_group("Enemy").remove_from_group("Enemy")
	queue_free()
	SignalBus.bossDefeated.emit()
	set_process(false)

func handleSummons() -> void:
	pass

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
	velocity = direction * stats.speed * 1.5
	repositioning = true
