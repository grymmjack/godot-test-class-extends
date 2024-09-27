class_name AnsiDisplay
extends TextDisplay

@export_storage var ansi_parser:AnsiParser

func _init() -> void:
	super._init()
	print("AnsiDisplay")
	ansi_parser = AnsiParser.new()
