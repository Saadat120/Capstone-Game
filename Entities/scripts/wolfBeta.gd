class_name wolfBeta extends CharacterBody2D

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

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(_delta: float) -> void:
	handleMovement()
	die()

func handleMovement() -> void:
	if dead == false:
		distance = global_position.distance_to(player.global_position)
		if distance > 25 and attackTimer.is_stopped():
			direction = (player.global_position - global_position).normalized()
			velocity = direction * stats.speed
		elif distance <= 25 and attackTimer.is_stopped():
			direction = (player.global_position - global_position).normalized()
			attackTimer.start()
			attacking = true
		if direction != Vector2.ZERO:
			cardinal_direction = direction
			
		animationTree.set("parameters/Chase/blend_position", cardinal_direction)
		animationTree.set("parameters/Attack/blend_position", cardinal_direction)
		move_and_slide()
		velocity = Vector2.ZERO
	
func die() -> void:
	if dead == true:
		velocity = Vector2.ZERO
		animationTree.set("parameters/Death/blend_position", cardinal_direction)
		# Optional: Delay before removal
		await get_tree().create_timer(1.5).timeout
		queue_free()


func _on_attack_timer_timeout() -> void:
	attacking = false
