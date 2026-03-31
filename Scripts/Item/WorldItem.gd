extends Area2D

var item: Item


func _ready() -> void:
	connect("body_entered", _on_body_entered)
	print("WorldItem ready, sprite node: ", $Sprite2D)
	print("WorldItem ready, texture: ", $Sprite2D.texture)
func setup(i: Item) -> void:
	item = i
	$Sprite2D.texture = item.sprite
	print("setup called, texture is now: ", $Sprite2D.texture)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		item.use(body)
		queue_free()
