class_name wolfAlpha extends CharacterBody2D

@onready var healthBar: ProgressBar = $"BossUI/HUD/HealthBar"
@onready var animationTree: AnimationTree = $AnimationTree
@onready var stats: StatsComponent = $StatsComponent
@onready var hit_flash: AnimationPlayer = $HitFlash
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin
@onready var attackTimer: Timer = $AttackTimer

var player: CharacterBody2D
var dead :bool = false
var follow: bool = false
var attacking: bool = false
var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var distance: float
var recentHit := false
func _ready() -> void:
	stats.initialize(1500, 40, 90, 1.2, 60)
	SignalBus.enemyHealthChanged.connect(healthBar._set_health)
	healthBar.initHealth(stats.health)
	print(healthBar.health)
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
		if distance > 80 and attackTimer.is_stopped():
			direction = (player.global_position - global_position).normalized()
			velocity = direction * stats.speed
			recentHit = false
		elif distance <= 80 and attackTimer.is_stopped():
			attackTimer.start()
			attacking = true
			if !recentHit: recentHit = true
			elif recentHit: 
				velocity = Vector2.ZERO
				direction = (player.global_position - global_position).normalized()
		if direction != Vector2.ZERO:
			cardinal_direction = direction
		animationTree.set("parameters/Chase/blend_position", cardinal_direction)
		animationTree.set("parameters/Attack/blend_position", cardinal_direction)
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
