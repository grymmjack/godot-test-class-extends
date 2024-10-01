@icon("res://icon.svg")
class_name GodotConsoleScreen
extends Node

signal is_scrolling
signal is_printing
signal is_clearing
signal finished_clearing
signal cursor_moving
signal awaiting_input
signal color_changed
signal bg_color_changed
signal fg_color_changed
signal ansi_detected

var columns:int
var rows:int
var font:int
enum SCREEN_MODE { FONT_8x8, FONT_8x16, FONT_9x16 }
@export_enum("8x8", "8x16", "9x16") var screen_mode:int = SCREEN_MODE.FONT_8x16 : set = setup_screen_mode
@export_range(1, 4) var scale:int = 1 : set = setup_screen_mode
@export var blinking_enabled_at_start:bool = false
@export var locked:bool = false
@export var scrollback_size:int = 1000
@export_enum("UNDERLINE", "SOLID", "BOX") var cursor_shape:int
@export_group("TileMapLayers")
@export var background:TileMapLayer
@export var foreground:TileMapLayer

@export var bold:bool = false
@export var blinking:bool = false
@export var inverted:bool = false
@export var ice_color:bool = false
@export var font_9px:bool = false
@export var font_8px:bool = false
@export var utf8_ans:bool = false
@export var font_used:String

var background_color:int = CGA.BLACK
var foreground_color:int = CGA.WHITE

var cursor_position:Vector2i = Vector2i.ZERO
var cursor_visibile:bool = true

enum FONT { FONT_8x8, FONT_8x16, FONT_9x16 }
enum CGA {
	BLACK, RED, GREEN, BROWN, BLUE, MAGENTA, CYAN, WHITE,
	GRAY, B_RED, B_GREEN, B_BROWN, B_BLUE, B_MAGENTA, B_CYAN, B_WHITE
}

var _scrollback_buffer:Array[TextCharV1]

enum VERTICAL_DIRECTION { DOWN, UP }
enum HORIZONTAL_DIRECTION { LEFT, RIGHT }

const FONT_ATLAS_COLS := 32
const FONT_ATLAS_ROWS := 8

const BASE_FONT_TEXTURE_8x8:Texture2D = preload("res://assets/images/DOS-8x8-9x9-SCALED-1x.png")
const BASE_TILESET_8x8:TileSet = preload("res://assets/tilemaps/DOSFont-BASE-8x8.tres")
const BASE_TILE_SIZE_8x8:Vector2i = Vector2i(8, 8)

const BASE_FONT_TEXTURE_8x16:Texture2D = preload("res://assets/images/DOS-8x16-9x17-SCALED-1x.png")
const BASE_TILESET_8x16:TileSet = preload("res://assets/tilemaps/DOSFont-BASE-8x16.tres")
const BASE_TILE_SIZE_8x16:Vector2i = Vector2i(8, 16)

const BASE_FONT_TEXTURE_9x16:Texture2D = preload("res://assets/images/DOS-9x16-9x17-SCALED-1x.png")
const BASE_TILESET_9x16:TileSet = preload("res://assets/tilemaps/DOSFont-BASE-9x16.tres")
const BASE_TILE_SIZE_9x16:Vector2i = Vector2i(9, 16)

const TARGET_PATH:String = "res://assets/tilemaps"
const BG_ATLAS_ID := 0
const FG_ATLAS_ID := 0
const BG_BLINKING_ATLAS_ID := 1
const FG_BLINKING_ATLAS_ID := 1

