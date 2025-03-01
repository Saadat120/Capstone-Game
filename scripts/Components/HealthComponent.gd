class_name HealthComponent extends Node2D

@export var maxHealth:= 100.0
var health: float

func _ready():
	health = maxHealth
	
func damage(attack: Attack):
	health -= attack.attackDamage
	health = max(health, 0)
	if health <= 0:
		get_parent().queue_free()
	
