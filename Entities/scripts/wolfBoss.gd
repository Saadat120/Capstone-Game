class_name wolfBoss  extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var hit_flash: AnimationPlayer = $HitFlash
@onready var stateMachine: StateMachine = $StateMachine
@onready var healthBar: ProgressBar = $"BossUI/HUD/HealthBar"
@onready var stats: StatsComponent = $StatsComponent
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin
@onready var attackTimer: Timer = $AttackTimer

var recentHit: bool = false
var dead := false
var aggro: bool = false
var cardinal_direction: Vector2 = Vector2(1, -1)
var direction : Vector2 = Vector2.ZERO

var wolfDirectionMap := {
	Vector2(1, 0): "E",
	Vector2(-1, 0): "W",
	Vector2(1, 1).normalized(): "SE",  # Southeast
	Vector2(-1, 1).normalized(): "SW", # Southwest
	Vector2(1, -1).normalized(): "NE", # Northeast
	Vector2(-1, -1).normalized(): "NW" # Northwest
}

func _ready() -> void:
	stats.initialize(700, 15, 45, 1.2, 80)
	SignalBus.enemyHealthChanged.connect(healthBar._set_health)
	healthBar.initHealth(stats.health)
	aggro = true
	healthBar.visible = true
	
	animationPlayer.play("Howl")
	await animationPlayer.animation_finished
	
	stateMachine.Initialize()
	stateMachine.changeState(stateMachine.get_node("Chase"))
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	die()

func updateAnimation(state: String) -> void:
	animationPlayer.play(state + animationDirection())

func animationDirection() -> String:
	return wolfDirectionMap.get(cardinal_direction, "NE")

func setDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
		
	var closest_direction := Vector2.ZERO
	var min_angle := 180

	for dir:Vector2 in wolfDirectionMap.keys():
		var angle_diff := rad_to_deg(direction.angle_to(dir))
		if abs(angle_diff) < min_angle:
			min_angle = abs(angle_diff)
			closest_direction = dir
			
	if closest_direction == cardinal_direction:
		return false

	cardinal_direction = closest_direction
	return true

func die() -> void:
	if dead == true:
		stateMachine = null
		velocity = Vector2.ZERO
		# Optional: Delay before removal
		setDirection()
		updateAnimation("Death")
		await get_tree().create_timer(1.5).timeout  
		healthBar.queue_free()
		queue_free()
		SignalBus.bossDefeated.emit()
