extends Node


const MAX_BOMBS : int = 24
const MAX_SHIPS : int = 3
const SHIP_SIZES : Array[int] = [2, 3, 4]

enum {HORIZONTAL, VERTICAL}

var bombs_remaining : int = MAX_BOMBS
var used_coords : Array[Vector2]

@onready var grid = $Grid


func _ready():
	@warning_ignore("assert_always_true")
	assert(len(SHIP_SIZES) == MAX_SHIPS)
	
	generateShipPlacement()


func generateShipPlacement() -> void:
	for i in range(MAX_SHIPS):
		var placed : bool = false
		while not placed:
			# Random point on grid
			var spawn_pos : Vector2 = Vector2(randi_range(grid.X_MIN, grid.X_MAX), randi_range(grid.Y_MIN, grid.Y_MAX))
			
			# Random orientation
			var orientation : int = randi_range(0, 1)
			
			# Check if out of bounds or overlapping
			match orientation:
				HORIZONTAL:
					if spawn_pos.x + SHIP_SIZES[i] > grid.X_MAX or checkOverlapping(orientation, SHIP_SIZES[i], spawn_pos):
						continue
				VERTICAL:
					if spawn_pos.y + SHIP_SIZES[i] > grid.Y_MAX or checkOverlapping(orientation, SHIP_SIZES[i], spawn_pos):
						continue
			
			placeShip(orientation, SHIP_SIZES[i], spawn_pos)
			placed = true
	
	print("Placed ships!")
	print(used_coords)


func checkOverlapping(orientation : int, ship_size : int, spawn_pos : Vector2) -> bool:
	match orientation:
		HORIZONTAL:
			for c in range(ship_size):
				if used_coords.find(Vector2(spawn_pos.x + c, spawn_pos.y)) != -1:
					return true
		VERTICAL:
			for c in range(ship_size):
				if used_coords.find(Vector2(spawn_pos.x, spawn_pos.y + c)) != -1:
					return true
	return false


func placeShip(orientation : int, ship_size : int, spawn_pos : Vector2) -> void:
	match orientation:
		HORIZONTAL:
			for c in range(ship_size):
				used_coords.append(Vector2(spawn_pos.x + c, spawn_pos.y))
		VERTICAL:
			for c in range(ship_size):
				used_coords.append(Vector2(spawn_pos.x, spawn_pos.y + c))


func _on_grid_fired(pos : Vector2):
	bombs_remaining -= 1
	print("Fired on: ", pos)
	print("Bombs remaining: ", bombs_remaining)
	match used_coords.find(pos):
		-1:
			grid.setTileMiss(pos)
		_:
			grid.setTileHit(pos)