# from https://github.com/SelinaDev/Godot-4-ASCII-Grid/blob/0ad3a145f3b296cd474e3619b43ca1128c6a309d/addons/ascii_grid/term_cell.gd#L7
const UNICODE_ASCII := { "": 0, "☺": 1, "☻": 2, "♥": 3, "♦": 4, "♣": 5, "♠": 6, "•": 7, "◘": 8, "○": 9, "◙": 10, "♂": 11, "♀": 12, "♪": 13, "♫": 14, "☼": 15, "►": 16, "◄": 17, "↕": 18, "‼": 19, "¶": 20, "§": 21, "▬": 22, "↨": 23, "↑": 24, "↓": 25, "→": 26, "←": 27, "∟": 28, "↔": 29, "▲": 30, "▼": 31, " ": 32, "!": 33, "\"": 34, "#": 35, "$": 36, "%": 37, "&": 38, "\'": 39, "(": 40, ")": 41, "*": 42, "+": 43, ",": 44, "-": 45, ".": 46, "/": 47, "0": 48, "1": 49, "2": 50, "3": 51, "4": 52, "5": 53, "6": 54, "7": 55, "8": 56, "9": 57, ":": 58, ";": 59, "<": 60, "=": 61, ">": 62, "?": 63, "@": 64, "A": 65, "B": 66, "C": 67, "D": 68, "E": 69, "F": 70, "G": 71, "H": 72, "I": 73, "J": 74, "K": 75, "L": 76, "M": 77, "N": 78, "O": 79, "P": 80, "Q": 81, "R": 82, "S": 83, "T": 84, "U": 85, "V": 86, "W": 87, "X": 88, "Y": 89, "Z": 90, "[": 91, "\\": 92, "]": 93, "^": 94, "_": 95, "`": 96, "a": 97, "b": 98, "c": 99, "d": 100, "e": 101, "f": 102, "g": 103, "h": 104, "i": 105, "j": 106, "k": 107, "l": 108, "m": 109, "n": 110, "o": 111, "p": 112, "q": 113, "r": 114, "s": 115, "t": 116, "u": 117, "v": 118, "w": 119, "x": 120, "y": 121, "z": 122, "{": 123, "|": 124, "}": 125, "~": 126, "⌂": 127, "Ç": 128, "ü": 129, "é": 130, "â": 131, "ä": 132, "à": 133, "å": 134, "ç": 135, "ê": 136, "ë": 137, "è": 138, "ï": 139, "î": 140, "ì": 141, "Ä": 142, "Å": 143, "É": 144, "æ": 145, "Æ": 146, "ô": 147, "ö": 148, "ò": 149, "û": 150, "ù": 151, "ÿ": 152, "Ö": 153, "Ü": 154, "¢": 155, "£": 156, "¥": 157, "₧": 158, "ƒ": 159, "á": 160, "í": 161, "ó": 162, "ú": 163, "ñ": 164, "Ñ": 165, "ª": 166, "º": 167, "¿": 168, "⌐": 169, "¬": 170, "½": 171, "¼": 172, "¡": 173, "«": 174, "»": 175, "░": 176, "▒": 177, "▓": 178, "│": 179, "┤": 180, "╡": 181, "╢": 182, "╖": 183, "╕": 184, "╣": 185, "║": 186, "╗": 187, "╝": 188, "╜": 189, "╛": 190, "┐": 191, "└": 192, "┴": 193, "┬": 194, "├": 195, "─": 196, "┼": 197, "╞": 198, "╟": 199, "╚": 200, "╔": 201, "╩": 202, "╦": 203, "╠": 204, "═": 205, "╬": 206, "╧": 207, "╨": 208, "╤": 209, "╥": 210, "╙": 211, "╘": 212, "╒": 213, "╓": 214, "╫": 215, "╪": 216, "┘": 217, "┌": 218, "█": 219, "▄": 220, "▌": 221, "▐": 222, "▀": 223, "α": 224, "ß": 225, "Γ": 226, "π": 227, "Σ": 228, "σ": 229, "µ": 230, "τ": 231, "Φ": 232, "Θ": 233, "Ω": 234, "δ": 235, "∞": 236, "φ": 237, "ε": 238, "∩": 239, "≡": 240, "±": 241, "≥": 242, "≤": 243, "⌠": 244, "⌡": 245, "÷": 246, "≈": 247, "°": 248, "∙": 249, "·": 250, "√": 251, "ⁿ": 252, "²": 253, "■": 254, " ": 255 }
const ASCII_UNICODE := [ "", "☺", "☻", "♥", "♦", "♣", "♠", "•", "◘", "○", "◙", "♂", "♀", "♪", "♫", "☼", "►", "◄", "↕", "‼", "¶", "§", "▬", "↨", "↑", "↓", "→", "←", "∟", "↔", "▲", "▼", " ", "!", "\"", "#", "$", "%", "&", "\'", "(", ")", "*", "+", ",", "-", ".", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\", "]", "^", "_", "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "{", "|", "}", "~", "⌂", "Ç", "ü", "é", "â", "ä", "à", "å", "ç", "ê", "ë", "è", "ï", "î", "ì", "Ä", "Å", "É", "æ", "Æ", "ô", "ö", "ò", "û", "ù", "ÿ", "Ö", "Ü", "¢", "£", "¥", "₧", "ƒ", "á", "í", "ó", "ú", "ñ", "Ñ", "ª", "º", "¿", "⌐", "¬", "½", "¼", "¡", "«", "»", "░", "▒", "▓", "│", "┤", "╡", "╢", "╖", "╕", "╣", "║", "╗", "╝", "╜", "╛", "┐", "└", "┴", "┬", "├", "─", "┼", "╞", "╟", "╚", "╔", "╩", "╦", "╠", "═", "╬", "╧", "╨", "╤", "╥", "╙", "╘", "╒", "╓", "╫", "╪", "┘", "┌", "█", "▄", "▌", "▐", "▀", "α", "ß", "Γ", "π", "Σ", "σ", "µ", "τ", "Φ", "Θ", "Ω", "δ", "∞", "φ", "ε", "∩", "≡", "±", "≥", "≤", "⌠", "⌡", "÷", "≈", "°", "∙", "·", "√", "ⁿ", "²", "■", " " ]

