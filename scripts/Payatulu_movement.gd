extends CharacterBody2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D


@export var bullet_scene: PackedScene
@export var enemy_scene: PackedScene
@export var tenten_scene: PackedScene
@export var fire_rate: float = 2.0
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var hp = 2000
var player: Node2D = null
enum state {bullet,spawn }

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	

		

func _on_fire_timer_timeout() -> void:
	if player != null:
		shoot()


func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.speed = 160
	var dir = (player.global_position - global_position).normalized()
	bullet.set_direction(dir)
	get_parent().add_child(bullet)
	
	var bullet2 = bullet_scene.instantiate()
	bullet2.global_position = global_position
	bullet2.speed = 160
	var dir2 = (player.global_position - global_position).normalized()
	print(dir2)
	bullet2.set_direction(dir2 + Vector2(0.4, 0.4))
	get_parent().add_child(bullet2)
	
	var bullet3 = bullet_scene.instantiate()
	bullet3.global_position = global_position
	bullet3.speed = 160
	var dir3 = (player.global_position - global_position).normalized()
	print(dir3)
	bullet3.set_direction(dir3 + Vector2(-0.4, -0.4))
	get_parent().add_child(bullet3)

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	var enemy2 = enemy_scene.instantiate()
	var enemy3 = enemy_scene.instantiate()
	var enemy4 = enemy_scene.instantiate()
	enemy.global_position = Vector2(-168, -64)
	enemy2.global_position = Vector2(168, -64)
	enemy3.global_position = Vector2(-168, 58)
	enemy4.global_position = Vector2(168, 58)
	get_parent().add_child(enemy)
	get_parent().add_child(enemy2)
	get_parent().add_child(enemy3)
	get_parent().add_child(enemy4)

func tenten():
	var tenten = tenten_scene.instantiate()
	tenten.global_position = Vector2(player.global_position.x, player.global_position.y - 65)
	get_parent().add_child(tenten)

func _on_att_timer_timeout() -> void:
	var att = randi_range(1, 5)
	if att == 1:
		tenten()
	elif att == 2:
		spawn_enemy()
	else:
		shoot()

	
func hit():
	$AnimationPlayer.play("hitflash")
	hp -= GameManager.player_attack_damage
	$CanvasLayer/TextureRect/TextureRect2/ProgressBar.value = hp
	if hp <= 0:
		queue_free()
	


func _on_hurtbox_area_entered(area: Area2D) -> void:
	hit()
