extends Control
class_name MainMenu

signal play_requested
signal options_requested
signal quit_requested

@onready var play_button: MainMenuButton = $MainButtons/PlayButton
@onready var options_button: MainMenuButton = $MainButtons/OptionsButton
@onready var quit_button: MainMenuButton = $MainButtons/QuitButton

@onready var wait_timer: Timer = $WaitTimer

var no_return: bool = false
var signal_to_emit: Signal

func _ready() -> void:
    reset()

func reset() -> void:
    grab_focus()
    play_button.reset_animation()
    options_button.reset_animation()
    quit_button.reset_animation()

func _on_play_button_selected() -> void:
    if no_return: return
    no_return = true
    wait_timer.start()
    signal_to_emit = play_requested

func _on_options_button_selected() -> void:
    if no_return: return
    no_return = true
    wait_timer.start()
    signal_to_emit = options_requested

func _on_quit_button_selected() -> void:
    if no_return: return
    no_return = true
    wait_timer.start()
    signal_to_emit = quit_requested

func _on_wait_timer_timeout() -> void:
    if signal_to_emit:
        no_return = false
        signal_to_emit.emit()
