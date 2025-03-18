extends CharacterBody2D

@onready var animationTree: AnimationTree = $AnimationTree
@onready var stack1: ProgressBar = $CanvasLayer/HBoxContainer/Stack1
@onready var stack2: ProgressBar = $CanvasLayer/HBoxContainer/Stack2
@onready var stack3: ProgressBar = $CanvasLayer/HBoxContainer/Stack3
var stacks: Array

var player: CharacterBody2D
var follow: bool = false
var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var distance: float
const maxStacks = 3
var stackCount = 0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	SignalBus.passiveStack.connect(handleStacks)
	stack1.visible = false
	stack2.visible = false
	stack3.visible = false
	stacks.append(stack1)
	stacks.append(stack2)
	stacks.append(stack3)
	
func _physics_process(_delta: float) -> void:
	handleMovement()

func handleMovement():
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

	
func handleStacks():
	if stackCount < maxStacks:
		stacks[stackCount].visible = true
		stackCount += 1
		return

	if stackCount >= maxStacks:
		stackCount = 0
		for stack in stacks:
			stack.visible = false
