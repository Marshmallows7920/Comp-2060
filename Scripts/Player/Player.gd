extends CharacterBody2D

@export var move_speed: float = 200.0

@onready var weapon_holder = $WeaponHolder
@onready var stats = $Stats

var equipped_weapon
var facing_direction = Vector2.RIGHT


func _ready():
	# detect starting weapon
	if weapon_holder.get_child_count() > 0:
		equipped_weapon = weapon_holder.get_child(0)


func _physics_process(_delta: float) -> void:
	var direction := Vector2(
		Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft"),
		Input.get_action_strength("MoveDown") - Input.get_action_strength("MoveUp")
	).normalized()

	# update facing direction when moving
	if direction != Vector2.ZERO:
		facing_direction = direction

	velocity = direction * move_speed
	move_and_slide()

	# attack input
	if Input.is_action_just_pressed("Attack"):
		attack()


func attack():
	if equipped_weapon == null:
		return

	equipped_weapon.attack(facing_direction, stats.atk_stat())


func equip_weapon(new_weapon):
	if equipped_weapon != null:
		equipped_weapon.queue_free()

	weapon_holder.add_child(new_weapon)
	new_weapon.position = Vector2.ZERO
	equipped_weapon = new_weapon
