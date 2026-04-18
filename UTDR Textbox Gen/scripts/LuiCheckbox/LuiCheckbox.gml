///@desc A button with a boolean value, either marked or unmarked.
/// Available parameters:
/// value
/// text
///@arg {Struct} [_params] Struct with parameters
function LuiCheckbox(_params = {}) : LuiBase(_params) constructor {
	
	self.value = _params[$ "value"] ?? false;
	self.text = _params[$ "text"] ?? "";
	
	///@desc Set display text of checkbox (render right of checkbox)
	///@arg {string} _text
	static setText = function(_text) {
		self.text = _text;
		return self;
	}
	
	self.draw = function() {
		// Base
		if !is_undefined(self.style.sprite_checkbox) {
			var _blend_color = self.style.color_back;
			if self.deactivated {
				_blend_color = merge_color(_blend_color, c_black, 0.5);
			}
			var _draw_width = min(self.width, self.height);
			var _draw_height = min(self.width, self.height);
			draw_sprite_stretched_ext(self.style.sprite_checkbox, 0, self.x, self.y, _draw_width, _draw_height, _blend_color, 1);
		}
		// Pin
		if !is_undefined(self.style.sprite_checkbox_pin) {
			var _blend_color = self.value ? self.style.color_accent : self.style.color_primary;
			if !self.deactivated {
				if self.isMouseHovered() {
					_blend_color = merge_color(_blend_color, self.style.color_hover, 0.5);
				}
			} else {
				_blend_color = merge_color(_blend_color, c_black, 0.5);
			}
			var _draw_width = min(self.width, self.height);
			var _draw_height = min(self.width, self.height);
			draw_sprite_stretched_ext(self.style.sprite_checkbox_pin, 0, self.x, self.y, _draw_width, _draw_height, _blend_color, 1);
		}
		// Text
		if self.text != "" {
			if !self.deactivated {
				draw_set_color(self.style.color_text);
			} else {
				draw_set_color(merge_color(self.style.color_text, c_black, 0.5));
			}
			draw_set_alpha(1);
			draw_set_halign(fa_left);
			draw_set_valign(fa_middle);
			if !is_undefined(self.style.font_default) {
				draw_set_font(self.style.font_default);
			}
			var _draw_width = min(self.width, self.height);
			var _text_width = min(string_width(self.text), self.width - _draw_width - self.style.gap);
			self._drawTruncatedText(self.x + _draw_width + self.style.gap, self.y + self.height div 2, self.text, _text_width);
		}
		// Border
		if !is_undefined(self.style.sprite_checkbox_border) {
			var _draw_width = min(self.width, self.height);
			var _draw_height = min(self.width, self.height);
			draw_sprite_stretched_ext(self.style.sprite_checkbox_border, 0, self.x, self.y, _draw_width, _draw_height, self.style.color_border, 1);
		}
	}
	
	self.addEvent(LUI_EV_CLICK, function(_element) {
		_element.set(!_element.get());
		if !is_undefined(_element.style.sound_click) {
			audio_play_sound(_element.style.sound_click, 1, false);
		}
	});
}