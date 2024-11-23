extends Button
class_name MainMenuButton

signal selected

@export var translation_id: String

@onready var point_sound: AudioStreamPlayer = $PointSound
@onready var select_sound: AudioStreamPlayer = $SelectSound
@onready var blinker: AnimationPlayer = $Blinker

func _ready() -> void:
    text = tr(translation_id)

func reset_animation() -> void:
    blinker.play("RESET")

func _on_mouse_entered() -> void:
    grab_focus()

func _on_focus_entered() -> void:
    text = "\u203a " + tr(translation_id) + " \u2039"
    point_sound.play()

func _on_focus_exited() -> void:
    text = tr(translation_id)

func _on_pressed() -> void:
    blinker.play("blink")
    select_sound.play()
    selected.emit()
