extends CharacterBody2D

@onready var animationTree: AnimationTree = $AnimationTree

var player: CharacterBody2D
var follow: bool = false
var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var distance: float

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
func _physics_process(_delta: float) -> void:
	handleMovement()

func handleMovement() -> void:
	distance = global_position.distance_to(player.global_position)
	
	if distance > 60:
		follow = true
		direction = (player.global_position - global_position).normalized()
		velocity = direction * 40
	elif distance > 30 and follow:
		direction = (player.global_position - global_position).normalized()
	else:
		follow = false
		velocity = Vector2.ZERO
	
	if direction != Vector2.ZERO:
		cardinal_direction = direction
	
	animationTree.set("parameters/Idle/blend_position", cardinal_direction)
	animationTree.set("parameters/Follow/blend_position", cardinal_direction)
	move_and_slide()
