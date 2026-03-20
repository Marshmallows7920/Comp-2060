extends CharacterBody2D


const SPEED = 100.0
var hp = 100

#hotbar variables
@onready var hotbar = $CanvasLayer/Hotbar
@export var numSpellSlots:int = 2
const MAX_SPELL_SLOTS = 4
var spellSlots = ["fireball", "icicle", "", ""]
var slotSelected = 1
@export_file("*.tscn") var hotbarSlotScene:String


func _ready():
	numSpellSlots = clampi(numSpellSlots, 1, MAX_SPELL_SLOTS)
	updateHotbar()


func _process(delta):
	for i in range(1,numSpellSlots+1):
		if Input.is_action_just_pressed("Slot"+str(i)):
			if numSpellSlots >= i:
				slotSelected = i
	if Input.is_action_just_pressed("NextSlot"):
		slotSelected = wrapi(slotSelected+1, 1, numSpellSlots+1)
		print(slotSelected)
	elif Input.is_action_just_pressed("PrevSlot"):
		slotSelected = wrapi(slotSelected-1, 1, numSpellSlots+1)
		print(slotSelected)
	updateHotbar()



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



func updateHotbar():
	if hotbar != null:
		hotbar.update(numSpellSlots, spellSlots, slotSelected)
	else:
		print("NO HOTBAR!")



func attacked(type:String, power:int):
	print("Attacked by %s type attack with %s power." % [type, power])
	hp -= power
	print("HP: %s" % hp)
