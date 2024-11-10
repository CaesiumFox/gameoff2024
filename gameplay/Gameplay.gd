extends Node2D

signal level_loaded

@export var player_scene: PackedScene

var current_level: Level = null
var player: CharacterBody2D = null
var level_scene: PackedScene = null

func load_level(scene: PackedScene) -> void:
    level_scene = scene
    if player == null:
        player = player_scene.instantiate() as CharacterBody2D
        add_child(player)
    var level := scene.instantiate() as Level
    if current_level != null:
        remove_child(current_level)
    current_level = level
    add_child(current_level)
    player.position = level.get_spawn_point()
    level_loaded.emit()

func restart_level() -> void:
    if level_scene == null:
        return
    load_level(level_scene)
