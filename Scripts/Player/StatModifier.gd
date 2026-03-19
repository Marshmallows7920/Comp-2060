extends Resource
class_name StatModifier

@export var id: String = ""

@export var hp_bonus: int = 0
@export var atk_bonus: int = 0
@export var def_bonus: int = 0
@export var speed_bonus: float = 0.0

@export var duration: float = -1.0
@export var hp_per_second: int = 0

var time_left: float = -1.0


func setup() -> void:
	time_left = duration
