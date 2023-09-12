extends Node


const MAX_BOMBS : int = 24
const MAX_SHIPS : int = 3
const SHIP_SIZES : Array[int] = [2, 3, 4]

enum {HORIZONTAL, VERTICAL}

var used_coords : Array[Vector2]
var ship_coords : Dictionary
var bombs_remaining : int = MAX_BOMBS

@onready var grid = $Grid
@onready var bombs_label = $HUD/Bombs
@onready var camera = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var dead_ship = load("res://Assets/squid_dead.png")
@onready var new_game_hud = $NewGame


func _ready():
	@warning_ignore("assert_always_true")
	assert(len(SHIP_SIZES) == MAX_SHIPS)
	
	generateShipPlacement()
	updateBombLabel()


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
	print(ship_coords)


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
	var new_ship : Array[Vector2]
	match orientation:
		HORIZONTAL:
			for c in range(ship_size):
				new_ship.append(Vector2(spawn_pos.x + c, spawn_pos.y))
		VERTICAL:
			for c in range(ship_size):
				new_ship.append(Vector2(spawn_pos.x, spawn_pos.y + c))
	
	ship_coords[ship_size] = new_ship
	used_coords += new_ship


func _on_grid_fired(pos : Vector2):
	bombs_remaining -= 1
	updateBombLabel()
	
	#print("\nFired on: ", pos)
	
	# Check every ships coordinates to see if it has been hit
	for ship in ship_coords.keys():
		# Found coordinate
		if ship_coords[ship].find(pos) != -1:
			grid.setTileHit(pos)
			# Remove coordinates from ship
			ship_coords[ship].erase(pos)
			# Check if ship is sunk
			if not ship_coords[ship]:
				print("Ship size ", ship, " sunk!")
				ship_coords.erase(ship)
				setShipDead(ship)
				print(ship_coords)
			
			# Camera shake
			camera.shake()
			audio.playHit()
			
			# All ships sunk
			if ship_coords.is_empty():
				new_game_hud.setLabelText(true)
				new_game_hud.visible = true
				return
			return
	
	# If no ship coordinate is found, it's a miss
	grid.setTileMiss(pos)
	audio.playMiss()
	
	# Ran out of bombs
	if bombs_remaining <= 0:
		new_game_hud.setLabelText(false)
		new_game_hud.visible = true


func updateBombLabel() -> void:
	bombs_label.set_text("Bombs Remaining: " + str(bombs_remaining))


func setShipDead(ship_size : int) -> void:
	match ship_size:
		2:
			$Ship2.texture = dead_ship
			$Ship2/ShipDead.visible = true
		3:
			$Ship3.texture = dead_ship
			$Ship3/ShipDead.visible = true
		4:
			$Ship4.texture = dead_ship
			$Ship4/ShipDead.visible = true
