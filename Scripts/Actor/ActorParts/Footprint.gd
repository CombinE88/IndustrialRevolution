extends Node

class_name Footprint

var width: int
var height: int

var occupationType:String

var origin_x: int
var origin_y: int

func initialize(size_x:int, size_y:int, occupation:String, offset_x:int = 0, offset_y:int = 0):
	width = size_x
	height = size_y
	origin_x = offset_x
	origin_y = offset_y
	
	var loverTrim = occupation.strip_edges(true,true).to_lower()
	for chara in loverTrim:
		if chara != "x" && chara != "_":
			push_error("occuptation string must contain either x or _")
	occupationType = loverTrim;

func get_class():
	return "Footprint"
	
func rotate_Footprint():
	var new_String:String = occupationType
	for xx in range(width):
		for yy in range(height):
			var newX = height - 1 - yy
			var newY = xx
			var currentValue = occupationType[xx + yy * width]
			new_String[newX + newY * height] = currentValue
	occupationType = new_String
	var a = width
	var b = height
	width = b
	height = a

func returnFootprintCenterOffset(cellSize:Vector2):
	return Vector3(
		cellSize.x / 2 * (width - 1),
		0,
		cellSize.y / 2 * (height - 1))

func CenterOfFootprintLocation(cell:Vector2,cellSize:Vector2,terrain):
	var cellCenter = terrain.get_centerOfCell(cell)
	return cellCenter + Vector3(
		cellSize.x / 2 * (width - 1),
		0,
		cellSize.y / 2 * (height - 1))
