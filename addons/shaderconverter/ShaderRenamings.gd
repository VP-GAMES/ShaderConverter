# Simple shaders converter from 3.+ to 4.+: MIT License
# ShaderRenamings class to parse shaders 
# @author Vladimir Petrenko
class_name ShaderRenamings

const renamings: Dictionary = {
	"hint_albedo": "source_color",
	"hint_black_albedo": "source_color",
	"hint_color": "source_color",
	"hint_black": "hint_default_black",
	"hint_white": "hint_default_white",
	"WORLD_MATRIX": "MODEL_MATRIX",
	"WORLD_NORMAL_MATRIX": "MODEL_NORMAL_MATRIX",
	"INV_CAMERA_MATRIX": "VIEW_MATRIX",
	"CAMERA_MATRIX": "INV_VIEW_MATRIX",
	"NORMALMAP": "NORMAL_MAP",
	"NORMALMAP_DEPTH": "NORMAL_MAP_DEPTH",
	"depth_draw_alpha_prepass": "depth_prepass_alpha"
}
