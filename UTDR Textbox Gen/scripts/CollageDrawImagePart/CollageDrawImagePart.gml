/// @func CollageDrawImagePart(image, image_index, x, y);
/// @param {Struct.__CollageImageClass} collage_image
/// @param {Real} image_index
/// @param {Real} left
/// @param {Real} right
/// @param {Real} width
/// @param {Real} height
/// @param {Real} x
/// @param {Real} y
/// feather ignore all
function CollageDrawImagePart(_imageData, _imageIndex, _left, _top, _width, _height, _x, _y) {
	gml_pragma("forceinline");
	if (!is_struct(_imageData)) __CollageThrow("Invalid collage_image! Got " + string(_imageData) + " instead!");
	var _uvs = _imageData.__InternalGetUvs(_imageIndex);
	
	if (!_uvs.texturePageStruct.__isLoaded) _uvs.texturePageStruct.CheckSurface();
	var _uvLeft = clamp(_uvs.left + _left, _uvs.left, _uvs.left+_uvs.right), 
			_uvTop = clamp(_uvs.top + _top, _uvs.top, _uvs.top + _uvs.bottom), 
			_uvWidth = clamp(_width, 0, _uvs.right),
			_uvHeight = clamp(_height, 0, _uvs.bottom);
	
	if (_imageData.__ratio != 1) {
		draw_surface_part_ext(
			_uvs.texturePageStruct.__surface, 
			_uvLeft,
			_uvTop,
			_uvWidth,
			_uvHeight, 
			(__COLLAGE_PART_RESPECT_ORIGIN) ? _x-(_uvs.xPos) : _x+(_uvs.trimLeft), 
			(__COLLAGE_PART_RESPECT_ORIGIN) ? _y-(_uvs.xPos) : _y+(_uvs.trimTop), 
			_imageData.__scaled, 
			_imageData.__scaled, 
			draw_get_colour(), 
			draw_get_alpha()
		);	
	} else {
		draw_surface_part(
			_uvs.texturePageStruct.__surface, 
			_uvLeft,
			_uvTop,
			_uvWidth,
			_uvHeight, 
			(__COLLAGE_PART_RESPECT_ORIGIN) ? _x-(_uvs.xPos) : _x+(_uvs.trimLeft), 
			(__COLLAGE_PART_RESPECT_ORIGIN) ? _y-(_uvs.xPos) : _y+(_uvs.trimTop)
		);	
	}
}
