extends Button
class_name LanguageSelectionButton

signal changed(lang: String)

var current: String
var lang_change: Dictionary = {
    "en": { "left": "ru", "right": "ru" },
    "ru": { "left": "en", "right": "en" },
    "en_US": { "left": "ru", "right": "ru" },
    "ru_RU": { "left": "en", "right": "en" },
}

func _ready() -> void:
    current = TranslationServer.get_locale()

func update() -> void:
    SaveManager.settings.language = current

func _process(_delta: float) -> void:
    if has_focus():
        if Input.is_action_just_pressed("ui_left"):
            _on_left_pressed()
        if Input.is_action_just_pressed("ui_right"):
            _on_right_pressed()

func _on_left_pressed() -> void:
    current = lang_change[current]["left"]
    changed.emit(current)
    update()

func _on_right_pressed() -> void:
    current = lang_change[current]["right"]
    changed.emit(current)
    update()
