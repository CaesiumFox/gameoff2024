extends Spinner

func _ready() -> void:
    super._ready()
    const OUT: int = 14
    const IN: int = 3
    
    interpolate(total_cells, Vector2i(  IN, ~OUT), Vector2i(  IN,  OUT))
    interpolate(total_cells, Vector2i(  IN,  OUT), Vector2i( OUT,  OUT))
    interpolate(total_cells, Vector2i( OUT,  OUT), Vector2i( OUT,   IN))
    
    interpolate(total_cells, Vector2i( OUT,   IN), Vector2i(~OUT,   IN))
    interpolate(total_cells, Vector2i(~OUT,   IN), Vector2i(~OUT,  OUT))
    interpolate(total_cells, Vector2i(~OUT,  OUT), Vector2i( ~IN,  OUT))
    
    interpolate(total_cells, Vector2i( ~IN,  OUT), Vector2i( ~IN, ~OUT))
    interpolate(total_cells, Vector2i( ~IN, ~OUT), Vector2i(~OUT, ~OUT))
    interpolate(total_cells, Vector2i(~OUT, ~OUT), Vector2i(~OUT,  ~IN))
    
    interpolate(total_cells, Vector2i(~OUT,  ~IN), Vector2i( OUT,  ~IN))
    interpolate(total_cells, Vector2i( OUT,  ~IN), Vector2i( OUT, ~OUT))
    interpolate(total_cells, Vector2i( OUT, ~OUT), Vector2i(  IN, ~OUT))

    count = 24 * 4
    delta_cells = [
        11, 11, 11, 18,
        11, 11, 11, 18,
        11, 11, 11, 18,
        11, 11, 11, 18 + 1,
    ]
