extends CharacterBody2D

@export var move_speed: float = 200.0

func _physics_process(_delta: float) -> void:
	var direction := Vector2(
		Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft"),
		Input.get_action_strength("MoveDown") - Input.get_action_strength("MoveUp")
	).normalized()

	velocity = direction * move_speed
	move_and_slide()
