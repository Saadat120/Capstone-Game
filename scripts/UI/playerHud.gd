extends Control

@onready var healthBar: ProgressBar = $HealthBar
@onready var healthVal: Label = $HealthVal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthVal.text = str(healthBar.value) + "/100"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	healthVal.text = str(healthBar.value) + "/100"
	pass
