class_name Hurtbox extends Area2D

signal damagedRecieved(damage: int)

func _ready() -> void:
	connect("area_entered", on_area_entered)
	
func on_area_entered(hitbox: Area2D) -> void:
	damagedRecieved.emit(hitbox.stats.damage)
	if hitbox is Projectile:
		hitbox.queue_free()
	
