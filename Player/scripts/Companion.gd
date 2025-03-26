extends CharacterBody2D

@onready var animationTree: AnimationTree = $AnimationTree
@onready var gauge: ProgressBar = $CanvasLayer/GaugeMeter

var player: CharacterBody2D
var follow: bool = false
var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var distance: float
var gaugeInc: float = 0
var abilityActive: bool

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	gauge.value = 0
	SignalBus.passiveStack.connect(handleStacks)
	
	
func _physics_process(_delta: float) -> void:
	handleMovement()

func handleMovement() -> void:
	distance = global_position.distance_to(player.global_position)
	
	if distance > 60:
		follow = true
		direction = (player.global_position - global_position).normalized()
		velocity = direction * 40
	elif distance > 30 and follow:
		direction = (player.global_position - global_position).normalized()
	else:
		follow = false
		velocity = Vector2.ZERO
	
	if direction != Vector2.ZERO:
		cardinal_direction = direction
	
	animationTree.set("parameters/Idle/blend_position", cardinal_direction)
	animationTree.set("parameters/Follow/blend_position", cardinal_direction)
	move_and_slide()

func handleStacks() -> void:
#The lower the health, the greater the gauge increase every hit
	if gauge.value < 100 and $AbilityTimer.is_stopped():
		gaugeInc = 10 * (1 + abs((player.playerManager.health - 100)/200.0))
		gauge.value = clamp(gauge.value + gaugeInc, gauge.min_value, gauge.max_value)
		$CanvasLayer/GaugeValue.text = str(int(gauge.value))
		AbilityProc()

func AbilityProc() -> void:
	if gauge.value >= 100 and not abilityActive:
		abilityActive = true
		SignalBus.AbilityMeterFilled.emit()
		$AbilityTimer.start()

func _on_ability_timer_timeout() -> void:
	abilityActive = false
	gauge.value = 0
	$CanvasLayer/GaugeValue.text = str(int(gauge.value))
	SignalBus.AbilityEnded.emit()
