extends Camera2D

# Camera parameters
@export var zoom_level = Vector2(0.6, 0.6)  # Makes view wider
@export var follow_speed = 3.0

# Screen shake parameters
@export var shake_strength = 2.0
@export var shake_decay = 5.0

# Target (player) reference - we'll get it differently now
var target: Node2D
var shake_strength_current = 0.0

func _ready():
	# Basic camera setup
	zoom = zoom_level
	position_smoothing_enabled = true
	position_smoothing_speed = follow_speed
	
	# Camera feel improvements
	drag_horizontal_enabled = true
	drag_vertical_enabled = true
	drag_left_margin = 0.1
	drag_right_margin = 0.1
	drag_top_margin = 0.1
	drag_bottom_margin = 0.1
	
	# Get the player reference - since camera is child of player
	target = get_parent()
	if not target:
		push_warning("Camera couldn't find player node!")

func _physics_process(delta):
	if target:
		# Since we're a child of the player, we actually don't need to move to their position
		# Just handle screen shake if active
		if shake_strength_current > 0:
			shake_strength_current = lerpf(shake_strength_current, 0.0, shake_decay * delta)
			offset = Vector2(
				randf_range(-1.0, 1.0) * shake_strength_current,
				randf_range(-1.0, 1.0) * shake_strength_current
			)
		else:
			offset = Vector2.ZERO

# Call this to shake the camera
func shake():
	shake_strength_current = shake_strength
