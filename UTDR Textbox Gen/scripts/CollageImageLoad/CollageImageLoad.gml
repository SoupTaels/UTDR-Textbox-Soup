/// @func CollageImageLoad(collage_image_or_name, image_index)
/// @param {Struct.__CollageImageClass, String} collage_image_or_name
/// @param {Real} image_index
/// feather ignore all
function CollageImageLoad(_identifier, _subImage) {
	static __system = __CollageSystem();
	var _image;
	
	if (is_string(_identifier)) {
		if (!__COLLAGE_IMAGES_ARE_PUBLIC) {
			__CollageThrow("__COLLAGE_IMAGES_ARE_PUBLIC is set to false and therefore string names do not work.");
		}
		
		 _image =  __system.__CollageImageMap[$ _identifier];
	} else {
		_image = _identifier;	
	}
	
	if (!CollageImageExists(_identifier)) __CollageThrow(_identifier + " doesn't exist!");
	_image.subImagesArray[_subImage % _image.subImagesCount].texturePageStruct.CheckSurface();
}
