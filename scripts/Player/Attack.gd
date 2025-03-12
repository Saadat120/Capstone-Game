class_name Attack extends Node

var attackName: String
var cooldown: float
var damage: int
var stackThreshold: int
var currentStack: int = 0
var debuff: String
var isReady: bool = true
var cooldownTimer = Timer.new()
	
func _init(attackType: String, dmg: int, cd: float, stack_thresh: int, debuffType: String) -> void:
	attackName = attackType
	damage = dmg
	cooldown = cd
	stackThreshold = stack_thresh
	debuff = debuffType
	cooldownTimer.wait_time = cooldown
	cooldownTimer.one_shot = true
	cooldownTimer.timeout.connect(_reset_cooldown)

func execute_attack():
	if !isReady:
		return
	isReady = false
	cooldownTimer.start()
	
	# Apply stack-based debuff logic
	currentStack += 1
	if currentStack >= stackThreshold:
		#target.apply_debuff(debuff_type)
		currentStack = 0  # Reset stacks

func _reset_cooldown():
	isReady = true
