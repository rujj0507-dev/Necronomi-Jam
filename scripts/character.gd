extends CharacterBody2D

@export var bullet_scene: PackedScene
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var cooldownu = false
var deadyung = false
const SPEED = 100.0
var iframe = false

func _ready() -> void:
	add_to_group("player")

	$die.visible = false

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "Walk"
	else:
		animated_sprite_2d.animation = "Idle"

	var direction_x := Input.get_axis("left", "right")
	if direction_x:
		velocity.x = direction_x * GameManager.player_speed
	else:
		velocity.x = move_toward(velocity.x, 0, GameManager.player_speed)
	var direction_y := Input.get_axis("up", "down")
	if direction_y:
		velocity.y = direction_y * GameManager.player_speed
	else:
		velocity.y = move_toward(velocity.y, 0, GameManager.player_speed)
	if GameManager.player_health <= 0:
		print("Die")
		animated_sprite_2d.visible = false
		$die.play("Die")
		$die.visible = true
		await $die.animation_finished
		visible = false
		$Area2D/Bullet_hit_box.disabled = true
		#Engine.time_scale = 0.1
		
	if Input.is_action_pressed("shoot"):
		player_shoot()
		

	move_and_slide()
	if direction_x > 0:
		animated_sprite_2d.flip_h = false # Face right while moving right
	elif direction_x < 0:
		animated_sprite_2d.flip_h = true  # Face left while moving left
		
func hit():
	#$AnimationPlayer.play("damaged")
	#$Iframe.play("i")
	#GameManager.player_health -= 10
	#print("off")
	
	## มี iframe
	if !iframe:
		iframe = true
		$AnimationPlayer.play("damaged")
		$Iframe.play("i")
		GameManager.player_health -= 10
		print("off")

func player_shoot():
	if !cooldownu:
		cooldownu = true
		$cooldown.start()
		var bullet = bullet_scene.instantiate()
		bullet.speed = GameManager.player_bullet_speed
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		#bullet.targetposition = (get_global_mouse_position())-global_position
		var bullet_dir = (get_global_mouse_position() - global_position).normalized()
		bullet.set_direction(bullet_dir)


func _on_cooldown_timeout() -> void:
	cooldownu = false


func _on_iframe_animation_finished(anim_name: StringName) -> void:
	if anim_name == "i":
		iframe = false
