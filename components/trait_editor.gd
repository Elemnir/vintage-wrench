extends VBoxContainer
class_name TraitEditor

const ATTR_LINE_SCENE = preload("res://components/attribute_line.tscn")
const CHAR_ATTRS: Array[String] = [
	"meleeWeaponsDamage",
	"armorDurabilityLoss",
	"armorWalkSpeedAffectedness",
	"rangedWeaponsDamage",
	"rangedWeaponsAcc",
	"bowDrawingStrength",
	"mechanicalsDamage",
	"animalLootDropRate",
	"animalHarvestingTime",
	"forageDropRate",
	"wildCropDropRate",
	"oreDropRate",
	"vesselContentsDropRate",
	"rustyGearDropRate",
	"wholeVesselLootChance",
	"animalSeekingRange",
	"temporalGearTLRepairCost",
	"miningSpeedMul",
	"maxhealthExtraPoints",
	"hungerrate",
	"walkspeed",
]
var _traits: Array[Dictionary] = []


@onready var traits_list = %TraitsList
@onready var attr_list = %AttributeList


func _ready():
	for attr in CHAR_ATTRS:
		var new_line = ATTR_LINE_SCENE.instantiate()
		new_line.call_deferred("set_char_attr", attr)
		attr_list.add_child(new_line)
		
func _on_traits_list_item_selected(index):
	var item_key = traits_list.get_item_text(index)
	
	
