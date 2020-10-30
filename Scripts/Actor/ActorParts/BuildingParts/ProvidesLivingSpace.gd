extends Part

class_name ProvidesLivingSpace

var LivingSpace:int = 5
var HousingActos:Array = []

func get_class():
	return "ProvidesLivingSpace"

func isFull() -> bool:
	return HousingActos.size() >= LivingSpace

func RegisterInHouse(actor:Actor) -> bool:
	if !isFull():
		HousingActos.append(Actor)
		return true
	return false

func MoveOut(actor:Actor):
	if HousingActos.has(actor):
		HousingActos.erase(actor)
