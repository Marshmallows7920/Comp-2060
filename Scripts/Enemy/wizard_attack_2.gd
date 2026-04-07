extends Area2D

var par
var attackPower
var damageType
var direction = Vector2.ZERO
var target
@export var speed = 150


func _ready():
	if par != null:
		attackPower = par.attackPower
		damageType = par.damageType
		$AnimatedSprite2D.play("create")
		print("play create anim")
	else:
		queue_free()


func _physics_process(delta):
	if $AnimatedSprite2D.animation == "create":
		if par != null:
			if par.get_node("AnimatedSprite2D").flip_h == true:
				position = par.get_node("StaffLeft").global_position
			else:
				position = par.get_node("StaffRight").global_position
	elif $AnimatedSprite2D.animation == "fly":
		rotate(delta*TAU)
		position += direction * speed * delta
		
		


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "hit":
		print("hit anim done")
		queue_free()
	elif $AnimatedSprite2D.animation == "create":
		print("create anim done")
		$AnimatedSprite2D.play("fly")
		direction = (target.global_position - global_position).normalized()


func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("hit player")
		body.attacked(attackPower, damageType)
		$AnimatedSprite2D.play("hit")
	if body.is_in_group("TileMap"):
		var tile_map_coords = body.local_to_map(body.to_local(global_position))
		print(tile_map_coords)
		var tile_pos = body.to_global(body.map_to_local(tile_map_coords))
		print(tile_pos)
		var normal = (global_position - tile_pos).normalized()
		print(normal)
		if abs(normal.x) > abs(normal.y):
			direction.x *= -1
		else:
			direction.y *= -1
		print("hit wall - bounce")



func _on_timer_timeout():
	queue_free()
