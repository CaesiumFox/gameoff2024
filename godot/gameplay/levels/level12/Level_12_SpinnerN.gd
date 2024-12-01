extends Spinner

func _ready() -> void:
    super._ready()
    const OUT: int = 2
    
    interpolate(total_cells, Vector2i( OUT, ~OUT), Vector2i( OUT,  OUT))
    interpolate(total_cells, Vector2i( OUT,  OUT), Vector2i(~OUT,  OUT))
    interpolate(total_cells, Vector2i(~OUT,  OUT), Vector2i(~OUT, ~OUT))
    interpolate(total_cells, Vector2i(~OUT, ~OUT), Vector2i( OUT, ~OUT))

    count = 14
    delta_cells = [10, 11]
