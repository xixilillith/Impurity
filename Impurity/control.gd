extends Control

@export var Player: CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Player:
		print("UI Ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var health = Player.get_health()
	$Label.text = "HEALTH: " + str(health)
