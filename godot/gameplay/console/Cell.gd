extends TextureButton
class_name ConsoleCell

signal switch(id: int, on: bool)

var index: int = 0

func _on_mouse_entered() -> void:
    grab_focus()

func _on_toggled(toggled_on: bool) -> void:
    switch.emit(index, toggled_on)
