// This is a fallback script for GMLive.
// It provides replacements for the extension functions if the extension is missing locally.
//
// If you are seeing this in GameMaker, you must have downloaded a repository that uses GMLive.
// You can re-import GMLive to enable the extension, or do nothing if you don't need it.

globalvar live_log_script; live_log_script = live_log_impl;
function live_log_impl(l_text,l_level){
	/// @ignore
	show_debug_message("[GMLive]["+date_datetime_string(date_current_datetime())+"] "+l_text);
}
function live_init(l_updateRate,l_url,l_password) {
	live_log_script("GMLive.gml fallback v0.0.1",0);
	live_log_script("Please re-import GMLive script from the asset package if you intend to use live-reload functions.",0);
}
function live_update() {
	/// @ignore
}
function live_async_http(l_e = undefined){
	/// @ignore
}

globalvar live_result; live_result = "GMLive is amiss";
function live_execute_string(l_gml_code){
	/// @ignore
	return false;
}

#region Snippets
function live_snippet_create(l_gml_code,l_name) {
	/// @ignore
	return undefined;
}
function live_snippet_call(l_snippet){
	/// @ignore
	return false;
}
function live_snippet_destroy(l_snippet){
	/// @ignore
}
#endregion

#region Calls
function live_call(){
	/// @ignore
	if(false)show_debug_message(argument[argument_count-1]);
	return false;
}
function live_defcall(){
	/// @ignore
	if(false)show_debug_message(argument[argument_count-1]);
	return false;
}
function live_call_ext(){
	/// @ignore
	if(false)show_debug_message(argument[argument_count-1]);
	return false;
}
function live_defcall_ext(){
	/// @ignore
	if(false)show_debug_message(argument[argument_count-1]);
	return false;
}
#macro live_auto_call {}
globalvar live_name; live_name = "?";
#endregion

#region resources
function live_default_update(l_thing) {
	/// @ignore
}

// Sprites
function sprite_set_live(l_spr,l_live1){}
globalvar live_sprite_updated; live_sprite_updated = live_default_update;

// Paths
function path_set_live(l_ind,l_live1){}
globalvar live_path_updated; live_path_updated = live_default_update;

// Animcurves
function animcurve_set_live(l_curve_id,l_live1,l_bezierIterations){}
globalvar live_animcurve_updated; live_animcurve_updated = live_default_update;

// Rooms
function room_set_live(l_rm,l_enable){}
function room_goto_live(l_rm){
	/// @ignore
	room_goto(l_rm);
}
globalvar live_room_updated; live_room_updated = live_default_update;

// Shaders
function shader_set_live(l_sh,l_live1){}
globalvar live_shader_updated; live_shader_updated = live_default_update;

// Files
function file_set_live(l_path1,l_callback,l_kind){}
#endregion resources

#region API
function live_function_add(l_signature,l_func){}
function live_function_delete(l_name){}
function live_variable_add(l_signature,l_func){}
function live_variable_delete(l_name){}
function live_constant_add(l_name,l_value){}
function live_constant_delete(l_name){}
function live_throw_error(l_text){
	/// @ignore
	show_error(l_text, true);
}
#endregion

#region 2.3
function live_method(l_newSelf,l_func){
	/// @ignore
	return method(l_newSelf, l_func);
}
function live_method_get_self(l_func) {
	/// @ignore
	return method_get_self(l_func);
}
#endregion

#region misc
function gml_func_copy(l_from,l_to) {
	/// @ignore
}
function gml_enum_create_builtin(l_name) {
	/// @ignore
}
function live_script_get_index(l_name) {
	/// @ignore
	return asset_get_index(l_name);
}
#endregion
