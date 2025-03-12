class_name StateMachine extends Node

var states: Array[State]
var prevState: State
var currentState: State
@export var entity: CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if entity.dead != true:
		changeState(currentState.Process(delta))
	
func _physics_process(delta: float) -> void:
	changeState(currentState.Physics(delta))
	

func _unhandled_input(event: InputEvent) -> void:
	changeState(currentState.handleInput(event))

func Initialize() -> void:
	states = []
	for c in get_children():
		if c is State:
			states.append(c)
	
	if states.size() > 0:
		changeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT
	
func changeState(newState: State) -> void:
	if newState == null || newState == currentState:
		return
	
	if currentState:
		currentState.Exit()
	
	prevState = currentState
	currentState = newState
	
	if currentState:
		currentState.Enter()
