@tool
@icon("res://icon.svg")
class_name GodotConsole
extends Sprite2D

signal is_ready
signal changed_file
signal tool_paused
signal tool_unpaused

var display:AnsiDisplay = AnsiDisplay.new()
@export_file() var loaded_file:String : set = file_was_changed
var screen_exists:bool = false
var file_loaded:bool = false
var file_changed:bool = false
var screen:GodotConsoleScreen
var screen_scene:PackedScene = preload("res://godot_console_screen.tscn")
var render_scene:PackedScene = preload("res://godot_console_screen_viewport.tscn")
var size:Vector2i = Vector2i.ZERO

# from https://github.com/SelinaDev/Godot-4-ASCII-Grid/blob/0ad3a145f3b296cd474e3619b43ca1128c6a309d/addons/ascii_grid/term_cell.gd#L7
const UNICODE_ASCII := { "": 0, "☺": 1, "☻": 2, "♥": 3, "♦": 4, "♣": 5, "♠": 6, "•": 7, "◘": 8, "○": 9, "◙": 10, "♂": 11, "♀": 12, "♪": 13, "♫": 14, "☼": 15, "►": 16, "◄": 17, "↕": 18, "‼": 19, "¶": 20, "§": 21, "▬": 22, "↨": 23, "↑": 24, "↓": 25, "→": 26, "←": 27, "∟": 28, "↔": 29, "▲": 30, "▼": 31, " ": 32, "!": 33, "\"": 34, "#": 35, "$": 36, "%": 37, "&": 38, "\'": 39, "(": 40, ")": 41, "*": 42, "+": 43, ",": 44, "-": 45, ".": 46, "/": 47, "0": 48, "1": 49, "2": 50, "3": 51, "4": 52, "5": 53, "6": 54, "7": 55, "8": 56, "9": 57, ":": 58, ";": 59, "<": 60, "=": 61, ">": 62, "?": 63, "@": 64, "A": 65, "B": 66, "C": 67, "D": 68, "E": 69, "F": 70, "G": 71, "H": 72, "I": 73, "J": 74, "K": 75, "L": 76, "M": 77, "N": 78, "O": 79, "P": 80, "Q": 81, "R": 82, "S": 83, "T": 84, "U": 85, "V": 86, "W": 87, "X": 88, "Y": 89, "Z": 90, "[": 91, "\\": 92, "]": 93, "^": 94, "_": 95, "`": 96, "a": 97, "b": 98, "c": 99, "d": 100, "e": 101, "f": 102, "g": 103, "h": 104, "i": 105, "j": 106, "k": 107, "l": 108, "m": 109, "n": 110, "o": 111, "p": 112, "q": 113, "r": 114, "s": 115, "t": 116, "u": 117, "v": 118, "w": 119, "x": 120, "y": 121, "z": 122, "{": 123, "|": 124, "}": 125, "~": 126, "⌂": 127, "Ç": 128, "ü": 129, "é": 130, "â": 131, "ä": 132, "à": 133, "å": 134, "ç": 135, "ê": 136, "ë": 137, "è": 138, "ï": 139, "î": 140, "ì": 141, "Ä": 142, "Å": 143, "É": 144, "æ": 145, "Æ": 146, "ô": 147, "ö": 148, "ò": 149, "û": 150, "ù": 151, "ÿ": 152, "Ö": 153, "Ü": 154, "¢": 155, "£": 156, "¥": 157, "₧": 158, "ƒ": 159, "á": 160, "í": 161, "ó": 162, "ú": 163, "ñ": 164, "Ñ": 165, "ª": 166, "º": 167, "¿": 168, "⌐": 169, "¬": 170, "½": 171, "¼": 172, "¡": 173, "«": 174, "»": 175, "░": 176, "▒": 177, "▓": 178, "│": 179, "┤": 180, "╡": 181, "╢": 182, "╖": 183, "╕": 184, "╣": 185, "║": 186, "╗": 187, "╝": 188, "╜": 189, "╛": 190, "┐": 191, "└": 192, "┴": 193, "┬": 194, "├": 195, "─": 196, "┼": 197, "╞": 198, "╟": 199, "╚": 200, "╔": 201, "╩": 202, "╦": 203, "╠": 204, "═": 205, "╬": 206, "╧": 207, "╨": 208, "╤": 209, "╥": 210, "╙": 211, "╘": 212, "╒": 213, "╓": 214, "╫": 215, "╪": 216, "┘": 217, "┌": 218, "█": 219, "▄": 220, "▌": 221, "▐": 222, "▀": 223, "α": 224, "ß": 225, "Γ": 226, "π": 227, "Σ": 228, "σ": 229, "µ": 230, "τ": 231, "Φ": 232, "Θ": 233, "Ω": 234, "δ": 235, "∞": 236, "φ": 237, "ε": 238, "∩": 239, "≡": 240, "±": 241, "≥": 242, "≤": 243, "⌠": 244, "⌡": 245, "÷": 246, "≈": 247, "°": 248, "∙": 249, "·": 250, "√": 251, "ⁿ": 252, "²": 253, "■": 254, " ": 255 }
const ASCII_UNICODE := [ "", "☺", "☻", "♥", "♦", "♣", "♠", "•", "◘", "○", "◙", "♂", "♀", "♪", "♫", "☼", "►", "◄", "↕", "‼", "¶", "§", "▬", "↨", "↑", "↓", "→", "←", "∟", "↔", "▲", "▼", " ", "!", "\"", "#", "$", "%", "&", "\'", "(", ")", "*", "+", ",", "-", ".", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\", "]", "^", "_", "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "{", "|", "}", "~", "⌂", "Ç", "ü", "é", "â", "ä", "à", "å", "ç", "ê", "ë", "è", "ï", "î", "ì", "Ä", "Å", "É", "æ", "Æ", "ô", "ö", "ò", "û", "ù", "ÿ", "Ö", "Ü", "¢", "£", "¥", "₧", "ƒ", "á", "í", "ó", "ú", "ñ", "Ñ", "ª", "º", "¿", "⌐", "¬", "½", "¼", "¡", "«", "»", "░", "▒", "▓", "│", "┤", "╡", "╢", "╖", "╕", "╣", "║", "╗", "╝", "╜", "╛", "┐", "└", "┴", "┬", "├", "─", "┼", "╞", "╟", "╚", "╔", "╩", "╦", "╠", "═", "╬", "╧", "╨", "╤", "╥", "╙", "╘", "╒", "╓", "╫", "╪", "┘", "┌", "█", "▄", "▌", "▐", "▀", "α", "ß", "Γ", "π", "Σ", "σ", "µ", "τ", "Φ", "Θ", "Ω", "δ", "∞", "φ", "ε", "∩", "≡", "±", "≥", "≤", "⌠", "⌡", "÷", "≈", "°", "∙", "·", "√", "ⁿ", "²", "■", " " ]

