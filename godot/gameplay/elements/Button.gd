extends Area2D
class_name WorldButton

signal click(on: bool)
signal press
signal release

@onready var animation := $Animation as AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
    if body is not CollisionObject2D: return
    if (body as CollisionObject2D).collision_layer & (1 << 2):  # player
        if body is not Player: return
        animation.play("press")
        click.emit(true)
        press.emit()

func _on_body_exited(body: Node2D) -> void:
    if body is not  CollisionObject2D: return
    if (body as CollisionObject2D).collision_layer & (1 << 2):  # player
        if body is not Player: return
        animation.play("RESET")
        click.emit(false)
        release.emit()