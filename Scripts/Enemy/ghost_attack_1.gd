extends Area2D

var par
var attackPower
var damageType
var direction = Vector2.ZERO
var target
@export var speed = 200


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
			position = par.global_position
	elif $AnimatedSprite2D.animation == "fly":
		rotate(delta*TAU/32)
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
		print("hit wall")
		print("hit wall")
		$AnimatedSprite2D.play("hit")

