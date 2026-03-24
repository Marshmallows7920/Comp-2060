extends Area2D

@export_file("*.wav") var launch_sound:String
@export_file("*.wav") var impact_sound:String

@export var speed: float = 300.0
@export var life_time: float = 2.0

var direction: Vector2 = Vector2.RIGHT
var damage: int = 1
var attack_type: String = DamageCalculator.TYPE_MAGIC
var shooter: Node = null


func _ready() -> void:
	play_launch_sound()
	var timer := get_tree().create_timer(life_time)
	timer.timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	global_position += direction.normalized() * speed * delta


func _on_body_entered(body: Node) -> void:
	if body == shooter:
		return

	if body.has_method("take_damage"):
		body.take_damage(damage, attack_type, shooter)
	play_impact_sound()
	queue_free()

func play_launch_sound():
	$AudioStreamPlayer2D.stream = load(launch_sound)
	$AudioStreamPlayer2D.play()

func play_impact_sound():
	$AudioStreamPlayer2D2.stream = load(impact_sound)
	$AudioStreamPlayer2D2.play()
