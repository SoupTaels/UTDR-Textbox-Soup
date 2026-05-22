///@desc Displays a LimeUI message box accepting arrays for text, blocking ui
///@param {string} textarr_ Text
///@param {string} textbutt_ Text Button
///@param {real} width Width
///@param {real} height Height
///@param {real} padd_ Padding
///@param {Asset.GMSound} snd_ Sound
///@param {Asset.GMFont} font_ Text Font
///@param {function} func_ Function to run
///@param {bool} allowmultiple_ Whether to allow multiple popups
///@param {bool} scribble_ Whether to render text as a Scribble class (performance penalty)
///@param {real} wrap_ Maximum text on a line before a line break
///@param {real} heightb Height Button
function soupy_message(textarr_ = ["Test", "Test 2"], textbutt_ = "OK", width = 620, height = -1, padd_ = 5, snd_ = snd_dimbox, font_ = fnt_determination, func_ = function(){}, allowmultiple_ = false, scribble_ = false, wrap_ = -1, heightb = 35, valign_ = fa_center) {
	window_set_cursor(cr_default);
	if ( !allowmultiple_ && !UI_MESSAGE ) { exit; }
	if ( !is_array(textarr_) ) { textarr_ = string_split(textarr_, "|"); }
	sfx_play(snd_);
	var containter_ = new LuiBox({ x: 0, y: 0, }).centerContent().setPositionAbsolute().bringToFront().setFullSize(); //Fullscreen opaque box
	var panel_ = new LuiPanel({ width, height }); //Container 
	var arr_len =  array_length(textarr_), arr_i = 0, arr_arr = [];
	repeat ( arr_len ) {
		array_push(arr_arr, new LuiText({ value: textarr_[arr_i], text_halign: fa_center, text_valign: valign_, font: font_, scribbletext: scribble_, wraplimit: wrap_ }).setPadding(padd_));
	arr_i++; }
	
	array_push(arr_arr, new LuiButton({ text: textbutt_, "height": heightb, font: font_, }).setData("allowmultiple", allowmultiple_).setData("container", containter_).setData("func", func_).setPadding(padd_)
	.addEvent(LUI_EV_CLICK, function (element_) { 
		var allowmultiple = element_.getData("allowmultiple"); SYSTEMUI.ui_paused = allowmultiple;
		var myfunc = element_.getData("func"); myfunc(); 
		var maincan = element_.getData("container"); maincan.destroy(); }));
	panel_.addContent([
		new LuiColumn().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.flex_end).addContent(arr_arr),
	]);
	SYSTEMUI.soupy_lui.addContent(containter_.addContent(panel_));
	SYSTEMUI.ui_paused = true;
	return containter_;
}

///@desc Displays a LimeUI popup box accepting arrays for LimeUI elements.
///@param {string} elementsarr An array containing elements to be pushed into this popup
///@param {function} func_ Function to run
///@param {string} textbutt_ Text Button
///@param {real} width Width
///@param {real} height Height
///@param {real} padd_ Padding
///@param {Asset.GMSound} snd_ Sound
///@param {Asset.GMFont} font_ Text Font
///@param {bool} allowmultiple_ Whether to allow multiple popups
///@param {real} gap_ Gap
///@param {real} heightb Height Button
function soupy_popup(elementsarr, func_ = function(){}, textbutt_ = "OK", width = 620, height = -1, padd_ = 5, snd_ = snd_dimbox, font_ = fnt_determination, allowmultiple_ = false, gap_ = 5, heightb = 35) {
	window_set_cursor(cr_default);
	if ( !allowmultiple_ && !UI_MESSAGE ) { exit; }
	sfx_play(snd_);
	var containter_ = new LuiBox({ x: 0, y: 0, }).centerContent().setPositionAbsolute().bringToFront().setFullSize(); //Fullscreen opaque box
	var panel_ = new LuiPanel({ width, height }); //Container 
	var arr_arr = elementsarr;	
	array_push(arr_arr, new LuiButton({ text: textbutt_, "height": heightb, font: font_, }).setData("allowmultiple", allowmultiple_).setData("container", containter_).setData("func", func_).setPadding(padd_)
	.addEvent(LUI_EV_CLICK, function (element_) { 
		var allowmultiple_ = element_.getData("allowmultiple"); SYSTEMUI.ui_paused = allowmultiple_;
		var myfunc = element_.getData("func"); myfunc();
		var maincan = element_.getData("container"); maincan.destroy(); }));
	panel_.addContent([
		new LuiColumn().setGap(gap_).setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.flex_end).addContent(arr_arr),
	]);
	SYSTEMUI.soupy_lui.addContent(containter_.addContent(panel_));
	SYSTEMUI.ui_paused = true;
	return containter_;
}

