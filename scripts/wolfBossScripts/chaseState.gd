class_name ChaseState extends State

@onready var attack: State = $"../Attack"
@onready var idle: BossIdleState = $"../Idle"

var speed: float
@export var attackRange = 55
var player: Node2D

#What happens when wolf Boss enters this state
func Enter() -> void:
	if entity:
		player = get_tree().get_first_node_in_group("player")
		speed = entity.stats.speed
	pass

#What happens when player exit this state
func Exit()  -> void:
	pass

func Process(_delta: float) -> State:
	if not entity.aggro:
		return idle
		
	if entity and player:
		var distance = entity.global_position.distance_to(player.global_position)
		#Transition to attack state
		if distance < attackRange:
			return attack

		if entity.aggro == true:
			# Move towards player
			entity.direction = (player.global_position - entity.global_position).normalized()
			entity.velocity = entity.direction * speed
			entity.setDirection()
			entity.updateAnimation("wolfRun")
	return null
