extends Weapon

@onready var muzzle: Marker2D = $Muzzle

func attack(direction: Vector2, base_damage: int, attack_type: String = DamageCalculator.TYPE_MAGIC) -> void:
	if !can_fire:
		return

	if bullet_scene == null:
		return

	start_cooldown()

	var dir = direction.normalized()
	var side = Vector2(-dir.y, dir.x) * 10.0
	var spawn_base = muzzle.global_position + dir * 20

	for offset in [-1, 1]:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = spawn_base + side * offset
		bullet.direction = dir
		bullet.damage = get_final_damage(base_damage)
		bullet.attack_type = attack_type
		bullet.shooter = get_parent().get_parent()
		get_tree().current_scene.add_child(bullet)
