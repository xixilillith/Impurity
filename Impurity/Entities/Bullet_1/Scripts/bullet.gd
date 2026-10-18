extends Area2D

var velocity := Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta


func _on_area_entered(area: Area2D) -> void:
	print("Hit!")
	queue_free()
