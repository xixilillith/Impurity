extends Control

@export var player: CharacterBody2D
@export var boss: Area2D
@onready var replay_button = $CanvasLayer/Button
@export var UI: Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if replay_button.visible == true:
		replay_button.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if boss.is_dead() and not player.is_dead():
		replay_button.visible = true
	else:
		replay_button.visible = false


func _on_button_pressed() -> void:
	player.respawn()
	UI.win_count += 1
	boss.respawn()
	replay_button.visible = false
