extends TileMapLayer
class_name Spinner

@export var count: int = 0
@export var total_cells: Array[Vector2i] = []
@export var terrain_set: int = 0
@export var terrain: int = 0
@export var start_frame: int = 0
@export var delta_frame: int = 1
@export var delta_cells: PackedInt32Array = [1]

var frame: int = 0

static func interpolate(array: Array[Vector2i], from: Vector2i, to: Vector2i) -> void:
    if abs(from.x - to.x) == 0:
        # vertical
        for y in range(from.y, to.y, 1 if to.y >= from.y else -1):
            array.append(Vector2i(from.x, y))
    elif abs(from.y - to.y) == 0:
        # horizontal
        for x in range(from.x, to.x, 1 if to.x >= from.x else -1):
            array.append(Vector2i(x, from.y))

func _ready() -> void:
    for child in get_children():
        if child is Timer:
            (child as Timer).timeout.connect(_on_timer_timeout)
    frame = start_frame

func _on_timer_timeout() -> void:
    if total_cells.size() == 0:
        return
    clear()
    var cells: Array[Vector2i] = []
    var f := 0
    for i in range(count):
        cells.append(total_cells[(frame + f) % total_cells.size()])
        f += delta_cells[i % delta_cells.size()]
    frame += delta_frame
    frame %= total_cells.size()
    set_cells_terrain_connect(cells, terrain_set, terrain)
    
