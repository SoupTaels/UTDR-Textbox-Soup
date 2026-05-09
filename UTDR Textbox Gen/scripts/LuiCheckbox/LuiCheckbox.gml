///@desc A button with a boolean value, either marked or unmarked.
/// Available parameters:
/// value
/// text
///@arg {Struct} [_params] Struct with parameters
function LuiCheckbox(_params = {}) : LuiBase(_params) constructor {
	
	self.value = _params[$ "value"] ?? false;
	self.text = _params[$ "text"] ?? "";
	self.sound_click = _params[$ "sound_click"] ?? undefined; self.sound_click_gain = _params[$ "sound_click_gain"] ?? undefined; self.sound_click_pitch = _params[$ "sound_click_pitch"] ?? undefined;
	self.sound_hover = _params[$ "sound_hover"] ?? undefined; self.sound_hover_gain = _params[$ "sound_hover_gain"] ?? undefined; self.sound_hover_pitch = _params[$ "sound_hover_pitch"] ?? undefined;
	self.checkbox_spr = _params[$ "checkbox_spr"] ?? false;
	self.checkbox_spr_index = _params[$ "checkbox_spr_index"] ?? 0;
	self.checkbox_spr_xscale = _params[$ "checkbox_spr_xscale"] ?? 1;
	self.checkbox_spr_yscale = _params[$ "checkbox_spr_yscale"] ?? 1;
	self.checkbox_clr = _params[$ "checkbox_clr"] ?? undefined;
	
	///@desc Set display text of checkbox (render right of checkbox)
	///@arg {string} _text
	static setText = function(_text) {
		self.text = _text;
		return self;
	}
	
	self.draw = function() {
		// Base
		if !is_undefined(self.style.sprite_checkbox) {
			var _blend_color = self.checkbox_clr ?? self.style.color_back;
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
			if ( !self.checkbox_spr ) { draw_sprite_stretched_ext(self.style.sprite_checkbox_pin, 0, self.x, self.y, _draw_width, _draw_height, _blend_color, 1); }
			else { draw_sprite_ext(self.checkbox_spr, self.checkbox_spr_index, self.x + ( _draw_width/ 2 ), self.y + ( _draw_height/ 2 ), self.checkbox_spr_xscale, self.checkbox_spr_yscale, 0, _blend_color, self.value); } 
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
		sfx_play(_element.sound_click ?? _element.style.sound_click, , _element.sound_click_gain ?? 1, _element.sound_click_pitch ?? 1);
	});
	
	self.addEvent(LUI_EV_MOUSE_ENTER, function(_element) {
		sfx_play(_element.sound_hover ?? _element.style.sound_hover, , _element.sound_hover_gain ?? 1, _element.sound_hover_pitch ?? 1);
	});
}