const CGA_PALETTE := [
	Color(0, 0, 0),			# BLACK
	Color(170, 0, 0),		# RED
	Color(0, 170, 0),		# GREEN
	Color(170, 85, 0),		# BROWN
	Color(0, 0, 170),		# BLUE
	Color(170, 0, 170),		# MAGENTA
	Color(0, 170, 170),		# CYAN
	Color(170, 170, 170),	# WHITE
	Color(85, 85, 85),		# GRAY
	Color(255, 85, 85),		# BRIGHT RED
	Color(85, 255, 85),		# BRIGHT GREEN
	Color(255, 255, 85),	# BRIGHT BROWN
	Color(85, 85, 255),		# BRIGHT BLUE
	Color(255, 85, 255),	# BRIGHT MAGENTA
	Color(85, 255, 255),	# BRIGHT CYAN
	Color(255, 255, 255)	# BRIGHT WHITE
]

func _init() -> void:
	print("SCENE: godot_console_screen.tscn")

func _ready() -> void:
	print("SCREEN READY")

func setup_screen_mode(mode:int) -> void:
	screen_mode = mode
	if !is_inside_tree():
		return
	%BG_8x8.hide()
	%BG_8x16.hide()
	%BG_9x16.hide()
	%FG_8x8.hide()
	%FG_8x16.hide()
	%FG_9x16.hide()
	match mode:
		SCREEN_MODE.FONT_8x8:
			%BG_8x8.show()
			%FG_8x8.show()
		SCREEN_MODE.FONT_8x16:
			%BG_8x16.show()
			%FG_8x16.show()
		SCREEN_MODE.FONT_9x16:
			%BG_9x16.show()
			%FG_9x16.show()

# clear screen
func cls() -> void:
	is_clearing.emit()
	for y in range(rows):
		for x in range(columns):
			bg(Vector2i(x, y), background_color)
	_set_cursor_position(Vector2i(0, 0))
	finished_clearing.emit()

# set foreground and background text colors
func color(fg_color:int, bg_color:int) -> void:
	color_changed.emit(fg_color, bg_color, blinking)
	foreground_color = fg_color
	background_color = bg_color

# set cursor position
func locate(x:int, y:int) -> void:
	_set_cursor_position(Vector2i(x, y))

func locate_center(msg:String, row:int = -1) -> void:
	if row >= 0:
		@warning_ignore("integer_division")
		locate(int((columns - len(msg)) / 2), row)
	else:
		@warning_ignore("integer_division")
		locate(int((columns - len(msg)) / 2), cursor_position.y)

@warning_ignore("unused_parameter")
func locate_left(msg:String, row:int = -1) -> void:
	if row >= 0:
		locate(0, row)
	else:
		locate(0, cursor_position.y)

func locate_right(msg:String, row:int = -1) -> void:
	if row >= 0:
		locate(columns - len(msg), row)
	else:
		locate(columns - len(msg), cursor_position.y)

# get cursor x position (column)
func pos(type:int = 0) -> int:
	match type:
		0:
			return cursor_position.x
		_:
			return cursor_position.x

# get cusor y position (row)
func csrlin() -> int:
	return cursor_position.y

# echo a string print using current colors
func echo(_str:String) -> void:
	is_printing.emit(_str)
	for i in len(_str):
		var cha:String = _str[i]
		var tile:Vector2i = cha_to_atlas_coord(cha)
		bg(Vector2i(cursor_position.x, cursor_position.y), background_color)
		fg(Vector2i(cursor_position.x, cursor_position.y), foreground_color, tile, blinking)
		var new_x:int = cursor_position.x + 1
		var new_y:int = cursor_position.y
		locate(new_x, new_y)

# echo a string (synonymous with print, but prints in colors)
func cecho(_str:String, fg_color:int, bg_color:int) -> void:
	is_printing.emit(_str)
	for i in len(_str):
		var cha:String = _str[i]
		var tile:Vector2i = cha_to_atlas_coord(cha)
		bg(Vector2i(cursor_position.x, cursor_position.y), bg_color)
		fg(Vector2i(cursor_position.x, cursor_position.y), fg_color, tile, blinking)
		var new_x:int = cursor_position.x + 1
		var new_y:int = cursor_position.y
		locate(new_x, new_y)

# set background color using %BG tilemap layer
func bg(_position:Vector2i, _color:int) -> void:
	color_changed.emit()
	bg_color_changed.emit()
	#var source_id:int
	#if blinking:
		#source_id = 1
	#else:
	var source_id:int = 0
	%BG_8x8.set_cell(_position, source_id, Vector2i(_color, 0))
	%BG_8x16.set_cell(_position, source_id, Vector2i(_color, 0))
	%BG_9x16.set_cell(_position, source_id, Vector2i(_color, 0))

