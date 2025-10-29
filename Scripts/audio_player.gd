extends AudioStreamPlayer

@export var MusicPlayer: AudioStreamPlayer 
@export var SfxPlayer: AudioStreamPlayer 
@export var MasterPlayer: AudioStreamPlayer 

const boss_music = preload("res://Music/MusiqueBoss_8BIT.mp3")
const level_music = preload("res://Music/MusiqueOverworld_8BIT.mp3")
const musique_lose = preload("res://Music/musique_lose.wav")

func _play_music(player: AudioStreamPlayer, music: AudioStream, volume: float = -10.0):
	# Si le joueur passé est déjà en train de jouer cette musique, on s'arrête
	if player.stream == music and player.playing:
		return
	
	player.stop()
	player.stream = music
	player.volume_db = volume
	player.play()
		

func Call_play_music(music: AudioStream,volume: float = -10.0):
	# Joue la musique de niveau (volume par défaut : -10.0 dB)
	_play_music(MusicPlayer, music, volume)

func play_music_overworld() -> void:
	Call_play_music(level_music)
	pass

func play_music_boss() -> void:
	Call_play_music(boss_music)
	pass

func stop_music():
	stop()
