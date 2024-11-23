extends MainMenuButton

signal quit_requested

func _on_pressed() -> void:
    quit_requested.emit()
