///@desc The basic constructor of all elements, which contains all the basic functions and logic of each element.
/// Available parameters:
/// x - x position for element (left position of flex node)
/// y - y position for element (top position of flex node)
/// r - right position for element (right position of flex node)
/// b - bottom position for element (bottom position of flex node)
/// width or w - width of element
/// height or h - height of element
/// min_width - minimum width of element
/// min_height - minimum height of element
/// name - unique name_id for element
///@arg {Struct} [_params] Struct with parameters
function LuiBase(_params = {}) constructor {
	if !variable_global_exists("lui_element_count") variable_global_set("lui_element_count", 0);
	if !variable_global_exists("lui_max_z") variable_global_set("lui_max_z", 0);
		
	self.element_id = global.lui_element_count++;
	self.name = LUI_AUTO_NAME;							//Unique element identifier
	self.value = undefined;								//Value
	self.data = undefined;								//Different user data for personal use
	self.style = undefined;								//Style struct
	self.style_overrides = {};							//Custom style for element
	self.x = LUI_AUTO;									//Actual real calculated x position on the screen
	self.y = LUI_AUTO;									//Actual real calculated y position on the screen
	self.r = LUI_AUTO;
	self.b = LUI_AUTO;
	self.z = 0;											//Depth
	self.start_x = -1;									//First x position
	self.start_y = -1;									//First y position
	self.prev_x = -1;									//Previous floor(x) position on the screen
	self.prev_y = -1;									//Previous floor(y) position on the screen
	self.width = LUI_AUTO;								//Actual real calculated width of element
	self.height = LUI_AUTO;								//Actual real calculated height of element
	self.prev_w = -1;									//Previous width
	self.prev_h = -1;									//Previous height
	self.min_width = LUI_AUTO;
	self.min_height = LUI_AUTO;
	self.max_width = 3200;
	self.max_height = 3200;
	self.auto_x = false;
	self.auto_y = false;
	self.auto_width = false;
	self.auto_height = false;
	self.parent = undefined;
	self.content = [];
	self.delayed_content = [];
	self.container = self; 								//Sometimes the container may not be the element itself, but the element inside it (for example: LuiTab, LuiScrollPanel...)
	self.deactivated = false;
	self.visible = true;
	self.visibility_switching = true;
	self.has_focus = false;
	self.inside_parent = 2;
	self.ignore_mouse = false;
	self.ignore_mouse_all = undefined;
	self.render_content_enabled = true;
	self.need_to_update_content = false;
	self.main_ui = undefined;
	self.tooltip = "";
	self.binded_variable = undefined;
	self.is_pressed = false;
	self.is_mouse_hovered = false;
	self.is_adding = false;
	self.is_custom_style_setted = false;
	self.is_destroyed = false;
	self.is_initialized = false;
	self.draw_content_in_cutted_region = false;
	self.render_region_offset = { //???// в целом еще может пригодится
		left : 0,
		right : 0,
		top : 0,
		bottom : 0
	};
	self.flex_node = flexpanel_create_node({ name: self.name, data: {} });
	var _data = flexpanel_node_get_data(self.flex_node);
	_data.element = self;
	// Screen grid system
	self._grid_location = []; 						//Screen grid to optimize the search for items under the mouse cursor
	self.grid_previous_x1 = -1;						//Previous floor(x / LUI_GRID_ACCURACY) left position on the grid
	self.grid_previous_y1 = -1;						//Previous floor(y / LUI_GRID_ACCURACY) top position on the grid
	self.grid_previous_x2 = -1;						//Previous floor((x + width) / LUI_GRID_ACCURACY) right position on the grid
	self.grid_previous_y2 = -1;						//Previous floor((y + width) / LUI_GRID_ACCURACY) bottom position on the grid
	// View region system
	self.view_region = {
		x1: 0,
		y1: 0,
		x2: 5000,
		y2: 5000
	};
	self.is_visible_in_region = false;
	// Depth system
	self.nesting_level = 0;
	self.depth_array = [];
	// Dragging system
	self.can_drag = false;
    self.is_dragging = false;
    self.drag_offset_x = 0;
    self.drag_offset_y = 0;
	
	// Processing parameters from the structure
	if is_struct(_params) {
		self.x = _params[$ "x"] ?? LUI_AUTO;
		self.y = _params[$ "y"] ?? LUI_AUTO;
		self.r = _params[$ "r"] ?? LUI_AUTO;
		self.b = _params[$ "b"] ?? LUI_AUTO;
		self.min_width = _params[$ "min_width"] ?? LUI_AUTO;
		self.min_height = _params[$ "min_height"] ?? LUI_AUTO;
		self.width = _params[$ "width"] ?? _params[$ "w"] ?? LUI_AUTO;
		self.height = _params[$ "height"] ?? _params[$ "h"] ??  LUI_AUTO;
		self.name = _params[$ "name"] ?? LUI_AUTO_NAME;
	} else {
		_luiPrintError($"A structure with parameters was expected, but a {typeof(_params)} was received!");
	}
	
	// Logic methods for element //???// delete uneccesery methods
	
	///@desc Calls every step
	self.step = undefined;
	
	///@desc Pre draw method call before draw method (for surfaces for example)
	self.preDraw = undefined;
	
	///@desc Draw method for element
	self.draw = undefined;
	
	// EVENT LISTENER SYSTEM
	self.event_listeners = {};
	
	///@desc Add a callback for a specific event
	/// Check "LuiEvents" script for available events
	///@param {string} _eventType The event type (constants of string e.g., LUI_EV_CREATE, LUI_EV_CLICK)
	///@param {function} _callback The callback function to execute
	///@return {struct} The element itself for chaining
	static addEvent = function(_eventType, _callback) {
		if (is_undefined(self.event_listeners[$ _eventType])) {
			self.event_listeners[$ _eventType] = [];
		}
		array_push(self.event_listeners[$ _eventType], _callback);
		return self;
	}
	
	///@desc Remove a callback for a specific event //???// возможно удаление подписки на событие с колбэком не очень правильное (поиск по точному колбэку странное решение)
	///@param {string} _eventType The event type
	///@param {function} _callback The callback function to remove
	///@return {struct} The element itself for chaining
	static removeEvent = function(_eventType, _callback) {
		if (!is_undefined(self.event_listeners[$ _eventType])) {
			var _listeners = self.event_listeners[$ _eventType];
			for (var i = array_length(_listeners) - 1; i >= 0; i--) {
				if (_listeners[i] == _callback) {
					array_delete(_listeners, i, 1);
				}
			}
		}
		return self;
	}

	///@desc Call events from event listener
	///@ignore
	static _dispatchEvent = function(_eventType, _data = undefined) {
		if (!is_undefined(self.event_listeners[$ _eventType])) {
			var _listeners = self.event_listeners[$ _eventType];
			for (var i = 0; i < array_length(_listeners); i++) {
				_listeners[i](self, _data);
			}
		}
	}
	
	// GETTERS
	
	///@desc Get value of this element
	///@return {any} Value depends on element
	static get = function() {
		return self.value;
	}
	
	///@desc Get data struct or specified value from it
	///@param {string} _key variable name
	static getData = function(_key = undefined) {
		if is_undefined(_key) {
			return self.data;
		} else {
			return self.data[$ _key];
		}
	}
	
	///@desc Get style
	static getStyle = function() {
		return self.style;
	}
	
	///@desc Get first element in content array
	static getFirst = function() {
		return array_first(self.content);
	};
	
	///@desc Get last element in content array
	static getLast = function() {
		return array_last(self.content);
	};
	
	///@desc Get container element
	self.getContainer = function() {
		return self.container;
	}
	
	///@desc Get content array
	self.getContent = function() {
		return self.getContainer().content;
	}
	
	// SETTERS
	
	///@desc Set value
	///@arg {any} _value
	static set = function(_value) {
		if self.value != _value {
			self.value = _value;
			if !is_undefined(self.binded_variable) {
				self._updateToBindedVariable();
			}
			self._dispatchEvent(LUI_EV_VALUE_UPDATE);
			self.updateMainUiSurface();
		}
		return self;
	}
	
	///@desc Set data
	///@param {string} _key variable name
	///@param {any} _value value
	static setData = function(_key, _value) {
		if is_undefined(self.data) self.data = {};
		self.data[$ _key] = _value;
		return self;
	}
	
	///@desc Set element unique identificator name (Used for get element from main ui container via getElement())
	static setName = function(_string) {
		if is_undefined(self.main_ui) || !variable_struct_exists(self.main_ui, "element_names") {
			self.name = _string;
		} else {
			if !variable_struct_exists(self.main_ui.element_names, _string) {
				self._deleteElementName();
				self.name = _string;
				self._registerElementName();
			} else {
				_luiPrintWarning($"Element name \"{_string}\" already exists! Please give another name!");
			}
		}
		return self;
	}
	
	///@desc Set flexpanel(element) position type (default is flexpanel_position_type.relative)
	///@arg {constant.flexpanel_position_type} [_type]
	static setPositionType = function(_type = flexpanel_position_type.relative) {
		var _flex_node = self.flex_node;
		flexpanel_node_style_set_position_type(_flex_node, _type);
		self.updateMainUiFlex();
		return self;
	}
	
	///@desc Shortcut method to make element position type absolute (eq. setPositionType(flexpanel_position_type.absolute))
	static setPositionAbsolute = function() {
		self.setPositionType(flexpanel_position_type.absolute);
		return self;
	}
	
	///@desc Set flexpanel(element) X position
	///@arg {real} [_x] left = X
	static setPosX = function(_x = LUI_AUTO) {
		var _flex_node = self.flex_node;
		var _update_flex = false;
		if _x != LUI_AUTO && self.x != _x {
			flexpanel_node_style_set_position(_flex_node, flexpanel_edge.left, _x, flexpanel_unit.point);
			if !self.is_initialized {
				self.x = _x;
			}
			self.auto_x = false;
			_update_flex = true;
		}
		if _update_flex {
			self.updateMainUiFlex();
		}
		return self;
	}
	
	///@desc Set flexpanel(element) Y position
	///@arg {real} [_y] top = Y
	static setPosY = function(_y = LUI_AUTO) {
		var _flex_node = self.flex_node;
		var _update_flex = false;
		if _y != LUI_AUTO && self.y != _y {
			flexpanel_node_style_set_position(_flex_node, flexpanel_edge.top, _y, flexpanel_unit.point);
			if !self.is_initialized {
				self.y = _y;
			}
			self.auto_y = false;
			_update_flex = true;
		}
		if _update_flex {
			self.updateMainUiFlex();
		}
		return self;
	}
	
	///@desc Set flexpanel(element) right position
	///@arg {real} [_r] right
	static setPosR = function(_r = LUI_AUTO) {
		var _flex_node = self.flex_node;
		var _update_flex = false;
		if _r != LUI_AUTO {
			flexpanel_node_style_set_position(_flex_node, flexpanel_edge.right, _r, flexpanel_unit.point);
			if !self.is_initialized {
				self.r = _r;
			}
			self.auto_x = false;
			_update_flex = true;
		}
		if _update_flex {
			self.updateMainUiFlex();
		}
		return self;
	}
	
	///@desc Set flexpanel(element) bottom position
	///@arg {real} [_b] bottom
	static setPosB = function(_b = LUI_AUTO) {
		var _flex_node = self.flex_node;
		var _update_flex = false;
		if _b != LUI_AUTO {
			flexpanel_node_style_set_position(_flex_node, flexpanel_edge.bottom, _b, flexpanel_unit.point);
			if !self.is_initialized {
				self.b = _b;
			}
			self.auto_y = false;
			_update_flex = true;
		}
		if _update_flex {
			self.updateMainUiFlex();
		}
		return self;
	}
	
	///@desc Set flexpanel(element) position
	///@arg {real} [_x] left = X
	///@arg {real} [_y] top = Y
	///@arg {real} [_r] right
	///@arg {real} [_b] bottom
	static setPosition = function(_x = LUI_AUTO, _y = LUI_AUTO, _r = LUI_AUTO, _b = LUI_AUTO) {
		var _flex_node = self.flex_node;
		var _update_flex = false;
		if _x != LUI_AUTO && self.x != _x {
			flexpanel_node_style_set_position(_flex_node, flexpanel_edge.left, _x, flexpanel_unit.point);
			if !self.is_initialized {
				self.x = _x;
			}
			self.auto_x = false;
			_update_flex = true;
		}
		if _y != LUI_AUTO && self.y != _y {
			flexpanel_node_style_set_position(_flex_node, flexpanel_edge.top, _y, flexpanel_unit.point);
			if !self.is_initialized {
				self.y = _y;
			}
			self.auto_y = false;
			_update_flex = true;
		}
		if _r != LUI_AUTO {
			flexpanel_node_style_set_position(_flex_node, flexpanel_edge.right, _r, flexpanel_unit.point);
			if !self.is_initialized {
				self.r = _r;
			}
			self.auto_x = false;
			_update_flex = true;
		}
		if _b != LUI_AUTO {
			flexpanel_node_style_set_position(_flex_node, flexpanel_edge.bottom, _b, flexpanel_unit.point);
			if !self.is_initialized {
				self.b = _b;
			}
			self.auto_y = false;
			_update_flex = true;
		}
		if _update_flex {
			self.updateMainUiFlex();
		}
		return self;
	}
	
	///@desc Set flexpanel(element) width
	///@arg {real} [_width]
	static setWidth = function(_width = LUI_AUTO) {
		var _flex_node = self.flex_node;
		var _update_flex = false;
		if _width != LUI_AUTO && self.width != _width {
			flexpanel_node_style_set_width(_flex_node, _width, flexpanel_unit.point);
			if !self.is_initialized {
				self.width = _width;
			}
			_update_flex = true;
		}
		if _update_flex {
			self.updateMainUiFlex();
		}
		return self;
	}
	
	///@desc Set flexpanel(element) height
	///@arg {real} [_height]
	static setHeight = function(_height = LUI_AUTO) {
		var _flex_node = self.flex_node;
		var _update_flex = false;
		if _height != LUI_AUTO && self.height != _height {
			flexpanel_node_style_set_height(_flex_node, _height, flexpanel_unit.point);
			if !self.is_initialized {
				self.height = _height;
			}
			_update_flex = true;
		}
		if _update_flex {
			self.updateMainUiFlex();
		}
		return self;
	}
	
	///@desc Set flexpanel(element) size
	///@arg {real} [_width]
	///@arg {real} [_height]
	static setSize = function(_width = LUI_AUTO, _height = LUI_AUTO) {
		var _flex_node = self.flex_node;
		var _update_flex = false;
		if _width != LUI_AUTO && self.width != _width {
			flexpanel_node_style_set_width(_flex_node, _width, flexpanel_unit.point);
			if !self.is_initialized {
				self.width = _width;
			}
			_update_flex = true;
		}
		if _height != LUI_AUTO && self.height != _height {
			flexpanel_node_style_set_height(_flex_node, _height, flexpanel_unit.point);
			if !self.is_initialized {
				self.height = _height;
			}
			_update_flex = true;
		}
		if _update_flex {
			self.updateMainUiFlex();
		}
		return self;
	}
	
	//@desc Stretch element on all width and height of parent
	static setFullSize = function() {
		flexpanel_node_style_set_width(self.flex_node, 100, flexpanel_unit.percent);
		flexpanel_node_style_set_height(self.flex_node, 100, flexpanel_unit.percent);
		return self;
	}
	
	///@desc Set flexpanel(element) min width
	///@arg {real} [_min_width]
	static setMinWidth = function(_min_width = LUI_AUTO) {
		var _flex_node = self.flex_node;
		var _update_flex = false;
		if _min_width != LUI_AUTO && self.min_width != _min_width {
			self.min_width = _min_width;
			flexpanel_node_style_set_min_width(_flex_node, _min_width, flexpanel_unit.point);
			_update_flex = true;
		}
		if _update_flex {
			self.updateMainUiFlex();
		}
		return self;
	}
	
	///@desc Set flexpanel(element) max width
	///@arg {real} [_max_width]
	static setMaxWidth = function(_max_width = LUI_AUTO) {
		var _flex_node = self.flex_node;
		var _update_flex = false;
		if _max_width != LUI_AUTO && self.max_width != _max_width {
			self.max_width = _max_width;
			flexpanel_node_style_set_max_width(_flex_node, _max_width, flexpanel_unit.point);
			_update_flex = true;
		}
		if _update_flex {
			self.updateMainUiFlex();
		}
		return self;
	}
	
	///@desc Set flexpanel(element) min height
	///@arg {real} [_min_height]
	static setMinHeight = function(_min_height = LUI_AUTO) {
		var _flex_node = self.flex_node;
		var _update_flex = false;
		if _min_height != LUI_AUTO && self.min_height != _min_height {
			self.min_height = _min_height;
			flexpanel_node_style_set_min_height(_flex_node, _min_height, flexpanel_unit.point);
			_update_flex = true;
		}
		if _update_flex {
			self.updateMainUiFlex();
		}
		return self;
	}
	
	///@desc Set flexpanel(element) max height
	///@arg {real} [_max_height]
	static setMaxHeight = function(_max_height = LUI_AUTO) {
		var _flex_node = self.flex_node;
		var _update_flex = false;
		if _max_height != LUI_AUTO && self.max_height != _max_height {
			self.max_height = _max_height;
			flexpanel_node_style_set_max_height(_flex_node, _max_height, flexpanel_unit.point);
			_update_flex = true;
		}
		if _update_flex {
			self.updateMainUiFlex();
		}
		return self;
	}
	
	///@desc Set flexpanel(element) min/max sizes
	///@arg {real} [_min_width]
	///@arg {real} [_max_width]
	///@arg {real} [_min_height]
	///@arg {real} [_max_height]
	static setMinMaxSize = function(_min_width = LUI_AUTO, _max_width = LUI_AUTO, _min_height = LUI_AUTO, _max_height = LUI_AUTO) {
		var _flex_node = self.flex_node;
		var _update_flex = false;
		if _min_width != LUI_AUTO && self.min_width != _min_width {
			self.min_width = _min_width;
			flexpanel_node_style_set_min_width(_flex_node, _min_width, flexpanel_unit.point);
			_update_flex = true;
		}
		if _max_width != LUI_AUTO && self.max_width != _max_width {
			self.max_width = _max_width;
			flexpanel_node_style_set_max_width(_flex_node, _max_width, flexpanel_unit.point);
			_update_flex = true;
		}
		if _min_height != LUI_AUTO && self.min_height != _min_height {
			self.min_height = _min_height;
			flexpanel_node_style_set_min_height(_flex_node, _min_height, flexpanel_unit.point);
			_update_flex = true;
		}
		if _max_height != LUI_AUTO && self.max_height != _max_height {
			self.max_height = _max_height;
			flexpanel_node_style_set_max_height(_flex_node, _max_height, flexpanel_unit.point);
			_update_flex = true;
		}
		if _update_flex {
			self.updateMainUiFlex();
		}
		return self;
	}
	
	///@desc Set flexpanel margin
	///@arg {real} _margin
	static setMargin = function(_margin) {
		self.style_overrides.margin = _margin;
		if (!is_undefined(self.main_ui)) {
	        self._applyStyles();
	        self.updateMainUiFlex();
	    }
		return self;
	}
	
	///@desc Set flexpanel padding
	///@arg {real} _padding
	static setPadding = function(_padding) {
		self.style_overrides.padding = _padding;
		if (!is_undefined(self.main_ui)) {
	        self._applyStyles();
	        self.updateMainUiFlex();
	    }
		return self;
	}
	
	///@desc Set flexpanel gap
	///@arg {real} _gap
	static setGap = function(_gap) {
		self.style_overrides.gap = _gap;
		if (!is_undefined(self.main_ui)) {
	        self._applyStyles();
	        self.updateMainUiFlex();
	    }
		return self;
	}
	
	///@desc Set flexpanel border
	///@arg {real} _border
	static setBorder = function(_border) {
		self.style_overrides.border = _border;
		if (!is_undefined(self.main_ui)) {
	        self._applyStyles();
	        self.updateMainUiFlex();
	    }
		return self;
	}
	
	///@desc Set flexpanel direction (Default: flexpanel_flex_direction.column)
	///@arg {constant.flexpanel_flex_direction} [_direction]
	static setFlexDirection = function(_direction = flexpanel_flex_direction.column) {
		var _flex_node = self.getContainer().flex_node;
		flexpanel_node_style_set_flex_direction(_flex_node, _direction);
		self.updateMainUiFlex();
		return self;
	}
	
	///@desc Set flexpanel wrap type (Default: flexpanel_wrap.no_wrap)
	///@arg {constant.flexpanel_wrap} [_wrap]
	static setFlexWrap = function(_wrap = flexpanel_wrap.no_wrap) {
		var _flex_node = self.getContainer().flex_node;
		flexpanel_node_style_set_flex_wrap(_flex_node, _wrap);
		self.updateMainUiFlex();
		return self;
	}
	
	///@desc Set flexpanel grow (Default: 1)
	///@arg {real} [_grow]
	static setFlexGrow = function(_grow = 1) {
		var _flex_node = self.flex_node;
		flexpanel_node_style_set_flex_grow(_flex_node, _grow);
		self.updateMainUiFlex();
		return self;
	}
	
	///@desc Set flexpanel shrink type (Default: 1)
	///@arg {real} [_shrink]
	static setFlexShrink = function(_shrink = 1) {
		var _flex_node = self.flex_node;
		flexpanel_node_style_set_flex_shrink(_flex_node, _shrink);
		self.updateMainUiFlex();
		return self;
	}
	
	///@desc Set flexpanel justify content (Default: flexpanel_justify.start)
	///Aligns items along the main axis, controlling horizontal spacing
	///@arg {constant.flexpanel_justify} [_flex_justify]
	static setFlexJustifyContent = function(_flex_justify = flexpanel_justify.start) {
		var _flex_node = self.getContainer().flex_node;
		flexpanel_node_style_set_justify_content(_flex_node, _flex_justify);
		self.updateMainUiFlex();
		return self;
	}
	
	///@desc Set flexpanel align items (Default: flexpanel_align.stretch)
	///Aligns items along the cross axis, affecting vertical alignment
	///@arg {constant.flexpanel_align} [_flex_align]
	static setFlexAlignItems = function(_flex_align = flexpanel_align.stretch) {
		var _flex_node = self.getContainer().flex_node;
		flexpanel_node_style_set_align_items(_flex_node, _flex_align);
		self.updateMainUiFlex();
		return self;
	}
	
	///@desc Set flexpanel align content (Default: flexpanel_justify.start)
	///Defines the spacing between flex lines when wrapping occurs.
	///@arg {constant.flexpanel_justify} [_flex_justify]
	static setFlexAlignContent = function(_flex_justify = flexpanel_justify.start) {
		var _flex_node = self.getContainer().flex_node;
		flexpanel_node_style_set_align_content(_flex_node, _flex_justify);
		self.updateMainUiFlex();
		return self;
	}
	
	///@desc Set flexpanel align self (Default: flexpanel_align.auto)
	///Overrides the container's alignment for this item on the cross axis
	///@arg {constant.flexpanel_align} [_flex_align]
	static setFlexAlignSelf = function(_flex_align = flexpanel_align.auto) {
		var _flex_node = self.flex_node;
		flexpanel_node_style_set_align_self(_flex_node, _flex_align);
		self.updateMainUiFlex();
		return self;
	}
	
	///@desc Set flexpanel display(flex) or not(none) (Default: flexpanel_display.flex)
	///@arg {constant.flexpanel_display} [_flex_display]
	static setFlexDisplay = function(_flex_display = flexpanel_display.flex) {
		var _flex_node = self.flex_node;
		flexpanel_node_style_set_display(_flex_node, _flex_display);
		self.updateMainUiFlex();
		return self;
	}
	
	///@desc Set container, Sometimes the container may not be the element itself, but the element inside it (for example: LuiTab, LuiScrollPanel...)
	static setContainer = function(_container) {
		self.container = _container;
		return self;
	}
	
	///@desc setFocus
	static setFocus = function() {
		self.has_focus = true;
		self._dispatchEvent(LUI_EV_FOCUS_SET);
		return self;
	}
	
	///@desc Set popup text to element when mouse on it
	static setTooltip = function(_string) {
		self.tooltip = _string;
		return self;
	}
	
	///@desc Binds the object/struct variable to the element value
	static bindVariable = function(_source, _variable) {
		if (_source != noone && _variable != "") {
			self.binded_variable = {
				source : _source,
				variable : _variable
			}
			if !variable_instance_exists(_source, _variable) {
				_luiPrintWarning($"Trying to bind variable: Can't find variable '{_variable}'!");
			}
		} else {
			_luiPrintError($"Wrong variable name or instance!");
		}
		return self;
	}
	
	///@desc Set style
	static setStyle = function(_style) {
		self.style = new LuiStyle(_style);
		self.is_custom_style_setted = true;
		if is_array(self.content) {
			array_foreach(self.content, function(_elm) {
				_elm.setStyleChilds(self.style);
			});
		}
		self._applyStyles();
		
		return self;
	}
	
	///@desc Set style for child elements
	static setStyleChilds = function(_style) {
		if self.is_custom_style_setted == false {
			self.style = _style;
		}
		for (var i = array_length(self.content)-1; i >= 0 ; --i) {
			var _element = self.content[i];
			_element.setStyleChilds(_style);
		}
		return self;
	}
	
	///@desc Set flag to update content
	static setNeedToUpdateContent = function(_update_parent) {
		if is_undefined(self.parent) return self;
		self.need_to_update_content = true;
		self.parent.setNeedToUpdateContent(_update_parent);
		return self;
	}
	
	///@desc Set element visibility (only visibility not flex display)
	static setVisible = function(_visible) {
		if self.visibility_switching {
			if self.visible != _visible {
				// Change visible
				self.visible = _visible;
				// Events show/hide
				if _visible {
					self._dispatchEvent(LUI_EV_SHOW);
				} else {
					self._dispatchEvent(LUI_EV_HIDE);
				}
				// Grid update
				self._updateScreenGrid();
				// Update childs
				for (var i = array_length(self.content) - 1; i >= 0; i--) {
					self.content[i].setVisible(self.visible);
				}
				// Main surface update 
				self.updateMainUiSurface();
			}
		}
		return self;
	}
	
	///@desc Enable or disable visibility switching by function setVisible()
	static setVisibilitySwitching = function(_allow) {
		self.visibility_switching = _allow;
		return self;
	}
	
	///@desc Set offset region for render content
	///@arg {struct, array} _region struct{left, right, top, bottom} or array [left, right, top, bottom]
	///@deprecated
	static setRenderRegionOffset = function(_region = {left : 0, right : 0, top : 0, bottom : 0}) { //???// в целом еще может пригодится
		if is_struct(_region) {
			render_region_offset = _region;
		} else if is_array(_region) {
			if array_length(_region) != 4 {
				array_resize(_region, 4);
			}
			render_region_offset = {
				left : _region[0],
				right : _region[1],
				top : _region[2],
				bottom : _region[3]
			}
		} else {
			_luiPrintWarning($"setRenderRegionOffset: Wrong type appear, when struct or array is expected!");
		}
		
		return self;
	}
	
	///@desc Enables/Disables mouse ignore mode
	static setMouseIgnore = function(_ignore = true) {
		self.ignore_mouse = _ignore;
		return self;
	}
	
	///@desc Enables/Disables mouse ignore mode for this and all nested elements
	static setMouseIgnoreAll = function(_ignore = true) {
		self.ignore_mouse = _ignore;
		self.ignore_mouse_all = _ignore;
		var _content = self.getContent();
		for (var i = 0, n = array_length(_content); i < n; i++) {
			var _e = _content[i];
			_e.setMouseIgnoreAll(self.ignore_mouse_all);
		}
		return self;
	}
	
	// DEPTH SYSTEM
	
	///@desc Sets a new depth value for the element and recalculates depth_array for itself and its children
	static setDepth = function(_new_z) {
	    // Update the element's z value
	    self.z = _new_z;
	    
	    // Rebuild depth_array: parent's depth_array + new z
	    if (self.parent != undefined) {
	        self.depth_array = array_concat(self.parent.depth_array, [self.z]);
	    } else {
	        self.depth_array = [self.z];
	    }
	    
	    // Update main UI surface
	    self.updateMainUiSurface();
	    
	    // Recursively update depth_array for all children
	    for (var i = 0, n = array_length(self.content); i < n; i++) {
	        var _element = self.content[i];
	        _element.depth_array = array_concat(self.depth_array, [_element.z]);
	        // Recursively update children's children
	        _element.setDepth(_element.z); // Reuse setDepth to update children
	    }
	    
	    return self;
	}
	
	///@desc Brings the element to the front by setting a new maximum z value
	static bringToFront = function() {
		// Increment global.lui_max_z to get a new maximum z
		global.lui_max_z++;
		
		// Set the new depth using setDepth
		self.setDepth(global.lui_max_z);
		
		return self;
	}
	
	// PRIVATE SYSTEM - Internal methods, not for public use
	
	///@desc Init element variables
	///@ignore
	static _initElement = function() {
		self.auto_x = self.x == LUI_AUTO && self.r == LUI_AUTO;
		self.auto_y = self.y == LUI_AUTO && self.b == LUI_AUTO;
		self.auto_width = self.width == LUI_AUTO;
		self.auto_height = self.height == LUI_AUTO;
		self._initFlexNode();
		self.is_initialized = true;
	}
	
	///@desc Initialize flex node
	///@ignore
	static _initFlexNode = function() {
		// Position X
		if !self.auto_x {
			if self.x != LUI_AUTO {
				flexpanel_node_style_set_position(self.flex_node, flexpanel_edge.left, self.x, flexpanel_unit.point);
			}
			if self.r != LUI_AUTO {
				flexpanel_node_style_set_position(self.flex_node, flexpanel_edge.right, self.r, flexpanel_unit.point);
			}
		}
		
		// Position Y
		if !self.auto_y {
			if self.y != LUI_AUTO {
				flexpanel_node_style_set_position(self.flex_node, flexpanel_edge.top, self.y, flexpanel_unit.point);
			}
			if self.b != LUI_AUTO {
				flexpanel_node_style_set_position(self.flex_node, flexpanel_edge.bottom, self.b, flexpanel_unit.point);
			}
		}
		
		// Width
		if !self.auto_width {
			flexpanel_node_style_set_width(self.flex_node, self.width, flexpanel_unit.point);
		} else {
			flexpanel_node_style_set_width(self.flex_node, 100, flexpanel_unit.percent);
			flexpanel_node_style_set_flex_shrink(self.flex_node, 1);
		}
		
		// Height
		if !self.auto_height {
			flexpanel_node_style_set_height(self.flex_node, self.height, flexpanel_unit.point);
		}
	}
	
	///@desc Adds elements from a delayed array
	///@ignore
	static _addDelayedContent = function() {
		if is_array(self.delayed_content) && array_length(self.delayed_content) > 0 {
			self.getContainer().addContent(self.delayed_content);
			self.delayed_content = -1;
		}
	}
	
	///@desc Renders debug rectangles for element boundaries and view region
	///@param {real} _x X-coordinate for rendering (default 0)
	///@param {real} _y Y-coordinate for rendering (default 0)
	///@ignore
	static _renderDebugRectangles = function(_x = 0, _y = 0) {
	    // Remember previous colors
	    var _prev_color = draw_get_color();
	    var _prev_alpha = draw_get_alpha();
	    
	    // Set colors based on mouse hover
	    if isMouseHovered() {
	        draw_set_alpha(1);
	        draw_set_color(c_red);
	    } else {
	        draw_set_alpha(0.5);
	        draw_set_color(make_color_hsv(self.element_id * 20 % 255, 255, 255));
	    }
	    
	    // Draw element boundary rectangle
	    if isMouseHovered() {
	        draw_rectangle(_x - 1, _y - 1, _x + self.width - 1 + 1, _y + self.height - 1 + 1, true);
	    } else {
	        draw_rectangle(_x, _y, _x + self.width - 1, _y + self.height - 1, true);
	    }
	    
	    // Draw view region rectangle
	    draw_set_color(make_color_hsv(self.element_id * 20 % 255, 255, 255));
	    draw_rectangle(self.view_region.x1, self.view_region.y1, self.view_region.x2, self.view_region.y2, true);
	    
	    // Reset colors
	    draw_set_color(_prev_color);
	    draw_set_alpha(_prev_alpha);
	}
	
	///@desc Renders debug text information for the element
	///@param {real} _x X-coordinate for rendering (default 0)
	///@param {real} _y Y-coordinate for rendering (default 0)
	///@ignore
	static _renderDebugInfo = function(_x = 0, _y = 0) {
	    // Set font if defined
	    if !is_undefined(self.style.font_debug) {
	        draw_set_font(self.style.font_debug);
	    }
	    
	    // Remember previous colors
	    var _prev_color = draw_get_color();
	    var _prev_alpha = draw_get_alpha();
	    
	    // Set colors based on mouse hover
	    if isMouseHovered() {
	        draw_set_alpha(1);
	        draw_set_color(c_red);
	    } else {
	        draw_set_alpha(0.5);
	        draw_set_color(make_color_hsv(self.element_id * 20 % 255, 255, 255));
	    }
	    
	    // Draw debug text
		_drawDebugText(_x, _y, 
			"id: " + string(self.element_id) + "\n" +
			"name: " + string(self.name) + "\n" +
			"class: " + instanceof(self) + "\n" +
			"x: " + string(self.x) + (self.auto_x ? " (auto)" : "") + " y: " + string(self.y) + (self.auto_y ? " (auto)" : "") + "\n" +
			"w: " + string(self.width) + (self.auto_width ? " (auto)" : "") + " h: " + string(self.height) + (self.auto_height ? " (auto)" : "") + "\n" +
			"min_w: " + string(self.min_width) + " min_h: " + string(self.min_height) + " max_w: " + string(self.max_width) + " max_h: " + string(self.max_height) + "\n" +
			"v: " + string(self.value) + "\n" +
			"content: " + string(array_length(self.content)) + "/" + string(array_length(self.delayed_content)) + "\n" +
			"parent: " + (is_undefined(self.parent) ? "undefined" : self.parent.name) + "\n" +
			"z: " + string(self.z) + " " + string(self.depth_array) + "\n" +
			"nesting_level: " + string(self.nesting_level)
		);
	    
	    // Reset colors
	    draw_set_color(_prev_color);
	    draw_set_alpha(_prev_alpha);
	}
	
	///@desc Renders debug info for the element (rectangles and text)
	///@param {real} _x X-coordinate for rendering (default 0)
	///@param {real} _y Y-coordinate for rendering (default 0)
	///@ignore
	static _renderDebug = function(_x = 0, _y = 0) {
	    // Draw rectangles
	    self._renderDebugRectangles(_x, _y);
	    
	    // Draw debug text info
		if global.lui_debug_mode == 2
	    self._renderDebugInfo(_x, _y);
	}
	
	///@desc Draw debug text
	///@ignore
	static _drawDebugText = function(_x, _y, text) {
		var _text_width = string_width(text);
		var _text_height = string_height(text);
		_x = clamp(_x, 0, display_get_gui_width() - _text_width);
		_y = clamp(_y, 0, display_get_gui_height() - _text_height);
		draw_set_color(c_black);
		draw_rectangle(_x, _y, _x + _text_width, _y + _text_height, false);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_color(c_white);
		draw_text(_x, _y, text);
	}
	
	///@desc Returns text fit to width
	///@return {string}
	///@ignore
	static _truncateTextToFitWidth = function(_string, _width = infinity) {
		// Calculate initial text width
		var _str_to_draw = _string;
		var _str_width = string_width(_str_to_draw);
		
		// Check if the text needs to be truncated
		if (_str_width > _width) {
			// Calculate the width of "..." once, to use in our calculations
			var _ellipsis = "...";
			var _ellipsis_width = string_width(_ellipsis);
			
			// Calculate the width available for the main part of the string
			var _available_width = _width - _ellipsis_width;
			
			// Initialize binary search bounds
			var _low = 1;
			var _high = string_length(_string);
			var _mid;
			
			// Perform binary search to find the cutoff point
			while (_low < _high) {
				_mid = floor((_low + _high) / 2);
				_str_to_draw = string_copy(_string, 1, _mid);
				_str_width = string_width(_str_to_draw);
				
				if (_str_width < _available_width) {
					_low = _mid + 1;
				} else {
					_high = _mid;
				}
			}
			
			// The final string should be within the bounds
			_str_to_draw = string_copy(_string, 1, _high - 1) + _ellipsis;
		}
		
		// Return the final text
		return _str_to_draw;
	};
	
	///@desc Draw text fit to width
	///@ignore
	static _drawTruncatedText = function(_x, _y, _string, _width = infinity) {
		// Calculate initial text width
		var _str_to_draw = _string;
		var _str_width = string_width(_str_to_draw);
		
		// Check if the text needs to be truncated
		if (_str_width > _width) {
			// Calculate the width of "..." once, to use in our calculations
			var _ellipsis = "...";
			var _ellipsis_width = string_width(_ellipsis);
			
			// Calculate the width available for the main part of the string
			var _available_width = _width - _ellipsis_width;
			
			// Initialize binary search bounds
			var _low = 1;
			var _high = string_length(_string);
			var _mid;
			
			// Perform binary search to find the cutoff point
			while (_low < _high) {
				_mid = floor((_low + _high) / 2);
				_str_to_draw = string_copy(_string, 1, _mid);
				_str_width = string_width(_str_to_draw);
				
				if (_str_width < _available_width) {
					_low = _mid + 1;
				} else {
					_high = _mid;
				}
			}
			
			// The final string should be within the bounds
			_str_to_draw = string_copy(_string, 1, _high - 1) + _ellipsis;
		}
		
		// Draw the final text
		draw_text(_x, _y, _str_to_draw);
	};
	
	///@ignore
	static _registerElementName = function() {
		if !variable_struct_exists(self.main_ui.element_names, self.name) && self.name != LUI_AUTO_NAME {
			variable_struct_set(self.main_ui.element_names, self.name, self);
		} else {
			if self.name != LUI_AUTO_NAME {
				_luiPrintWarning($"Element name \"{self.name}\" already exists! A new name will be given automatically.");
			}
			if self.name == LUI_AUTO_NAME {
				self.name = "";
			}
			var _new_name = self.name + "_" + string(self.element_id) + "_" + md5_string_utf8(self.name + string(self.element_id));
			variable_struct_set(self.main_ui.element_names, _new_name, self);
			self.name = _new_name;
		}
	}
	
	///@ignore
	static _deleteElementName = function() {
		if !is_undefined(self.main_ui) && self != self.main_ui {
			if variable_struct_exists(self.main_ui.element_names, self.name) {
				variable_struct_remove(self.main_ui.element_names, self.name);
			} else {
				_luiPrintError($"_deleteElementName: Can't find element {instanceof(self)} with name \"{self.name}\"!");
			}
		}
	}
	
	///@desc Add element in system ui grid
	///@ignore
	static _addToScreenGrid = function() {
		if (!self.is_visible_in_region || !self.visible) {
			return false;
		}
	
		// Calculate the start and end cells that the element intersects
		var _elm_x_start = floor(self.x / LUI_GRID_SIZE);
		var _elm_y_start = floor(self.y / LUI_GRID_SIZE);
		var _elm_x_end = floor((self.x + self.width) / LUI_GRID_SIZE);
		var _elm_y_end = floor((self.y + self.height) / LUI_GRID_SIZE);
	
		// Restrict grid pass to only the required cells
		for (var _x = _elm_x_start; _x <= _elm_x_end; ++_x) {
			for (var _y = _elm_y_start; _y <= _elm_y_end; ++_y) {
				var _key = string(_x) + "_" + string(_y);
				
				if (variable_struct_exists(self.main_ui._screen_grid, _key)) {
					var _array = self.main_ui._screen_grid[$ _key];
					_array[array_length(_array)] = self;
					self._grid_location[array_length(self._grid_location)] = _key;
				}
			}
		}
	};
	
	///@desc Delete element from system ui grid
	///@ignore
	static _deleteFromScreenGrid = function() {
	    var _grid_location_length = array_length(self._grid_location);
	    for (var i = 0; i < _grid_location_length; i++) {
	        var _key = self._grid_location[i];
	        if (variable_struct_exists(self.main_ui._screen_grid, _key)) {
	            var _array = self.main_ui._screen_grid[$ _key];
	            var _index = array_get_index(_array, self);
	            if (_index != -1) {
	                array_delete(_array, _index, 1);
	            }
	        }
	    }
	    self._grid_location = [];
	}
	
	///@desc Update element in system ui grid
	///@ignore
	static _updateScreenGrid = function() {
		self._deleteFromScreenGrid();
		self._addToScreenGrid();
	}
	
	///@desc Delete element from grid and clean up array
	///@ignore
	static _cleanupScreenGrid = function() {
		self._deleteFromScreenGrid();
		self._grid_location = -1;
	}
	
	///@ignore
	static _updateViewRegion = function() {
    	
		// Prevent this element from being updated if it has just been added
		if self.start_x == -1 || self.start_y == -1 return false;
		
		// Store previous visibility state
		var _was_visible = self.is_visible_in_region;
		
		// Set the initial dimensions of the visible region based on the current coordinates and dimensions of the element
	    self.view_region = {
	        x1: self.x,
	        y1: self.y,
	        x2: self.x + self.width,
	        y2: self.y + self.height
	    };
	    
	    // If there is no parent or it has no view_region, the element is considered visible, exit
	    if (self.parent == undefined) {
	        self.is_visible_in_region = true;
	        return;
	    }
	    
	    // Crop the view_region to the boundaries of the parent region
	    var _parent_region = self.parent.view_region;
	    self.view_region.x1 = max(_parent_region.x1, self.view_region.x1);
	    self.view_region.y1 = max(_parent_region.y1, self.view_region.y1);
	    self.view_region.x2 = min(_parent_region.x2, self.view_region.x2);
	    self.view_region.y2 = min(_parent_region.y2, self.view_region.y2);
	    
	    // Check if the element falls into the visible region of the parent
	    var _region_width = self.view_region.x2 - self.view_region.x1;
	    var _region_height = self.view_region.y2 - self.view_region.y1;
	    self.is_visible_in_region = (_region_width > 0 && _region_height > 0) &&
	                                !(self.x + self.width < _parent_region.x1 || self.x > _parent_region.x2 ||
	                                  self.y + self.height < _parent_region.y1 || self.y > _parent_region.y2);
		
		// Update grid if visibility changed
		if (_was_visible != self.is_visible_in_region) {
			self._updateScreenGrid();
		}
	}
	
	///@desc Apply local and inherited styles to the flex node
	///@ignore
	static _applyStyles = function() {
	    if (is_undefined(self.style)) return;
		
	    var _container_node = self.getContainer().flex_node;
		
	    // Base style
	    flexpanel_node_style_set_margin(_container_node, flexpanel_edge.all_edges, self.style.margin);
	    flexpanel_node_style_set_padding(_container_node, flexpanel_edge.all_edges, self.style.padding);
	    flexpanel_node_style_set_gap(_container_node, flexpanel_gutter.all_gutters, self.style.gap);
	    flexpanel_node_style_set_border(_container_node, flexpanel_edge.all_edges, self.style.border);
	    // ... 
		
	    // Local style
	    var _override_keys = variable_struct_get_names(self.style_overrides);
		
	    // Apply local style
	    for (var i = 0; i < array_length(_override_keys); i++) {
	        var _key = _override_keys[i];
	        var _value = self.style_overrides[$ _key];
			
	        switch (_key) {
	            case "margin":
	                flexpanel_node_style_set_margin(_container_node, flexpanel_edge.all_edges, _value);
	                break;
				
				case "padding":
	                flexpanel_node_style_set_padding(_container_node, flexpanel_edge.all_edges, _value);
	                break;
	            
	            case "gap":
	                flexpanel_node_style_set_gap(_container_node, flexpanel_gutter.all_gutters, _value);
	                break;
	            
	            case "border":
	                flexpanel_node_style_set_border(_container_node, flexpanel_edge.all_edges, _value);
	                break;
	        }
	    }
	}
	
	///@desc Calculate all sizes and positions of elements
	///@ignore
	static _calculateLayout = function() {
		if !is_undefined(self.main_ui) {
            flexpanel_calculate_layout(self.main_ui.flex_node, self.main_ui.width, self.main_ui.height, flexpanel_direction.LTR);
            return true;
        }
        return false;
    }
		
	///@desc Update position, size and z depth for specified flex node
	///@ignore
	static _updateFlex = function(_node) {
	    var _pos = flexpanel_node_layout_get_position(_node, false);
	    var _data = flexpanel_node_get_data(_node);
	    var _element = _data.element;
	    
		// Check position change
		var _position_changed = (_element.x != _pos.left || _element.y != _pos.top);
		// Check size change
		var _size_changed = (_element.width != _pos.width || _element.height != _pos.height);
		
	    _element.x = _pos.left;
	    _element.y = _pos.top;
	    _element.width = _pos.width;
	    _element.height = _pos.height;
	    if (_element.start_x == -1) {
	        _element.start_x = _element.x;
	    }
	    if (_element.start_y == -1) {
	        _element.start_y = _element.y;
	    }
		
		// If position was changed, call position update event
		if (_position_changed) {
			_element._dispatchEvent(LUI_EV_POSITION_UPDATE);
		}
		
		// If size was changed, call size update event
		if (_size_changed) {
			_element._dispatchEvent(LUI_EV_SIZE_UPDATE);
		}
	    
	    _element._updateViewRegion();
		
		if _element.is_visible_in_region == false {
			_element._deleteFromScreenGrid();
			return;
		}
		
	    var _children_count = flexpanel_node_get_num_children(_node);
	    for (var i = 0; i < _children_count; i++) {
	        var _child = flexpanel_node_get_child(_node, i);
	        _element._updateFlex(_child);
	    }
	}
	
	///@desc Update position, size and z depth of all elements with depth reset
	///@deprecated
	static flexUpdateAll = function() {
		if !is_undefined(main_ui) {
			// Update all elements
			_updateFlex(self.main_ui.flex_node);
		}
	}
	
	///@desc Update element value from binded variable
	///@ignore
	static _updateFromBindedVariable = function() {
		var _source = self.binded_variable.source;
		var _variable = self.binded_variable.variable;
		if (_source != noone && variable_instance_exists(_source, _variable)) {
			var _source_value = variable_instance_get(_source, _variable);
			self.set(_source_value);
		} else {
			_luiPrintError($"Binded variable is wrong or no longer available!");
			self.binded_variable = undefined;
		}
	}
	
	///@desc Update binded variable from element value
	///@ignore
	static _updateToBindedVariable = function() {
		var _source = self.binded_variable.source;
		var _variable = self.binded_variable.variable;
		if (_source != noone && variable_instance_exists(_source, _variable)) {
			var _element_value = self.get();
			variable_instance_set(_source, _variable, _element_value);
		} else {
			_luiPrintError($"Binded variable is wrong or no longer available!");
			self.binded_variable = undefined;
		}
	}
	
	///@desc Compare two depth arrays
	///@ignore
	function _compareDepthArrays(a, b) {
	    var len_a = array_length(a);
	    var len_b = array_length(b);
	    var min_len = min(len_a, len_b);
	    
	    for (var i = 0; i < min_len; i++) {
	        if (a[i] > b[i]) return 1;
	        if (a[i] < b[i]) return -1;
	    }
	    
	    if (len_a > len_b) return 1;
	    if (len_a < len_b) return -1;
	    return 0;
	}
	
	///@desc Recalculates depth_array for the element and all its children
	///@ignore
	static _recalculateDepthArray = function() {
	    // Rebuild depth_array: parent's depth_array + current z
	    if (self.parent != undefined) {
	        self.depth_array = array_concat(self.parent.depth_array, [self.z]);
	    } else {
	        self.depth_array = [self.z];
	    }
	    
	    // Update main UI surface
	    self.updateMainUiSurface();
	    
	    // Recursively update depth_array for all children
	    for (var i = 0, n = array_length(self.content); i < n; i++) {
	        self.content[i]._recalculateDepthArray();
	    }
	    
	    return self;
	}
	
	// SYSTEM
	
	///@desc Added elements into container of these element
	///@arg {Any} elements
	self.addContent = function(elements) {
	    
		// Convert to array if one element
		if !is_array(elements) elements = [elements];
	    
		var _elements_count = array_length(elements);
		
		// Update array with delayed content for unordered adding
	    if is_undefined(self.main_ui) {
	        if !is_array(self.delayed_content) self.delayed_content = [];
	        self.delayed_content = array_concat(self.delayed_content, elements);
	        return self;
	    }
	    
		// Take ranges from array
		var _ranges = elements[_elements_count - 1];
	    if is_array(_ranges) {
	        if array_length(_ranges) != _elements_count - 1 {
	            if LUI_LOG_ERROR_MODE == 2 {
					_luiPrintWarning($"Incorrect number of ratios for {self.name} ({instanceof(self)}). Elements {_elements_count - 1}, but ratios {array_length(_ranges)}.\nThe others will be filled in automatically and the extra ones will be cut off.");
	            }
				
				var _current_length = array_length(_ranges);
		        var _target_length = _elements_count - 1;
		        
		        if _current_length < _target_length {
		            var _sum = 0;
		            for (var i = 0; i < _current_length; i++) {
		                _sum += _ranges[i];
		            }
		            var _remaining = 1 - _sum;
		            var _num = _remaining / (_target_length - _current_length);
		            
		            while (array_length(_ranges) < _target_length) {
		                array_push(_ranges, _num);
		            }
		        }
	        }
			
	        _elements_count--;
	    }
	    
		// Adding
	    for (var i = 0; i < _elements_count; i++) {
	        
			// Get element
			var _element = elements[i];
	        
			// Init element
			_element._initElement();
			
			// Recursion prevention
	        if _element.is_adding continue;
	        _element.is_adding = true;
	        
			// Init depth
			_element.nesting_level = self.nesting_level + 1;
			_element.z = global.lui_max_z++;
			_element.depth_array = array_concat(self.depth_array, [_element.z]);
			
			// Inherit variables
	        _element.parent = self;
	        _element.main_ui = self.main_ui;
	        _element.style = self.style;
			if !is_undefined(self.ignore_mouse_all) {
				_element.ignore_mouse_all = true;
				_element.ignore_mouse = true;
			}
			
			// Flex setting up
			if _element.min_width == LUI_AUTO {
		        if _element.auto_width {
					_element.min_width = _element.style.min_width;
				} else {
					_element.min_width = min(_element.width, _element.style.min_width);
				}
			}
			if _element.min_height == LUI_AUTO {
				if _element.auto_height {
					_element.min_height = _element.style.min_height;
				} else {
					_element.min_height = min(_element.height, _element.style.min_height);
				}
			}
			flexpanel_node_style_set_min_width(_element.flex_node, _element.min_width, flexpanel_unit.point);
			flexpanel_node_style_set_min_height(_element.flex_node, _element.min_height, flexpanel_unit.point);
	        if array_length(_ranges) > 0 && i+1 <= array_length(_ranges) {
				flexpanel_node_style_set_flex(_element.flex_node, _ranges[i]);
				flexpanel_node_style_set_flex_shrink(_element.flex_node, _ranges[i]);
	        }
	        flexpanel_node_insert_child(self.flex_node, _element.flex_node, flexpanel_node_get_num_children(self.flex_node));
			
			// Apply styles settings
			_element._applyStyles();
	        
			// Register element name
	        _element._registerElementName();
	        
			// Add to content array
			if !is_array(self.content) self.content = [];
			array_push(self.content, _element);
	        _element._addDelayedContent();
	        
			// Call create event
			_element._dispatchEvent(LUI_EV_CREATE);
	        
	        _element.is_adding = false;
	    }
	    
		// Apply all positions and update content
	    self.updateMainUiFlex();
	    self.setNeedToUpdateContent(true);
	    
	    return self;
	}
	
	///@desc This function updates all nested elements
	static update = function() {
	    if (!self.is_visible_in_region || !self.visible || self.deactivated) return false;
	    
	    // Define the list of items to be processed
	    var _elements = self.content;
	    var _source_length = array_length(_elements);
	    
	    for (var i = _source_length - 1; i >= 0; --i) {
	        var _element = _elements[i];
	        
			// Delete destroyed elements
			if _element.is_destroyed {
				array_delete(_elements, i, 1);
				continue;
			}
			
	        // Skip the invisible elements
	        if (!_element.is_visible_in_region || !_element.visible || self.deactivated) continue;
	        
	        var _cur_x = _element.x;
	        var _cur_y = _element.y;
	        
	        // Update surface UI if the coordinates have changed
	        if (_element.prev_x != _cur_x || _element.prev_y != _cur_y) {
	            _element.prev_x = _cur_x;
	            _element.prev_y = _cur_y;
	            _element.updateMainUiSurface();
	        }
			
			var _cur_w = _element.width;
	        var _cur_h = _element.height;
			
			// Update surface UI if the size have changed
	        if (_element.prev_w != _cur_w || _element.prev_h != _cur_h) {
	            _element.prev_w = _cur_w;
	            _element.prev_h = _cur_h;
	            _element.updateMainUiSurface();
	        }
	        
	        // Updating the bound variables
	        if (!is_undefined(_element.binded_variable) && _element.get() != variable_instance_get(_element.binded_variable.source, _element.binded_variable.variable)) {
	            _element._updateFromBindedVariable();
	        }
	        
	        // Update content if required
	        if (_element.need_to_update_content) {
				_element._dispatchEvent(LUI_EV_CONTENT_UPDATE);
	            _element.need_to_update_content = false;
	        }
	        
	        // Update the grid if the area has changed
	        var _grid_x1 = floor(_element.x / LUI_GRID_ACCURACY);
	        var _grid_y1 = floor(_element.y / LUI_GRID_ACCURACY);
	        var _grid_x2 = floor((_element.x + _element.width) / LUI_GRID_ACCURACY);
	        var _grid_y2 = floor((_element.y + _element.height) / LUI_GRID_ACCURACY);
	        if (_element.grid_previous_x1 != _grid_x1 || _element.grid_previous_y1 != _grid_y1 || 
	            _element.grid_previous_x2 != _grid_x2 || _element.grid_previous_y2 != _grid_y2) {
	            _element._updateScreenGrid();
	            _element.grid_previous_x1 = _grid_x1;
	            _element.grid_previous_y1 = _grid_y1;
	            _element.grid_previous_x2 = _grid_x2;
	            _element.grid_previous_y2 = _grid_y2;
	        }
	        
	        // Execute custom step and recursive update
	        if (is_method(_element.step)) _element.step();
	        _element.update();
	    }
	}
	
	///@desc This function draws all nested elements
	static render = function() {
		
		if !is_array(self.content) return;
		
		// Sort by depth
		array_sort(self.content, function(a, b) { return a.z - b.z; });
		
		// Draw all elements
		for (var i = 0, n = array_length(self.content); i < n; i++) {
			// Get element
			var _element = self.content[i];
			// Restriction
			if !_element.is_visible_in_region || !_element.visible || _element.is_destroyed continue;
			// Draw self
			if is_method(_element.draw) _element.draw();
			// Draw content
			if _element.render_content_enabled { //???// is it right place for gpu_set_scissor ?
				if self.draw_content_in_cutted_region {
					var _gpu_scissor = gpu_get_scissor();
					var _x = self.x + self.style.render_region_offset.left;
					var _y = self.y + self.style.render_region_offset.top;
					var _w = self.width - self.style.render_region_offset.left - self.style.render_region_offset.right;
					var _h = self.height - self.style.render_region_offset.top - self.style.render_region_offset.bottom;
					gpu_set_scissor(_x, _y, _w, _h);
				}
				_element.render();
				if self.draw_content_in_cutted_region {
					gpu_set_scissor(_gpu_scissor);
				}
			}
		}
		if global.lui_debug_mode != 0 {
			for (var i = 0, n = array_length(self.content); i < n; i++) {
				//Get element
				var _element = self.content[i];
				// Restriction
				if !_element.is_visible_in_region || !_element.visible || _element.is_destroyed continue;
				// Draw debug
				if !_element.visible || !_element.is_visible_in_region continue;
				_element._renderDebug(_element.x, _element.y);
			}
			
		}
	}
	 
	///@desc Centers the content. Calls setFlexJustifyContent and setFlexAlignItems with centering
	static centerContent = function() {
		self.setFlexJustifyContent(flexpanel_justify.center)
			.setFlexAlignItems(flexpanel_align.center);
		return self;
	}
	
	///@desc Remove focus from element
	static removeFocus = function() {
		self.has_focus = false;
		self._dispatchEvent(LUI_EV_FOCUS_REMOVE);
		return self;
	}
	
	///@desc Activate an element
	static activate = function() {
		self.deactivated = false;
		if is_array(self.content)
		array_foreach(self.content, function(_elm) {
			_elm.activate();
		});
		return self;
	}
	
	///@desc Deactivate an element
	static deactivate = function() {
		self.deactivated = true;
		if is_array(self.content)
		array_foreach(self.content, function(_elm) {
			_elm.deactivate();
		});
		return self;
	}
	
	///@desc Update main ui surface
	static updateMainUiSurface = function() {
		if is_undefined(self.main_ui) return self;
		self.main_ui.needs_redraw_surface = true;
		return self;
	}
	
	///@desc Update main ui flex
	static updateMainUiFlex = function() {
		if is_undefined(self.main_ui) return self;
		self.main_ui.needs_update_flex = true;
		return self;
	}
	
	///@desc Returns true if the mouse is hovered over this element
	static isMouseHovered = function() {
		return self.is_mouse_hovered;
	}
	
	///@desc Returns true if the mouse is hovered over this element, excluding all elements above it
	static isMouseHoveredExc = function() {
		if !self.visible return false;
		var _mouse_x = device_mouse_x_to_gui(0);
		var _mouse_y = device_mouse_y_to_gui(0);
		var _element_x = self.x;
		var _element_y = self.y;
		var _on_this = point_in_rectangle(_mouse_x, _mouse_y, _element_x, _element_y, _element_x + self.width - 1, _element_y + self.height - 1);
		return _on_this;
	}
	
	///@desc Returns true if the mouse is hovered over this element and its parent
	static isMouseHoveredParents = function() {
		if is_undefined(self.parent) return true;
		if self.isMouseHoveredExc() {
			return self.parent.isMouseHoveredParents();
		} else {
			return false;
		}
	}
	
	///@desc Returns true if the specified rectangle is within the parent and its parents at the same time
	///@deprecated
	static isInsideParents = function(_x1, _y1, _x2, _y2) {
		if is_undefined(self.parent) return true;
		var _parent_x = self.parent.x;
		var _parent_y = self.parent.y;
		var _inside_parent = rectangle_in_rectangle(
			_x1, _y1, _x2, _y2,
			_parent_x, _parent_y, _parent_x + self.parent.width, _parent_y + self.parent.height
		);
		if _inside_parent {
			return self.parent.isInsideParents(_x1, _y1, _x2, _y2);
		} else {
			return false;
		}
	}
	
	///@desc Returns true if the mouse is hovered over the descendants of this element
	static isMouseHoveredChilds = function() {
		if !self.visible return false;
		var _mouse_x = device_mouse_x_to_gui(0);
		var _mouse_y = device_mouse_y_to_gui(0);
		var _on_element = false;
		for (var i = 0, n = array_length(self.content); i < n; ++i) {
		    var _element = self.content[i];
			if _element.isMouseHoveredChilds() {
				return true;
			}
		}
		return self.isMouseHovered() ? true : false;
	}
	
	///@desc Set visible to false and flex display to none
	static hide = function() {
		self.setVisible(false).setFlexDisplay(flexpanel_display.none);
		return self;
	}
	
	///@desc Set visible to true and flex display to flex
	static show = function() {
		self.setVisible(true).setFlexDisplay(flexpanel_display.flex);
		return self;
	}
	
	///@desc Destroys all nested elements
	static destroyContent = function() {
	    while (array_length(self.content) > 0) {
	        var _element = array_pop(self.content);
	        if (!is_undefined(_element)) {
	            _element.destroy();
	        }
	    }
	}
	
	///@desc Destroys self and all nested elements
	self.destroy = function() {
		// Double-Destroy protection
		if (self.is_destroyed) {
			return;
		}
		// Double-Destroy protection
		self.is_destroyed = true;
		// Destroy all content
		self.destroyContent();
		// Remove focus from main ui
		if !is_undefined(main_ui) && self == main_ui.element_in_focus {
			//self.main_ui.element_in_focus.removeFocus(); //???//
			self.main_ui.element_in_focus = undefined;
		}
		self._deleteElementName();
		self._cleanupScreenGrid();
		self.setNeedToUpdateContent(true);
		self.updateMainUiFlex();
		self.updateMainUiSurface();
		// Delete flex_node
		if (!is_undefined(self.flex_node)) {
		    // For the rest of the elements to react to the disappearance of this
			flexpanel_node_style_set_display(self.flex_node, flexpanel_display.none);
		    // Delete flex node from memory
		    self.flex_node = flexpanel_delete_node(self.flex_node, true);
		}
		// Call destroy event
		self._dispatchEvent(LUI_EV_DESTROY);
		// Clean all arrays and structs
		self.content = -1;
		self.depth_array = -1;
		delete self.style_overrides; self.style_overrides = undefined;
		delete self.render_region_offset; self.render_region_offset = undefined;
		delete self.view_region; self.view_region = undefined;
		delete self.binded_variable; self.binded_variable = undefined;
		delete self.data; self.data = undefined;
		self.event_listeners = {}
		// Decrement global counter
		global.lui_element_count--;
	}
}