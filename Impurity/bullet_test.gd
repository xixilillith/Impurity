extends Node2D

@export var player: CharacterBody2D
const bullet_scene = preload("res://Entities/Bullet_1/bullet.tscn")
var attacking = false
var attack_num = 1
func _on_timer_timeout() -> void:
	var player_is_dead = player.is_dead()
	var player_dir := (player.global_position - global_position).normalized()
	
	if not attacking and not player_is_dead and not get_parent().is_dead():
		if attack_num == 1:
			fire_arc_ltr(10, 45, player_dir, 200, 0.05)
			attack_num = 2
		elif attack_num == 2:
			fire_line(25, 200, 0.05)
			attack_num = 3
		elif attack_num == 3:
			fire_arc_rtl(10, 45, player_dir, 200, 0.05)
			attack_num = 4
		elif attack_num == 4:
			fire_cross(20, 90, player_dir, 200, 0.05)
			attack_num = 1
		
func fire_arc_ltr(count: int, arc_deg: float, center_dir: Vector2, vel: int, delay: float) -> void:
	attacking = true
	var step := arc_deg / (count - 1)
	var start := -arc_deg / 2.0
	for i in count:
		var angle := deg_to_rad(start + step * i)
		var dir := center_dir.rotated(angle)
		
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = global_position
		new_bullet.velocity = dir * vel
		get_tree().current_scene.add_child(new_bullet)
		
		await get_tree().create_timer(delay).timeout
		
	attacking = false
	
func fire_arc_rtl(count: int, arc_deg: float, center_dir: Vector2, vel: int, delay: float) -> void:
	attacking = true
	var step := arc_deg / (count - 1)
	var start := arc_deg / 2.0
	for i in count:
		var angle := deg_to_rad(start - step * i)
		var dir := center_dir.rotated(angle)
		
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = global_position
		new_bullet.velocity = dir * vel
		get_tree().current_scene.add_child(new_bullet)
		
		await get_tree().create_timer(delay).timeout
		
	attacking = false


func fire_line(count: int, vel: int, delay: float) -> void:
	attacking = true
	for i in count:
		var dir = (player.global_position - global_position).normalized()
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = global_position
		new_bullet.velocity = dir * vel
		get_tree().current_scene.add_child(new_bullet)
		
		await get_tree().create_timer(delay).timeout
	
	attacking = false

func fire_cross(count: int, arc_deg: float, center_dir: Vector2, vel: int, delay: float) -> void:
	attacking = true
	var step := arc_deg / (count-1)
	var start1 := arc_deg / 2.0
	var start2 := -arc_deg / 2.0
	for i in count:
		var angle1 = deg_to_rad(start1 - step * i)
		var angle2 = deg_to_rad(start2 + step * i)
		var dir1 = center_dir.rotated(angle1)
		var dir2 = center_dir.rotated(angle2)
		
		var new_bullet1 = bullet_scene.instantiate()
		var new_bullet2 = bullet_scene.instantiate()
		
		new_bullet1.global_position = global_position
		new_bullet2.global_position = global_position
		new_bullet1.velocity = dir1 * vel
		new_bullet2.velocity = dir2 * vel
		
		get_tree().current_scene.add_child(new_bullet1)
		get_tree().current_scene.add_child(new_bullet2)
		
		await get_tree().create_timer(delay).timeout
		
	attacking = false
	
