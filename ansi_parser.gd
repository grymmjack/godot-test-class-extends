class_name AnsiParser
extends GodotConsoleResource

@export_storage var data:AnsiData
@export_storage var sauce:SauceParser

func _init() -> void:
	super._init()
	data = AnsiData.new()
	sauce = SauceParser.new()
