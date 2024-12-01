extends Node2D
class_name Level

signal view_box_changed(view_box: Rect2)
signal coin_collected

@export var spawn_point := Vector2(0, 0)
@export var view_box := Rect2(-100000, -100000, 200000, 200000):
    get:
        return view_box
    set(new_view_box):
        view_box = new_view_box
        view_box_changed.emit()

func _init() -> void:
    process_mode = ProcessMode.PROCESS_MODE_PAUSABLE

func _ready() -> void:
    update_by_markers()
    var coin_node := get_node_or_null("Coin") as Coin
    if coin_node:
        coin_node.collect.connect(func(_id): coin_collected.emit())

func set_up() -> void:
    PhysicsCalculator.inverted_gravity = false

func update_by_markers() -> void:
    var tl := Vector2(-100000, -100000)
    var br := Vector2(100000, 100000)

    var spawn_point_marker: Node = get_node_or_null("Spawn")
    var tl_marker: Node = get_node_or_null("TL")
    var br_marker: Node = get_node_or_null("BR")
    
    if spawn_point_marker != null and spawn_point_marker is Node2D:
        spawn_point = (spawn_point_marker as Node2D).position

    if tl_marker != null and tl_marker is Node2D:
        tl = (tl_marker as Node2D).position
    else:
        tl = view_box.position

    if br_marker != null and br_marker is Node2D:
        br = (br_marker as Node2D).position
    else:
        tl = view_box.end

    var x0: float = tl.x if tl.x < br.x else br.x
    var y0: float = tl.y if tl.y < br.y else br.y
    var x1: float = tl.x if tl.x > br.x else br.x
    var y1: float = tl.y if tl.y > br.y else br.y
    
    view_box = Rect2(x0, y0, x1 - x0, y1 - y0)
