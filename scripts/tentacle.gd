extends Node2D

var player
var att = 0
var target_pos = Vector2.ZERO

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	var tween = create_tween()
	
	tween.tween_property(self, "position:y", position.y - 50, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _process(delta: float) -> void:
	if att == 0:
		position.x = player.position.x


func _on_timer_timeout() -> void:
	dash_attack()


func dash_attack() -> void:
	#att = 1
	var tween = create_tween()
	
	$Timer2.start()
	tween.tween_property(self, "position:y", position.y - 50, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", position.y + 210, 0.8).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	
	
	tween.finished.connect(func(): queue_free())


func _on_timer_2_timeout() -> void:
	att = 1
