extends Control

@export var Boss: Area2D
@export var Player: CharacterBody2D
var win_count = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Player:
		print("UI Ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var health = Player.get_health()
	var boss_health = Boss.get_health()
	var graze = Player.get_graze()
	$CanvasLayer/Label.text = "HEALTH: " + str(health)
	$CanvasLayer/Label2.text = "BOSS HEALTH: " + str(boss_health)
	$CanvasLayer/Label3.text = "WINS: " + str(win_count)
	$CanvasLayer/Label5.text = "GRAZE: " + str(graze)
