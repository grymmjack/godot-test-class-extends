class_name SauceData
extends GodotConsoleResource

var ID:String
var Version:String
var Title:String
var Author:String
var Group:String
var Date:String
var FileSize:int
var DataType:int
var FileType:int
var TInfo1:int
var TInfo2:int
var TInfo3:int
var TInfo4:int
var Comments:int
var TFlags:int
var TInfoS:String
var CommentLines: Array = []

var raw_data:PackedByteArray

func _init() -> void:
	super._init()
