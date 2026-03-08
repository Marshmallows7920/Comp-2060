extends Area2D

@export var speed: float = 700.0
@export var life_time: float = 2.0

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	# auto-delete after some time
	var t := get_tree().create_timer(life_time)
	t.timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	# Save for later after implemented enemy
	queue_free()
