class_name Fairy extends Node2D

@onready var game: Game = $/root/Game

@export var target: Node2D

var first_pos: Vector2
var is_at_target: bool = false
var has_to_return: bool = false


func _ready() -> void:
	first_pos = global_position


func _process(_delta: float) -> void:
	if not is_at_target:
		var dist_vec: Vector2 = target.global_position - global_position
		if (target.global_position - global_position).length() > 200.0:
			global_position = lerp(global_position, target.global_position - (dist_vec.normalized() * 190), 0.008)
		else:
			is_at_target = true
			var dialogbox = game.new_dialogbox("FAIRY", game.main_scene.current_world.fairy_text)
			dialogbox.dialog_ended.connect(func():
				game.main_scene.player.is_controlled_by_player = true
				has_to_return = true
			)
		return
	if has_to_return:
		global_position = lerp(global_position, first_pos, 0.004)
