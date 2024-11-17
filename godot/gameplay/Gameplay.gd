extends Node2D

signal level_loaded

@export var player_scene: PackedScene
@onready var timer: Timer = $Timer

var current_level: Level = null
var player: Player = null
var level_scene: PackedScene = null
var restarting: bool = false

func load_level(scene: PackedScene) -> void:
    level_scene = scene
    if player == null:
        player = player_scene.instantiate() as Player
        add_child(player)
        player.death.connect(plan_restart)
    var level := scene.instantiate() as Level
    if current_level != null:
        remove_child(current_level)
    current_level = level
    add_child(level)
    
    level.view_box_changed.connect(player.set_camera_limits)
    
    player.position = level.spawn_point
    player.prepare_for_load()
    player.set_camera_limits(level.view_box)
    player.reset()
    
    get_tree().paused = false
    restarting = false
    level_loaded.emit()

func restart_level() -> void:
    if level_scene == null:
        return
    load_level(level_scene)

func plan_restart() -> void:
    if restarting: return
    restarting = true
    timer.start()
    get_tree().paused = true

func _on_timer_timeout() -> void:
    restart_level()
