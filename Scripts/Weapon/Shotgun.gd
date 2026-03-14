extends Weapon

@onready var muzzle: Marker2D = $Muzzle


func attack(direction: Vector2, base_damage: int) -> void:
	if !can_fire:
		return
	
	if bullet_scene == null:
		return
	
	start_cooldown()

	var dir = direction.normalized()

	var bullet1 = bullet_scene.instantiate()
	bullet1.global_position = muzzle.global_position
	bullet1.direction = dir.rotated(deg_to_rad(-20))
	bullet1.damage = get_final_damage(base_damage)
	get_tree().current_scene.add_child(bullet1)

	var bullet2 = bullet_scene.instantiate()
	bullet2.global_position = muzzle.global_position
	bullet2.direction = dir.rotated(deg_to_rad(-10))
	bullet2.damage = get_final_damage(base_damage)
	get_tree().current_scene.add_child(bullet2)

	var bullet3 = bullet_scene.instantiate()
	bullet3.global_position = muzzle.global_position
	bullet3.direction = dir
	bullet3.damage = get_final_damage(base_damage)
	get_tree().current_scene.add_child(bullet3)

	var bullet4 = bullet_scene.instantiate()
	bullet4.global_position = muzzle.global_position
	bullet4.direction = dir.rotated(deg_to_rad(10))
	bullet4.damage = get_final_damage(base_damage)
	get_tree().current_scene.add_child(bullet4)

	var bullet5 = bullet_scene.instantiate()
	bullet5.global_position = muzzle.global_position
	bullet5.direction = dir.rotated(deg_to_rad(20))
	bullet5.damage = get_final_damage(base_damage)
	get_tree().current_scene.add_child(bullet5)
