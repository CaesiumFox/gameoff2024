extends CharacterBody2D

signal death
signal win

@onready var jump: Node = $Jump
@onready var move: Node = $Move
@onready var gravity: Node = $Gravity
@onready var camera: Camera2D = $Camera

@onready var shape: CollisionShape2D = $Shape

func _ready() -> void:
    (shape.shape as RectangleShape2D).size.x -= 2 * safe_margin
    (shape.shape as RectangleShape2D).size.y -= 2 * safe_margin

func _physics_process(_delta: float) -> void:
    move_and_slide()

func prepare_for_load() -> void:
    jump.reset_air_jumps()
    camera.reset_smoothing()

func set_camera_limits(view_box: Rect2) -> void:
    camera.limit_left = int(view_box.position.x)
    camera.limit_top = int(view_box.position.y)
    camera.limit_right = int(view_box.end.x)
    camera.limit_bottom = int(view_box.end.y)


func _on_hit_box_area_entered(area: Area2D) -> void:
    print("enter")
    if area.collision_layer & (1 << 5) > 0:  # damage
        death.emit()
        print("death")
    elif area.collision_layer & (1 << 8) > 0:  # exit
        win.emit()
        print("win")
    else:
        pass
