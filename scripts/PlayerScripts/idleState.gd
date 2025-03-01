class_name IdleState extends State

@onready var walk: State = $"../Walk"
@onready var attack: State = $"../Attack"

#What happens when wolf Boss enters this state
func Enter() -> void:
	entity.updateAnimation("idle")
	pass

#What happens when player exit this state
func Exit()  -> void:
	pass

func Process(_delta: float) -> State:
	if entity.direction != Vector2.ZERO:
		return walk
	if Input.is_action_just_pressed("space"):
		return attack
	entity.velocity = Vector2.ZERO
	return null
	
#What happens with input events in this state
func Physics(_delta: float) -> State:
	return null
	
#What happens with input events in this state
func handleInput(_event: InputEvent) -> State:
	return null
