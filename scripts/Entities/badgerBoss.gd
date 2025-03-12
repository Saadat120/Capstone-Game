class_name badgerBoss extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var hit_flash: AnimationPlayer = $HitFlash
@onready var stateMachine: StateMachine = $StateMachine
@onready var healthBar: ProgressBar = $"BossUI/HUD/HealthBar"
@export var stats: StatsComponent
@onready var badgerArena: Area2D = $"../Map/BadgerArena"
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin
var dead = false
var aggro: bool = false
var attacking: bool = false

var cardinal_direction: Vector2 = Vector2(1, -1)
var direction : Vector2 = Vector2.ZERO
var badgerDirectionMap = {
	Vector2(1, 0): "E",
	Vector2(-1, 0): "W",
	Vector2(1, 1).normalized(): "SE",  # Southeast
	Vector2(-1, 1).normalized(): "SW", # Southwest
	Vector2(1, -1).normalized(): "NE", # Northeast
	Vector2(-1, -1).normalized(): "NW" # Northwest
}

func _ready():
	stateMachine.Initialize()
	stats.initialize(700, 200, 10, 1, 1.15, 40)
	SignalBus.enemyHealthChanged.connect(healthBar._set_health)
	healthBar.visible = false
	badgerArena.body_entered.connect(_on_body_entered)
	badgerArena.body_exited.connect(_on_body_exited)
	pass
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	die()
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):  # Ensure the player is in the "player" group
		healthBar.initHealth(stats.health)
		aggro = true
		healthBar.visible = true
		stateMachine.changeState(stateMachine.get_node("Chase"))  # Change to follow state

func _on_body_exited(body):
	if body.is_in_group("player"):
		aggro = false
		healthBar.visible = false
		stateMachine.changeState(stateMachine.get_node("Idle"))  # Change to idle state

func updateAnimation(state: String):
	animationPlayer.play(state + animationDirection())

func animationDirection():
	return badgerDirectionMap.get(cardinal_direction, "NE")

func setDirection():
	if direction == Vector2.ZERO:
		return false
		
	var closest_direction = Vector2.ZERO
	var min_angle = 180

	for dir in badgerDirectionMap.keys():
		var angle_diff = rad_to_deg(direction.angle_to(dir))
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
		healthBar.visible = false
		queue_free()

func _on_hurtbox_area_entered(hitbox: Area2D) -> void:
	if hitbox is Hitbox:
		DamageManager.applyDamage(hitbox.get_parent(), self)
		SignalBus.enemyHealthChanged.emit(stats.health)
		hit_flash.play("hitFlash")
		if stats.health <= 0:
			dead = true
	pass # Replace with function body.
