class_name SauceData
extends GodotConsoleResource

@export_storage var raw_data:PackedByteArray

@export_storage var ID:String
@export_storage var Version:String
@export_storage var Title:String
@export_storage var Author:String
@export_storage var Group:String
@export_storage var Date:String
@export_storage var FileSize:int
@export_storage var DataType:String
@export_storage var FileType:String
@export_storage var TInfo1:String
@export_storage var TInfo2:String
@export_storage var TInfo3:String
@export_storage var TInfo4:String
@export_storage var Comments:String
@export_storage var TFlags:int
@export_storage var TInfoS:String

func _init() -> void:
	super._init()
