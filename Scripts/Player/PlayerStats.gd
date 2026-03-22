extends Node
class_name PlayerStats

@export var level: int = 1

@export var base_hp: int = 50
@export var base_def: int = 5
@export var base_atk: int = 10
@export var base_move_speed: float = 200.0

@export var hp_growth: int = 5
@export var def_growth: int = 2
@export var atk_growth: int = 3

var current_hp: int
var modifiers: Array[StatModifier] = []


func _ready() -> void:
	current_hp = max_hp()


func update_modifiers(delta: float) -> void:
	for i in range(modifiers.size() - 1, -1, -1):
		var modifier: StatModifier = modifiers[i]

		if modifier.hp_per_second != 0:
			current_hp += modifier.hp_per_second * delta
			current_hp = clamp(current_hp, 0, max_hp())

		if modifier.duration > 0:
			modifier.time_left -= delta
			if modifier.time_left <= 0:
				modifiers.remove_at(i)

	current_hp = min(current_hp, max_hp())


func add_modifier(modifier: StatModifier) -> void:
	if modifier == null:
		return

	var new_modifier: StatModifier = modifier.duplicate()
	new_modifier.setup()
	modifiers.append(new_modifier)

	current_hp = min(current_hp, max_hp())


func remove_modifier(modifier_id: String) -> void:
	for i in range(modifiers.size() - 1, -1, -1):
		if modifiers[i].id == modifier_id:
			modifiers.remove_at(i)

	current_hp = min(current_hp, max_hp())


func get_hp_bonus() -> int:
	var total: int = 0
	for modifier in modifiers:
		total += modifier.hp_bonus
	return total


func get_atk_bonus() -> int:
	var total: int = 0
	for modifier in modifiers:
		total += modifier.atk_bonus
	return total


func get_def_bonus() -> int:
	var total: int = 0
	for modifier in modifiers:
		total += modifier.def_bonus
	return total


func get_speed_bonus() -> float:
	var total: float = 0.0
	for modifier in modifiers:
		total += modifier.speed_bonus
	return total


func max_hp() -> int:
	return base_hp + level * hp_growth + get_hp_bonus()


func atk_stat() -> int:
	return base_atk + level * atk_growth + get_atk_bonus()


func def_stat() -> int:
	return base_def + level * def_growth + get_def_bonus()


func move_speed() -> float:
	return base_move_speed + get_speed_bonus()


func heal(amount: int) -> int:
	if amount <= 0:
		return 0

	var old_hp: int = current_hp
	current_hp = min(current_hp + amount, max_hp())
	return current_hp - old_hp


func take_damage(amount: int) -> int:
	var final_damage: int = max(1, amount - def_stat())
	current_hp -= final_damage
	current_hp = max(current_hp, 0)
	return final_damage


func is_dead() -> bool:
	return current_hp <= 0
