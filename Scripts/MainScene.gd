class_name MainScene extends Node2D

@onready var player: Player = $Player
@onready var current_world: World = $World
@onready var player_camera_2d: PlayerCamera2D = $PlayerCamera2D

@export var worlds : Array[PackedScene]

func load_world(world: World):
	current_world.queue_free()
	add_child(world)
	current_world = world
	player.global_position = world.player_spawn.global_position
	
