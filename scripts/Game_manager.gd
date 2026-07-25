extends Node

signal health_changed(new_health: float)

var max_player_health = 100
var player_health: float = 100:
	set(v):
		player_health = clampf(v, 0.0, max_player_health)
		health_changed.emit(player_health)

var player_sanity = 0
var player_speed = 100
var player_attack_damage = 5
var player_bullet_speed = 250

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Goon")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
