extends Node

@onready var shading: TextureRect = $ShadingLayer/Shading
@onready var shading_animation: AnimationPlayer = $ShadingAnimation
@onready var death_shade_timer: Timer = $DeathShadeTimer

var gameplay: Gameplay
var main_menu: MainMenu
var level_menu: LevelMenu

var gameplay_scene := preload("res://gameplay/Gameplay.tscn")
var main_menu_scene := preload("res://ui/main_menu/MainMenu.tscn")
var level_menu_scene := preload("res://ui/level_menu/LevelMenu.tscn")
var level_scenes: Array[PackedScene] = [
    preload("res://gameplay/levels/Level001.tscn")
]

var lock: bool = false

func _ready() -> void:
    death_shade_timer.timeout.connect(shade_in)
    
    # Main Menu
    main_menu = main_menu_scene.instantiate() as MainMenu
    main_menu.quit_requested.connect(quit)
    main_menu.play_requested.connect(play)

    # Level Menu
    level_menu = level_menu_scene.instantiate() as LevelMenu
    level_menu.selected.connect(level_selected)
    level_menu.back.connect(level_menu_back)

    # Gameplay
    gameplay = gameplay_scene.instantiate() as Gameplay
    gameplay.level_loaded.connect(shade_out)
    gameplay.player_death.connect(func(): death_shade_timer.start())
    gameplay.level_exit.connect(win)

    # Init
    add_child(main_menu)

func quit() -> void:
    if lock: return
    lock = true
    get_tree().quit()
    lock = false

func play() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(main_menu)
    add_child(level_menu)
    level_menu.reset()
    shade_out()
    lock = false

func level_selected(_id: int) -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(level_menu)
    add_child(gameplay)
    gameplay.load_level(level_scenes[0])
    lock = false

func level_menu_back() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(level_menu)
    add_child(main_menu)
    main_menu.reset()
    shade_out()
    lock = false

func win() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(gameplay)
    add_child(level_menu)
    level_menu.reset()
    shade_out()
    lock = false

func shade_in() -> void:
    shading_animation.play("shade_in")

func shade_out() -> void:
    shading_animation.play("shade_out")
