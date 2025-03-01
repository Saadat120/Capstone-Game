class_name PlayerAttackState extends State

@onready var idle: IdleState = $"../Idle"
@onready var walk: WalkState = $"../Walk"
@export var stats: StatsComponent
@onready var projectile = preload("res://scenes/Projectile.tscn")

var attackFinished: bool = false
var attackSpeed: float = 1
var attackTimer: Timer

func _ready() -> void:
	stats.attackTimer.wait_time = attackSpeed
	stats.attackTimer.one_shot = true
	add_child(stats.attackTimer)
	attackSpeed = stats.attackSpeed
	stats.attackTimer.wait_time = attackSpeed
	pass

func Enter():
	if stats.attackTimer.time_left > 0:
		return  # Prevent attacking if cooldown is still active

	if stats.attackTimer.is_stopped():
		stats.attackTimer.start()
	basicAttack()
	pass
	
func Exit():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process(_delta: float) -> State:
	return walk

func basicAttack():
	var instance = projectile.instantiate()
	instance.stats = entity.stats
	instance.position = entity.position
	instance.direction = entity.cardinal_direction.normalized()
	instance.projectileAttack("space")
	instance.rotation = instance.direction.angle()
	get_parent().add_child(instance)
