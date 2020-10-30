extends Spatial

# Eingang für Actor die Entern möchten
# ExitDoor -> Doorway -> inside location

class_name Eingang

var exitLocation:Vector3
var doorway:Vector3
var insideLocation:Vector3
var astarId:int

var spatialexitLocation
var spatialdoorway
var spatialinsideLocation

func get_class():
	return "Eingang"
	
func initialize(
	exitDoorConnection:Vector3 = Vector3(0,0,4),
	doorwaylocalPosition:Vector3 = Vector3(0,0,2),
	insideLocalPosition:Vector3 = Vector3(0,0,0)):
	
	spatialexitLocation = CSGMesh.new()
	spatialexitLocation.transform.origin = exitDoorConnection
	add_child(spatialexitLocation)
	#spatialexitLocation.mesh = SphereMesh.new()
	
	spatialdoorway = CSGMesh.new()
	spatialdoorway.transform.origin = doorwaylocalPosition
	add_child(spatialdoorway)
	#spatialdoorway.mesh = SphereMesh.new()
	
	spatialinsideLocation = CSGMesh.new()
	spatialinsideLocation.transform.origin = insideLocalPosition
	add_child(spatialinsideLocation)
	#spatialinsideLocation.mesh = SphereMesh.new()
	
	exitLocation = exitDoorConnection
	doorway = doorwaylocalPosition
	insideLocation = insideLocalPosition

func Update():
	
	exitLocation = spatialexitLocation.global_transform.origin - get_parent().global_transform.origin 
	insideLocation = spatialinsideLocation.global_transform.origin - get_parent().global_transform.origin 
	doorway = spatialdoorway.global_transform.origin - get_parent().global_transform.origin 
