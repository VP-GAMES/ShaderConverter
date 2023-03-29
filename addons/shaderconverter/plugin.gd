# Simple shaders converter from 3.+ to 4.+: MIT License
# @author Vladimir Petrenko
@tool
extends EditorPlugin

const _base_path: String = "res://"
const _tool_item: String = "Convert Shaders 3.x to GDShaders 4.x"

var _resource_filesystem: EditorFileSystem = get_editor_interface().get_resource_filesystem()
var _files_to_update: Array[String] = []

func _enter_tree() -> void:
	# TODO Add autoconvert after this implementation: https://github.com/godotengine/godot-proposals/issues/2131
	_shaders_to_gdshaders()
	add_tool_menu_item(_tool_item, _shaders_to_gdshaders)

func _shaders_to_gdshaders() -> void:
	print("\n\n *** Start convert shaders ***\n")
	dir_contents(_base_path)
	print("\n *** End convert shaders ***\n")

func _exit_tree():
	remove_tool_menu_item(_tool_item)

func dir_contents(path: String):
	_files_to_update.clear()
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
					_append_file_to_update(file_path_new)
					dir.rename(file_path, file_path_new)
					print("RENAMED: ", file_path, " to ", file_path_new)
				if file_path_new.ends_with(".gdshader"):
					_fix_shader_file(file_path_new)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	dir.list_dir_end()
	_resource_filesystem.scan()
	_resource_filesystem.scan_sources()
	_resource_filesystem.reimport_files(_files_to_update)

func _fix_shader_file(file_path: String) -> void:
	var file_read: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var content = file_read.get_as_text()
	content = _shader_renamings_fix(content, file_path)
	content = _shader_renamings_with_variables_fix(content, file_path)
	content = _shader_remove_variables_fix(content, file_path)
	content = _shader_type_particles_rename_functions(content, file_path)

	var file_write: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	file_write.store_string(content)

func _shader_renamings_fix(content: String, file_path: String) -> String:
	for old_name in ShaderRenamings.renamings:
		if content.contains(old_name):
			_append_file_to_update(file_path)
			content = content.replacen(old_name, ShaderRenamings.renamings[old_name])
	return content

func _shader_renamings_with_variables_fix(content: String, file_path: String) -> String:
	for old_name in ShaderRenamingsWithVariables.renamings:
		if content.contains(old_name):
			_append_file_to_update(file_path)
			content = content.replacen(old_name, ShaderRenamingsWithVariables.renamings[old_name][0])
			for shader_type_line in ShaderRenamingsWithVariables.shader_types_list:
				_append_file_to_update(file_path)
				content = content.replace(shader_type_line, shader_type_line + ShaderRenamingsWithVariables.renamings[old_name][1])
	return content

func _shader_remove_variables_fix(content: String, file_path: String) -> String:
	for to_remove in ShaderRemoveVariables.removings:
		var regex = RegEx.new()
		regex.compile(to_remove)
		if regex.search(content):
			_append_file_to_update(file_path)
			content = regex.sub(content, "")
	return content

func _shader_type_particles_rename_functions(content: String, file_path: String) -> String:
	if content.contains(ShaderRenamingsWithFunctions.shader_type_particles):
		for renaming_regex in ShaderRenamingsWithFunctions.renamings_regex:
			var regex = RegEx.new()
			regex.compile(renaming_regex)
			if regex.search(content):
				_append_file_to_update(file_path)
				content = regex.sub(content, ShaderRenamingsWithFunctions.renamings_regex[renaming_regex])
	return content

func _append_file_to_update(file_path: String) -> void:
	if not _files_to_update.has(file_path):
		_files_to_update.append(file_path)
