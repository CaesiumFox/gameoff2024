extends Node

signal file_load_success
signal file_load_fail(error: Error)
signal file_save_success
signal file_save_fail(error: Error)

const SAVE_FILE_PATH: String = "user://save_0.txt";

var data: Data
const data_scene = preload("res://savefile/Data.tscn")

func _ready() -> void:
    data = data_scene.instantiate()
    add_child(data)

func save_file() -> void:
    var config_file := ConfigFile.new()
    data.save_data(config_file)
    var error := config_file.save(SAVE_FILE_PATH)
    if error:
        file_save_fail.emit(error)
    else:
        file_save_success.emit()

func load_file() -> void:
    var config_file := ConfigFile.new()
    var error := config_file.load(SAVE_FILE_PATH)
    if error:
        file_load_fail.emit(error)
        return
    data.load_data(config_file)
    file_load_success.emit()
