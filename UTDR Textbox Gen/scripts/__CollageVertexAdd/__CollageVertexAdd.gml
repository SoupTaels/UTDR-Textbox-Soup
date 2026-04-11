/// @ignore
/// feather ignore all
function __CollageVertexAdd(_vbuffer, _xy, _z, _left, _top, _right, _bottom, _colour, _alpha) {
	// Add vertices
	vertex_position_3d(_vbuffer, _xy[0][0], _xy[0][1], _z);
	vertex_color(_vbuffer, _colour[0], _alpha);
	vertex_texcoord(_vbuffer, _left, _top);
	
	vertex_position_3d(_vbuffer, _xy[1][0], _xy[1][1], _z);
	vertex_color(_vbuffer, _colour[1], _alpha);
	vertex_texcoord(_vbuffer, _right, _top);
	
	vertex_position_3d(_vbuffer, _xy[2][0], _xy[2][1], _z);
	vertex_color(_vbuffer, _colour[2], _alpha);
	vertex_texcoord(_vbuffer, _right, _bottom);
	
	
	vertex_position_3d(_vbuffer, _xy[0][0], _xy[0][1], _z);
	vertex_color(_vbuffer, _colour[0], _alpha);
	vertex_texcoord(_vbuffer, _left, _top);
	
	vertex_position_3d(_vbuffer, _xy[2][0], _xy[2][1], _z);
	vertex_color(_vbuffer, _colour[2], _alpha);
	vertex_texcoord(_vbuffer, _right, _bottom);
	
	vertex_position_3d(_vbuffer, _xy[3][0], _xy[3][1], _z);
	vertex_color(_vbuffer, _colour[3], _alpha);
	vertex_texcoord(_vbuffer, _left, _bottom);	
}