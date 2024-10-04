class_name SauceParser
extends GodotConsoleResource

var data:SauceData

const SAUCE_ID := "SAUCE"
const SAUCE_VERSION := "00"

# SAUCE record structure sizes
const SAUCE_RECORD_SIZE := 128
const COMMENT_BLOCK_SIZE := 64
const COMMENT_ID := "COMNT"

# ANSI Flags https://www.acid.org/info/sauce/sauce.htm#ANSiFlags
# B S L R A 0 0 0
# 0 1 2 3 4 5 6 7
const ANSI_FLAG_ICE_COLOR     = 1 << 0
const ANSI_FLAG_FONT_8PX      = 1 << 1
const ANSI_FLAG_FONT_9PX      = 1 << 2
const ANSI_FLAG_RATIO_BIT1    = 1 << 3
const ANSI_FLAG_RATIO_BIT2    = 1 << 4
const ANSI_FLAG_BIT_6         = 1 << 5
const ANSI_FLAG_BIT_7         = 1 << 6
const ANSI_FLAG_BIT_8         = 1 << 7

func _init() -> void:
	super._init()
	data = SauceData.new()

func parse(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)

	if !file:
		print("Failed to open file: %s" % file_path)
		return null

	var file_size = file.get_length()
	if file_size < SAUCE_RECORD_SIZE:
		# File is too small to contain SAUCE record
		file.close()
		return null

	# Seek to potential SAUCE record position
	file.seek(file_size - SAUCE_RECORD_SIZE)
	data.raw_data = file.get_buffer(SAUCE_RECORD_SIZE)
	var raw_data_str = data.raw_data.get_string_from_ascii()

	if not raw_data_str.begins_with(SAUCE_ID):
		# No SAUCE record found
		file.close()
		return null

	# Parse SAUCE record
	data.ID = bytes_to_str8(data.raw_data.slice(0, 5))
	data.Version = bytes_to_str8(data.raw_data.slice(5, 5 + 2))
	data.Title = bytes_to_str8(data.raw_data.slice(7, 7 + 35))
	data.Author = bytes_to_str8(data.raw_data.slice(42, 42 + 20))
	data.Group = bytes_to_str8(data.raw_data.slice(62, 62 + 20))
	data.Date = bytes_to_str8(data.raw_data.slice(82, 82 + 8))
	data.FileSize = bytes_to_int(data.raw_data.slice(90, 90 + 4))
	data.DataType = data.raw_data[94]
	data.FileType = data.raw_data[95]
	data.TInfo1 = bytes_to_int(data.raw_data.slice(96, 96 + 2))  # 2 bytes for TInfo1
	data.TInfo2 = bytes_to_int(data.raw_data.slice(98, 98 + 2))  # 2 bytes for TInfo2
	data.TInfo3 = bytes_to_int(data.raw_data.slice(100, 102 + 2))  # 2 bytes for TInfo3
	data.TInfo4 = bytes_to_int(data.raw_data.slice(102, 102 + 2))  # 2 bytes for TInfo4
	data.Comments = data.raw_data[104]
	data.TFlags = data.raw_data[105]
	data.TInfoS = bytes_to_str8(data.raw_data.slice(106, 106 + 22))

	# Parse comments if any
	if data.Comments > 0:
		var comment_block_position = file_size - SAUCE_RECORD_SIZE - (data.Comments * COMMENT_BLOCK_SIZE)
		file.seek(comment_block_position - 5)
		var comment_id_data = file.get_buffer(5)
		var comment_id_str = comment_id_data.get_string_from_ascii()
		if comment_id_str == COMMENT_ID:
			for i in range(data.Comments):
				var comment_line_data = file.get_buffer(COMMENT_BLOCK_SIZE)
				var comment_line = comment_line_data.get_string_from_ascii().strip_edges()
				data.CommentLines.append(comment_line)
		else:
			print("Invalid comment block identifier.")

	file.close()

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
