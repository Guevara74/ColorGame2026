extends Node


enum Area_Type {BASEMENT, OUTSIDE}

var areaDict = {
	Area_Type.BASEMENT: "res://main.tscn",
	Area_Type.OUTSIDE: "res://Temp_Outside.tscn"
}

var lastArea = Area_Type


func change_area(currentArea: Area_Type):
	lastArea = currentArea
