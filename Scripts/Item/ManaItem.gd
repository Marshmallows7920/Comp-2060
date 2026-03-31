extends Item
class_name ManaItem

@export var recover_amount: int = 20

func use(player) -> void:
	player.restore_mana(recover_amount)
