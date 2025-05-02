class_name badgerBoss extends CharacterBody2D

signal health_changed(new_health: int)

#References
@onready var healthBar: ProgressBar = $"../UI/BossUI/VBoxContainer/Healths/Boss/HealthBar"
@onready var healthVal: Label = $"../UI/BossUI/VBoxContainer//Healths/Boss/HealthVal"
@onready var bossTitle: Label = $"../UI/BossUI/VBoxContainer/BossTitle"
@onready var animationTree: AnimationTree = $AnimationTree
@onready var stats: StatsComponent = $StatsComponent
@onready var hit_flash: AnimationPlayer = $HitFlash
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin
@onready var attackTimer: Timer = $AttackTimer
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

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
var burrow : bool = false
func _ready() -> void:
	health_changed.connect(healthBar._set_health)
	healthBar.initHealth(stats.health)
	healthBar.show()
	bossTitle.text = "Badger"
	bossTitle.show()
	healthVal.show()
	add_to_group("Enemy")

func _physics_process(_delta: float) -> void:
	handler()

func handler() -> void:
	if dead:
		handleDeath()
	else:
		if !burrow:
			handleCombatMovement()
		else: handleBurrow()
	updateAnimations()
	move_and_slide()

func handleCombatMovement() -> void:
	#Handle movement and combat if not attacking or repositioning
	if attackTimer.is_stopped():
		distance = global_position.distance_to(player.global_position)
		direction = (player.global_position - global_position).normalized()
		if distance > 70: #Chase the player
			velocity = direction * stats.speed
			recentHit = false
			if distance > 150:
				burrow = true
				follow = false
		elif distance <= 70: #Attack the player
			attackTimer.start()
			attacking = true
			#If already lunged and still in attack phase -> stationary attack
			if !recentHit: recentHit = true
			elif recentHit: 
				velocity = Vector2.ZERO
				direction = (player.global_position - global_position).normalized()

func handleBurrow() -> void:
	if burrow and !follow:
		velocity = Vector2.ZERO
		await get_tree().create_timer(2.45).timeout
		follow = true
	elif burrow and follow:
		distance = global_position.distance_to(player.global_position)
		direction = (player.global_position - global_position).normalized()
		if distance > 30: #Chase the player
			velocity = direction * stats.speed * 2
		elif distance <= 30:
			burrow = false
			follow = false
			velocity = Vector2.ZERO
			await get_tree().create_timer(2.45).timeout
			follow = true

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
	animationTree.set("parameters/Burrow/blend_position", cardinal_direction)
	animationTree.set("parameters/burrowChase/blend_position", cardinal_direction)
	animationTree.set("parameters/Unburrow/blend_position", cardinal_direction)
	animationTree.set("parameters/Death/blend_position", cardinal_direction)

func delay() -> void:
	velocity = Vector2.ZERO
