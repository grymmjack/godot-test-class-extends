class_name SauceParser
extends GodotConsoleResource

@export var data:SauceData

func _init() -> void:
	super._init()
	data = SauceData.new()
