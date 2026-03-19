extends Node
class_name Inventory

var items: Array = []
var current_index: int = -1


func add_item(item: Item, amount: int = 1) -> void:
	if item == null or amount <= 0:
		return

	for i in range(items.size()):
		if items[i]["item"] == item:
			items[i]["amount"] += amount
			return

	items.append({
		"item": item,
		"amount": amount
	})

	if current_index == -1:
		current_index = 0


func get_current_item() -> Item:
	if items.is_empty():
		return null

	fix_index()
	return items[current_index]["item"]


func get_current_amount() -> int:
	if items.is_empty():
		return 0

	fix_index()
	return items[current_index]["amount"]


func use_current_item(player) -> void:
	if items.is_empty():
		return

	fix_index()

	var item: Item = items[current_index]["item"]
	item.use(player)

	items[current_index]["amount"] -= 1

	if items[current_index]["amount"] <= 0:
		items.remove_at(current_index)

		if items.is_empty():
			current_index = -1
		else:
			if current_index >= items.size():
				current_index = 0


func next_item() -> void:
	if items.is_empty():
		return

	fix_index()
	current_index += 1

	if current_index >= items.size():
		current_index = 0

func prev_item() -> void:
	if items.is_empty():
		return

	fix_index()
	current_index -= 1

	if current_index < 0:
		current_index = items.size() - 1
		
func fix_index() -> void:
	if items.is_empty():
		current_index = -1
		return

	if current_index < 0 or current_index >= items.size():
		current_index = 0
