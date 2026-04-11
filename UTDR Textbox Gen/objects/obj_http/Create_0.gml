/// @description 
//gml_pragma("global","instance_create_depth(0,0,0,obj_http);");

if (instance_number(object_index) > 1) {
	instance_destroy();	 // THERE CAN ONLY BE ONE
}
active = false;
requests = ds_map_create();
