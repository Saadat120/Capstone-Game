class_name wolfBoss  extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var animationTree: AnimationTree = $AnimationTree
@onready var hit_flash: AnimationPlayer = $HitFlash
#@onready var stateMachine: StateMachine = $StateMachine
@onready var healthBar: ProgressBar = $"BossUI/HUD/HealthBar"
@onready var stats: StatsComponent = $StatsComponent
@onready var wolfArena: Area2D = $"../Map/WolfArena"
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin
@onready var attackTimer: Timer = $AttackTimer

var player: Node2D = null
var dead = false
var aggro: bool = false
var attacking: bool = false
var cardinal_direction: Vector2 = Vector2(1, -1)
var direction : Vector2 = Vector2.ZERO
var distance: float
var state: String = "chase"
var transition: bool = true

var wolfDirectionMap = {
	Vector2(1, 0): "E",
	Vector2(-1, 0): "W",
	Vector2(1, 1).normalized(): "SE",  # Southeast
	Vector2(-1, 1).normalized(): "SW", # Southwest
	Vector2(1, -1).normalized(): "NE", # Northeast
	Vector2(-1, -1).normalized(): "NW" # Northwest
}

func _ready():
	#stateMachine.Initialize()
	stats.initialize(700, 200, 10, 55, 1.2, 75)
	SignalBus.enemyHealthChanged.connect(healthBar._set_health)
	healthBar.initHealth(stats.health)
	aggro = true
	healthBar.visible = true
	pass
	
func _physics_process(_delta: float) -> void:
	#chase()
	if player:
		distance = global_position.distance_to(player.global_position)
	if player and !attacking and distance > stats.attackRange:
		direction = (player.global_position - global_position).normalized()
		velocity = direction * stats.speed
	else: 
		attack()
	
	if direction != Vector2.ZERO:
		cardinal_direction = direction
		
		
	animationTree.set("parameters/Chase/blend_position", cardinal_direction)
	animationTree.set("parameters/Attack/blend_position", cardinal_direction)
	die()
	move_and_slide()
	
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):  # Ensure the player is in the "player" group
		player = get_tree().get_first_node_in_group("Player")
		aggro = true
		healthBar.initHealth(stats.health)
		healthBar.visible = true
		#stateMachine.changeState(stateMachine.get_node("Chase"))  # Change to follow state

func _on_body_exited(body):
	if body.is_in_group("player"):
		aggro = false
		healthBar.visible = false
		#stateMachine.changeState(stateMachine.get_node("Idle"))  # Change to idle state

func chase():
	if player:
		distance = global_position.distance_to(player.global_position)
		if distance <= stats.attackRange:
			attacking = true
			return
		state = "chase"
		direction = (player.global_position - global_position).normalized()
		velocity = direction * stats.speed
		if direction != Vector2.ZERO: cardinal_direction = direction
pass

func attack()-> void:
	#if attackTimer.is_stopped():
		
	if player and attacking:
		if state == "attack":
			distance = global_position.distance_to(player.global_position)
			direction = (player.global_position - global_position).normalized()
			velocity = Vector2.ZERO
			if direction != Vector2.ZERO: 
				cardinal_direction = direction
		state = "attack"
		animationTree.set("parameters/StateMachine/transition_request", "Attack")
		await get_tree().create_timer(stats.attackSpeed).timeout
		attacking = false
	
func updateAnimation(state: String):
	animationPlayer.play(state + animationDirection())

func animationDirection():
	return wolfDirectionMap.get(cardinal_direction, "NE")

func setDirection():
	if direction == Vector2.ZERO:
		return false
		
	var closest_direction = Vector2.ZERO
	var min_angle = 180

	for dir in wolfDirectionMap.keys():
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
		#stateMachine = null
		velocity = Vector2.ZERO
		animationTree.set("parameters/Death/blend_position", cardinal_direction)
		# Optional: Delay before removal
		#setDirection()
		#updateAnimation("Death")
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
