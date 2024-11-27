extends Node
class_name Ability

signal just_enabled
signal just_disabled

@export var enabled: bool = true:
    get:
        return enabled
    set(new):
        enabled = new
        (just_enabled if new else just_disabled).emit()

@export var player: CharacterBody2D
@export var prevented: Array[Ability] = []

'''
The algorithm used in this class
HEAVILY relies on sequential
execution of _physics_process
'''

func _physics_process(delta: float) -> void:
    if not enabled: return
    action(delta)

func lock_abilities() -> void:
    for ability in prevented:
        ability.enabled = false

func unlock_abilities() -> void:
    for ability in prevented:
        ability.enabled = true

func action(_delta: float) -> void:
    pass

func reset() -> void:
    pass
