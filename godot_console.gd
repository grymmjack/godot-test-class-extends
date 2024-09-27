@icon("res://icon.svg")
class_name GodotConsole
extends Node

@export var display:AnsiDisplay

func _init() -> void:
	print("SCENE: godot_console.tscn")
	display = AnsiDisplay.new()
	display.load_file("file.ans")
	print(display.ansi.sauce.data.Author)
	print_tree_pretty()
