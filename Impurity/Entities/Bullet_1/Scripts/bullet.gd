extends Area2D

var velocity := Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(15)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
