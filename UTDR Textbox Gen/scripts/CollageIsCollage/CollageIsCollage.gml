/// @func CollageIsCollage(value)
/// @param {Any} value
/// feather ignore all
function CollageIsCollage(_collage) {
	return (is_struct(_collage) && (instanceof(_collage) == "Collage"));
}