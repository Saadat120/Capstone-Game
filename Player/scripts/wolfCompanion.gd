extends CharacterBody2D

@onready var animationTree: AnimationTree = $AnimationTree

var player: CharacterBody2D
var enemy: CharacterBody2D
var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var distance: float
var attacking: bool = false
var chaseDown := false
var follow := false
var speed : float

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	enemy = get_tree().get_first_node_in_group("Enemy")
	SignalBus.applyBleed.connect(target)
	
func _physics_process(_delta: float) -> void:
	if player.playerManager.companion == "Wolf":
		handleMovement()

func handleMovement() -> void:
	if !chaseDown:
		distance = global_position.distance_to(player.global_position)
		direction = (player.global_position - global_position).normalized()
		speed = player.playerManager.getSpeed()
		if distance > 60:
			follow = true
			velocity = direction * player.playerManager.getSpeed()
		elif distance > 30:
			follow = true
			velocity = direction * 50
		else:
			follow = false
			velocity = Vector2.ZERO
	else:
		if !enemy: return
		distance = global_position.distance_to(enemy.global_position)
		direction = (enemy.global_position - global_position).normalized()
		if distance > 20:
			velocity = direction * 120
		else:
			velocity = Vector2.ZERO
			attacking = true
			$AttackTimer.start()
	
	if direction != Vector2.ZERO:
		cardinal_direction = direction
	
	animationTree.set("parameters/Idle/blend_position", cardinal_direction)
	animationTree.set("parameters/Attack/blend_position", cardinal_direction)
	animationTree.set("parameters/Follow/blend_position", cardinal_direction)
	move_and_slide()

func target() -> void:
	chaseDown = true

func _on_attack_timer_timeout() -> void:
	attacking = false
	chaseDown = false
