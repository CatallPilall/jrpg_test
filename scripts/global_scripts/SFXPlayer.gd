extends BaseAudioPlayer

const EFFECTS_PATH : String = "res://audio/effects/"


func _load_sound() -> void:
	var suffix : String = ".wav"
	for music_file in DirAccess.open(EFFECTS_PATH).get_files():
		if music_file.ends_with(suffix):
			var music_stream = load(EFFECTS_PATH + music_file)
			sound[music_file.trim_suffix(suffix)] = music_stream
			ConsoleLog.DEBUG("Loaded music file: " + str(music_file))


func _emit_signal(type_to_emit : PlayerEmitSignalType) -> void:
	match type_to_emit:
		PlayerEmitSignalType.STARTED:
			EventBus.emit_signal_log(EventBus.sfx_started)
		PlayerEmitSignalType.ENDED:
			EventBus.emit_signal_log(EventBus.sfx_ended)
		PlayerEmitSignalType.PAUSED:
			EventBus.emit_signal_log(EventBus.sfx_paused)
		PlayerEmitSignalType.RESUMED:
			EventBus.emit_signal_log(EventBus.sfx_resumed)
