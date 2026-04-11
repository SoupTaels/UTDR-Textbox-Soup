/// @func CollageImageGetUVsArray(collage_image_or_name, image_index)
/// @param {Struct.__CollageImageClass, String} collage_image_or_name
/// @param {Real} image_index
/// @return {Array<Real>}
/// feather ignore all
function CollageImageGetUVsArray(_identifier, _imageIndex) {
	static __system = __CollageSystem();
    var _uvs;
    if (is_string(_identifier)) {
		if (!__COLLAGE_IMAGES_ARE_PUBLIC) {
			__CollageThrow("__COLLAGE_IMAGES_ARE_PUBLIC is set to false and therefore string names do not work.");
		}
		
		if (!CollageImageExists(_identifier)) __CollageThrow(_identifier + " doesn't exist!");
		_uvs = __system.__CollageImageMap[$ _identifier].__InternalGetUvs(_imageIndex);
	} else {
		if (!CollageImageExists(_identifier)) __CollageThrow(_identifier + " doesn't exist!");
	    _uvs =_identifier.__InternalGetUvs(_imageIndex);
	}
	var _texPage = _uvs.texturePageStruct;
	var _width = _texPage.GetWidth();
	var _height = _texPage.GetHeight();
	
	return [
		_uvs.normLeft, 
		_uvs.normTop, 
		_uvs.normRight, 
		_uvs.normBottom, 
		_uvs.trimLeft, 
		_uvs.trimTop, 
		_uvs.originalWidth/_width, 
		_uvs.originalHeight/_height
		];
}