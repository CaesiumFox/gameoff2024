extends Control
class_name MainMenu

signal quit_requested
signal play_requested

func _on_quit_button_quit_requested() -> void:
    quit_requested.emit()

func _on_play_button_play_requested() -> void:
    play_requested.emit()
