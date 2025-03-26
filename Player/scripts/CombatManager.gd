class_name CombatManager extends Node

@onready var skill: Skill = $"../../PlayerUI/HUD/Skills/Skill"
@onready var skill2: Skill = $"../../PlayerUI/HUD/Skills/Skill2"
@onready var skill3: Skill = $"../../PlayerUI/HUD/Skills/Skill3"

var initialized := false
var attacks := {}

func _ready() -> void:
	# Define different attacks and store them
	attacks["basicAttack"] = Attack.new("basicAttack", 30, 0.4)
	attacks["Dash"] = Attack.new("Dash", 0, 2.0)
	attacks["secondaryAttack"] = Attack.new("secondaryAttack", 5, 2.0)
	attacks["specialAbility"] = Attack.new("specialAsbility", 20, 2.5)
	
	#Add cooldowns for each attack to combat manager
	add_child(attacks["basicAttack"].cooldownTimer)
	add_child(attacks["Dash"].cooldownTimer)
	add_child(attacks["secondaryAttack"].cooldownTimer)
	add_child(attacks["specialAbility"].cooldownTimer)

func _process(_delta: float) -> void:
	connectSkill()
	set_process(false)
	
func connectSkill() -> void:
	skill.initialize(attacks["basicAttack"].cooldown, "Space")
	skill2.initialize(attacks["Dash"].cooldown, "Shift")

func performAttack(attackType: String) -> void:
	if attackType in attacks:
		attacks[attackType].execute_attack()
