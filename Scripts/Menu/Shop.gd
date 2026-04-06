extends Control

@onready var gold_label: Label = $Panel/GoldLabel
@onready var buff_list: VBoxContainer = $Panel/BuffList


func _ready() -> void:
	get_tree().paused = false
	refresh_ui()


func refresh_ui() -> void:
	gold_label.text = "Gold: " + str(GlobalData.money)

	for child in buff_list.get_children():
		child.queue_free()

	for buff in GlobalData.buffs:
		if buff == null:
			continue

		var row := HBoxContainer.new()
		row.custom_minimum_size = Vector2(0, 70)
		row.add_theme_constant_override("separation", 20)

		var name_label := Label.new()
		name_label.custom_minimum_size = Vector2(300, 70)
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		name_label.text = buff.display_name
		name_label.add_theme_font_size_override("font_size", 28)

		var level_label := Label.new()
		level_label.custom_minimum_size = Vector2(180, 70)
		level_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		level_label.text = "Lv " + str(buff.level) + "/" + str(buff.max_level)
		level_label.add_theme_font_size_override("font_size", 28)

		var price_label := Label.new()
		price_label.custom_minimum_size = Vector2(180, 70)
		price_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		if buff.can_level_up():
			price_label.text = str(buff.get_price()) + " Gold"
		else:
			price_label.text = "MAX"
		price_label.add_theme_font_size_override("font_size", 28)

		var buy_button := Button.new()
		buy_button.text = "Buy"
		buy_button.custom_minimum_size = Vector2(140, 70)
		buy_button.add_theme_font_size_override("font_size", 28)
		buy_button.disabled = not buff.can_level_up() or GlobalData.money < buff.get_price()
		buy_button.pressed.connect(_on_buy_pressed.bind(buff))

		row.add_child(name_label)
		row.add_child(level_label)
		row.add_child(price_label)
		row.add_child(buy_button)

		buff_list.add_child(row)


func _on_buy_pressed(buff: StatModifier) -> void:
	if buff == null:
		return
	if not buff.can_level_up():
		return

	var cost := buff.get_price()
	if GlobalData.money < cost:
		return

	GlobalData.money -= cost
	buff.level_up()
	refresh_ui()


func _on_continue_pressed() -> void:
	if GlobalData.pending_next_scene == "":
		push_error("GlobalData.pending_next_scene is empty.")
		return

	get_tree().change_scene_to_file(GlobalData.pending_next_scene)
