///@desc Show message with custom message text and button text
///@arg {Struct.LuiMain} ui
///@arg {Real} width
///@arg {Real} height
///@arg {String} message_text
///@arg {String} button_text
function luiShowMessage(ui, width = LUI_AUTO, height = LUI_AUTO, message_text = "", button_text = "OK") {
	// Black block area
	var _box_message_screen = new LuiBox({x: 0, y: 0})
		.centerContent()
		.setPositionAbsolute()
		.bringToFront()
		.setFullSize();
	// Message panel
	var _content_width = width;
	var _panel_min_width = 256;
	if _content_width == LUI_AUTO {
		draw_set_font(ui.style.font_default);
		_content_width = max(_panel_min_width, max(string_width(message_text), string_width(button_text)) + ui.style.padding * 2);
	}
	var _container = new LuiColumn();
	var _panel = new LuiPanel({width: _content_width, height});
	// Text
	var _txt_message = new LuiText({value: message_text}).setTextHalign(fa_center);
	// Button
	var _btn_close = new LuiButton({text: button_text}).setData("message_screen", _box_message_screen);
	_btn_close.addEvent(LUI_EV_CLICK, function(_element) {
		var _message_screen = _element.getData("message_screen");
		_message_screen.destroy();
	});
	// Build message screen
	ui.addContent([
		_box_message_screen.addContent([
			_panel.addContent([
				_container.addContent([
					_txt_message
				]),
				new LuiColumn().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.flex_end).addContent([
					_btn_close
				])
			])
		])
	]);
	return _container;
}