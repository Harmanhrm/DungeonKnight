
# Enemy.gd - This controls the enemy
extends CharacterBody2D

var speed = 100
var player = null

func _ready():
	# Find the player
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player:
		# Move towards player
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()

func take_damage():
	# Enemy dies when hit
	queue_free()
