extends ProgressBar

@onready var damageBar: ProgressBar = $DamageBar
@onready var timer: Timer = $Timer
var health = 0: set = _set_health

func _ready() -> void:
	pass
	
func _set_health(newHealth):
	if damageBar == null:
		damageBar = get_node("DamageBar")
	var prevHealth = health
	health = min(max_value, newHealth)
	value = health
	if health <= 0:
		queue_free()
		
	if health < prevHealth:
		timer.start()
	else:
		damageBar.value = health

func initHealth(_health):
	if damageBar == null:
		damageBar = get_node("DamageBar")
	health = _health
	max_value = health
	damageBar.max_value = health
	damageBar.value = health
	print(damageBar)


func _on_timer_timeout() -> void:
	#Damage bar catches up to health bar
	damageBar.value = health
