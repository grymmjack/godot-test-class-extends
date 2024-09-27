@icon("res://icon.svg")
class_name GodotConsoleResource
extends Resource

func _init() -> void:
	print("- %-22s %s : %-20s -> %-25s" % [
		get_script().get_path(),
		get_script().get_instance_base_type(),
		super.get_script().get_base_script().get_global_name(),
		get_script().get_global_name()
	])
