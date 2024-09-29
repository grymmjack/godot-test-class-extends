class_name AnsiParser
extends GodotConsoleResource

@export var sauce:SauceParser

func _init() -> void:
	super._init()
	sauce = SauceParser.new()
