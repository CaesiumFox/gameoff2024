extends Control
class_name LevelMenu

signal selected(id: int)
signal back

const LEVEL_BUTTON: PackedScene = preload("res://ui/level_menu/LevelButton.tscn")

@onready var levels: GridContainer = %Levels
@onready var point_sound: AudioStreamPlayer = $PointSound
@onready var select_sound: AudioStreamPlayer = $SelectSound

var buttons: Array[LevelButton] = []

func _ready() -> void:
    for i in range(12):
        var button = LEVEL_BUTTON.instantiate() as LevelButton
        button.level_id = i
        button.focus_entered.connect(_on_level_button_focus)
        button.selected.connect(_on_level_button_select)
        buttons.append(button)

    for i in range(12):
        levels.add_child(buttons[i])
    
    var xytoindex := func (x: int, y: int) -> int:
        return ((y + 4) % 4) * 3 + ((x + 3) % 3)
    
    for i: int in range(12):
        var x := i % 3
        @warning_ignore("integer_division")
        var y := i / 3
        buttons[i].focus_neighbor_top    = buttons[i].get_path_to(buttons[xytoindex.call(x, y - 1)])
        buttons[i].focus_neighbor_bottom = buttons[i].get_path_to(buttons[xytoindex.call(x, y + 1)])
        buttons[i].focus_neighbor_left   = buttons[i].get_path_to(buttons[xytoindex.call(x - 1, y)])
        buttons[i].focus_neighbor_right  = buttons[i].get_path_to(buttons[xytoindex.call(x + 1, y)])
        buttons[i].focus_next            = buttons[i].get_path_to(buttons[(i + 1) % 12])
        buttons[i].focus_previous        = buttons[i].get_path_to(buttons[(i + 11) % 12])

    focus_neighbor_top    = get_path_to(buttons[11])
    focus_neighbor_bottom = get_path_to(buttons[0])
    focus_neighbor_left   = get_path_to(buttons[11])
    focus_neighbor_right  = get_path_to(buttons[0])
    focus_next            = get_path_to(buttons[0])
    focus_previous        = get_path_to(buttons[11])
    
    reset()

func reset() -> void:
    grab_focus()
    point_sound.stop()
    select_sound.stop()
    for i in range(12):
        buttons[i].unlocked = SaveManager.data.levels.levels[i].unlocked
        buttons[i].completed = SaveManager.data.levels.levels[i].completed
        buttons[i].star_count = SaveManager.data.levels.levels[i].star_count()
        buttons[i].coin_collect = SaveManager.data.levels.levels[i].coin_collected
        

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        back.emit()

func _on_level_button_focus() -> void:
    point_sound.play()

func _on_level_button_select(id: int) -> void:
    select_sound.play()
    selected.emit(id)
