extends Node

var freezeSlow = 0.07
var freezeTime = 0.4

func slowTime():
	Engine.time_scale = freezeSlow
	await get_tree().create_timer(freezeTime * freezeSlow).timeout
	Engine.time_scale = 1
