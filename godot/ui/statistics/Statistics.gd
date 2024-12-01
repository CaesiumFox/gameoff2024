extends Control
class_name StatisticsMenu

signal back_requested

@export var normal: Color
@export var highlight: Color
@onready var table: GridContainer = $Center/Table
@onready var deaths: Label = $Deaths

var level_names: Array[Label] = []
var best_times: Array[Label] = []
var star1_times: Array[Label] = []
var star2_times: Array[Label] = []
var star3_times: Array[Label] = []

func time_show(x: float) -> String:
    if is_inf(x):
        return "-"
    return "%.2f" % x

func _ready() -> void:
    deaths.text = "D %d" % SaveManager.data.levels.total_deaths_count()
    for i in range(12):
        var level_name := Label.new()
        var best_time := Label.new()
        var star1_time := Label.new()
        var star2_time := Label.new()
        var star3_time := Label.new()
        level_name.text = tr("NUM_LVL").format({ id = i + 1 })
        best_time.text = time_show(SaveManager.data.levels.levels[i].best_time)
        star1_time.text = time_show(LevelMetadata.data[i].star_1_threshold)
        star2_time.text = time_show(LevelMetadata.data[i].star_2_threshold)
        star3_time.text = time_show(LevelMetadata.data[i].star_3_threshold)
        level_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        best_time.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        star1_time.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        star2_time.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        star3_time.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        level_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        best_time.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        star1_time.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        star2_time.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        star3_time.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        
        star1_time.modulate = highlight if (
            SaveManager.data.levels.levels[i].best_time <= LevelMetadata.data[i].star_1_threshold
            and
            SaveManager.data.levels.levels[i].best_time > LevelMetadata.data[i].star_2_threshold
        ) else normal
        
        star2_time.modulate = highlight if (
            SaveManager.data.levels.levels[i].best_time <= LevelMetadata.data[i].star_2_threshold
            and
            SaveManager.data.levels.levels[i].best_time > LevelMetadata.data[i].star_3_threshold
        ) else normal
            
        star3_time.modulate = highlight if (
            SaveManager.data.levels.levels[i].best_time <= LevelMetadata.data[i].star_3_threshold
        ) else normal
        
        level_names.append(level_name)
        best_times.append(best_time)
        star1_times.append(star1_time)
        star2_times.append(star2_time)
        star3_times.append(star3_time)
        table.add_child(level_name)
        table.add_child(best_time)
        table.add_child(star1_time)
        table.add_child(star2_time)
        table.add_child(star3_time)

func reload() -> void:
    deaths.text = "D %d   S: %d   C: %d" % [
        SaveManager.data.levels.total_deaths_count(),
        SaveManager.data.levels.total_star_count(),
        SaveManager.data.levels.total_coin_count()
    ]
    for i in range(12):
        level_names[i].text = tr("NUM_LVL").format({ id = i + 1 })
        best_times[i].text = time_show(SaveManager.data.levels.levels[i].best_time)
        star1_times[i].modulate = highlight if (
            SaveManager.data.levels.levels[i].best_time <= LevelMetadata.data[i].star_1_threshold
            and
            SaveManager.data.levels.levels[i].best_time > LevelMetadata.data[i].star_2_threshold
        ) else normal
        
        star2_times[i].modulate = highlight if (
            SaveManager.data.levels.levels[i].best_time <= LevelMetadata.data[i].star_2_threshold
            and
            SaveManager.data.levels.levels[i].best_time > LevelMetadata.data[i].star_3_threshold
        ) else normal
            
        star3_times[i].modulate = highlight if (
            SaveManager.data.levels.levels[i].best_time <= LevelMetadata.data[i].star_3_threshold
        ) else normal

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        back_requested.emit()



func _on_back_button_pressed() -> void:
    back_requested.emit()
