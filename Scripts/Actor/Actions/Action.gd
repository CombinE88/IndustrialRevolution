extends Object

class_name Action

var mySelf
var ActionFinished:bool = false
var ActionName:String

func setActionParameter(actionName:String,actorSelf,params:Array):
	mySelf = actorSelf
	ActionName = actionName
	pass

func ProcessAction():
	pass
	
func OnStart():
	pass
	
func OnCanceled():
	ActionFinished = true
	pass
	
func OnFinished():
	ActionFinished = true
	pass

