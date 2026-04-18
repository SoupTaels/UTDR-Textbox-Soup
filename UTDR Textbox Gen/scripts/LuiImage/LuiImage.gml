///@desc This item displays the specified sprite with certain settings.
/// Available parameters:
/// value
/// subimg
/// color
/// alpha
/// maintain_aspect
///@arg {Struct} [_params] Struct with parameters
function LuiImage(_params = {}) : LuiBase(_params) constructor {
	
	self.value = _params[$ "value"] ?? undefined;
	self.subimg = _params[$ "subimg"] ?? 0;
	self.color_blend = _params[$ "color"] ?? c_white;
	self.alpha = _params[$ "alpha"] ?? 1;
	self.maintain_aspect = _params[$ "maintain_aspect"] ?? true;
	
	self.sprite_real_width = 0;
	self.sprite_real_height = 0;
	self.aspect = 1;
	
	///@desc Set sprite
	///@arg {asset.GMSprite} _sprite
	static setSprite = function(_sprite) {
		self.set(_sprite);
		return self;
	}
	
	///@desc Set subimg of sprite
	///@arg {real} _subimg
	static setSubimg = function(_subimg) {
		self.subimg = _subimg;
		return self;
	}
	
	///@desc Set blend color for sprite
	///@arg {any} _color_blend
	static setColor = function(color_blend) {
		self.color_blend = color_blend;
		return self;
	}
	
	///@desc Set alpha for sprite
	///@arg {real} _alpha
	static setAlpha = function(_alpha) {
		self.alpha = _alpha;
		return self;
	}
	
	///@desc Set maintain aspect of sprite
	///@arg {bool} _maintain_aspect
	static setMaintainAspect = function(_maintain_aspect) {
		self.maintain_aspect = _maintain_aspect;
		return self;
	}
	
	///@ignore
	static _calcSpriteSize = function() {
		if !is_undefined(self.value) && sprite_exists(self.value) {
			self.sprite_real_width = sprite_get_width(self.value);
			self.sprite_real_height = sprite_get_height(self.value);
			self.aspect = self.sprite_real_width / self.sprite_real_height;
		}
	}
	
	self.draw = function() {
		//Calculate fit size
		var _width = self.width;
		var _height = self.height;
		if self.maintain_aspect {
			if _width / self.aspect <= self.height  {
				_height = _width / self.aspect;
			} else {
				_width = _height * self.aspect;
			}
		}
		//Get blend color
		var _blend_color = self.color_blend;
		if self.deactivated {
			_blend_color = merge_color(_blend_color, c_black, 0.5);
		}
		//Draw sprite
		var _sprite_render_function = self.style.sprite_render_function ?? draw_sprite_stretched_ext;
		if !is_undefined(self.value) && sprite_exists(self.value) {
			_sprite_render_function(self.value, self.subimg, 
										floor(self.x + self.width/2 - _width/2), 
										floor(self.y + self.height/2 - _height/2), 
										_width, _height, 
										_blend_color, self.alpha);
		}
	}
	
	self.addEvent(LUI_EV_CREATE, function(_element) {
		_element._calcSpriteSize();
	});
	
	self.addEvent(LUI_EV_VALUE_UPDATE, function(_element) {
		_element._calcSpriteSize();
	});
}