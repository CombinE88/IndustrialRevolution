extends Node

class_name RoadNetwork

var roadCells:Array
var roadMainMesh:MeshInstance
var dataTool = MeshDataTool.new()
var surfaceNumber:int = 0

func _initialize():
	roadMainMesh =  get_node("../RoadMesh")
	roadMainMesh.mesh = ArrayMesh.new()
	
func CreateNewRoadSegment(terrain:TerrainWorld,cell:Vector2,offset:Vector3):
	
	var modulateXShitftPosition = float(int(cell.x)%10)/10.0
	var modulateYShitftPosition = float(int(cell.y)%10)/10.0
	
	offset += Vector3(0,0.1,0)
	
	var verts = PoolVector3Array()
	var indicies = PoolIntArray()
	var normals = PoolVector3Array()
	var uvs = PoolVector2Array()
	
	var cornerVerts = terrain.getCellsCornerVerts(cell)
	
	verts.append(Vector3(+2,cornerVerts[1].y,-2)+offset)
	verts.append(Vector3(+2,cornerVerts[2].y,+2)+offset)
	verts.append(Vector3(-2,cornerVerts[3].y,+2)+offset)
	
	uvs.append(Vector2(0.1+modulateXShitftPosition,0+modulateYShitftPosition))
	uvs.append(Vector2(0.1+modulateXShitftPosition,0.1+modulateYShitftPosition))
	uvs.append(Vector2(0+modulateXShitftPosition,0.1+modulateYShitftPosition))
	
	for vert in range(verts.size()):
		normals.append(Vector3.UP)
		
	for i in 3:
		indicies.append(i)
	
	var arr = []
	arr.resize(ArrayMesh.ARRAY_MAX)
	
	arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_NORMAL] = normals
	arr[Mesh.ARRAY_INDEX] = indicies
	
	roadMainMesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	roadMainMesh.mesh.surface_set_material(surfaceNumber,load("res://Materials/Dirt.material"))
	surfaceNumber +=1
	
	verts = PoolVector3Array()
	indicies = PoolIntArray()
	normals = PoolVector3Array()
	uvs = PoolVector2Array()
	
	verts.append(Vector3(-2,cornerVerts[3].y,+2)+offset)
	verts.append(Vector3(-2,cornerVerts[0].y,-2)+offset)
	verts.append(Vector3(+2,cornerVerts[1].y,-2)+offset)
	
	uvs.append(Vector2(0+modulateXShitftPosition,0.1+modulateYShitftPosition))
	uvs.append(Vector2(0+modulateXShitftPosition,0+modulateYShitftPosition))
	uvs.append(Vector2(0.1+modulateXShitftPosition,0+modulateYShitftPosition))
	
	for vert in range(verts.size()):
		normals.append(Vector3.UP)
		#if vert != 0:
		#	normals.append(verts[vert]-verts[vert-1].normalized())
		#else:			
		#	normals.append(verts[vert]-verts[verts.size()-1].normalized())
		
	for i in 3:
		indicies.append(i)
		
	arr = []
	arr.resize(ArrayMesh.ARRAY_MAX)
	
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_NORMAL] = normals
	arr[Mesh.ARRAY_INDEX] = indicies
	
	roadMainMesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	roadMainMesh.mesh.surface_set_material(surfaceNumber,load("res://Materials/Dirt.material"))
	surfaceNumber +=1
	
func RegisterNewRoadSegment(terrain:TerrainWorld,cell:Vector2):
	if roadCells.has(cell):
		return
	
	var offset = Vector3(
		terrain.get_centerOfCell(cell).x,
		0.1,
		terrain.get_centerOfCell(cell).z)
	
	CreateNewRoadSegment(terrain,cell,offset*Vector3(1,0,1))
	
	if terrain.cells[cell] == null:
		return 
		
	terrain.get_parent().Astar_Navigation.set_point_weight_scale(terrain.cells[cell],1)
	
	roadCells.append(cell)
