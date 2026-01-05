# ***
# author: 
# brief:
# date:
# ***
# author: 
# brief:
# date:
# ***
# author: 
# brief:
# date:
# ***
# author: 
# brief:
# date:
# ***
# author: 
# brief:
# date:
# ***
# author: 
# brief:
# date:
# ***
# author: 
# brief:
# date:
# ***
# author: 
# brief:
# date:
# ***
# author: 
# brief:
# date:
# ***
# author: 
# brief:
# date:
# ***
# author: 
# brief:
# date:
# ***
# author: 
# brief:
# date:
# ***
# author: 
# brief:
# date:
# ***
# author: 
# brief:
# date:
# ***
@tool
extends EditorPlugin

var file : FileAccess
var script_editor
var header_source : PackedStringArray
var source_code : String
var comment_line : String
var performed : bool = false

# TODO: make a helper function that calls the base editor, replace every line w that func

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
	script_editor = get_editor_interface().get_script_editor()	
	
	if (script_editor == null): 
		printerr("headerthing says: script editor is null")
		pass
	
	file.close()


func _process(delta: float) -> void:
	if (!performed):
		if EditorInterface:
			EditorInterface.get_script_editor().get_current_editor().get_base_editor().lines_edited_from.connect(update_script)
			var settings = EditorInterface.get_editor_settings()
			settings.set_setting("text_editor/behavior/files/auto_reload_scripts_on_external_change", true)
			performed = true


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass


func update_script(from: int, to: int) -> void:
	if (from + to == 0):
		if get_editor_interface():
			var script := get_editor_interface().get_script_editor().get_current_script() 
			if script && script.has_source_code():
				comment_line = header_source[0].substr(0, 3)
				print(get_editor_interface().get_script_editor().get_current_editor().get_base_editor().text.get_slice("\n", 0))
				print("comment_line: " + comment_line)
				if (get_editor_interface().get_script_editor().get_current_editor().get_base_editor().text.get_slice("\n", 0) == comment_line):
					var new_code = script.source_code.split("\n")
					new_code = insert_header(new_code)
					new_code = "\n".join(new_code)
					script.source_code = new_code
					
					ResourceSaver.save(script, get_editor_interface().get_script_editor().get_current_script().get_path())
					
					get_editor_interface().get_script_editor().get_current_editor().get_base_editor().text = script.source_code
					performed = false
					# ResourceLoader.load(script.get_path(), "Script", ResourceLoader.CACHE_MODE_REPLACE)
					# EditorInterface.get_script_editor().reload_scripts()


func insert_header(code: PackedStringArray) -> PackedStringArray:
	code[0] = header_source[0]
	for line in range(1, header_source.size()-1):
		code.insert(line, header_source[line])
		pass
	
	return code
