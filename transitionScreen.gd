extends CanvasLayer

signal transitionFinished

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	color_rect.hide()

func transition() -> void:
	color_rect.visible = true
	animation_player.play("fadeToBlack")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeToBlack":
		transitionFinished.emit()
		animation_player.play("fadeToNormal")
	elif anim_name == "fadeToNormal":
		color_rect.visible = true
