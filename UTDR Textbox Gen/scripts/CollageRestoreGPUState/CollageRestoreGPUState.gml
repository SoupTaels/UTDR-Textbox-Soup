/// @func CollageRestoreGPUState()
/// feather ignore all
function CollageRestoreGPUState() {
	/// feather ignore all
	gml_pragma("forceinline");
	var _instance = __CollageGPUStateSingleton();
	if (!_instance.isSterilized) {
		__CollageThrow("GPU is not sterlized! Please use CollageSterlizeGPUState()!")
	}
	_instance.isSterilized = false;
	// Restore settings
	gpu_set_blendenable(_instance.gpuBlendEnable);
	// Feather ignore once GM1020 
	// Feather ignore once GM1044 
	gpu_set_blendmode_ext_sepalpha(_instance.gpuBlendMode);
	// Feather ignore once GM1041 
	gpu_set_colourwriteenable(_instance.gpuColourWrite);
	gpu_set_alphatestenable(_instance.gpuAlphaTest);
	gpu_set_texfilter(_instance.gpuTexFilter);
	// Feather ignore once GM1020 
	// Feather ignore once GM1041 
	var _gpuFog = _instance.gpuFog;
	gpu_set_fog(_gpuFog[0], _gpuFog[1], _gpuFog[2], _gpuFog[3]);
	draw_set_lighting(_instance.gpuLighting);
	draw_set_colour(_instance.gpuColour);
	draw_set_alpha(_instance.gpuAlpha);
	gpu_set_zwriteenable(_instance.gpuZWrite);
	gpu_set_ztestenable(_instance.gpuZTest);
	// Feather ignore once GM1029 
	gpu_set_cullmode(_instance.gpuCullmode);
	gpu_set_zfunc(_instance.gpuZFunc);
	gpu_set_tex_filter(_instance.gpuFiltering);
	gpu_set_tex_mip_enable(_instance.gpuMipEnabled);
	matrix_set(matrix_world, _instance.matrixWorld);
	matrix_set(matrix_view, _instance.matrixView);
	matrix_set(matrix_projection, _instance.matrixProj);
	gpu_set_blendequation(_instance.blendEquation);
	gpu_set_depth(_instance.depth);
	gpu_set_sprite_cull(_instance.spriteCull);
	// Feather ignore once GM1009 
	if (_instance.shader != -1) {
		shader_set(_instance.shader);	
	}
}