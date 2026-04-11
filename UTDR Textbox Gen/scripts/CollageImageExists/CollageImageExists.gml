/// @func CollageImageExists(collage_image_or_name)
/// @param {Struct.__CollageImageClass, String} collage_image_or_name
/// @return {Bool}
/// feather ignore all
function CollageImageExists(_identifier) {
	gml_pragma("forceinline");
	static __system = __CollageSystem();
	if (is_string(_identifier)) {
		if (!__COLLAGE_IMAGES_ARE_PUBLIC) {
			__CollageThrow("__COLLAGE_IMAGES_ARE_PUBLIC is set to false and therefore string names do not work.");
		}
		return variable_struct_exists(__system.__CollageImageMap, _identifier);		
	} 
	
	return ( ( is_instanceof(_identifier, __CollageImageClass) ) && ( variable_struct_exists(__system.__CollageImageMap, _identifier.__name) ) );
}