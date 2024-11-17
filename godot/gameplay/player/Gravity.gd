extends Node

@export var enabled: bool = true
@export var player: CharacterBody2D

func reset() -> void:
    pass

func _physics_process(delta: float) -> void:
    if not enabled: return
    player.velocity.y += PhysicsCalculator.gravity() * delta
