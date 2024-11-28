extends Button
class_name LanguageSelectionButton

signal changed(lang: String)

var current: String
var lang_change: Dictionary = {
    "en": { "left": "ru", "right": "ru" },
    "ru": { "left": "en", "right": "en" },
}

func _ready() -> void:
    current = TranslationServer.get_locale()
    text = "\u2039 " + tr("O_MY_NAME") + " \u203a"

func update() -> void:
    SaveManager.settings.language = current
    text = "\u2039 " + tr("O_MY_NAME") + " \u203a"

func _process(_delta: float) -> void:
    if has_focus():
        if Input.is_action_just_pressed("ui_left"):
            current = lang_change[current]["left"]
            changed.emit(current)
            update()
        if Input.is_action_just_pressed("ui_right"):
            current = lang_change[current]["right"]
            changed.emit(current)
            update()
