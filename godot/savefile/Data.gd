extends Saver
class_name Data

@onready var abilities := $Abilities as Abilities
@onready var levels: Levels = $Levels

func save_data(file: ConfigFile) -> void:
    abilities.save_data(file)
    levels.save_data(file)

func load_data(file: ConfigFile) -> void:
    abilities.load_data(file)
    levels.load_data(file)
