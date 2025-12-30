# ***
# author: 
# brief:
# date:
# ***
@tool
extends EditorPlugin

var file : FileAccess
var script_editor: ScriptEditor
var header_source : PackedStringArray
var source_code : String
var comment_line : String
var performed : bool = false

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
	file = FileAccess.open("res://addons/headerthing/header_source.txt", FileAccess.READ)
	
	header_source = file.get_as_text().split("\n")
	script_editor = EditorInterface.get_script_editor()	
	
	if (script_editor == null): 
		printerr("headerthing says: script editor is null")
		pass
	
	file.close()
	script_editor.editor_script_changed.connect(_check_script)
	
	pass


func _process(delta: float) -> void:
	var script := get_editor_interface().get_script_editor().get_current_script() 

	if (!printed_once):
		if script && script.has_source_code():
			comment_line = header_source[0].substr(0, 3)
			if (script.source_code.get_slice("\n", 0) == comment_line):
				var new_code = script.source_code.split("\n")
				new_code = _insert_header(new_code)
				new_code = "\n".join(new_code)
				script.source_code = new_code
				
				if (ResourceSaver.save(script) != 0):
					printerr("headerthing says: unable to save script")
					pass
				
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
	for line in range(1, header_source.size()-1):
		code.insert(line, header_source[line])
		pass
	
	return code
