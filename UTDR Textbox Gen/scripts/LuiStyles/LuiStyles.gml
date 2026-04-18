enum LUI_ANIM {
	none,
}

///@desc Style for UI
///@arg {Struct} [_style]
function LuiStyle(_style = {}) constructor {
	//Fonts
	font_default = _style[$ "font_default"] ?? undefined;
	font_buttons = _style[$ "font_buttons"] ?? undefined;
	font_debug = _style[$ "font_debug"] ?? undefined;
	//Sprites
	sprite_panel = _style[$ "sprite_panel"] ?? undefined;
	sprite_panel_border = _style[$ "sprite_panel_border"] ?? undefined;
	sprite_input = _style[$ "sprite_input"] ?? undefined;
	sprite_input_border = _style[$ "sprite_input_border"] ?? undefined;
	sprite_button = _style[$ "sprite_button"] ?? undefined;
	sprite_button_border = _style[$ "sprite_button_border"] ?? undefined;
	sprite_checkbox = _style[$ "sprite_checkbox"] ?? undefined;
	sprite_checkbox_pin = _style[$ "sprite_checkbox_pin"] ?? undefined;
	sprite_checkbox_border = _style[$ "sprite_checkbox_border"] ?? undefined;
	sprite_progress_bar = _style[$ "sprite_progress_bar"] ?? undefined;
	sprite_progress_bar_value = _style[$ "sprite_progress_bar_value"] ?? undefined;
	sprite_progress_bar_border = _style[$ "sprite_progress_bar_border"] ?? undefined;
	sprite_progress_ring = _style[$ "sprite_progress_ring"] ?? undefined;
	sprite_progress_ring_value = _style[$ "sprite_progress_ring_value"] ?? undefined;
	sprite_progress_ring_border = _style[$ "sprite_progress_ring_border"] ?? undefined;
	sprite_slider_knob = _style[$ "sprite_slider_knob"] ?? undefined;
	sprite_slider_knob_border = _style[$ "sprite_slider_knob_border"] ?? undefined;
	sprite_scroll_pin = _style[$ "sprite_scroll_pin"] ?? undefined;
	sprite_scroll_pin_border = _style[$ "sprite_scroll_pin_border"] ?? undefined;
	sprite_scroll_slider = _style[$ "sprite_scroll_slider"] ?? undefined;
	sprite_combobox = _style[$ "sprite_combobox"] ?? undefined;
	sprite_combobox_border = _style[$ "sprite_combobox_border"] ?? undefined;
	sprite_combobox_item = _style[$ "sprite_combobox_item"] ?? undefined;
	sprite_combobox_item_border = _style[$ "sprite_combobox_item_border"] ?? undefined;
	sprite_combobox_arrow = _style[$ "sprite_combobox_arrow"] ?? undefined;
	sprite_tab = _style[$ "sprite_tab"] ?? undefined;
	sprite_tab_border = _style[$ "sprite_tab_border"] ?? undefined;
	sprite_tabs = _style[$ "sprite_tabs"] ?? undefined;
	sprite_tabs_border = _style[$ "sprite_tabs_border"] ?? undefined;
	sprite_tooltip = _style[$ "sprite_tooltip"] ?? undefined;
	sprite_tooltip_border = _style[$ "sprite_tooltip_border"] ?? undefined;
	sprite_toggleswitch = _style[$ "sprite_toggleswitch"] ?? undefined;
	sprite_toggleswitch_slider = _style[$ "sprite_toggleswitch_slider"] ?? undefined;
	sprite_toggleswitch_border = _style[$ "sprite_toggleswitch_border"] ?? undefined;
	sprite_toggleswitch_slider_border = _style[$ "sprite_toggleswitch_slider_border"] ?? undefined;
	//Colors
	color_primary = _style[$ "color_primary"] ?? c_white;
	color_secondary = _style[$ "color_secondary"] ?? c_white;
    color_accent = _style[$ "color_accent"] ?? #45C952;
    color_border = _style[$ "color_border"] ?? c_gray;
    color_back = _style[$ "color_back"] ?? c_ltgray;
    color_deactivated = _style[$ "color_deactivated"] ?? c_gray;
    color_text = _style[$ "color_text"] ?? c_black;
	color_text_hint = _style[$ "color_text_hint"] ?? c_gray;
    color_hover = _style[$ "color_hover"] ?? c_gray;
    color_semantic_success = _style[$ "color_semantic_success"] ?? #4CAF50;
    color_semantic_warning = _style[$ "color_semantic_warning"] ?? #FF9800;
	color_semantic_error = _style[$ "color_semantic_error"] ?? #F44336;
    color_shadow = _style[$ "color_shadow"] ?? c_black;
	//Sounds
	sound_click = _style[$ "sound_click"] ?? undefined;
	//Settings
	min_width = _style[$ "min_width"] ?? 1;
	min_height = _style[$ "min_height"] ?? 1;
	margin = _style[$ "margin"] ?? 0;
	padding = _style[$ "padding"] ?? 0;
	gap = _style[$ "gap"] ?? 0;
	border = _style[$ "border"] ?? 0;
	scroll_step = _style[$ "scroll_step"] ?? 32;
	scroll_slider_width = _style[$ "scroll_slider_width"] ?? 16;
	render_region_offset = _style[$ "render_region_offset"] ?? {left : 0, right : 0, top : 0, bottom : 0};
	input_cursor = _style[$ "input_cursor"] ?? "|";
	input_password = _style[$ "input_password"] ?? "•";
	//Render functions
	sprite_render_function = _style[$ "sprite_render_function"] ?? undefined; //function(_sprite, _subimg, _x, _y, _width, _height, _color, _alpha)
	//Animations (WIP) //???//
	anim_on_create = _style[$ "anim_on_create"] ?? LUI_ANIM.none;
	anim_on_destroy = _style[$ "anim_on_destroy"] ?? LUI_ANIM.none;
	anim_on_mouse_enter = _style[$ "anim_on_mouse_enter"] ?? LUI_ANIM.none;
	anim_on_mouse_leave = _style[$ "anim_on_mouse_leave"] ?? LUI_ANIM.none;
	
	// FONTS FUNCTIONS
	
	///@desc Set fonts (_default, _buttons, _debug)
	///@arg {asset.GMFont} _default
	///@arg {asset.GMFont} _buttons
	///@arg {asset.GMFont} _debug
	static setFonts = function(_default, _buttons, _debug) {
		// Fonts
		self.font_default = _default;
		self.font_buttons = _buttons;
		self.font_debug = _debug;
		return self;
	}
	
	// SPRITES FUNCTIONS
	
	///@desc Set default sprites for almost all components (_panel, _element, _panel_border, _element_border)
	///@arg {asset.GMSprite} _panel
	///@arg {asset.GMSprite} _element
	///@arg {asset.GMSprite} [_panel_border]
	///@arg {asset.GMSprite} [_element_border]
	static setSprites = function(_panel, _element, _panel_border = undefined, _element_border = undefined) {
		// Panel
		self.sprite_panel = _panel;
		self.sprite_panel_border = _panel_border;
		self.sprite_tab = _panel;
		self.sprite_tab_border = _panel_border;
		self.sprite_tabs = _panel;
		self.sprite_tabs_border = _panel_border;
		self.sprite_scroll_pin = _panel;
		self.sprite_scroll_pin_border = _panel_border;
		// Element
		self.sprite_input = _element;
		self.sprite_button = _element;
		self.sprite_checkbox = _element;
		self.sprite_checkbox_pin = _element;
		self.sprite_progress_bar = _element;
		self.sprite_progress_bar_value = _element;
		self.sprite_slider_knob = _element;
		self.sprite_scroll_slider = _element;
		self.sprite_combobox = _element;
		self.sprite_combobox_item = _element;
		self.sprite_tooltip = _element;
		self.sprite_progress_ring = _element;
		self.sprite_progress_ring_value = _element;
		self.sprite_combobox_arrow = _element;
		self.sprite_toggleswitch = _element;
		self.sprite_toggleswitch_slider = _element;
		// Border
		self.sprite_input_border = _element_border;
		self.sprite_button_border = _element_border;
		self.sprite_checkbox_border = _element_border;
		self.sprite_progress_bar_border = _element_border;
		self.sprite_slider_knob_border = _element_border;
		self.sprite_combobox_border = _element_border;
		self.sprite_combobox_item_border = _element_border;
		self.sprite_tooltip_border = _element_border;
		self.sprite_progress_ring_border = _element_border;
		self.sprite_toggleswitch_border = _element_border;
		self.sprite_toggleswitch_slider_border = _element_border;
		return self;
	}
	
	///@desc Set sprites for CheckBox component (_checkbox, _checkbox_pin, _checkbox_border)
	///@arg {asset.GMSprite} _checkbox
	///@arg {asset.GMSprite} _checkbox_pin
	///@arg {asset.GMSprite} [_checkbox_border]
	static setSpriteCheckbox = function(_checkbox, _checkbox_pin, _checkbox_border = undefined) {
		self.sprite_checkbox = _checkbox;
		self.sprite_checkbox_pin = _checkbox_pin;
		self.sprite_checkbox_border = _checkbox_border;
		return self;
	}
	
	///@desc Set sprites for ToggleSwitch component (_toggleswitch, _toggleswitch_slider, _toggleswitch_border, _toggleswitch_slider_border)
	///@arg {asset.GMSprite} _toggleswitch
	///@arg {asset.GMSprite} _toggleswitch_slider
	///@arg {asset.GMSprite} [_toggleswitch_border]
	///@arg {asset.GMSprite} [_toggleswitch_slider_border]
	static setSpriteToggleSwitch = function(_toggleswitch, _toggleswitch_slider, _toggleswitch_border = undefined, _toggleswitch_slider_border = undefined) {
		self.sprite_toggleswitch = _toggleswitch;
		self.sprite_toggleswitch_slider = _toggleswitch_slider;
		self.sprite_toggleswitch_border = _toggleswitch_border;
		self.sprite_toggleswitch_slider_border = _toggleswitch_slider_border;
		return self;
	}
	
	///@desc Set sprites for ProgressBar component (_progressbar, _progressbar_value, _progressbar_border)
	///@arg {asset.GMSprite} _progressbar
	///@arg {asset.GMSprite} _progressbar_value
	///@arg {asset.GMSprite} [_progressbar_border]
	static setSpriteProgressBar = function(_progressbar, _progressbar_value, _progressbar_border = undefined) {
		self.sprite_progress_bar = _progressbar;
		self.sprite_progress_bar_value = _progressbar_value;
		self.sprite_progress_bar_border = _progressbar_border;
		return self;
	}
	
	///@desc Set sprites for SliderKnob component (_slider_knob, _slider_knob_border)
	///@arg {asset.GMSprite} _slider_knob
	///@arg {asset.GMSprite} [_slider_knob_border]
	static setSpriteSliderKnob = function(_slider_knob, _slider_knob_border = undefined) {
		self.sprite_slider_knob = _slider_knob;
		self.sprite_slider_knob_border = _slider_knob_border;
		return self;
	}
	
	///@desc Set sprites for Tabs component (_tabs, _tab, _tabs_border, _tab_border)
	///@arg {asset.GMSprite} _tabs
	///@arg {asset.GMSprite} _tab
	///@arg {asset.GMSprite} [_tabs_border]
	///@arg {asset.GMSprite} [_tab_border]
	static setSpriteTabs = function(_tabs, _tab, _tabs_border = undefined, _tab_border = undefined) {
		self.sprite_tabs = _tabs;
		self.sprite_tabs_border = _tabs_border;
		self.sprite_tab = _tab;
		self.sprite_tab_border = _tab_border;
		return self;
	}
	
	///@desc Set sprite for ComboBox arrow (_combobox_arrow)
	///@arg {asset.GMSprite} [_combobox_arrow]
	static setSpriteComboBoxArrow = function(_combobox_arrow = undefined) {
		self.sprite_combobox_arrow = _combobox_arrow;
		return self;
	}
	
	///@desc Set sprites for ProgressRing component (_ring, _ring_value, _ring_border)
	///@arg {asset.GMSprite} _ring
	///@arg {asset.GMSprite} _ring_value
	///@arg {asset.GMSprite} [_ring_border]
	static setSpriteRing = function(_ring, _ring_value, _ring_border = undefined) {
		self.sprite_progress_ring = _ring;
		self.sprite_progress_ring_value = _ring_value;
		self.sprite_progress_ring_border = _ring_border;
		return self;
	}
	
	///@desc Set sprites for Scroll slider (_scroll_slider, _scroll_pin, _scroll_pin_border)
	///@arg {asset.GMSprite} _scroll_slider
	///@arg {asset.GMSprite} _scroll_pin
	///@arg {asset.GMSprite} [_scroll_pin_border]
	static setSpriteScrollSlider = function(_scroll_slider, _scroll_pin, _scroll_pin_border = undefined) {
		self.sprite_scroll_slider = _scroll_slider;
		self.sprite_scroll_pin = _scroll_pin;
		self.sprite_scroll_pin_border = _scroll_pin_border;
		return self;
	}
	
	///@desc Set sprites for tooltip (_tooltip, _tooltip_border)
	///@arg {asset.GMSprite} _tooltip
	///@arg {asset.GMSprite} [_tooltip_border]
	static setSpriteTooltip = function(_tooltip, _tooltip_border = undefined) {
		self.sprite_tooltip = _tooltip;
		self.sprite_tooltip_border = _tooltip_border;
		return self;
	}
	
	// COLORS FUNCTIONS
	
	///@desc Sets the primary, secondary, accent, and border colors for UI elements.
    ///@arg {Real} [_primary] The primary color for elements (default: c_white).
    ///@arg {Real} [_secondary] The secondary color for interactive elements (default: c_ltgray).
    ///@arg {Real} [_back] The back color for interactive elements (default: c_ltgray).
    ///@arg {Real} [_accent] The accent color for active states (default: c_green).
    ///@arg {Real} [_border] The border color for elements (default: c_gray).
    static setColors = function(_primary = c_white, _secondary = c_ltgray, _back = c_ltgray, _accent = c_green, _border = c_gray) {
        // Panel
        self.color_primary = _primary;
        self.color_secondary = _secondary;
		self.color_back = _back;
        self.color_accent = _accent;
        self.color_border = _border;
        return self;
    }
    
    ///@desc Sets the accent color for interactive elements.
    ///@arg {Real} [_color] The accent color for active states (default: c_green).
    ///@deprecated
    static setColorValue = function(_color = c_green) {
        _luiPrintWarning($"setColorValue: function is deprecated! Please use setColorAccent!");
        return self.setColorAccent(_color);
    }
    
    ///@desc Sets the accent color for interactive elements.
    ///@arg {Real} [_color] The accent color for active states (default: c_green).
    static setColorAccent = function(_color = c_green) {
        self.color_accent = _color;
        return self;
    }
    
    ///@desc Sets the hover color for UI elements.
    ///@arg {Real} [_hover] The hover color to be mixed with element colors (default: c_gray).
    static setColorHover = function(_hover = c_gray) {
        self.color_hover = _hover;
        return self;
    }
    
    ///@desc Sets the text and text hint colors for UI elements.
    ///@arg {Real} [_font] The color for text (default: c_black).
    ///@arg {Real} [_font_hint] The color for text hints (default: c_gray).
    ///@deprecated
    static setColorFont = function(_font = c_black, _font_hint = c_gray) {
        _luiPrintWarning($"setColorFont: function is deprecated! Please use setColorText!");
        return self.setColorText(_font, _font_hint);
    }
    
    ///@desc Sets the text and text hint colors for UI elements.
    ///@arg {Real} [_font] The color for text (default: c_black).
    ///@arg {Real} [_font_hint] The color for text hints (default: c_gray).
    static setColorText = function(_font = c_black, _font_hint = c_gray) {
        self.color_text = _font;
        self.color_text_hint = _font_hint;
        return self;
    }
    
    ///@desc [DEPRECATED] Previously set the tooltip colors (no longer used).
    ///@arg {Real} [_tooltip] The tooltip background color (default: c_white).
    ///@arg {Real} [_tooltip_border] The tooltip border color (default: c_black).
    ///@deprecated
    static setColorTooltip = function(_tooltip = c_white, _tooltip_border = c_black) {
        _luiPrintWarning($"setColorTooltip: function is deprecated!");
        return self;
    }
    
    ///@desc Sets the color for deactivated elements, which can be mixed with active colors.
    ///@arg {Real} [_color] The base color for deactivated elements (default: c_gray).
    static setColorDeactivated = function(_color = c_gray) {
        self.color_deactivated = _color;
        return self;
    }
    
    ///@desc Sets the semantic colors for success, error, and warning states.
    ///@arg {Real} [_success] The color for success (default: #4CAF50).
	///@arg {Real} [_warning] The color for warning (default: #FF9800).
    ///@arg {Real} [_error] The color for error (default: #F44336).
    static setColorSemantic = function(_success = #4CAF50, _warning = #FF9800, _error = #F44336) {
        self.color_semantic_success = _success;
        self.color_semantic_warning = _warning;
		self.color_semantic_error = _error;
        return self;
    }
    
    ///@desc Sets the optional shadow color for UI elements (default: undefined).
    ///@arg {Real} [_color] The shadow color (default: undefined).
    static setColorShadow = function(_color = undefined) {
        self.color_shadow = _color;
        return self;
    }
	
	// SOUNDS FUNCTIONS
	
	///@desc Set sounds (_click)
	///@arg {asset.GMSound} [_click]
	static setSounds = function(_click = undefined) {
		self.sound_click = _click;
		return self;
	}
	
	// SETTINGS FUNCTIONS
	
	///@desc Set default min size for all elements (_min_width, _min_height)
	///@arg {real} [_min_width]
	///@arg {real} [_min_height]
	static setMinSize = function(_min_width = 32, _min_height = 32) {
		self.min_width = _min_width;
		self.min_height = _min_height;
		return self;
	}
	
	///@desc Set default margin for all elements (_margin)
	///@arg {real} [_margin]
	static setMargin = function(_margin) {
		self.margin = _margin;
		return self;
	}
	
	///@desc Set default padding for all elements (_padding)
	///@arg {real} [_padding]
	static setPadding = function(_padding) {
		self.padding = _padding;
		return self;
	}
	
	///@desc Set default gap for all elements (_gap)
	///@arg {real} [_gap]
	static setGap = function(_gap) {
		self.gap = _gap;
		return self;
	}
	
	///@desc Set default border for all elements (_border)
	///@arg {real} [_border]
	static setBorder = function(_border) {
		self.border = _border;
		return self;
	}
	
	///@desc Set scroll step size for LuiScrollPanel (_scroll_step)
	///@arg {real} [_scroll_step]
	static setScrollStep = function(_scroll_step = 32) {
		self.scroll_step = _scroll_step;
		return self;
	}
	
	///@desc Set scroll slider width of LuiScrollPanel (_width)
	///@arg {real} [_width]
	static setScrollSliderWidth = function(_width = 16) {
		self.scroll_slider_width = _width;
		return self;
	}
	
	///@desc Set default render region offset for elements
	///@arg {struct, array} _region struct{left, right, top, bottom} or array [left, right, top, bottom]
	static setRenderRegionOffset = function(_region = {left : 0, right : 0, top : 0, bottom : 0}) {
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
	
	///@desc Set text cursor for LuiInput (_text_cursor)
	///@arg {string} [_text_cursor]
	static setTextCursor = function(_text_cursor = "|") {
		self.input_cursor = _text_cursor;
		return self;
	}
	
	///@desc Set cursor symbol for LuiInput (_symbol_cursor)
	///@arg {string} [_symbol_cursor]
	///@deprecated
	///@ignore
	static setSymbolCursor = function(_symbol_cursor = "|") {
		_luiPrintWarning($"setSymbolCursor: function is deprecated! Please use setTextCursor!");
		return self.setTextCursor(_symbol_cursor);
	}
	
	///@desc Set password symbol (_symbol_password)
	///@arg {string} [_symbol_password]
	static setSymbolPassword = function(_symbol_password = "•") {
		self.input_password = _symbol_password;
		return self;
	}
}
