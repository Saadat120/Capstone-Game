class_name AttackState extends State

@onready var chase: ChaseState = $"../Chase"
@onready var idle: BossIdleState = $"../Idle"

var player: Node2D
var attackFinished: bool = false
var attackSpeed: float =  1
var attackTimer: Timer

func _ready() -> void:
	attackTimer = Timer.new()
	attackTimer.wait_time = attackSpeed
	attackTimer.one_shot = true
	add_child(attackTimer)
	attackTimer.start()

func Enter():
	attackSpeed = entity.stats.attackSpeed
	attackTimer.wait_time = attackSpeed
	if attackTimer.time_left > 0:
		return  # Prevent attacking if cooldown is still active
		
	if attackTimer.is_stopped():
		attackTimer.start()
	print(attackSpeed)
	entity.setDirection()
	entity.updateAnimation("Attack")
	pass
	
func Exit():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process(_delta: float) -> State:
	if not entity.aggro:
		return idle
		
#	Get Player reference and distance b/w player and boss
	player = get_tree().get_first_node_in_group("player")
	var distance = entity.global_position.distance_to(player.global_position)
#	# Wait for attack animation + cooldown before switching states
	if attackTimer.is_stopped():
		if distance > 55:
			return chase
		entity.direction = (player.global_position - entity.global_position).normalized()
		entity.velocity = Vector2.ZERO
		# Restart attack if player is still in range
		Enter()
	
	return null
