extends Node

signal jump(air: bool)
signal air_jump_reset(amount: int)

@export var enabled: bool = true
@export var player: CharacterBody2D
@export var ray: RayCast2D

@onready var coyote_timer := $CoyoteTimer as Timer
@onready var wall_jump := $WallJump as Node

const MAX_AIR_JUMPS: int = 0

var want_to_jump: bool = false
var air_jumps_left: int = MAX_AIR_JUMPS
var was_on_ground: bool = false
var coyote_works: bool = false


func _physics_process(_delta: float) -> void:
    if not enabled: return

    want_to_jump = want_to_jump or Input.is_action_just_pressed("jump")
    want_to_jump = want_to_jump and not Input.is_action_just_released("jump")
    var on_ground := player.is_on_floor() or (air_jumps_left > 0 and ray.is_colliding())
    
    if on_ground and not was_on_ground:
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
    air_jumps_left = MAX_AIR_JUMPS
    air_jump_reset.emit(MAX_AIR_JUMPS)

func _on_coyote_timer_timeout() -> void:
    coyote_works = false
