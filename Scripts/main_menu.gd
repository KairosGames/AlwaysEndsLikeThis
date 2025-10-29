class_name main_menu
extends Control

@onready var game: Game = $/root/Game
@onready var start: Button = $VBoxContainer/Start
@onready var options: Button = $VBoxContainer/Options
@onready var credits: Button = $VBoxContainer/Credits
@onready var exit: Button = $VBoxContainer/Exit
@onready var camera_2d: Camera2D = $Background/Camera2D
@onready var credit_menu: Control = $Menus/CreditMenu
@onready var setting_menu: Control = $Menus/SettingMenu
@onready var credit_menu_button: Button = $CreditMenu/CreditMenuButton
@onready var setting_menu_back_button: Button = $SettingMenu/SettingMenuBackButton

func _ready():
	start.pressed.connect(func():
		set_visible(false)
		game.main_scene.current_world_index = 0
		game.main_scene.load_world(game.main_scene.worlds[0])
	)
	options.pressed.connect(func():
		setting_menu.set_visible(true)
	)
	credits.pressed.connect(func():
		credit_menu.set_visible(true)
	)
	credit_menu_button.pressed.connect(func():
		credit_menu.set_visible(false)
	)
	setting_menu_back_button.pressed.connect(func():
		setting_menu.set_visible(false)
	)
