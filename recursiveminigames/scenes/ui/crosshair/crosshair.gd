extends Control

@onready var crosshair_text: Label = %CrosshairText
@onready var crosshair_image: TextureRect = %CrosshairImage


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.crosshair_changed.connect(_on_crosshair_changed)
	SignalBus.crosshair_text_changed.connect(_on_crosshair_text_changed)
	SignalBus.crosshair_visibility_changed.connect(_on_crosshair_visible_changed)


func _on_crosshair_changed(texture: Texture2D):
	crosshair_image.texture = texture
	crosshair_image.queue_redraw()


func _on_crosshair_text_changed(text: String):
	crosshair_text.text = text


func _on_crosshair_visible_changed(mode: bool):
	self.visible = mode
