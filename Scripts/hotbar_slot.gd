extends AspectRatioContainer

@onready var overlay = $PanelContainer/ColorRect

@export_file("*.stylebox") var selected_style:String
@export_file("*.stylebox") var not_selected_style:String

@export var default_size = Vector2(128,128)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_num(num):
	$PanelContainer/SlotNumber.text = str(num)

func set_sprite(sprite):
	$PanelContainer/TextureRect.texture = sprite

func set_shader(shader):
	var mat = ShaderMaterial.new()
	mat.shader = shader
	$PanelContainer/TextureRect.material = mat

func outline(is_selected):
	if is_selected:
		$PanelContainer.add_theme_stylebox_override("panel", load(selected_style))
		if custom_minimum_size == default_size:
			custom_minimum_size = default_size * 1.25
	else:
		$PanelContainer.add_theme_stylebox_override("panel", load(not_selected_style))
		custom_minimum_size = default_size


func update_cooldown(cd, max):
	overlay.material = overlay.material.duplicate()
	overlay.material.set_shader_parameter("cooldown", cd)
	overlay.material.set_shader_parameter("max_cooldown", max)
