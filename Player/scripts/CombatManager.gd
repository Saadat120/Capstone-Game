class_name CombatManager extends Node

var attacks = {}

func _ready():
	# Define different attacks and store them
	attacks["basicAttack"] = Attack.new("basicAttack", 30, 0.4, 0, "")
	attacks["secondaryAttack"] = Attack.new("secondaryAttack", 5, 2.0, 3, "slow")
	attacks["specialAbility"] = Attack.new("specialAsbility", 20, 2.5, 0, "")
	
	#Add cooldowns for each attack to combat manager
	add_child(attacks["basicAttack"].cooldownTimer)
	add_child(attacks["secondaryAttack"].cooldownTimer)
	add_child(attacks["specialAbility"].cooldownTimer)


func performAttack(attackType: String):
	if attackType in attacks:
		attacks[attackType].execute_attack()
