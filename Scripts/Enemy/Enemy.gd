extends CharacterBody2D
class_name Enemy

@export var hp: int = 50
@export var defense: int = 0
@export var enemy_type: String = DamageCalculator.TYPE_PHYSIC
@export var experience: int = 100
@export var speed: float = 50.0
@export var drops: Array[Item] = []                          
@export_file("*.tscn") var world_item_scene: String = ""    

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
	if attacker != null and attacker.has_method("killedEnemy"):
		attacker.killedEnemy(experience)
	drop_item()    
	queue_free()

func drop_item() -> void:
	if drops.is_empty() or world_item_scene == "":
		return
	var item = drops.pick_random()
	if item == null:
		return
	var world_item = load(world_item_scene).instantiate()
	world_item.global_position = global_position
	get_tree().current_scene.add_child(world_item)
	world_item.setup(item)
