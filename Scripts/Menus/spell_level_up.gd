extends Control

@onready var card_container = $MarginContainer/VBoxContainer/SpellCardContainer
@export_file("*.tscn") var spell_select_card:String

var spells
var options = []
var num_options = 3
var cards = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in card_container.get_children():
		node.queue_free()
	
	for i in range(0, spells.available.size()):
		options.append(spells.available[i]+"_new")
	for i in range(0, spells.num_slots):
		if spells.slots[i] != "":
			options.erase(spells.slots[i]+"_new")
			options.append(spells.slots[i]+"_upgrade")
	
	options.shuffle()
	
	for i in range(0, min(num_options, options.size())):
		var card = load(spell_select_card).instantiate()
		card.par = self
		card.card_num = i
		match options[i]:
			"fireball_new":
				card.set_spell_name.call_deferred("Fireball")
				card.set_spell_sprite.call_deferred(load(spells.fireball_sprite))
				card.set_spell_shader.call_deferred(load(spells.fireball_shader))
				card.set_spell_description.call_deferred(spells.fireball_description)
				card.set_spell_stats.call_deferred("Damage: " + str(spells.fireball_base_damage) + 
				"\nCooldown: " + str(spells.fireball_base_cooldown) + 
				"\nMana Cost: " + str(spells.fireball_base_mana_cost) + 
				"\nSpeed: " + str(spells.fireball_base_speed))
				cards.append(["fireball_new"])
			"fireball_upgrade":
				card.set_spell_name.call_deferred("Fireball")
				card.set_spell_sprite.call_deferred(load(spells.fireball_sprite))
				card.set_spell_shader.call_deferred(load(spells.fireball_shader))
				card.set_spell_description.call_deferred(spells.fireball_description)
				var num_upgrades = randi_range(1,spells.fireball_stats.size())
				var order = spells.fireball_stats.duplicate(true)
				order.shuffle()
				var stat_text = ""
				var card_info = ["fireball_upgrade"]
				for j in range(0, num_upgrades):
					if j > 0:
						stat_text += "\n"
					match order[j]:
						"damage":
							stat_text += "Damage + [" + str(spells.fireball_damage_growth) + "] -> " + str(spells.fireball_damage + spells.fireball_damage_growth)
						"cooldown":
							stat_text += "Cooldown - [" + str(spells.fireball_cooldown_growth) + "] -> " + str(spells.fireball_cooldown - spells.fireball_cooldown_growth)
						"mana_cost":
							stat_text += "Mana Cost - [" + str(spells.fireball_mana_cost_growth) + "] -> " + str(spells.fireball_mana_cost - spells.fireball_mana_cost_growth)
						"speed":
							stat_text += "Speed + [" + str(spells.fireball_speed_growth) + "] -> " + str(spells.fireball_speed + spells.fireball_speed_growth)
					card_info.append(order[j])
				card.set_spell_stats.call_deferred(stat_text)
				cards.append(card_info)
			"icicle_new":
				card.set_spell_name.call_deferred("Icicle")
				card.set_spell_sprite.call_deferred(load(spells.icicle_sprite))
				card.set_spell_shader.call_deferred(load(spells.icicle_shader))
				card.set_spell_description.call_deferred(spells.icicle_description)
				card.set_spell_stats.call_deferred("Damage: " + str(spells.icicle_base_damage) + 
				"\nCooldown: " + str(spells.icicle_base_cooldown) + 
				"\nMana Cost: " + str(spells.icicle_base_mana_cost) + 
				"\nPierce: " + str(spells.icicle_base_pierce))
				cards.append(["icicle_new"])
			"icicle_upgrade":
				card.set_spell_name.call_deferred("Icicle")
				card.set_spell_sprite.call_deferred(load(spells.icicle_sprite))
				card.set_spell_shader.call_deferred(load(spells.icicle_shader))
				card.set_spell_description.call_deferred(spells.icicle_description)
				var num_upgrades = randi_range(1,spells.icicle_stats.size())
				var order = spells.icicle_stats.duplicate(true)
				order.shuffle()
				var stat_text = ""
				var card_info = ["icicle_upgrade"]
				for j in range(0, num_upgrades):
					if j > 0:
						stat_text += "\n"
					match order[j]:
						"damage":
							stat_text += "Damage + [" + str(spells.icicle_damage_growth) + "] -> " + str(spells.icicle_damage + spells.icicle_damage_growth)
						"cooldown":
							stat_text += "Cooldown - [" + str(spells.icicle_cooldown_growth) + "] -> " + str(spells.icicle_cooldown - spells.icicle_cooldown_growth)
						"mana_cost":
							stat_text += "Mana Cost - [" + str(spells.icicle_mana_cost_growth) + "] -> " + str(spells.icicle_mana_cost - spells.icicle_mana_cost_growth)
						"pierce":
							stat_text += "Pierce + [" + str(spells.icicle_pierce_growth) + "] -> " + str(spells.icicle_pierce + spells.icicle_pierce_growth)
					card_info.append(order[j])
				card.set_spell_stats.call_deferred(stat_text)
				cards.append(card_info)
			"boulder_new":
				card.set_spell_name.call_deferred("Boulder")
				card.set_spell_sprite.call_deferred(load(spells.boulder_sprite))
				card.set_spell_shader.call_deferred(load(spells.boulder_shader))
				card.set_spell_description.call_deferred(spells.boulder_description)
				card.set_spell_stats.call_deferred("Damage: " + str(spells.boulder_base_damage) + 
				"\nCooldown: " + str(spells.boulder_base_cooldown) + 
				"\nMana Cost: " + str(spells.boulder_base_mana_cost) + 
				"\nKnockback: " + str(spells.boulder_base_knockback) +
				"\nSize: " + str(spells.boulder_base_size))
				cards.append(["boulder_new"])
			"boulder_upgrade":
				card.set_spell_name.call_deferred("boulder")
				card.set_spell_sprite.call_deferred(load(spells.boulder_sprite))
				card.set_spell_shader.call_deferred(load(spells.boulder_shader))
				card.set_spell_description.call_deferred(spells.boulder_description)
				var num_upgrades = randi_range(1,spells.boulder_stats.size())
				var order = spells.boulder_stats.duplicate(true)
				order.shuffle()
				var stat_text = ""
				var card_info = ["boulder_upgrade"]
				for j in range(0, num_upgrades):
					if j > 0:
						stat_text += "\n"
					match order[j]:
						"damage":
							stat_text += "Damage + [" + str(spells.boulder_damage_growth) + "] -> " + str(spells.boulder_damage + spells.boulder_damage_growth)
						"cooldown":
							stat_text += "Cooldown - [" + str(spells.boulder_cooldown_growth) + "] -> " + str(spells.boulder_cooldown - spells.boulder_cooldown_growth)
						"mana_cost":
							stat_text += "Mana Cost - [" + str(spells.boulder_mana_cost_growth) + "] -> " + str(spells.boulder_mana_cost - spells.boulder_mana_cost_growth)
						"knockback":
							stat_text += "Knockback + [" + str(spells.boulder_knockback_growth) + "] -> " + str(spells.boulder_knockback + spells.boulder_knockback_growth)
						"size":
							stat_text += "Size + [" + str(spells.boulder_size_growth) + "] -> " + str(spells.boulder_size + spells.boulder_size_growth)
					card_info.append(order[j])
				card.set_spell_stats.call_deferred(stat_text)
				cards.append(card_info)
		card_container.add_child(card)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func pressed(card_num):
	var card = cards[card_num]
	var added = false
	var index = 0
	while(!added):
		if spells.slots[index] == "":
			if card[0].ends_with("_new"):
				spells.slots[index] = card[0].left(-4)
				print(spells.slots[index])
			else:
				match card[0].left(-8):
					"fireball":
						for x in card.slice(1,-1):
							match x:
								"damage":
									spells.fireball_damage += spells.fireball_damage_growth
								"cooldown":
									spells.fireball_cooldown -= spells.fireball_cooldown_growth
								"mana_cost":
									spells.fireball_mana_cost -= spells.fireball_mana_cost_growth
								"speed":
									spells.fireball_speed += spells.fireball_speed_growth
					"icicle":
						for x in card.slice(1,-1):
							match x:
								"damage":
									spells.icicle_damage += spells.icicle_damage_growth
								"cooldown":
									spells.icicle_cooldown -= spells.icicle_cooldown_growth
								"mana_cost":
									spells.icicle_mana_cost -= spells.icicle_mana_cost_growth
								"pierce":
									spells.icicle_pierce += spells.icicle_pierce_growth
					"boulder":
						for x in card.slice(1,-1):
							match x:
								"damage":
									spells.boulder_damage += spells.boulder_damage_growth
								"cooldown":
									spells.boulder_cooldown -= spells.boulder_cooldown_growth
								"mana_cost":
									spells.boulder_mana_cost -= spells.boulder_mana_cost_growth
								"knockback":
									spells.boulder_knockback += spells.boulder_knockback_growth
			added = true
		index += 1
		if index >= spells.slots.size():
			print("No empty spell slots!")
			break
	get_tree().paused = false
	queue_free()
