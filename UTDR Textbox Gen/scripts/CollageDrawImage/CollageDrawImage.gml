/// @func CollageDrawImage(collage_image, image_index, x, y);
/// @param {Struct.__CollageImageClass} collage_image
/// @param {Real} image_index
/// @param {Real} x
/// @param {Real} y
/// feather ignore all
function CollageDrawImage(_imageData, _imageIndex, _x, _y) {
	gml_pragma("forceinline");
	if (!is_struct(_imageData)) __CollageThrow("Invalid collage_image! Got " + string(_imageData) + " instead!");
	var _ratio = _imageData.__ratio;
    var _uvs = _imageData.__InternalGetUvs(_imageIndex);
	
	if (!_uvs.texturePageStruct.__isLoaded) _uvs.texturePageStruct.CheckSurface();
	
	if (_ratio != 1) && (__COLLAGE_SCALE_TO_TEXTURES_ON_PAGE) {
		draw_surface_part_ext(
            _uvs.texturePageStruct.__surface, 
			_uvs.left, 
			_uvs.top, 
			_uvs.right, 
			_uvs.bottom, 
			_x-_uvs.xPos, 
			_y-_uvs.yPos, 
			_imageData.__scaled, 
			_imageData.__scaled, 
			draw_get_colour(), 
			draw_get_alpha()
		);
	} else {
		draw_surface_part(
            _uvs.texturePageStruct.__surface,
			_uvs.left, 
			_uvs.top, 
			_uvs.right, 
			_uvs.bottom,
			_x-_uvs.xPos, 
			_y-_uvs.yPos
		);	
	}
}
