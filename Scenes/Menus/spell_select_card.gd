extends PanelContainer

@onready var spell_name = $VBoxContainer/SpellName
@onready var spell_image = $VBoxContainer/AspectRatioContainer/SpellImage
@onready var spell_description = $VBoxContainer/SpellDescription
@onready var spell_stats = $VBoxContainer/SpellStats

var card_num
var par

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func set_spell_name(new_text:String):
	print(new_text)
	spell_name.text = new_text

func set_spell_sprite(sprite):
	spell_image.texture = sprite

func set_spell_shader(shader):
	spell_image.material = ShaderMaterial.new()
	spell_image.material.shader = shader

func set_spell_description(text:String):
	spell_description.text = text

func set_spell_stats(text:String):
	spell_stats.text = text

func _on_spell_button_pressed():
	par.pressed(card_num)
