extends CharacterBody2D

# Movement variables
@export var speed = 200.0
@export var acceleration = 1500.0
@export var friction = 1000.0

# Animation
@onready var animated_sprite = $AnimatedSprite2D

# Track player state
var is_attacking = false
var direction = Vector2.ZERO

func _physics_process(delta):
	# Get input direction
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Handle movement
	if direction:
		# Accelerate when moving
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		# Apply friction when no input
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
	update_animation()

func update_animation():
	if is_attacking:
		# Don't change animation if we're attacking
		return
		
	if velocity.length() == 0:
		play_animation("idle")
	else:
		# Determine direction for animation
		if abs(velocity.x) > abs(velocity.y):
			# Moving horizontally
			if velocity.x > 0:
				play_animation("run")
				animated_sprite.flip_h = false
			else:
				play_animation("run")
				animated_sprite.flip_h = true
		else:
			# Moving vertically
			if velocity.y > 0:
				play_animation("attack-down")
			else:
				play_animation("attack-up")

func play_animation(anim_name: String):
	if animated_sprite.animation != anim_name:
		animated_sprite.play(anim_name)

func attack():
	if not is_attacking:
		is_attacking = true
		
		# Choose attack animation based on direction
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				animated_sprite.play("attack-right")
				animated_sprite.flip_h = false
			else:
				animated_sprite.play("attack-right")
				animated_sprite.flip_h = true
		else:
			if direction.y > 0:
				animated_sprite.play("attack-down")
			else:
				animated_sprite.play("attack-up")
		
		# Wait for attack animation to finish
		await animated_sprite.animation_finished
		is_attacking = false

func _unhandled_input(event):
	# Handle attack input
	if event.is_action_pressed("attack"):  # You'll need to set up this input action
		attack()
