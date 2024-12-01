@tool
extends TextureRect
class_name CollectedIndicator

@export var off: Vector2 = Vector2(0,0)
@export var on: Vector2 = Vector2(0,12)

@export var collected: bool = false:
    get:
        return collected
    set(new_collected):
        collected = new_collected
        update_collected()

var atlas: AtlasTexture

func update_collected():
    if atlas:
        atlas.region.position = on if collected else off

func _ready() -> void:
    atlas = texture as AtlasTexture
    update_collected()
    
    
