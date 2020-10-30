extends Spatial

class_name TerrainWorld

var grid:Vector2
var cellSize:Vector2
var mesh_Size:Vector2

var noise:OpenSimplexNoise
var renderDebug:bool
var mesh_instance:MeshInstance
var plane_mesh:PlaneMesh
var data_tool:MeshDataTool
var terrainheight:int

var cells:Dictionary = {}
	
func GenerateTerrain(_grid:Vector2,_cellSize:Vector2,_noise:OpenSimplexNoise,_terrainheight:int,_renderDebug:bool = false):
	grid = _grid
	cellSize = _cellSize
	mesh_Size = Vector2(_grid.x * _cellSize.x,_grid.y * _cellSize.y)
	noise = _noise
	renderDebug = _renderDebug
	terrainheight = _terrainheight
	
	data_tool = MeshDataTool.new()
	mesh_instance = $TerrainMesh
	plane_mesh = PlaneMesh.new()
	var surface_tool = SurfaceTool.new()
	
	plane_mesh.size = mesh_Size
	plane_mesh.subdivide_depth = grid.x - 1
	plane_mesh.subdivide_width = grid.y - 1
	
	surface_tool.create_from(plane_mesh, 0)
	
	var array_plane = surface_tool.commit()
	
	data_tool.create_from_surface(array_plane, 0)
		
	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		vertex.y = noise.get_noise_3d(vertex.x, vertex.y, vertex.z) * terrainheight
		
		data_tool.set_vertex(i, vertex)
		
	for i in range(array_plane.get_surface_count()):
		array_plane.surface_remove(i)
	
	data_tool.commit_to_surface(array_plane)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(array_plane, 0)
	surface_tool.generate_normals()
	
	mesh_instance.mesh = surface_tool.commit()
	mesh_instance.set_surface_material(0, load("res://Scripts/Scenen/Village/VillageGround.tres"))
	mesh_instance.create_trimesh_collision()
	
	#############DEBUG render as Wireframe
	if renderDebug:
		var a = mesh_instance.mesh.surface_get_arrays(0)
		var m = mesh_instance.mesh.surface_get_material(0)
		mesh_instance.mesh.surface_remove(0)
		mesh_instance.mesh.add_surface_from_arrays(1, a)
		mesh_instance.mesh.surface_set_material(0, m)
	
	for x in range(grid.x):
		for y in range(grid.y):
			cells[Vector2(x,y)] = null
	
	#mesh_instance.transform.origin = Vector3(
	#	plane_mesh.size.x / 2,
	#	0,
	#	plane_mesh.size.y / 2)
	
func get_centerOfCell(cell:Vector2):
	return Vector3(
		transform.origin.x + cell.x * cellSize.x + cellSize.x/2 - mesh_Size.x/2 ,
		getAverageHeightOfCell(cell),
		transform.origin.y + cell.y * cellSize.y + cellSize.y/2 - mesh_Size.y/2)

func getAverageHeightOfCell(cell:Vector2):
	var average:float = 0.0
	var verts:PoolVector3Array = getCellsCornerVerts(cell)
	for vert in verts:
		average += vert.y
	return average / verts.size()
	
func getCellsCornerVerts(cell:Vector2):
	return PoolVector3Array([
		data_tool.get_vertex(
			data_tool.get_vertex_count()-1-data_tool.get_face_vertex((
				cell.y*100+cell.x)*2,0))
		+Vector3(plane_mesh.size.x / 2,0, plane_mesh.size.y / 2),
		data_tool.get_vertex(
			data_tool.get_vertex_count()-1-data_tool.get_face_vertex((
				cell.y*100+cell.x)*2,1))
		+Vector3(plane_mesh.size.x / 2,0, plane_mesh.size.y / 2),
		data_tool.get_vertex(
			data_tool.get_vertex_count()-1-data_tool.get_face_vertex(1+(
				cell.y*100+cell.x)*2,1))
		+Vector3(plane_mesh.size.x / 2,0, plane_mesh.size.y / 2),
		data_tool.get_vertex(
			data_tool.get_vertex_count()-1-data_tool.get_face_vertex(1+(
				cell.y*100+cell.x)*2,2))
		+Vector3(plane_mesh.size.x / 2,0, plane_mesh.size.y / 2)])

func findCellByCoordinates(worldPos:Vector3):
	
	var cellx = round((worldPos.x - get_parent().transform.origin.x + mesh_Size.x/2 - cellSize.x/2) / cellSize.x)
	var celly = round((worldPos.z - get_parent().transform.origin.z + mesh_Size.y/2 - cellSize.y/2) / cellSize.y)
	return Vector2(cellx,celly)

func get_highest_cell(cell:Vector2, footprint:Footprint):
	var newCell: = cell
	for x in range(footprint.width):
		for y in range(footprint.height):
			var found_cell:Vector2 = Vector2(
				cell.x + x - footprint.origin_x,
				cell.y + y - footprint.origin_y)
			
			if cells.has(found_cell) && getAverageHeightOfCell(found_cell) > getAverageHeightOfCell(newCell):
				newCell = found_cell
	return newCell
