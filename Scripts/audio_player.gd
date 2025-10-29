extends AudioStreamPlayer

@export var MusicPlayer: AudioStreamPlayer 
@export var SfxPlayer: AudioStreamPlayer 
@export var MasterPlayer: AudioStreamPlayer 

#const level_music = preload()
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

func play_SFX(sfx: AudioStream, volume: float = -10.0):
	# Joue un SFX avec un volume légèrement plus fort
	SfxPlayer.stream = sfx
	SfxPlayer.volume_db = volume
	SfxPlayer.play()
	# Le SfxPlayer étant déjà assigné au bus SFX dans l'éditeur, son volume sera automatiquement
	# modulé par le volume du Bus SFX défini par le Slider.
	
func play_game_music() -> void:
	#Call_play_music(level_music, -30.0)
	pass

func stop_music():
	stop()
