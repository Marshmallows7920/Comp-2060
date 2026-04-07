extends Weapon

@onready var muzzle: Marker2D = $Muzzle

func attack(direction: Vector2, base_damage: int, attack_type: String = DamageCalculator.TYPE_MAGIC) -> void:
	if !can_fire:
		return

	if bullet_scene == null:
		return

	start_cooldown()

	var bullet = bullet_scene.instantiate()
	bullet.global_position = muzzle.global_position + direction.normalized() * 20
	bullet.direction = direction.normalized()
	bullet.damage = get_final_damage(base_damage)
	bullet.attack_type = attack_type
	bullet.shooter = get_parent().get_parent()
	bullet.speed = 400

	get_tree().current_scene.add_child(bullet)
