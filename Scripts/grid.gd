extends TileMap

signal fired(pos : Vector2)

const X_MIN : int = 1
const X_MAX : int = 8
const Y_MIN : int = 1
const Y_MAX : int = 8

const SHIP_LAYER : int = 3
const STATUS_LAYER : int = 4
const HIT_ID : int = 4
const MISS_ID : int = 5


func _unhandled_input(event):
	if event.is_action("select") and Input.is_action_just_pressed("select"):
		var clicked_pos : Vector2 = get_local_mouse_position()
		var map_pos : Vector2 = local_to_map(clicked_pos)
		if checkBounds(map_pos) and checkCanFire(map_pos):
			emit_signal("fired", map_pos)


func checkBounds(pos : Vector2) -> bool:
	if pos.x >= X_MIN and pos.x <= X_MAX and pos.y >= Y_MIN and pos.y <= Y_MAX:
		return true
	return false


func checkCanFire(pos : Vector2) -> bool:
	var id : int = get_cell_source_id(STATUS_LAYER, pos)
	match id:
		HIT_ID, MISS_ID:
			print("Cell already used")
			return false
		_:
			return true


func setTileHit(pos : Vector2) -> void:
	set_cell(STATUS_LAYER, pos, HIT_ID, Vector2.ZERO)


func setTileMiss(pos : Vector2) -> void:
	set_cell(STATUS_LAYER, pos, MISS_ID, Vector2.ZERO)
