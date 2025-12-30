@tool
extends EditorPlugin

var script_editor: ScriptEditor = null
var current_script = null
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
	script_editor = EditorInterface.get_script_editor()	
	
	if (script_editor == null): 
		printerr("headerthing says: script editor is null")
		pass
	
	script_editor.editor_script_changed.connect(_check_script)
	
	pass


# TODO: every time the script has changed,
# check in the first line of the function the string "#-"
# if it is there, insert header into the source code
func _process(delta: float) -> void:
	# var script = EditorInterface.get_script_editor()
	current_script = script_editor.get_open_scripts()
	# var scripts = script_editor.get_open_scripts()
	
	var script := get_editor_interface().get_script_editor().get_current_script() 
	# var source := script.get_source_code()
	if (!printed_once):
		# print(script.get_source_code())
		if script && script.has_source_code():
			print(script.source_code.get_slice("\n", 0))
			
			# script.source_code.insert(0, "# hello world!")
			script.source_code[0] = 'Q'
			ResourceSaver.save(script)
			
			print(script.source_code.get_slice("\n", 0))
			
			printed_once = true
		
		
		
		# print(current_script.get_source_code())
	pass
	
	# script.reload()


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass


func _check_script(script: Script) -> void:
	# print("beep")
	pass
