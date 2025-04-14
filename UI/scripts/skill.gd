class_name Skill extends NinePatchRect

@onready var bar: TextureProgressBar = $TextureProgressBar
@onready var timer: Timer = $Timer
@onready var time: Label = $Time
@onready var key: Label = $Key
var skillButton: String = "Special"

func _ready() -> void:
	bar.max_value = timer.wait_time
	bar.value = 0
	set_process(false)
	
func initialize(skillCooldown: float, button: String) -> void:
	timer.wait_time = skillCooldown
	skillButton = button
	key.text = skillButton
	bar.max_value = timer.wait_time
	bar.value = 0
	
func _process(_delta: float) -> void:
	time.text = "%3.1f" % timer.time_left
	bar.value = timer.time_left

func activateAbility() -> void:
	start_cooldown()
	set_process(true)
	
func start_cooldown() -> void:
	timer.start()
	bar.value = timer.wait_time

func _on_timer_timeout() -> void:
	time.text = ""
	set_process(false)
