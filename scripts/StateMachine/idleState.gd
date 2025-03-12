class_name BossIdleState extends State

@onready var attack: AttackState = $"../Attack"
@onready var chase: ChaseState = $"../Chase"
var speed: float
var idlePosition: Vector2 = Vector2(966, 1053)
var arrived: bool

#What happens when wolf Boss enters this state
func Enter() -> void:
	speed = get_entity().stats.speed/3
	arrived = false
	pass

#What happens when player exit this state
func Exit()  -> void:
	pass

func Process(_delta: float) -> State:
	if get_entity().aggro:
		return chase
	if not arrived:
		if get_entity().global_position.distance_to(idlePosition) > 5:
			get_entity().velocity = (idlePosition - get_entity().global_position).normalized() * speed
		else:
			get_entity().velocity = Vector2.ZERO
			arrived = true
			get_entity().updateAnimation("idle")  # Ensure it stays idle

	return null


#What happens with input events in this state
func Physics(_delta: float) -> State:
	return null
	
#What happens with input events in this state
func handleInput(_event: InputEvent) -> State:
	return null
