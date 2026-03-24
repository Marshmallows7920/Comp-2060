extends CharacterBody2D


const SPEED = 100.0
var hp = 100

#hotbar variables
@onready var hotbar = $CanvasLayer/Hotbar
@export var numSpellSlots:int = 5
const MAX_SPELL_SLOTS = 4
var spellSlots #= ["fireball", "icicle", "", ""]
var slotSelected = 1
@export_file("*.tscn") var hotbarSlotScene:String

@export_file("*.tscn") var fireball:String


func _ready():
	numSpellSlots = clampi(numSpellSlots, 1, MAX_SPELL_SLOTS)
	spellSlots = []
	for i in range(1, MAX_SPELL_SLOTS+1):
		spellSlots.append("")
	slotSelected = clampi(slotSelected, 1, numSpellSlots)
	hotbar.update(numSpellSlots, spellSlots, slotSelected)


func _process(delta):
	for i in range(1,numSpellSlots+1):
		if Input.is_action_just_pressed("Slot"+str(i)):
			if numSpellSlots >= i:
				slotSelected = i
	if Input.is_action_just_pressed("NextSlot"):
		slotSelected = wrapi(slotSelected+1, 1, numSpellSlots+1)
	elif Input.is_action_just_pressed("PrevSlot"):
		slotSelected = wrapi(slotSelected-1, 1, numSpellSlots+1)
	hotbar.update(numSpellSlots, spellSlots, slotSelected)
	
	if Input.is_action_just_pressed("Attack"):
			var dir = (get_global_mouse_position() - position).normalized()
			spawnFireball(position, dir)



func _physics_process(delta):
	var directionX = Input.get_axis("MoveLeft", "MoveRight")
	if directionX:
		velocity.x = directionX
	else:
		velocity.x = 0
		
	var directionY = Input.get_axis("MoveUp", "MoveDown")
	if directionY:
		velocity.y = directionY
	else:
		velocity.y = 0
	
	velocity = velocity.normalized() * SPEED
	
	move_and_slide()


func spawnFireball(pos, dir):
	var newFireball = load(fireball).instantiate()
	newFireball.global_position = pos
	newFireball.setDirection(dir)
	get_tree().root.add_child(newFireball)


func attacked(type:String, power:int):
	print("Attacked by %s type attack with %s power." % [type, power])
	hp -= power
	print("HP: %s" % hp)
