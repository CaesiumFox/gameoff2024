extends Node

@export var enabled: bool = true

var player: CharacterBody2D
var move_input: float = 0.0

func _ready() -> void:
    player = get_parent()

func _physics_process(_delta: float) -> void:
    if not enabled: return

    move_input = Input.get_axis("move_left", "move_right")

    player.velocity.x = move_input * PhysicsCalculator.speed()    
