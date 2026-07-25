extends Control
class_name HealthIndicator
## A single heart icon that transitions from red (full HP) to purple
## (0 HP) with a top-to-bottom WIPE, not a fade.
##
## How it works: a purple icon sits underneath a red icon. The red icon
## has a shader on it that hides its top portion once health drops
## below 100%, revealing the purple icon beneath. As health keeps
## dropping, the hidden portion grows further down the icon, so the
## red->purple boundary sweeps from top to bottom.

@export var sprite_sheet: Texture2D
@export var tile_size: Vector2i = Vector2i(16, 16)
@export var full_frame_coords: Vector2i = Vector2i(0, 0)   # red icon  -> full HP
@export var empty_frame_coords: Vector2i = Vector2i(1, 0)  # purple icon -> 0 HP
@export var icon_scale: float = 4.0  # pixel-art upscale factor

## Fraction of the tile (0-1) that's just transparent padding above/below
## the actual art. Measured for this sheet: the icon only draws on rows
## 1-13 of its 16px tile, so top ~0.06 and bottom ~0.12 are empty space.
## Excluding that padding keeps the wipe proportional to what you can
## actually see, instead of "50%" landing mostly in dead space.
@export_range(0.0, 1.0, 0.001) var content_top_margin: float = 0.035
@export_range(0.0, 1.0, 0.001) var content_bottom_margin: float = 0.55

@export var max_health: float = GameManager.max_player_health
@export var current_health: float = GameManager.player_health:
	set(v):
		current_health = clampf(v, 0.0, max_health)
		_update_fill()

var _full_icon: TextureRect
var _empty_icon: TextureRect
var _wipe_material: ShaderMaterial

const WIPE_SHADER_CODE := """
shader_type canvas_item;

uniform float fill_amount : hint_range(0.0, 1.0) = 1.0;
uniform float top_margin : hint_range(0.0, 1.0) = 0.0;
uniform float bottom_margin : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	// UV.y = 0 is the top of the icon, UV.y = 1 is the bottom.
	// Only the content_start..content_end band actually has visible art,
	// so the wipe threshold is measured within that band instead of the
	// full 0..1 tile, keeping it proportional to what's actually drawn.
	float content_start = top_margin;
	float content_end = 1.0 - bottom_margin;
	float cutoff = content_start + (1.0 - fill_amount) * (content_end - content_start);
	if (UV.y < cutoff) {
		tex_color.a = 0.0;
	}
	COLOR = tex_color;
}
"""


func _ready() -> void:
	_build_icon()
	current_health = GameManager.player_health
	GameManager.health_changed.connect(func(new_health): current_health = new_health)


func _build_icon() -> void:
	for c in get_children():
		c.queue_free()

	if sprite_sheet == null:
		push_warning("HealthIndicator: no sprite_sheet assigned.")
		return

	var icon_pixel_size := Vector2(tile_size) * icon_scale
	custom_minimum_size = icon_pixel_size

	var empty_atlas := AtlasTexture.new()
	empty_atlas.atlas = sprite_sheet
	empty_atlas.region = Rect2(
		empty_frame_coords.x * tile_size.x, empty_frame_coords.y * tile_size.y,
		tile_size.x, tile_size.y
	)

	var full_atlas := AtlasTexture.new()
	full_atlas.atlas = sprite_sheet
	full_atlas.region = Rect2(
		full_frame_coords.x * tile_size.x, full_frame_coords.y * tile_size.y,
		tile_size.x, tile_size.y
	)

	_empty_icon = _make_icon_rect(empty_atlas, icon_pixel_size)
	add_child(_empty_icon)

	_full_icon = _make_icon_rect(full_atlas, icon_pixel_size)
	add_child(_full_icon)

	var shader := Shader.new()
	shader.code = WIPE_SHADER_CODE
	_wipe_material = ShaderMaterial.new()
	_wipe_material.shader = shader
	_wipe_material.set_shader_parameter("top_margin", content_top_margin)
	_wipe_material.set_shader_parameter("bottom_margin", content_bottom_margin)
	_full_icon.material = _wipe_material


func _make_icon_rect(tex: Texture2D, pixel_size: Vector2) -> TextureRect:
	var rect := TextureRect.new()
	rect.texture = tex
	rect.stretch_mode = TextureRect.STRETCH_SCALE
	rect.custom_minimum_size = pixel_size
	rect.size = pixel_size
	rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST  # keep pixel art crisp
	return rect


func _update_fill() -> void:
	if _wipe_material == null:
		return
	var pct := current_health / max_health if max_health > 0.0 else 0.0
	_wipe_material.set_shader_parameter("fill_amount", clampf(pct, 0.0, 1.0))


func damage(amount: float) -> void:
	self.current_health -= amount


func heal(amount: float) -> void:
	self.current_health += amount
