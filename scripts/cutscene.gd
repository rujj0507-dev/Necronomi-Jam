extends Control
@onready var anim: AnimationPlayer = $AnimationPlayer
var scenenow = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("NextScene"):
		scenenow += 1
		if scenenow <= 5:
			anim.play(str(scenenow))
		else:
			get_tree().change_scene_to_file("res://scene/Rooms/room_start.tscn")
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
