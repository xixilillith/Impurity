extends Area2D

var player_detection := false
@export var boss: Area2D
@export var player: CharacterBody2D
@export var bullet_node: Node2D
var player_dir: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_dir = (player.global_position - bullet_node.get_parent().global_position).normalized()


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() == player:
		player_detection = true


func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() == player:
		player_detection = false


func _on_timer_timeout() -> void:
	if player_detection and not boss.is_dead():
		bullet_node.cheese = true
		bullet_node.fire_laser_cross_auto(1000)
		bullet_node.fire_cross(40, 90, player_dir, 200, 0.05)
	else:
		bullet_node.cheese = false
