class_name GodotConsole
extends Node

@export var ansi_display:AnsiDisplay

func _init() -> void:
	print("SCENE: godot_console.tscn")
	ansi_display = AnsiDisplay.new()
