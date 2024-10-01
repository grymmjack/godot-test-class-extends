class_name SauceData
extends GodotConsoleResource

var ID:String
var Version:String
var Title:String
var Author:String
var Group:String
var Date:String
var FileSize:int
var DataType:String
var FileType:String
var TInfo1:String
var TInfo2:String
var TInfo3:String
var TInfo4:String
var Comments:String
var TFlags:int
var TInfoS:String
var CommentLines: Array = []

var raw_data:PackedByteArray

func _init() -> void:
	super._init()
