@tool
extends Control

@onready var button: TextureButton = $BoomButton
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	# Connect button signal
	button.pressed.connect(_on_button_pressed)
	
	# Load the audio file
	var audio_stream = load("res://addons/vine_boom/assets/vine-boom sfx.mp3")
	if audio_stream:
		audio_player.stream = audio_stream
	else:
		push_error("Vine Boom Button: Could not load audio file!")

func _on_button_pressed():
	# Play the sound
	if audio_player and audio_player.stream:
		audio_player.play()
		
		# Visual feedback - make button flash
		var original_modulate = button.modulate
		button.modulate = Color(1.5, 1.5, 1.5)
		await get_tree().create_timer(0.1).timeout
		button.modulate = original_modulate
