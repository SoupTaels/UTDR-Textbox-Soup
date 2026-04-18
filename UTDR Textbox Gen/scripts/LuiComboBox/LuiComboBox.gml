///@desc Drop-down list.
/// Available parameters:
/// placeholder
///@arg {Struct} [_params] Struct with parameters
function LuiComboBox(_params = {}) : LuiButton(_params) constructor {
	
	self.placeholder = _params[$ "placeholder"] ?? "";
	
	self.items = undefined;
	self.is_open = false;
	self.combobox_panel = undefined;
	self.text_width = self.width;
	
	///@desc Set placeholder text
	///@arg {string} _placeholder
	static setPlaceholder = function(_placeholder) {
		self.placeholder = _placeholder;
		return self;
	}
	
	///@ignore
	static _calculateTextWidth = function() { //???// not used now
		if !is_undefined(self.style) && !is_undefined(self.style.sprite_combobox_arrow) {
			self.text_width = self.width - sprite_get_width(self.style.sprite_combobox_arrow)*4;
		} else {
			self.text_width = self.width;
		}
	}
	
	///@ignore
	static _initComboBoxPanel = function() {
		var _item_count = array_length(self.items);
		// Calculate panel sizes
		var _width = self.width;
		var _height = (self.height + self.style.padding) * _item_count + self.style.padding;
		// Create panel
		self.combobox_panel = new LuiPanel({x: 0, y: 0, width: _width}).hide().setVisibilitySwitching(false).setPositionAbsolute();
		self.main_ui.addContent([self.combobox_panel]);
	}
	
	///@ignore
	static _initItems = function() {
		var _item_count = array_length(self.items);
		//Add items to this panel
		if !is_array(self.items) self.items = [self.items];
		for (var i = 0; i < _item_count; ++i) {
			var _item = self.items[i];
			_item.combobox_parent = self;
			_item.height = self.height;
			_item.auto_height = false;
		}
		self.combobox_panel.addContent(self.items);
	}
	
	///@desc Toggle combobox open/close
	static toggle = function() {
		if is_undefined(self.combobox_panel) {
			self._initComboBoxPanel();
			self._initItems();
		}
		// Change state
		self.is_open = !self.is_open;
		self.combobox_panel.setVisibilitySwitching(true);
		if self.is_open {
			// Set position and size of panel
			var _x = self.x;
			var _y = self.y + self.height;
			self.combobox_panel.setPosition(_x, _y).setWidth(self.width);
			// Show and bring to front
			self.combobox_panel.show().bringToFront();
		} else {
			// Hide
			self.combobox_panel.hide();
		}
		self.combobox_panel.setVisibilitySwitching(false);
		return self;
    }
	
	///@desc Add items //???//
	///@arg {struct,array} _items Element or array of elements
	static addItems = function(_items) {
        self.items = _items;
        return self;
    }
	
	///@desc Remove items //???//
    static removeItem = function(index) {
        //if (index >= 0 && index < array_length(self.items)) {
        //    array_delete(self.items, index, 1);
        //}
        return self;
    }
	
	self.draw = function() {
		//Base
		if !is_undefined(self.style.sprite_combobox) {
			var _blend_color = self.style.color_secondary;
			if !self.deactivated {
				if self.isMouseHovered() {
					_blend_color = merge_color(self.style.color_secondary, self.style.color_hover, 0.5);
					if self.is_pressed == true {
						_blend_color = merge_color(self.style.color_secondary, c_black, 0.5);
					}
				}
			} else {
				_blend_color = merge_color(_blend_color, c_black, 0.5);
			}
			draw_sprite_stretched_ext(self.style.sprite_combobox, 0, self.x, self.y, self.width, self.height, _blend_color, 1);
		}
		
		//Arrow
		if !is_undefined(self.style.sprite_combobox_arrow) {
			var _x_offset = sprite_get_width(self.style.sprite_combobox_arrow);
			var _blend_color = self.style.color_border;
			if self.deactivated {
				_blend_color = merge_color(_blend_color, c_black, 0.5);
			}
			draw_sprite_ext(self.style.sprite_combobox_arrow, 0, self.x + self.width - _x_offset, self.y + self.height div 2, 1, is_open ? -1 : 1, 0, _blend_color, 1);
		}
		
		//Text
		if !is_undefined(self.style.font_buttons) {
			draw_set_font(self.style.font_buttons);
		}
		if !self.deactivated {
			draw_set_color(self.style.color_text);
		} else {
			draw_set_color(merge_color(self.style.color_text, c_black, 0.5));
		}
		var _text_draw_width = self.width;
		if !is_undefined(self.style.sprite_combobox_arrow) {
			_text_draw_width -= sprite_get_width(self.style.sprite_combobox_arrow)*3;
		}
		var _txt_x = self.x + self.width / 2;
		var _txt_y = self.y + self.height / 2;
		draw_set_alpha(1);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		if is_undefined(self.text) || self.text == "" {
			draw_set_alpha(0.5);
			_drawTruncatedText(_txt_x, _txt_y, self.placeholder, _text_draw_width);
		} else {
			_drawTruncatedText(_txt_x, _txt_y, string(self.text), _text_draw_width);
		}
		
		//Border
		if !is_undefined(self.style.sprite_combobox_border) {
			draw_sprite_stretched_ext(self.style.sprite_combobox_border, 0, self.x, self.y, self.width, self.height, self.style.color_border, 1);
		}
	}
	
	self.addEvent(LUI_EV_CREATE, function(_element) {
		_element._calculateTextWidth();
		if is_undefined(_element.combobox_panel) {
			_element._initComboBoxPanel();
			_element._initItems();
		}
	});
	
	self.addEvent(LUI_EV_CLICK, function(_element) {
		_element.toggle();
	});
	
	self.addEvent(LUI_EV_VALUE_UPDATE, function(_element) {
		_element._calculateTextWidth();
	});
	
	self.addEvent(LUI_EV_HIDE, function(_element) {
		if _element.is_open {
			_element.toggle();
		}
	});
	
	self.addEvent(LUI_EV_FOCUS_REMOVE, function(_element) {
		if _element.is_open && !_element.combobox_panel.isMouseHoveredExc() {
			_element.toggle();
		}
	});
	
	self.addEvent(LUI_EV_DESTROY, function(_element) {
		if !is_undefined(_element.combobox_panel) {
			_element.combobox_panel.destroy();
		}
		_element.items = -1;
	});
}

