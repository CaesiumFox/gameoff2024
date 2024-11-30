extends TileMapLayer

@export var count: int = 0
@export var total_cells: Array[Vector2i] = []
@export var terrain_set: int = 0
@export var terrain: int = 0
@export var start_frame: int = 0
@export var delta_frame: int = 1
@export var delta_cells: PackedInt32Array = [1]

var frame: int = 0

func _ready() -> void:
    for child in get_children():
        if child is Timer:
            (child as Timer).timeout.connect(_on_timer_timeout)
    frame = start_frame

func _on_timer_timeout() -> void:
    if total_cells.size() == 0:
        return
    clear()
    frame += delta_frame
    frame %= total_cells.size()
    var cells: Array[Vector2i] = []
    var f := 0
    for i in range(count):
        f += delta_cells[i % delta_cells.size()]
        cells.append(total_cells[(frame + f) % total_cells.size()])
    set_cells_terrain_connect(cells, 2, 0)
    
