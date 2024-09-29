@icon("res://icon.svg")
class_name GodotConsole
extends Node

@export var display:AnsiDisplay

func _init() -> void:
	display = AnsiDisplay.new()
