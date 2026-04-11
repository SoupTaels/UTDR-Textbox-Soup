/// @func CollageIsGPUStateSterlized()
/// feather ignore all
function CollageIsGPUStateSterlized() {
	static _instance = __CollageGPUStateSingleton();
	return _instance.isSterilized;
}