extends Weapon

@onready var muzzle: Marker2D = $Muzzle

func attack(direction: Vector2, base_damage: int, attack_type: String = DamageCalculator.TYPE_MAGIC) -> void:
	if !can_fire:
		return

	if bullet_scene == null:
		return

	start_cooldown()

	var dir := direction.normalized()
	var shooter_ref = get_parent().get_parent()
	var spawn_pos = muzzle.global_position + dir * 20
	var angles := [-20, -10, 0, 10, 20]

	for angle in angles:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = spawn_pos
		bullet.direction = dir.rotated(deg_to_rad(angle))
		bullet.damage = get_final_damage(base_damage)
		bullet.attack_type = attack_type
		bullet.shooter = shooter_ref
		get_tree().current_scene.add_child(bullet)
