# Simple shaders converter from 3.+ to 4.+: MIT License
# ShaderRemoveVariables class to parse shaders 
# @author Vladimir Petrenko
class_name ShaderRemoveVariables

const removings: PackedStringArray = [
	"(.*)(TAU)\\s*[=](.*)\\n",
#	"(.*)(PI)\\s*[=](.*)\\n",
#	"(.*)(E)\\s*[=](.*)\\n"
]
