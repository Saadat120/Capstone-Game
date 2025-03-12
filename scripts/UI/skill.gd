extends NinePatchRect

@onready var bar: TextureProgressBar = $TextureProgressBar
@onready var timer: Timer = $Timer
@onready var time: Label = $Time

func _ready() -> void:
	bar.max_value = timer.wait_time
	bar.value = 0
	#set_process(false)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space")and timer.is_stopped():
		start_cooldown()
	time.text = "%3.1f" % timer.time_left
	bar.value = timer.time_left

func start_cooldown() -> void:
	timer.start()
	bar.value = timer.wait_time
	#set_process(true)

func _on_timer_timeout() -> void:
	time.text = ""
	#set_process(false)
	pass # Replace with function body.
