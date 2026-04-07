extends Enemy

@export var attack_1:PackedScene
@export var attack_2:PackedScene
@export var reward_item_3: Item
@export var reward_item_5: Item
var states = ["unaware_idle", "unaware_wander", "chase", "attack_1", "attack_2", "cooldown"]
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

var tileMap

@export var attackPower:float = 10.0
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
				actionTimer = 0.8
			elif actionTimer != null:
				if is_stunned():
					velocity = Vector2.ZERO
					move_and_slide()
				else:
					actionTimer -= delta
					if actionTimer <= 0:
						var attack = attack_1.instantiate()
						var spawn_pos = Vector2.ZERO
						if $AnimatedSprite2D.flip_h == true:
							spawn_pos = $StaffLeft.global_position
						else:
							spawn_pos = $StaffRight.global_position
						attack.par = self
						attack.global_position = spawn_pos
						get_tree().root.add_child(attack)
						attack.target = target
						actionTimer = null
		
		"attack_2":
			if prevState != state:
				$AttackArea/CollisionShape2D.disabled = true
				nextState = "attack_2"
				$AnimatedSprite2D.play("attack_2")
				actionTimer = 0.8*5.0/2.0
			elif actionTimer != null:
				if is_stunned():
					velocity = Vector2.ZERO
					move_and_slide()
				else:
					actionTimer -= delta
					if actionTimer <= 0:
						var attack = attack_2.instantiate()
						var spawn_pos = Vector2.ZERO
						if $AnimatedSprite2D.flip_h == true:
							spawn_pos = $StaffLeft.position
						else:
							spawn_pos = $StaffRight.position
						attack.par = self
						attack.global_position = spawn_pos
						get_tree().root.add_child(attack)
						attack.target = target
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
	var siblings = get_parent().get_children()
	for sib in siblings:
		if sib.is_in_group("TileMap"):
			#print(sib.name)
			if tileMap == null:
				tileMap = sib
			else:
				if global_position.distance_to(tileMap.global_position) > global_position.distance_to(sib.global_position):
					tileMap = sib
	if tileMap != null:
		print(tileMap.name)


func _on_animated_sprite_2d_animation_finished():
	if state == "attack_1" or state == "attack_2":
		state = "cooldown"


func _on_sight_area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		if state == "unaware_idle" or state == "unaware_wander":
			state = "chase"


func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		var attacks = ["attack_1", "attack_2"]
		attacks.shuffle()
		state = attacks[0]


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
		
func drop_reward(item: Item) -> void:
	if item == null:
		return
	if world_item_scene == null or world_item_scene == "":
		return

	var world_item = load(world_item_scene).instantiate()
	world_item.global_position = global_position
	get_tree().current_scene.add_child(world_item)
	world_item.setup(item)
func die(attacker: Node = null) -> void:
	if is_dead:
		return

	is_dead = true

	GlobalData.wizard_boss_defeated = true
	GlobalData.wizard_boss_defeat_count += 1

	if attacker != null and attacker.has_method("killedEnemy"):
		attacker.killedEnemy(experience)

	var dropped_special_reward := false

	if GlobalData.wizard_boss_defeat_count == 3:
		drop_reward(reward_item_3)
		dropped_special_reward = true

	if GlobalData.wizard_boss_defeat_count == 5:
		drop_reward(reward_item_5)
		dropped_special_reward = true

	if not dropped_special_reward:
		drop_item()

	if GlobalData.wizard_boss_defeat_count >= 7:
		GlobalData.game_victory = true
		show_victory_text()
		get_tree().paused = true

	queue_free()

func show_victory_text() -> void:
	var label := Label.new()
	label.text = "VICTORY!"
	label.scale = Vector2(5, 5)
	label.z_index = 100

	# center on screen
	var screen_size = get_viewport_rect().size
	label.position = screen_size / 2 - Vector2(100, 20)

	get_tree().current_scene.add_child(label)
