@abstract
extends Node

class_name BaseAudioPlayer

enum PlayerEmitSignalType {
	STARTED,
	ENDED,
	PAUSED,
	RESUMED
}


var audio_player: AudioStreamPlayer
var sound : Dictionary[String, AudioStream] = {}
var loop : bool = false

@abstract func _load_sound() -> void
@abstract func _emit_signal(type_to_emit : PlayerEmitSignalType) -> void



func _play() -> void:
	audio_player.play()
	_emit_signal(PlayerEmitSignalType.STARTED)


func _stop() -> void:
	audio_player.stop()
	_on_audio_effect_finished()


func _on_audio_effect_finished() -> void:
	_emit_signal(PlayerEmitSignalType.ENDED)

	if loop:
		_play()


func init_vars(_player: AudioStreamPlayer) -> void:
	audio_player = _player
	EventBus.connect_function_with_signal(self, _on_audio_effect_finished, audio_player.finished)
	_load_sound()


func resume_sound() -> void:
	audio_player.stream_paused = false
	_emit_signal(PlayerEmitSignalType.RESUMED)


func pause_sound() -> void:
	audio_player.stream_paused = true
	_emit_signal(PlayerEmitSignalType.PAUSED)


func set_volume(volume: float):
	audio_player.volume_linear = volume


func get_volume() -> float:
	return audio_player.volume_linear


func is_playing_sound() -> bool:
	return audio_player.playing


func set_sound(sound_name : String) -> void:
	if sound.has(sound_name):
		audio_player.stream = sound[sound_name]
	else:
		ConsoleLog.ERROR("Sound not found: " + str(sound_name))


func set_loop(_loop_audio : bool) -> void:
	loop = _loop_audio


func get_loop() -> bool:
	return loop


func play_sound(sound_name : String, fade_time : float = -1) -> void:
	if sound.has(sound_name):
		if fade_time <= 0.0:
			set_sound(sound_name)
			_play()
		else:
			var tween : Tween = create_tween()
			tween.tween_property(audio_player, "volume_db", -80.0, fade_time)
			await tween.finished
			# tween.free()
			set_sound(sound_name)
			tween = create_tween()
			tween.tween_property(audio_player, "volume_db", 0.0, fade_time)
			_play()
			await tween.finished
			# tween.free()
	else:
		ConsoleLog.ERROR("Sound not found: " + str(sound_name))


func stop_sound(fade_time : float = -1) -> void:
	if not is_playing_sound():
		return

	if fade_time <= 0.0:
		_stop()
	else:
		var tween = create_tween()
		tween.tween_property(audio_player, "volume_db", -80.0, fade_time)
		await tween.finished
		# tween.free()
		_stop()
		audio_player.volume_db = 0.0
