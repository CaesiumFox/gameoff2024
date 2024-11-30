extends Control
class_name OptionsMenu

signal back_requested

@export var modulate_select: Color
@export var modulate_deselect: Color

@onready var point_sound := $PointSound as AudioStreamPlayer
@onready var master_slider := %MasterSlider as HSlider
@onready var master_label := %MasterLabel as Label
@onready var sfx_slider := %SFXSlider as HSlider
@onready var sfx_label := %SFXLabel as Label
@onready var music_slider := %MusicSlider as HSlider
@onready var music_label := %MusicLabel as Label
@onready var full_screen := %FullScreen as CheckButton
@onready var language_selection := %LanguageSelection as LanguageSelectionButton

@onready var reset_button := %ResetButton as Button
@onready var reset_progress := %ResetButton/Progress as ProgressBar
@onready var reset_timer := %ResetButton/Timer as Timer

var master_index: int
var sfx_index: int
var music_index: int



func _ready() -> void:
    SaveManager.load_settings()
    reset_progress.max_value = reset_timer.wait_time
    reload()

func reload() -> void:
    grab_focus()
    load_settings()
    reset_progress.visible = false
    reset_timer.stop()

func load_settings() -> void:
    master_slider.value = SaveManager.settings.master_volume
    sfx_slider.value = SaveManager.settings.sfx_volume
    music_slider.value = SaveManager.settings.music_volume
    full_screen.button_pressed = SaveManager.settings.full_screen
    language_selection.current = SaveManager.settings.language



func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        back_requested.emit()
    
    reset_progress.value = (reset_timer.wait_time - reset_timer.time_left)


func _on_master_slider_value_changed(value: float) -> void:
    if value == master_slider.min_value:
        SaveManager.settings.master_volume = -INF
    else:
        SaveManager.settings.master_volume = value
    point_sound.play()

func _on_master_slider_focus_entered() -> void:
    master_label.modulate = modulate_select
    point_sound.play()

func _on_master_slider_focus_exited() -> void:
    master_label.modulate = modulate_deselect



func _on_sfx_slider_value_changed(value: float) -> void:
    if value == sfx_slider.min_value:
        SaveManager.settings.sfx_volume = -INF
    else:
        SaveManager.settings.sfx_volume = value
    point_sound.play()

func _on_sfx_slider_focus_entered() -> void:
    sfx_label.modulate = modulate_select
    point_sound.play()

func _on_sfx_slider_focus_exited() -> void:
    sfx_label.modulate = modulate_deselect



func _on_music_slider_value_changed(value: float) -> void:
    if value == music_slider.min_value:
        SaveManager.settings.music_volume = -INF
    else:
        SaveManager.settings.music_volume = value
    point_sound.play()

func _on_music_slider_focus_entered() -> void:
    music_label.modulate = modulate_select
    point_sound.play()

func _on_music_slider_focus_exited() -> void:
    music_label.modulate = modulate_deselect



func _on_full_screen_toggled(toggled_on: bool) -> void:
    SaveManager.settings.full_screen = toggled_on
    point_sound.play()

func _on_full_screen_focus_entered() -> void:
    full_screen.add_theme_color_override("font_pressed_color", modulate_select)
    point_sound.play()

func _on_full_screen_focus_exited() -> void:
    full_screen.add_theme_color_override("font_pressed_color", modulate_deselect)



func _on_language_selection_changed(_lang: String) -> void:
    point_sound.play()
    
func _on_language_selection_focus_entered() -> void:
    point_sound.play()



func _on_reset_button_button_down() -> void:
    reset_timer.start()
    reset_progress.visible = true

func _on_reset_button_button_up() -> void:
    reset_timer.stop()
    reset_progress.visible = false

func _on_reset_button_focus_entered() -> void:
    point_sound.play()

func _on_reset_timer_timeout() -> void:
    SaveManager.data.reset()
    SaveManager.save_file()
    back_requested.emit()



func _on_back_button_pressed() -> void:
    back_requested.emit()
