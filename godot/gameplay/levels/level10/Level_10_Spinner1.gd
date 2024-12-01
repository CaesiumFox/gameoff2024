extends Spinner

func _ready() -> void:
    super._ready()
    const OUT: int = 4
    
    interpolate(total_cells, Vector2i( OUT, ~OUT), Vector2i( OUT,  OUT))
    interpolate(total_cells, Vector2i( OUT,  OUT), Vector2i(~OUT,  OUT))
    interpolate(total_cells, Vector2i(~OUT,  OUT), Vector2i(~OUT, ~OUT))
    interpolate(total_cells, Vector2i(~OUT, ~OUT), Vector2i( OUT, ~OUT))

    count = 20
    start_frame = -9
    delta_cells = [1]
    terrain_set = 2
