extends CharacterBody2D
class_name Enemy

@export var hp: int = 50
@export var defense: int = 0
@export var enemy_type: String = DamageCalculator.TYPE_PHYSIC
@export var experience: int = 100


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
	queue_free()
