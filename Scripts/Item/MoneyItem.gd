extends Item
class_name MoneyItem

@export var amount: int = 1

func use(player) -> void:
	player.add_money(amount)
