extends Node

var Lagerhaus = ["LagerHaus",
		["ArrayMeshPart","res://Models/HousesV2/Models/industbuild1.mesh"],
		["FootprintPart", 3, 2, "xxxxxx"],
		["ToolTipInfoPart", "Lagerhaus"],
		["Selectable"],
		["StoresRecources"],
		["EingangPart",Vector3(0,0,6),Vector3(0,0,0)]]
		
var SaegeFabrik = ["SaegeWerk",
		["ArrayMeshPart","res://Models/HousesV2/Models/industbuild4.mesh"],
		["FootprintPart", 2, 3, "xxxxxx"],
		["ToolTipInfoPart", "Sägewerk"],
		["Selectable"],
		["GeneratesRecources","Holz",1,30],
		["EingangPart",Vector3(0,0,8),Vector3(0,0,0)],
		["ProvidesWorkingSpace","LagerArbeiten",2,["Organisation"]],
		["ProvidesWorkingSpace","Säge",1,["Werkzeuge"]],
		["ProvidesWorkingSpace","Verschnitt",1,["Kraft"]],
		["Valued",{
			"Roh Holz":5,
			"Bruchstein":15,
			"Ziegel":10,
			"Zement":4
			}]]

var Rathaus = ["Rathaus",
		["ArrayMeshPart","res://Models/HousesV2/Models/publbuild1.mesh"],
		["FootprintPart", 6, 5, "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"],
		["ToolTipInfoPart", "Rathaus"],
		["Selectable"],
		["StoresRecources"],
		["EingangPart",Vector3(0,0,12),Vector3(0,0,-6)]]

var RandomBuildingActor = [
	["City Building 1",
		["ArrayMeshPart","res://Models/HousesV2/Models/citybuilding1.mesh"],
		["FootprintPart", 2, 1, "xx"],
		["ToolTipInfoPart", "Wohnhaus"],
		["Selectable"],
		["ProvidesLivingSpacePart",5],
		["EingangPart",Vector3(1,0,2),Vector3(1,3,0)]],
	["City Building 2",
		["ArrayMeshPart","res://Models/HousesV2/Models/citybuilding2.mesh"],
		["FootprintPart", 2, 1, "xx"],
		["ToolTipInfoPart", "Wohnhaus"],
		["Selectable"],
		["ProvidesLivingSpacePart",5],
		["EingangPart",Vector3(2.718,0,3),Vector3(2.718,2,0)]],
	["City Building 3",
		["ArrayMeshPart","res://Models/HousesV2/Models/citybuilding3.mesh"],
		["FootprintPart", 2, 1, "xx"],
		["ToolTipInfoPart", "Wohnhaus"],
		["Selectable"],
		["ProvidesLivingSpacePart",5],
		["EingangPart",Vector3(2.718,0,3),Vector3(2.718,2,0)]],
	["City Building 4",
		["ArrayMeshPart","res://Models/HousesV2/Models/citybuilding4.mesh"],
		["FootprintPart", 2, 1, "xx"],
		["ToolTipInfoPart", "Wohnhaus"],
		["Selectable"],
		["ProvidesLivingSpacePart",5],
		["EingangPart",Vector3(2.718,0,3),Vector3(2.718,2,0)]],
	["City Building 5",
		["ArrayMeshPart","res://Models/HousesV2/Models/citybuilding5.mesh"],
		["FootprintPart", 2, 1, "xx"],
		["ToolTipInfoPart", "Wohnhaus"],
		["Selectable"],
		["ProvidesLivingSpacePart",5],
		["EingangPart",Vector3(2.718,0,3),Vector3(2.718,2,0)]],
	["City Building 6",
		["ArrayMeshPart","res://Models/HousesV2/Models/citybuilding6.mesh"],
		["FootprintPart", 2, 1, "xx"],
		["ToolTipInfoPart", "Wohnhaus"],
		["Selectable"],
		["ProvidesLivingSpacePart",5],
		["EingangPart",Vector3(2.718,0,3),Vector3(2.718,2,0)]],
	["City Villa 1",
		["ArrayMeshPart","res://Models/HousesV2/Models/cittyvill01.mesh"],
		["FootprintPart", 2, 2, "xxxx"],
		["ToolTipInfoPart", "Stadtvilla"],
		["Selectable"],
		["ProvidesLivingSpacePart",5],
		["EingangPart",Vector3(3,0,4),Vector3(3,3,0)]],
	["City Villa 2",
		["ArrayMeshPart","res://Models/HousesV2/Models/cittyvill02.mesh"],
		["FootprintPart", 2, 2, "xxxx"],
		["ToolTipInfoPart", "Stadtvilla"],
		["Selectable"],
		["ProvidesLivingSpacePart",5],
		["EingangPart",Vector3(1,0,4),Vector3(1,3,0)]]
	]

var BuildingInfos = [
	Rathaus,
	SaegeFabrik,
	Lagerhaus]

func _init():
	for info in RandomBuildingActor:
		BuildingInfos.append(info)
