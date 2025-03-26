class_name State extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#What happens when player enters this state
func Enter() -> void:
	pass

#What happens when player exit this state
func Exit()  -> void:
	pass

func Process(_delta: float) -> State:
	return null
	
#What happens with input events in this state
func Physics(_delta: float) -> State:
	return null
	
#What happens with input events in this state
func handleInput(_event: InputEvent) -> State:
	return null

# Helper function to access entity through StateMachine
func get_entity() -> CharacterBody2D:
	return get_parent().entity if get_parent() is StateMachine else null
