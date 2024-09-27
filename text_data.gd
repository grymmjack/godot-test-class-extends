class_name TextData
extends GodotConsoleResource

@export var raw_data:PackedByteArray
@export_global_file() var source_file:String
@export var columns:int
@export var rows:int
@export_enum("IBM VGA50 (8x8)", "IBM VGA (8x16)", "IBM VGA (9x16)") var font:int
enum FONT { FONT_8x8, FONT_8x16, FONT_9x16 }

func _init() -> void:
	print("TextData")
