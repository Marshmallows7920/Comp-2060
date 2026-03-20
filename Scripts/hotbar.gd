extends Control

@onready var slotContainer = $MarginContainer/SlotContainer
@export_file("*.tscn") var hotbarSlotScene:String
var slots

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in slotContainer.get_children():
		node.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update(numSlots, spells, selected):
	var index = slotContainer.get_child_count()
	for i in range(1, index+1):
		update_slot(i, spells[i-1], i == selected)
	while(index < numSlots):
		add_slot(index, spells[index-1], index == selected)
		index += 1


func add_slot(num, spell, is_selected):
	var slot = load(hotbarSlotScene).instantiate()
	slot.set_num(num)
	#get texture for spell
	#var sprite = load(spellSprite)
	#slot.set_texture(sprite)
	slot.outline(is_selected)
	slotContainer.add_child(slot)


func update_slot(num, spell, is_selected):
	var slot = slotContainer.get_children()[num-1]
	slot.set_num(num)
	#get texture for spell
	#var sprite = load(spellSprite)
	#slot.set_texture(sprite)
	slot.outline(is_selected)
