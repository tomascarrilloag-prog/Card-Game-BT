@tool
extends Control

@export var card_spacing: float = 80.0:
	set(value):
		card_spacing = value
		reorganize_hand()

@export var max_rotation_deg: float = 15.0:
	set(value):
		max_rotation_deg = value
		reorganize_hand()

@export var vertical_arc: float = 20.0:
	set(value):
		vertical_arc = value
		reorganize_hand()

func _ready() -> void:
	resized.connect(reorganize_hand)
	# Solo conectamos cambios de hijos si estamos diseñando en el Editor
	if Engine.is_editor_hint():
		child_order_changed.connect(reorganize_hand)
	reorganize_hand()

func reorganize_hand() -> void:
	var cards := get_children()
	var card_count := cards.size()
	
	if card_count == 0:
		return

	for i in range(card_count):
		var card = cards[i] as Control
		if not card or not card.is_inside_tree():
			continue

		var c_size: Vector2 = card.size if card.size != Vector2.ZERO else Vector2(100, 140)

		# Calcula posición de -1.0 (izquierda) a 1.0 (derecha)
		var t: float = 0.0
		if card_count > 1:
			t = (float(i) / float(card_count - 1)) * 2.0 - 1.0

		var offset_x: float = t * (card_spacing * (card_count - 1) / 2.0)
		var offset_y: float = (t * t) * vertical_arc
		var card_rotation: float = deg_to_rad(t * max_rotation_deg)

		# Centrar el origen en la parte inferior de la carta
		card.pivot_offset = Vector2(c_size.x / 2.0, c_size.y * 1.3)
		
		# Centra las cartas respecto al ancho del HandContainer
		var center_x: float = size.x / 2.0
		card.position = Vector2(center_x + offset_x - (c_size.x / 2.0), offset_y)
		card.rotation = card_rotation
		
		if "default_position" in card:
			card.default_position = card.position
