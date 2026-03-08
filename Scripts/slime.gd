extends CharacterBody2D


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

@export var speed:float = 50.0
@export var attackCooldown:float = 1.0

@onready var navAgent = $Navigation/NavigationAgent2D
@onready var navUpdateTimer = $Navigation/UpdatePathTimer

var tileMaps
var tileMap


func _ready():
	closestTileMap()



func _physics_process(delta):
	match state:
		#UNAWARE IDLE STATE
		"unaware_idle":
			if prevState != state:
				print("unaware_idle")
				actionTimer = randf_range(actionMinTime, actionMaxTime)
				$AnimatedSprite2D.play("idle")
			else:
				actionTimer -= delta
				if actionTimer <= 0:
					nextState = "unaware_wander"
		
		#UNAWARE WANDER STATE
		"unaware_wander":
			#update for better wander navigation
			if prevState != state:
				print("unaware_wander")
				if tileMap == null:
					closestTileMap()
				
				if tileMap != null:
					var navCells = tileMap.get_used_cells(0) #id 0 = navigation layer
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
				if wanderTarget != null:
					if !navAgent.is_navigation_finished() and !navAgent.is_target_reached():
						direction = to_local(navAgent.get_next_path_position()).normalized()
						velocity = direction * speed * 0.25
						move_and_slide()
					else:
						nextState = "unaware_idle"
						navAgent.target_position = global_position
						navAgent.get_next_path_position()
				
				else:
					velocity = direction * speed * 0.25
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
		
		#CHASE STATE
		"chase":
			if prevState != state:
				nextState = "chase"
				print("chase")
				$AnimatedSprite2D.play("walk_right")
				if target != null:
					navAgent.target_position = target.global_position
				navUpdateTimer.start()
			
			if !navAgent.is_navigation_finished() and !navAgent.is_target_reached():
				direction = to_local(navAgent.get_next_path_position()).normalized()
				velocity = direction * speed
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
		
		#ATTACK_1 STATE
		"attack_1":
			if prevState != state:
				$AttackArea/CollisionShape2D.disabled = true
				nextState = "attack_1"
				print("attack_1")
				$AnimatedSprite2D.play("attack_1")
				actionTimer = 0.4
			elif actionTimer != null:
					actionTimer -= delta
					if actionTimer <= 0:
						var attack = attack_1.instantiate()
						if $AnimatedSprite2D.flip_h == true:
							attack.scale.x = -1
						add_child(attack)
						actionTimer = null
		
		#COOLDOWN STATE
		"cooldown":
			if prevState != state:
				nextState = "cooldown"
				print("cooldown")
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



func closestTileMap():
	tileMaps = get_tree().get_nodes_in_group("TileMap")
	for map in tileMaps:
		if tileMap == null:
			tileMap = map
		else:
			if position.distance_to(tileMap.global_position) < position.distance_to(map.global_position):
				tileMap = map
	if tileMap != null:
		print(tileMap.name)



func _on_animated_sprite_2d_animation_finished():
	if state == "attack_1":
		state = "cooldown"


func _on_sight_area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		print("Sight %s" % body)
		if state == "unaware_idle" or state == "unaware_wander":
			state = "chase"


func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		print("Attack %s" % body)
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
