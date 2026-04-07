extends Item
class_name WeaponItem

@export var weapon_scene: PackedScene

func use(player) -> void:
	if weapon_scene == null:
		return

	if player.has_method("equip_weapon"):
		var new_weapon = weapon_scene.instantiate()
		player.equip_weapon(new_weapon)
