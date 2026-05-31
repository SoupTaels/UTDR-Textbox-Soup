///@desc
var soupstack_count = array_length(soupstack_spr), soupstack_i = 0;
if ( soupstack_count == 0 ) { exit; } //Cancel early if there's nothing to draw

if ( !abort ) { surface_save(soupstack_surf, soupstack_path); } //Save everything drawn to this surface, aka our stack of sprites
with ( SYSTEMUI ) { dial_text_page = 0; }

repeat ( soupstack_count ) { 
	sprite_delete(soupstack_spr[soupstack_i]); show_debug_message("Deleted sprite stack {0}/ {1}", soupstack_i, soupstack_count - 1);
soupstack_i++; } //Delete all the sprites

surface_free(soupstack_surf); //Free surface to prevent memory leaks
MobileUtils_Vibrate_Shot(100);
if ( !abort ) { 
	soupy_message($"{soupstack_fname}_.png[/] [rainbow][wave]saved at[/]| |[c_lime]{soupstack_path}![/]| |Your [c_gold]good soup[/] is ready!|The file path was [c_yellow]copied to your clipboard[/]{ global.pref.openresult ? " and|the result will open up in your [c_cyan]default image viewer[/]" : ""}.| |Please share your dialogue with [c_gold]#soupgen[/] for easier find!", "I'm so soupy!!", , , , snd_dumbvictory, fnt_abaddon, , , true, 590);
	if ( global.pref.openresult ) {
		if ( !is_android() ) { 
			soupy_url($"{executable_get_directory()}{soupstack_folder}", , , 6); //Open the directory (Windows only)
			soupy_url(soupstack_path, , , 6); //Open the image in the PC's default photo viewer (Windows only)
		}
		else { file_copy(soupstack_path, $"{soupstack_fname}_.png"); MobileUtils_Share_Open("Here's your good soup!", "image/png", $"{soupstack_fname}_.png"); }
	}
	clipboard_set_text(soupstack_path);
}