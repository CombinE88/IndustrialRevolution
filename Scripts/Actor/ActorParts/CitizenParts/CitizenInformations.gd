extends Part

class_name CitizenInformations

var CitizenName:String
var CitizenStatus:String

func get_class():
	return "CitizenInformations"

func _ready():
	if GlobalFunctions.IsServer():
		get_name()

func set_status(status:String):
	CitizenStatus = status
	
remote func get_name():
	if !GlobalFunctions.IsServer():
		rpc_id(1,"get_name")
		return
	var name = GameData.nachnamen[GameData.rng.randi_range(0,GameData.nachnamen.size()-1)]
	rpc("setName",name)
	setName(name)

remote func setName(name:String):
	CitizenName = name
