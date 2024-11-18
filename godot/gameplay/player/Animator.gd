extends Node

@export var player: Player
@export var sprite: PlayerView
@onready var movement: AnimationPlayer = $Movement
@onready var invincibility: AnimationPlayer = $Invincibility

var dead: bool = false
var free_fall: bool = false
var move: int = 0

func _ready() -> void:
    pass

func _physics_process(_delta: float) -> void:
    if free_fall and not dead:
        movement.stop()
        if PhysicsCalculator.gravity() < 0:
            sprite.flip_v = true
            if player.velocity.y < 0:
                sprite.frame_xy = Vector2(1, 1)
            else:
                sprite.frame_xy = Vector2(0, 1)
        else:
            sprite.flip_v = false
            if player.velocity.y < 0:
                sprite.frame_xy = Vector2(0, 1)
            else:
                sprite.frame_xy = Vector2(1, 1)

func reset() -> void:
    move = 0
    dead = false
    free_fall = not player.is_on_floor()
    stop_all()
    movement.play("idle")

func stop_all() -> void:
    movement.stop()
    invincibility.play("RESET")

func _on_player_death() -> void:
    if dead: return
    free_fall = false
    stop_all()
    sprite.frame_xy = Vector2(3, 1)

func _on_player_win() -> void:
    if dead: return
    stop_all()
    pass # Replace with function body.

func _on_jump_hit_ground() -> void:
    if dead: return
    free_fall = false
    if move == 0:
        movement.play("idle")
    else:
        movement.play("walk")

func _on_jump_leave_ground() -> void:
    if dead: return
    movement.stop()
    sprite.frame_xy = Vector2(1, 1)

func _on_jump_jump(_air: bool) -> void:
    if dead: return
    free_fall = true
    movement.stop()
    sprite.frame_xy = Vector2(0, 1)

func _on_move_start_left() -> void:
    if dead: return
    move = -1
    sprite.flip_h = true
    if player.is_on_floor():
        movement.play("walk")

func _on_move_start_right() -> void:
    if dead: return
    move = 1
    sprite.flip_h = false
    if player.is_on_floor():
        movement.play("walk")

func _on_move_stop() -> void:
    if dead: return
    move = 0
    if player.is_on_floor():
        movement.play("idle")
