extends Spinner

func _ready() -> void:
    super._ready()
    
    interpolate(total_cells, Vector2i( 0, 0), Vector2i( 3, 0))
    interpolate(total_cells, Vector2i( 3, 0), Vector2i( 3, 6))
    interpolate(total_cells, Vector2i( 3, 6), Vector2i( 0, 6))
    interpolate(total_cells, Vector2i( 0, 6), Vector2i( 0, 0))
    interpolate(total_cells, Vector2i( 0, 0), Vector2i(-3, 0))
    interpolate(total_cells, Vector2i(-3, 0), Vector2i(-3, 6))
    interpolate(total_cells, Vector2i(-3, 6), Vector2i( 0, 6))
    interpolate(total_cells, Vector2i( 0, 6), Vector2i( 0, 0))

    count = 9
    start_frame = 0
    delta_cells = [1]
    terrain_set = 4
