extends Node2D

@export var player: CharacterBody2D
const bullet_scene = preload("res://Entities/Bullet_1/bullet.tscn")
const laser_head_scn = preload("res://Entities/laser_1/laser_1_head.tscn")
const laser_body_scn = preload("res://Entities/laser_1/laser_1_body.tscn")
var attacking = false
var laser_attacking = false
var attack_num = 1
var laser_attack_num = 1

var offset := 20

func _ready() -> void:
	randomize()

func _on_timer_timeout() -> void:
	var random_attack = randi_range(1, 100)
	var random_las_attack = randi_range(1, 100)
	var player_is_dead = player.is_dead()
	var player_dir := (player.global_position - global_position).normalized()
	
	if not attacking and not player_is_dead and not get_parent().is_dead():
		if attack_num <= 20:
			fire_arc_ltr(20, 45, player_dir, 200, 0.05)
		elif attack_num <= 40:
			fire_line(20, 200, 0.05)
		elif attack_num <= 60:
			fire_arc_rtl(20, 45, player_dir, 200, 0.05)
		elif attack_num <= 80:
			fire_cross(40, 90, player_dir, 200, 0.05)
		if not laser_attacking:
			if laser_attack_num <= 5:
				fire_laser_one_auto(1000)
			elif laser_attack_num <= 10:
				fire_laser_cross_auto(1000)
			elif laser_attack_num <= 15:
				fire_laser_semi_ltr_auto(1000, 10)
			elif laser_attack_num <= 20:
				fire_laser_semi_rtl_auto(1000, 10)
			elif laser_attack_num <= 25:
				fire_laser_semi_rtl_chaos(1000, 10)
			elif laser_attack_num <= 30:
				fire_laser_semi_ltr_chaos(1000, 10)
		attack_num = random_attack
		laser_attack_num = random_las_attack
		
func fire_arc_ltr(count: int, arc_deg: float, center_dir: Vector2, vel: int, delay: float) -> void:
	attacking = true
	var step := arc_deg / (count - 1)
	var start := -arc_deg / 2.0
	for i in count:
		var angle := deg_to_rad(start + step * i)
		var dir := center_dir.rotated(angle)
		
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = global_position + center_dir * offset
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
		new_bullet.global_position = global_position + center_dir * offset
		new_bullet.velocity = dir * vel
		get_tree().current_scene.add_child(new_bullet)
		
		await get_tree().create_timer(delay).timeout
		
	attacking = false


func fire_line(count: int, vel: int, delay: float) -> void:
	attacking = true
	for i in count:
		var dir = (player.global_position - global_position).normalized()
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = global_position + dir * offset
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
		
		new_bullet1.global_position = global_position + center_dir * offset
		new_bullet2.global_position = global_position + center_dir * offset
		new_bullet1.velocity = dir1 * vel
		new_bullet2.velocity = dir2 * vel
		
		get_tree().current_scene.add_child(new_bullet1)
		get_tree().current_scene.add_child(new_bullet2)
		
		await get_tree().create_timer(delay).timeout
		
	attacking = false
	
func fire_laser_one_auto(length: float) -> void:
	laser_attacking = true
	var len = length
	var aim = (player.global_position - get_parent().MID_POINT).normalized()
	var dir = aim.angle()
	var new_laser_head = laser_head_scn.instantiate()
	var new_laser_body = laser_body_scn.instantiate()
	var start = get_parent().MID_POINT + aim * offset
	run_laser(new_laser_head, new_laser_body, len, dir, start)
	
	await get_tree().create_timer(1.3).timeout
	
	laser_attacking = false
	
func fire_laser_cross_auto(length: float) -> void:
	laser_attacking = true
	var len = length
	var aim1 = (player.global_position - get_parent().POINTA).normalized()
	var aim2 = (player.global_position - get_parent().POINTB).normalized()
	var start1 = get_parent().POINTA + aim1 * offset
	var start2 = get_parent().POINTB + aim2 * offset
	var dir1 = aim1.angle()
	var dir2 = aim2.angle()
	
	var las_head_1 = laser_head_scn.instantiate()
	var las_head_2 = laser_head_scn.instantiate()
	var las_body_1 = laser_body_scn.instantiate()
	var las_body_2 = laser_body_scn.instantiate()
	run_laser(las_head_1, las_body_1, length, dir1, start1)
	run_laser(las_head_2, las_body_2, length, dir2, start2)
	
	await get_tree().create_timer(1.3).timeout
	laser_attacking = false

