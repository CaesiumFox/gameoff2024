extends Control
class_name MainMenu

signal play_requested
signal achievements_requested
signal records_requested
signal options_requested
signal credits_requested
signal quit_requested

@onready var wait_timer: Timer = $WaitTimer
@onready var main_buttons: VBoxContainer = $MainButtons

var no_return: bool = false
var signal_to_emit: Signal

func _ready() -> void:
    reset()

func reset() -> void:
    grab_focus()
    for node in main_buttons.get_children():
        if node is MainMenuButton:
            (node as MainMenuButton).reload_locale()
            (node as MainMenuButton).reset_animation()

func _on_play_button_selected() -> void:
    if no_return: return
    no_return = true
    wait_timer.start()
    signal_to_emit = play_requested

func _on_achievements_button_selected() -> void:
    if no_return: return
    no_return = true
    wait_timer.start()
    signal_to_emit = achievements_requested

func _on_statistics_button_selected() -> void:
    if no_return: return
    no_return = true
    wait_timer.start()
    signal_to_emit = records_requested

func _on_options_button_selected() -> void:
    if no_return: return
    no_return = true
    wait_timer.start()
    signal_to_emit = options_requested

func _on_credits_button_selected() -> void:
    if no_return: return
    no_return = true
    wait_timer.start()
    signal_to_emit = credits_requested

func _on_quit_button_selected() -> void:
    if no_return: return
    no_return = true
    wait_timer.start()
    signal_to_emit = quit_requested

func _on_wait_timer_timeout() -> void:
    if signal_to_emit:
        no_return = false
        signal_to_emit.emit()
