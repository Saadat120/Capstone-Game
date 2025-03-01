class_name WalkState extends State

@export var moveSpeed: float
@export var waterSpeedMultiplier: float = 0.65  # Reduce speed by 50% on water

@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"
@onready var tilemap: Array[TileMapLayer] = [$"../../../Map/LowerLayer", $"../../../Map/HigherLayer"]

#What happens when player enters this state
func Enter() -> void:
	if entity == null:
		return
	moveSpeed = entity.stats.speed
	entity.updateAnimation("walk")
	pass

#What happens when player exit this state
func Exit()  -> void:
	pass

func Process(_delta: float) -> State:
	if entity.direction == Vector2.ZERO:
		return idle
	if Input.is_action_just_pressed("space"):
		if entity.stats.attackTimer.is_stopped():
			return attack
	var tilePos = tilemap[0].local_to_map(tilemap[0].to_local(entity.global_position + Vector2(8, 16)))
	var tileData = tilemap[0].get_cell_tile_data(tilePos)
	
	if tileData:
		var tileAtlasCoord = tilemap[0].get_cell_atlas_coords(tilePos)
		if tileAtlasCoord == Vector2i(6,8):
			moveSpeed *= waterSpeedMultiplier
	
	entity.velocity = entity.direction * moveSpeed
	if entity.setDirection():
		entity.updateAnimation("walk")
	return null
	
#What happens with input events in this state
func Physics(_delta: float) -> State:
	return null
	
#What happens with input events in this state
func handleInput(_event: InputEvent) -> State:
	return null
