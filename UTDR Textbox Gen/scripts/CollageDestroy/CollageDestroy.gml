/// @func CollageDestroy(collage_instance_or_name)
/// @param {Any} collage_instance_or_name
/// feather ignore all
function CollageDestroy(_identifier) {
	gml_pragma("forceinline");
	static __system = __CollageSystem();
    if (is_string(_identifier)) {
		__system.__CollageTexturePagesMap[$ _identifier].Destroy();
    } else {
		_identifier.Destroy();	
	}
}