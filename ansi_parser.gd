class_name AnsiParser
extends GodotConsoleResource

var ice_color:bool
var font_8px:bool
var font_9px:bool
var font_used:String
var aspect_ratio:int
enum ASPECT_RATIO { LEGACY, SQUARE }

var sauce:SauceParser

func _init() -> void:
	super._init()
	sauce = SauceParser.new()

var ansi_width:int = 0
var ansi_height:int = 0

func parse(data:PackedByteArray, screen:GodotConsoleScreen) -> void:
	# Process data
	var data_length:int = data.size()
	var i:int = 0
	while i < data_length:
		var char_code:int = data[i]
		i += 1

		if char_code == 27:  # ESC character
			if i >= data_length:
				break  # End of data
			var next_char:int = data[i]
			i += 1
			if next_char == "[".unicode_at(0):
				# Start of CSI sequence
				var ansi_sequence:String = ""
				# Read characters until we find a letter between '@' (64) and '~' (126)
				while i < data_length:
					var c:int = data[i]
					i += 1
					ansi_sequence += String.chr(c)
					if c >= 64 and c <= 126:
						# Found the final character
						break
				# Now process the ansi_sequence
				process_ansi_sequence(ansi_sequence, screen)
		else:
			if char_code == 10:  # LF (Line Feed)
				screen._set_cursor_position(Vector2i(0, screen.cursor_position.y+1))
			elif char_code == 13:  # CR (Carriage Return)
				screen._set_cursor_position(Vector2i(0, screen.cursor_position.y))
			else:
				# Draw character
				#if !utf8_ans:
					#screen.echo(screen.ASCII_UNICODE[char_code])
				#else:
				screen.echo(String.chr(screen.ASCII_UNICODE.find(char_code)))

func process_ansi_sequence(seq:String, screen:GodotConsoleScreen) -> void:
	if seq == '':
		return
	var final_char:String = seq[seq.length() - 1]
	var params_str:String = seq.substr(0, seq.length() - 1)
	var params = []
	if params_str != '':
		params = params_str.split(';')
	else:
		params = ['0']  # Default parameter

	# Convert parameters to integers
	var params_int:Array[int] = []
	for p:String in params:
		if p == '':
			p = '0'
		var n:int = int(p)
		params_int.append(n)

	# Now handle the command based on final_char
	match final_char:
		'm': # SGR - Select Graphic Rendition
			process_sgr(params_int, screen)
		'H', 'f': # Cursor position
			process_cursor_position(params_int, screen)
		'A': # Cursor up
			cursor_up(params_int, screen)
		'B': # Cursor down
			cursor_down(params_int, screen)
		'C': # Cursor forward
			cursor_right(params_int, screen)
		'D': # Cursor backward
			cursor_left(params_int, screen)
		's': # TODO Save cursor position - not yet supported
			#save_cursor_position()
			pass
		'u': # TODO Restore cursor position - not yet supported
			#restore_cursor_position()
			pass
		# Add other commands as needed
		_:
			# Unhandled command
			pass

func process_sgr(params:Array[int], screen:GodotConsoleScreen) -> void:
	if params.size() == 0:
		params = [0]
	for p:int in params:
		match p:
			0: # Reset all attributes
				screen.foreground_color = screen.CGA.WHITE  # Default foreground
				screen.background_color = screen.CGA.BLACK  # Default background
				screen.bold = false
				screen.blinking = false
				screen.inverted = false
			1: # Bold on (bright foreground)
				screen.bold = true
				if screen.foreground_color < 8:
					screen.foreground_color += 8
			2,22: # Enable low intensity, disable high intensity
				screen.bold = false
				if screen.foreground_color > 7:
					screen.foreground_color -= 8
			5,6: # Blink on
				screen.blinking = true
				if screen.ice_color:
					if screen.background_color < 8:
						screen.background_color += 8
			7: # Reverse video on
				if !screen.inverted:
					screen.inverted = true
			25: # Blink off
				screen.blinking = false
				if screen.background_color > 7:
					screen.background_color -= 8
			27: # Reverse video off
				if screen.inverted:
					screen.inverted = false
			30,31,32,33,34,35,36,37: # Set foreground color
				screen.foreground_color = p - 30
				if screen.bold:
					screen.foreground_color += 8
			38: # TODO 256 color foreground - not yet supported
				# foreground_color = params[2]
				pass
			39: # Set default foreground color
				screen.foreground_color = screen.CGA.WHITE
			40,41,42,43,44,45,46,47: # Set background color
				screen.background_color = p - 40
				if screen.blinking and screen.ice_color:
					screen.background_color += 8
			48: # TODO 256 color background - not yet supported
				# background_color = params[2]
				pass
			49: # Set default background color
				screen.background_color = screen.CGA.BLACK
			90,91,92,93,94,95,96,97: # Set high intensity foreground color
				screen.foreground_color = p - 90 + 8
			100,101,102,103,104,105,106,107: # Set high intensity background color
				screen.background_color = p - 90 + 8
			_:
				# Unhandled SGR code
				pass

