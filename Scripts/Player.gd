class_name Player extends CharacterBody2D

@export_category("References")
@export var ray_cast: RayCast2D

@export_category("Player Movement")
@export var max_speed: float = 500.0
@export var acceleration: float = 1000.0
@export var braking_strength: float = 3000.0

@export_category("Gravity")
@export var max_fall_speed: float = 2000.0
@export var gravity: float = 4000.0

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
	handle_gravity(delta)
	move_and_slide()


func handle_acceleration(delta: float):
	var dir: float = 1.0 if velocity.x >= 0.0 else -1.0
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
	if ray_cast.is_colliding():
		if velocity.y < 0.0:
			velocity.y -= braking_strength
			if velocity.y > 0.0: velocity.y = 0.0
		return
	
	velocity.y += gravity * delta
	if velocity.y < -max_fall_speed:
		velocity.y = -max_fall_speed
