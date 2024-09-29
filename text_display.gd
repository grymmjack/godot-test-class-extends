class_name TextDisplay
extends GodotConsoleResource

@export var data:TextData

@export_group("Screen")
@export var columns:int
@export var rows:int
@export_enum("IBM VGA50 (8x8)", "IBM VGA (8x16)", "IBM VGA (9x16)") var font:int

@export_group("Colors")
@export var background_color:int = CGA.BLACK
@export var foreground_color:int = CGA.WHITE

@export_group("Cursor")
@export var cursor_position:Vector2i = Vector2i.ZERO
@export var cursor_visibile:bool = true
@export_enum("UNDERLINE", "SOLID", "BOX") var cursor_shape:int

enum CGA {
	BLACK, RED, GREEN, BROWN, BLUE, MAGENTA, CYAN, WHITE,
	GRAY, B_RED, B_GREEN, B_BROWN, B_BLUE, B_MAGENTA, B_CYAN, B_WHITE
}

enum FONT { FONT_8x8, FONT_8x16, FONT_9x16 }

func _init() -> void:
	super._init()
	data = TextData.new()
