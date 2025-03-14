class_name badgerBoss extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var hit_flash: AnimationPlayer = $HitFlash
@onready var stateMachine: StateMachine = $StateMachine
@onready var healthBar: ProgressBar = $"BossUI/HUD/HealthBar"
@onready var stats: StatsComponent = $StatsComponent
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
	
	SignalBus.enemyHealthChanged.connect(healthBar._set_health)
	healthBar.initHealth(stats.health)
	healthBar.visible = true
	aggro = true
	
	stateMachine.changeState(stateMachine.get_node("Chase"))
	stateMachine.Initialize()
func _physics_process(_delta: float) -> void:
	move_and_slide()
	die()

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
		updateAnimation("Burrow")
		await get_tree().create_timer(2.6).timeout
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
