extends Node2D

# Node references - removed explicit typing for tilemap
@onready var tilemap = $Room
@onready var player = $Player
@onready var camera = $Player/Camera2D

func _ready():
	setup_scene()

func setup_scene():
	# Center the room
	center_room()
	
	# Position player in middle of room
	position_player()
	
	# Setup camera limits based on room size
	setup_camera_limits()

func center_room():
	var tile_size = 64  # Adjust based on your tile size
	var room_width_tiles = 10  # Adjust based on your room width
	var room_height_tiles = 8   # Adjust based on your room height
	
	# Calculate room size in pixels
	var room_size = Vector2(
		room_width_tiles * tile_size,
		room_height_tiles * tile_size
	)
	
	# Center the tilemap
	var screen_size = get_viewport().get_visible_rect().size
	var center_offset = (screen_size - room_size) / 2
	tilemap.position = center_offset

func position_player():
	if player and tilemap:
		var tile_size = 64  # Adjust based on your tile size
		# Position player in center of room
		player.position = tilemap.position + Vector2(
			5 * tile_size,  # Half of room width
			4 * tile_size   # Half of room height
		)

func setup_camera_limits():
	if camera and tilemap:
		# Make sure tilemap is actually a TileMap before using TileMap-specific methods
		if tilemap is TileMap:
			# Get the used cells from tilemap
			var used_cells = tilemap.get_used_cells(0)  # 0 is the default layer
			
			if used_cells.size() > 0:
				# Find the bounds
				var min_x = INF
				var max_x = -INF
				var min_y = INF
				var max_y = -INF
				
				for cell in used_cells:
					min_x = min(min_x, cell.x)
					max_x = max(max_x, cell.x)
					min_y = min(min_y, cell.y)
					max_y = max(max_y, cell.y)
				
				# Calculate room bounds in pixels
				var tile_size = 64  # Adjust based on your tile size
				var padding = 32    # Adjust padding as needed
				
				# Set camera limits
				camera.limit_left = tilemap.position.x + (min_x * tile_size) - padding
				camera.limit_right = tilemap.position.x + ((max_x + 1) * tile_size) + padding
				camera.limit_top = tilemap.position.y + (min_y * tile_size) - padding
				camera.limit_bottom = tilemap.position.y + ((max_y + 1) * tile_size) + padding
				
				# Enable limits
				camera.limit_smoothed = true
