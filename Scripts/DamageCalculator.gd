extends Node
class_name DamageCalculator

const TYPE_MAGIC := "Magic"
const TYPE_PHYSIC := "Physic"
const TYPE_PSYCHIC := "Psychic"

static func get_type_modifier(attack_type: String, defend_type: String) -> float:
	match attack_type:
		TYPE_MAGIC:
			if defend_type == TYPE_PSYCHIC:
				return 1.1   # effective
			elif defend_type == TYPE_PHYSIC:
				return 0.9   # ineffective

		TYPE_PHYSIC:
			if defend_type == TYPE_MAGIC:
				return 1.1
			elif defend_type == TYPE_PSYCHIC:
				return 0.9

		TYPE_PSYCHIC:
			if defend_type == TYPE_PHYSIC:
				return 1.1
			elif defend_type == TYPE_MAGIC:
				return 0.9

	return 1.0


static func calculate_damage(attack: int, defense: int, attack_type: String, defend_type: String) -> int:
	var type_mod: float = get_type_modifier(attack_type, defend_type)
	var raw_damage: float = (attack - defense) * type_mod
	return max(1, roundi(raw_damage))
