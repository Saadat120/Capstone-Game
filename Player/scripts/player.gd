class_name Player extends CharacterBody2D

@onready var playerManager: PlayerManager = $PlayerManager
@onready var animationTree: AnimationTree = $AnimationTree
@onready var fx: AnimationPlayer = $FX
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin

var attacking := false
var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

#Camera Shake Varaibles
var randomStrength: float = 5.0
var shakeFade: float = 3.0
var rng := RandomNumberGenerator.new()
var shakeStrength: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerManager.initialize(100, 150, 80, 10)

func _physics_process(delta: float) -> void:
	handleDash()
	handleMovement()
	attack()
	died()
	
	#Camera Shake
	if shakeStrength > 0:
		shakeStrength = lerpf(shakeStrength, 0, shakeFade * delta)
		$Camera2D.offset = randomOffset()

func handleMovement() -> void:
	if !attacking:
		direction = Vector2(
			Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
		).normalized()
		velocity = direction * playerManager.getSpeed()
	elif attacking:
		velocity = Vector2.ZERO
	if direction != Vector2.ZERO:
		cardinal_direction = direction
		
	animationTree.set("parameters/Idle/blend_position", cardinal_direction)
	animationTree.set("parameters/Walk/blend_position", cardinal_direction)
	animationTree.set("parameters/Attack/blend_position", cardinal_direction)
	move_and_slide()

func handleDash() -> void:
	if Input.is_action_just_pressed("Shift"):
		if velocity != Vector2.ZERO and playerManager.getAbility("Dash").isReady:
			$Dash.startDash(0.1)
			playerManager.performAttack("Dash")
	playerManager.speedMultipliers["Dash"] = 5 if $Dash.isDashing() else 1

func attack() -> void:
	if playerManager.getAbility("basicAttack").isReady:
		attacking = false
		
	if Input.is_action_just_pressed("Space"):
		playerManager.performAttack("basicAttack")
		attacking = true

func died() -> void:
	if playerManager.health <= 0:
		get_parent().get_tree().change_scene_to_file("res://World/Areas/Main.tscn")

func _on_hurtbox_component_area_entered(hitbox: Area2D) -> void:
	if hitbox is Hitbox:
		DamageManager.applyDamageToPlayer(hitbox.get_parent(), self)
		SignalBus.playerHealthChanged.emit(playerManager.health)
		shakeStrength = randomStrength #apply camera shake
		fx.play("hitFlash")

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shakeStrength, shakeStrength), rng.randf_range(-shakeStrength, shakeStrength))
