extends Node

var nextFreeActorID:int = 0

func GetNextFreeActorID() -> int:
	nextFreeActorID += 1
	return nextFreeActorID
#debug

var VillageChunkWorldSize:Vector2 = Vector2(600,600)
var Villages:Dictionary

var standardVillageSize:Vector2 = Vector2(100,100)
var standardCellSize:Vector2 = Vector2(4,4)
var standardRoadPreBuild:int = 20

var game_world:Game_World = null
var cameraAnchor = null
var cursorHandler:Cursor_Handler = null

var player:Dictionary = {}
var LocalPlayer:Player

var rng:RandomNumberGenerator = RandomNumberGenerator.new()
var randomNumber:int

var hostNetwork
var clientNetwork

var stadtVorSilben:Array = [
	"Mar","Meer","Lau","Lang","Lo",
	"Kar","Reh","Ber","Mün","Hint",
	"Less","Hoch","Wupp","Frank","Wald",
	"Salz","Unter","Hinden","Sol","Brand",
	"Gör","Ossen","Wolf","Kir","Varres",
	"Lade","Wart","Oster","Esch","Witt"]
var stadtNachSilben:Array = [
	"stedt","stadt","dorf","burg","stein",
	"heim","statt","litz","lingen","ungen",
	"ohsen","ansen","hein","berg","tal",
	"furt","fluss","ingen","leben","feld",
	"beck","hahn","beck","kamp","kuhle"]
	
var nachnamen:Array = [
	"Färberg", "Beckette", "Blaug", "Bergströms", "Berglunds",
	 "Siegert", "Stein","Forst", "Kühn", "Winkler", "Langer",
	"Herrmann", "Wolf", "Geissler", "Peters", "Weiß", "Riese",
	"Klossner","Schwarz","Braun","Schreier","Berger",
	"Bauer","Schmidt","Schulte","Knopf","Derichs",
	"Horn","Schreiber","Vogt","Dreher","Hofmann",
	"Nagel","Foehrkolb","Wiegand","Spitz","Fischer"
]

var faehigkeiten:Array = [
	"Kraft","Ausdauer",
	"Lesen","Schreiben","Rechnen","Buchhaltung","Organisation",
	"Werkzeuge",
	"Metallverarbeitung","Holzverarbeitung",
]

func _ready():
	var CityPlayer = Player.new()
	CityPlayer.PlayerID = 0
	CityPlayer.PlayerName = "Stadt"
	player[0] = CityPlayer
