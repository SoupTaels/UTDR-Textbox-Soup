#define file_dropper_init
/// file_dropper_init()->bool
var _buf = file_dropper_prepare_buffer(8);
buffer_write(_buf, buffer_u64, int64(window_handle()));
return file_dropper_init_raw(buffer_get_address(_buf), 8);

#define file_dropper_get_allow
/// file_dropper_get_allow()->bool
// no buffer!
return file_dropper_get_allow_raw();

#define file_dropper_set_allow
/// file_dropper_set_allow(allow:bool)
// no buffer!
file_dropper_set_allow_raw(argument0)

#define file_dropper_get_effect
/// file_dropper_get_effect(effect:int)->number
// no buffer!
return file_dropper_get_effect_raw(argument0);

#define file_dropper_set_effect
/// file_dropper_set_effect(effect:int)->number
// no buffer!
return file_dropper_set_effect_raw(argument0);

#define file_dropper_get_default_allow
/// file_dropper_get_default_allow()->bool
// no buffer!
return file_dropper_get_default_allow_raw();

#define file_dropper_set_default_allow
/// file_dropper_set_default_allow(allow:bool)
// no buffer!
file_dropper_set_default_allow_raw(argument0)

#define file_dropper_get_default_effect
/// file_dropper_get_default_effect(effect:int)->number
// no buffer!
return file_dropper_get_default_effect_raw(argument0);

#define file_dropper_set_default_effect
/// file_dropper_set_default_effect(effect:int)->number
// no buffer!
return file_dropper_set_default_effect_raw(argument0);

