class_name BossArea extends Area2D

@onready var boss: Node2D = $Boss
@onready var game: Game = $/root/Game
@onready var player: Player = $/root/Game/MainScene/Player
@onready var camera: PlayerCamera2D = $/root/Game/MainScene/PlayerCamera2D
@onready var boss_camera_target: Node2D = $BossCameraTarget
@onready var world: World = $".."
@onready var animation_player: AnimationPlayer = $Boss/SubViewportContainer/SubViewport/BossRat01/AnimationPlayer

func _ready():
	body_entered.connect(func(_body: Node): trigger_boss_animation())
	await get_tree().create_timer(1.0).timeout
	monitoring = true
	
func trigger_boss_animation():
	camera.target = null
	get_tree().create_tween().tween_property(camera, "global_position", boss_camera_target.global_position, 1)
	await get_tree().create_timer(1).timeout
	
	var dialogbox = game.new_dialogbox("BOSS", world.boss_text)
	dialogbox.dialog_ended.connect(func():
		player.is_controlled_by_player = false
		create_tween().tween_property(boss, "global_position:x", player.global_position.x + 300.0, 0.5)
		await get_tree().create_timer(0.4).timeout
		animation_player.play("ATTACK")
		await animation_player.animation_finished
		
		await game.scene_transition.show_transition()
		await game.main_scene.load_next_world()
		camera.target = player
	)
