extends DirectionalLight2D
@onready var lightnig: AudioStreamPlayer2D = $"../Lightnig"
var next_play = randf_range(5,20)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(next_play).timeout
	play()

func play():
	visible = true
	lightnig.play()
	await lightnig.finished
	visible = false
	next_play = randf_range(5,20)