# Cursor movement functions
func process_cursor_position(params, screen:GodotConsoleScreen) -> void:
	var row = 1
	var col = 1
	if params.size() >= 1 and params[0]:
		row = params[0]
	if params.size() >= 2 and params[1]:
		col = params[1]
	screen.locate(col, row)

func cursor_home(params:Array, screen:GodotConsoleScreen) -> void:
	var row = int(params[0]) - 1 if (params.size() > 0) else 0
	var col = int(params[1]) - 1 if (params.size() > 1) else 0
	screen.set_cursor_position(Vector2i(col, row))

func cursor_up(params:Array, screen:GodotConsoleScreen) -> void:
	var count = int(params[0]) if (params.size() > 0) else 1
	screen.move_cursor(Vector2i(0, -count))

func cursor_down(params:Array, screen:GodotConsoleScreen) -> void:
	var count = int(params[0]) if (params.size() > 0) else 1
	screen.move_cursor(Vector2i(0, count))

func cursor_right(params:Array, screen:GodotConsoleScreen) -> void:
	var count = int(params[0]) if (params.size() > 0) else 1
	screen.move_cursor(Vector2i(count, 0))

func cursor_left(params:Array, screen:GodotConsoleScreen) -> void:
	var count = int(params[0]) if (params.size() > 0) else 1
	screen.move_cursor(Vector2i(-count, 0))

@warning_ignore("unused_parameter")
func cursor_col0_down(params:Array, screen:GodotConsoleScreen) -> void:
	screen.cursor_position.x = 0
	screen.move_cursor(Vector2i(0, 1))

@warning_ignore("unused_parameter")
func cursor_col0_up(params:Array, screen:GodotConsoleScreen) -> void:
	screen.cursor_position.x = 0
	screen.move_cursor(Vector2i(0, -1))

func cursor_move_col(params:Array, screen:GodotConsoleScreen) -> void:
	if params.size() > 0:
		var col = int(params[0]) - 1  # Convert to 0-based index
		screen.set_cursor_position(Vector2i(col, screen.cursor_position.y))

func erase_screen(params:Array, screen:GodotConsoleScreen) -> void:
	if params.size() > 0 and params[0] == "2":
		screen.cls()

func erase_line(params:Array, screen:GodotConsoleScreen) -> void:
	if params.size() > 0 and params[0] == "2":
		screen.clear_line(screen.cursor_position.y)

func clear_line(line_index:int, screen:GodotConsoleScreen) -> void:
	for x in range(screen.columns):
		screen.bg(Vector2i(x, line_index), screen.background_color)
		screen.fg(Vector2i(x, line_index), screen.foreground_color, screen.cha_to_atlas_coord(" "), screen.blinking)

func reset_styles(screen:GodotConsoleScreen) -> void:
	screen.reset_colors(screen)

func reset_colors(screen:GodotConsoleScreen) -> void:
	screen.foreground_color = screen.CGA.WHITE
	screen.background_color = screen.CGA.BLACK

func move_cursor(delta: Vector2i, screen:GodotConsoleScreen) -> void:
	screen.cursor_position += delta
	screen.screen_wrap()

