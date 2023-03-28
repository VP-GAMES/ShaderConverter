# Simple shaders converter from 3.+ to 4.+: MIT License
# ShaderRemoveVariables class to parse shaders 
# @author Vladimir Petrenko
class_name ShaderRemoveVariables

const removings: PackedStringArray = [
	"(.*)(\\sTAU\\s)\\s*[=](.*)(;)\\n",
	"(.*)(\\sPI\\s)\\s*[=](.*)(;)\\n",
	"(.*)(\\sE\\s)\\s*[=](.*)(;)\\n"
]
