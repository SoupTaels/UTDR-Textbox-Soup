///@desc Displays a LimeUI message box accepting arrays for text, blocking ui
///@param {string} textarr_ Text
///@param {string} textbutt_ Text Button
///@param {real} width Width
///@param {real} height Height
///@param {real} padd_ Padding
///@param {Asset.GMSound} snd_ Sound
///@param {Asset.GMFont} font_ Text Font
function soupy_message(textarr_ = ["Test", "Test 2"], textbutt_ = "OK", width = 620, height = -1, padd_ = 5, snd_ = snd_dimbox, font_ = fnt_determination, func_ = function(){}, allowmultiple_ = false) {
	window_set_cursor(cr_default);
	if ( !UI_MESSAGE ) { exit; }
	if ( !is_array(textarr_) ) { textarr_ = string_split(textarr_, "|"); }
	sfx_play(snd_);
	var containter_ = new LuiBox({ x: 0, y: 0, }).centerContent().setPositionAbsolute().bringToFront().setFullSize(); //Fullscreen opaque box
	var panel_ = new LuiPanel({ width, height }); //Container 
	var arr_len =  array_length(textarr_), arr_i = 0, arr_arr = [];
	repeat ( arr_len ) {
		array_push(arr_arr, new LuiText({ value: textarr_[arr_i], text_halign: fa_center, text_valign: fa_middle, font: font_, }).setPadding(padd_));
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
function soupy_popup(elementsarr, func_ = function(){}, textbutt_ = "OK", width = 620, height = -1, padd_ = 5, snd_ = snd_dimbox, font_ = fnt_determination, allowmultiple_ = false) {
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
		new LuiColumn().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.flex_end).addContent(arr_arr),
	]);
	SYSTEMUI.soupy_lui.addContent(containter_.addContent(panel_));
	SYSTEMUI.ui_paused = true;
}