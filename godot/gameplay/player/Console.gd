extends Ability
class_name ConsoleAbility

@export var shield: Shield

@onready var console := $UI/Console as Console
@onready var wrong_sound := $WrongSound as AudioStreamPlayer
@onready var invert_sound := $InvertSound as AudioStreamPlayer
@onready var power_up_sound := $PowerUpSound as AudioStreamPlayer

var current_hash: int = 0
var console_opened: bool = false

func reset() -> void:
    console_opened = false
    console.visible = false
    wrong_sound.stop()
    invert_sound.stop()
    power_up_sound.stop()
    unlock_abilities()

func action(_delta: float) -> void:
    if console_opened: return

    if Input.is_action_just_pressed("game_console"):
        console_opened = true
        lock_abilities()
        console.visible = true
        console.ignore_exit = true
        console.reset_focus()

    if Input.is_action_just_pressed("game_execute"):
        match current_hash:
            8794265229978523055:  # all off
            #    print("Hello")
                 pass
            -5946216267815589025:  # all on
            #    print("World")
                 pass
            -3385780115000047589:  # invert gravity
                invert_sound.play()
                PhysicsCalculator.inverted_gravity = not PhysicsCalculator.inverted_gravity
            -3441390707128674805:  # activate wall jump
                if not SaveManager.data.abilities.wall_jump:
                    power_up_sound.play()
                    SaveManager.data.abilities.wall_jump = true
            2891475358436697532:  # activate double jump
                if SaveManager.data.abilities.air_jumps < 1:
                    power_up_sound.play()
                    SaveManager.data.abilities.air_jumps = 1
            8319217979696709123:  # activate triple jump
                if SaveManager.data.abilities.air_jumps < 2:
                    power_up_sound.play()
                    SaveManager.data.abilities.air_jumps = 2
            -7231277095096570745:  # add shield
                if shield:
                    shield.activate()
            _:
                wrong_sound.play()

func _on_console_exited(returned_hash: int) -> void:
    console_opened = false
    current_hash = returned_hash
    console.visible = false
    unlock_abilities()
    #print("Hash: ", current_hash)
