///@desc A progress ring for display loading/filling anything
/// Available parameters:
/// value
/// min_value
/// max_value
/// rounding
/// display_value
/// bar_height
/// color - custom bar accent color
///@arg {Struct} [_params] Struct with parameters
function LuiProgressRing(_params = {}) : LuiProgressBar(_params) constructor {
	
	self.sprite_pos = {
		x : 0,
		y : 0,
		scale : 1
	};
	
	///@desc Calculate scale to fit size and position
	///@ignore
	static _calcSpritePos = function(_sprite) {
		if is_undefined(_sprite) return;
		var _spr_width = sprite_get_width(_sprite);
		var _spr_height = sprite_get_height(_sprite);
		var _scale = min(self.width / _spr_width, self.height / _spr_height);
		self.sprite_pos.x = self.x + floor(self.width / 2) - _spr_width * _scale / 2;
		self.sprite_pos.y = self.y + floor(self.height / 2) - _spr_height * _scale / 2;
		self.sprite_pos.scale = _scale;
	}
	
	self.draw = function() {
		// Calculate colors
		var _blend_back = self.style.color_back;
		var _blend_accent = !is_undefined(self.bar_color) ? self.bar_color : self.style.color_accent;
		var _blend_text = self.style.color_text;
		var _blend_border = self.style.color_border;
		if self.deactivated {
			_blend_back = merge_color(_blend_back, c_black, 0.5);
			_blend_accent = merge_color(_blend_accent, c_black, 0.5);
			_blend_text = merge_color(_blend_text, c_black, 0.5);
		}
		
		// Calculate position
		var _x = self.sprite_pos.x;
		var _y = self.sprite_pos.y;
		var _scale = self.sprite_pos.scale;
		
		// Base
		if !is_undefined(self.style.sprite_progress_ring) {
			draw_sprite_ext(self.style.sprite_progress_ring, 0, _x, _y, _scale, _scale, 0, _blend_back, 1);
		}
		
		// Bar value
		if !is_undefined(self.style.sprite_progress_ring_value) {
			drawSpriteRadial(self.style.sprite_progress_ring_value, 0, self.bar_value, _x, _y, _scale, _scale, _blend_accent, 1);
		}
		
		// Border
		if !is_undefined(self.style.sprite_progress_ring_border) {
			draw_sprite_ext(self.style.sprite_progress_ring_border, 0, _x, _y, _scale, _scale, 0, _blend_border, 1);
		}
		
		// Text value
		if self.display_value {
			if !is_undefined(self.style.font_default) draw_set_font(self.style.font_default);
			draw_set_color(_blend_text);
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			draw_text(self.x + self.width / 2, self.y + self.height / 2, _calculateValue(self.value));
		}
	}
	
	self.addEvent(LUI_EV_CREATE, function(_element) {
		_element._calcSpritePos(_element.style.sprite_progress_ring);
	});
	
	self.addEvent(LUI_EV_POSITION_UPDATE, function(_element) {
		_element._calcSpritePos(_element.style.sprite_progress_ring);
	});
	
	self.addEvent(LUI_EV_SIZE_UPDATE, function(_element) {
		_element._calcSpritePos(_element.style.sprite_progress_ring);
	});
	
	self.addEvent(LUI_EV_DESTROY, function(_element) {
		delete _element.sprite_pos;
	});
}