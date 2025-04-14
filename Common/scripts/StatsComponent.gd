class_name StatsComponent extends Node

@export var maxHealth: int = 100
@export var health: int = 100
@export var damage: int = 20

@export var defence: int = 5
@export var speed: float = 35
@export var attackSpeed: float = 1
@export var attackRange: float = 0
var attackTimer: Timer = Timer.new()
@export var attackCounter: int = 0
	
func initialize(_maxHealth: int, _damage: int, _speed: float,  _attackSpeed: float, _range: float) -> void:
	maxHealth = _maxHealth
	health = maxHealth
	damage = _damage
	attackSpeed = _attackSpeed
	speed = _speed
	attackRange = _range
