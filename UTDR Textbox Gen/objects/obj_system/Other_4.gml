///@desc Systems
var tinysoup = "icons\\tinysoupy.png"; if ( file_exists(tinysoup) ) { widget_set_icon(tinysoup); }
undo_stack_create(); //History of undo changes
file_dropper_init(); //Handle file dropping
scribble_font_set_default("fnt_determination_nomono");