extends Area2D
var rng = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	$CollisionShape2D.disabled = true

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("Monster").is_empty():
		visible = true
		$CollisionShape2D.disabled = false
		print("Clear")



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		rng = randi_range(1,8)
		GameManager.card_turn -= 1
		GameManager.boss_room -= 1
		if GameManager.card_turn == 0:
			get_tree().change_scene_to_file("res://scene/pick_card.tscn")
			GameManager.card_turn = 3
		elif GameManager.boss_room == 0:
			get_tree().change_scene_to_file("res://scene/Rooms/room_boss.tscn")
		else:
			get_tree().change_scene_to_file("res://scene/Rooms/room_"+str(rng)+".tscn")
