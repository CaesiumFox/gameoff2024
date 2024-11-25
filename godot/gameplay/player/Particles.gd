extends Node2D

func _ready() -> void:
    PhysicsCalculator.gravity_changed.connect(_on_gravity_change)

func _on_gravity_change(upwards: bool) -> void:
    transform.y.y = -1 if upwards else 1
