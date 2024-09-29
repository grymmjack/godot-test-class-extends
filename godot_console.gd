@icon("res://icon.svg")
class_name GodotConsole
extends Node

var display:AnsiDisplay = AnsiDisplay.new()
var screen_scene:PackedScene = preload("res://godot_console_screen.tscn")

func _init() -> void:
	pass

func _ready() -> void:
	var screen = screen_scene.instantiate()
	add_child(screen)
	print("GODOT CONSOLE READY")
