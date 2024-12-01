@icon("res://assets/script_icons/stopwatch.svg")
extends Node
class_name Stopwatch

enum State { PAUSED, WORKING }

var last_time_stamp: int
var last_pause_time: int
var state: State

func _init() -> void:
    last_time_stamp = 0
    last_pause_time = 0
    state = State.PAUSED

func reset() -> void:
    last_time_stamp = 0
    last_pause_time = 0
    state = State.PAUSED

func resume() -> void:
    if state == State.WORKING:
        return
    last_time_stamp = Time.get_ticks_usec()
    state = State.WORKING

func pause() -> void:
    if state == State.PAUSED:
        return
    last_pause_time = get_microseconds()
    last_time_stamp = Time.get_ticks_usec()
    state = State.PAUSED

func get_microseconds() -> int:
    if state == State.PAUSED:
        return last_pause_time
    return Time.get_ticks_usec() - last_time_stamp + last_pause_time

func get_time() -> float:
    return get_microseconds() / 1e6
