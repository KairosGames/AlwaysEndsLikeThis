class_name Game extends Node2D
@onready var main_scene: MainScene = $MainScene
@onready var scene_transition: ScreenTransition = $SceneTransition

const DIALOG_BOX = preload("res://Prefabs/DialogBox.tscn")
var active_dialogbox : DialogBox

func _ready():
	GlobalAudioStreamPlayer.Call_play_music(GlobalAudioStreamPlayer.level_music)
	scene_transition.reset_transition_screen()

func new_dialogbox(name_text, text, is_fairy:=true) -> DialogBox:
	if active_dialogbox: active_dialogbox.queue_free()
	var dialogbox := DIALOG_BOX.instantiate() as DialogBox
	add_child(dialogbox)
	dialogbox.set_name_label(name_text)
	dialogbox.write_text(text, is_fairy)
	active_dialogbox = dialogbox
	return dialogbox
