class_name AnsiParser
extends GodotConsoleResource

var ice_color:bool
var font_8px:bool
var font_9px:bool
var font_used:String
var aspect_ratio:int
enum ASPECT_RATIO { LEGACY, SQUARE }

var sauce:SauceParser

func _init() -> void:
	super._init()
	sauce = SauceParser.new()
