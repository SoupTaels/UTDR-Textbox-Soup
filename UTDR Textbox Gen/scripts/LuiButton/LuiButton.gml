///@desc It's just a button.
/// Available parameters:
/// text
/// color
///@arg {Struct} [_params] Struct with parameters
function LuiButton(_params = {}) : LuiBase(_params) constructor {
	
	self.text = _params[$ "text"] ?? "";
	self.button_color = _params[$ "color"] ?? undefined;
	self.icon = {
		sprite: -1,
		width: -1,
		height: -1,
		scale: 1,
		angle: 0,
		color: c_white,
		alpha: 1,
	}
	
	/* //???// Button animation test
	self.width_offset = 0;
	self.height_offset = 0;
	*/
	
	///@desc Set button text
	///@arg {string} _text
	static setText = function(_text) {
		self.text = _text;
		return self;
	}
	
	///@desc Set custom button color
	///@arg {any} _color
	static setColor = function(_color) {
		self.button_color = _color;
		return self;
	}
	
	///@arg {Asset.GMSprite} _sprite
	///@arg {real} _scale
	///@arg {real} _angle
	///@arg {any} _color
	///@arg {real} _alpha
	static setIcon = function(_sprite, _scale = 1, _angle = 0, _color = c_white, _alpha = 1) {
		self.icon.sprite = _sprite;
		self.icon.scale = _scale;
		self.icon.angle = _angle;
		self.icon.color = _color;
		self.icon.alpha = _alpha;
		if sprite_exists(_sprite) {
			_calcIconSize();
		}
		return self;
	}
	
	///@ignore
	static _calcIconSize = function() {
		if sprite_exists(self.icon.sprite) {
			var _spr_width = sprite_get_width(self.icon.sprite);
			var _spr_height = sprite_get_height(self.icon.sprite);
			var _scale = min(1, self.height / _spr_height);
			var _base_width = floor(_spr_width * _scale);
			var _base_height = floor(_spr_height * _scale);
			self.icon.width = floor(_base_width * self.icon.scale);
			self.icon.height = floor(_base_height * self.icon.scale);
		}
	}
	
	///@ignore
	static _drawIcon = function(_x, _y) {
		if sprite_exists(self.icon.sprite) {
			draw_sprite_stretched_ext(self.icon.sprite, 0, _x, _y, self.icon.width, self.icon.height, self.icon.color, self.icon.alpha);
		}
	}
	
	///@ignore
	static _drawIconAndText = function(_center_x, _center_y, _available_width, _text_color) {
		if self.text != "" {
			if !is_undefined(self.style.font_buttons) draw_set_font(self.style.font_buttons);
			draw_set_color(_text_color);
			draw_set_alpha(1);
			draw_set_valign(fa_middle);
			var _draw_icon = sprite_exists(self.icon.sprite) && self.text != "";
			if _draw_icon {
				if !is_undefined(self.style.font_buttons) draw_set_font(self.style.font_buttons);
				var _space_width = string_width(" ");
				var _text_width = string_width(self.text);
				_draw_icon = self.icon.width + _space_width + _text_width <= _available_width;
			}
			if _draw_icon {
				draw_set_halign(fa_left);
				var _space_width = string_width(" ");
				var _text_width = string_width(self.text);
				var _total_width = self.icon.width + _space_width + _text_width;
				var _icon_x = floor(_center_x - _total_width / 2);
				var _icon_y = floor(_center_y - self.icon.height / 2);
				var _text_x = _icon_x + self.icon.width + _space_width;
				_drawIcon(_icon_x, _icon_y);
				_drawTruncatedText(_text_x, _center_y, self.text, _available_width - self.icon.width - _space_width);
			} else {
				draw_set_halign(fa_center);
				_drawTruncatedText(_center_x, _center_y, self.text, _available_width);
			}
		}
	}
	
	self.draw = function() {
		// Calculate colors
		var _blend_color = !is_undefined(self.button_color) ? self.button_color : self.style.color_secondary;
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
			//???// Button animation test
			//draw_sprite_stretched_ext(self.style.sprite_button, 0, self.x - self.width_offset/2, self.y - self.height_offset/2, self.width + self.width_offset, self.height + self.height_offset, _blend_color, 1);
		}
		
		// Icon and text
		_drawIconAndText(_center_x, _center_y, self.width, _blend_text);
		
		// Border
		if !is_undefined(self.style.sprite_button_border) {
			draw_sprite_stretched_ext(self.style.sprite_button_border, 0, self.x, self.y, self.width, self.height, self.style.color_border, 1);
			//???// Button animation test
			//draw_sprite_stretched_ext(self.style.sprite_button_border, 0, self.x - self.width_offset/2, self.y - self.height_offset/2, self.width + self.width_offset, self.height + self.height_offset, self.style.color_border, 1);
		}
	}
	
	self.addEvent(LUI_EV_CREATE, function(_element) {
		if sprite_exists(_element.icon.sprite) {
			_element._calcIconSize();
		}
	});
	
	self.addEvent(LUI_EV_CLICK, function(_element) {
		if !is_undefined(_element.style.sound_click) {
			audio_play_sound(_element.style.sound_click, 1, false);
		}
	});
	
	self.addEvent(LUI_EV_SIZE_UPDATE, function(_element) {
		if sprite_exists(_element.icon.sprite) {
			_element._calcIconSize();
		}
	});
	
	/* //???// Button animation test
	self.addEvent(LUI_EV_MOUSE_ENTER, function(_element) {
		var _anim_time = 0.2;
		// 
		_element.main_ui.animate(_element, "width_offset", 4, _anim_time);
		// 
		_element.main_ui.animate(_element, "height_offset", 4, _anim_time);
	});
	
	self.addEvent(LUI_EV_MOUSE_LEAVE, function(_element) {
		var _anim_time = 0.2;
		// 
		_element.main_ui.animate(_element, "width_offset", 0, _anim_time);
		// 
		_element.main_ui.animate(_element, "height_offset", 0, _anim_time);
	});
	*/
}