extends Control
class_name AchievementsMenu

signal back_requested

@onready var achievement1 := $Center/Achievement1 as AchievementBox
@onready var achievement2 := $Center/Achievement2 as AchievementBox
@onready var achievement3 := $Center/Achievement3 as AchievementBox
@onready var achievement4 := $Center/Achievement4 as AchievementBox
@onready var achievement5 := $Center/Achievement5 as AchievementBox
@onready var description := $Bottom/Description as Label

func cond1() -> bool:
    # Inverted Gravity is granted for
    # collecting _ stars
    return false

func cond2() -> bool:
    # Wall Jump is granted for
    # collecting 4 stars
    return SaveManager.data.levels.total_star_count() >= 4

func cond3() -> bool:
    # Double Jump is granted for
    # collecting _ coins
    return false

func cond4() -> bool:
    # Triple Jump is granted for
    # collecting everything
    return (
        SaveManager.data.levels.total_star_count() >= 3 * 12
        and SaveManager.data.levels.total_coin_count() >= 12
    )

func cond5() -> bool:
    # Shield is granted for
    # collecting _ coins
    return false

func _ready() -> void:
    reload()

func reload() -> void:
    grab_focus()
    achievement1.achieved = cond1()
    achievement2.achieved = cond2()
    achievement3.achieved = cond3()
    achievement4.achieved = cond4()
    achievement5.achieved = cond5()
    description.text = ""

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        back_requested.emit()

func _on_achievement_1_request_description(achieved: bool) -> void:
    description.text = tr("A_1_1" if achieved else "A_1_0")

func _on_achievement_2_request_description(achieved: bool) -> void:
    description.text = tr("A_2_1" if achieved else "A_2_0")

func _on_achievement_3_request_description(achieved: bool) -> void:
    description.text = tr("A_3_1" if achieved else "A_3_0")

func _on_achievement_4_request_description(achieved: bool) -> void:
    description.text = tr("A_4_1" if achieved else "A_4_0")

func _on_achievement_5_request_description(achieved: bool) -> void:
    description.text = tr("A_5_1" if achieved else "A_5_0")



func _on_back_button_pressed() -> void:
    back_requested.emit()
