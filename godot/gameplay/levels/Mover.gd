extends Path2D
class_name Mover

var point: PathFollow2D
var timer: Timer

func _ready() -> void:
    for child in get_children():
        if child is PathFollow2D:
            point = child
        elif child is Timer:
            timer = child

func _physics_process(_delta: float) -> void:
    var time_passed := timer.wait_time - timer.time_left;
    point.progress_ratio = clampf(interp(time_passed / timer.wait_time), 0, 1)

func interp(x: float) -> float:
    return x
