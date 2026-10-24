extends Control

const boss_fight := preload("res://Other Scenes/boss_fight.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$CanvasLayer/Button.visible = false
	get_tree().current_scene.add_child(boss_fight.instantiate())
