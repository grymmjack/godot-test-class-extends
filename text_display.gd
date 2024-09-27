class_name TextDisplay
extends GodotConsoleResource

@export var text_data:TextData

func _init() -> void:
	print("TextDisplay")
	text_data = TextData.new()
