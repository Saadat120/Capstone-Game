extends Node2D

@onready var timer: Timer = $Timer
@onready var cooldown: Timer = $Cooldown

	
func startDash(duration):
	timer.wait_time = duration
	timer.start()

func isDashing():
	return !timer.is_stopped()
