extends Node

var level: int = 1
var exp: int = 0
var exp_needed: int = 100

var hp: int = 50
var mana: int = 50
var money: int = 0

var wizard_boss_defeated: bool = false
var wizard_boss_defeat_count: int = 0
var game_victory: bool = false

var pending_next_scene: String = ""
var buffs: Array[StatModifier] = []


func initialize_buffs(buff_templates: Array[StatModifier]) -> void:
	if buffs.size() > 0:
		return

	for buff in buff_templates:
		if buff == null:
			continue

		var buff_copy: StatModifier = buff.duplicate(true)
		buffs.append(buff_copy)


func save_buffs(buff_list: Array[StatModifier]) -> void:
	buffs.clear()

	for buff in buff_list:
		if buff == null:
			continue

		var buff_copy: StatModifier = buff.duplicate(true)
		buffs.append(buff_copy)
