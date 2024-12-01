extends Level

@onready var moving := $Moving as Level12Moving

func _on_button_click(on: bool) -> void:
    if on:
        moving.reverse()
        
