extends Node2D

const bullet_scene = preload("res://Entities/Bullet_1/bullet.tscn")

func _on_timer_timeout() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.velocity = Vector2.DOWN * 100
	get_tree().current_scene.add_child(bullet)
