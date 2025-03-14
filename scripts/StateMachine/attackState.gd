class_name AttackState extends State

@onready var chase: ChaseState = $"../Chase"
@export var stats: StatsComponent

var player: Node2D
var attackFinished: bool = false

func _ready() -> void:
	stats.attackTimer.wait_time = stats.attackSpeed
	stats.attackTimer.one_shot = true
	add_child(stats.attackTimer)
	stats.attackTimer.start()

func Enter():
	stats.attackTimer.wait_time = stats.attackSpeed
	if stats.attackTimer.time_left > 0:
		return  # Prevent attacking if cooldown is still active
		
	if stats.attackTimer.is_stopped():
		stats.attackTimer.start()
	if get_entity() is badgerBoss:
		get_entity().velocity = Vector2.ZERO
		
	get_entity().setDirection()
	get_entity().updateAnimation("Attack")
	pass
	
func Exit():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process(_delta: float) -> State:
#	Get Player reference and distance b/w player and boss
	player = get_tree().get_first_node_in_group("Player")
	var distance = get_entity().global_position.distance_to(player.global_position)
#	# Wait for attack animation + cooldown before switching states
	if stats.attackTimer.is_stopped():
		if distance > stats.attackRange:
			return chase
		get_entity().direction = (player.global_position - get_entity().global_position).normalized()
		get_entity().velocity = Vector2.ZERO
		# Restart attack if player is still in range
		Enter()
	
	return null
