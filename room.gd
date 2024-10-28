extends Node2D

# Store references to our scenes and nodes
@onready var tilemap: TileMap = $TileMap

# Room size in tiles (adjust based on your tileset)
const ROOM_WIDTH = 16  # Example: 16 tiles wide
const ROOM_HEIGHT = 10 # Example: 10 tiles high

# Tile indices - adjust these to match your tileset
const FLOOR_TILE = 0
const WALL_TILE = 1
const DOOR_TILE = 2

# Room types
enum RoomType {
	START,
	NORMAL,
	TREASURE
}

# Current room tracking
var current_room_pos = Vector2i(0, 0)

func _ready():
	create_starter_level()

func create_starter_level():
	# Create starting room at (0,0)
	create_room(Vector2i(0, 0), RoomType.START)
	
	# Create adjacent rooms
	create_room(Vector2i(1, 0), RoomType.NORMAL)  # Right room
	create_room(Vector2i(0, 1), RoomType.NORMAL)  # Bottom room
	create_room(Vector2i(0, -1), RoomType.TREASURE)  # Top room
	
	# Add doors between rooms
	add_door_between_rooms(Vector2i(0, 0), Vector2i(1, 0))  # Right door
	add_door_between_rooms(Vector2i(0, 0), Vector2i(0, 1))  # Bottom door
	add_door_between_rooms(Vector2i(0, 0), Vector2i(0, -1))  # Top door

func create_room(room_pos: Vector2i, room_type: RoomType):
	# Calculate room's pixel position
	var start_x = room_pos.x * ROOM_WIDTH
	var start_y = room_pos.y * ROOM_HEIGHT
	
	# Place floor tiles
	for y in range(ROOM_HEIGHT):
		for x in range(ROOM_WIDTH):
			var tile_pos = Vector2i(start_x + x, start_y + y)
			
			# Place walls around the edges
			if x == 0 or x == ROOM_WIDTH-1 or y == 0 or y == ROOM_HEIGHT-1:
				tilemap.set_cell(0, tile_pos, 0, Vector2i(WALL_TILE, 0))
			else:
				tilemap.set_cell(0, tile_pos, 0, Vector2i(FLOOR_TILE, 0))
	
	# Add room-type specific decorations
	match room_type:
		RoomType.START:
			# Maybe add a special floor tile or marker
			var center = Vector2i(start_x + ROOM_WIDTH/2, start_y + ROOM_HEIGHT/2)
			tilemap.set_cell(1, center, 0, Vector2i(3, 0))  # Special start tile
		RoomType.TREASURE:
			# Add a treasure chest
			var chest_pos = Vector2i(start_x + ROOM_WIDTH/2, start_y + ROOM_HEIGHT/2)
			tilemap.set_cell(1, chest_pos, 0, Vector2i(4, 0))  # Treasure chest tile

func add_door_between_rooms(room1_pos: Vector2i, room2_pos: Vector2i):
	# Figure out where the door should go
	var door_pos = Vector2i()
	
	if room1_pos.x == room2_pos.x:  # Vertical connection
		door_pos.x = room1_pos.x * ROOM_WIDTH + ROOM_WIDTH/2
		if room1_pos.y < room2_pos.y:  # Down door
			door_pos.y = room1_pos.y * ROOM_HEIGHT + ROOM_HEIGHT - 1
		else:  # Up door
			door_pos.y = room1_pos.y * ROOM_HEIGHT
	else:  # Horizontal connection
		door_pos.y = room1_pos.y * ROOM_HEIGHT + ROOM_HEIGHT/2
		if room1_pos.x < room2_pos.x:  # Right door
			door_pos.x = room1_pos.x * ROOM_WIDTH + ROOM_WIDTH - 1
		else:  # Left door
			door_pos.x = room1_pos.x * ROOM_WIDTH
	
	# Place the door tile
	tilemap.set_cell(0, door_pos, 0, Vector2i(DOOR_TILE, 0))

# Call this when player enters a new room
func enter_room(new_room_pos: Vector2i):
	current_room_pos = new_room_pos
	# You can add room transition effects here
