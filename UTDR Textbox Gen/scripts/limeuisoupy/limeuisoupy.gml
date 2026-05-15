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
function soupy_message(textarr_ = ["Test", "Test 2"], textbutt_ = "OK", width = 620, height = -1, padd_ = 5, snd_ = snd_dimbox, font_ = fnt_determination, func_ = function(){}, allowmultiple_ = false, scribble_ = false, wrap_ = -1) {
	window_set_cursor(cr_default);
	if ( !allowmultiple_ && !UI_MESSAGE ) { exit; }
	if ( !is_array(textarr_) ) { textarr_ = string_split(textarr_, "|"); }
	sfx_play(snd_);
	var containter_ = new LuiBox({ x: 0, y: 0, }).centerContent().setPositionAbsolute().bringToFront().setFullSize(); //Fullscreen opaque box
	var panel_ = new LuiPanel({ width, height }); //Container 
	var arr_len =  array_length(textarr_), arr_i = 0, arr_arr = [];
	repeat ( arr_len ) {
		array_push(arr_arr, new LuiText({ value: textarr_[arr_i], text_halign: fa_center, text_valign: fa_middle, font: font_, scribbletext: scribble_, wraplimit: wrap_ }).setPadding(padd_));
	arr_i++; }
	
	array_push(arr_arr, new LuiButton({ text: textbutt_, "height": 35, font: font_, }).setData("allowmultiple", allowmultiple_).setData("container", containter_).setData("func", func_).setPadding(padd_)
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
function soupy_popup(elementsarr, func_ = function(){}, textbutt_ = "OK", width = 620, height = -1, padd_ = 5, snd_ = snd_dimbox, font_ = fnt_determination, allowmultiple_ = false, gap_ = 5) {
	window_set_cursor(cr_default);
	if ( !allowmultiple_ && !UI_MESSAGE ) { exit; }
	sfx_play(snd_);
	var containter_ = new LuiBox({ x: 0, y: 0, }).centerContent().setPositionAbsolute().bringToFront().setFullSize(); //Fullscreen opaque box
	var panel_ = new LuiPanel({ width, height }); //Container 
	var arr_arr = elementsarr;	
	array_push(arr_arr, new LuiButton({ text: textbutt_, "height": 35, font: font_, }).setData("allowmultiple", allowmultiple_).setData("container", containter_).setData("func", func_).setPadding(padd_)
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
	soup_store("soupyname", soupyname_);
	soup_store("rgb r", color_get_red(var_)); soup_store("rgb g", color_get_green(var_)); soup_store("rgb b", color_get_blue(var_));
	var clr = new LuiImage({ value: spr_soul, width: 60, height: 48 }).addEvent(LUI_EV_CREATE, function(element_) { soup_store("element spr", element_); element_.setColor(make_color_rgb(soup_checkout("rgb r", false), soup_checkout("rgb g", false), soup_checkout("rgb b", false))); });
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
	
		new LuiButton({ text: "RANDOMIZE", "height": 35, }).addEvent(LUI_EV_CLICK, function () {
			soup_store("rgb r", irandom(255)); soup_store("rgb g", irandom(255)); soup_store("rgb b", irandom(255));
			var rgbr = soup_checkout("element r", false); rgbr.value = soup_checkout("rgb r", false); rgbr.update_values();
			var rgbg = soup_checkout("element g", false); rgbg.value = soup_checkout("rgb g", false); rgbg.update_values();
			var rgbb = soup_checkout("element b", false); rgbb.value = soup_checkout("rgb b", false); rgbb.update_values();
			soup_checkout("element spr", false).setColor(make_color_rgb(soup_checkout("rgb r", false), soup_checkout("rgb g", false), soup_checkout("rgb b", false)));
			sfx_play(snd_throw, 0, , 1.5);
		}),
		new LuiButton({ text: "RESET", "height": 35, }).addEvent(LUI_EV_CLICK, function () {
			soup_store("rgb r", 255); soup_store("rgb g", 255); soup_store("rgb b", 255);
			var rgbr = soup_checkout("element r", false); rgbr.value = soup_checkout("rgb r", false); rgbr.update_values();
			var rgbg = soup_checkout("element g", false); rgbg.value = soup_checkout("rgb g", false); rgbg.update_values();
			var rgbb = soup_checkout("element b", false); rgbb.value = soup_checkout("rgb b", false); rgbb.update_values();
			soup_checkout("element spr", false).setColor(make_color_rgb(soup_checkout("rgb r", false), soup_checkout("rgb g", false), soup_checkout("rgb b", false)));
			sfx_play(snd_hurtpowerful);
		}),
	];
	soupy_popup(elemarr, function() { 
		var myobj = soup_checkout(soup_checkout("soupyname"), false, true); 
		myobj.setColor(make_color_rgb(soup_checkout("rgb r"), soup_checkout("rgb g"), soup_checkout("rgb b"))); myobj.set(spr_face_blank); 
		soup_store_clear(); 
	}, "SET COLOR!");
}
function soupy_color_picker_portrait() { soupy_color_picker(SYSTEMUI.dial_face_clr, "datacolor"); }