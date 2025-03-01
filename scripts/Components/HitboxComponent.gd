class_name Hitbox extends Area2D

@export var stats: StatsComponent
var damage: int = 100

func _ready() -> void:
	damage = stats.damage
