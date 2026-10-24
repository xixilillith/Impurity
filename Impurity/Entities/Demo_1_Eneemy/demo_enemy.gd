extends Area2D

@export var POINTA: Vector2 = Vector2(100, -125)
@export var POINTB: Vector2 = Vector2(-100, -125)
var MID_POINT: Vector2 = (POINTA + POINTB) / Vector2(2, 2)
@export var SPEED: float = 100.0

var target_point: Vector2

var DEAD = false
const MAX_HEALTH := 2000.0
var HEALTH := 2000.0
var velocity = Vector2.ZERO

func _ready() -> void:
	global_position = Vector2(0, -125)
	target_point = POINTB
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if HEALTH <= 0:
		DEAD = true
		visible = false
		monitorable = false
	elif HEALTH > 0:
		DEAD = false
		visible = true
		monitorable = true
	
	if not DEAD:
		global_position = global_position.move_toward(target_point, SPEED * delta)
		
		if global_position.distance_to(target_point) < 0.1:
			if target_point == POINTA:
				target_point = POINTB
			elif target_point == POINTB:
				target_point = POINTA

func take_damage(amount: int) -> void:
	HEALTH -= amount

func is_dead() -> bool:
	if DEAD:
		return true
	else:
		return false

func get_health() -> int:
	return HEALTH

func respawn() -> void:
	HEALTH = MAX_HEALTH
	DEAD = false
	global_position = Vector2(0, -125)
