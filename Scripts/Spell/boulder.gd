extends Area2D

var playerStats
var par
var speed
var direction: Vector2

@export_file("*.wav") var launch_sound:String
@export_file("*.wav") var impact_sound:String

@export var stun_duration: float = 1.0


func _ready():
	play_launch_sound()


func _physics_process(delta):
	position = position + direction * speed * delta


func setDirection(dir):
	direction = dir
	rotation = direction.angle()


func _on_body_entered(body):
	if body.is_in_group("TileMap"):
		play_impact_sound()
		queue_free()
	elif body.is_in_group("Enemy"):
		play_impact_sound()
		var damage = roundi(playerStats.atk_stat() * 2.0)
		body.take_damage(damage, playerStats.damage_type, par)

		if body.has_method("apply_stun"):
			body.apply_stun(stun_duration)

		print("Hit Enemy")
		queue_free()


func _on_area_exited(area):
	if area.is_in_group("PlayArea"):
		queue_free()

func play_launch_sound():
	$AudioStreamPlayer2D.stream = load(launch_sound)
	$AudioStreamPlayer2D.play()

func play_impact_sound():
	$AudioStreamPlayer2D2.stream = load(impact_sound)
	$AudioStreamPlayer2D2.play()
