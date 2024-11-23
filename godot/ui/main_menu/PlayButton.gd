extends MainMenuButton

signal play_requested

func _on_pressed() -> void:
    play_requested.emit()
