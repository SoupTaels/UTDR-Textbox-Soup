/// @ignore
/// feather ignore all
function __CollageVFormat() {
	static _vFormat = undefined;
	if (is_undefined(_vFormat)) {
		vertex_format_begin();
		vertex_format_add_position_3d();
		vertex_format_add_colour();
		vertex_format_add_texcoord();
		_vFormat = vertex_format_end();	
	}
	
	return _vFormat;
}