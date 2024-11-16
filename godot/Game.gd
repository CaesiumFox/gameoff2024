extends Node

@onready var level_loader: Node2D = $Gameplay
var test_level := preload("res://gameplay/levels/Level001.tscn")

func _ready() -> void:
    level_loader.load_level(test_level)
