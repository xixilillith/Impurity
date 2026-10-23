extends Line2D

const wall_offset = 2
var in_laser = false
var in_wall1 = false
var in_wall2 = false
var player: Node = null
var HAS_HIT := false

var p0: Vector2
var p1: Vector2
var dir: Vector2
var side: Vector2

@onready var Wall1 = $Area2D
@onready var Wall2 = $Area2D2
@onready var Shape1 = $Area2D/CollisionShape2D
@onready var Shape2 = $Area2D2/CollisionShape2D

func _ready() -> void:
	print(points)
	print(get_point_position(0))

func set_hitbox() -> void:
	Wall1.position = p0 + side
	Wall2.position = p0 - side
	Shape1.shape.a = Vector2.ZERO
	Shape2.shape.a = Vector2.ZERO
	Shape1.shape.b = dir
	Shape2.shape.b = dir
#WALL1
func _on_area_2d_area_entered(area: Area2D) -> void:
	if not in_wall1:
		player = area.get_parent()
		in_wall1 = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if in_wall1:
		in_wall1 = false
	
#WALL2
func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if not in_wall2:
		player = area.get_parent()
		in_wall2 = true


func _on_area_2d_2_area_exited(area: Area2D) -> void:
	if in_wall2:
		in_wall2 = false

func _process(delta: float) -> void:
	p0 = get_point_position(0)
	p1 = get_point_position(1)
	dir = p1 - p0
	side = dir.orthogonal().normalized() * wall_offset
	set_hitbox()
	
	if in_wall1 or in_wall2:
		in_laser = true
	else:
		in_laser = false
	
	if in_laser:
		if player.has_method("take_damage"):
			HAS_HIT = true
			player.take_damage(1)
