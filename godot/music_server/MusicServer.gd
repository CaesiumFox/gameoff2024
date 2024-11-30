extends Node
class_name MusicServer

enum Mode {
    STOPPED,
    NORMAL,
    SWITCHING
}

var tracks: Array[LoopedMusic] = []
var current: int = 0
var next: int = 0
var random: RandomNumberGenerator
var weights: PackedFloat32Array = [1.0, 1.0, 1.0]

@export_range(1.0, 2.0) var mul: float = 1.5
var div: float = 1.0

@onready var music_1 := $Music1 as LoopedMusic
@onready var music_2 := $Music2 as LoopedMusic
@onready var music_3 := $Music3 as LoopedMusic
@onready var music_4 := $Music4 as LoopedMusic

static var already: bool = false

func gen() -> int:
    var retval := random.rand_weighted(weights)
    for i in range(weights.size()):
        if i == retval:
            weights[i] /= div
        else:
            weights[i] *= mul
    return retval + 1

func _ready() -> void:
    if already: return
    already = true
    
    music_1.music_repeat.connect(repeat_main_menu)
    music_2.music_repeat.connect(change_gameplay_music)
    music_3.music_repeat.connect(change_gameplay_music)
    music_4.music_repeat.connect(change_gameplay_music)
    
    tracks.append(music_1)
    tracks.append(music_2)
    tracks.append(music_3)
    tracks.append(music_4)
    
    div = mul ** (weights.size() - 1)
    random = RandomNumberGenerator.new()
    start()

func stop() -> void:
    for track in tracks:
        track.stop_music()

func start() -> void:
    current = 0
    tracks[current].volume_db = 0
    tracks[current].play_music()

func repeat_main_menu() -> void:
    prepare_switch(0, true)

func enable_gameplay_music() -> void:
    prepare_switch(-1, true)

func change_gameplay_music() -> void:
    prepare_switch(-1, false)

func prepare_switch(next_id: int, fast: bool) -> void:
    next = gen() if next_id == -1 else next_id
    if current != next:
        var tween := create_tween()
        tween.tween_property(tracks[current], "volume_db", -80, 1 if fast else 5)
        tween.tween_callback(switch)

func switch() -> void:
    tracks[current].stop_music()
    current = next
    tracks[current].volume_db = 0
    tracks[current].play_music()
    pass