# set a foreground colored cell using %FG tilemap layer
func fg(_position:Vector2i, _color:int, _tile:Vector2i, _blinking:bool = false) -> void:
	color_changed.emit()
	fg_color_changed.emit()
	var alternative_tile:int
	var source_id:int
	if _blinking and blinking_enabled_at_start and not ice_color:
		alternative_tile = _color + CGA_PALETTE.size()
		source_id = FG_BLINKING_ATLAS_ID
	else:
		alternative_tile = _color + CGA_PALETTE.size()
		source_id = FG_ATLAS_ID
	%FG_8x8.set_cell(_position, source_id, _tile, alternative_tile)
	%FG_8x16.set_cell(_position, source_id, _tile, alternative_tile)
	%FG_9x16.set_cell(_position, source_id, _tile, alternative_tile)

# map character to font atlas
func cha_to_atlas_coord(cha:String) -> Vector2i:
	var cha_ord:int = ASCII_UNICODE.find(cha) if cha in ASCII_UNICODE else cha.unicode_at(0)
	if cha_ord == 27:
		ansi_detected.emit()
	@warning_ignore("integer_division")
	var y:int = int(cha_ord / FONT_ATLAS_COLS)
	var x:int
	if blinking and blinking_enabled_at_start and not ice_color:
		x = int(cha_ord % FONT_ATLAS_COLS) * 2
	else:
		x = int(cha_ord % FONT_ATLAS_COLS)
	return Vector2i(x, y)

# screen wrap update
func screen_wrap() -> void:
	if cursor_position.y >= rows:
		cursor_position.y = rows
		screen_scroll_down()
	if cursor_position.x >= columns:
		cursor_position.y += 1
		cursor_position.x = 0

func _set_cursor_position(_position:Vector2i) -> void:
	cursor_moving.emit(_position, cursor_position)
	cursor_position = _position
	screen_wrap()

# TODO
func screen_scroll_down() -> void:
	is_scrolling.emit(VERTICAL_DIRECTION.DOWN)
	# move top row into memory
	# move top row+1 to top row-1 for entire tile row
	# loop until at row height

# TODO
func screen_scroll_up() -> void:
	is_scrolling.emit(VERTICAL_DIRECTION.UP)

# TODO
func input(prompt:String) -> String:
	awaiting_input.emit()
	return ""

# TODO
func inkey() -> String:
	awaiting_input.emit()
	#var keypress:Key
	#while keypress == null:
		#print("waiting")
	return ""

func _unhandled_key_input(event: InputEvent) -> void:
	#print(event.as_text())
	pass


# Create colored tile alternates
# thank you to Selina - https://github.com/SelinaDev/
func create_colored_tiles(colors, base_tileset:TileSet, font_name:String, palette_name:String, blink_speed:float=0.33) -> void:
	var tileset:TileSet = base_tileset.duplicate(true)
	var tileset_source:TileSetAtlasSource = tileset.get_source(0)
	var blinking_tileset_source:TileSetAtlasSource = tileset.get_source(1)
	var grid_size:Vector2i = tileset_source.get_atlas_grid_size()
	var total_colors:int = colors.size()
	for c:int in range(0, total_colors):
		tileset.resource_name = font_name
		tileset_source.resource_name = palette_name
		var _color:Color = colors[c]
		print(colors[c])
		for y:int in range(grid_size.y):
			for x:int in range(grid_size.x):
				var id:int = tileset_source.create_alternative_tile(Vector2i(x, y), c + total_colors)
				var colored_tile_data:TileData = tileset_source.get_tile_data(Vector2i(x, y), id)
				colored_tile_data.modulate.r8 = colors[c].r
				colored_tile_data.modulate.g8 = colors[c].g
				colored_tile_data.modulate.b8 = colors[c].b
		for y:int in range(grid_size.y):
			for x:int in range(0, grid_size.x*2, 2):
				var id:int = blinking_tileset_source.create_alternative_tile(Vector2i(x, y), c + total_colors)
				var colored_tile_data:TileData = blinking_tileset_source.get_tile_data(Vector2i(x, y), id)
				blinking_tileset_source.set_tile_animation_frame_duration(Vector2i(x, y), 0, blink_speed)
				blinking_tileset_source.set_tile_animation_frame_duration(Vector2i(x, y), 1, blink_speed)
				colored_tile_data.modulate.r8 = colors[c].r
				colored_tile_data.modulate.g8 = colors[c].g
				colored_tile_data.modulate.b8 = colors[c].b
		print("Created alternative tileset for COLOR %d" % [ c ])
	var filename:String =  TARGET_PATH + "/DOSFont-%s-%s.tres" % [ palette_name, font_name ]
	ResourceSaver.save(tileset, filename)
	print("Created %s" % filename)
