extends Node2D

@export var resource_list: Array[Card] = []
var random_card

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if resource_list.size() > 0:
		random_card = resource_list.pick_random()
		$Sprite2D.texture = random_card.texture
		$Label.text = random_card.infor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if random_card.infor == "bullet speed - 50%":
		GameManager.player_bullet_speed -= (GameManager.player_bullet_speed * 50 / 100)
	if random_card.infor == "cooldown + 1s":
		GameManager.player_cooldown += 1
	if random_card.infor == "gun damage - 1":
		GameManager.player_attack_damage -= 1
	if random_card.infor == "speed - 50%":
		GameManager.player_speed -= (GameManager.player_speed * 50 / 100)
	if random_card.infor == "max health - 50%":
		GameManager.max_player_health -= (GameManager.max_player_health * 50 / 100)
	if random_card.infor == "70% damage - 2 30% damage + 2":
		GameManager.player_got_damagechance = true
