extends CharacterBody2D


const SPEED = 300.0
const SPRINT_MULTIPLIER = 1.5
const SLOW_MULTIPLIER = 0.5

var HEALTH = 100.0
var DEAD = false

var direction_queue = []
var facing_direction = "down"
var status = "idle"

func _physics_process(_delta: float) -> void:
	
	if HEALTH <= 0:
		visible = false
		print("DEAD")
		DEAD = true
	
	# input, directions are -1, 0, or 1
	var directionx := Input.get_axis("move_left", "move_right")
	var directiony := Input.get_axis("move_up", "move_down")
	var running := Input.is_action_pressed("run")
	var slowing := Input.is_action_pressed("slow")
	var speed := SPEED
	if running:
		speed = speed * SPRINT_MULTIPLIER
	elif slowing:
		speed = speed * SLOW_MULTIPLIER
	var input_direction := Vector2(directionx, directiony).normalized()
	
	#movement
	if not DEAD:
		if directionx:
			velocity.x = input_direction.x * speed
				
			# the following lines check direction (for sprites)
			if directionx == -1:
				if "RIGHT" in direction_queue:
					direction_queue.erase("RIGHT")
				if not "LEFT" in direction_queue:
					direction_queue.append("LEFT")
			elif directionx == 1:
				if "LEFT" in direction_queue:
					direction_queue.erase("LEFT")
				if not "RIGHT" in direction_queue:
					direction_queue.append("RIGHT")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			direction_queue.erase("RIGHT")
			direction_queue.erase("LEFT")
			
		if directiony:
			velocity.y = input_direction.y * speed
			if directiony == -1:
				if "DOWN" in direction_queue:
					direction_queue.erase("DOWN")
				if not "UP" in direction_queue:
					direction_queue.append("UP")
			elif directiony == 1:
				if "UP" in direction_queue:
					direction_queue.erase("UP")
				if not "DOWN" in direction_queue:
					direction_queue.append("DOWN")
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
			direction_queue.erase("DOWN")
			direction_queue.erase("UP")

		move_and_slide()
	# USE THE FOLLOWING LINE IF NOTHING IS WORKING
	#print("test")
	
	get_direction_sprite()
	update_anim()
	
	# USE THE FOLLOWING LINES IF SPRITES ARE NOT UPDATING CORRECTLY
	#print(direction_queue)
	#print("You are " + status + " facing " + facing_direction + ".")


func get_direction_sprite() -> void:
	if not direction_queue.is_empty():
		facing_direction = direction_queue.back().to_lower()

func is_moving() -> bool:
	var moving := Input.get_axis("move_left", "move_right") != 0 \
	or Input.get_axis("move_up", "move_down") != 0
	status = "moving" if moving else "idle"
	return moving
	
func update_anim() -> void:
	is_moving()
	$sprite.play(status + "_" + facing_direction)
	
func take_damage(amount) -> void:
	HEALTH = HEALTH - amount
	print("Took " + str(amount) + " damage, now at " + str(HEALTH) + ".")

func get_health() -> int:
	if DEAD:
		if has_node("bullet_collision"):
			$bullet_collision.queue_free()
		return 0
	else:
		return HEALTH
