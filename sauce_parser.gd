class_name SauceParser
extends GodotConsoleResource

var data:SauceData

func _init() -> void:
	super._init()
	data = SauceData.new()
