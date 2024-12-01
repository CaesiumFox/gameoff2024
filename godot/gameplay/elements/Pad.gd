extends Area2D
class_name Pad

const EPS: float = 0.1
const COEFF: float = sqrt(1.5)

@onready var pad_sound: AudioStreamPlayer = $PadSound
@onready var animation: AnimationPlayer = $Animation

func _on_body_entered(body: Node2D) -> void:
    var new_velocity: float = 0
    
    if rotation < EPS or rotation > 2 * PI - EPS:
        if not PhysicsCalculator.inverted_gravity:
            new_velocity = -PhysicsCalculator.jump_speed() * COEFF
        else:
            return
    elif rotation > PI - EPS and rotation < PI + EPS:
        if not PhysicsCalculator.inverted_gravity:
            new_velocity = PhysicsCalculator.jump_speed() * COEFF
        else:
            return

    if body is not CollisionObject2D: return
    if (body as CollisionObject2D).collision_layer & (1 << 2):  # player
        if body is not Player: return
        (body as Player).velocity.y = new_velocity
        pad_sound.play()
        animation.play("bounce")
