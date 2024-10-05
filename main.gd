@tool
extends Sprite2D

func _init() -> void:
	pass
	#print("SCENE: main.tscn")

func _ready() -> void:
	#print(%ansi1.display.ansi.sauce.data.ice_color)
	%ansi1.load_file("res://assets/ANSIs/gj-22_dec23.ans")

	%ansi1.screen.mode = %ansi1.screen.SCREEN_MODE.FONT_9x16
	%ansi1.scale = Vector2(0.5, 0.5)

	%ansi2.load_file("res://assets/ANSIs/US-CAT.ans")
	%ansi2.screen.mode = %ansi2.screen.SCREEN_MODE.FONT_8x8
	%ansi2.scale = Vector2(0.5, 0.5)
	%ansi2.locate(%ansi1.size.x + 800, 0)

	%ansi3.load_file("res://assets/ANSIs/gj-cgagris.ans")
	#%ansi3.scale = Vector2(0.5, 0.5)
	%ansi3.locate(0, %ansi1.position.y + %ansi1.size.y)

	%ansi4.load_file("res://assets/ANSIs/gj-dwimmer.ans")
	#%ansi4.scale = Vector2(0.5, 0.5)
	%ansi4.locate(350, %ansi3.position.y + %ansi3.size.y)

	%ansi5.load_file("res://assets/ANSIs/gj-test1.ans")
	%ansi5.screen.mode = %ansi5.screen.SCREEN_MODE.FONT_9x16
	%ansi5.scale = Vector2(1.5, 1.5)
	%ansi5.locate(0, %ansi4.position.y)

	%ansi6.load_file("res://assets/ANSIs/akbar.png-25-moebius.ans")
	%ansi6.scale = Vector2(0.5, 0.5)
	%ansi6.locate(0, %ansi5.position.y + %ansi5.size.y)

	#%ansi7.load_file("res://assets/ANSIs/bacsi-img2pal.png-25-OPT.ans")
	##%ansi7.scale = Vector2(0.5, 0.5)
	#%ansi7.locate(1200, 0)

	# TODO fix scale offset from center to top left corner
	%ansi8.load_file("res://assets/ANSIs/gj-antonio.ans")
	#%ansi8.scale = Vector2(0.5, 0.5)
	%ansi8.locate(1600, %ansi6.position.y + %ansi6.size.y + 100)

	#print_tree_pretty()
