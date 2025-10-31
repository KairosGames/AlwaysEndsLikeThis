class_name Player extends CharacterBody2D

@onready var game: Game = $/root/Game

@export_category("References")
@export var ray_cast: RayCast2D
@export var player3D: Node3D
@export var animation_player: AnimationPlayer
@export var health_bar: ProgressBar
@export var damage_area:Area2D
@export var damage_shape: CollisionShape2D

@export_category("Player Movement")
@export var max_speed: float = 500.0
@export var acceleration: float = 1000.0
@export var braking_strength: float = 3000.0
@export var jump_strength: float = 1200.0

@export_category("Gravity")
@export var max_fall_speed: float = 2000.0
@export var gravity: float = 4000.0

@export_category("Gameplay")
@export var health: int = 100
@export var strength_attack: int = 10

var move_dir: Vector2 = Vector2.ZERO
var is_alive: bool = true
var is_controlled_by_player: bool = false
var is_waiting_animation: bool = false

@onready var sword_hit_audio: AudioStreamPlayer = $SwordHitAudio
@onready var damage_audio: AudioStreamPlayer = $DamageAudio
@onready var jump_audio: AudioStreamPlayer = $JumpAudio

func _process(_delta: float) -> void:
	get_input()

func _physics_process(delta: float) -> void:
	move_player(delta)


func set_player_stats(p_health: int, p_attack: int):
	health = p_health
	strength_attack = p_attack
	health_bar.max_value = health
	health_bar.value = health


func get_input():
	move_dir = Input.get_vector("Left", "Right", "Up", "Down")
	if move_dir.length() < 0.2:
		move_dir = Vector2.ZERO
	if Input.is_action_just_pressed("Jump"):
		jump()
	if Input.is_action_just_pressed("Attack"):
		attack()


func move_player(delta: float):
	if not game.main_scene.current_world: return;
	if game.active_dialogbox: return;
	handle_acceleration(delta)
	handle_gravity(delta)
	set_player3D()
	move_and_slide()


func handle_acceleration(delta: float):
	var dir: float = 1.0 if velocity.x >= 0.0 else -1.0
	if not is_controlled_by_player: return
	if move_dir.length() != 0:
		velocity.x += move_dir.x * acceleration * delta
		if (velocity.x * Vector2.RIGHT).normalized().x != (move_dir.x * Vector2.RIGHT).normalized().x:
			velocity.x -= braking_strength * dir * delta
		if velocity.x * dir > max_speed:
			velocity.x = max_speed * dir
		return
	
	velocity.x -= braking_strength * dir * delta
	if velocity.x * dir < 0.0:
		velocity.x = 0.0


func handle_gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y < -max_fall_speed:
			velocity.y = -max_fall_speed

func jump():
	if is_on_floor():
		if not is_controlled_by_player or game.active_dialogbox or not is_alive: return
		velocity.y = -jump_strength
		is_waiting_animation = true
		animation_player.speed_scale = 1.5
		animation_player.play("JUMP_IN_PLACE")
		jump_audio.pitch_scale = randf_range(0.9, 1.1)
		jump_audio.play()
		await get_tree().create_timer(1.0417 / 1.5).timeout
		is_waiting_animation = false


func set_player3D():
	if not is_alive: return
	if velocity.x > 0:
		player3D.global_rotation.y = -80.0
		if damage_shape.position.x < 0 : damage_shape.position.x = -damage_shape.position.x
	elif velocity.x < 0:
		player3D.global_rotation.y = 80.0
		if damage_shape.position.x > 0 : damage_shape.position.x = -damage_shape.position.x
	if velocity.x == 0.0 && not is_waiting_animation:
		animation_player.play("IDLE")
		return
	if not is_waiting_animation:
		animation_player.speed_scale = 3.0 * abs(velocity.x/max_speed)
		animation_player.play("WALK")



func take_damages(damages: int):
	health -= damages
	if health <= 0:
		health = 0
		is_controlled_by_player = false
		die()
		return
	health_bar.value = health
	damage_audio.pitch_scale = randf_range(0.8, 1.2)
	damage_audio.play()

func attack():
	if is_waiting_animation or game.active_dialogbox or not is_controlled_by_player: return
	is_waiting_animation = true
	animation_player.speed_scale = 3.0
	animation_player.play("ATTACK")
	sword_hit_audio.play()
	await get_tree().create_timer(0.5/3.0).timeout
	var enemies: Array[Node2D] = damage_area.get_overlapping_bodies()
	for enemy in enemies:
		if enemy is Enemy:
			var en = enemy as Enemy
			en.take_damages(strength_attack)
	await get_tree().create_timer((1.0417 - 0.5)/3.0).timeout
	is_waiting_animation = false


func die():
	if is_alive:
		is_alive = false
		animation_player.speed_scale = 2.0
		animation_player.play("DEATH")
		health_bar.value = 0
		await get_tree().create_timer(1.0).timeout
		await game.scene_transition.show_transition()
		game.main_scene.load_world(game.main_scene.worlds[game.main_scene.current_world_index])
		is_alive = true
