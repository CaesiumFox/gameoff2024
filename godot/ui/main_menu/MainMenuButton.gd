extends Button
class_name MainMenuButton

@export var translation_id: String

func _ready() -> void:
    mouse_entered.connect(_on_mouse_entered)
    focus_entered.connect(_on_focus_entered)
    focus_exited.connect(_on_focus_exited)
    text = tr(translation_id)
    
func _on_mouse_entered() -> void:
    grab_focus()

func _on_focus_entered() -> void:
    text = "\u203a " + tr(translation_id) + " \u2039"

func _on_focus_exited() -> void:
    text = tr(translation_id)
