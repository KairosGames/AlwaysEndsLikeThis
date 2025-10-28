extends Control
class_name DialogueSystem
@export var _text : RichTextLabel
var current_dialogue : int = 0
@export var dialogues_list : Array[String]

func _ready():
	_set_text()

func _set_text():
	if visible :
		_text.text = dialogues_list[current_dialogue]
	

func _end_dialogue():
	if current_dialogue < dialogues_list.size():
			current_dialogue += 1
			visible = false
			print("current_dialogue : " ,current_dialogue)
