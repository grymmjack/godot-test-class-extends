class_name SauceData
extends GodotConsoleResource

@export_group("ANSI Flags")
@export var ice_color:bool
@export var font_8px:bool
@export var font_9px:bool
@export var font_used:String
@export var aspect_ratio:int

@export_group("Sauce Record")
@export var ID:String
@export var Version:String
@export var Title:String
@export var Author:String
@export var Group:String
@export var Date:String
@export var FileSize:int
@export var DataType:String
@export var FileType:String
@export var TInfo1:String
@export var TInfo2:String
@export var TInfo3:String
@export var TInfo4:String
@export var Comments:String
@export var TFlags:int
@export var TInfoS:String

@export var raw_data:PackedByteArray

enum ASPECT_RATIO { LEGACY, SQUARE }

func _init() -> void:
	super._init()
