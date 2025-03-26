class_name SummonState extends State

@onready var attack: State = $"../Attack"

var speed: float
@export var attackRange := 55
var player: Node2D

#What happens when wolf Boss enters this state
func Enter() -> void:
	if get_entity():
		player = get_tree().get_first_node_in_group("player")
		speed = get_entity().stats.speed
	pass

#What happens when player exit this state
func Exit()  -> void:
	pass

func Process(_delta: float) -> State:
		
	if get_entity() and player:
		var distance := get_entity().global_position.distance_to(player.global_position)
		#Transition to attack state
		if distance < attackRange:
			return attack

		if get_entity().aggro == true:
			# Move towards player
			get_entity().direction = (player.global_position - get_entity().global_position).normalized()
			get_entity().velocity = get_entity().direction * speed
			get_entity().setDirection()
			get_entity().updateAnimation("wolfRun")
	return null
