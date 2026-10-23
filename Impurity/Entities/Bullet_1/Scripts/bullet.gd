extends Area2D

var velocity := Vector2.ZERO
var HAS_GRAZED := false
var HAS_HIT := false
var HAS_PARRIED := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta

#ACTUAL HIT!
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("take_damage") and not HAS_HIT and not HAS_GRAZED and not HAS_PARRIED:
		area.get_parent().take_damage(15)
		HAS_HIT = true
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
