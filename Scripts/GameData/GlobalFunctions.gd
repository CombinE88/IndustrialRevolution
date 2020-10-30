extends Node

remote func GetSharedRandomNumber():
	
	GameData.rng.randomize()
	var randomNumber = GameData.rng.randi()
	rpc("SetRandomNumber",randomNumber)
	GameData.randomNumber = randomNumber
	return GameData.randomNumber
	
remote func SetRandomNumber(randomNumber:int):
	GameData.randomNumber = randomNumber

func IsServer(player:Player = GameData.LocalPlayer) -> bool:
	return player.PlayerID == 1

func IsLocalPlayer(player:Player):
	return GameData.LocalPlayer.PlayerID == player.PlayerID
	
func Patchgenerator(
	gridSize:Vector2,
	rectangleSizeX:Vector2,
	rectangleSizeY:Vector2,
	randomSeed:int):
	var rng = RandomNumberGenerator.new()
	rng.set_seed(randomSeed) 
	var splitXNumbers = [0]
	var xSum = 0
	while xSum < gridSize.x:
		var rSpalte = min(
			rng.randi_range(
				int(rectangleSizeX.x),
				int(rectangleSizeX.y)),
			100-xSum)
		splitXNumbers.append(rSpalte)
		xSum += rSpalte
		
	var splitYNumbers = [0]
	var ySum = 0
	while ySum < gridSize.y:
		var rReihe = min(
			rng.randi_range(
				int(rectangleSizeY.x),
				int(rectangleSizeY.y)),
			100-ySum)
		splitYNumbers.append(rReihe)
		ySum += rReihe
		
	var rectangles = []
	
	var xPos = 0
	var yPos = 0
	var xSize = 0
	var ySize = 0
			
	for x in splitXNumbers.size()-1:
		
		xPos += splitXNumbers[x]
		yPos = 0
			
		if x == splitXNumbers.size()-1:
			xSize = gridSize.x - xPos
		else:
			xSize = splitXNumbers[x+1]
			
		for y in splitYNumbers.size()-1:
			
			yPos += splitYNumbers[y]
			
			if y == splitYNumbers.size()-1:
				ySize = gridSize.y - yPos
			else:
				ySize = splitYNumbers[y+1]
				
			rectangles.append(
				Rect2(
					xPos,
					yPos,
					xSize,
					ySize))
					
	for rectangle in rectangles:
		
		var rectangleIndex = rectangles.find(rectangle)
		var rectangleBelowIndex
		if rng.randi_range(0,4) == 0:
			var getRectangleBelow = null
			for rect in rectangles:
				if rect.has_point(Vector2(rectangle.position.x+1,rectangle.position.y+rectangle.size.y+1)):
					getRectangleBelow = rect
					rectangleBelowIndex = rectangles.find(rect)
					break
			
			if getRectangleBelow == null:
				continue
				
			var upDown = rng.randi_range(0,1)
			var length = rng.randi_range(2,3)
			if upDown == 0:
				rectangle.size.y -= length
				getRectangleBelow.position.y -= length
				getRectangleBelow.size.y += length
			else:
				rectangle.size.y += length
				getRectangleBelow.position.y += length
				getRectangleBelow.size.y -= length
				
			rectangles[rectangleIndex] = rectangle
			rectangles[rectangleBelowIndex] = getRectangleBelow
		
	for rectangle in rectangles:
		var rectangleIndex = rectangles.find(rectangle)
		var rectangleRightIndex
		var getRectangleRight = null
		for rect in rectangles:
			if rect.has_point(Vector2(
				rectangle.position.x + rectangle.size.x + 1,
				 rectangle.position.y + 1)):
				getRectangleRight = rect
				rectangleRightIndex = rectangles.find(rect)
				break
			
		if getRectangleRight == null || rectangle.position.y != getRectangleRight.position.y || rectangle.size.y != getRectangleRight.size.y:
			continue
			
		var leftRight = rng.randi_range(0,1)
		var length = rng.randi_range(2,3)
		
		if leftRight == 0:
			rectangle.size.x -= length
			getRectangleRight.position.x -= length
			getRectangleRight.size.x += length
		else:
			rectangle.size.x += length
			getRectangleRight.position.x += length
			getRectangleRight.size.x -= length
			
		rectangles[rectangleIndex] = rectangle
		rectangles[rectangleRightIndex] = getRectangleRight
		
	return rectangles

func GetPlayer(playerID:int)->Player:
	var player = null
	if playerID == GameData.LocalPlayer.PlayerID:
		player = GameData.LocalPlayer
		return player
	else:
		for pl in GameData.player.values():
			if pl.PlayerID == playerID:
				player = pl
				break
				
	if player == null:
		return null
		
	return player

func GetPlayerStorage(village:Village,player:Player)->StoresRecources:
	var actorCanStore = null
	var resourceStorage = null
	
	for actor in village.ActorList:
		
		if actor.Owner != player:
			continue
		
		resourceStorage = actor.getFirstPartOrDefault("StoresRecources")
		
		if resourceStorage == null:
			continue
		
		actorCanStore = actor
		break
		
	if resourceStorage == null || actorCanStore == null:
		return null
		
	return resourceStorage
