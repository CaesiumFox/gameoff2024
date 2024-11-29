extends TextureButton
class_name ConsoleCell

signal switch(id: int, on: bool)

static var held: bool = false
var index: int = 0

func _on_mouse_entered() -> void:
    grab_focus()

func _on_focus_entered() -> void:
    if held:
        button_pressed = not button_pressed

func _on_toggled(toggled_on: bool) -> void:
    switch.emit(index, toggled_on)

func _on_button_down() -> void:
    held = true

func _on_button_up() -> void:
    held = false
