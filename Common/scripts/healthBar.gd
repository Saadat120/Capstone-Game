extends ProgressBar

@onready var damageBar: ProgressBar = $DamageBar
@export var timer: Timer
var health := 0: set = _set_health

func _set_health(newHealth: int) -> void:
	if damageBar == null:
		damageBar = get_node("DamageBar")
	var prevHealth := health
	health = min(max_value, newHealth)
	value = int(health)
		
	if health < prevHealth:
		timer.start()
	else:
		damageBar.value = health

func initHealth(_health: int) -> void:
	if damageBar == null:
		damageBar = get_node("DamageBar")
	max_value = _health
	health = _health
	damageBar.max_value = _health
	damageBar.value = _health
	custom_minimum_size = Vector2(GameState.healthBarLength,16)

func _on_timer_timeout() -> void:
	#Damage bar catches up to health bar
	damageBar.value = health
