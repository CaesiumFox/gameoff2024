extends Saver
class_name Settings

var master_volume: float = 0:
    get:
        return master_volume
    set(new):
        master_volume = new
        if master_volume == -INF:
            AudioServer.set_bus_mute(master_index, true)
        else:
            AudioServer.set_bus_mute(master_index, false)
            AudioServer.set_bus_volume_db(master_index, master_volume)

var sfx_volume: float = 0:
    get:
        return sfx_volume
    set(new):
        sfx_volume = new
        if sfx_volume == -INF:
            AudioServer.set_bus_mute(sfx_index, true)
        else:
            AudioServer.set_bus_mute(sfx_index, false)
            AudioServer.set_bus_volume_db(sfx_index, sfx_volume)

var music_volume: float = 0:
    get:
        return music_volume
    set(new):
        music_volume = new
        if music_volume == -INF:
            AudioServer.set_bus_mute(music_index, true)
        else:
            AudioServer.set_bus_mute(music_index, false)
            AudioServer.set_bus_volume_db(music_index, music_volume)

var full_screen: bool = true:
    get:
        return full_screen
    set(new):
        full_screen = new
        if full_screen:
            DisplayServer.window_set_mode(
                DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
        else:
            DisplayServer.window_set_mode(
                DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)

var language: String = "":
    get:
        return language
    set(new):
        language = new
        TranslationServer.set_locale(new)

var master_index: int
var sfx_index: int
var music_index: int

func _ready() -> void:
    master_index = AudioServer.get_bus_index("Master")
    sfx_index = AudioServer.get_bus_index("Sound")
    music_index = AudioServer.get_bus_index("Music")
    language = TranslationServer.get_locale()

func reset() -> void:
    master_volume = 0
    sfx_volume = 0
    music_volume = 0
    full_screen = false
    language = "en"

func save_data(file: ConfigFile) -> void:
    file.set_value("Settings", "master_volume", master_volume)
    file.set_value("Settings", "sfx_volume", sfx_volume)
    file.set_value("Settings", "music_volume", music_volume)
    file.set_value("Settings", "full_screen", full_screen)
    file.set_value("Settings", "language", language)

func load_data(file: ConfigFile) -> void:
    master_volume = file.get_value("Settings", "master_volume", 0)
    sfx_volume = file.get_value("Settings", "sfx_volume", 0)
    music_volume = file.get_value("Settings", "music_volume", 0)
    full_screen = file.get_value("Settings", "full_screen", false)
    language = file.get_value("Settings", "language", "")

func apply_deferred() -> void:
    pass
