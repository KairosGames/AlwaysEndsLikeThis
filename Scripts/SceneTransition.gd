class_name ScreenTransition extends CanvasLayer
@onready var texture_rect: TextureRect = $Container/TextureRect
@onready var container: Control = $Container
@export var transition_duration := 1.0
@export var waiting_time := 1.0
@export var texture_color:Color = "#051129"

func show_transition():
	texture_rect.pivot_offset.x = texture_rect.size.x / 2.0
	texture_rect.pivot_offset.y = 0
	texture_rect.size.y = 0
	texture_rect.size.x = container.size.x
	texture_rect.modulate.a = 1.0
	get_tree().create_tween().tween_property(texture_rect, "size:y", container.size.y, transition_duration)
	await get_tree().create_timer(transition_duration + waiting_time).timeout


func hide_transition():
	get_tree().create_tween().tween_property(texture_rect, "modulate:a", 0, transition_duration)
	await get_tree().create_timer(transition_duration).timeout
