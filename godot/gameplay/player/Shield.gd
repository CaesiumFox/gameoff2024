extends Node2D
class_name Shield

signal applied
signal broken
signal iframes_end
signal cooled

var active: bool = false

@onready var working := $Working as AnimatedSprite2D
@onready var apply := $Apply as AnimatedSprite2D
@onready var invincibility := $Invincibility as Timer
@onready var cool_down := $CoolDown as Timer
@onready var slide := $UI/Slide as AnimationPlayer
@onready var progress_bar := $UI/NinePatchRect/ProgressBar as ProgressBar

var can_activate: bool = true
var invincible: bool = false

func _ready() -> void:
    progress_bar.max_value = cool_down.wait_time
    reset()

func _process(_delta: float) -> void:
    progress_bar.value = cool_down.time_left

func reset() -> void:
    active = false
    can_activate = true
    invincible = false
    working.stop()
    working.visible = false
    apply.stop()
    apply.visible = false
    invincibility.stop()
    cool_down.stop()
    slide.play("RESET")

func activate() -> bool:
    if not can_activate or active:
        return false
    active = true
    apply.visible = true
    apply.play("default")
    working.visible = true
    working.play("default")
    can_activate = false
    applied.emit()
    return true

func hit() -> bool:
    if active:
        active = false
        working.stop()
        working.visible = false
        invincible = true
        invincibility.start()
        slide.play("show")
        cool_down.start()
        broken.emit()
        return true
    return invincible

func _on_apply_animation_finished() -> void:
    apply.visible = false

func _on_invincibility_timeout() -> void:
    invincible = false
    iframes_end.emit()

func _on_cool_down_timeout() -> void:
    can_activate = true
    slide.play("hide")
    cooled.emit()
