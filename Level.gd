extends Node2D
class_name Level

func get_spawn_point() -> Vector2:
    var spawn_point: Node = get_node_or_null("Spawn")
    if spawn_point != null and spawn_point is Node2D:
        return (spawn_point as Node2D).position
    else:
        return Vector2(0, 0)
