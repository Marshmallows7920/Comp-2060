extends CharacterBody2D

@onready var weapon_holder: Node2D = $WeaponHolder
@onready var stats: PlayerStats = $Stats
@onready var anim: AnimatedSprite2D = $Sprite
@onready var inventory: Inventory = $Inventory

@onready var hp_bar: ProgressBar = $UIAnchor/HPBar
@onready var mana_bar: ProgressBar = $UIAnchor/ManaBar

@onready var hotbar = $HUD/Hotbar

var equipped_weapon: Weapon = null
var facing_direction: Vector2 = Vector2.RIGHT
var is_dead: bool = false

@export var numSpellSlots:int = 2
const MAX_SPELL_SLOTS = 4
var spellSlots #= ["fireball", "icicle", "", ""]
var slotSelected = 1

@export_file("*.tscn") var fireball:String

func _ready() -> void:
	numSpellSlots = clampi(numSpellSlots, 1, MAX_SPELL_SLOTS)
	spellSlots = []
	for i in range(1, MAX_SPELL_SLOTS+1):
		spellSlots.append("")
	slotSelected = clampi(slotSelected, 1, numSpellSlots)
	hotbar.update(numSpellSlots, spellSlots, slotSelected)
	
	if weapon_holder.get_child_count() > 0:
		var first_child: Node = weapon_holder.get_child(0)
		if first_child is Weapon:
			equipped_weapon = first_child
	update_ui()



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



func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	stats.update_modifiers(delta)
	update_ui()
	
	movement()
	attack()
	item_input()
	move_and_slide()
	
	if stats.is_dead():
		die()


func movement() -> void:
	var direction := Vector2(
		Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft"),
		Input.get_action_strength("MoveDown") - Input.get_action_strength("MoveUp")
	).normalized()
	
	if direction != Vector2.ZERO:
		facing_direction = direction
	
		if anim.animation != "Attack":
			anim.play("Walk")
	
		if facing_direction.x != 0:
			anim.flip_h = facing_direction.x < 0
	else:
		if anim.animation == "Walk":
			anim.stop()
	
	velocity = direction * stats.move_speed()


func attack() -> void:
	if Input.is_action_just_pressed("Attack") and equipped_weapon != null:
		equipped_weapon.attack(facing_direction, stats.atk_stat(), stats.damage_type)
		anim.play("Attack")


func item_input() -> void:
	if Input.is_action_just_pressed("UseItem"):
		inventory.use_current_item(self)
	
	if Input.is_action_just_pressed("NextItem"):
		inventory.next_item()
	
	if Input.is_action_just_pressed("PrevItem"):
		inventory.prev_item()


func equip_weapon(new_weapon: Weapon) -> void:
	if equipped_weapon != null:
		equipped_weapon.queue_free()
	
	weapon_holder.add_child(new_weapon)
	new_weapon.position = Vector2.ZERO
	equipped_weapon = new_weapon


func heal(amount: int) -> void:
	if is_dead:
		return
	stats.heal(amount)
	update_ui()


func restore_mana(amount: int) -> void:
	if is_dead:
		return
	stats.restore_mana(amount)
	update_ui()


func attacked(amount: int, attack_type: String = DamageCalculator.TYPE_MAGIC) -> void:
	if is_dead:
		return
	
	stats.take_damage(amount, attack_type)
	update_ui()
	
	if stats.is_dead():
		die()


func add_modifier(modifier: StatModifier) -> void:
	if is_dead:
		return
	stats.add_modifier(modifier)


func remove_modifier(modifier_id: String) -> void:
	stats.remove_modifier(modifier_id)


func update_ui() -> void:
	hp_bar.max_value = stats.max_hp()
	hp_bar.value = stats.current_hp
	
	mana_bar.max_value = stats.max_mana()
	mana_bar.value = stats.current_mana


func die() -> void:
	if is_dead:
		return
	
	is_dead = true
	velocity = Vector2.ZERO
	anim.play("Die")
	await anim.animation_finished
	anim.stop()


func spawnFireball(pos, dir):
	var newFireball = load(fireball).instantiate()
	newFireball.global_position = pos
	newFireball.setDirection(dir)
	newFireball.par = self
	newFireball.playerStats = stats
	get_tree().root.add_child(newFireball)


func killedEnemy(experience):
	stats.exp_gained(experience)
