class_name Game extends Node2D
@onready var main_scene: MainScene = $MainScene

const DIALOG_BOX = preload("res://Prefabs/DialogBox.tscn")

func new_dialogbox(name_text, text) -> DialogBox:
	var dialogbox := DIALOG_BOX.instantiate() as DialogBox
	add_child(dialogbox)
	dialogbox.set_name_label(name_text)
	dialogbox.write_text(text)
	return dialogbox
