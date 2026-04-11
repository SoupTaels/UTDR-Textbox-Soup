/// @func CollageImageGetUVs(collage_image_or_name, image_index)
/// @param {Struct.__CollageImageClass, String} collage_image_or_name
/// @param {Real} image_index
/// @return {Struct.__CollageUVsClass}
/// feather ignore all
function CollageImageGetUVs(_identifier, _imageIndex) {
	static __system = __CollageSystem();
	if (is_string(_identifier)) {
		if (!__COLLAGE_IMAGES_ARE_PUBLIC) {
			__CollageThrow("__COLLAGE_IMAGES_ARE_PUBLIC is set to false and therefore string names do not work.");
		}
		
		if (!CollageImageExists(_identifier)) __CollageThrow(_identifier + " doesn't exist!");
		return __system.__CollageImageMap[$ _identifier].GetUVs(_imageIndex);
	}
	
	if (!CollageImageExists(_identifier)) __CollageThrow(_identifier + " doesn't exist!");
	return _identifier.GetUVs(_imageIndex);
}
