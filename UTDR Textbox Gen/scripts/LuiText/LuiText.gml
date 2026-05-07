///@desc Just a text.
/// Available parameters:
/// value
/// text_halign
/// text_valign
/// scale_to_fit
///@arg {Struct} [_params] Struct with parameters
function LuiText(_params = {}) : LuiBase(_params) constructor {
	
	self.value = string(_params[$ "value"] ?? "");
	self.text_halign = _params[$ "text_halign"] ?? fa_left;
	self.text_valign = _params[$ "text_valign"] ?? fa_middle;
	self.scale_to_fit = _params[$ "scale_to_fit"] ?? false;
	self.scale_x = _params[$ "scale_x"] ?? 1;
	self.scale_y = _params[$ "scale_y"] ?? scale_x;
	self.color = _params[$ "color"] ?? undefined;
	self.font = _params[$ "font"] ?? undefined;
	self.xoff = _params[$ "xoff"] ?? 0; self.yoff = _params[$ "yoff"] ?? 0;
	self.params = _params;
	self.scribble_ = _params[$ "scribbletext"] ?? false;
	
	///@desc Set text
	///@arg {string} _text
	static setText = function(_text) {
		self.set(_text);
		return self;
	}
	
	///@desc Set horizontal aligment of text.
	///@arg {constant.HAlign} _halign
	static setTextHalign = function(_halign) {
		self.text_halign = _halign;
		return self;
	}
	
	///@desc Set vertical aligment of text.
	///@arg {constant.VAlign} _valign
	static setTextValign = function(_valign) {
		self.text_valign = _valign;
		return self;
	}
	
	///@desc Set scale to fit text
	///@arg {bool} _scale_to_fit True is scale text to fit element size
	static setScaleToFit = function(_scale_to_fit) {
		self.scale_to_fit = _scale_to_fit;
		return self;
	}
	self.step = function() {
		if ( self.scribble_ ) { self.updateMainUiSurface(); }
	}
	self.draw = function() {
		//Set font properties
		if ( !self.scribble_ ) {
			if !is_undefined(self.style.font_default) {
				draw_set_font(self.font ?? self.style.font_default);
			}
			draw_set_color(self.color ?? ( !self.deactivated ? self.style.color_text : merge_color(self.style.color_text, c_black, 0.5) ));
			draw_set_alpha(1);
			draw_set_halign(self.text_halign);
			draw_set_valign(self.text_valign);
		}
		//Calculate right text align
		var _txt_x = 0;
		var _txt_y = 0;
		switch(self.text_halign) {
			case fa_left: 
				_txt_x = self.x;
			break;
			case fa_center:
				_txt_x = self.x + self.width / 2;
			break;
			case fa_right: 
				_txt_x = self.x + self.width;
			break;
		}
		switch(self.text_valign) {
			case fa_top: 
				_txt_y = self.y;
			break;
			case fa_middle:
				_txt_y = self.y + self.height / 2;
			break;
			case fa_bottom: 
				_txt_y = self.y + self.height;
			break;
		}
		//Draw text
		if self.value != "" {
			if ( !self.scribble_ ) { 
				if !self.scale_to_fit {
					self._drawTruncatedText(_txt_x + self.xoff, _txt_y + self.yoff, self.value, self.width, self.scale_x, self.scale_y);
				} else {
					var _text = self.value;
					var _xscale = self.width / string_width(_text);
					var _yscale = self.height / string_height(_text);
					var _scale = min(_xscale, _yscale);
					draw_text_transformed(_txt_x + self.xoff, _txt_y + self.yoff, _text, _scale * self.scale_x, _scale * self.scale_y, 0);
				}
			}
			else {
				var text_ = scribble(self.value)
				.align(self.text_halign, self.text_valign)
				.starting_format(self.font ?? self.style.font_default, self.color ?? ( !self.deactivated ? self.style.color_text : merge_color(self.style.color_text, c_black, 0.5) ))
				.draw(_txt_x + self.xoff, _txt_y + self.yoff);
			}
		}
	}
}