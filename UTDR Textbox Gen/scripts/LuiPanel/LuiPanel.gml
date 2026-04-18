///@desc A visually visible container for placing elements in it.
/// Available parameters:
/// allow_resize
///@arg {Struct} [_params] Struct with parameters
function LuiPanel(_params = {}) : LuiBase(_params) constructor {
	
	self.allow_resize = _params[$ "allow_resize"] ?? false;
	
	self.resizer = undefined;
	
	///@desc Set allow to resize panel or not
	///@arg {bool} _allow
	static setAllowResize = function(_allow) {
		self.allow_resize = _allow;
		if _allow {
			self._initResizer();
		} else {
			if !is_undefined(self.resizer) {
				self.resizer.destroy();
				self.resizer = undefined;
			}
		}
		return self;
	}
	
	///@ignore
	static _initResizer = function() {
		if is_undefined(self.resizer) && self.allow_resize {
			self.resizer = new LuiBox({r: 0, b: 0, w: 8, h: 8, color: c_red, alpha: 0}).setPositionAbsolute(); //???//
			self.resizer.can_drag = true;
			self.resizer.setData("panel", self);
			self.resizer.addEvent(LUI_EV_DRAGGING, function(_e, _data) {
				var _new_x = _data.new_x;
				var _new_y = _data.new_y;
				var _panel = _e.getData("panel");
				var _new_width = max(_new_x - _panel.x, _panel.min_width);
				var _new_height = max(_new_y - _panel.y, _panel.min_height);
				_panel.setSize(_new_width, _new_height);
			});
			self.addContent(self.resizer);
		}
	}
	
	self.draw = function() {
		//Shadow
		//var _left = (sprite_get_width(sUI_Square_21r_shadow) - sprite_get_width(self.style.sprite_panel)) div 2;
		//var _right = (sprite_get_width(sUI_Square_21r_shadow) - sprite_get_width(self.style.sprite_panel)) div 2;
		//var _top = (sprite_get_height(sUI_Square_21r_shadow) - sprite_get_height(self.style.sprite_panel)) div 2 - 2;
		//var _bottom = (sprite_get_height(sUI_Square_21r_shadow) - sprite_get_height(self.style.sprite_panel)) div 2 + 1;
		//draw_sprite_stretched_ext(sUI_Square_21r_shadow, 0, self.x - _left, self.y - _top, self.width + _right*2, self.height + _bottom*2, c_white, 1);
		// Base
		if !is_undefined(self.style.sprite_panel) {
			var _blend_color = self.style.color_primary; //???// self.nesting_level == 1 ? self.style.color_primary : merge_color(self.style.color_primary, self.style.color_secondary, 0.25);
			if self.deactivated {
				_blend_color = merge_color(_blend_color, c_black, 0.5);
			}
			draw_sprite_stretched_ext(self.style.sprite_panel, 0, self.x, self.y, self.width, self.height, _blend_color, 1);
		}
		// Border
		if !is_undefined(self.style.sprite_panel_border) {
			draw_sprite_stretched_ext(self.style.sprite_panel_border, 0, self.x, self.y, self.width, self.height, self.style.color_border, 1);
		}
	}
	
	self.addEvent(LUI_EV_CREATE, function(_e) {
		_e._initResizer();
	});
}