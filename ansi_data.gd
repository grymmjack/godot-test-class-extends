class_name AnsiData
extends TextData

@export_storage var ice_color:bool
@export_storage var font_8px:bool
@export_storage var font_9px:bool
@export_storage var font_used:String
@export_storage var aspect_ratio:int

enum ASPECT_RATIO { LEGACY, SQUARE }

func _init() -> void:
	print("AnsiData")
	super._init()
