/// @func CollageImageGetTexture(collage_image_or_name, image_index)
/// @param {Struct.__CollageImageClass, String} collage_image_or_name
/// @param {Real} image_index
/// @return {Pointer.Texture}
/// feather ignore all
function CollageImageGetTexture(_identifier, _imageIndex) {
	static __system = __CollageSystem();
	if (is_string(_identifier)) {
		if (!__COLLAGE_IMAGES_ARE_PUBLIC) {
			__CollageThrow("__COLLAGE_IMAGES_ARE_PUBLIC is set to false and therefore string names do not work.");
		}
		
		return __system.__CollageImageMap[$ _identifier].GetTexture(_imageIndex);	
	} 
	
	return _identifier.GetTexture(_imageIndex);	
}