func fire_laser_semi_ltr_auto(length: float, count: int) -> void:
	laser_attacking = true
	var center = (get_parent().POINTA + get_parent().POINTB) / 2
	var radius = (get_parent().POINTB - get_parent().POINTA).length() / 2
	var start_angle = (get_parent().POINTB - center).angle()
	for i in count:
		var n_las_head = laser_head_scn.instantiate()
		var n_las_body = laser_body_scn.instantiate()
		var t = float(i) / (count - 1)
		var arc_angle = start_angle - PI * t
		var pos = center + Vector2.from_angle(arc_angle) * radius
		var aim = (player.global_position - pos).normalized()
		var dir = aim.angle()
		run_laser(n_las_head, n_las_body, length, dir, pos)
		await get_tree().create_timer(0.2).timeout
	await get_tree().create_timer(1.1).timeout
	laser_attacking = false

func fire_laser_semi_rtl_auto(length: float, count: int) -> void:
	laser_attacking = true
	var center = (get_parent().POINTA + get_parent().POINTB) / 2
	var radius = (get_parent().POINTA - get_parent().POINTB).length() / 2
	var start_angle = (get_parent().POINTA - center).angle()
	for i in count:
		var n_las_head = laser_head_scn.instantiate()
		var n_las_body = laser_body_scn.instantiate()
		var t = float(i) / (count - 1)
		var arc_angle = start_angle + PI * t
		var pos = center + Vector2.from_angle(arc_angle) * radius
		var aim = (player.global_position - pos).normalized()
		var dir = aim.angle()
		run_laser(n_las_head, n_las_body, length, dir, pos)
		await get_tree().create_timer(0.2).timeout
	await get_tree().create_timer(1.1).timeout
	laser_attacking = false

func fire_laser_semi_rtl_chaos(length: float, count: int) -> void:
	laser_attacking = true
	var center = (get_parent().POINTA + get_parent().POINTB) / 2
	var radius = (get_parent().POINTA - get_parent().POINTB).length() / 2
	var start_angle = (get_parent().POINTA - center).angle()
	for i in count:
		var n_las_head = laser_head_scn.instantiate()
		var n_las_body = laser_body_scn.instantiate()
		var t = float(i) / (count - 1)
		var arc_angle = start_angle + PI * t
		var pos = center + Vector2.from_angle(arc_angle) * radius
		var dir = arc_angle
		run_laser(n_las_head, n_las_body, length, dir, pos)
		await get_tree().create_timer(0.2).timeout
	await get_tree().create_timer(1.1).timeout
	laser_attacking = false

func fire_laser_semi_ltr_chaos(length: float, count: int) -> void:
	laser_attacking = true
	var center = (get_parent().POINTA + get_parent().POINTB) / 2
	var radius = (get_parent().POINTB - get_parent().POINTA).length() / 2
	var start_angle = (get_parent().POINTB - center).angle()
	for i in count:
		var n_las_head = laser_head_scn.instantiate()
		var n_las_body = laser_body_scn.instantiate()
		var t = float(i) / (count - 1)
		var arc_angle = start_angle - PI * t
		var pos = center + Vector2.from_angle(arc_angle) * radius
		var dir = arc_angle
		run_laser(n_las_head, n_las_body, length, dir, pos)
		await get_tree().create_timer(0.2).timeout
	await get_tree().create_timer(1.1).timeout
	laser_attacking = false

func run_laser(head: Area2D, body: Line2D, length: float, dir: float, pos: Vector2) -> void:
	var sprite: AnimatedSprite2D = head.get_node("AnimatedSprite2D")
	head.global_position = pos
	head.global_rotation = dir
	body.global_position = pos
	body.global_rotation = dir
	body.set_point_position(1, Vector2.ZERO)
	
	get_tree().current_scene.add_child(head)
	await sprite.animation_finished
	get_tree().current_scene.add_child(body)
	
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_method(func(x: float): body.set_point_position(1, Vector2(x, 0)), 0.0, length, 0.3)
	await tween.finished
	
	await get_tree().create_timer(1.0).timeout
	head.queue_free()
	body.queue_free()
