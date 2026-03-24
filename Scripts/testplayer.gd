extends CharacterBody2D


const SPEED = 100.0
var hp = 100


func _physics_process(delta):
	var directionX = Input.get_axis("move_left", "move_right")
	if directionX:
		velocity.x = directionX * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var directionY = Input.get_axis("move_up", "move_down")
	if directionY:
		velocity.y = directionY * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()


func attacked(type:String, power:int):
	print("Attacked by %s type attack with %s power." % [type, power])
	hp -= power
	print("HP: %s" % hp)
