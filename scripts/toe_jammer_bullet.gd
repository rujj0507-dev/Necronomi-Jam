extends Area2D

var speed = 100
var direction = Vector2.ZERO

func _physics_process(delta):
	global_position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("walls"):
			queue_free()
	visible= false
	await get_tree().create_timer(0.2).timeout
	queue_free()
