extends Node

@onready var CONSOLE1:GodotConsole = $CONSOLE1
@onready var CONSOLE2:GodotConsole = $CONSOLE2

func _init() -> void:
	print("SCENE: main.tscn")

func _ready() -> void:
	var console:GodotConsole
	console = GodotConsole.new()
	console.display.load_file("res://assets/ANSIs/gj-22_dec23.ans", CONSOLE1)
	print(console.display.ansi.sauce.data.Author)
	print_tree_pretty()
