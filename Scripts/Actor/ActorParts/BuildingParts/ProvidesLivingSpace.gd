extends Part

class_name ProvidesLivingSpace

var LivingSpace:int = 5
var HousingActors:Array = []

func get_class():
	return "ProvidesLivingSpace"

func isFull() -> bool:
	return HousingActors.size() >= LivingSpace

func RegisterInHouse(actor:Actor) -> bool:
	if !isFull():
		HousingActors.append(Actor)
		return true
	return false

func MoveOut(actor:Actor):
	if HousingActors.has(actor):
		HousingActors.erase(actor)
	
func Tick():
	return
