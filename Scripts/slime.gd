extends CharacterBody2D


@export var attack_1:PackedScene

var states = ["unaware_idle", "unaware_wander", "chase", "attack_1", "cooldown"]
var state = "unaware_idle"
var nextState = "unaware_idle"
var prevState = "none"
var target
var direction
var actionMinTime = 2.0
var actionMaxTime = 10.0
var actionTimer

@export var speed:int
@export var attackCooldown:float

var random


func _ready():
	pass



func _physics_process(delta):
	match state:
		#UNAWARE IDLE STATE
		"unaware_idle":
			if prevState != state:
				print("unaware_idle")
				actionTimer = randf_range(actionMinTime, actionMaxTime)
				$AnimatedSprite2D.play("idle")
				$AnimationPlayer.play("idle")
			else:
				actionTimer -= delta
				if actionTimer <= 0:
					nextState = "unaware_wander"
		
		#UNAWARE WANDER STATE
		"unaware_wander":
			if prevState != state:
				print("unaware_wander")
				direction = Vector2.RIGHT.rotated(randf_range(0.0, TAU))
				if direction.x > 0:
					$AnimatedSprite2D.flip_h = false
					$CollisionPolygon2D.scale.x = 1
				else:
					$AnimatedSprite2D.flip_h = true
					$CollisionPolygon2D.scale.x = -1
				$AnimatedSprite2D.play("walk_right")
				$AnimationPlayer.play("walk_right")
				actionTimer = randf_range(actionMinTime, actionMaxTime)
			else:
				position += direction*speed*delta*0.25
				actionTimer -= delta
				if actionTimer <= 0:
					nextState = "unaware_idle"
		
		#CHASE STATE
		"chase":
			#replace with pathfinding
			if prevState != state:
				nextState = "chase"
				print("chase")
				$AnimatedSprite2D.play("walk_right")
				$AnimationPlayer.play("walk_right")
			direction = global_position.direction_to(target.global_position)
			global_position += direction*speed*delta
			if direction.x > 0:
				$AnimatedSprite2D.flip_h = false
				$CollisionPolygon2D.scale.x = 1
			else:
				$AnimatedSprite2D.flip_h = true
				$CollisionPolygon2D.scale.x = -1
		
		#ATTACK_1 STATE
		"attack_1":
			if prevState != state:
				$AttackArea/CollisionShape2D.disabled = true
				$AttackArea/MeshInstance2D.visible = false
				nextState = "attack_1"
				print("attack_1")
				$AnimatedSprite2D.play("attack_1")
				$AnimationPlayer.play("attack_1")
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
				$AnimationPlayer.play("idle")
				actionTimer = attackCooldown
			else:
				actionTimer -= delta
				if actionTimer <= 0:
					nextState = "chase"
					$AttackArea/CollisionShape2D.disabled = false
					$AttackArea/MeshInstance2D.visible = true
	prevState = state
	state = nextState



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
