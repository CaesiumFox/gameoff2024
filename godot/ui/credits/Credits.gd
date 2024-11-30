extends Control
class_name CreditsMenu

signal back_requested

func reload() -> void:
    pass

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        back_requested.emit()

func _on_back_button_pressed() -> void:
    back_requested.emit()

func _on_rich_text_label_meta_clicked(meta: String) -> void:
    OS.shell_open(meta)
