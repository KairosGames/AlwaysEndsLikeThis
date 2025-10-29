extends Button
@onready var click = $Click
@onready var hover = $Hover

@export var Menu : main_menu

var hovered:=false

func _ready():
	mouse_entered.connect(func():
		hover.play()
		hovered = true
	)
	mouse_exited.connect(func():
		hovered = false
	)
	pressed.connect(func():
		click.play()
	)

func _load_scene(GameScene):
	get_tree().change_scene_to_packed(GameScene)

func _process(delta: float) -> void:
	scale = lerp(scale, (1.1 if hovered else 1.0) * Vector2.ONE, delta * 10.0)
	pivot_offset = size / 2.0
