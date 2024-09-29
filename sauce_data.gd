class_name SauceData
extends GodotConsoleResource

var ice_color:bool
var font_8px:bool
var font_9px:bool
var font_used:String
var aspect_ratio:int

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

var raw_data:PackedByteArray

enum ASPECT_RATIO { LEGACY, SQUARE }

func _init() -> void:
	super._init()
