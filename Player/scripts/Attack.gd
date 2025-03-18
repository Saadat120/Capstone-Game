class_name Attack extends Node

var attackName: String
var cooldown: float
var damage: int
var isReady: bool = true
var cooldownTimer = Timer.new()
	
func _init(attackType: String, dmg: int, cd: float) -> void:
	attackName = attackType
	damage = dmg
	cooldown = cd
	cooldownTimer.wait_time = cooldown
	cooldownTimer.one_shot = true
	cooldownTimer.timeout.connect(_reset_cooldown)

func execute_attack():
	if !isReady:
		return
	isReady = false
	cooldownTimer.start()

func _reset_cooldown():
	isReady = true
