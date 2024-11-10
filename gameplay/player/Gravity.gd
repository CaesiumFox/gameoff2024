extends Node

@export var enabled: bool = true

var player: CharacterBody2D

func _ready() -> void:
    player = get_parent()

func _physics_process(delta: float) -> void:
    if not enabled: return

    player.velocity.y += PhysicsCalculator.gravity() * delta
