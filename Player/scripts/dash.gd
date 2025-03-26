extends Node2D

@onready var timer: Timer = $Timer
@onready var cooldown: Timer = $Cooldown

	
func startDash(duration: float) -> void:
	timer.wait_time = duration
	timer.start()

func isDashing() -> bool:
	return !timer.is_stopped()
