extends Node

enum State {
    MAIN,
    LEVEL,
    PLAY,
    ACH,
    RECORDS,
    CREDITS,
    OPTIONS,
}

@onready var shading: TextureRect = $ShadingLayer/Shading
@onready var shading_animation: AnimationPlayer = $ShadingAnimation
@onready var death_shade_timer: Timer = $DeathShadeTimer

var gameplay: Gameplay
var main_menu: MainMenu
var achievements: AchievementsMenu
var records: RecordsMenu
var options: OptionsMenu
var credits: CreditsMenu
var level_menu: LevelMenu
var current_level_id: int = 0

var state: State = State.MAIN

var gameplay_scene := preload("res://gameplay/Gameplay.tscn")
var main_menu_scene := preload("res://ui/main_menu/MainMenu.tscn")
var achievements_scene := preload("res://ui/achievements/Achievements.tscn")
var records_scene := preload("res://ui/records/Records.tscn")
var options_scene := preload("res://ui/options/Options.tscn")
var credits_scene := preload("res://ui/credits/Credits.tscn")
var level_menu_scene := preload("res://ui/level_menu/LevelMenu.tscn")
var level_scenes: Array[PackedScene] = [
    preload("res://gameplay/levels/Level_1.tscn"),
    preload("res://gameplay/levels/Level_2.tscn"),
    preload("res://gameplay/levels/LevelBlank.tscn"),
    preload("res://gameplay/levels/LevelBlank.tscn"),
    preload("res://gameplay/levels/LevelBlank.tscn"),
    preload("res://gameplay/levels/LevelBlank.tscn"),
    preload("res://gameplay/levels/LevelBlank.tscn"),
    preload("res://gameplay/levels/LevelBlank.tscn"),
    preload("res://gameplay/levels/LevelBlank.tscn"),
    preload("res://gameplay/levels/LevelBlank.tscn"),
    preload("res://gameplay/levels/LevelBlank.tscn"),
    preload("res://gameplay/levels/LevelBlank.tscn"),
]

var lock: bool = false

func _ready() -> void:
    death_shade_timer.timeout.connect(shade_in)
    
    # Main Menu
    main_menu = main_menu_scene.instantiate() as MainMenu
    main_menu.play_requested.connect(play)
    main_menu.achievements_requested.connect(show_achievements)
    main_menu.records_requested.connect(show_records)
    main_menu.options_requested.connect(show_options)
    main_menu.credits_requested.connect(show_credits)
    main_menu.quit_requested.connect(quit)

    # Achievements
    achievements = achievements_scene.instantiate() as AchievementsMenu
    achievements.back_requested.connect(hide_achievements)

    # Records
    records = records_scene.instantiate() as RecordsMenu
    records.back_requested.connect(hide_records)

    # Options
    options = options_scene.instantiate() as OptionsMenu
    options.back_requested.connect(hide_options)

    # Credits
    credits = credits_scene.instantiate() as CreditsMenu
    credits.back_requested.connect(hide_credits)

    # Level Menu
    level_menu = level_menu_scene.instantiate() as LevelMenu
    level_menu.selected.connect(level_selected)
    level_menu.back.connect(level_menu_back)

    # Gameplay
    gameplay = gameplay_scene.instantiate() as Gameplay
    gameplay.level_loaded.connect(shade_out)
    gameplay.player_death.connect(death)
    gameplay.win.connect(win)
    gameplay.level_exit.connect(level_exit)

    # Init
    add_child(main_menu)

func quit() -> void:
    if lock: return
    lock = true
    get_tree().quit()
    lock = false

func show_achievements() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(main_menu)
    state = State.ACH
    add_child(achievements)
    achievements.reload()
    shade_out()
    lock = false
    pass
    
func hide_achievements() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(achievements)
    state = State.MAIN
    add_child(main_menu)
    main_menu.reset()
    shade_out()
    lock = false
    pass

func show_records() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(main_menu)
    state = State.RECORDS
    add_child(records)
    records.reload()
    shade_out()
    lock = false
    pass
    
func hide_records() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(records)
    state = State.MAIN
    add_child(main_menu)
    main_menu.reset()
    shade_out()
    lock = false
    pass

func show_options() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(main_menu)
    state = State.RECORDS
    add_child(options)
    options.reload()
    shade_out()
    lock = false
    pass
    
func hide_options() -> void:
    if lock: return
    lock = true
    SaveManager.save_settings()
    shade_in()
    await shading_animation.animation_finished
    remove_child(options)
    state = State.MAIN
    add_child(main_menu)
    main_menu.reset()
    shade_out()
    lock = false
    pass

func show_credits() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(main_menu)
    state = State.RECORDS
    add_child(credits)
    credits.reload()
    shade_out()
    lock = false
    pass
    
func hide_credits() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(credits)
    state = State.MAIN
    add_child(main_menu)
    main_menu.reset()
    shade_out()
    lock = false
    pass

func play() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(main_menu)
    state = State.LEVEL
    add_child(level_menu)
    level_menu.reset()
    shade_out()
    lock = false

func level_selected(id: int) -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(level_menu)
    state = State.PLAY
    add_child(gameplay)
    gameplay.load_level(level_scenes[id])
    current_level_id = id
    lock = false

func level_menu_back() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(level_menu)
    state = State.MAIN
    add_child(main_menu)
    main_menu.reset()
    shade_out()
    lock = false

func level_exit() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(gameplay)
    state = State.LEVEL
    add_child(level_menu)
    SaveManager.save_file()
    level_menu.reset()
    shade_out()
    lock = false

func death() -> void:
    death_shade_timer.start()
    SaveManager.data.levels.levels[current_level_id].deaths += 1

func win(time: float, coin: bool) -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(gameplay)
    state = State.LEVEL
    add_child(level_menu)
    SaveManager.data.levels.levels[current_level_id].try_set_best_time(time)
    SaveManager.data.levels.levels[current_level_id].try_set_coin(coin)
    SaveManager.data.levels.levels[current_level_id].completed = true
    if current_level_id < 11:
        SaveManager.data.levels.levels[current_level_id + 1].unlocked = true
    SaveManager.save_file()
    level_menu.reset()
    shade_out()
    lock = false

func shade_in() -> void:
    shading_animation.play("shade_in")

func shade_out() -> void:
    shading_animation.play("shade_out")
