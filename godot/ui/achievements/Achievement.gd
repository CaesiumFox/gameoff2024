@tool
extends TextureRect
class_name AchievementBox

signal request_description(achieved: bool)

@export var achieved: bool = false:
    get:
        return achieved
    set(new):
        achieved = new
        if image:
            image.visible = achieved

@export var zero: Color
@export var one: Color

@onready var image: TextureRect = $Image
@onready var point_sound: AudioStreamPlayer = $PointSound

func _on_focus_entered() -> void:
    modulate = one
    point_sound.play()
    request_description.emit(achieved)

func _on_focus_exited() -> void:
    modulate = zero

func _on_mouse_entered() -> void:
    grab_focus()
