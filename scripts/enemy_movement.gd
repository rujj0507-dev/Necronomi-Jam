extends CharacterBody2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D


@export var bullet_scene = preload("res://scene/normal_bullet.tscn")
@export var fire_rate: float = 3
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var player: Node2D = null
var fire_timer: Timer
var dir: Vector2
var speed = 50.0
var hp = 25
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	#fire_timer = Timer.new()
	#fire_timer.one_shot = true  # important: one_shot for now, we restart it manually
	#add_child(fire_timer)
	#fire_timer.timeout.connect(_on_fire_timer_timeout)

	# Randomize the delay before the FIRST shot
	$fire_timer.wait_time = randf_range(1.0, 3.0)
	$fire_timer.start()
	
	await get_tree().create_timer(randf_range(0,1)).timeout
	$Timer.start()
	
func _physics_process(delta: float) -> void:
	if is_instance_valid(player):
		if player.global_position.x < global_position.x:
			sprite_2d.flip_h = true
			$Eye1.position.x = 0.5
			$Eye2.position.x = -2.5
		elif player.global_position.x > global_position.x:
			sprite_2d.flip_h = false
			$Eye1.position.x = -0.5
			$Eye2.position.x = 2.5

	velocity = speed * dir
	if velocity.x > 1 or velocity.x < -1:
		sprite_2d.animation = "walk"
	else:
		sprite_2d.animation = "Idle"
	
	move_and_slide()
func _on_fire_timer_timeout() -> void:
	shoot()
	$fire_timer.wait_time = fire_rate
	$fire_timer.start()

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.speed = 100.0
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	var bullet_dir = (player.global_position - global_position).normalized()
	bullet.set_direction(bullet_dir)


func _on_timer_timeout() -> void:
	var move_or_not = 0
	move_or_not = randi_range(1,3)
	if move_or_not == 1:
		dir = Vector2(0, 0)
	else:
		speed = randi_range(25,50)
		dir = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	
	$Timer.start(randf_range(0.5,2))
	
func hit():
	$AnimationPlayer.play("hitflash")
	hp -= GameManager.player_attack_damage
	if hp <= 0:
		queue_free()
	
