class_name Player  extends CharacterBody2D

signal healthChange(newHealth)

@onready var healthBar: ProgressBar = $"../HUD/CanvasLayer/PlayerHud/HealthBar"
@onready var animatedPlayer: AnimatedSprite2D = $AnimatedSprite2D
@onready var stateMachine: StateMachine = $StateMachine
@onready var stats: StatsComponent = $StatsComponent
@onready var hurtbox: Hurtbox = $HurtboxComponent
@onready var damage_number_origin: Node2D = $DamageNumberOrigin

var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var directionMap = {
		Vector2(0, 1): "Down",
		Vector2(0, -1): "Up",
		Vector2(1, 0): "Right",
		Vector2(-1, 0): "Left",
		Vector2(1, 1).normalized(): "DownRight",
		Vector2(-1, 1).normalized(): "DownLeft",
		Vector2(1, -1).normalized(): "UpRight",
		Vector2(-1, -1).normalized(): "UpLeft"
	}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stateMachine.Initialize(self)
	stats.initialize(100, 100, 20, 80, 1.15)
	healthBar.initHealth(stats.health)
	healthChange.connect(healthBar._set_health)

func _physics_process(_delta: float) -> void:
	direction = Vector2(
		Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	).normalized()
	move_and_slide()
	

func setDirection():
	if direction == Vector2.ZERO:
		return false
		
	var closest_direction = Vector2.ZERO
	var min_angle = 120

	for dir in directionMap.keys():
		var angle_diff = rad_to_deg(direction.angle_to(dir))
		if abs(angle_diff) < min_angle:
			min_angle = abs(angle_diff)
			closest_direction = dir

	if closest_direction == cardinal_direction:
		return false

	cardinal_direction = closest_direction
	return true


func updateAnimation(state: String):
	animatedPlayer.play(state + animationDirection())

func animationDirection():
	return directionMap.get(cardinal_direction, "Down")
	
func died():
	if stats.health <= 0:
		get_tree().reload_current_scene()

func _on_hurtbox_component_damaged_recieved(damage: int) -> void:
	stats.health -= damage
	healthChange.emit(stats.health)
	DamageNumbers.displayNumbers(damage, damage_number_origin.global_position, false)
	pass # Replace with function body.
