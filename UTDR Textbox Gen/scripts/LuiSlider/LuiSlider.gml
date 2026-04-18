///@desc Slider with a limited value from and to, e.g. to change the volume.
/// Available parameters:
/// value
/// min_value
/// max_value
/// rounding
/// display_value
/// bar_height
/// knob_extender
/// color - custom bar accent color
///@arg {Struct} [_params] Struct with parameters
function LuiSlider(_params = {}) : LuiProgressBar(_params) constructor {
	
	self.can_drag = true;
	
	self.knob_extender = _params[$ "knob_extender"] ?? 1;
	
	// Calculate knob width in constructor
	static _initKnobWidth = function() {
		if !is_undefined(self.style.sprite_slider_knob) {
			var _slider_knob_nineslice = sprite_get_nineslice(self.style.sprite_slider_knob);
			var _nineslice_left_right = _slider_knob_nineslice.left + _slider_knob_nineslice.right;
			self.knob_width = _nineslice_left_right == 0 ? sprite_get_width(self.style.sprite_slider_knob) : _nineslice_left_right;
		}
	}
	
	self.draw = function() {
		// Calculate colors based on state
		var _blend_back = self.style.color_back;
		var _blend_accent = !is_undefined(self.bar_color) ? self.bar_color : self.style.color_accent;
		var _blend_secondary = self.style.color_secondary;
		var _blend_text = self.style.color_text;
		var _blend_border = self.style.color_border;
		if self.deactivated {
			_blend_back = merge_color(_blend_back, c_black, 0.5);
			_blend_accent = merge_color(_blend_accent, c_black, 0.5);
			_blend_secondary = merge_color(_blend_secondary, c_black, 0.5);
			_blend_text = merge_color(_blend_text, c_black, 0.5);
		} else if self.isMouseHovered() {
			_blend_secondary = merge_color(_blend_secondary, self.style.color_hover, 0.5);
		}
		
		// Calculate bar position and size
		var _bar_height = self.bar_height == -1 ? self.height : self.bar_height;
		var _bar_x = self.x;
		var _bar_y = self.y + (self.height - _bar_height) div 2;
		var _bar_w = self.width;
		var _bar_h = _bar_height;
		
		// Base
		if !is_undefined(self.style.sprite_progress_bar) {
			draw_sprite_stretched_ext(self.style.sprite_progress_bar, 0, _bar_x, _bar_y, _bar_w, _bar_h, _blend_back, 1);
		}
		
		// Bar value
		if !is_undefined(self.style.sprite_progress_bar_value) {
			draw_sprite_stretched_ext(self.style.sprite_progress_bar_value, 0, _bar_x, _bar_y, _bar_w * self.bar_value, _bar_h, _blend_accent, 1);
		}
		
		// Border
		if !is_undefined(self.style.sprite_progress_bar_border) {
			draw_sprite_stretched_ext(self.style.sprite_progress_bar_border, 0, _bar_x, _bar_y, _bar_w, _bar_h, _blend_border, 1);
		}
		
		// Text
		if !is_undefined(self.style.font_default) {
			draw_set_font(self.style.font_default);
		}
		draw_set_color(_blend_text);
		draw_set_halign(fa_center);
		draw_set_valign(self.is_dragging ? fa_bottom : fa_middle);
		var _text_x = self.is_dragging ? self.x + self.width * self.bar_value : self.x + self.width div 2;
		var _text_y = self.is_dragging ? self.y - 4 : self.y + self.height div 2;
		draw_text(_text_x, _text_y, self.value);
		
		// Slider knob
		var _knob_x = clamp(self.x + self.width * self.bar_value - self.knob_width div 2, self.x, self.x + self.width - self.knob_width);
		var _spr_x1 = _knob_x - self.knob_extender;
		var _spr_y1 = self.y - self.knob_extender;
		var _spr_w = self.knob_width + self.knob_extender*2;
		var _spr_h = self.height + self.knob_extender*2;
		if !is_undefined(self.style.sprite_slider_knob) {
			draw_sprite_stretched_ext(self.style.sprite_slider_knob, 0, _spr_x1, _spr_y1, _spr_w, _spr_h, _blend_secondary, 1);
		}
		
		// Knob border
		if !is_undefined(self.style.sprite_slider_knob_border) {
			draw_sprite_stretched_ext(self.style.sprite_slider_knob_border, 0, _spr_x1, _spr_y1, _spr_w, _spr_h, _blend_border, 1);
		}
	}
	
	self.addEvent(LUI_EV_CREATE, function(_element) {
		_element._initKnobWidth();
	});
	
	self.addEvent(LUI_EV_MOUSE_WHEEL, function(_element) {
		var _wheel_step = max(_element.rounding, (_element.max_value - _element.min_value) * 0.02);
		var _wheel_up = mouse_wheel_up() ? 1 : 0;
		var _wheel_down = mouse_wheel_down() ? 1 : 0;
		var _wheel = _wheel_up - _wheel_down;
		var _new_value = clamp(_element.value + _wheel * _wheel_step, _element.min_value, _element.max_value);
		_new_value = _element._calculateValue(_new_value);
		_element.set(_new_value);
	});
	
	self.addEvent(LUI_EV_DRAGGING, function(_element, _data) {
		var x1 = _element.x;
		var x2 = x1 + _element.width;
		var _new_value = _element._calculateValue((_data.mouse_x - x1) / (x2 - x1) * (_element.max_value - _element.min_value) + _element.min_value);
		_element.set(_new_value);
	});
}