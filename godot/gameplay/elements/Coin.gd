extends Area2D
class_name Coin

signal collect(id: int)

var falling: bool = false
var velocity: Vector2 = Vector2(0, -100)

@export var id: int = 0
@onready var view: AnimatedSprite2D = $View
@onready var collect_sound: AudioStreamPlayer = $CollectSound

func _ready() -> void:
    view.play()

func _on_body_entered(body: CollisionObject2D) -> void:
    if body.collision_layer & (1 << 2) > 0:
        set_deferred("monitorable", false)
        set_deferred("monitoring", false)
        view.speed_scale = 4.0
        falling = true
        velocity.x = 0
        velocity.y = -250
        velocity = velocity.rotated(deg_to_rad(randf_range(-10, 10)))
        z_index = 1
        collect.emit(id)

func _process(delta: float) -> void:
    if not falling: return
    view.position += velocity * delta
    velocity.y += PhysicsCalculator.GRAVITY * 2 * delta

func _on_viewed_screen_exited() -> void:
    if not falling: return
    falling = false
    visible = false

func _on_collect(_id: int) -> void:
    collect_sound.play()
