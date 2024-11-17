extends CharacterBody2D
class_name Player

signal death
signal win

@onready var shape: CollisionShape2D = $Shape
@onready var jump: Node = $Jump
@onready var move: Node = $Move
@onready var gravity: Node = $Gravity
@onready var camera: Camera2D = $Camera
@onready var jump_particles: CPUParticles2D = $JumpParticles
@onready var death_particles: CPUParticles2D = $DeathParticles
@onready var land_particles: CPUParticles2D = $LandParticles
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var death_sound: AudioStreamPlayer = $DeathSound
@onready var land_sound: AudioStreamPlayer = $LandSound
@onready var animator: Node = $Animator

func _ready() -> void:
    (shape.shape as RectangleShape2D).size.x -= 2 * safe_margin
    (shape.shape as RectangleShape2D).size.y -= 2 * safe_margin

func _physics_process(_delta: float) -> void:
    move_and_slide()

func reset() -> void:
    jump.reset()
    move.reset()
    gravity.reset()
    animator.reset()

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
