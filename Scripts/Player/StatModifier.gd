extends Resource
class_name StatModifier

@export var id: String = ""
@export var display_name: String = ""

@export var hp_bonus: int = 0
@export var atk_bonus: int = 0
@export var def_bonus: int = 0
@export var speed_bonus: float = 0.0
@export var hp_per_second: int = 0

@export var level: int = 0
@export var max_level: int = 1
@export var base_price: int = 0
@export var price_growth: int = 0


func get_price() -> int:
	return base_price + level * price_growth


func can_level_up() -> bool:
	return level < max_level


func level_up() -> void:
	if level < max_level:
		level += 1


func scaled_hp_bonus() -> int:
	return hp_bonus * level


func scaled_atk_bonus() -> int:
	return atk_bonus * level


func scaled_def_bonus() -> int:
	return def_bonus * level


func scaled_speed_bonus() -> float:
	return speed_bonus * level


func scaled_hp_per_second() -> int:
	return hp_per_second * level
