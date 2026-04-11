/// @func CollageIsImage(value)
/// @param {Any} value
/// feather ignore all
function CollageIsImage(_image) {
	gml_pragma("forceinline");
	return (is_struct(_image) && is_instanceof(_image, __CollageImageClass));
}