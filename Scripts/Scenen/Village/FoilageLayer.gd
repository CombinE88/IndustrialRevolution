extends Node

class_name FoilageLayer

var trees = []

func AddTree(cell:Vector2):
	for tree in trees:
		if tree[1] == cell:
			return
	
	var newTree = preload("res://treeTest.tscn")
	var instancedTree = newTree.instance() 
	trees.append([instancedTree,cell])
	
	get_parent().add_child(instancedTree)
	
	var cellCenter = get_parent().Village_Terrain.get_centerOfCell(cell)
	instancedTree.transform.origin = cellCenter

func RemoveTree(cell:Vector2):
	var queueRemoval = []
	for tree in trees:
		if tree[1] == cell:
			tree[0].queue_free()
			queueRemoval.append(tree)
	for remo in queueRemoval:
		trees.erase(remo)
