class_name Projectile extends Hitbox

var speed = 135
var direction = Vector2.ZERO
var attackOption: String = "Damage"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var lifetime: float = 0.75 
var _time_alive: float = 0.0

func  _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	position += speed * direction * delta
	animated_sprite_2d.play(attackOption)
	
	 #Remove projectile after its lifetime expires.
	_time_alive += delta
	if _time_alive > lifetime:
		queue_free()

func projectileAttack(mouseClick: String):
	if mouseClick == "leftClick":
		attackOption = "Damage"
	elif mouseClick == "rightClick":
		attackOption = "Debuff"
