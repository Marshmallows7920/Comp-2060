extends Area2D

@export_file("*.tres") var noise_texture:String
@onready var sprite = $Sprite2D
var playerStats
var par
var speed

var direction:Vector2

func _ready():
	sprite.material = sprite.material.duplicate()
	sprite.material.set_shader_parameter("position", global_position)
	sprite.material.set_shader_parameter("noise_texture", load(noise_texture))


func _physics_process(delta):
	position = position + direction*speed*delta
	sprite.material.set_shader_parameter("position", global_position)



func setDirection(dir):
	direction = dir
	#rotation = direction.angle()



func _on_body_entered(body):
	if body.is_in_group("TileMap"):
		queue_free()
		#print("hit wall")
	elif body.is_in_group("Enemy"):
		body.attacked(playerStats.atk_stat(), "rock", par)
		print("Hit Enemy")
		queue_free()


func _on_area_exited(area):
	if area.is_in_group("PlayArea"):
		queue_free()
		#print("out of area")
