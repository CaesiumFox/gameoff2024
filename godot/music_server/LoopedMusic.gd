extends AudioStreamPlayer
class_name LoopedMusic

signal music_repeat

var timer: Timer
var default_volume: float

func _ready() -> void:
    default_volume = volume_db
    timer = Timer.new()
    timer.autostart = false
    timer.one_shot = false
    timer.wait_time = stream.get_length()
    timer.timeout.connect(music_repeat.emit)
    add_child(timer)

func play_music() -> void:
    volume_db = default_volume
    play()
    timer.start()

func stop_music() -> void:
    stop()
    timer.stop()
