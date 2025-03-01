class_name StatsComponent extends Node

@export var maxHealth: int = 100
@export var maxAbility: int = 100

@export var health: int = 100
@export var ability: int = 100
@export var damage: int = 20

@export var defence: int = 5
@export var speed: float = 75
@export var attackSpeed: float = 1
var attackTimer: Timer = Timer.new()
@export var buffs: Dictionary = {
	"strength": 0, #Increases attack power
	"agility": 0 #Increases speed
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func initialize(_maxHealth, _maxAbility, _damage, _speed,  _attackSpeed):
	maxHealth = _maxHealth
	maxAbility = _maxAbility
	
	health = maxHealth
	ability = maxAbility
	damage = _damage
	attackSpeed = _attackSpeed
	speed = _speed
	
func damaged(_damage: int):
	if health >= _damage:
		health -= _damage
		print(health)
