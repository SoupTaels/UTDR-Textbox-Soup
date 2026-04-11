/// @func CollageDrawImageExt(collage_image, image_index, x, y, xscale, yscale, rot, col, alpha);
/// @param {Struct.__CollageImageClass} collage_image
/// @param {Real} image_index
/// @param {Real} x
/// @param {Real} y
/// @param {Real} xscale
/// @param {Real} yscale
/// @param {Real} rot
/// @param {Real} col
/// @param {Real} alpha
/// feather ignore all
function CollageDrawImageExt(_imageData, _imageIndex, _x, _y, _xScale, _yScale, _rot, _col, _alpha) {
	gml_pragma("forceinline");
	if (!is_struct(_imageData)) __CollageThrow("Invalid collage_image! Got " + string(_imageData) + " instead!");
	var _ratio = (__COLLAGE_SCALE_TO_TEXTURES_ON_PAGE) ? _imageData.__ratio : 1;
	var _uvs = _imageData.__InternalGetUvs(_imageIndex);
	
	if (!_uvs.texturePageStruct.__isLoaded) _uvs.texturePageStruct.CheckSurface();
	
	var _xOffset = _uvs.xPos;
	var _yOffset = _uvs.yPos;
	var _xPos = lengthdir_x(_xOffset * _xScale, _rot) + lengthdir_x(_yOffset * _yScale, _rot - 90);
	var _yPos = lengthdir_y(_xOffset * _xScale, _rot) + lengthdir_y(_yOffset * _yScale, _rot - 90);
	draw_surface_general(
		_uvs.texturePageStruct.__surface, 
		_uvs.left, 
		_uvs.top, 
		_uvs.right, 
		_uvs.bottom, 
		_x-_xPos, 
		_y-_yPos, 
		_xScale/_ratio, 
		_yScale/_ratio, 
		_rot,
		_col, 
		_col, 
		_col, 
		_col, 
		_alpha
	);	
}