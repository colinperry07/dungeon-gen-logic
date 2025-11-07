extends Node2D


export var level = 0
onready var tilemap = $TileMap


func _ready():
	randomize()
	var n_rooms = [5,6].pick_random() + level
	var grid_size = Vector2(64,38)
	generate_dungeon(grid_size, n_rooms)


func generate_dungeon(grid_size : Vector2, room_num : int):
	var room_coords = []
	var room_centers = []
	
	for _i in range(room_num): # generates rooms
		var room_size = Vector2(10,10)
		var room_starting_point
		
		while true:
			var roomx = randi() % int(grid_size.x - room_size.x)
			var roomy = randi() % int(grid_size.y - room_size.y)
			room_starting_point = Vector2(roomx, roomy)
			
			var overlap = false
			for room_pos in room_coords:
				if Rect2(room_starting_point, room_size).intersects(Rect2(room_pos, room_size).grow(2)):
					overlap = true
					break
			
			if !overlap:
				break
		for x in range(room_size.x):
			for y in range(room_size.y):
				tilemap.set_cell(x+room_starting_point.x, y+room_starting_point.y, 1)
		
		room_coords.append(room_starting_point)
		room_centers.append(room_starting_point + (room_size / 2))
		
	for i in range(1, room_centers.size()): # generates corridors
		create_corridor(room_centers[i-1], room_centers[i], room_coords)


func create_corridor(from: Vector2, to: Vector2, room_coords : Array):
	
	var x1 = int(from.x)
	var x2 = int(to.x)
	
	var y1 = int(from.y)
	var y2 = int(to.y)
	
	for x in range(min(x1, x2), max(x1, x2)):
		tilemap.set_cell(x, y1, 1)
	for y in range(min(y1, y2), max(y1, y2) + 1):
		tilemap.set_cell(x2, y, 1)
	check_surroundings(Vector2(0,0), room_coords)


func check_surroundings(point : Vector2, room_coords : Array):
	var path_cell_locations = tilemap.get_used_cells_by_id(1)
	
	for room in room_coords: # removes the room cell positions from the array to isolate the path cell positions
		for x in range(10):
			for y in range(10):
				path_cell_locations.erase(Vector2(room.x+x, room.y+y))
