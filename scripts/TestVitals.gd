extends Node
## Quick test harness for HealthIndicator + SanityOverlay together.
## Attach this to any Node in the scene, then drag both nodes into the
## export slots below.
##
## Controls:
##   D -> deal 10 damage (health)
##   H -> heal 10 (health)
##   C -> corrupt 10 (sanity)
##   V -> restore 10 sanity
##   R -> reset both to full

@export var health_bar: HealthIndicator
@export var sanity_overlay: SanityOverlay
@export var amount: float = 10.0


func _ready() -> void:
	if health_bar == null or sanity_overlay == null:
		push_warning("TestVitals: assign HealthIndicator and SanityOverlay in the inspector.")
		return
	print("Vitals test ready. D=damage H=heal C=corrupt V=restore R=reset")


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return

	match event.keycode:
		KEY_D:
			if health_bar:
				health_bar.damage(amount)
				print("HP: %s/%s" % [health_bar.current_health, health_bar.max_health])
		KEY_H:
			if health_bar:
				health_bar.heal(amount)
				print("HP: %s/%s" % [health_bar.current_health, health_bar.max_health])
		KEY_C:
			if sanity_overlay:
				sanity_overlay.corrupt(amount)
				print("Sanity: %s/%s" % [sanity_overlay.current_sanity, sanity_overlay.max_sanity])
		KEY_V:
			if sanity_overlay:
				sanity_overlay.restore(amount)
				print("Sanity: %s/%s" % [sanity_overlay.current_sanity, sanity_overlay.max_sanity])
		KEY_R:
			if health_bar:
				health_bar.current_health = health_bar.max_health
			if sanity_overlay:
				sanity_overlay.current_sanity = sanity_overlay.max_sanity
			print("Reset both to full.")
