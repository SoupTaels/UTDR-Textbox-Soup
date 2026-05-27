///@desc Draw Stacked Sprites
var soupstack_count = array_length(soupstack_spr);
if ( soupstack_count == 0 ) { instance_destroy(); exit; } //Cancel early if there's nothing to draw

var soupstack_i = 0, sprH = sprite_get_height(soupstack_spr[0]) + soupstack_yoff, sprW = sprite_get_width(soupstack_spr[0]) + soupstack_xoff;
var soupstack_width = sprW + ( soupstack_count * ( ( soupstack_i + soupstack_xoff ) * 2 ) ), soupstack_height = ( sprH * soupstack_scale ) * soupstack_count; //Calculate the surface size

if ( !surface_exists(soupstack_surf) ) { soupstack_surf = surface_create(sprW, soupstack_height); } else { 
	try { surface_resize(soupstack_surf, soupstack_width, soupstack_height); }
	catch ( err_ ) {
		//Guestimating the numbers here based on my testing
		if ( soupstack_width >= 3000 ) { soupy_message($"Sorry, but the stack has shifted to an|amount that is too big for this tool to handle!|Shift amount: [c_yellow]{soupstack_xoff}[/] / Surface Width: [c_red]{soupstack_width}[/]|Try a smaller shift amount.", "Damn... That's fine.", 400, , , snd_error, fnt_abaddon, , , true, 590); abort = true; }
		else if ( soupstack_height >= 5000 ) { soupy_message($"Sorry, but the amount of dialogue pages([c_yellow]{soupstack_count}[/])|you have is too much for this tool to handle!|You'll need to split up your dialogue|into smaller exports.|You may also want to try lowering|the stack gap amount.([c_yellow]{soupstack_yoff}[/])", "Damn... That's fine.", 400, , , snd_error, fnt_abaddon, , , true, 590); abort = true; }
		SYSTEMUI.screenshot = false; soup_checkout("finishfunc", , true)(false, true, false); instance_destroy(); exit;
	}
}
surface_set_target(soupstack_surf);
draw_clear_alpha(c_black, 0);

repeat ( soupstack_count ) { 
	draw_sprite_ext(soupstack_spr[soupstack_i], 0, soupstack_xoff * soupstack_i, ( ( sprH * soupstack_scale ) * soupstack_i ) + ( soupstack_yoff * soupstack_i ), soupstack_scale, soupstack_scale, 0, c_white, 1); //Draw dialogue 
soupstack_i++; }

surface_reset_target();
draw_surface_ext(soupstack_surf, 0, 0, 0.5, 0.5, 0, c_white, 1);