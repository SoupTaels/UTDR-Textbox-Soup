/// @func CollageGet(name)
/// @param {String} name
/// feather ignore all
function CollageGet(_identifier) {
	gml_pragma("forceinline");
	static __system = __CollageSystem();
    return __system.__CollageTexturePagesMap[$ _identifier];
}
