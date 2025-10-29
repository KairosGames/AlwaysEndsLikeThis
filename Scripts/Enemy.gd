class_name Enemy extends CharacterBody2D

const GRAVITY := 98
const MOVE_SPEED := 100

@onready var player : Player = $"/root/Game/MainScene/Player"
@onready var rat: Node3D = $SubViewportParent/SubViewportContainer/SubViewport/Rat
@onready var animation_player: AnimationPlayer = $SubViewportParent/SubViewportContainer/SubViewport/Rat/AnimationPlayer
@onready var left_sprite_2d: Sprite2D = $LeftSprite2D
@onready var right_sprite_2d: Sprite2D = $RightSprite2D
@onready var vision_node: Node2D = $VisionNode
@onready var attack_area: Area2D = $VisionNode/AttackArea

var current_state : EnemyState = EnemyState.Idle
enum EnemyState {
	Idle,
	Walking,
	Fighting,
	Attacking
}

@onready var player_vision_ray_cast_2d: RayCast2D = $VisionNode/PlayerVisionRayCast2D
@onready var walking_vision_ray_cast_2d: RayCast2D = $VisionNode/WalkingVisionRayCast2D
@onready var walking_ray_cast_2d: RayCast2D = $WalkingRayCast2D

@export var health_bar: ProgressBar
var health: int = 100

var enter_state_time := 0

var current_idle_time := 0.0
var idle_max_time := 1000.0
var idle_min_time := 500.0

var walking_points : Array[Vector2]
var current_walking_point : Vector2
var max_walking_point_distance := 1000.0
var walking_point_steps := 100.0

func _ready() -> void:
	enter_state(EnemyState.Idle)
	health_bar.value = health
	health_bar.max_value = health

func _process(delta: float) -> void:
	handle_state(delta)
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += delta * GRAVITY
	
	move_and_slide()

func enter_state(state: EnemyState):
	match state:
		EnemyState.Idle:
			current_idle_time = randf_range(idle_min_time, idle_max_time)
			animation_player.play("IDLE")
		EnemyState.Walking:
			animation_player.play("WALK")
			update_walking_points()
			current_walking_point = get_next_walking_point()
			
		EnemyState.Fighting:
			animation_player.play("WALK")
		EnemyState.Attacking:
			velocity = Vector2.ZERO
			animation_player.play("ATTACK")
	enter_state_time = Time.get_ticks_msec()
	current_state = state

func handle_state(_delta: float)->void:
	if not is_on_floor(): return;
	match current_state:
		EnemyState.Idle:
			if is_on_floor() and Time.get_ticks_msec() - enter_state_time > current_idle_time:
				enter_state(EnemyState.Walking)
			if player_vision_ray_cast_2d.is_colliding():
				enter_state(EnemyState.Fighting)
				return;
		EnemyState.Walking:
			var moved = move_to_position(current_walking_point)
			if moved:
				current_walking_point = get_next_walking_point()
			if player_vision_ray_cast_2d.is_colliding():
				enter_state(EnemyState.Fighting)
				return;
		EnemyState.Fighting:
			if not player_vision_ray_cast_2d.is_colliding():
				enter_state(EnemyState.Walking)
				return;
			move_to_position(player.global_position, 0.0)
			if attack_area.has_overlapping_bodies():
				enter_state(EnemyState.Attacking)
		EnemyState.Attacking:
			if not animation_player.is_playing():
				enter_state(EnemyState.Idle)
				
func get_next_walking_point()->Vector2:
	return walking_points[0] if walking_points[0] != current_walking_point else walking_points[1]

	
func move_to_position(pos:Vector2, distance:float=100.0)->bool:
	velocity.x = sign(pos.x - global_position.x) * MOVE_SPEED
	vision_node.scale.x = sign(pos.x - global_position.x)
	rat.scale.z = -sign(pos.x - global_position.x)
	walking_vision_ray_cast_2d.target_position.x = 100.0
	return global_position.distance_to(pos) < distance

func deal_damages():
	if attack_area.has_overlapping_bodies():
		print("DEAL DAMAGES")
		player.take_damages(1)

func update_walking_points():
	var left_position = global_position
	for i in range(0, max_walking_point_distance / walking_point_steps):
		walking_ray_cast_2d.global_position = global_position + Vector2.LEFT * i * walking_point_steps
		walking_ray_cast_2d.force_raycast_update()
		if not walking_ray_cast_2d.is_colliding(): break
		walking_vision_ray_cast_2d.target_position.x = -i * walking_point_steps
		walking_vision_ray_cast_2d.force_raycast_update()
		if walking_vision_ray_cast_2d.is_colliding(): 
			left_position = walking_vision_ray_cast_2d.get_collision_point()
			break
		left_position = global_position + Vector2.LEFT * i * walking_point_steps
		left_sprite_2d.global_position = left_position
		
	var right_position = global_position
	for i in range(0, max_walking_point_distance / walking_point_steps):
		walking_ray_cast_2d.global_position = global_position + Vector2.RIGHT * i * walking_point_steps
		walking_ray_cast_2d.force_raycast_update()
		if not walking_ray_cast_2d.is_colliding(): break
		walking_vision_ray_cast_2d.target_position.x = i * walking_point_steps
		walking_vision_ray_cast_2d.force_raycast_update()
		if walking_vision_ray_cast_2d.is_colliding():
			right_position = walking_vision_ray_cast_2d.get_collision_point()
			break
		right_position = global_position + Vector2.RIGHT * i * walking_point_steps
		right_sprite_2d.global_position = right_position
	
	walking_points = [left_position, right_position]

@onready var squeak_audio: AudioStreamPlayer = $SqueakAudio
@onready var rat_hit_audio: AudioStreamPlayer = $RatHitAudio

func take_damages(damages: int):
	health -= damages
	health_bar.value = health

	if health <= 0: die()
	else: 
		rat_hit_audio.pitch_scale = randf_range(0.8, 1.2)
		rat_hit_audio.play()
		animation_player.play("HIT")
		enter_state(EnemyState.Fighting)
		
	
func die():
	squeak_audio.pitch_scale = randf_range(0.8, 1.2)
	squeak_audio.play()
	animation_player.play("DEATH")
	await animation_player.animation_finished
	queue_free()
