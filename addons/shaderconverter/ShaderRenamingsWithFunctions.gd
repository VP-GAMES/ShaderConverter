# Simple shaders converter from 3.+ to 4.+: MIT License
# ShaderRenamingsWithFunctions class to parse shaders 
# @author Vladimir Petrenko
class_name ShaderRenamingsWithFunctions

const shader_type_particles = "shader_type particles;"
const shader_types_list: PackedStringArray = [
	shader_type_particles + "\n"
	]

const renamings_regex: Dictionary = {
	"(.*)(void)\\s*(vertex)[(][)]\\s[{]\n": "void start() {"
}
