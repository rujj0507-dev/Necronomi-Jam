extends Area2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var speed: float = 100.0
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	rotation = direction.angle()
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("walls"):
		queue_free()
		
func _on_area_entered(area: Area2D) -> void:
		audio_stream_player_2d.play()
		visible = false
		await audio_stream_player_2d.finished
		queue_free()
