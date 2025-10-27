class_name  Player
extends "res://Scripts/HugoTestScript/Entity.gd"


func GetInput():
	var inputDirection = Input.get_vector("Left","Right","Up", "Down")
	var InputDirX = Vector2(inputDirection.x,0)
	velocity = InputDirX * Speed

func _physics_process(delta):
	GetInput()
	move_and_slide()
func HandleCollision(body: Node2D):
	if body is Ennemi:
		var ennemi = body as Ennemi
		var DamageToTake = ennemi.Damage
		ReceiveDamage(DamageToTake)