func _init() -> void:
	pass

func _ready() -> void:
	#print("GODOT CONSOLE READY")
	if loaded_file:
		load_file(loaded_file, true) # force loading regardless first time
	is_ready.emit()
	pause_tool()

func pause_tool() -> void:
	#print_debug("PAUSING TOOL")
	if Engine.is_editor_hint():
		set_process(false)
		set_physics_process(false)
		tool_paused.emit()

func unpause_tool() -> void:
	#print_debug("UNPAUSING TOOL")
	if Engine.is_editor_hint():
		set_process(true)
		tool_unpaused.emit()

func _process(float) -> void:
	if Engine.is_editor_hint():
		if loaded_file and file_loaded == false:
			#printerr("FROM PROCESS Loaded file is %s" % loaded_file)
			#printerr("In Tool and File Loaded!")
			load_file(loaded_file)
		pause_tool()

func file_was_changed(filename:String) -> void:
	loaded_file = filename
	file_changed = true
	load_file(filename, true)

func load_file(filename:String, forced:bool = false) -> void:
	var ext:String = filename.get_extension().to_lower()
	match ext:
		"ans_":
			display_file(filename, forced, true) # render
		"ans":
			display_file(filename, forced)
		# for other cases use ANSI for now (sorta dumb overkill I know. just future-ready)
		_:
			display_file(filename, forced)

