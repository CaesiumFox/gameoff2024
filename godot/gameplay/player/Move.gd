extends Node

signal start_left
signal start_right
signal stop

@export var enabled: bool = true
@export var player: CharacterBody2D

var old_vel: float = 0.0

func reset() -> void:
    old_vel = 0.0

func _physics_process(delta: float) -> void:
    if not enabled: return
    
    var vel := Input.get_axis("game_left", "game_right") * PhysicsCalculator.speed()
    
    if sign(old_vel) != sign(vel):
        if vel < 0.01 and vel > -0.01:
            vel = 0.0
            stop.emit()
        elif vel <= -0.01:
            start_left.emit()
        else:
            start_right.emit()

    old_vel = vel
    
    var acc := (PhysicsCalculator.ground_movement_acceleration()
        if player.is_on_floor()
        else PhysicsCalculator.air_movement_acceleration())
    var dec := (PhysicsCalculator.ground_movement_deceleration()
        if player.is_on_floor()
        else PhysicsCalculator.air_movement_deceleration())
    
    var pos := acc if player.velocity.x > 0 else dec
    var neg := dec if player.velocity.x > 0 else acc
    
    if vel < player.velocity.x:
        player.velocity.x -= neg * delta
        if player.velocity.x < vel: player.velocity.x = vel
    else:
        player.velocity.x += pos * delta
        if player.velocity.x > vel: player.velocity.x = vel
