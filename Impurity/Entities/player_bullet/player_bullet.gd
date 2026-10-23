extends Area2D

@onready var player: CharacterBody2D = get_tree().current_scene.find_child("Player")
var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += velocity * delta
	if player.is_dead():
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(5)
