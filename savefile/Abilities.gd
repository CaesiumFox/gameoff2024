extends Saver
class_name Abilities

var air_jumps: int = 0
var wall_jump: bool = true

func save_data(file: ConfigFile) -> void:
    file.set_value("Abilities", "air_jumps", air_jumps)
    file.set_value("Abilities", "wall_jump", wall_jump)

func load_data(file: ConfigFile) -> void:
    air_jumps = file.get_value("Abilities", "air_jumps", 0)
    wall_jump = file.get_value("Abilities", "wall_jump", false)
