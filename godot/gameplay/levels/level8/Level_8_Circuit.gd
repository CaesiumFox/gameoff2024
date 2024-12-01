extends Node2D

@export var zero: Color
@export var one: Color

@onready var wire_1 := $Wire1 as TileMapLayer
@onready var wire_2 := $Wire2 as TileMapLayer
@onready var wire_3 := $Wire3 as TileMapLayer
@onready var wire_4 := $Wire4 as TileMapLayer
@onready var wire_5 := $Wire5 as TileMapLayer
@onready var wire_6 := $Wire6 as TileMapLayer
@onready var wire_7 := $Wire7 as TileMapLayer
@onready var wire_8 := $Wire8 as TileMapLayer
@onready var wire_9 := $Wire9 as TileMapLayer
@onready var wire_10 := $Wire10 as TileMapLayer
@onready var wire_11 := $Wire11 as TileMapLayer

@onready var laser_1 := $Laser1 as Area2D
@onready var laser_2 := $Laser2 as Area2D

var wire_1_val: bool = false
var wire_2_val: bool = false
var wire_3_val: bool = false
var wire_4_val: bool = false
var wire_5_val: bool = false
var wire_6_val: bool = false
var wire_7_val: bool = false
var wire_8_val: bool = false
var wire_9_val: bool = false
var wire_10_val: bool = false
var wire_11_val: bool = false

var wire_4_old_val: bool = false
var wire_10_old_val: bool = false

func recalculate() -> void:
    wire_2_val = not wire_1_val
    wire_4_val = wire_1_val != wire_3_val
    wire_5_val = wire_5_val != (wire_4_val and not wire_4_old_val)
    wire_6_val = wire_2_val or wire_4_val
    wire_8_val = wire_3_val and wire_5_val
    wire_9_val = wire_7_val and wire_8_val
    wire_10_val = not wire_9_val or wire_6_val
    wire_11_val = wire_11_val != (wire_10_val and not wire_10_old_val)
    # ---
    wire_4_old_val = wire_4_val
    wire_10_old_val = wire_10_val

func recolor() -> void:
    wire_1.modulate = one if wire_1_val else zero
    wire_2.modulate = one if wire_2_val else zero
    wire_3.modulate = one if wire_3_val else zero
    wire_4.modulate = one if wire_4_val else zero
    wire_5.modulate = one if wire_5_val else zero
    wire_6.modulate = one if wire_6_val else zero
    wire_7.modulate = one if wire_7_val else zero
    wire_8.modulate = one if wire_8_val else zero
    wire_9.modulate = one if wire_9_val else zero
    wire_10.modulate = one if wire_10_val else zero
    wire_11.modulate = one if wire_11_val else zero

func retrigger() -> void:
    laser_1.set_deferred("monitorable", wire_10_val)
    laser_1.visible = wire_10_val
    laser_2.set_deferred("monitorable", wire_11_val)
    laser_2.visible = wire_11_val

func reeverything() -> void:
    recalculate()
    recolor()
    retrigger()

func _ready() -> void:
    reeverything()

func _on_button_1_click(on: bool) -> void:
    if on:
        wire_1_val = not wire_1_val
        reeverything()

func _on_button_2_click(on: bool) -> void:
    if on:
        wire_3_val = not wire_3_val
        reeverything()

func _on_button_3_click(on: bool) -> void:
    if on:
        wire_7_val = not wire_7_val
        reeverything()
