extends Control
class_name OptionsMenu

signal back_requested

@onready var point_sound := $PointSound as AudioStreamPlayer
@onready var sfx_slider := $Center/VBoxContainer/SFX/Slider as HSlider
@onready var sfx_label := $Center/VBoxContainer/SFX/Label as Label

var sfx_index: int

func _ready() -> void:
    sfx_index = AudioServer.get_bus_index("Sound")
    reload()

func reload() -> void:
    grab_focus()

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        back_requested.emit()

func _on_h_slider_drag_ended(value_changed: bool) -> void:
    if value_changed:
        AudioServer.set_bus_volume_db(sfx_index, sfx_slider.value)
        point_sound.play()

func _on_h_slider_focus_entered() -> void:
    point_sound.play()
