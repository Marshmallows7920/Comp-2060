extends Area2D

var playerStats
var par
var speed
var direction: Vector2

@export var life_time: float = 0.6


func _ready():
	var timer = get_tree().create_timer(life_time)
	timer.timeout.connect(queue_free)


func _physics_process(delta):
	position = position + direction * speed * delta


func setDirection(dir):
	direction = dir
	rotation = direction.angle()


func _on_body_entered(body):
	if body.is_in_group("TileMap"):
		queue_free()
	elif body.is_in_group("Enemy"):
		var damage = roundi(playerStats.atk_stat() * 2.0)
		body.take_damage(damage, playerStats.damage_type, par)
		print("Hit Enemy")
		queue_free()


func _on_area_exited(area):
	if area.is_in_group("PlayArea"):
		queue_free()
