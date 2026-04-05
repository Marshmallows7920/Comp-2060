extends Enemy

@export var attack_1:PackedScene

var states = ["unaware_idle", "unaware_wander", "chase", "attack_1", "cooldown"]
var state = "unaware_idle"
var nextState = "unaware_idle"
var prevState = "none"
var target
var wanderTarget
var direction = Vector2.ZERO
var actionMinTime = 2.0
var actionMaxTime = 10.0
var actionTimer
var reachableLast = true
@export var loseInterestTime:float = 15.0
var interestTimer

@export var attackCooldown:float = 1.0

@onready var navAgent = $Navigation/NavigationAgent2D
@onready var navUpdateTimer = $Navigation/UpdatePathTimer
@onready var sprite = $AnimatedSprite2D

var tileMaps
var tileMap

@export var attackPower:float = 5.0
@export var damageType:String = DamageCalculator.TYPE_PHYSIC


func _ready():
	super._ready()
	getTileMap()
	sprite.material = sprite.material.duplicate()
	sprite.material.set_shader_parameter("custom_time", 1.0)


func _process(delta):
	var custom_time = sprite.material.get_shader_parameter("custom_time")
	if custom_time + delta >= 1.0:
		sprite.material.set_shader_parameter("custom_time", 1.0)
	else:
		sprite.material.set_shader_parameter("custom_time", custom_time + delta)


func _physics_process(delta):
	update_stun(delta)

	match state:
		"unaware_idle":
			if prevState != state:
				actionTimer = randf_range(actionMinTime, actionMaxTime)
				$AnimatedSprite2D.play("idle")
			else:
				actionTimer -= delta
				if actionTimer <= 0:
					nextState = "unaware_wander"

		"unaware_wander":
			if prevState != state:
				if tileMap == null:
					getTileMap()

				if tileMap != null:
					var navCells = tileMap.get_used_cells(0)
					if navCells != null:
						target = null
						wanderTarget = navCells.pick_random()
						navAgent.target_position = tileMap.to_global(tileMap.map_to_local(wanderTarget))
						navUpdateTimer.start()
					else:
						wanderTarget = null
						direction = Vector2.RIGHT.rotated(randf_range(0.0, TAU))
				else:
					wanderTarget = null
					direction = Vector2.RIGHT.rotated(randf_range(0.0, TAU))

				$AnimatedSprite2D.play("walk_right")
				actionTimer = randf_range(actionMinTime, actionMaxTime) + 5.0

			else:
				if is_stunned():
					velocity = Vector2.ZERO
					move_and_slide()
				elif wanderTarget != null:
					if !navAgent.is_navigation_finished() and !navAgent.is_target_reached():
						direction = to_local(navAgent.get_next_path_position()).normalized()
						velocity = direction * current_speed * 0.25
						move_and_slide()
					else:
						nextState = "unaware_idle"
						navAgent.target_position = global_position
						navAgent.get_next_path_position()

				else:
					velocity = direction * current_speed * 0.25
					move_and_slide()

				if direction.x > 0:
					$AnimatedSprite2D.flip_h = false
				else:
					$AnimatedSprite2D.flip_h = true

				actionTimer -= delta
				if actionTimer <= 0:
					nextState = "unaware_idle"
					if wanderTarget != null:
						navAgent.target_position = global_position
						navAgent.get_next_path_position()

		"chase":
			if prevState != state:
				nextState = "chase"
				$AnimatedSprite2D.play("walk_right")
				if target != null:
					navAgent.target_position = target.global_position
				navUpdateTimer.start()

			if is_stunned():
				velocity = Vector2.ZERO
				move_and_slide()
			elif !navAgent.is_navigation_finished() and !navAgent.is_target_reached():
				direction = to_local(navAgent.get_next_path_position()).normalized()
				velocity = direction * current_speed
				move_and_slide()
			else:
				nextState = "attack_1"

			if !navAgent.is_target_reachable():
				if reachableLast == true:
					interestTimer = loseInterestTime
					reachableLast = false
			else:
				reachableLast = true
				interestTimer = null

			if direction.x > 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true

		"attack_1":
			if prevState != state:
				$AttackArea/CollisionShape2D.disabled = true
				nextState = "attack_1"
				$AnimatedSprite2D.play("attack_1")
				actionTimer = 0.4
			elif actionTimer != null:
				if is_stunned():
					velocity = Vector2.ZERO
					move_and_slide()
				else:
					actionTimer -= delta
					if actionTimer <= 0:
						var attack = attack_1.instantiate()
						if $AnimatedSprite2D.flip_h == true:
							attack.scale.x = -1
						add_child(attack)
						actionTimer = null

		"cooldown":
			if prevState != state:
				nextState = "cooldown"
				$AnimatedSprite2D.play("idle")
				actionTimer = attackCooldown
			else:
				actionTimer -= delta
				if actionTimer <= 0:
					nextState = "chase"
					$AttackArea/CollisionShape2D.disabled = false

	if interestTimer != null:
		interestTimer -= delta
		if interestTimer <= 0:
			nextState = "unaware_wander"
			interestTimer = null

	prevState = state
	state = nextState


func getTileMap():
	tileMaps = get_parent().get_children()
	for map in tileMaps:
		if map.is_in_group("TileMap"):
			print(map.name)
			if tileMap == null:
				tileMap = map
			else:
				if global_position.distance_to(tileMap.global_position) > global_position.distance_to(map.global_position):
					tileMap = map
	if tileMap != null:
		print(tileMap.name)


func _on_animated_sprite_2d_animation_finished():
	if state == "attack_1":
		state = "cooldown"


func _on_sight_area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		if state == "unaware_idle" or state == "unaware_wander":
			state = "chase"


func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		state = "attack_1"


func _on_update_path_timer_timeout():
	if target != null:
		if navAgent.target_position != target.global_position:
			navAgent.target_position = target.global_position
		navUpdateTimer.start()
	elif wanderTarget != null:
		if navAgent.target_position != tileMap.to_global(tileMap.map_to_local(wanderTarget)):
			navAgent.target_position = tileMap.to_global(tileMap.map_to_local(wanderTarget))
		navUpdateTimer.start()


func on_hit(attacker: Node = null) -> void:
	sprite.material.set_shader_parameter("custom_time", 0)
	if attacker != null and attacker.is_in_group("Player"):
		target = attacker
		state = "chase"
