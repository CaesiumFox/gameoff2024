extends CharacterBody2D
class_name Player

signal death
signal win

@onready var shape: CollisionShape2D = $Shape

@onready var jump: JumpAbility = $Jump as JumpAbility
@onready var wall_jump: WallJumpAbility = $Jump/WallJump
@onready var move: MoveAbility = $Move as MoveAbility
@onready var gravity: GravityAbility = $Gravity as GravityAbility
@onready var console: ConsoleAbility = $Console

@onready var camera: Camera2D = $Camera as Camera2D
@onready var jump_particles: CPUParticles2D = $Particles/JumpParticles as CPUParticles2D
@onready var death_particles: CPUParticles2D = $Particles/DeathParticles as CPUParticles2D
@onready var land_particles: CPUParticles2D = $Particles/LandParticles as CPUParticles2D
@onready var jump_sound: AudioStreamPlayer = $JumpSound as AudioStreamPlayer
@onready var death_sound: AudioStreamPlayer = $DeathSound as AudioStreamPlayer
@onready var land_sound: AudioStreamPlayer = $LandSound as AudioStreamPlayer
@onready var animator: Animator = $Animator as Animator

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
    velocity.x = 0
    velocity.y = 0

func prepare_for_load() -> void:
    jump.reset_air_jumps()
    camera.reset_smoothing()

func set_camera_limits(view_box: Rect2) -> void:
    camera.limit_left = int(view_box.position.x)
    camera.limit_top = int(view_box.position.y)
    camera.limit_right = int(view_box.end.x)
    camera.limit_bottom = int(view_box.end.y)

func _on_hit_box_area_entered(area: Area2D) -> void:
    if area.collision_layer & (1 << 5) > 0:  # damage
        death.emit()
    elif area.collision_layer & (1 << 8) > 0:  # exit
        win.emit()
    else:
        pass

func _on_jump_jump(_air: bool) -> void:
    jump_particles.restart()
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
