@tool
extends TextureButton
class_name LevelButton

signal selected(id: int)

@export var level_id: int = 1:
    get:
        return level_id
    set(new_level_id):
        level_id = new_level_id
        update_status()

@export var unlocked: bool = false:
    get:
        return unlocked
    set(new_unlocked):
        unlocked = new_unlocked
        update_status()

@export var completed: bool = false:
    get:
        return completed
    set(new_completed):
        completed = new_completed
        update_status()

@export var best_time: float = 0.0:
    get:
        return best_time
    set(new_best_time):
        best_time = new_best_time
        update_status()

@export var star_1_threshold: float = 0.0:
    get:
        return star_1_threshold
    set(new_star_1_threshold):
        star_1_threshold = new_star_1_threshold
        update_status()

@export var star_2_threshold: float = 0.0:
    get:
        return star_2_threshold
    set(new_star_2_threshold):
        star_2_threshold = new_star_2_threshold
        update_status()

@export var star_3_threshold: float = 0.0:
    get:
        return star_3_threshold
    set(new_star_3_threshold):
        star_3_threshold = new_star_3_threshold
        update_status()

@export var coin_collect: bool = false:
    get:
        return coin_collect
    set(new_coin_collect):
        coin_collect = new_coin_collect
        update_status()


@onready var complete_decoration: TextureRect = $CompleteDecoration
@onready var name_label: Label = $Name
@onready var star_1_indicator: CollectedIndicator = $Star1Indicator
@onready var star_2_indicator: CollectedIndicator = $Star2Indicator
@onready var star_3_indicator: CollectedIndicator = $Star3Indicator
@onready var coin_indicator: CollectedIndicator = $CoinIndicator

func update_status() -> void:
    if unlocked:
        visible = true
        disabled = false
    else:
        visible = false
        disabled = true
        return

    if name_label:    
        name_label.text = tr("NUMBERED_LEVEL").format({ id = level_id })

    if complete_decoration:
        complete_decoration.visible = completed

    if star_1_indicator:
        star_1_indicator.collected = completed and best_time <= star_1_threshold
    if star_2_indicator:
        star_2_indicator.collected = completed and best_time <= star_2_threshold
    if star_3_indicator:
        star_3_indicator.collected = completed and best_time <= star_3_threshold

    if coin_indicator:
        coin_indicator.collected = completed and coin_collect

func _ready() -> void:
    update_status()

func _on_pressed() -> void:
    if unlocked:
        selected.emit(level_id)

func _on_mouse_entered() -> void:
    if unlocked:
        grab_focus()
