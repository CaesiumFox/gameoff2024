extends Saver
class_name Data

@onready var abilities := $Abilities as Abilities

func save_data(file: ConfigFile) -> void:
    abilities.save_data(file)

func load_data(file: ConfigFile) -> void:
    abilities.load_data(file)
