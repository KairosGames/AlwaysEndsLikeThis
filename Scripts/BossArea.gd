class_name BossArea extends Area2D
@onready var boss: Node2D = $Boss

@onready var game: Game = $/root/Game
@onready var player: Player = $/root/Game/MainScene/Player
@onready var camera: PlayerCamera2D = $/root/Game/MainScene/PlayerCamera2D
@onready var boss_camera_target: Node2D = $BossCameraTarget

func _ready():
	body_entered.connect(func(body: Node): trigger_boss_animation())

func trigger_boss_animation():
	camera.target = null
	get_tree().create_tween().tween_property(camera, "global_position", boss_camera_target.global_position, 1)
	await get_tree().create_timer(1).timeout
	var dialogbox = game.new_dialogbox("BOSS", "apdoja p/apzdojadz/aizdjapdij.../aizpjdad")
	dialogbox.dialog_ended.connect(func():
		get_tree().create_tween().tween_property(camera, "global_position", player.global_position, 1)
		await get_tree().create_timer(1).timeout
		camera.target = player
	)
