extends Node

@onready var level_loader: Node2D = $LevelLoader
var test_level := preload("res://gameplay/levels/Test.tscn")

func _ready() -> void:
    level_loader.load_level(test_level)
