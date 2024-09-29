class_name AnsiDisplay
extends TextDisplay

@export var ansi:AnsiParser

func _init() -> void:
	super._init()
	ansi = AnsiParser.new()

func load_file(filename:String, console:GodotConsole) -> bool:
	print("Loading file: '%s'" % filename)
	return true
