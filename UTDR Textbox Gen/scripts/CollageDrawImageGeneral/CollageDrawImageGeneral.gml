/// @func CollageDrawImageGeneral(collage_image, image_index, left, top, width, height, x, y, xscale, yscale, rot, col1, col2, col3, col4, alpha);
/// @param {Struct.__CollageImageClass} collage_image
/// @param {Real} image_index
/// @param {Real} left
/// @param {Real} top
/// @param {Real} width
/// @param {Real} height
/// @param {Real} x
/// @param {Real} y
/// @param {Real} xscale
/// @param {Real} yscale
/// @param {Real} rot
/// @param {Real} col1
/// @param {Real} col2
/// @param {Real} col3
/// @param {Real} col4
/// @param {Real} alpha
/// feather ignore all
function CollageDrawImageGeneral(_imageData, _imageIndex, _left, _top, _width, _height, _x, _y, _xScale, _yScale, _rot, _col1, _col2, _col3, _col4, _alpha) {
	gml_pragma("forceinline");
	if (!is_struct(_imageData)) __CollageThrow("Invalid collage_image! Got " + string(_imageData) + " instead!");
	var _ratio = (__COLLAGE_SCALE_TO_TEXTURES_ON_PAGE) ? _imageData.__ratio : 1;
	var _uvs = _imageData.__InternalGetUvs(_imageIndex);
	
	if (!_uvs.texturePageStruct.__isLoaded) _uvs.texturePageStruct.CheckSurface();	
	
	var _xOffset = _uvs.xPos;
	var _yOffset = _uvs.yPos;
	var _xPos = lengthdir_x(_xOffset * _xScale, _rot) + lengthdir_x(_yOffset * _yScale, _rot - 90);
	var _yPos = lengthdir_y(_xOffset * _xScale, _rot) + lengthdir_y(_yOffset * _yScale, _rot - 90);
	draw_surface_general(_uvs.texturePageStruct.__surface, 
		clamp(_uvs.left+_left, _uvs.left, _uvs.left+_uvs.right), 
		clamp(_uvs.top+_top, _uvs.top, _uvs.top+_uvs.bottom), 
		clamp(_width, _left, _uvs.right), 
		clamp(_height, _top, _uvs.bottom), 
		_x-_xPos, 
		_y-_yPos, 
		_xScale/_ratio, 
		_yScale/_ratio, 
		_rot, 
		_col1, 
		_col2, 
		_col3, 
		_col4, 
		_alpha
	);	
}
