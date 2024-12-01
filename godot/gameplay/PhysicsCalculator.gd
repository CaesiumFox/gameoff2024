extends Node

signal gravity_changed(upwards: bool)

const UNIT: float = 16

const BASE_JUMP_HEIGHT: float = 2.1 * UNIT
const BASE_JUMP_LENGTH: float = 4.0 * UNIT
const BASE_SPEED: float = 7.0 * UNIT

const BASE_JUMP_TIME: float = BASE_JUMP_LENGTH / BASE_SPEED
const BASE_JUMP_SPEED: float = 4.0 * BASE_JUMP_HEIGHT / BASE_JUMP_TIME
const GRAVITY: float = 8.0 * BASE_JUMP_HEIGHT / (BASE_JUMP_TIME * BASE_JUMP_TIME)

const BASE_GROUND_MOVEMENT_ACCELERATION_LENGTH: float = 0.5 * UNIT
const BASE_GROUND_MOVEMENT_DECELERATION_LENGTH: float = 0.1 * UNIT
const BASE_AIR_MOVEMENT_ACCELERATION_LENGTH: float = 1.0 * UNIT
const BASE_AIR_MOVEMENT_DECELERATION_LENGTH: float = 0.2 * UNIT

const BASE_GROUND_MOVEMENT_ACCELERATION: float = (
        BASE_SPEED * BASE_SPEED) / (2.0 * BASE_GROUND_MOVEMENT_ACCELERATION_LENGTH)
const BASE_GROUND_MOVEMENT_DECELERATION: float = (
        BASE_SPEED * BASE_SPEED) / (2.0 * BASE_GROUND_MOVEMENT_DECELERATION_LENGTH)
const BASE_AIR_MOVEMENT_ACCELERATION: float = (
        BASE_SPEED * BASE_SPEED) / (2.0 * BASE_AIR_MOVEMENT_ACCELERATION_LENGTH)
const BASE_AIR_MOVEMENT_DECELERATION: float = (
        BASE_SPEED * BASE_SPEED) / (2.0 * BASE_AIR_MOVEMENT_DECELERATION_LENGTH)

var desired_jump_height: float = BASE_JUMP_HEIGHT
var desired_speed: float = BASE_SPEED
var inverted_gravity: bool = false:
    get:
        return inverted_gravity
    set(new_inverted_gravity):
        var did_change: bool = inverted_gravity != new_inverted_gravity
        inverted_gravity = new_inverted_gravity
        if did_change:
            gravity_changed.emit(inverted_gravity)

func _ready() -> void:
    ProjectSettings.set_setting("physics/2d/default_gravity", GRAVITY)

func gravity() -> float:
    if inverted_gravity:
        return -GRAVITY
    return GRAVITY

func jump_speed() -> float:
    var retval := BASE_JUMP_SPEED * sqrt(desired_jump_height / BASE_JUMP_HEIGHT)
    if inverted_gravity:
        return -retval
    return retval

func wall_jump_speed_v() -> float:
    return jump_speed()

func wall_jump_speed_h() -> float:
    return jump_speed()

func speed() -> float:
    return desired_speed

func ground_movement_acceleration() -> float:
    return BASE_GROUND_MOVEMENT_ACCELERATION

func ground_movement_deceleration() -> float:
    return BASE_GROUND_MOVEMENT_DECELERATION

func air_movement_acceleration() -> float:
    return BASE_AIR_MOVEMENT_ACCELERATION

func air_movement_deceleration() -> float:
    return BASE_AIR_MOVEMENT_DECELERATION
