extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("hit"):
			body.hit()
