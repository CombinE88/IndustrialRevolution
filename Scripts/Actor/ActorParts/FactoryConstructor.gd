extends Object

class_name FactoryConstructor


static func CalculateRotation(position:Vector2,rectangleSize:Vector2):
	var rotation = 180
	
	if position.y == rectangleSize.y-1 && position.x == rectangleSize.x-1:
		rotation += 180
	elif position.y == rectangleSize.y-1 && position.x == 0:
		rotation += 90
	elif position.x == 0 && position.y != 0:
		rotation += 90
	elif position.x == rectangleSize.x-1:
		rotation -= 90
	elif position.y == rectangleSize.y-1:
		rotation -= 180
	return deg2rad(rotation)

static func createMeshes(
	segmentSize:Vector2,
	footprint:Footprint,
	ModelRoof:String,
	RoofMaterial:String,
	ModelWall:String,
	WallMaterial:String,
	ModelCorner:String,
	CornerMaterial:String):

	var meshes:Array = []
	
	for x in footprint.width:
		for y in footprint.height:
			
			var newMesh = CSGMesh.new()
			if (x == 0 || x == footprint.width-1) && (y == 0 || y == footprint.height-1):
				newMesh.mesh = load(ModelCorner)
				newMesh.material = load(CornerMaterial)
			elif x == 0 || x == footprint.width-1 || y == 0 || y == footprint.height-1:
				newMesh.mesh = load(ModelWall)
				newMesh.material = load(WallMaterial)
			else:
				newMesh.mesh = load(ModelRoof)
				newMesh.material = load(RoofMaterial)
			
			newMesh.translate(
				Vector3(x * segmentSize.x - footprint.width * segmentSize.x / 2 + segmentSize.x / 2
					,0
					,y * segmentSize.y - footprint.height * segmentSize.y / 2  + segmentSize.y / 
					2))
					
			newMesh.rotate_y(CalculateRotation(Vector2(x,y),Vector2(footprint.width,footprint.height)))
			
			meshes.append(newMesh)
	return meshes
