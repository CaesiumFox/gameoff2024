extends Ability
class_name GravityAbility

func reset() -> void:
    pass

func action(delta: float) -> void:
    if not enabled: return
    player.velocity.y += PhysicsCalculator.gravity() * delta
