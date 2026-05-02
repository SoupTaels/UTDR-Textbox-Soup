///@desc Displays a LimeUI message box, blocking ui
///@param {string} message_ Text
///@param {Asset.GMSound} snd_ Sound
///@param {real} height_ Height
///@param {real} y_ Text Y
function soupy_message(message_, snd_ = snd_error, height_ = 50, y_ = 10) { 
	window_set_cursor(cr_default);
	sfx_play(snd_);
	if ( UI_MESSAGE ) { obj_system.ui_message = luiShowMessage(obj_system.soupy_lui, , , message_, , y_); obj_system.ui_message.setHeight(height_); }
}

///@desc Displays a LimeUI message box accepting arrays for text, blocking ui
///@param {string} textarr_ Text
///@param {string} textbutt_ Text Button
///@param {real} width Width
///@param {real} height Height
///@param {real} padd_ Padding
///@param {Asset.GMSound} snd_ Sound
///@param {Asset.GMFont} font_ Text Font
function soupy_message_ext(textarr_ = ["Test", "Test 2"], textbutt_ = "OK", width = 620, height = -1, padd_ = 5, snd_ = snd_dimbox, font_ = fnt_determination) {
	window_set_cursor(cr_default);
	if ( !UI_MESSAGE ) { exit; }
	
	sfx_play(snd_);
	var containter_ = new LuiBox({ x: 0, y: 0, }).centerContent().setPositionAbsolute().bringToFront().setFullSize(); //Fullscreen opaque box
	var panel_ = new LuiPanel({ width, height }); //Container 
	var arr_len =  array_length(textarr_), arr_i = 0, arr_arr = [];
	repeat ( arr_len ) {
		array_push(arr_arr, new LuiText({ value: textarr_[arr_i], text_halign: fa_center, text_valign: fa_middle, font: font_, }).setPadding(padd_));
	arr_i++; }
	
	array_push(arr_arr, new LuiButton({ text: textbutt_, "height": 35, font: font_, }).setData("container", containter_).setPadding(padd_).addEvent(LUI_EV_CLICK, function (element_) { var maincan = element_.getData("container"); maincan.destroy(); obj_system.ui_message.is_destroyed = true; }));
	panel_.addContent([
		new LuiColumn().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.flex_end).addContent(arr_arr),
	]);
	soupy_lui.addContent(containter_.addContent(panel_));
	ui_message.is_destroyed = false;
}