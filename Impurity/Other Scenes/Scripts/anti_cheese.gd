extends Area2D

var player_detection := false
@export var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_detection:
		print("in cheese")
	else:
		print("in not cheese mhm yeah")


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() == player:
		player_detection = true


func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() == player:
		player_detection = false
