extends Control

@onready var slotContainer = $MarginContainer/SlotContainer
@export_file("*.tscn") var hotbarSlotScene:String
var slots
var spells
var cleared = false

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_default()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update(num_slots, slots, selected, cooldowns):
	clear_default()
	var index = slotContainer.get_child_count()
	for i in range(0, index):
		update_slot(i, slots[i], i == selected)
	while(index < num_slots):
		add_slot(index, slots[index], index == selected)
		index += 1


func add_slot(num, spell, is_selected):
	var slot = load(hotbarSlotScene).instantiate()
	slot.set_num(num+1)
	slot.outline(is_selected)
	match spell:
		"fireball":
			slot.set_sprite(load(spells.fireball_sprite))
			slot.set_shader(load(spells.fireball_shader))
		"icicle":
			slot.set_sprite(load(spells.icicle_sprite))
			slot.set_shader(load(spells.icicle_shader))
		"boulder":
			slot.set_sprite(load(spells.boulder_sprite))
			slot.set_shader(load(spells.boulder_shader))
	slotContainer.add_child(slot)


func update_slot(num, spell, is_selected):
	var slot = slotContainer.get_children()[num]
	slot.set_num(num+1)
	match spell:
		"fireball":
			slot.set_sprite(load(spells.fireball_sprite))
			slot.set_shader(load(spells.fireball_shader))
		"icicle":
			slot.set_sprite(load(spells.icicle_sprite))
			slot.set_shader(load(spells.icicle_shader))
		"boulder":
			slot.set_sprite(load(spells.boulder_sprite))
			slot.set_shader(load(spells.boulder_shader))
	slot.outline(is_selected)

func clear_default():
	if !cleared:
		for node in slotContainer.get_children():
			node.queue_free()
		cleared = true
