class_name PlayerCamera2D extends Node2D

@export var weight_lerp: float = 0.5

@export var target: Node2D
@export var camera: Camera2D


func _ready() -> void:
	global_position = target.global_position


func _physics_process(_delta: float) -> void:
	if target != null:
		global_position = lerp(global_position, target.global_position, weight_lerp)
