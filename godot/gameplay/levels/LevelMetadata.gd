extends Node

class Metadata:
    var star_1_threshold: float = 0.0
    var star_2_threshold: float = 0.0
    var star_3_threshold: float = 0.0
    
    func _init(s1: float, s2: float, s3: float) -> void:
        star_1_threshold = s1
        star_2_threshold = s2
        star_3_threshold = s3

var data: Array[Metadata] = [
    Metadata.new( 30, 15,  6),
    Metadata.new( 60, 40, 20),
    Metadata.new( 30, 12,  6),
    Metadata.new( 40, 20, 10),
    Metadata.new( 30, 15,  3),
    Metadata.new( 30, 15, 10),
    Metadata.new( 48, 24, 12),
    Metadata.new(120, 90, 60),
    Metadata.new( 60, 45, 30),
    Metadata.new( 40, 25, 15),
    Metadata.new( 45, 30,  5),
    Metadata.new(120, 90, 60),
]
