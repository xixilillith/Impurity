extends Area2D

var in_laser := false
var player = TYPE_NIL
@onready var shape = $CollisionShape2D

func _on_area_entered(area: Area2D) -> void:
	in_laser = true
	player = area.get_parent()
	
func _on_area_exited(area: Area2D) -> void:
	in_laser = false
	player = TYPE_NIL
	
func _physics_process(delta: float) -> void:
	shape.global_position = global_position
	if in_laser:
		if player.has_method("take_damage"):
			player.take_damage(2)
		
		
