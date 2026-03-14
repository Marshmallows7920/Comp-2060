extends Item
class_name HealItem

@export var heal_amount: int = 20

func use(player) -> void:
	player.heal(heal_amount)
