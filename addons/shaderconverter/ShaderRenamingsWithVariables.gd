# Simple shaders converter from 3.+ to 4.+: MIT License
# ShaderRenamingsWithVariables class to parse shaders 
# @author Vladimir Petrenko
class_name ShaderRenamingsWithVariables

const shader_types_list: PackedStringArray = ["shader_type spatial;\n", "shader_type canvas_item;\n"]

const renamings: Dictionary = {
	"DEPTH_TEXTURE": ["depth_texture", "uniform sampler2D depth_texture : hint_depth_texture, filter_linear_mipmap;\n"]
}
