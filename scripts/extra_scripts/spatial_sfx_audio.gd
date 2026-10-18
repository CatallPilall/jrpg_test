extends Node2D


enum AUDIO_BUS {
	MASTER,
	MUSIC,
	SFX,
	VOICE,
	TEXT
}

@onready var audio_player: AudioStreamPlayer2D = $spatial_player

## Die Soundeffects, die man abgespielt haben will
@export var sound_effects : Array[AudioStream]

## Soll der Audioeffect in der Reihenfolge abgespielt werden, wie sie in der Liste stehen?
## Ansonsten wird ein zufälliger Audioeffect aus der Liste abgespielt.
@export var play_in_order : bool = false

## Soll sich der Audioeffect wiederholen, wenn er fertig ist?
@export var loop_audio_effects : bool = false
## Soll der Audioeffect automatisch abgespielt werden, wenn die Szene geladen wird?
@export var autoplay_on_ready : bool = false
## Soll der Audioeffect abgespielt werden, wenn ein Signal empfangen wird?
@export var play_on_signal : bool = false

## Lautstärke des Audioeffects (0.0 bis 1.0)
@export_range(0.0, 1.0, 0.01) var volume : float = 1.0
## Pitch des Audioeffects (0.5 bis 2.0) (2 ist doppelt so schnell und auch höher)
@export_range(0.5, 2.0, 0.01) var pitch_scale : float = 1.0

## Wie oft max. kann der Audioeffect abgespielt werden, bevor er gestoppt wird?
## (<= 0 heißt unendlich oft)
@export var max_play_count : int = 0
# ## Wie viele Audioeffekte können gleichzeitig abgespielt werden?
# @export var max_num_playable_sound_effetcs : int = 1

## Soll der Audioeffect zufällig in der Tonhöhe variieren? (0.0 bis 1.0) (1.0 heißt immer)
## Wenn dieses Value ungleich 0 ist, dann wird das Value "Pitch_Scale" oben drüber ignoriert
@export_range(0.0, 1.0, 0.01) var randomness_of_pitch : float = 1.0
## Wie stark soll sich der Pitch verändern? (0.0 bis 12.0) (In Oktaven max. hoch und runter)
## (0.0 heißt der pitch bleibt beim Pith_Scale Value oben drüber)
@export_range(0.0, 12.0, 0.01) var randomness_of_pitch_value : float = 2.0
## Mit was für einer Wahrscheinlichkeit soll der Audioeffect wiederholt werden? (0.0 bis 1.0) (1.0 heißt immer)
## Falls nicht abgespielt, dann wird solange gewartet wie der zuletzt abgespielte effekt lang dauert und wieder getestet, ob er abgespielt werden soll.
@export_range(0.0, 1.0, 0.01) var randomness_of_replay : float = 1.0
## Der AudioBus auf dem der Audioeffect abgespielt werden soll (MASTER, MUSIC, SFX, VOICE, TEXT)
@export var bus : AUDIO_BUS = AUDIO_BUS.SFX
## Die maximale Distanz in Pixeln, ab der der Audioeffect nicht mehr hörbar ist in pixeln
@export_range(0.0, 1000.0, 0.01) var distance_max_pixel : float = 100.0

var is_stopped : bool = false
var is_initialized : bool = false
var play_count : int = 0
var streamer : AudioStreamRandomizer = null
# var current_player_id : int = 0
# var previous_player_id : int = 0

func _ready() -> void:

	if sound_effects.size() == 0:
		ConsoleLog.WARNING("No sound effects assigned to " + self.get_name())
		return

	streamer = AudioStreamRandomizer.new()

	_init_player()

	if play_on_signal:
		EventBus.connect_function_with_signal(self, play_effect, EventBus.play_spatial_audio_effects)

	if autoplay_on_ready:
		_wait_to_play_effect()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _is_initialized() -> bool:
	if is_initialized:
		return true
	else:
		ConsoleLog.WARNING("AudioPlayer is not initialized")
		return false


func _init_player() -> void:
	var count : int = 0
	for sound_effect in sound_effects:
		streamer.add_stream(count, sound_effect)
		count += 1

	if play_in_order:
		streamer.playback_mode = AudioStreamRandomizer.PlaybackMode.PLAYBACK_SEQUENTIAL
	else:
		streamer.playback_mode = AudioStreamRandomizer.PlaybackMode.PLAYBACK_RANDOM_NO_REPEATS

	audio_player.stream = streamer

	audio_player.bus = _bus_to_string(bus)
	audio_player.volume_linear = volume
	audio_player.pitch_scale = pitch_scale
	# audio_player.max_polyphony = max_num_playable_sound_effetcs
	audio_player.max_polyphony = 1
	audio_player.max_distance = distance_max_pixel
	EventBus.connect_function_with_signal(self, _on_audio_effect_finished, audio_player.finished)
	ConsoleLog.DEBUG("AudioPlayer initialized")
	is_initialized = true


func _bus_to_string(bus_enum: AUDIO_BUS) -> String:
	match bus_enum:
		AUDIO_BUS.MASTER:
			return "Master"
		AUDIO_BUS.MUSIC:
			return "Music"
		AUDIO_BUS.SFX:
			return "SFX"
		AUDIO_BUS.VOICE:
			return "Voice"
		AUDIO_BUS.TEXT:
			return "Text"
		_:
			return "Master"


func _wait_to_play_effect() -> void:
	if not _is_initialized():
		return
	# ConsoleLog.DEBUG("Waiting to play effect again for " + self.get_name() + " with randomness_of_replay: " + str(randomness_of_replay))
	if int(randomness_of_replay * 100) >= 100:
		# ConsoleLog.DEBUG("Randomness of replay is 1 or higher, playing effect again for " + self.get_name())
		play_effect()
	else:
		# ConsoleLog.DEBUG("Randomness of replay is less than 1, waiting to play effect again for " + self.get_name())
		var wait_time = audio_player.stream.get_length()
		while not is_stopped:
			# if current_player_id == previous_player_id:
			# 	ConsoleLog.DEBUG("Player ID changed, stopping wait to play effect")
			# 	current_player_id += 1
			# 	return

			if int(randomness_of_replay * 100) >= randi() % 100:
				play_effect()
				break
			else:
				await get_tree().create_timer(wait_time).timeout
				# ConsoleLog.DEBUG("WAITED " + str(wait_time) + " seconds to play effect again for " + self.get_name())



func _on_audio_effect_finished() -> void:
	if not loop_audio_effects:
		return

	if is_stopped:
		return

	if max_play_count > 0 and play_count >= max_play_count:
		ConsoleLog.DEBUG("Max play count reached for " + self.get_name())
		is_stopped = true
		return

	play_count += 1

	# ConsoleLog.DEBUG("Audio effect finished for " + self.get_name() + ", play count: " + str(play_count))

	# player_id += 1
	# var current_player_id : int = player_id

	_wait_to_play_effect()


func stop_effect() -> void:
	audio_player.stop()
	is_stopped = true


func reset():
	is_stopped = false
	play_count = 0


func play_effect(_signal_key : int = -1) -> void:
	if not _is_initialized():
		return

	if is_stopped:
		return

	# previous_player_id = current_player_id

	var randomness_of_pitch_int = int(randomness_of_pitch * 100)

	if randomness_of_pitch_int > 0:
		if randi() % 100 < randomness_of_pitch_int:
			audio_player.stream.random_pitch_semitones = randomness_of_pitch_value
	else:
		audio_player.pitch_scale = 1.0

	audio_player.play()
