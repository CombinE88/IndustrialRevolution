extends Part

# Determens Value of Actor
# used to determen cost when building and selling ect

class_name Valued

var Cost = {}

func initialize(costDictionary:Dictionary):
	Cost = costDictionary

func get_class():
	return "Valued"

func Update():
	pass
