class_name Ennemi
extends "res://Scripts/HugoTestScript/Entity.gd"

func HandleCollision(body: Node2D):
	if body is Player:
		var ennemi = body as Player
		var DamageToTake = ennemi.Damage
		ReceiveDamage(DamageToTake)
