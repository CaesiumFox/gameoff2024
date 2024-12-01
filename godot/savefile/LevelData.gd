extends Saver
class_name LevelData

var level_id: int = 0
var unlocked: bool = false
var completed: bool = false
var best_time: float = INF
var coin_collected: bool = false
var deaths: int = 0

func reset() -> void:
    unlocked = level_id == 0
    completed = false
    best_time = INF
    coin_collected = false
    deaths = 0

func save_data(file: ConfigFile) -> void:
    file.set_value("level_%d" % level_id, "unlocked"      , unlocked      )
    file.set_value("level_%d" % level_id, "completed"     , completed     )
    file.set_value("level_%d" % level_id, "best_time"     , best_time     )
    file.set_value("level_%d" % level_id, "coin_collected", coin_collected)
    file.set_value("level_%d" % level_id, "deaths"        , deaths        )

func load_data(file: ConfigFile) -> void:
    unlocked       = file.get_value("level_%d" % level_id, "unlocked"      , false)
    completed      = file.get_value("level_%d" % level_id, "completed"     , false)
    best_time      = file.get_value("level_%d" % level_id, "best_time"     , 0.0  )
    coin_collected = file.get_value("level_%d" % level_id, "coin_collected", false)
    deaths         = file.get_value("level_%d" % level_id, "deaths"        , 0    )

func star_count() -> int:
    var thresholds := LevelMetadata.data[level_id]
    if best_time <= thresholds.star_3_threshold:
        return 3
    if best_time <= thresholds.star_2_threshold:
        return 2
    if best_time <= thresholds.star_1_threshold:
        return 1
    return 0

func try_set_best_time(time: float) -> bool:
    if time < best_time:
        best_time = time
        return true
    return false

func try_set_coin(coin: bool) -> bool:
    if coin_collected:
        return false
    coin_collected = coin
    return true
