class_name World extends Node2D

@onready var game: Game = $/root/Game
@onready var player_spawn: Node2D = $PlayerSpawn

@export var player_health: int = 100
@export var player_attack: int = 10
@export_multiline var fairy_text: String = "Aventurier ! Te voilà. Le donjon qui t’attend n’est pas le plus simple, mais on m’a vanté tes talents dans tout le royaume… Je sais que ça sera un jeu d’enfant pour toi. / Viens à bout de ces lieux et des ennemis qui l’habitent, et amène moi le trésor que renferme le donjon… Tu seras richement récompensé. Courage !"
@export_multiline var boss_text: String = "Sois le bienvenu dans mon antre, voyageur. Tu as réussi à parvenir jusqu’à là. Sauras-tu faire preuve de la même ruse pour me battre et te montrer digne de mon trésor ? Je te souhaite bonne chance…"
