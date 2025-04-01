extends Control

@onready var healthBar: ProgressBar = $HealthBar
@onready var healthVal: Label = $HealthVal
@onready var treats: Label = $PanelContainer/VBoxContainer/TreatsHBox/Treats
@onready var marks: Label = $PanelContainer/VBoxContainer/MarksHBox/Marks

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthVal.text = str(int(healthBar.value)) + "/100"
	treats.text = str(GlobalPlayer.animalTreats)
	marks.text = str(GlobalPlayer.playerMarks)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	healthVal.text = str(int(healthBar.value)) + "/100"
	treats.text = str(GlobalPlayer.animalTreats)
	marks.text = str(GlobalPlayer.playerMarks)
