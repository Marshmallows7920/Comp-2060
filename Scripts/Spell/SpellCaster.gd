extends Node
class_name SpellCaster


static func cast_spell(player, spells, stats):
	match spells.slots[spells.selected]:
		"fireball":
			if spells.cooldowns[spells.selected] <= 0.0 and stats.current_mana >= spells.fireball_mana_cost:
				var dir = (player.get_global_mouse_position() - player.position).normalized()
				spawn_fireball(player, spells, stats, player.position, dir)
				spells.cooldowns[spells.selected] = spells.fireball_cooldown
				stats.current_mana -= spells.fireball_mana_cost

		"icicle":
			if spells.cooldowns[spells.selected] <= 0.0 and stats.current_mana >= spells.icicle_mana_cost:
				var dir = (player.get_global_mouse_position() - player.position).normalized()
				spawn_icicle(player, spells, stats, player.position, dir)
				spells.cooldowns[spells.selected] = spells.icicle_cooldown
				stats.current_mana -= spells.icicle_mana_cost

		"boulder":
			if spells.cooldowns[spells.selected] <= 0.0 and stats.current_mana >= spells.boulder_mana_cost:
				var dir = (player.get_global_mouse_position() - player.position).normalized()
				spawn_boulder(player, spells, stats, player.position, dir)
				spells.cooldowns[spells.selected] = spells.boulder_cooldown
				stats.current_mana -= spells.boulder_mana_cost


static func spawn_fireball(player, spells, stats, pos, dir):
	var newFireball = load(spells.fireball).instantiate()
	newFireball.global_position = pos
	newFireball.setDirection(dir)
	newFireball.par = player
	newFireball.playerStats = stats
	newFireball.speed = spells.fireball_speed
	player.get_tree().root.add_child(newFireball)


static func spawn_icicle(player, spells, stats, pos, dir):
	var newIcicle = load(spells.icicle).instantiate()
	newIcicle.global_position = pos
	newIcicle.setDirection(dir)
	newIcicle.par = player
	newIcicle.playerStats = stats
	newIcicle.speed = spells.icicle_speed
	player.get_tree().root.add_child(newIcicle)


static func spawn_boulder(player, spells, stats, pos, dir):
	var newBoulder = load(spells.boulder).instantiate()
	newBoulder.global_position = pos
	newBoulder.setDirection(dir)
	newBoulder.par = player
	newBoulder.playerStats = stats
	newBoulder.speed = spells.boulder_speed
	player.get_tree().root.add_child(newBoulder)
