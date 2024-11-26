extends Node2D
class_name Gameplay

signal level_loaded
signal level_exit
signal win(time: float, coin: bool)
signal player_death

@export var player_scene: PackedScene
@onready var restart_timer: Timer = $RestartTimer
@onready var stopwatch: Stopwatch = $Stopwatch
@onready var time_label: Label = %Time
@onready var pause_menu: CanvasLayer = $PauseMenu

var current_level: Level = null
var player: Player = null
var level_scene: PackedScene = null
var restarting: bool = false
var coin_collected: bool = true

func load_level(scene: PackedScene) -> void:
    level_scene = scene
    if player == null:
        player = player_scene.instantiate() as Player
        add_child(player)
        player.death.connect(plan_restart)
        player.win.connect(record_win)
    var level := scene.instantiate() as Level
    if current_level != null:
        remove_child(current_level)
    current_level = level
    add_child(level)
    
    level.view_box_changed.connect(player.set_camera_limits)
    level.coin_collected.connect(register_coin_collected)
    level.set_up()
    coin_collected = false
    
    player.position = level.spawn_point
    
    player.prepare_for_load()
    player.set_camera_limits(level.view_box)
    player.reset()
    
    pause_menu.visible = false
    get_tree().paused = false
    stopwatch.reset()
    stopwatch.resume()
    restarting = false
    level_loaded.emit()

func _process(_delta: float) -> void:
    time_label.text = "T: %2.2f" % stopwatch.get_time()
    if Input.is_action_just_pressed("game_pause"):
        get_tree().paused = true
        pause_menu.visible = true
        $PauseMenu/ColorRect/Buttons/ResumeButton.grab_focus()
        stopwatch.pause()

func restart_level() -> void:
    if level_scene == null:
        return
    load_level(level_scene)

func plan_restart() -> void:
    if restarting: return
    restarting = true
    restart_timer.start()
    player_death.emit()
    get_tree().paused = true

func record_win() -> void:
    stopwatch.pause()
    win.emit(stopwatch.get_time(), coin_collected)
    
func register_coin_collected() -> void:
    coin_collected = true

func _on_timer_timeout() -> void:
    restart_level()

func _on_resume_button_selected() -> void:
    pause_menu.visible = false
    get_tree().paused = false
    stopwatch.resume()

func _on_quit_button_selected() -> void:
    level_exit.emit()
