/// @func CollageImageGetInfo(collage_image_name)
/// @param {String} collage_image_name
/// @return {Struct.__CollageImageClass}
/// feather ignore all
function CollageImageGetInfo(_identifier) {
	gml_pragma("forceinline");
	static __system = __CollageSystem();
	if (!__COLLAGE_IMAGES_ARE_PUBLIC) {
		__CollageThrow("__COLLAGE_IMAGES_ARE_PUBLIC is set to false and therefore string names do not work.");
	}
	
	if (!variable_struct_exists(__system.__CollageImageMap, _identifier)) {
		__CollageThrow("Image " + string(_identifier) + " does not exist!");
	}
	
	return __system.__CollageImageMap[$ _identifier];
}
