extends Control
@export var _start_button : Button
@export var _options_button :  Button
@export var _credits_button : Button
@export var _exit_button : Button
@onready var setting_menu = $Menus/SettingMenu
@onready var credit_menu = $Menus/CreditMenu
const GameScene = preload("res://Scenes/Game.tscn")

func _on_exit_pressed():
	get_tree().quit()


func _on_credits_pressed():
	credit_menu.visible = true 


func _on_options_pressed():
	setting_menu.visible = true


func _on_start_pressed():
	get_tree().change_scene_to_packed(GameScene)


func _on_back_button_pressed():
	credit_menu.visible = false


func _on_back_button_2_pressed():
	setting_menu.visible = false
