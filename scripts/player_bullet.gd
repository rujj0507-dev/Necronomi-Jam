extends Area2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var speed: float = 500.0
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
	#if body.has_method("hit"):
			#body.hit()
			#queue_free()
	await get_tree().create_timer(0.1).timeout
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	var rng
	if GameManager.player_got_damagechance:
		rng = randi_range(1,10)
		if rng <= 7:
			GameManager.player_attack_damage -= 2
			rng = 1
		else:
			GameManager.player_attack_damage += 2
			rng = 2
	audio_stream_player_2d.play()
	visible = false
	await audio_stream_player_2d.finished
	await get_tree().create_timer(0.5).timeout
	if rng == 1:
		GameManager.player_attack_damage += 2
	else:
		GameManager.player_attack_damage -= 2
	print(GameManager.player_attack_damage)
	queue_free()
