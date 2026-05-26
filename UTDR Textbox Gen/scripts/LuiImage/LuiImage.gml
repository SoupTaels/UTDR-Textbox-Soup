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
	self.draw_normal = _params[$ "draw_normal"] ?? false;
	self.angle = _params[$ "angle"] ?? 0;
	self.xoff = _params[$ "xoff"] ?? 0;
	self.yoff = _params[$ "yoff"] ?? 0;
	self.imgspd = _params[$ "imgspd"] ?? 0;
	self.xscale = _params[$ "xscale"] ?? 1;
	self.yscale = _params[$ "yscale"] ?? 1;
	self.color_default = self.color_blend;
	self.blink = -1;

	self.sprite_real_width = 0;
	self.sprite_real_height = 0;
	self.aspect = 1;
	self.bounce = false;
	self.updating = false;
	self.anim_track = false;
	
	///@desc Set sprite
	///@arg {asset.GMSprite} _sprite
	static setSprite = function(_sprite) {
		self.updating = true; self.alpha = 0; TweenScript(self, 0, 5, function(){ if ( self.updating ) { self.updating = false; self.alpha = 1; } });
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
		if ( !is_undefined(self.value) && self.value != -1 && self.value != "" && sprite_exists(self.value) ) {
			self.sprite_real_width = sprite_get_width(self.value);
			self.sprite_real_height = sprite_get_height(self.value);
			self.aspect = self.sprite_real_width / self.sprite_real_height;
		}
	}
	
	self.step = function () { 
		if ( self.imgspd > 0 ) {
			var amt = sprite_get_number(self.value);
			if ( !self.bounce ) { self.subimg += self.imgspd; if ( self.subimg >= amt ) { self.subimg = 0; } }
			else { 
				if ( !self.anim_track ) { self.subimg += self.imgspd mod amt; if ( round(self.subimg) >= amt) { self.anim_track = true; } }
				else { self.subimg -= self.imgspd; if ( round(self.subimg) <= 0) { self.anim_track = false; } }
			}
			self.updateMainUiSurface();
		};
		
		if ( self.blink != -1 ) { self.updateMainUiSurface(); }
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
		if ( !is_undefined(self.value) && self.value != -1 && self.value != "" && sprite_exists(self.value) ) {
			if ( self.blink == -1 || ( self.blink != -1 && blink(self.blink - 100, self.blink) ) ) {
				if ( !self.draw_normal ) {
					var _sprite_render_function = self.style.sprite_render_function ?? draw_sprite_stretched_ext;
						_sprite_render_function(self.value, self.subimg, 
													floor(( ( self.x + ( self.width/ 2 ) ) - ( _width/ 2 )) - self.xscale ) + self.xoff, 
													floor(( ( self.y + ( self.height/ 2 ) ) - ( _height/ 2 )) - self.yscale ) + self.yoff, 
													_width + ( self.xscale * 2 ), _height + ( self.yscale * 2 ), 
													_blend_color, self.alpha);
				}
				else {
					draw_sprite_ext(self.value, self.subimg, ( self.x + ( self.width/ 2 ) ) + self.xoff, ( self.y + ( self.height/ 2 ) ) + self.yoff, self.xscale, self.yscale, self.angle ?? 0, _blend_color, self.alpha);
				}
			}
		}
	}
	
	self.addEvent(LUI_EV_CREATE, function(_element) {
		_element._calcSpriteSize();
	});
	
	self.addEvent(LUI_EV_VALUE_UPDATE, function(_element) {
		_element._calcSpriteSize();
	});
}