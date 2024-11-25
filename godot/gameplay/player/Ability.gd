extends Node
class_name Ability

@export var enabled: bool = true
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
