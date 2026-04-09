// Prevents the common mistake of accidentally deactivating GMLive, breaking live-reloading
// If you know what you're doing, you can get rid of this
#macro instance_deactivate_all instance_deactivate_all_hook
#macro instance_deactivate_all_base instance_deactivate_all
function instance_deactivate_all_hook(_notme) {
	instance_deactivate_all_base(_notme);
	instance_activate_object(obj_gmlive);
}

#macro instance_deactivate_layer instance_deactivate_layer_hook
#macro instance_deactivate_layer_base instance_deactivate_layer
function instance_deactivate_layer_hook(_layer) {
	instance_deactivate_layer_base(_layer);
	instance_activate_object(obj_gmlive);
}

#macro instance_deactivate_object instance_deactivate_object_hook
#macro instance_deactivate_object_base instance_deactivate_object
function instance_deactivate_object_hook(_object) {
	instance_deactivate_object_base(_object);
	instance_activate_object(obj_gmlive);
}

#macro instance_deactivate_region instance_deactivate_region_hook
#macro instance_deactivate_region_base instance_deactivate_region
function instance_deactivate_region_hook(_left, _top, _width, _height, _inside, _notme) {
	instance_deactivate_region_base(_left, _top, _width, _height, _inside, _notme);
	instance_activate_object(obj_gmlive);
}