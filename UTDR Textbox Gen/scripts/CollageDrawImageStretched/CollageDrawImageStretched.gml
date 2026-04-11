/// @func CollageDrawImageStretched(image, image_index, x, y, width, height);
/// @param {Struct.__CollageImageClass} collage_image
/// @param {Real} image_index
/// @param {Real} x
/// @param {Real} y
/// @param {Real} width
/// @param {Real} height
/// feather ignore all
function CollageDrawImageStretched(_imageData, _imageIndex, _x, _y, _width, _height) {
	gml_pragma("forceinline");
	if (!is_struct(_imageData)) __CollageThrow("Invalid collage_image! Got " + string(_imageData) + " instead!");
	var _ratio = (__COLLAGE_SCALE_TO_TEXTURES_ON_PAGE) ? _imageData.__ratio : 1;
	var _uvs = _imageData.__InternalGetUvs(_imageIndex);
	var _sx = (_width/_imageData.__width)/_ratio;
	var _sy = (_height/_imageData.__height)/_ratio;
	
	if (!_uvs.texturePageStruct.__isLoaded) _uvs.texturePageStruct.CheckSurface();	
	
	draw_surface_part_ext(
		_uvs.texturePageStruct.__surface, 
		_uvs.left, 
		_uvs.top, 
		_uvs.right, 
		_uvs.bottom, 
		(__COLLAGE_STRETCHED_RESPECT_ORIGIN) ? _x-(_uvs.xPos*_sx) : _x+(_uvs.trimLeft*_sx), 
		(__COLLAGE_STRETCHED_RESPECT_ORIGIN) ? _y-(_uvs.xPos*_sy) : _y+(_uvs.trimTop*_sy), 
		_sx, 
		_sy, 
		c_white, 
		draw_get_alpha()
	);	
}