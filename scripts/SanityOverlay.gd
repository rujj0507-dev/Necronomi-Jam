extends Control
class_name SanityOverlay
## Corruption overlay that layers ON TOP of a HealthIndicator to show
## sanity loss creeping in.
##
## 0-25% corruption -> nothing shown.
## 25-50% -> tile 0 (mildest)
## 50-75% -> tile 1
## 75-100% -> tile 2
## 100% (fully corrupted) -> tile 3 (heaviest)
##
## corruption = 1.0 - (current_sanity / max_sanity)
##
## SETUP: do NOT add this as a child of HealthIndicator - HealthIndicator
## clears its children whenever it rebuilds. Instead put both under a
## plain Control/Node2D "wrapper", sized/anchored the same (e.g. both
## using the "Full Rect" anchor preset), with SanityOverlay placed AFTER
## HealthIndicator in the scene tree so it renders on top.

@export var sprite_sheet: Texture2D  # health_corrupt_ss.png
@export var tile_size: Vector2i = Vector2i(16, 16)
@export var stage_count: int = 4      # number of corruption sprites in the sheet
@export var icon_scale: float = 4.0   # match your HealthIndicator's icon_scale

@export var max_sanity: float = 100.0
@export var current_sanity: float = 100.0:
	set(v):
		current_sanity = clampf(v, 0.0, max_sanity)
		_update_stage()

var _icon: TextureRect
var _stage_atlases: Array[AtlasTexture] = []


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_icon()
	_update_stage()


func _build_icon() -> void:
	for c in get_children():
		c.queue_free()
	_stage_atlases.clear()

	if sprite_sheet == null:
		push_warning("SanityOverlay: no sprite_sheet assigned.")
		return

	var icon_pixel_size := Vector2(tile_size) * icon_scale
	custom_minimum_size = icon_pixel_size

	for i in stage_count:
		var atlas := AtlasTexture.new()
		atlas.atlas = sprite_sheet
		atlas.region = Rect2(i * tile_size.x, 0, tile_size.x, tile_size.y)
		_stage_atlases.append(atlas)

	_icon = TextureRect.new()
	_icon.stretch_mode = TextureRect.STRETCH_SCALE
	_icon.custom_minimum_size = icon_pixel_size
	_icon.size = icon_pixel_size
	_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST  # keep pixel art crisp
	_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_icon)


func _update_stage() -> void:
	if _icon == null or _stage_atlases.is_empty():
		return

	var sanity_pct := current_sanity / max_sanity if max_sanity > 0.0 else 0.0
	var corruption_pct := 1.0 - clampf(sanity_pct, 0.0, 1.0)

	# Breakpoints every 25%: 0=nothing, 1..stage_count map to tiles 0..stage_count-1
	var stage: int = clampi(int(floor(corruption_pct * stage_count)), 0, stage_count)

	if stage == 0:
		_icon.visible = false
	else:
		_icon.visible = true
		_icon.texture = _stage_atlases[stage - 1]


func corrupt(amount: float) -> void:
	self.current_sanity -= amount


func restore(amount: float) -> void:
	self.current_sanity += amount