///@desc An element for a drop-down list.
/// Available parameters:
/// text
/// color
///@arg {Struct} [_params] Struct with parameters
function LuiComboBoxItem(_params = {}) : LuiButton(_params) constructor {
	
	self.combobox_parent = undefined;
	
	///@desc Set new combobox text and close combobox
	static chooseItem = function() {
		self.combobox_parent.setText(self.text);
		self.combobox_parent.toggle();
	}
	
	self.draw = function() {
		
		// Calculate positions
		var _center_x = self.x + self.width / 2;
		var _center_y = self.y + self.height / 2;
		
		//Base
		if !is_undefined(self.style.sprite_combobox_item) {
			var _blend_color = self.style.color_secondary;
			if !self.deactivated && self.isMouseHovered() {
				_blend_color = merge_color(self.style.color_secondary, self.style.color_hover, 0.5);
				if self.is_pressed == true {
					_blend_color = merge_color(self.style.color_secondary, c_black, 0.5);
				}
			}
			draw_sprite_stretched_ext(self.style.sprite_combobox_item, 0, self.x, self.y, self.width, self.height, _blend_color, 1);
		}
		
		// Icon and text
		_drawIconAndText(_center_x, _center_y, self.width, self.style.color_text);
		
		//Border
		if !is_undefined(self.style.sprite_combobox_item_border) {
			draw_sprite_stretched_ext(self.style.sprite_combobox_item_border, 0, self.x, self.y, self.width, self.height, self.style.color_border, 1);
		}
	}
	
	self.addEvent(LUI_EV_CLICK, function(_element) {
		_element.chooseItem();
	});
}