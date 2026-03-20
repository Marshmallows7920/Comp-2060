extends Area2D

@export var SPEED = 200

var direction:Vector2

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	position = position + direction*SPEED*delta



func setDirection(dir):
	direction = dir
	rotation = direction.angle()


func _on_body_entered(body):
	if body.is_in_group("TileMap"):
		queue_free()
		#print("hit wall")


func _on_area_exited(area):
	if area.is_in_group("PlayArea"):
		queue_free()
		#print("out of area")
