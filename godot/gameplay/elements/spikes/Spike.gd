@tool
extends Area2D
class_name Spike

@export_enum(
    "Left",
    "Mid",
    "Right",
    "Big",
    "Dot"
) var variant: int = 1:
    get:
        return variant
    set(new_variant):
        variant = new_variant
        apply_variant()

@onready var view: AnimatedSprite2D = $View

func _ready() -> void:
    apply_variant()

func apply_variant():
    if view != null:
        view.frame = variant
