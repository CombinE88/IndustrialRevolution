extends Node

static func CreatePachtAreas(terrain:TerrainWorld, minHeight:int = 10, minWidth:int = 10, maxWidth:int = 5, maxHeight:int = 5) -> Dictionary:
	var pachts:Dictionary = {}
	var cellsOccupied = []
	var cell = Vector2(0,0)
	var index = 0
	var random = RandomNumberGenerator.new()
	for x in range(terrain.grid.x):
		for y in range(terrain.grid.y):
			if cellsOccupied.has(Vector2(x,y)):
				continue
			
			random.randomize()
			var width = random.randi_range(minWidth,maxWidth)
			random.randomize()
			var height = random.randi_range(minHeight,maxHeight)
			var cells = []
			for xx in width:
				var vrako = false
				for yy in height:
					var checkCell = Vector2(x+xx,y+yy)
					if cellsOccupied.has(checkCell):
						vrako = true
						break
					if terrain.cells.has(checkCell):
						cells.append(checkCell)
						cellsOccupied.append(checkCell)
				if vrako:
					break
			pachts[index] = cells
			index +=1
	return pachts