///@desc Open LimeUI color picker
function soupy_color_picker(var_, soupyname_) {
	if ( !soup_store_undefined("colorhistory", true) ) { soup_store("colorhistory", [], , true); }
	soup_store("soupyname", soupyname_);
	soup_store("rgb r", color_get_red(var_)); soup_store("rgb g", color_get_green(var_)); soup_store("rgb b", color_get_blue(var_));
	var clr = new LuiImage({ value: spr_soul, width: 60, height: 48 }).setTooltip("Don't want to use the sliders?\nClick here to open a color picker instead.", true).addEvent(LUI_EV_CREATE, function(element_) { soup_store("element spr", element_); element_.setColor(make_color_rgb(soup_checkout("rgb r", false), soup_checkout("rgb g", false), soup_checkout("rgb b", false))); });
	clr.addEvent(LUI_EV_CLICK, function () { //Open color picker
		sfx_play(snd_bump);
		var result = get_color_ext(c_white, "Pick a new color!"); if ( result < 0 ) { result = c_white; } 
		soup_store("rgb r", color_get_red(result)); soup_store("rgb g", color_get_green(result)); soup_store("rgb b", color_get_blue(result));
		soup_checkout("colormain")(); soup_checkout("colorcan", true, true).destroy(); SYSTEMUI.ui_paused = false; sfx_play(snd_equip2, , , 1.3);
	});
	
	var elemarr = [
		new LuiText({ value: "   <- Your chosen color", text_halign: fa_center, text_valign: fa_middle, scale_x: 2, }).addContent(clr),
	
		new LuiSlider({ value: soup_checkout("rgb r", false), min_value: 0, max_value: 255, rounding: true, display_value: true, bar_sprite: spr_border_header, bar_sprite_back: spr_border_header, bar_color: c_maroon, bar_color_back: c_maroon, }).setData("clr", clr).addEvent(LUI_EV_VALUE_UPDATE, function(element_) { 
			var getclr = element_.getData("clr"), rgbg = soup_checkout("rgb g", false), rgbb = soup_checkout("rgb b", false);
			soup_store("rgb r", element_.value);
			getclr.setColor(make_color_rgb(soup_checkout("rgb r", false), rgbg, rgbb));
		}).addEvent(LUI_EV_CREATE, function(element_) { soup_store("element r", element_); }),
	
		new LuiSlider({ value: soup_checkout("rgb g", false), min_value: 0, max_value: 255, rounding: true, display_value: true, bar_sprite: spr_border_header, bar_sprite_back: spr_border_header, bar_color: c_green, bar_color_back: c_green, }).setData("clr", clr).addEvent(LUI_EV_VALUE_UPDATE, function(element_) { 
			var getclr = element_.getData("clr"), rgbr = soup_checkout("rgb r", false), rgbb = soup_checkout("rgb b", false);
			soup_store("rgb g", element_.value);
			getclr.setColor(make_color_rgb(rgbr, soup_checkout("rgb g", false), rgbb));
		}).addEvent(LUI_EV_CREATE, function(element_) { soup_store("element g", element_); }),
	
		new LuiSlider({ value: soup_checkout("rgb b", false), min_value: 0, max_value: 255, rounding: true, display_value: true, bar_sprite: spr_border_header, bar_sprite_back: spr_border_header, bar_color: c_navy, bar_color_back: c_navy, }).setData("clr", clr).addEvent(LUI_EV_VALUE_UPDATE, function(element_) { 
			var getclr = element_.getData("clr"), rgbr = soup_checkout("rgb r", false), rgbg = soup_checkout("rgb g", false);
			soup_store("rgb b", element_.value);
			getclr.setColor(make_color_rgb(rgbr, rgbg, soup_checkout("rgb b", false)));
		}).addEvent(LUI_EV_CREATE, function(element_) { soup_store("element b", element_); }),
	];
	
	#region Color History
		var hist_ = soup_checkout("colorhistory", false, true), hist_len = array_length(hist_), hist_i = 0, hist_clrs = [];
		if ( hist_len > 0 ) {
			repeat ( hist_len ) {
			var cur_ = hist_[hist_i];
				array_push(hist_clrs, new LuiImageButton({ value: spr_pixel, maintain_aspect: false, color: cur_ }).setSize(20, 20)
				.addEvent(LUI_EV_CLICK, function (e_) {
					soup_store("rgb r", color_get_red(e_.color_blend)); soup_store("rgb g", color_get_green(e_.color_blend)); soup_store("rgb b", color_get_blue(e_.color_blend));
					var rgbr = soup_checkout("element r", false); rgbr.value = soup_checkout("rgb r", false); rgbr.update_values();
					var rgbg = soup_checkout("element g", false); rgbg.value = soup_checkout("rgb g", false); rgbg.update_values();
					var rgbb = soup_checkout("element b", false); rgbb.value = soup_checkout("rgb b", false); rgbb.update_values();
					soup_checkout("element spr", false).setColor(make_color_rgb(soup_checkout("rgb r", false), soup_checkout("rgb g", false), soup_checkout("rgb b", false)));
					e_.main_ui.animate(e_, "xscale", 0, 1, global.Ease.OutElastic, 4); e_.main_ui.animate(e_, "yscale", 0, 1, global.Ease.OutElastic, -2);
					sfx_play(snd_bump, , , 1.3);
				}) );
			hist_i++; }
		
			array_push(elemarr, new LuiRow().setFlexGrow(1).centerContent().addContent(hist_clrs));
		}
	#endregion
	
	#region Add Default Options
	array_push(elemarr, 
		new LuiButton({ text: "RANDOMIZE", "height": 35, }).addEvent(LUI_EV_CLICK, function () {
			soup_store("rgb r", irandom(255)); soup_store("rgb g", irandom(255)); soup_store("rgb b", irandom(255));
			var rgbr = soup_checkout("element r", false); rgbr.value = soup_checkout("rgb r", false); rgbr.update_values();
			var rgbg = soup_checkout("element g", false); rgbg.value = soup_checkout("rgb g", false); rgbg.update_values();
			var rgbb = soup_checkout("element b", false); rgbb.value = soup_checkout("rgb b", false); rgbb.update_values();
			soup_checkout("element spr", false).setColor(make_color_rgb(soup_checkout("rgb r", false), soup_checkout("rgb g", false), soup_checkout("rgb b", false)));
			sfx_play(snd_throw, 0, , 1.5);
		}),
		new LuiButton({ text: "RESET", "height": 35, }).addEvent(LUI_EV_CLICK, function () {
			var def_ = soup_checkout(soup_checkout("soupyname", false), false, true).color_default;
			soup_store("rgb r", color_get_red(def_)); soup_store("rgb g", color_get_green(def_)); soup_store("rgb b", color_get_blue(def_));
			var rgbr = soup_checkout("element r", false); rgbr.value = soup_checkout("rgb r", false); rgbr.update_values();
			var rgbg = soup_checkout("element g", false); rgbg.value = soup_checkout("rgb g", false); rgbg.update_values();
			var rgbb = soup_checkout("element b", false); rgbb.value = soup_checkout("rgb b", false); rgbb.update_values();
			soup_checkout("element spr", false).setColor(make_color_rgb(soup_checkout("rgb r", false), soup_checkout("rgb g", false), soup_checkout("rgb b", false)));
			sfx_play(snd_hurtpowerful);
		}),
	);
	#endregion
	
	soup_store("colormain", function() { 
		var myobj = soup_checkout(soup_checkout("soupyname"), false, true); 
		myobj.setColor(make_color_rgb(soup_checkout("rgb r"), soup_checkout("rgb g"), soup_checkout("rgb b"))); myobj.set(spr_face_blank);
		var hist_ = soup_checkout("colorhistory", false, true), hist_len = array_length(hist_);
		if ( hist_len < 15 ) { if ( !array_contains(hist_, myobj.color_blend) ) { array_push(hist_, myobj.color_blend); } } else { array_delete(hist_, 0, 1); array_push(hist_, myobj.color_blend); } //Add color to history
		soup_store_clear(); 
	});
	var maincan = soupy_popup(elemarr, soup_checkout("colormain", false), "SET COLOR!"); soup_store("colorcan", maincan, , true);
}
function soupy_color_picker_portrait() { soupy_color_picker(SYSTEMUI.dial_face_clr, "datacolor"); }
function soupy_color_picker_gifcolor() { soupy_color_picker(SYSTEMUI.screenshot_back, "datagifcolor"); }
function soupy_color_picker_border() { soupy_color_picker(SYSTEMUI.bord_clr, "dataimageB"); }
function soupy_color_picker_asterisk() { soupy_color_picker(SYSTEMUI.dial_point_clr, "dataasterisk"); }
function soupy_color_picker_textc() { soupy_color_picker(SYSTEMUI.dial_text_c, "datatextc"); } function soupy_color_picker_textcout() { soupy_color_picker(SYSTEMUI.dial_text_outline, "datatextcout"); }
function soupy_color_picker_shadow() { soupy_color_picker(SYSTEMUI.dial_text_shdw_clr, "datashadow"); }

