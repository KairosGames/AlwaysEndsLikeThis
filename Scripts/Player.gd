class_name Player extends CharacterBody2D

@onready var game: Game = $/root/Game

@export_category("References")
@export var ray_cast: RayCast2D
@export var player3D: Node3D
@export var animation_player: AnimationPlayer

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


func _process(_delta: float) -> void:
	get_input()


func _physics_process(delta: float) -> void:
	move_player(delta)


func get_input():
	move_dir = Input.get_vector("Left", "Right", "Up", "Down")
	if move_dir.length() < 0.2:
		move_dir = Vector2.ZERO
	if Input.is_action_just_pressed("Jump"):
		jump()


func move_player(delta: float):
	if not game.main_scene.current_world: return;
	if game.active_dialogbox: return;
	handle_acceleration(delta)
	handle_gravity(delta)
	set_player3D_rotation()
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
		if not is_controlled_by_player: return
		velocity.y = -jump_strength


func set_player3D_rotation():
	if velocity.x > 0:
		player3D.global_rotation.y = -80.0
	elif velocity.x < 0:
		player3D.global_rotation.y = 80.0
	if velocity.x == 0.0:
		animation_player.play("IDLE")
		return
	animation_player.speed_scale = 3.0 * abs(velocity.x/max_speed)
	animation_player.play("WALK")

func take_damages(damages: int):
	health -= damages
	if health <= 0:
		health = 0
		is_alive = false
		is_controlled_by_player = false
		die()


func die():
	print("player is dead")
