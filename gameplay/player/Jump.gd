extends Node

signal jump

@export var enabled: bool = true

var player: CharacterBody2D
var want_to_jump: bool = false

func _ready() -> void:
    player = get_parent()

func _physics_process(_delta: float) -> void:
    if not enabled: return

    want_to_jump = want_to_jump or Input.is_action_just_pressed("jump")
    want_to_jump = want_to_jump and not Input.is_action_just_released("jump")

    if player.is_on_floor() and want_to_jump:
        want_to_jump = false
        player.velocity.y -= PhysicsCalculator.jump_speed()
        jump.emit()
