soup_store("rgb r", color_get_red(bord_clr)); soup_store("rgb g", color_get_green(bord_clr)); soup_store("rgb b", color_get_blue(bord_clr));
var clr = new LuiImage({ value: spr_soul, width: 60, height: 48 }).addEvent(LUI_EV_CREATE, function(element_) { soup_store("element spr", element_); element_.setColor(make_color_rgb(soup_checkout("rgb r", false), soup_checkout("rgb g", false), soup_checkout("rgb b", false))); });
var elemarr = [
	new LuiText({ value: "   <- New dialogue border color", text_halign: fa_center, text_valign: fa_middle, scale_x: 2, }).addContent(clr),
	
	new LuiSlider({ value: soup_checkout("rgb r", false), min_value: 0, max_value: 255, rounding: true, display_value: true, bar_sprite: spr_pixel, bar_sprite_back: spr_pixel, bar_color: c_maroon, bar_color_back: c_maroon, }).setData("clr", clr).addEvent(LUI_EV_VALUE_UPDATE, function(element_) { 
		var getclr = element_.getData("clr"), rgbg = soup_checkout("rgb g", false), rgbb = soup_checkout("rgb b", false);
		soup_store("rgb r", element_.value);
		getclr.setColor(make_color_rgb(soup_checkout("rgb r", false), rgbg, rgbb));
	}).addEvent(LUI_EV_CREATE, function(element_) { soup_store("element r", element_); }),
	
	new LuiSlider({ value: soup_checkout("rgb g", false), min_value: 0, max_value: 255, rounding: true, display_value: true, bar_sprite: spr_pixel, bar_sprite_back: spr_pixel, bar_color: c_green, bar_color_back: c_green, }).setData("clr", clr).addEvent(LUI_EV_VALUE_UPDATE, function(element_) { 
		var getclr = element_.getData("clr"), rgbr = soup_checkout("rgb r", false), rgbb = soup_checkout("rgb b", false);
		soup_store("rgb g", element_.value);
		getclr.setColor(make_color_rgb(rgbr, soup_checkout("rgb g", false), rgbb));
	}).addEvent(LUI_EV_CREATE, function(element_) { soup_store("element g", element_); }),
	
	new LuiSlider({ value: soup_checkout("rgb b", false), min_value: 0, max_value: 255, rounding: true, display_value: true, bar_sprite: spr_pixel, bar_sprite_back: spr_pixel, bar_color: c_navy, bar_color_back: c_navy, }).setData("clr", clr).addEvent(LUI_EV_VALUE_UPDATE, function(element_) { 
		var getclr = element_.getData("clr"), rgbr = soup_checkout("rgb r", false), rgbg = soup_checkout("rgb g", false);
		soup_store("rgb b", element_.value);
		getclr.setColor(make_color_rgb(rgbr, rgbg, soup_checkout("rgb b", false)));
	}).addEvent(LUI_EV_CREATE, function(element_) { soup_store("element b", element_); }),
	
	new LuiButton({ text: "RANDOMIZE" }).addEvent(LUI_EV_CLICK, function () {
		soup_store("rgb r", irandom(255)); soup_store("rgb g", irandom(255)); soup_store("rgb b", irandom(255));
		var rgbr = soup_checkout("element r", false); rgbr.value = soup_checkout("rgb r", false); rgbr.update_values();
		var rgbg = soup_checkout("element g", false); rgbg.value = soup_checkout("rgb g", false); rgbg.update_values();
		var rgbb = soup_checkout("element b", false); rgbb.value = soup_checkout("rgb b", false); rgbb.update_values();
		soup_checkout("element spr", false).setColor(make_color_rgb(soup_checkout("rgb r", false), soup_checkout("rgb g", false), soup_checkout("rgb b", false)));
		sfx_play(snd_throw, 0, , 1.5);
	}),
];
soupy_popup(elemarr, function() { sfx_play(snd_equip); obj_system.bord_clr = make_color_rgb(soup_checkout("rgb r"), soup_checkout("rgb g"), soup_checkout("rgb b")); soup_store_clear(); }, "SET COLOR!");
//bord_clr = get_color_ext(c_white, "Change dialogue box color:");
/*soupy_message([ "Credits:", ".+\\/\\/\\_______________________________________________/\\/\\/+.", "", "Scribble, Clean Shapes, Gumshoe: JujuAdams", "GMLive, ExecuteShellSimple, FileDropper: YellowAfterlife", "TweenGMX: stephenloney", 
	"Undo Stack: alphish-creature(Alice)", "LimeUI: Limekys", "Quill: RefresherTowelGames", "Undertale, Deltarune: Toby Fox, Temmie Chang", "Happy generating by yours truly, Soup Taels!", "", "Huge thanks to JujuAdams especially as this wouldn't", "have be possible without his tools!" ], 
	"Cool!", , , , , fnt_abaddon);