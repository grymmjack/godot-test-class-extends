class_name SauceParser
extends GodotConsoleResource

@export var sauce_data:SauceData

func _init() -> void:
	print("SauceParser")
	sauce_data = SauceData.new()
