extends CharacterBody2D
class_name Enemy

@export var hp: int = 50
@export var defense: int = 0
@export var enemy_type: String = DamageCalculator.TYPE_PHYSIC
@export var experience: int = 100
@export var speed: float = 50.0

@export var drop_table: Array[DropEntry] = []
@export_range(0.0, 100.0, 0.1) var no_drop_rate: float = 100.0
@export_file("*.tscn") var world_item_scene: String = ""
var is_dead: bool = false
var stun_timer: float = 0.0
var current_speed: float = 0.0


func _ready() -> void:
	current_speed = speed


func update_stun(delta: float) -> void:
	if stun_timer > 0.0:
		stun_timer -= delta
		current_speed = 0.0
		if stun_timer < 0.0:
			stun_timer = 0.0
	else:
		current_speed = speed


func apply_stun(duration: float) -> void:
	if duration > stun_timer:
		stun_timer = duration


func is_stunned() -> bool:
	return stun_timer > 0.0


func take_damage(amount: int, attack_type: String = DamageCalculator.TYPE_MAGIC, attacker: Node = null) -> int:
	var final_damage = DamageCalculator.calculate_damage(amount, defense, attack_type, enemy_type)

	hp -= final_damage
	if hp < 0:
		hp = 0

	if final_damage > 0:
		on_hit(attacker)

	if hp <= 0:
		die(attacker)

	return final_damage


func on_hit(attacker: Node = null) -> void:
	pass


func die(attacker: Node = null) -> void:
	if is_dead:
		return

	is_dead = true

	if attacker != null and attacker.has_method("killedEnemy"):
		attacker.killedEnemy(experience)

	drop_item()
	queue_free()


func drop_item() -> void:
	if world_item_scene == "":
		return

	var selected_item: Item = roll_drop()
	if selected_item == null:
		return

	var world_item = load(world_item_scene).instantiate()
	world_item.global_position = global_position
	get_tree().current_scene.add_child(world_item)
	world_item.setup(selected_item)


func roll_drop() -> Item:
	var total_weight: float = no_drop_rate

	for entry in drop_table:
		if entry != null and entry.item != null and entry.drop_rate > 0.0:
			total_weight += entry.drop_rate

	if total_weight <= 0.0:
		return null

	var roll: float = randf_range(0.0, total_weight)
	var current: float = no_drop_rate

	if roll < current:
		return null

	for entry in drop_table:
		if entry == null or entry.item == null or entry.drop_rate <= 0.0:
			continue

		current += entry.drop_rate
		if roll < current:
			return entry.item

	return null
