@icon("res://icon.svg")
class_name GodotConsoleScreen
extends Node

func _init() -> void:
	print("SCENE: godot_console_screen.tscn")
	print_tree_pretty()
