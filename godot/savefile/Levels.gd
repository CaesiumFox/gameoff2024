extends Saver
class_name Levels

var levels: Array[LevelData] = []

func _ready() -> void:
    for i in range(12):
        levels.append(LevelData.new())
        levels[i].level_id = i
        levels[i].unlocked = true  # TODO: remove
    levels[0].unlocked = true

func save_data(file: ConfigFile) -> void:
    for i in range(12):
        levels[i].save_data(file)

func load_data(file: ConfigFile) -> void:
    for i in range(12):
        levels[i].load_data(file)

func total_star_count() -> int:
    var retval: int = 0
    for level in levels:
        if level.unlocked and level.completed:
            retval += level.star_count()
    return retval

func total_coin_count() -> int:
    var retval: int = 0
    for level in levels:
        if level.unlocked and level.completed and level.coin_collected:
            retval += 1
    return retval
