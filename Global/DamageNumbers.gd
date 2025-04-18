extends Node

func displayNumbers(value: int, position: Vector2, isBleed: bool)->void:
	var number := Label.new()
	number.global_position = position
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color := "#fff"
	
	if isBleed:
		color = "#b22"
	if value == 0:
		color = "#fff8"
		
	number.label_settings.font_color = color
	number.label_settings.font_size = 18
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size/2)
	
	var tween := get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	
	await tween.finished
	number.queue_free()

func displayDodge(Fxposition: Vector2)->void:
	var number := Label.new()
	number.global_position = Fxposition
	number.text = "Dodged"
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	var color := "#fff"
		
	number.label_settings.font_color = color
	number.label_settings.font_size = 12
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size/2)
	
	var tween := get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	
	await tween.finished
	number.queue_free()
