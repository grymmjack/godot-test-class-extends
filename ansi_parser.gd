class_name AnsiParser
extends GodotConsoleResource

var sauce:SauceParser

func _init() -> void:
	super._init()
	sauce = SauceParser.new()
