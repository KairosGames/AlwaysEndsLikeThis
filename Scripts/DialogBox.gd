class_name DialogBox extends CanvasLayer

@onready var label: Label = $Container/Control/Label
@onready var arrow: TextureRect = $Container/Control/ArrowControl/Arrow
@onready var name_label: Label = $Container/Control/MarginContainer/NameLabel
@onready var fairy_audio: AudioStreamPlayer = $FairyAudio
@onready var boss_audio: AudioStreamPlayer = $BossAudio

func set_name_label(value: String):
	name_label.text = value
	
var texts : PackedStringArray
var current_text_index := 0
var is_ended = false
func write_text(text: String, is_fairy:=true):
	texts = text.split("/")
	_write_text(texts[0], fairy_audio if is_fairy else boss_audio)
	dialog_input.connect(func():
		if is_ended: return;
		if is_writing_dialog: 
			dialog_speed = 5.0
			return
		current_text_index += 1
		if current_text_index >= texts.size():
			is_ended = true
			dialog_ended.emit()
			await get_tree().create_timer(0.5).timeout
			queue_free()
			return;
		_write_text(texts[current_text_index], fairy_audio if is_fairy else boss_audio)
	)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DialogInput"): dialog_input.emit()

var speed = 50.0
var dialog_speed := 1.0
var is_writing_dialog := false
func _write_text(text: String, audio: AudioStreamPlayer):
	dialog_speed = 1.0
	label.text = ""
	is_writing_dialog = true
	for char in text:
		if char == " ":
			audio.pitch_scale = randf_range(0.8, 1.2)
			audio.play()
			await get_tree().create_timer(2.0 / speed / dialog_speed).timeout
		if char == ".": await get_tree().create_timer(4.0 / speed / dialog_speed).timeout
		await get_tree().create_timer(1.0 / speed / dialog_speed).timeout
		label.text += char
	
	is_writing_dialog = false

func _process(delta: float) -> void:
	arrow.visible = not is_writing_dialog
	arrow.position.y = sin(Time.get_ticks_msec() / 1000.0 * TAU) * 5.0

signal dialog_ended
signal dialog_input
