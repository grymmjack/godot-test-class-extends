class_name TextDisplay
extends GodotConsoleResource

@export var data:TextData

func _init() -> void:
	super._init()
	data = TextData.new()
