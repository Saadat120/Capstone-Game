class_name Player extends CharacterBody2D

@onready var healthBar: ProgressBar = $"PlayerUI/HUD/HealthBar"
@onready var animationTree: AnimationTree = $AnimationTree
@onready var hit_flash: AnimationPlayer = $HitFlash
@onready var stats: StatsComponent = $StatsComponent
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin
@onready var combatManager: CombatManager = $CombatManager


var attacking = false
var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats.initialize(100, 100, 400, 80, 0.3, 0)
	healthBar.initHealth(stats.health)
	SignalBus.playerHealthChanged.connect(healthBar._set_health)
	add_child(stats.attackTimer)

func _physics_process(_delta: float) -> void:
	if !attacking:
		direction = Vector2(
			Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
		).normalized()
		velocity = direction * stats.speed
	elif attacking:
		velocity = Vector2.ZERO
	if direction != Vector2.ZERO:
		cardinal_direction = direction
		
	animationTree.set("parameters/Idle/blend_position", cardinal_direction)
	animationTree.set("parameters/Walk/blend_position", cardinal_direction)
	animationTree.set("parameters/Attack/blend_position", cardinal_direction)
	attack()
	move_and_slide()
	died()

func attack():
	if combatManager.attacks["basicAttack"].isReady:
		attacking = false
		
	#print(combatManager.attacks["basicAttack"].isReady)
	if Input.is_action_just_pressed("space"):
		combatManager.performAttack("basicAttack")
		attacking = true

func died():
	if stats.health <= 0:
		get_parent().get_tree().change_scene_to_file("res://World/Areas/Main.tscn")


func _on_hurtbox_component_area_entered(hitbox: Area2D) -> void:
	#DamageManager.damageApplied.emit(get_parent(), hitbox.get_parent())
	if hitbox is Hitbox:
		DamageManager.applyDamage(hitbox.get_parent(), self)
		SignalBus.playerHealthChanged.emit(stats.health)
		hit_flash.play("hitFlash")
	pass # Replace with function body.
