class_name Player extends CharacterBody2D

@onready var playerManager: PlayerManager = $PlayerManager
@onready var animationTree: AnimationTree = $AnimationTree
@onready var fx: AnimationPlayer = $FX
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin

var attacking := false
var recentHit := false
var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

#Camera Shake Varaibles
var randomStrength: float = 5.0
var shakeFade: float = 3.0
var rng := RandomNumberGenerator.new()
var shakeStrength: float = 0.0
	
func _physics_process(delta: float) -> void:
	handleMovement()
	handleAbilities()
	died()
	
	#Camera Shake
	if shakeStrength > 0:
		shakeStrength = lerpf(shakeStrength, 0, shakeFade * delta)
		$Camera2D.offset = randomOffset()

func handleMovement() -> void:
	if !attacking and playerManager.canMove:
		direction = Vector2(
			Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
		).normalized()
		velocity = direction * playerManager.getSpeed()
	elif attacking or !playerManager.canMove:
		velocity = Vector2.ZERO
	if direction != Vector2.ZERO:
		cardinal_direction = direction
	updateAnimation()
	move_and_slide()

func handleAbilities() -> void:
#	Attack
	if $PlayerManager/AbilitiesManager/AttackTimer.is_stopped():
		attacking = false
		recentHit = false
		if Input.is_action_just_pressed("Space") and playerManager.canAttack:
			attacking = true
			playerManager.useAbility("Attack")
#	Dashing
	if Input.is_action_just_pressed("Shift"):
		if velocity != Vector2.ZERO and !playerManager.abilitiesManager.isDashing():
			playerManager.useAbility("Dash")
#	PetAbility
	if Input.is_action_just_pressed("F"):
		playerManager.useAbility("Ultimate")

	playerManager.speedMultipliers["Dash"] = 5 if playerManager.abilitiesManager.isDashing() else 1

func updateAnimation() -> void:
	for param:String in ["Idle", "Walk", "Attack"]:
		animationTree.set("parameters/%s/blend_position" % param, cardinal_direction)

func died() -> void:
	if playerManager.health <= 0:
		get_parent().get_tree().change_scene_to_file("res://World/scenes/Main.tscn")

#Player hits enemy
func _on_hitbox_area_entered(hurtbox: Area2D) -> void:
	if recentHit == true:
		return
	if hurtbox is Hurtbox:
		playerManager.updateGauge()
		var entity := hurtbox.get_parent()
		DamageManager.applyDamageToEnemy(self, entity)
		SignalBus.enemyHealthChanged.emit(entity.stats.health)
		entity.hit_flash.play("hitFlash")
		if entity.stats.health <= 0:
			entity.dead = true

#Enemy hits player
func _on_hurtbox_component_area_entered(hitbox: Area2D) -> void:
	if hitbox is Hitbox:
		DamageManager.applyDamageToPlayer(hitbox.get_parent(), self)
		SignalBus.playerHealthChanged.emit(playerManager.health)
		shakeStrength = randomStrength #apply camera shake
		fx.play("hitFlash")

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shakeStrength, shakeStrength), rng.randf_range(-shakeStrength, shakeStrength))
