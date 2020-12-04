extends Node

var PossibleTraits = ["Waldgebiet","Berggebiet"]

var UniversalProduktion = {
	"Fischfang":
		[
			["GeneratesRecources","Fisch",1,2500],
			["ProvidesWorkingSpace","Angeln",1,["Angeln"]],
		],
	"Feldwirtschaft":
		[
			["GeneratesRecources","Weizen",1,2500],
			["ProvidesWorkingSpace","Anbauen",1,["Anbau"]],
		],
	"Viehzucht":
		[
			["GeneratesRecources","Milch",1,2500],
			["GeneratesRecources","Rinder",1,25000],
			["GeneratesRecources","Schafe",1,19500],
			["GeneratesRecources","Schweine",1,15000],
			["GeneratesRecources","Fleisch",1,3800],
			["ProvidesWorkingSpace","Viehzucht",4,["Viehzucht"]],
		],
	"Pferdezucht":
		[
			["GeneratesRecources","Pferde",1,22500],
			["ProvidesWorkingSpace","Pferdezucht",4,["Viehzucht"]],
		],
	}


var Traits = {
	"Waldgebiet":
		{
			"Holzfäller":
				[
					["GeneratesRecources","Roh Holz",1,4000],
					["ProvidesWorkingSpace","Fällen",3,["Forstwirtschaft"]],
					["ProvidesWorkingSpace","Aufforsten",1,["Forstwirtschaft"],300],
				],
			"Jäger":
				[
					["GeneratesRecources","Fleisch",2,3500],
					["GeneratesRecources","Felle",1,3500],
					["ProvidesWorkingSpace","Jagen",2,["Bogenschießen"]],
					["ProvidesWorkingSpace","Gerben",2,["Werkzeuge"]]
				],
			"Sammler":
				[
					["GeneratesRecources","Pilze",4,2500],
					["ProvidesWorkingSpace","Sammeln",4,["Aufmerksamkeit"]]
				],
			"Pelzhersteller":
				[
					["GeneratesRecources","Kleidung",1,3500],
					["ProvidesWorkingSpace","Nähen",1,["Handwerk","Werkzeuge"]]
				],
			"Sägewerk":
				[
					["GeneratesRecources","Bauholz",4,4000],
					["ProvidesWorkingSpace","Sägen",2,["Handwerk","Werkzeuge"]],
				],
		},
		"Berggebiet":
		{
			"Steinbruch":
				[
					["GeneratesRecources","Bruchstein",1,4000],
					["ProvidesWorkingSpace","Abbau",4,["Handwerk"]],
				],
			"Steinmetz":
				[
					["GeneratesRecources","Stein",2,3500],
					["GeneratesRecources","Kalk",1,3500],
					["ProvidesWorkingSpace","Meißeln",4,["Handwerk"]],
				],
			"Mine":
				[
					["GeneratesRecources","Eisenerz",1,6000],
					["GeneratesRecources","Bauxiterz",1,5000],
					["ProvidesWorkingSpace","Abbau",4,["Handwerk"]],
				],
			"Verhütten":
				[
					["GeneratesRecources","Eisen",1,6000],
					["GeneratesRecources","Kupfer",2,5000],
					["ProvidesWorkingSpace","Verhütten",6,["Handwerk","Verhütten"]],
				],
			"Werkstatt":
				[
					["GeneratesRecources","Werkzeuge",2,4000],
					["ProvidesWorkingSpace","Schmieden",2,["Herstellen","Schmied"]],
				],
		}
}
