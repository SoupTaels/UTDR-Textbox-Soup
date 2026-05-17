///@desc 
if ( keyboard_check_pressed(vk_enter) ) {
	sfx_play(snd_enc1);
	scribble_anim_shake(2, 0.4);
	instance_destroy();
	instance_activate_object(SYSTEMUI);
}