class_name TextDisplay
extends GodotConsoleResource

var data:TextData

var columns:int
var rows:int
var font:int

var background_color:int = CGA.BLACK
var foreground_color:int = CGA.WHITE

var cursor_position:Vector2i = Vector2i.ZERO
var cursor_visibile:bool = true
var cursor_shape:int

enum FONT { FONT_8x8, FONT_8x16, FONT_9x16 }
enum CGA {
	BLACK, RED, GREEN, BROWN, BLUE, MAGENTA, CYAN, WHITE,
	GRAY, B_RED, B_GREEN, B_BROWN, B_BLUE, B_MAGENTA, B_CYAN, B_WHITE
}

func _init() -> void:
	super._init()
	data = TextData.new()
