class_name AnsiParser
extends GodotConsoleResource

@export_storage var ansi_data:AnsiData
@export_storage var sauce_parser:SauceParser

func _init() -> void:
	print("AnsiParser")
	ansi_data = AnsiData.new()
	sauce_parser = SauceParser.new()
