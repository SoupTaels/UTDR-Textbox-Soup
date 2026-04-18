///@desc Works like checkbox or switch, lights with accent color when value true
/// Available parameters:
/// text
/// color
/// value
///@arg {Struct} [_params] Struct with parameters
function LuiToggleButton(_params = {}) : LuiButton(_params) constructor {
	
	self.value = _params[$ "value"] ?? false;
	
	self.draw = function() {
		
		// Calculate colors
		var _blend_color = self.value == true ? self.style.color_accent : (!is_undefined(self.button_color) ? self.button_color : self.style.color_secondary);
		var _blend_text = self.style.color_text;
		if self.deactivated {
			_blend_color = merge_color(_blend_color, c_black, 0.5);
			_blend_text = merge_color(_blend_text, c_black, 0.5);
		} else if self.isMouseHovered() {
			_blend_color = merge_color(_blend_color, self.style.color_hover, 0.5);
			if self.is_pressed {
				_blend_color = merge_color(_blend_color, c_black, 0.5);
			}
		}
		
		// Calculate positions
		var _center_x = self.x + self.width / 2;
		var _center_y = self.y + self.height / 2;
		
		// Base
		if !is_undefined(self.style.sprite_button) {
			draw_sprite_stretched_ext(self.style.sprite_button, 0, self.x, self.y, self.width, self.height, _blend_color, 1);
		}
		
		// Icon and text
		_drawIconAndText(_center_x, _center_y, self.width, _blend_text);
		
		// Border
		if !is_undefined(self.style.sprite_button_border) {
			draw_sprite_stretched_ext(self.style.sprite_button_border, 0, self.x, self.y, self.width, self.height, self.style.color_border, 1);
		}
	}
	
	self.addEvent(LUI_EV_CLICK, function(_element) {
		_element.set(!_element.get());
	});
}