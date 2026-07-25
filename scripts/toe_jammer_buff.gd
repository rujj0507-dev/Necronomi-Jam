extends CharacterBody2D
var balls_num = 20
var hp = 80
var balls_path = preload("res://scene/toe_jammer_bullet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func vongmagic_logic():
	var center_pos = Vector2(global_position.x, global_position.y)
	var angle_step = 2 * PI / balls_num
	var random_offset = randf_range(0, 2 * PI)
	
	for i in range(balls_num):
		var magic = balls_path.instantiate()
		var current_angle = (i * angle_step) + random_offset
		
		magic.rotation = current_angle
		magic.direction = Vector2(cos(current_angle), sin(current_angle))
		magic.global_position = center_pos
		get_tree().root.add_child(magic)


func _on_timer_timeout() -> void:
	vongmagic_logic()
	
	
func hit():
	print("67")
	$AnimationPlayer.play("flash")
	hp -= GameManager.player_attack_damage
	if hp <= 0:
		queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	hit()