function soupy_ui_credits() {
	var arr_ = [];
	var credits_add = method({ arr_ }, function(text_ = "", link_ = "", scribble_ = false) {
		array_push(arr_, new LuiText({ scribbletext: scribble_, value: text_, text_halign: fa_center, text_valign: fa_middle, font: fnt_abaddon, color: c_white, xoff: 0, y: 10 }).setData("link", link_).setTooltip(link_, true, fnt_abaddon).setPadding(5)
		.addEvent(LUI_EV_CLICK, function(element_) { var link_ = element_.getData("link"); if ( link_ != "" ) { sfx_play(snd_select); execute_shell_simple(link_, , , 0); } })
		.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { var link_ = element_.getData("link"); if ( link_ != "" ) { element_.color = c_cyan; sfx_play(snd_sel_switch); element_.main_ui.animate(element_, "xoff", 10, 0.30, global.Ease.OutBack, 0); } })
		.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }));
	});
	
	var ico_ = get_icon("gameico", "size"); array_push(arr_, new LuiImage({ value: ico_.sprite, }).setFlexAlignSelf(flexpanel_align.center).setSize(ico_.width * 3, ico_.height * 3)); 
	credits_add("[scale,2]UTDR [c_gold]SoupGen[/c] [c_red]BETA[/c] v0.0.2", , true);
	credits_add();
	credits_add("[c_yellow][wobble]Credits:", , true);
	credits_add(".+\\/\\/\\_______________________________________________/\\/\\/+.");
	credits_add();
	credits_add("Scribble, Clean Shapes, Gumshoe: [slant][c_gold]JujuAdams", "https://github.com/JujuAdams", true);
	credits_add("GMLive, ExecuteShellSimple, FileDropper: [slant][c_gold]YellowAfterlife", "https://yal.cc/", true);
	credits_add("TweenGMX: [slant][c_gold]stephenloney", "https://stephenloney.com/", true);
	credits_add("Undo Stack: [slant][c_gold]alphish-creature(Alice)", "https://github.com/Alphish", true);
	credits_add("LimeUI: [slant][c_gold]Limekys", "https://github.com/Limekys", true);
	credits_add("Quill: [slant][c_gold]RefresherTowelGames", "https://github.com/RefresherTowel", true);
	credits_add("DialogModule, FileManager: [slant][c_gold]Samuel Venable", "https://itch.io/profile/samuel-venable", true);
	credits_add("Accurate Determination, Sans, and Papyrus fonts: [slant][c_gold]emihead", "https://twitter.com/emihead", true);
	credits_add("Undertale, Deltarune: [slant][c_gold]Toby Fox[/] [annoyingdog,0,0.15], [slant][c_gold]Temmie Chang[/] [annoyingtem,0,0.15]", "https://undertale.com/about/", true);
	credits_add("Made in [slant][c_gold]GameMaker[/] [scale,0.15][gamemaker][/]", "https://gamemaker.io/", true);
	credits_add();
	credits_add("Huge thanks to [rainbow][wheel]Juju Adams[/][wheel] [scale,0.3][jujugoodpug][/] especially as this wouldn't\nhave been possible without his tools!", , true);
	credits_add();
	credits_add("Happy generating by yours truly, [slant][c_gold]Soup Taels!", "https://souptaels.carrd.co/", true);
	array_push(arr_, new LuiRow().setFlexJustifyContent(flexpanel_justify.center).addContent([
		new LuiImage({ value: spr_soul, color: #ed4577, draw_normal: true, y: 10 }).setSize(20, 16).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 1, 0.15, , 1.3); element_.main_ui.animate(element_, "yscale", 1, 0.15, , 1.3); sfx_play(snd_bump); }),
		new LuiImage({ value: get_icon("tinysoupy"), draw_normal: true, y: 10 }).setSize(19, 19).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 1, 0.15, , 0.5); element_.main_ui.animate(element_, "yscale", 1, 0.15, , 1.5); sfx_play(snd_squish); }),
		new LuiImage({ value: spr_soul, color: #ed4577, draw_normal: true, y: 10 }).setSize(20, 16).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 1, 0.15, , 1.3); element_.main_ui.animate(element_, "yscale", 1, 0.15, , 1.3); sfx_play(snd_bump); }),
	]));

	var maincan = new LuiScrollPanel({ sprite_panel: false, scroll_slider_width: 10, height: 390, }).addContent(arr_);
	soupy_popup([ maincan, ], , "What lovely people!", , 460, , snd_chest, fnt_abaddon, , , 40); //Credits with clickable text links
}