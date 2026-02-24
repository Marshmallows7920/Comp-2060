extends Area2D

var par

func _ready():
	print(get_parent())
	par = get_parent()
	$AnimatedSprite2D.play("attack_1")
	$AnimationPlayer.play("attack_1")


func _process(delta):
	pass


func _on_animated_sprite_2d_animation_finished():
	print("attack_1 anim done")
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.attacked("neutral", 3)