func display_file(filename:String, forced:bool = false, render:bool = false) -> void:
	if forced:
		file_changed = true
	if file_changed == false:
		#printerr("DISPLAY FILE file_changed == false")
		return
	# TODO modify scale if aspect_ratio
	if screen_exists:
		for child in self.get_children():
			child.queue_free()
		#printerr("HAS NODE! %s"  % filename.get_file().replace('.', '_'))
	#printerr("DOES NOT HAVE NODE! %s"  % filename.get_file().replace('.', '_'))
	screen = screen_scene.instantiate()
	screen.name = filename.get_file()
	add_child(screen)
	if Engine.is_editor_hint(): # if in tool mode
		if screen.is_inside_tree(): # and screen is in the tree
			if get_tree().edited_scene_root != null:
				#screen.owner = self
				screen.owner = get_tree().edited_scene_root # set the owner for the tool mode
	screen_exists = true
	screen.cls()
	display.load_file(filename, screen)
	size = get_active_tilemap_layer_rect_size()
	changed_file.emit()
	file_loaded = true
	file_changed = false
	if Engine.is_editor_hint(): # if in tool mode
		unpause_tool() # unpause to get an update
	if render:
		var render_temp = render_scene.instantiate()
		print(render_temp)
		add_child(render_temp)
		render_temp.name = "RENDER_TEMP"
		if Engine.is_editor_hint(): # if in tool mode
			if render_temp.is_inside_tree(): # and screen is in the tree
				if get_tree().edited_scene_root != null:
					render_temp.owner = get_tree().edited_scene_root
		duplicate_nodes(screen, render_temp.get_node("DISPLAY"))
		var viewport:SubViewport = render_temp.get_node("DISPLAY")
		printt(viewport)
		viewport.size = size
		printt(viewport.size, size)
		match screen.mode:
			GodotConsoleScreen.SCREEN_MODE.FONT_8x8:
				print("8x8")
				var screen_render = render_temp.get_node("DISPLAY").get_children()[0]
				var bg = screen_render.find_children("BG_8x8", "TileMapLayer", true)
				var fg = screen_render.find_children("FG_8x8", "TileMapLayer", true)
				bg[0].show()
				fg[0].show()
			GodotConsoleScreen.SCREEN_MODE.FONT_8x16:
				print("8x16")
				render_temp.print_tree_pretty()
				printt(render_temp, self, get_parent())
				var screen_render = render_temp.get_node("DISPLAY").get_children()[0]
				var bg = screen_render.find_children("BG_8x16", "", true)
				var fg = screen_render.find_children("FG_8x16", "", true)
				bg[0].show()
				fg[0].show()
			GodotConsoleScreen.SCREEN_MODE.FONT_9x16:
				print("9x16")
				var screen_render = render_temp.get_node("DISPLAY").get_children()[0]
				var bg = screen_render.find_children("BG_9x16", "TileMapLayer", true)
				var fg = screen_render.find_children("FG_9x16", "TileMapLayer", true)
				bg[0].show()
				fg[0].show()
		await RenderingServer.frame_post_draw
		var image:Image = viewport.get_texture().get_image()
		print(image)
		print(image.save_png("res://assets/ANSIs/%s.png" % screen.name))
		render_temp.queue_free()

func duplicate_nodes(source_node, target_node) -> void:
	printt(source_node, target_node)
	# Duplicate the current node
	var duplicated_node = source_node.duplicate()
	# Add the duplicated node to the target node
	target_node.add_child(duplicated_node)
	# Iterate through all children of the source node
	for child in source_node.get_children():
		duplicate_nodes(child, duplicated_node)  # Recursive call for each child

func locate(x:int, y:int):
	position = Vector2(x * scale.x, y * scale.y)

func get_active_tilemap_layer_rect_size() -> Vector2:
	var tilemap_name:String = ""
	match screen.mode:
		screen.SCREEN_MODE.FONT_8x8:
			tilemap_name = "BG_8x8"
		screen.SCREEN_MODE.FONT_8x16:
			tilemap_name = "BG_8x16"
		screen.SCREEN_MODE.FONT_9x16:
			tilemap_name = "BG_9x16"
	var tilemap_layer:TileMapLayer = screen.get_node(tilemap_name) # Adjust node path as necessary
	# Get the tile size
	var tile_size = tilemap_layer.tile_set.tile_size
	tile_size.x *= scale.x
	tile_size.y *= scale.y
	# Get the size of the used area (number of cells)
	var used_area = tilemap_layer.get_used_rect()
	# Calculate the width and height in pixels
	var width = used_area.size.x * tile_size.x
	var height = used_area.size.y * tile_size.y
	#var map_size = used_area.size * tile_size
	#tilemap_layer.position = Vector2(map_size.x * (tilemap_layer.scale.x - 1) / 2, map_size.y * (tilemap_layer.scale.y - 1) / 2)
	#print("Width: ", width, " Height: ", height)
	return Vector2(width, height)

func get_child_scene_rect_size(scene_instance):
	var rect = Rect2()
	for child in scene_instance.get_children():
		if child is Node2D:
			var child_rect = child.get_rect()
			rect = rect.expand(child_rect.position + child_rect.size)
	#print("Width: ", rect.size.x, " Height: ", rect.size.y)

func bytes_to_str8(bytes:PackedByteArray) -> String:
	var result:String = ""
	for i in range(bytes.size()):
		result += String.chr(bytes[i])
	return result

func bytes_to_int(bytes:PackedByteArray) -> int:
	var result:int = 0
	for i in range(bytes.size()):
		result |= (bytes[i] & 0xFF) << (8 * i)
	return result

func packedbyearray_to_string_utf8(_input:PackedByteArray) -> String:
	var ret:String = ""
	for i:int in range(_input.size()):
		if _input[i] != 27:
			ret += ASCII_UNICODE[_input[i]]
		else:
			ret += String.chr(27)
	return ret

func utf8_to_string8(_input:String) -> String:
	var ret:String = ""
	for i:int in range(len(_input)):
		if _input[i] != String.chr(27):
			ret += String.chr(UNICODE_ASCII[_input[i]])
		else:
			ret += String.chr(27)
	return ret
