class_name DialogBox extends CanvasLayer

@onready var label: Label = $Container/Control/Label
@onready var arrow: TextureRect = $Container/Control/ArrowControl/Arrow

func _ready():
	write_text("Mais c’est pas possible, comment ça se fait qu’il te batte à chaque fois ?/Je n’ai JAMAIS vu ça !/Sans vouloir remettre en doute tes compétences, tu es sûr que tu te sens capable de continuer ?... /Prends cette grosse épée, on ne fait pas mieux dans la région, je suis sûr que c’est ce qu’il te faut."
)

var texts : PackedStringArray
var current_text_index := 0
func write_text(text: String):
	texts = text.split("/")
	_write_text(texts[0])
	dialog_input.connect(func():
		if is_writing_dialog: 
			dialog_speed = 5.0
			return
		current_text_index += 1
		if current_text_index >= texts.size():
			dialog_ended.emit()
			queue_free()
			return;
		_write_text(texts[current_text_index])
	)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DialogInput"): dialog_input.emit()

var speed = 50.0
var dialog_speed := 1.0
var is_writing_dialog := false
func _write_text(text: String):
	dialog_speed = 1.0
	label.text = ""
	is_writing_dialog = true
	for char in text:
		if char == " ": await get_tree().create_timer(2.0 / speed / dialog_speed).timeout
		if char == ".": await get_tree().create_timer(4.0 / speed / dialog_speed).timeout
		await get_tree().create_timer(1.0 / speed / dialog_speed).timeout
		label.text += char
	
	is_writing_dialog = false

func _process(delta: float) -> void:
	arrow.visible = not is_writing_dialog
	arrow.position.y = sin(Time.get_ticks_msec() / 1000.0 * TAU) * 5.0

signal dialog_ended
signal dialog_input
