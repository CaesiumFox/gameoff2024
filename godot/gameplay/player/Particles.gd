extends Node2D

@onready var invert := $Invert as AnimatedSprite2D

func _ready() -> void:
    PhysicsCalculator.gravity_changed.connect(_on_gravity_change)

func _on_gravity_change(upwards: bool) -> void:
    transform.y.y = -1 if upwards else 1
    invert.visible = true
    invert.play("default")

func _on_invert_animation_finished() -> void:
    invert.visible = false
