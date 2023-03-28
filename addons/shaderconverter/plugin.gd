# Simple shaders converter from 3.+ to 4.+: MIT License
# @author Vladimir Petrenko
@tool
extends EditorPlugin

const _base_path: String = "res://"
var _resource_filesystem: EditorFileSystem = get_editor_interface().get_resource_filesystem()

func _enter_tree():
	_on_filesystem_changed()
	#_resource_filesystem.filesystem_changed.connect(_on_filesystem_changed)

func _on_filesystem_changed() -> void:
	print("filesystem_changed")
	dir_contents("res://")

func dir_contents(path: String):
	var actualpath = path 
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				dir_contents(actualpath + "/" + file_name)
			else:
				var file_path_new = actualpath + "/" + file_name
				if file_path_new.ends_with(".shader"):
					# Rename shader files
					var file_path = file_path_new
					file_path_new = actualpath + "/" + file_name.replace(".shader", ".gdshader")
					dir.rename(file_path, file_path_new)
				if file_path_new.ends_with(".gdshader"):
					_fix_shader_file(file_path_new)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	dir.list_dir_end()
	_resource_filesystem.scan()

func _fix_shader_file(file_path: String) -> void:
	print(file_path)
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ_WRITE)
	var content: String = file.get_as_text()
	content = _shader_renamings_fix(content, file_path)
	content = _shader_renamings_with_variables_fix(content, file_path)
	content = _shader_remove_variables_fix(content, file_path)
	file.store_string(content)

func _shader_renamings_fix(content: String, file_path: String) -> String:
	for old_name in ShaderRenamings.renamings:
		if content.contains(old_name):
			content = content.replacen(old_name, ShaderRenamings.renamings[old_name])
	return content

func _shader_renamings_with_variables_fix(content: String, file_path: String) -> String:
	for old_name in ShaderRenamingsWithVariables.renamings:
		if content.contains(old_name):
			content = content.replacen(old_name, ShaderRenamingsWithVariables.renamings[old_name][0])
			for shader_type_line in ShaderRenamingsWithVariables.shader_types_list:
				content = content.replace(shader_type_line, shader_type_line + ShaderRenamingsWithVariables.renamings[old_name][1])
	return content

func _shader_remove_variables_fix(content: String, file_path: String) -> String:
	for to_remove in ShaderRemoveVariables.removings:
		var regex = RegEx.new()
		regex.compile(to_remove)
		if regex.search(content):
			content = regex.sub(content, "")
	return content
