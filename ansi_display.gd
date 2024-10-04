class_name AnsiDisplay
extends TextDisplay

var ansi:AnsiParser

func _init() -> void:
	super._init()
	ansi = AnsiParser.new()

func load_file(filename:String, screen:GodotConsoleScreen) -> bool:
	#print("Loading file: '%s'" % filename)
	ansi.load_ansi_file(filename, screen)
	return true
