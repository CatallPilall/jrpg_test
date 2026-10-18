extends BaseAudioPlayer

const MUSIC_PATH : String = "res://audio/music/"


func _load_sound() -> void:
	var suffix : String = ".ogg"
	for music_file in DirAccess.open(MUSIC_PATH).get_files():
		if music_file.ends_with(suffix):
			var music_stream = load(MUSIC_PATH + music_file)
			sound[music_file.trim_suffix(suffix)] = music_stream
			ConsoleLog.DEBUG("Loaded music file: " + str(music_file))


func _emit_signal(type_to_emit : PlayerEmitSignalType) -> void:
	match type_to_emit:
		PlayerEmitSignalType.STARTED:
			EventBus.emit_signal_log(EventBus.song_started)
		PlayerEmitSignalType.ENDED:
			EventBus.emit_signal_log(EventBus.song_ended)
		PlayerEmitSignalType.PAUSED:
			EventBus.emit_signal_log(EventBus.song_paused)
		PlayerEmitSignalType.RESUMED:
			EventBus.emit_signal_log(EventBus.song_resumed)
