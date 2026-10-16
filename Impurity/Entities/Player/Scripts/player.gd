extends CharacterBody2D


const SPEED = 300.0
const SPRINT_MULTIPLIER = 1.5
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionx := Input.get_axis("ui_left", "ui_right")
	var directiony := Input.get_axis("ui_up", "ui_down")
	var running := Input.is_action_pressed("run")
	
	if directionx:
		if running:
			velocity.x = directionx * SPEED * SPRINT_MULTIPLIER
		else:
			velocity.x = directionx * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if directiony:
		if running:
			velocity.y = directiony * SPEED * SPRINT_MULTIPLIER
		else:
			velocity.y = directiony * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
