extends Node

signal file_load_success
signal file_load_fail(error: Error)
signal file_save_success
signal file_save_fail(error: Error)

signal settings_load_success
signal settings_load_fail(error: Error)
signal settings_save_success
signal settings_save_fail(error: Error)

const SAVE_FILE_PATH: String = "user://save_0.txt";
const SETTINGS_FILE_PATH: String = "user://settings.txt";

@onready var data: Data = $Data as Data
@onready var settings: Settings = $Settings

func _ready() -> void:
    load_file()
    load_settings()

func save_file() -> void:
    var file := ConfigFile.new()
    data.save_data(file)
    var error := file.save(SAVE_FILE_PATH)
    if error:
        file_save_fail.emit(error)
    else:
        file_save_success.emit()

func load_file() -> void:
    var file := ConfigFile.new()
    var error := file.load(SAVE_FILE_PATH)
    if error:
        file_load_fail.emit(error)
        return
    data.load_data(file)
    file_load_success.emit()

func save_settings() -> void:
    var file := ConfigFile.new()
    settings.save_data(file)
    var error := file.save(SETTINGS_FILE_PATH)
    if error:
        settings_save_fail.emit(error)
    else:
        settings_save_success.emit()

func load_settings() -> void:
    var file := ConfigFile.new()
    var error := file.load(SETTINGS_FILE_PATH)
    if error:
        settings_load_fail.emit(error)
        return
    settings.load_data(file)
    settings_load_success.emit()
