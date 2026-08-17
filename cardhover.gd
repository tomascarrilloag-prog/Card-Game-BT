@tool

extends Control

@export var hover_offset_y: float = -30.0
@export var tween_duration: float = 0.15
@export var card_texture: Texture2D # <-- NUEVA VARIABLE

var default_position: Vector2 = Vector2.ZERO
var original_z_index: int = 0
var tween: Tween

func _ready() -> void:
	# <-- NUEVO: Le pasamos la imagen al nodo Sprite si existe
	if card_texture and has_node("Sprite"):
		$Sprite.texture = card_texture
		
	original_z_index = z_index
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	z_index = 100
	if tween and tween.is_running():
		tween.kill()
		
	tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var offset := Vector2(0, hover_offset_y).rotated(rotation)
	tween.tween_property(self, "position", default_position + offset, tween_duration)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), tween_duration)

func _on_mouse_exited() -> void:
	z_index = original_z_index
	if tween and tween.is_running():
		tween.kill()
		
	tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", default_position, tween_duration)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), tween_duration)
