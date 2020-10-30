extends Object

class_name Cursor_Handler

var Cursor:CurserType setget set_cursor
var free_queue:Array

var dragMesh:CSGMesh

#	---- Drag Cursor ----
	
func queue_cursore_for_free(Cursor):
	free_queue.append(Cursor)

func handleCursor(current_click:Vector3 ,current_cell:Vector2,event:InputEvent):
	
	if(free_queue.size()>0):
		for object in free_queue.duplicate():
			var cursortime:CurserType = object
			cursortime.free_custom(GameData.game_world)
			cursortime.free()
			free_queue.erase(cursortime)	
		
	if event.is_action_pressed("Mouse_Right_click"):
		if(Cursor != null):
			queue_cursore_for_free(Cursor)
			Cursor = null
		GameData.cameraAnchor.selectedItem = null
		return
	#hacky movement des testactors
	#if event.is_action_pressed("Mouse_Left_click") && GameData.cameraAnchor.activeVillage != null:
	#	for actor in GameData.cameraAnchor.activeVillage.ActorList:
	#		if actor.Owner == GameData.LocalPlayer:
	#			actor.QueueAction("FollowPathAction",[current_click],false,true)
	
	#if dragMesh == null:
	#	dragMesh = CSGMesh.new()
	#	dragMesh.mesh = CubeMesh.new()
	#	GameData.game_world.add_child(dragMesh)		
	#	dragMesh.set_material(load("res://Materials/Dirt.material"))
		
	if(GameData.cameraAnchor.activeVillage != null && current_cell != null):
		var cells = []
		for pachts in GameData.cameraAnchor.activeVillage.PachtZellen.keys():
			if pachts.has_point(Vector2(current_cell.x,current_cell.y)):
				for x in pachts.size.x:
					for y in pachts.size.y:
						cells.append(Vector2(pachts.position.x+x,pachts.position.y+y))
		if cells.size()>0:
			var minX = cells[0].x
			var maxX = cells[cells.size()-1].x
			var minY = cells[0].y
			var maxY = cells[cells.size()-1].y
		
			#dragMesh.mesh.size = Vector3(
			#	(maxX+1-minX)*4,
			#	0.5,
			#	(maxY+1-minY)*4)
			#dragMesh.transform.origin = GameData.cameraAnchor.activeVillage.Village_Terrain.to_global(
			#	GameData.cameraAnchor.activeVillage.Village_Terrain.get_centerOfCell(
			#		Vector2(minX,minY))+Vector3(dragMesh.mesh.size.x/2-2,0,dragMesh.mesh.size.z/2-2))
		
	if Cursor == null:
		return
	
	Cursor.handle_cursor(current_cell,event,current_click)

func set_cursor(curser:CurserType):
	if Cursor != null:
		queue_cursore_for_free(Cursor)
	Cursor = curser
