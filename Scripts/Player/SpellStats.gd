extends Node
class_name SpellStats

@export_file("*.tscn") var fireball:String
@export_file("*.png") var fireball_sprite:String
@export_file("*.tres") var fireball_shader:String

@export_file("*.tscn") var icicle:String
@export_file("*.png") var icicle_sprite:String
@export_file("*.tres") var icicle_shader:String

@export_file("*.tscn") var boulder:String
@export_file("*.png") var boulder_sprite:String
@export_file("*.tres") var boulder_shader:String


@export var num_slots:int = 2
@export var MAX_SLOTS = 4
var slots
var available = ["fireball", "icicle", "boulder"]
var selected = 0
var cooldowns

@export var fireball_description = "Shoot a ball of fire that will explode on impact."
@export var fireball_stats = ["damage", "cooldown", "mana_cost", "speed"]
@export var fireball_base_damage = 10
@export var fireball_damage_growth = 2
@export var fireball_base_cooldown = 2.0
@export var fireball_cooldown_growth = 0.2
@export var fireball_base_mana_cost = 5
@export var fireball_mana_cost_growth = 1
@export var fireball_base_speed = 75
@export var fireball_speed_growth = 25

var fireball_damage = fireball_base_damage
var fireball_cooldown = fireball_base_cooldown
var fireball_mana_cost = fireball_base_mana_cost
var fireball_speed = fireball_base_speed

@export var icicle_description = "Shoot an icicle that will pierce through enemies."
@export var icicle_stats = ["damage", "cooldown", "mana_cost", "pierce"]
@export var icicle_base_damage = 10
@export var icicle_damage_growth = 2
@export var icicle_base_cooldown = 2.0
@export var icicle_cooldown_growth = 0.2
@export var icicle_base_mana_cost = 5
@export var icicle_mana_cost_growth = 1
@export var icicle_base_pierce = 1
@export var icicle_pierce_growth = 1

var icicle_damage = icicle_base_damage
var icicle_cooldown = icicle_base_cooldown
var icicle_mana_cost = icicle_base_mana_cost
var icicle_pierce = icicle_base_pierce
@export var icicle_speed = 200


@export var boulder_description = "Roll a boulder that will knock back any enemies it hits."
@export var boulder_stats = ["damage", "cooldown", "mana_cost", "knockback", "size"]
@export var boulder_base_damage = 10
@export var boulder_damage_growth = 2
@export var boulder_base_cooldown = 2.0
@export var boulder_cooldown_growth = 0.2
@export var boulder_base_mana_cost = 5
@export var boulder_mana_cost_growth = 1
@export var boulder_base_knockback = 8
@export var boulder_knockback_growth = 8
@export var boulder_base_size = 1.0
@export var boulder_size_growth = 0.2

var boulder_damage = boulder_base_damage
var boulder_cooldown = boulder_base_cooldown
var boulder_mana_cost = boulder_base_mana_cost
var boulder_knockback = boulder_base_knockback
var boulder_size = boulder_base_size
@export var boulder_speed = 50
