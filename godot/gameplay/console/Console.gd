extends TextureRect
class_name Console

signal exited(hash: int)

const CELL := preload("res://gameplay/console/Cell.tscn")

var cells: Array[ConsoleCell] = []
var value: int = 0
var ctx: HashingContext
var ignore_exit: bool = false

func _ready() -> void:
    ctx = HashingContext.new()

    var xytoindex := func (x: int, y: int) -> int:
        return ((y + 6) % 6) * 6 + ((x + 6) % 6)

    for y in range(6):
        for x in range(6):
            var cell := CELL.instantiate() as ConsoleCell
            cell.position.x = 2 + 14 * x
            cell.position.y = 2 + 14 * y
            cell.switch.connect(_on_switch)
            cell.index = xytoindex.call(x, y)
            cells.append(cell)

    for y in range(6):
        for x in range(6):
            add_child(cells[xytoindex.call(x, y)])
    
    for y in range(6):
        for x in range(6):
            cells[xytoindex.call(x, y)].focus_neighbor_top    = cells[xytoindex.call(x, y)].get_path_to(cells[xytoindex.call(x, y - 1)])
            cells[xytoindex.call(x, y)].focus_neighbor_bottom = cells[xytoindex.call(x, y)].get_path_to(cells[xytoindex.call(x, y + 1)])
            cells[xytoindex.call(x, y)].focus_neighbor_left   = cells[xytoindex.call(x, y)].get_path_to(cells[xytoindex.call(x - 1, y)])
            cells[xytoindex.call(x, y)].focus_neighbor_right  = cells[xytoindex.call(x, y)].get_path_to(cells[xytoindex.call(x + 1, y)])

    value = 0

func reset() -> void:
    reset_values()
    reset_focus()

func reset_focus() -> void:
    if cells and cells.size() > 0 and cells[0]:
        cells[0].grab_focus()

func reset_values() -> void:
    if cells and cells.size() > 0 and cells[0]:
        for cell in cells:
            cell.button_pressed = false
        value = 0

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("console_clear"):
        reset_values()
        return

    if Input.is_action_just_pressed("console_close"):
        if ignore_exit:
            ignore_exit = false
            return
        exited.emit(value_hash())
        return

func _on_switch(index: int, on: bool) -> void:
    if on:
        value |= 1 << index
    else:
        value &= ~(1 << index)

func value_hash() -> int:
    var input := PackedByteArray()
    input.resize(8)
    input.encode_s64(0, value)
    ctx.start(HashingContext.HASH_SHA256)
    ctx.update(input)
    return ctx.finish().decode_s64(0)
