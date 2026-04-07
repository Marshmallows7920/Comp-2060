extends Control

@onready var gold_label = $Panel/GoldLabel
@onready var buff_list = $Panel/BuffList


func _ready():
	refresh_ui()


func refresh_ui():
	gold_label.text = "Gold: " + str(GlobalData.money) +"$"

	for c in buff_list.get_children():
		c.queue_free()

	for buff in GlobalData.buffs:
		if buff == null:
			continue

		var row = HBoxContainer.new()

		row.add_child(Label.new())
		row.get_child(0).text = buff.display_name

		row.add_child(Label.new())
		row.get_child(1).text = "Lv " + str(buff.level)

		row.add_child(Label.new())
		row.get_child(2).text = "Price:"+ str(buff.get_price()) if buff.can_level_up() else "MAX"

		var btn = Button.new()
		btn.text = "Buy"
		btn.disabled = not buff.can_level_up() or GlobalData.money < buff.get_price()
		btn.pressed.connect(_on_buy_pressed.bind(buff))

		row.add_child(btn)
		buff_list.add_child(row)


func _on_buy_pressed(buff):
	if buff == null:
		return
	if not buff.can_level_up():
		return

	var cost = buff.get_price()
	if GlobalData.money < cost:
		return

	GlobalData.money -= cost
	buff.level_up()
	refresh_ui()


func _on_continue_pressed():
	get_tree().change_scene_to_file(GlobalData.pending_next_scene)
