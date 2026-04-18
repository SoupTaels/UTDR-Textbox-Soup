///@desc Panel with tabs
/// Available parameters:
/// tab_height
/// tab_indent
///@arg {Struct} [_params] Struct with parameters
function LuiTabs(_params = {}) : LuiBase(_params) constructor {
	
	self.tab_height = _params[$ "tab_height"] ?? 32;
	self.tab_indent = _params[$ "tab_indent"] ?? 0;
	
	self.tabs = undefined;
	self.tabs_header = undefined;
	self.active_tab = undefined;
	
	///@desc Set tabs height
	///@arg {real} _tab_height
	static setTabHeight = function(_tab_height) {
		self.tab_height = _tab_height;
		if !is_undefined(self.tabs_header) {
			self.tabs_header.setMinHeight(self.tab_height).setHeight(self.tab_height);
		}
		return self;
	}
	
	///@desc Set tabs indent
	///@arg {real} _tab_indent
	static setTabIndent = function(_tab_indent) {
		self.tab_indent = _tab_indent;
		self.setGap(self.tab_indent);
		if !is_undefined(self.tabs_header) {
			self.tabs_header.setGap(self.tab_indent);
		}
		return self;
	}
	
	///@desc Create header container for tabs
	///@ignore
	static _initHeader = function() {
		if is_undefined(self.tabs_header) {
			self.tabs_header = new LuiRow({height: self.tab_height}).setGap(self.tab_indent).setMinHeight(self.tab_height);
		}
	}
	
	///@desc Create tabs
	///@ignore
	static _initTabs = function() {
		if !is_undefined(self.tabs) {
			if !is_array(self.tabs) self.tabs = [self.tabs];
			var _tab_count = array_length(self.tabs);
			for (var i = 0; i < _tab_count; ++i) {
			    // Get tab
				var _tab = self.tabs[i];
				// Init tab container
				_tab._initContainer();
				// Set tabs parent for tab
				_tab.tabs_parent = self;
				// Add tab container to tabs_parent
				self.addContent(_tab.tab_container);
			}
			//Add tab to header of tabs_parent
			self.tabs_header.addContent(self.tabs);
			//Deactivate all and activate first
			self.tabDeactivateAll();
			self.tabs[0].tabActivate();
			self.active_tab = self.tabs[0];
		}
	}
	
	///@desc Add LuiTab's
	///@arg {struct,array} _tabs
	static addTabs = function(_tabs) {
        self.tabs = _tabs;
		if !is_undefined(self.main_ui) self._initTabs();
        return self;
    }
	
	///@desc Switch tab to another
	static switchTab = function(_new_tab) {
	    if (self.active_tab == _new_tab) return;
		
	    if (!is_undefined(self.active_tab)) {
	        self.active_tab.tabDeactivate();
	    }
		
	    _new_tab.tabActivate();
	    self.active_tab = _new_tab;
	}
	
	///@desc Deactivate all tabs
	static tabDeactivateAll = function() {
		var _tab_count = array_length(self.tabs);
		for (var i = 0; i < _tab_count; ++i) {
		    //Get tab
			var _tab = self.tabs[i];
			//Deactivate it
			_tab.tabDeactivate();
		}
	}
	
	///@desc Removes tab (WIP)
    static removeTab = function(index) {
        if (index >= 0 && index < array_length(self.tabs)) {
            array_delete(self.tabs, index, 1);
        }
        return self;
    }
	
	self.draw = function() {
		//Base
		if !is_undefined(self.style.sprite_tabs) {
			var _blend_color = self.style.color_primary;//self.nesting_level == 0 ? self.style.color_primary : merge_color(self.style.color_primary, self.style.color_secondary, 0.25);
			if self.deactivated {
				_blend_color = merge_color(_blend_color, c_black, 0.5);
			}
			draw_sprite_stretched_ext(self.style.sprite_tabs, 0, self.x, self.y + self.tab_height + self.tab_indent, self.width, self.height - self.tab_height - self.tab_indent, _blend_color, 1);
		}
		//Border
		if !is_undefined(self.style.sprite_tabs_border) {
			draw_sprite_stretched_ext(self.style.sprite_tabs_border, 0, self.x, self.y + self.tab_height + self.tab_indent, self.width, self.height - self.tab_height - self.tab_indent, self.style.color_border, 1);
		}
	}
	
	self.addEvent(LUI_EV_CREATE, function(_element) {
		// Setting up padding for tabs
		_element.setPadding(0).setGap(_element.tab_indent);
		// Init header container for tabs
		_element._initHeader();
		// Add header
		_element.addContent(_element.tabs_header);
		// Init tab's
		_element._initTabs();
	});
	
	self.addEvent(LUI_EV_SHOW, function(_element) {
		//Turn of visible of deactivated tab_container's
		var _tab_count = array_length(_element.tabs);
		for (var i = 0; i < _tab_count; ++i) {
			var _tab = _element.tabs[i];
			if !_tab.is_active {
				_tab.tab_container.setVisible(false);
			}
		}
	});
	
	self.addEvent(LUI_EV_DESTROY, function(_element) {
		if !is_undefined(_element.tabs_header) {
			_element.tabs_header.destroy();
		}
		_element.tabs = -1;
	});
}

