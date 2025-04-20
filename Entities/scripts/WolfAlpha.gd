class_name wolfAlpha extends CharacterBody2D

@onready var healthBar: ProgressBar = $"BossUI/HUD/HealthBar"
@onready var animationTree: AnimationTree = $AnimationTree
@onready var stats: StatsComponent = $StatsComponent
@onready var hit_flash: AnimationPlayer = $HitFlash
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin
@onready var attackTimer: Timer = $AttackTimer
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft

var player: CharacterBody2D
var dead :bool = false
var follow: bool = false
var attacking: bool = false
var howling: bool = false

var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var redirection : Vector2 = Vector2.ZERO
var distance: float
var recentHit := false
var playerInSafeZone : bool = false

func _ready() -> void:
	stats.initialize(1500, 40, 90, 1.2, 60)
	SignalBus.enemyHealthChanged.connect(healthBar._set_health)
	healthBar.initHealth(stats.health)
	healthBar.visible = true
	add_to_group("Enemy")
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(_delta: float) -> void:
	handler()

func handler() -> void:
	handleMovement()
	die()
	
func handleMovement() -> void:
	if dead == false:
		distance = global_position.distance_to(player.global_position)
		if attackTimer.is_stopped() and !playerInSafeZone:
			direction = (player.global_position - global_position).normalized()
			if distance > 80:
				velocity = direction * stats.speed
				recentHit = false
			elif distance <= 80:
				attackTimer.start()
				attacking = true
				if !recentHit: recentHit = true
				elif recentHit: 
					velocity = Vector2.ZERO
					direction = (player.global_position - global_position).normalized()
		if !playerInSafeZone:
			if direction != Vector2.ZERO: cardinal_direction = direction
		else:
			if redirection != Vector2.ZERO: cardinal_direction = redirection
		animationTree.set("parameters/Chase/blend_position", cardinal_direction)
		animationTree.set("parameters/Attack/blend_position", cardinal_direction)
		animationTree.set( "parameters/Howl/blend_position", cardinal_direction)
		move_and_slide()
	
func die() -> void:
	if dead == true:
		velocity = Vector2.ZERO
		animationTree.set("parameters/Death/blend_position", cardinal_direction)
		# Optional: Delay before removal
		await get_tree().create_timer(4).timeout
		healthBar.queue_free()
		get_tree().get_first_node_in_group("Enemy").remove_from_group("Enemy")
		queue_free()
		SignalBus.bossDefeated.emit()
		set_process(false)

func _on_attack_timer_timeout() -> void:
	attacking = false

func _on_safe_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerInSafeZone = true
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

	var offset := Vector2(1 * side, 1).normalized() * 170
	var target_position := global_position + offset

	redirection = (target_position - global_position).normalized()
	velocity = redirection * stats.speed
