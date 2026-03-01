extends Node
class_name PlayerStats

# Level/EXP
@export var level: int = 1
@export var exp: int = 0
@export var exp_needed: int = 100
@export var exp_increase_step: int = 25

# Base stats
@export var base_hp: int = 50
@export var base_def: int = 5
@export var base_atk: int = 10
@export var base_move_speed: float = 200.0

# Growth (temporary; class system later)
@export var hp_growth: int = 5
@export var def_growth: int = 2
@export var atk_growth: int = 3

var current_hp: int

func _ready() -> void:
	current_hp = max_hp()

# Total stats = base + level * growth
func max_hp() -> int:
	return base_hp + level * hp_growth

func def_stat() -> int:
	return base_def + level * def_growth

func atk_stat() -> int:
	return base_atk + level * atk_growth
