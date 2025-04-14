class_name stagBoss extends CharacterBody2D

@onready var hit_flash: AnimationPlayer = $HitFlash
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin
var struck := false

func _on_hurtbox_area_entered(hitbox: Area2D) -> void:
	if hitbox is Hitbox:
		hit_flash.play("hitFlash")
		DamageNumbers.displayNumbers(30, damage_numbers_origin.global_position, false)
		struck = true
