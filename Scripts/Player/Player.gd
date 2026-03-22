extends CharacterBody2D

@onready var weapon_holder = $WeaponHolder
@onready var stats: PlayerStats = $Stats
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var inventory: Inventory = $Inventory

var equipped_weapon: Weapon = null
var facing_direction: Vector2 = Vector2.RIGHT
var is_dead: bool = false


func _ready() -> void:
	if weapon_holder.get_child_count() > 0:
		var first_child: Node = weapon_holder.get_child(0)
		if first_child is Weapon:
			equipped_weapon = first_child


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	stats.update_modifiers(delta)

	movement()
	attack()
	item_input()
	move_and_slide()

	if stats.is_dead():
		die()


func movement() -> void:
	var direction: Vector2 = Vector2(
		Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft"),
		Input.get_action_strength("MoveDown") - Input.get_action_strength("MoveUp")
	).normalized()

	if direction != Vector2.ZERO:
		facing_direction = direction
		anim.play("Walk")

		if facing_direction.x != 0:
			anim.flip_h = facing_direction.x < 0
	else:
		anim.stop()

	velocity = direction * stats.move_speed()


func attack() -> void:
	if Input.is_action_just_pressed("Attack") and equipped_weapon != null:
		equipped_weapon.attack(facing_direction, stats.atk_stat())
		anim.play("Attack")


func item_input() -> void:
	if Input.is_action_just_pressed("UseItem"):
		inventory.use_current_item(self)

	if Input.is_action_just_pressed("NextItem"):
		inventory.next_item()

	if Input.is_action_just_pressed("PrevItem"):
		inventory.prev_item()


func equip_weapon(new_weapon: Weapon) -> void:
	if equipped_weapon != null:
		equipped_weapon.queue_free()

	weapon_holder.add_child(new_weapon)
	new_weapon.position = Vector2.ZERO
	equipped_weapon = new_weapon


func heal(amount: int) -> void:
	if is_dead:
		return
	stats.heal(amount)


func take_damage(amount: int) -> void:
	if is_dead:
		return

	stats.take_damage(amount)

	if stats.is_dead():
		die()


func add_modifier(modifier: StatModifier) -> void:
	if is_dead:
		return
	stats.add_modifier(modifier)


func remove_modifier(modifier_id: String) -> void:
	stats.remove_modifier(modifier_id)


func die() -> void:
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO
	anim.play("Die")
	await anim.animation_finished
	queue_free()
