class_name BurrowState extends State

@onready var attack: State = $"../Attack"
@onready var chase: ChaseState = $"../Chase"

var speed: float
@export var attackRange = 55
var player: Node2D

#What happens when wolf Boss enters this state
func Enter() -> void:
	if get_entity():
		player = get_tree().get_first_node_in_group("Player")
		get_entity().setDirection()
		get_entity().updateAnimation("Burrow")
		await get_tree().create_timer(2.5).timeout 
		speed = get_entity().stats.speed * 2.25
		attackRange = get_entity().stats.attackRange
	pass

#What happens when player exit this state
func Exit()  -> void:
	pass

func Process(_delta: float) -> State:
	if get_entity() and player:
		var distance = get_entity().global_position.distance_to(player.global_position)
		#Transition to attack state
		if distance > 30:
			get_entity().direction = (player.global_position - get_entity().global_position).normalized()
			get_entity().velocity = get_entity().direction * speed
			get_entity().setDirection()
			get_entity().updateAnimation("BurrowMove")
		else:
			get_entity().velocity = Vector2.ZERO
			get_entity().setDirection()
			get_entity().updateAnimation("Unburrow")
			#await get_entity().animationPlayer.animation_finished
			return attack
	return null
