class_name BossArea extends Area2D
@onready var boss: Node2D = $Boss

@onready var player: Player = $/root/Game/MainScene/Player
@onready var camera: PlayerCamera2D = $/root/Game/MainScene/PlayerCamera2D

func _ready():
	body_entered.connect(func(body: Node): trigger_boss_animation())

func trigger_boss_animation():
	camera.target = null
	get_tree().create_tween().tween_property(camera, "global_position", boss.global_position, 1)
	await get_tree().create_timer(1).timeout
	camera.target = player
	pass
