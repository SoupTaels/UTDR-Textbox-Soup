///@desc 
///@desc Update Check
//if ( live_call() ) { return live_result; }
if ( !global.pref.checkupdates ) { instance_destroy(); exit; }
updateversion = {}; //The new update's info
text = "[c_yellow]Checking for update... [spr_effects_icons,14]";
text_y = 15;
active = false;

failedfunc = function() { //Failed connection, abort...
	text = $"[#f73e7e][shake]Can't check for updates.";
	var tween = TweenFire("$15", "~ocirc", "text_y", 25, 15);
	TweenMore(tween, "$60", "+75", "~iback", "text_y>", -50, "@", instance_destroy);
	sfx_play(snd_error);
	active = true;
	exit;
}

if ( os_is_network_connected(true) ) {
	var updateurl = "https://raw.githubusercontent.com/SoupTaels/UTDR-Textbox-Soup/refs/heads/main/SOUP"; //Link to check for updates

	http(updateurl, , , , function(status, result) { //We got connected!
		if ( real(status) >= 400 ) { failedfunc(); exit; } //If there's internet, but maybe the content wasn't found, the website is down, or whatever else, let's just assume a connection fail anyways.
		
		updateversion = json_parse(result); //Turn JSON string into valid JSON data
		var currversion = string_split(GAME_VERSION, "."); //Split the version numbers into separate arrays
		var newversion = string_split(updateversion.game_version, ".");
		
		for ( var i = 0; i < 3; i++; ) { //If any number in the array is higher than our current version, it must mean there's a new update available! Otherwise, no update needed
			var c_real = real(currversion[i]);
			var n_real = real(newversion[i]);
			if ( n_real > c_real ) { //New update available! Go to the update room
				var arr_ = [
					new LuiImage({ value: get_icon("gameico"), maintain_aspect: false, }).setSize(120, 120).setFlexAlignSelf(flexpanel_align.center).addEvent(LUI_EV_CLICK, function(e_) { e_.main_ui.animate(e_, "xscale", 1, 0.3, global.Ease.OutBack, 12); e_.main_ui.animate(e_, "yscale", 1, 0.3, global.Ease.OutBack, -6); sfx_play(snd_squish); }),
					new LuiText({ value: "There's a [rainbow]new update available![/] [tinysoupy]", font: fnt_abaddon, scribbletext: true, }),
					new LuiText({ value: $"Current Version: [c_yellow]{GAME_VERSION}[/] | New Version: [c_lime]{updateversion.game_version}", font: fnt_abaddon, scribbletext: true, }),
					new LuiText({ value: "Would you like to update now?", font: fnt_abaddon, }),
					new LuiButton({ text: "Time for some new soup!", height: 35, font: fnt_abaddon, }).setData("link", updateversion.game_page).addEvent(LUI_EV_CLICK, function(e_) { execute_shell_simple(e_.getData("link"), , , 0); }),
				];
				soupy_popup(arr_, , "Gotta generate smth rq.", , , , snd_dimbox, fnt_abaddon, SYSTEMUI.ui_paused);
				instance_destroy();
				exit;
			}
		}
		
		#region We're good! No updates needed
			text = $"[tinysoupy] [rainbow][wheel]You have the latest version([/][c_yellow]{updateversion.game_version}[/][rainbow][wheel])! [/][tinysoupy]";
			var tween = TweenFire("$15", "~ocirc", "text_y", 25, 15);
			TweenMore(tween, "$60", "+75", "~iback", "text_y>", -50, "@", instance_destroy);
			sfx_play(snd_updated); active = true;
		#endregion
	}, function() { failedfunc(); }); //If the OS is connected, but something failed along the way, assume a failed connection.
}
else { failedfunc(); } //OS isn't connected.