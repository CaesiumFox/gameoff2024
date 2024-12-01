extends Node2D
class_name Level12Moving

@onready var spinners: Array[Spinner] = [
    $BigLoop/Spinner1 as Spinner,
    $BigLoop/Spinner2 as Spinner,
    $BigLoop/Spinner3 as Spinner,
    $BigLoop/Spinner4 as Spinner,
    $BigLoop/Spinner5 as Spinner,
    $BigLoop/Spinner6 as Spinner,
    $BigLoop/Spinner7 as Spinner,
    $BigLoop/Spinner8 as Spinner,
    $BigLoop/Spinner9 as Spinner,
    $BigLoop/Spinner10 as Spinner,
    $BigLoop/Spinner11 as Spinner,
    $BigLoop/Spinner12 as Spinner,
    $BigLoop/Spinner13 as Spinner,
    $BigLoop/Spinner14 as Spinner,
    $BigLoop/Spinner15 as Spinner,
    $BigLoop/Spinner16 as Spinner,
    $Spinner2 as Spinner,
    $Spinner3 as Spinner,
    $Spinner4 as Spinner,
    $Spinner5 as Spinner,
]

func reverse() -> void:
    for spinner in spinners:
        spinner.delta_frame = -spinner.delta_frame
