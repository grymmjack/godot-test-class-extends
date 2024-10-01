extends Node

func _init() -> void:
	print("SCENE: main.tscn")

func _ready() -> void:
	#print(%ansi1.display.ansi.sauce.data.ice_color)
	%ansi1.display.load_file("res://assets/ANSIs/gj-22_dec23.ans")
	#%ansi2.display.load_file("res://assets/ANSIs/gj-17_dec23.ans")
	print_tree_pretty()
