extends Control

var rng = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.card_turn = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.cardpick:
		GameManager.cardpick = false
	if Input.is_action_just_pressed("NextScene"):
		if GameManager.boss_room == 0:
			get_tree().change_scene_to_file("res://scene/Rooms/room_boss.tscn")
		else:
			rng = randi_range(1,8)
			get_tree().change_scene_to_file("res://scene/Rooms/room_"+str(rng)+".tscn") 
