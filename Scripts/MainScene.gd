class_name MainScene extends Node2D

@onready var player: Player = $Player
@onready var current_world: World = $World
@onready var player_camera_2d: PlayerCamera2D = $PlayerCamera2D

@export var worlds : Array[PackedScene]
var current_world_index = 0

func _ready() -> void:
	load_world(worlds[0])

func load_world(world: PackedScene):
	var new_world := world.instantiate() as World
	current_world.queue_free()
	add_child(new_world)
	current_world = new_world
	player.global_position = new_world.player_spawn.global_position