func set_cursor_position(_pos:Vector2i, screen:GodotConsoleScreen) -> void:
	screen.cursor_position = _pos
	screen.screen_wrap()

func get_cursor_position(screen:GodotConsoleScreen) -> Vector2i:
	return screen.cursor_position

@warning_ignore("unused_parameter")
func set_bold(enabled: bool, screen:GodotConsoleScreen) -> void:
	pass

@warning_ignore("unused_parameter")
func set_dimmed(enabled: bool, screen:GodotConsoleScreen) -> void:
	pass

@warning_ignore("unused_parameter")
func set_italic(enabled: bool, screen:GodotConsoleScreen) -> void:
	pass

@warning_ignore("unused_parameter")
func set_underline(enabled: bool, screen:GodotConsoleScreen) -> void:
	pass

func swap_colors(screen:GodotConsoleScreen) -> void:
	var temp = screen.foreground_color
	screen.foreground_color = screen.background_color
	screen.background_color = temp

func load_ansi_file(file_path:String, screen:GodotConsoleScreen, resize_display:bool = true, change_font:bool = true) -> void:
	var sauce_parser = SauceParser.new()
	var content_length:int = 0
	sauce_parser.data = sauce_parser.parse(file_path)

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		if sauce_parser.data:
			# Exclude SAUCE record and comments from content
			content_length = sauce_parser.data.FileSize
			# Setup ANSI Flags https://www.acid.org/info/sauce/sauce.htm#ANSiFlags
			if sauce_parser.data.Flags & sauce_parser.ANSI_FLAG_ICE_COLOR:
				screen.ice_color = true
				screen.blinking = false
				screen.blinking_enabled_at_start = false
			else:
				screen.ice_color = false
				screen.blinking = true
				screen.blinking_enabled_at_start = true
			font_8px = sauce_parser.data.Flags & sauce_parser.ANSI_FLAG_FONT_8PX and not sauce_parser.data.Flags & sauce_parser.ANSI_FLAG_FONT_9PX
			font_9px = sauce_parser.data.Flags & sauce_parser.ANSI_FLAG_FONT_9PX and not sauce_parser.data.Flags & sauce_parser.ANSI_FLAG_FONT_8PX
			if sauce_parser.data.Flags & sauce_parser.ANSI_FLAG_RATIO_BIT2 and not sauce_parser.ANSI_FLAG_RATIO_BIT1:
				aspect_ratio = ASPECT_RATIO.LEGACY
			else:
				aspect_ratio = ASPECT_RATIO.SQUARE
			# Extract font
			font_used = sauce_parser.data.TInfoS
			# Extract width
			ansi_width = sauce_parser.data.TInfo1
			ansi_height = sauce_parser.data.TInfo2
		else:
			content_length = file.get_length()
			screen.blinking = true
			screen.blinking_enabled_at_start = true
			ice_color = false
			font_used = "IBM VGA"
			font_8px = true
			font_9px = false
			aspect_ratio = ASPECT_RATIO.SQUARE

		var content:PackedByteArray
		for i:int in range(content_length):
			content.append(file.get_8())
		file.close()

		if resize_display:
			if screen.columns < 80: # reset to 80 columns first
				screen.columns = 80
			if screen.font_8px or screen.font_9px: # reset to 25 rows first...
				if screen.rows < 25: screen.rows = 25
			if screen.font_used == "IBM VGA50": # reset to 50 rows if 8x8 font
				if screen.ows < 50: screen.rows = 50
			if screen.ansi_width > 0 and screen.ansi_height > 0: # then if ansi w/h from sauce avail. use instead
				screen.columns = ansi_width
				screen.rows = ansi_height
		if change_font:
			if font_used == "IBM VGA50":
				screen.setup_screen_mode(screen.SCREEN_MODE.FONT_8x8)
			else:
				if font_8px:
					screen.setup_screen_mode(screen.SCREEN_MODE.FONT_8x16)
				else:
					screen.setup_screen_mode(screen.SCREEN_MODE.FONT_9x16)
		screen.cls()
		parse(content, screen)
	else:
		print("Failed to open file: %s" % file_path)
