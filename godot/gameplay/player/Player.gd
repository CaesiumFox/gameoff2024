extends CharacterBody2D
class_name Player

signal death
signal win

@onready var shape := $Shape as CollisionShape2D

@onready var jump := $Jump as JumpAbility
@onready var wall_jump := $Jump/WallJump
@onready var move := $Move as MoveAbility
@onready var gravity := $Gravity as GravityAbility
@onready var console := $Console

@onready var hit_box := $HitBox as Area2D

@onready var camera := $Camera as Camera2D
@onready var jump_particles := $Particles/JumpParticles as CPUParticles2D
@onready var wall_jump_particles_center := $Particles/WallJumpParticlesCenter as Node2D
@onready var wall_jump_particles := $Particles/WallJumpParticlesCenter/WallJumpParticles as CPUParticles2D
@onready var death_particles := $Particles/DeathParticles as CPUParticles2D
@onready var land_particles := $Particles/LandParticles as CPUParticles2D
@onready var jump_sound := $JumpSound as AudioStreamPlayer
@onready var death_sound := $DeathSound as AudioStreamPlayer
@onready var land_sound := $LandSound as AudioStreamPlayer
@onready var animator := $Animator as Animator
@onready var shield := $Shield as Shield

var danger_zones: int = 0

func _ready() -> void:
    (shape.shape as RectangleShape2D).size.x -= 2 * safe_margin
    (shape.shape as RectangleShape2D).size.y -= 2 * safe_margin
    PhysicsCalculator.gravity_changed.connect(_on_gravity_change)

func _physics_process(_delta: float) -> void:
    move_and_slide()

func reset() -> void:
    reset_all_abilities()
    enable_all_abilities()
    animator.reset()
    shield.reset()
    danger_zones = 0
    velocity.x = 0
    velocity.y = 0
    jump.reset_air_jumps()
    camera.reset_smoothing()

func prepare_for_load() -> void:
    jump.reset_air_jumps()
    camera.reset_smoothing()

func set_camera_limits(view_box: Rect2) -> void:
    camera.limit_left = int(view_box.position.x)
    camera.limit_top = int(view_box.position.y)
    camera.limit_right = int(view_box.end.x)
    camera.limit_bottom = int(view_box.end.y)

func _on_hit_box_area_entered(_area: Area2D) -> void:
    if not shield.hit():
        death.emit()
    else:
        danger_zones += 1

func _on_hit_box_area_exited(_area: Area2D) -> void:
    danger_zones -= 1

func _on_win_box_area_entered(_area: Area2D) -> void:
    win.emit()

func _on_jump_jump(_air: bool) -> void:
    jump_particles.restart()
    jump_sound.play()

func _on_wall_jump_wall_jump(right_wall: bool) -> void:
    wall_jump_particles_center.transform.x.x = 1 if right_wall else -1
    wall_jump_particles.restart()
    jump_sound.play()

func _on_death() -> void:
    death_particles.restart()
    death_sound.play()

func _on_jump_hit_ground() -> void:
    land_particles.restart()
    land_sound.play()

func _on_gravity_change(upwards: bool) -> void:
    up_direction.y = 1 if upwards else -1

func enable_all_abilities() -> void:
    jump.enabled = true
    wall_jump.enabled = true
    move.enabled = true
    gravity.enabled = true
    console.enabled = true

func disable_all_abilities() -> void:
    jump.enabled = false
    wall_jump.enabled = false
    move.enabled = false
    gravity.enabled = false
    console.enabled = false

func reset_all_abilities() -> void:
    jump.reset()
    move.reset()
    gravity.reset()
    console.reset()

func _on_win() -> void:
    reset_all_abilities()
    disable_all_abilities()
    animator.reset()
    velocity.x = 0
    velocity.y = 0

func _on_shield_iframes_end() -> void:
    #print("C ", danger_zones)
    if danger_zones > 0:
        death.emit()


func _on_hit_box_body_entered(_body: Node2D) -> void:
    _on_hit_box_area_entered(null)

func _on_hit_box_body_exited(_body: Node2D) -> void:
    _on_hit_box_area_exited(null)

func _on_squish_box_body_entered(_body: Node2D) -> void:
    _on_hit_box_area_entered(null)

func _on_squish_box_body_exited(_body: Node2D) -> void:
    _on_hit_box_area_exited(null)
