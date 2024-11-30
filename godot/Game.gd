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
var statistics: StatisticsMenu
var options: OptionsMenu
var credits: CreditsMenu
var level_menu: LevelMenu
var current_level_id: int = 0

var state: State = State.MAIN

var gameplay_scene := preload("res://gameplay/Gameplay.tscn")
var main_menu_scene := preload("res://ui/main_menu/MainMenu.tscn")
var achievements_scene := preload("res://ui/achievements/Achievements.tscn")
var statistics_scene := preload("res://ui/statistics/Statistics.tscn")
var options_scene := preload("res://ui/options/Options.tscn")
var credits_scene := preload("res://ui/credits/Credits.tscn")
var level_menu_scene := preload("res://ui/level_menu/LevelMenu.tscn")
var level_scenes: Array[PackedScene] = [
    preload("res://gameplay/levels/level1/Level_1.tscn"),
    preload("res://gameplay/levels/level2/Level_2.tscn"),
    preload("res://gameplay/levels/level3/Level_3.tscn"),
    preload("res://gameplay/levels/level4/Level_4.tscn"),
    preload("res://gameplay/levels/level5/Level_5.tscn"),
    preload("res://gameplay/levels/blank/LevelBlank.tscn"),
    preload("res://gameplay/levels/blank/LevelBlank.tscn"),
    preload("res://gameplay/levels/blank/LevelBlank.tscn"),
    preload("res://gameplay/levels/blank/LevelBlank.tscn"),
    preload("res://gameplay/levels/blank/LevelBlank.tscn"),
    preload("res://gameplay/levels/blank/LevelBlank.tscn"),
    preload("res://gameplay/levels/blank/LevelBlank.tscn"),
]

var lock: bool = false

func _ready() -> void:
    death_shade_timer.timeout.connect(shade_in)
    
    # Main Menu
    main_menu = main_menu_scene.instantiate() as MainMenu
    main_menu.play_requested.connect(play)
    main_menu.achievements_requested.connect(show_achievements)
    main_menu.records_requested.connect(show_statistics)
    main_menu.options_requested.connect(show_options)
    main_menu.credits_requested.connect(show_credits)
    main_menu.quit_requested.connect(quit)

    # Achievements
    achievements = achievements_scene.instantiate() as AchievementsMenu
    achievements.back_requested.connect(hide_achievements)

    # Statistics
    statistics = statistics_scene.instantiate() as StatisticsMenu
    statistics.back_requested.connect(hide_statistics)

    # Options
    options = options_scene.instantiate() as OptionsMenu
    options.back_requested.connect(hide_options)

    # Credits
    credits = credits_scene.instantiate() as CreditsMenu
    credits.back_requested.connect(hide_credits)

    # Level Menu
    level_menu = level_menu_scene.instantiate() as LevelMenu
    level_menu.selected.connect(level_selected)
    level_menu.back_requested.connect(level_menu_back)

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

func show_statistics() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(main_menu)
    state = State.RECORDS
    add_child(statistics)
    statistics.reload()
    shade_out()
    lock = false
    pass
    
func hide_statistics() -> void:
    if lock: return
    lock = true
    shade_in()
    await shading_animation.animation_finished
    remove_child(statistics)
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
    Music.enable_gameplay_music()
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
    Music.repeat_main_menu()
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
    SaveManager.data.levels.levels[current_level_id].try_set_best_time(time)
    SaveManager.data.levels.levels[current_level_id].try_set_coin(coin)
    SaveManager.data.levels.levels[current_level_id].completed = true
    if current_level_id < 11:
        SaveManager.data.levels.levels[current_level_id + 1].unlocked = true
    SaveManager.save_file()
    if current_level_id < 11:
        current_level_id += 1
        gameplay.load_level(level_scenes[current_level_id])
    else:
        remove_child(gameplay)
        state = State.LEVEL
        add_child(level_menu)
        level_menu.reset()
        shade_out()
    lock = false

func shade_in() -> void:
    shading_animation.play("shade_in")

func shade_out() -> void:
    shading_animation.play("shade_out")
