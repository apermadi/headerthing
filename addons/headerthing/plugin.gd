@tool
extends EditorPlugin

var script_editor: ScriptEditor
var current_script : Script
var code

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	script_editor = EditorInterface.get_script_editor()	
	
	if (script_editor == null): 
		print("headerthing says: script editor is null")
		pass
	
	current_script = script_editor.get_script()
	if (current_script == null): 
		print("headerthing says: current script is null")
		pass
	
	# _print_all_children(script_editor)
	pass


func _process(delta: float) -> void:
	
	pass

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass


# debugging purposes
func _print_all_children(node: Node) -> void:
	for child in node.get_children():
		if (child.get_child_count()):
			_print_all_children(child)
		
		# print(child.name)


func _parse_source_code(code : String) -> void:
	
	pass