///@desc Tab, used for LuiTabs.
/// Available parameters:
/// text
/// color
///@arg {Struct} [_params] Struct with parameters
function LuiTab(_params = {}) : LuiButton(_params) constructor {
	
	self.is_active = false;
	self.tabs_parent = undefined;
	self.tab_container = undefined;
	
	///@desc Change getContainer function for compatibility with setFlex... functions
	self.getContainer = function() {
		self._initContainer();
		return self.container;
	}
	
	///@ignore
	static _initContainer = function() {
		if is_undefined(self.tab_container) {
			self.tab_container = new LuiContainer({x: 0, y: 0}).setVisible(false).setFlexDisplay(flexpanel_display.none).setFlexGrow(1);
			self.setContainer(self.tab_container);
		}
	}
	
	///@desc Set active state of tab
	///@arg {bool} _is_active
	static setActiveState = function(_is_active) {
	    self.is_active = _is_active;
	    if (_is_active) {
	        self.tab_container.setVisible(true).setFlexDisplay(flexpanel_display.flex);
	    } else {
	        self.tab_container.setVisible(false).setFlexDisplay(flexpanel_display.none);
	    }
	}
	
	///@desc Activate current tab
	static tabActivate = function() {
		self.setActiveState(true);
	}
	
	///@desc Deactivate current tab
	static tabDeactivate = function() {
		self.setActiveState(false);
	}
	
	///@desc Works like usual addContent, but redirect add content to tab_container of this tab
	self.addContent = function(elements) {
		self._initContainer();
		self.tab_container.addContent(elements);
		return self;
	}
	
	self.draw = function() {
		// Calculate colors
		var _blend_color = !is_undefined(self.button_color) ? self.button_color : self.style.color_primary;
		var _blend_text = self.style.color_text;
		if self.deactivated {
			_blend_color = merge_color(_blend_color, c_black, 0.5);
			_blend_text = merge_color(_blend_text, c_black, 0.5);
		} else if !self.is_active {
			_blend_color = merge_color(_blend_color, c_black, 0.25);
			if self.isMouseHovered() {
				_blend_color = merge_color(_blend_color, self.style.color_hover, 0.5);
				if self.is_pressed {
					_blend_color = merge_color(_blend_color, c_black, 0.5);
				}
			}
		}
		
		// Calculate positions
		var _center_x = self.x + self.width / 2;
		var _center_y = self.y + self.height / 2;
		
		// Base
		if !is_undefined(self.style.sprite_tab) {
			draw_sprite_stretched_ext(self.style.sprite_tab, 0, self.x, self.y, self.width, self.height, _blend_color, 1);
		}
		
		// Icon and text
		_drawIconAndText(_center_x, _center_y, self.width, _blend_text);
		
		// Border
		if !is_undefined(self.style.sprite_tab_border) {
			draw_sprite_stretched_ext(self.style.sprite_tab_border, 0, self.x, self.y, self.width, self.height, self.style.color_border, 1);
		}
	}
	
	self.addEvent(LUI_EV_CREATE, function(_element) {
		_element._initContainer();
	});
	
	self.addEvent(LUI_EV_CLICK, function(_element) {
		if !_element.is_active {
			_element.tabs_parent.switchTab(_element);
		}
	});
	
	self.addEvent(LUI_EV_DESTROY, function(_element) {
		if !is_undefined(_element.tab_container) {
			_element.tab_container.destroy();
		}
	});
}