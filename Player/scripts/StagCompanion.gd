extends CharacterBody2D

@onready var animationTree: AnimationTree = $AnimationTree

var player: CharacterBody2D
var follow: bool = false
var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var distance: float
var speed : = 40

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
func _physics_process(_delta: float) -> void:
	if player.playerManager.companion == "Stag":
		handleMovement()

func handleMovement() -> void:
	distance = global_position.distance_to(player.global_position)
	
	if distance > 60:
		follow = true
		direction = (player.global_position - global_position).normalized()
		velocity = direction * player.playerManager.speed
	elif distance > 30:
		follow = true
		direction = (player.global_position - global_position).normalized()
		velocity = direction * 50
	else:
		follow = false
		velocity = Vector2.ZERO
	
	if direction != Vector2.ZERO:
		cardinal_direction = direction
	
	animationTree.set("parameters/Idle/blend_position", cardinal_direction)
	animationTree.set("parameters/Follow/blend_position", cardinal_direction)
	move_and_slide()
