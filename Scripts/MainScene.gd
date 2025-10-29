class_name MainScene extends Node2D

@onready var game: Game = $/root/Game
@onready var player: Player = $Player
@onready var current_world: World = $World
@onready var player_camera_2d: PlayerCamera2D = $PlayerCamera2D

@export var worlds : Array[PackedScene]
var current_world_index = 0

func load_next_world():
	current_world_index += 1
	load_world(worlds[current_world_index])

func load_world(world: PackedScene):
	player.is_controlled_by_player = false
	player.move_dir = Vector2.ZERO
	await game.scene_transition.show_transition()
	var new_world := world.instantiate() as World
	current_world.queue_free()
	current_world = new_world
	add_child(new_world)
	player.global_position = new_world.player_spawn.global_position
	game.scene_transition.hide_transition()
	player.set_player_stats(current_world.player_health, current_world.player_attack)
