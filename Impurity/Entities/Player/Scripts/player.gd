extends CharacterBody2D

@export var boss: Area2D
const BULLET_SCENE := preload("res://Entities/player_bullet/player_bullet.tscn")
const BULLET_OFFSET := Vector2(0, -20)
const OFFSET_1 := Vector2(-10, 0)
const OFFSET_2 := Vector2(10, 0)

var bullet := 1
var auto_aim := false
var reward_duration := 10
var reward_requirement := 500

const SPEED := 150.0
const SPRINT_MULTIPLIER := 1.5
const SLOW_MULTIPLIER := 0.5

const MAX_HEALTH := 500.0
var HEALTH := 500.0
var GRAZE := 0
# tick is for reward from graze
var tick := 0
var DEAD := false
var attacking := false

var parrying := false
var parrying_window := 0.3
var parry_available := true

var direction_queue: Array
var facing_direction := "down"
var status := "idle"
var intro_dialogue := true

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	intro_dialogue = false

func _physics_process(_delta: float) -> void:
	
	if HEALTH <= 0:
		visible = false
		print("DEAD")
		DEAD = true
	
	if HEALTH > 0:
		visible = true
		DEAD = false
	
	# input, directions are -1, 0, or 1
	var directionx := Input.get_axis("move_left", "move_right")
	var directiony := Input.get_axis("move_up", "move_down")
	var parry := Input.is_action_pressed("parry")
	var slowing := Input.is_action_pressed("slow")
	var shooting := Input.is_action_pressed("shoot")
	var speed := SPEED
	if slowing:
		speed = speed * SLOW_MULTIPLIER
	var input_direction := Vector2(directionx, directiony).normalized()
	
	#movement
	if not DEAD:
		if parry and not parrying and parry_available:
			parry_available = false
			parrying = true
			print("parry")
			await get_tree().create_timer(parrying_window).timeout
			parrying = false
			print("parry over")
			await get_tree().create_timer(1).timeout
			parry_available = true
			print("parry off cooldown")
		
		if not parry:
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
			
			# firing/shooting
			
			if shooting and not attacking and not intro_dialogue:
				shoot_bullet()
				
			

	# USE THE FOLLOWING LINE IF NOTHING IS WORKING
	#print("test")
	
	get_direction_sprite()
	update_anim(slowing)
	
	# USE THE FOLLOWING LINES IF SPRITES ARE NOT UPDATING CORRECTLY
	#print(direction_queue)
	#print("You are " + status + " facing " + facing_direction + ".")
	
	check_reward()
	
func get_direction_sprite() -> void:
	if not direction_queue.is_empty():
		facing_direction = direction_queue.back().to_lower()

func is_moving() -> bool:
	var moving := Input.get_axis("move_left", "move_right") != 0 \
	or Input.get_axis("move_up", "move_down") != 0
	status = "moving" if moving else "idle"
	return moving
	
func update_anim(slowing: bool) -> void:
	if slowing:
		$sprite.play("idle_up_hitbox")
	else:
		$sprite.play("idle_up")
	
func take_damage(amount) -> void:
	HEALTH = HEALTH - amount
	print("Took " + str(amount) + " damage, now at " + str(HEALTH) + ".")

func get_health() -> int:
	if DEAD:
		if has_node("bullet_collision"):
			$bullet_collision.monitorable = false
		return 0
	else:
		$bullet_collision.monitorable = true
		return HEALTH

func is_dead() -> bool:
	if DEAD:
		return true
	else:
		return false

func respawn() -> void:
	global_position = Vector2(0, 0)
	HEALTH = MAX_HEALTH
	DEAD = false

func shoot_bullet() -> void:
	attacking = true
	var new_bullet = BULLET_SCENE.instantiate()
	var new_bullet2 = BULLET_SCENE.instantiate()
	new_bullet.global_position = global_position + BULLET_OFFSET + OFFSET_1
	new_bullet2.global_position = global_position + BULLET_OFFSET + OFFSET_2
	if not auto_aim:
		new_bullet.velocity = Vector2.UP * 1000
		new_bullet2.velocity = Vector2.UP * 1000
	else:
		new_bullet.velocity = (boss.global_position \
		- new_bullet.global_position).normalized() * 1000
		new_bullet2.velocity = (boss.global_position \
		- new_bullet2.global_position).normalized() * 1000
	new_bullet.player = self
	new_bullet2.player = self
	get_tree().current_scene.add_child(new_bullet)
	get_tree().current_scene.add_child(new_bullet2)
	await get_tree().create_timer(0.05 if not auto_aim else 0.15).timeout
	attacking = false



#this also increases tick, the variable for reward checks
func gain_graze(amount: int) -> void:
	GRAZE += amount
	tick += amount
	
func lose_graze(amount: int) -> void:
	GRAZE -= amount
	
func get_graze() -> int:
	return GRAZE

func check_reward() -> void:
	if auto_aim == false:
		if tick >= reward_requirement:
			tick = 0
			auto_aim = true
			print("auto_aim")
			await get_tree().create_timer(reward_duration).timeout
			auto_aim = false


func _on_graze_collision_area_exited(area: Area2D) -> void:
	if not area.HAS_HIT and not area.HAS_PARRIED:
		gain_graze(15)


func _on_graze_collision_area_entered(area: Area2D) -> void:
	if parrying == true:
		area.velocity = -area.velocity
		area.HAS_PARRIED = true
		print("Parry!")
