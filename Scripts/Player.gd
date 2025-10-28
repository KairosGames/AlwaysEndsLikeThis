class_name Player extends CharacterBody2D


@export var max_speed: float = 500.0
@export var acceleration: float = 1000.0
@export var braking_strength: float = 3000.0

var move_dir: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	get_input()
	move_player(delta)


func get_input():
	move_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if move_dir.length() < 0.2:
		move_dir = Vector2.ZERO


func move_player(delta: float):
	handle_acceleration(delta)
	move_and_slide()


func handle_acceleration(delta: float):
	var dir: float = 1.0 if velocity.x >= 0.0 else -1.0
	if move_dir.length() != 0:
		velocity.x += move_dir.x * acceleration * delta
		if velocity.normalized().x != move_dir.normalized().x:
			velocity.x -= braking_strength * dir * delta
		if velocity.x * dir > max_speed:
			velocity.x = max_speed * dir
	else:
		velocity.x -= braking_strength * dir * delta
		if velocity.x * dir < 0.0:
			velocity.x = 0.0
