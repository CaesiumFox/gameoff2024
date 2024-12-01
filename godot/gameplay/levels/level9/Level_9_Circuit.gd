extends Node2D

@export var zero: Color
@export var one: Color

@onready var wire_1 := $Wire1 as TileMapLayer
@onready var wire_2 := $Wire2 as TileMapLayer
@onready var wire_low_1 := $WireLow1 as TileMapLayer
@onready var wire_low_2 := $WireLow2 as TileMapLayer
@onready var laser_1 := $Laser1 as Area2D
@onready var laser_2 := $Laser2 as Area2D

var wire_1_val: bool = false:
    get:
        return wire_1_val
    set(new):
        var old = wire_1_val
        wire_1_val = new
        wire_1.modulate = one if wire_1_val else zero
        if not old and new:
            wire_2_val = not wire_2_val

var wire_2_val: bool = false:
    get:
        return wire_2_val
    set(new):
        wire_2_val = new
        wire_2.modulate = one if wire_2_val else zero
        laser_1.set_deferred("monitorable", wire_2_val)
        laser_1.visible = wire_2_val

var wire_low_1_val: bool = false:
    get:
        return wire_low_1_val
    set(new):
        wire_low_1_val = new
        wire_low_1.modulate = one if wire_low_1_val else zero
        laser_2.set_deferred("monitorable", wire_low_1_val or wire_low_2_val)
        laser_2.visible = wire_low_1_val or wire_low_2_val

var wire_low_2_val: bool = false:
    get:
        return wire_low_2_val
    set(new):
        wire_low_2_val = new
        wire_low_2.modulate = one if wire_low_2_val else zero
        laser_2.set_deferred("monitorable", wire_low_1_val or wire_low_2_val)
        laser_2.visible = wire_low_1_val or wire_low_2_val

func _ready() -> void:
    wire_2_val = true
    wire_low_1_val = true
    wire_low_2_val = true

func _on_button_click(on: bool) -> void:
    wire_1_val = on

func _on_button_low_1_click(on: bool) -> void:
    if on:
        wire_low_1_val = not wire_low_1_val

func _on_button_low_2_click(on: bool) -> void:
    if on:
        wire_low_2_val = not wire_low_2_val
