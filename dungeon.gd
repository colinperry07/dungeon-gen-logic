extends Node2D

export var level = 0
onready var tilemap = $TileMap


func _ready():
	randomize()
	var room_num = [5,6].pick_random() + level
	var grid_size = Vector2(64,38)
	if room_num > grid_size.x * grid_size.y:
		room_num = grid_size.x * grid_size.y
	generate_dungeon(grid_size, room_num)


func generate_dungeon(grid_size : Vector2, room_num : int):
	
	var room_coords = []
	
	for _i in range(room_num):
		var room_size = Vector2(10,10)
		var room_viable = false
		var starting_point
		while !room_viable:
			var roomx = randi() % int(grid_size.x - room_size.x)
			var roomy = randi() % int(grid_size.y - room_size.y)
			var buffer = 1
			starting_point = Vector2(roomx, roomy)
			if room_coords != []:
				for room_pos in room_coords: # added 1 pixel of extra padding to prevent any rooms from touching
					if (starting_point.x < room_pos.x + room_size.x + buffer and starting_point.x > room_pos.x - room_size.x - buffer -1 ) or \
					(starting_point.y < room_pos.y + room_size.y + buffer and starting_point.y > room_pos.y - room_size.y - buffer - 1):
						pass
					else:
						room_viable = true
			else:
				room_viable = true
		print(starting_point)
		
		for y in range(room_size.y):
			for x in range(room_size.x): 
				tilemap.set_cell(x+starting_point.x, y+starting_point.y, 1)
		
		room_coords.append(starting_point)
