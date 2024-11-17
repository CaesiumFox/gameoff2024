extends Node

signal jump(air: bool)
signal air_jump_reset(amount: int)
signal hit_ground

@export var enabled: bool = true
@export var player: CharacterBody2D
@export var ray: RayCast2D

@onready var coyote_timer := $CoyoteTimer as Timer
@onready var wall_jump := $WallJump as Node

var want_to_jump: bool = false
var air_jumps_left: int = 0
var was_on_ground: bool = false
var coyote_works: bool = false

func reset() -> void:
    coyote_timer.stop()
    wall_jump.reset()
    want_to_jump = false
    reset_air_jumps()
    was_on_ground = false
    coyote_works = false

func _physics_process(_delta: float) -> void:
    if not enabled: return

    want_to_jump = want_to_jump or Input.is_action_just_pressed("game_jump")
    want_to_jump = want_to_jump and not Input.is_action_just_released("game_jump")
    var on_ground := player.is_on_floor() or (air_jumps_left > 0 and ray.is_colliding())
    
    if on_ground and not was_on_ground:
        hit_ground.emit()
        was_on_ground = true
        reset_air_jumps()
        if coyote_works:
            coyote_works = false
            coyote_timer.stop()
    
    if want_to_jump and wall_jump.try_wall_jump():
        want_to_jump = false
        return
    
    if on_ground or coyote_works:
        if want_to_jump:
            want_to_jump = false
            player.velocity.y = -PhysicsCalculator.jump_speed()
            was_on_ground = false
            jump.emit(false)
    else:
        if was_on_ground:
            was_on_ground = false
            coyote_works = true
            coyote_timer.start()
        if want_to_jump and air_jumps_left > 0:
            want_to_jump = false
            air_jumps_left -= 1
            player.velocity.y = -PhysicsCalculator.jump_speed()
            jump.emit(true)

func reset_air_jumps() -> void:
    var max_air_jumps := SaveManager.data.abilities.air_jumps
    air_jumps_left = max_air_jumps
    air_jump_reset.emit(max_air_jumps)

func _on_coyote_timer_timeout() -> void:
    coyote_works = false
