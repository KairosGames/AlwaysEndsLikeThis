extends CharacterBody2D

const GRAVITY := 98
const MOVE_SPEED := 100

@onready var player : Player = $"/root/Game/MainScene/Player"
@onready var rat: Node3D = $SubViewportParent/SubViewportContainer/SubViewport/Rat
@onready var animation_player: AnimationPlayer = $SubViewportParent/SubViewportContainer/SubViewport/Rat/AnimationPlayer
@onready var left_sprite_2d: Sprite2D = $LeftSprite2D
@onready var right_sprite_2d: Sprite2D = $RightSprite2D

var current_state : EnemyState = EnemyState.Idle
enum EnemyState {
	Idle,
	Walking,
	Fighting,
	Attacking
}

@onready var enemy_ray_cast_2d_2: RayCast2D = $Vision/EnemyRayCast2D
@onready var vision_ray_cast_2d: RayCast2D = $Vision/VisionRayCast2D
@onready var walking_ray_cast_2d: RayCast2D = $WalkingRayCast2D

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
			var left_position = global_position.x
			for i in range(0, max_walking_point_distance / walking_point_steps):
				walking_ray_cast_2d.global_position = global_position + Vector2.LEFT * i * walking_point_steps
				walking_ray_cast_2d.force_raycast_update()
				if not walking_ray_cast_2d.is_colliding(): break;
				left_position = global_position + Vector2.LEFT * i * walking_point_steps
				left_sprite_2d.global_position = left_position
			var right_position = global_position.x
			for i in range(0, max_walking_point_distance / walking_point_steps):
				walking_ray_cast_2d.global_position = global_position + Vector2.RIGHT * i * walking_point_steps
				walking_ray_cast_2d.force_raycast_update()
				if not walking_ray_cast_2d.is_colliding(): break;
				right_position = global_position + Vector2.RIGHT * i * walking_point_steps
				right_sprite_2d.global_position = right_position
			walking_points = [left_position, right_position]
			current_walking_point = get_next_walking_point()
			
		EnemyState.Fighting:
			animation_player.play("WALK")
		EnemyState.Attacking:
			velocity = Vector2.ZERO
			animation_player.play("ATTACK")
	enter_state_time = Time.get_ticks_msec()
	current_state = state

func handle_state(delta: float)->void:
	if not is_on_floor(): return;
	match current_state:
		EnemyState.Idle:
			if is_on_floor() and Time.get_ticks_msec() - enter_state_time > current_idle_time:
				enter_state(EnemyState.Walking)
			if vision_ray_cast_2d.is_colliding():
				enter_state(EnemyState.Fighting)
				return;
		EnemyState.Walking:
			var moved = move_to_position(current_walking_point)
			if moved:
				current_walking_point = get_next_walking_point()
			if vision_ray_cast_2d.is_colliding():
				enter_state(EnemyState.Fighting)
				return;
		EnemyState.Fighting:
			if not vision_ray_cast_2d.is_colliding():
				enter_state(EnemyState.Walking)
				return;
			var moved = move_to_position(player.global_position, 200.0)
			if moved: enter_state(EnemyState.Attacking)
		EnemyState.Attacking:
			if not animation_player.is_playing():
				enter_state(EnemyState.Idle)
				
func get_next_walking_point()->Vector2:
	walking_points.sort_custom(func(a,b): return global_position.distance_to(a) > global_position.distance_to(b))
	return walking_points[0]
	
func move_to_position(pos:Vector2, distance:float=100.0)->bool:
	velocity.x = sign(pos.x - global_position.x) * MOVE_SPEED
	vision_ray_cast_2d.scale.x = sign(pos.x - global_position.x)
	rat.scale.z = -sign(pos.x - global_position.x)
	return global_position.distance_to(pos) < distance
