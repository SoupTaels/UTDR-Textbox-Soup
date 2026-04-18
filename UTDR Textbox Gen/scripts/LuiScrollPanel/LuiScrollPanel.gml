///@desc Panel with the ability to scroll down/up.
///@arg {Struct} [_params] Struct with parameters
function LuiScrollPanel(_params = {}) : LuiBase(_params) constructor {
	
	self.draw_content_in_cutted_region = true;
	
	self.scroll_offset_y = 0;
	self.scroll_target_offset_y = 0;
	self.drag_start_y = -1;
	self.drag_y = -1;
	self.scroll_pin_edge_offset = 4;
	self.scroll_smoothness = 0.02;
	self.scroll_container = undefined;
	
	///@desc Change getContainer function for compatibility with setFlex... functions
	self.getContainer = function() {
		self._initScrollContainer();
		return self.container;
	}
	
	///@desc Create container
	///@ignore
	static _initScrollContainer = function() {
		if is_undefined(self.scroll_container) {
			self.scroll_container = new LuiAbsoluteContainer({x: 0, y: 0});
			self.setContainer(self.scroll_container);
		}
	}
	
	///@desc Original addContent for compatibility
	self.addContentOriginal = method(self, addContent);
	
	///@desc Redirect addContent
	self.addContent = function(elements) {
		self._initScrollContainer();
		self.scroll_container.addContent(elements);
		return self;
	}
	
	///@desc Delete scroll panel content
	static cleanScrollPanel = function() {
		self.scroll_container.destroyContent();
		self.scroll_offset_y = 0;
		self.scroll_target_offset_y = 0;
	}
	
	///@ignore
	static _applyScroll = function() {
		self.scroll_container.setPosition(, self.scroll_offset_y);
	}
	
	self.draw = function() {
		//Panel
		if !is_undefined(self.style.sprite_panel) {
			var _blend_color = self.style.color_primary;//self.nesting_level == 0 ? self.style.color_primary : merge_color(self.style.color_primary, self.style.color_secondary, 0.25);
			if self.deactivated {
				_blend_color = merge_color(_blend_color, c_black, 0.5);
			}
			draw_sprite_stretched_ext(self.style.sprite_panel, 0, self.x, self.y, self.width, self.height, _blend_color, 1);
		}
		//Scroll slider
		if array_length(self.getContainer().content) > 0 {
			var _scroll_slider_x = self.x + self.width - self.style.scroll_slider_width - self.scroll_pin_edge_offset;
			var _scroll_pin_y_offset = Range(self.scroll_offset_y, 0, -(self.scroll_container.height - self.height), self.scroll_pin_edge_offset, self.height - self.style.scroll_slider_width - self.scroll_pin_edge_offset);
			// Slider back
			if !is_undefined(self.style.sprite_scroll_slider) {
				draw_sprite_stretched_ext(self.style.sprite_scroll_slider, 0, _scroll_slider_x, self.y + self.scroll_pin_edge_offset, self.style.scroll_slider_width, self.height - self.scroll_pin_edge_offset*2, self.style.color_back, 1);
			}
			// Scroll pin
			if !is_undefined(self.style.sprite_scroll_pin) {
				draw_sprite_stretched_ext(self.style.sprite_scroll_pin, 0, _scroll_slider_x, self.y + _scroll_pin_y_offset, self.style.scroll_slider_width, self.style.scroll_slider_width, self.style.color_secondary, 1);
			}
			// Scroll pin border
			if !is_undefined(self.style.sprite_scroll_pin_border) {
				draw_sprite_stretched_ext(self.style.sprite_scroll_pin_border, 0, _scroll_slider_x, self.y + _scroll_pin_y_offset, self.style.scroll_slider_width, self.style.scroll_slider_width, self.style.color_border, 1);
			}
		}
		//Panel border
		if !is_undefined(self.style.sprite_panel_border) {
			draw_sprite_stretched_ext(self.style.sprite_panel_border, 0, self.x, self.y, self.width, self.height, self.style.color_border, 1);
		}
	}
	
	self.step = function() {
		// Mouse wheel input
		if self.isMouseHoveredExc() && self.isMouseHoveredChilds() {
			var _wheel_up = mouse_wheel_up() ? 1 : 0;
			var _wheel_down = mouse_wheel_down() ? 1 : 0;
			var _wheel = _wheel_up - _wheel_down;
			if _wheel != 0 {
				self.scroll_target_offset_y += self.style.scroll_step * _wheel;
			}
			// Touch compatibility //???// (WIP)
			if self.drag_start_y == -1 && mouse_check_button_pressed(mb_left) {
				self.drag_start_y = device_mouse_y_to_gui(0);
			}
		}
		// Touch compatibility //???// (WIP)
		if self.drag_start_y != -1 {
			if mouse_check_button(mb_left) 
				&& (is_undefined(self.main_ui.element_in_focus) || (!is_undefined(self.main_ui.element_in_focus) && is_undefined(self.main_ui.dragging_element))) {
				self.drag_y = device_mouse_y_to_gui(0);
				self.scroll_target_offset_y = self.scroll_target_offset_y - self.drag_start_y + self.drag_y;
				self.drag_start_y = SmoothApproachDelta(self.drag_start_y, self.drag_y, self.scroll_smoothness, 0.1);
			}
			if mouse_check_button_released(mb_left) {
				self.drag_start_y = -1;
			}
		}
		// Scrolling
		if self.scroll_offset_y != self.scroll_target_offset_y {
			self.scroll_target_offset_y = clamp(self.scroll_target_offset_y, -(self.scroll_container.height - self.height), 0);
			self.scroll_offset_y = SmoothApproachDelta(self.scroll_offset_y, self.scroll_target_offset_y, self.scroll_smoothness, 0.1);
			self._applyScroll();
		}
	}
	
	self.addEvent(LUI_EV_CREATE, function(_element) {
		_element._initScrollContainer();
		_element.addContentOriginal(_element.scroll_container);
		if _element.auto_height {
			flexpanel_node_style_set_flex(_element.flex_node, 1); //???//
		}
		flexpanel_node_style_set_border(_element.flex_node, flexpanel_edge.right, _element.style.scroll_slider_width + _element.scroll_pin_edge_offset); //???//
	});
	
	self.addEvent(LUI_EV_DESTROY, function(_element) {
		if !is_undefined(_element.scroll_container) {
			_element.scroll_container.destroy();
		}
	});
}