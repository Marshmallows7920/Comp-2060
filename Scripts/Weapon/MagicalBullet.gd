extends Area2D

@export var speed: float = 300.0
@export var life_time: float = 2.0

var direction: Vector2 = Vector2.RIGHT
var damage: int = 1
var attack_type: String = DamageCalculator.TYPE_MAGIC
var shooter: Node = null


func _ready() -> void:
	var timer := get_tree().create_timer(life_time)
	timer.timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	global_position += direction.normalized() * speed * delta


func _on_body_entered(body: Node) -> void:
	if body == shooter:
		return

	if body.has_method("take_damage"):
		body.take_damage(damage, attack_type, shooter)

	queue_free()
