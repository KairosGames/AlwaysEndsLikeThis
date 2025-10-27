class_name Entity
extends CharacterBody2D
# Script Parent ennemi & joueur
@export var MaxHealth : int =  100
var CurrentHealth : int
@export var  Hitbox : Area2D
@export var Damage : int 
@export var Speed : int 
@export var Armor : int
func Setup():
	CurrentHealth = MaxHealth
	if Hitbox == null :
		print("Error no hitbox assigned")
	# **CONNEXION DU SIGNAL**
	# Connecte le signal 'body_entered' de l'Area2D à la fonction '__on_hitbox_body_entered'
	if not Hitbox.body_entered.is_connected(Callable(self,"_on_hitbox_body_entered")):
		Hitbox.body_entered.connect(_on_hitbox_body_entered)

func _ready():
	Setup()
func _on_hitbox_body_entered(body: Node2D):
		HandleCollision(body)

# La fonction que les enfants devront surcharger.
func HandleCollision(body: Node2D):
	print("Collision générique détectée par Entity avec : ", body.name)


func ReceiveDamage(ReceivedDamage : int):
	CurrentHealth -= ReceivedDamage
	print("Vie Restante : ", CurrentHealth)
	if CurrentHealth <= 0 :
		queue_free()
		
