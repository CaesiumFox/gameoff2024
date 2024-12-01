@tool
extends Sprite2D
class_name PlayerView

@export var frame_xy: Vector2 = Vector2(0, 0):
    get:
        return frame_xy
    set(new_frame_xy):
        frame_xy = new_frame_xy
        update_frame()
@export var invincible_xy: Vector2 = Vector2(0, 0):
    get:
        return invincible_xy
    set(new_invincible_xy):
        invincible_xy = new_invincible_xy
        update_frame()

func update_frame() -> void:
    (texture as AtlasTexture).region.position = (
        frame_xy + invincible_xy) * (texture as AtlasTexture).region.size
