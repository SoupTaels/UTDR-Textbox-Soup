///@desc 
if ( visible && mouse_released && ( range_within(mouse_x_gui, 0, 640) && range_within(mouse_y_gui, -40, 0) ) ) { soup_store("androidexport", , , true); }

visible = ( !SYSTEMUI.record.enabled && !SYSTEMUI.screenshot && !instance_exists(obj_errhandler) );