extends Control

@export var player: CharacterBody2D
@onready var respawn_button = $CanvasLayer/Button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if respawn_button.visible == true:
		respawn_button.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.is_dead():
		respawn_button.visible = true
	else:
		respawn_button.visible = false

func _on_button_pressed() -> void:
	player.respawn()
	respawn_button.visible = false
