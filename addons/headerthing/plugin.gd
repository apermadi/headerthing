# ***
# author: 
# brief:
# date:
# ***

# ***
@tool
extends EditorPlugin

var file : FileAccess
var header_source : PackedStringArray
var script_editor: ScriptEditor
var source_code : String

# debug printing
var printed_once: bool = false

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# TODO: error checking
	# this will not be a todo soon
	file = FileAccess.open("res://addons/headerthing/header_source.txt", FileAccess.READ)
	
	header_source = file.get_as_text().split("\n")
	script_editor = EditorInterface.get_script_editor()	
	
	if (script_editor == null): 
		printerr("headerthing says: script editor is null")
		pass
	
	file.close()
	script_editor.editor_script_changed.connect(_check_script)
	
	print(header_source)
	
	pass


func _process(delta: float) -> void:
	var script := get_editor_interface().get_script_editor().get_current_script() 

	if (!printed_once):
		# print(script.get_source_code())
		if script && script.has_source_code():
			# print(script.source_code.get_slice("\n", 0))
			
			# TODO: replace "# *" with the first line of the source, up to two chars
			# thats what we call data driven development !!
			if (script.source_code.get_slice("\n", 0) == "# *"):
				var new_code = script.source_code.split("\n")
				new_code = _insert_header(new_code)
				new_code = "\n".join(new_code)
				script.source_code = new_code
				
				if (ResourceSaver.save(script) != 0):
					printerr("headerthing says: unable to save script")
					pass
			
			print(script.source_code)
			printed_once = true
	
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass


func _check_script(script: Script) -> void:
	# print("beep")
	pass


func _insert_header(code: PackedStringArray) -> PackedStringArray:
	code[0] = header_source[0]
	for line in header_source.size():
		code.insert(line, header_source[line])
		pass
	
	return code
