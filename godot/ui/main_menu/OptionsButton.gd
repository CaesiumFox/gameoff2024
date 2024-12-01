extends MainMenuButton

signal options_requested

func _on_pressed() -> void:
    options_requested.emit()
