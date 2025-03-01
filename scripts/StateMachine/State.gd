class_name State extends Node

var entity
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
