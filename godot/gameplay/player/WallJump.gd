extends Ability
class_name WallJumpAbility

signal wall_grab
signal wall_jump(right_wall: bool)

@onready var wall_timer := $WallTimer as Timer

var was_on_wall: int = 0
var on_wall: int = 0
var timer_works: int = 0

func reset() -> void:
    wall_timer.stop()
    was_on_wall = 0
    on_wall = 0
    timer_works = 0

func action(_delta: float) -> void:
    if player.is_on_wall() and player.get_slide_collision_count() > 0:
        var old_on_wall := on_wall
        on_wall = 1 if player.get_last_slide_collision().get_normal().x > 0 else -1
        if old_on_wall != on_wall:
            wall_grab.emit()
    else:
        on_wall = 0
    
    if was_on_wall != 0:
        if on_wall == 0:
            timer_works = was_on_wall
            was_on_wall = 0
            wall_timer.start()
    else:
        if on_wall != 0:
            was_on_wall = on_wall
            if timer_works:
                timer_works = 0
                wall_timer.stop()

func try_wall_jump() -> bool:
    if not SaveManager.data.abilities.wall_jump:
        return false
    
    var dir: int = on_wall
    if dir == 0: dir = timer_works
    
    if dir != 0:
        player.velocity.y = -PhysicsCalculator.wall_jump_speed_v()
        player.velocity.x = dir * PhysicsCalculator.wall_jump_speed_h()
        timer_works = 0
        wall_timer.stop()
        wall_jump.emit(dir < 0)
        return true
    return false

func _on_wall_timer_timeout() -> void:
    timer_works = 0
