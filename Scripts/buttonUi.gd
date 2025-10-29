extends Button
@onready var click = $Click
@onready var hover = $Hover
@export var node_to_set : Control
@export var _set_node_visible : bool

@export var is_start_button : bool
@export var is_exit_button : bool

@export var Menu : main_menu

func _on_pressed():
	click.play()
	if node_to_set != null:
		if _set_node_visible == true : 
			node_to_set.visible = true
		else :
			node_to_set.visible = false
	else  :
		if is_start_button :
			_load_scene(Menu.GameScene)
		if is_exit_button :
			get_tree().quit()
	

func _load_scene(GameScene):
	get_tree().change_scene_to_packed(GameScene)

func _on_mouse_entered():
	hover.play()
