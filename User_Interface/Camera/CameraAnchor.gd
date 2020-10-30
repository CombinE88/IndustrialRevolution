extends Spatial

var curser_pos = Vector2(0,0);

onready var camera = $PlayerCamera
var rayOrigin = Vector3()
var rayEnd = Vector3()

var activeVillage = null
var cursor_handler:Cursor_Handler
var selectedItem

func _ready():
	cursor_handler = Cursor_Handler.new()
	GameData.cursorHandler = cursor_handler
	
func _process(delta):	
	$CameraRay.set_cast_to(Vector3(0,-40,0))
	$CameraRay.force_raycast_update()
	
	if($CameraRay.is_colliding()):
		translate(Vector3.UP * (40 - min(
			abs($CameraRay.get_collision_point().y - global_transform.origin.y)
				,40))
				 / 20);
		
	$CameraRay.set_cast_to(Vector3(0,-100,0))
	$CameraRay.force_raycast_update()
	
	if(!$CameraRay.is_colliding() || abs($CameraRay.get_collision_point().y-global_transform.origin.y) > 50):		
		translate(Vector3.DOWN * (min(
			abs($CameraRay.get_collision_point().y + 50 - global_transform.origin.y)
				,40))
				 / 20)
	
	if(Input.is_action_pressed("W") && check_in_Bounds(Vector3.FORWARD)):
			translate(Vector3.FORWARD)
		
	if(Input.is_action_pressed("S") && check_in_Bounds(Vector3.BACK)):
		translate(Vector3.BACK)
		
	if(Input.is_action_pressed("A") && check_in_Bounds(Vector3.LEFT)):
		translate(Vector3.LEFT)
		
	if(Input.is_action_pressed("D") && check_in_Bounds(Vector3.RIGHT)):
		translate(Vector3.RIGHT)
		
	if(Input.is_action_pressed("ALT")):
		var mouse_rotation = curser_pos - get_viewport().get_mouse_position()
		rotate_y(mouse_rotation.x/100)
		if $PlayerCamera.rotation_degrees.x < -35 && mouse_rotation.y/100 > 0:
			$PlayerCamera.rotate_x(mouse_rotation.y/100)
		if $PlayerCamera.rotation_degrees.x > -65 && mouse_rotation.y/100 < 0:
			$PlayerCamera.rotate_x(mouse_rotation.y/100)
		
	var current_cell = get_current_cell(curser_pos) 	
	curser_pos = get_viewport().get_mouse_position()
	
func SetActiveItem(actor:Actor):
	selectedItem = actor
	UiLibData.ToolTipPanel.ShowAndExpandTooltip(actor)

func _unhandled_input(event):
	
	var current_cell = get_current_cell(curser_pos) 
	
	if(current_cell != null):
		cursor_handler.handleCursor(get_currentVector(curser_pos), current_cell, event)
	
func get_currentVector(cursor:Vector2):
	
	rayOrigin = camera.project_ray_origin(cursor)
	rayEnd = rayOrigin + camera.project_ray_normal(cursor) * 2000
	
	var space_state = get_world().direct_space_state
	var intersection = space_state.intersect_ray(rayOrigin, rayEnd)
	
	if "position" in intersection:
		return intersection.position
	
	return null

func get_current_cell(cursor:Vector2):
	
	var found = get_currentVector(cursor)
	if found == null:
		return null
	return GameData.cameraAnchor.activeVillage.Village_Terrain.findCellByCoordinates(found)
	

#needs fixing
func check_in_Bounds(addVector:Vector3):
	return true
	#((transform.origin + addVector*2).x < 400 
	#		&& (transform.origin + addVector*2).x > -0 
	#		&& (transform.origin + addVector*2).z < 400 
	#		&& (transform.origin + addVector*2).z > 0 )
