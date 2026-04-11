/// @func CollageDrawImagePartExt(image, image_index, x, y);
/// @param {Struct.__CollageImageClass} collage_image
/// @param {Real} image_index
/// @param {Real} left
/// @param {Real} right
/// @param {Real} width
/// @param {Real} height
/// @param {Real} x
/// @param {Real} y
/// @param {Real} xscale
/// @param {Real} yscale
/// @param {Real} colour
/// @param {Real} alpha
/// feather ignore all
function CollageDrawImagePartExt(_imageData, _imageIndex, _left, _top, _width, _height, _x, _y, _xScale, _yScale, _col, _alpha) {
	gml_pragma("forceinline");
	if (!is_struct(_imageData)) __CollageThrow("Invalid collage_image! Got " + string(_imageData) + " instead!");
	var _ratio = (__COLLAGE_SCALE_TO_TEXTURES_ON_PAGE) ? _imageData.__ratio : 1;
	var _uvs = _imageData.__InternalGetUvs(_imageIndex);
	var _sx = _xScale/_ratio;
	var _sy = _yScale/_ratio;
	
	if (!_uvs.texturePageStruct.__isLoaded) _uvs.texturePageStruct.CheckSurface();	
	var _uvLeft = clamp(_uvs.left + _left, _uvs.left, _uvs.left+_uvs.right), 
		_uvTop = clamp(_uvs.top + _top, _uvs.top, _uvs.top + _uvs.bottom), 
		_uvWidth = clamp(_width, 0, _uvs.right),
		_uvHeight = clamp(_height, 0, _uvs.bottom);
	
	draw_surface_part_ext(
		_uvs.texturePageStruct.__surface, 
		_uvLeft, 
		_uvTop, 
		_uvWidth, 
		_uvHeight, 
		(__COLLAGE_PART_RESPECT_ORIGIN) ? _x-(_uvs.xPos*_sx) : _x+(_uvs.trimLeft*_sx), 
		(__COLLAGE_PART_RESPECT_ORIGIN) ? _y-(_uvs.xPos*_sy) : _y+(_uvs.trimTop*_sy),
		_sx, 
		_sy, 
		_col, 
		_alpha
	);	
}
