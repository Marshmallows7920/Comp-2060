extends Node2D
class_name Weapon

@export var bullet_scene: PackedScene
@export var fire_cooldown: float = 0.25
@export var damage_modifier: float = 1.0

var can_fire := true

func attack(_direction: Vector2, _base_damage: int) -> void:
	pass

func get_final_damage(base_damage: int) -> int:
	return max(1, roundi(base_damage * damage_modifier))

func start_cooldown() -> void:
	can_fire = false
	var timer := get_tree().create_timer(fire_cooldown)
	timer.timeout.connect(_reset_fire)

func _reset_fire() -> void:
	can_fire = true
