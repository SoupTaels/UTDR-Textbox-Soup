enum LUI_INPUT_MODE {
    text,          // All characters
    password,      // Letters, digits, specific symbols (!?@#$%&_); no spaces
    numbers,       // 0-9
    sint,          // 0-9, "-", no leading zeros, no -0
    letters,       // A-Z, a-z
    alphanumeric   // A-Z, a-z, 0-9
}

///@desc A field for entering text.
/// Available parameters:
/// value
/// placeholder
/// is_masked (bool, default: false, masks text with dots)
/// max_length
/// input_mode (LUI_INPUT_MODE: text, password, numbers, sint, letters, alphanumeric)
/// excluded_chars (string of forbidden chars, e.g. "!@#")
/// allowed_chars (string of allowed chars, e.g. "!@", takes priority over excluded_chars)
///@arg {Struct} [_params] Struct with parameters
function LuiInput(_params = {}) : LuiBase(_params) constructor {
    
    self.value = string(_params[$ "value"] ?? "");
    self.placeholder = _params[$ "placeholder"] ?? "";
    self.is_masked = _params[$ "is_masked"] ?? false;
    self.max_length = _params[$ "max_length"] ?? 255;
    self.input_mode = _params[$ "input_mode"] ?? LUI_INPUT_MODE.text;
    self.excluded_chars = _params[$ "excluded_chars"] ?? "";
    self.allowed_chars = _params[$ "allowed_chars"] ?? "";
    
    self.is_incorrect = false;
    self.cursor_pointer = "";
    self.cursor_timer = time_source_create(time_source_game, 0.5, time_source_units_seconds, function() {
        if self.cursor_pointer == "" {
            self.cursor_pointer = self.style.input_cursor;
        } else {
            self.cursor_pointer = "";
        }
        self.updateMainUiSurface();
    }, [], -1);
    
    ///@desc Set text
    ///@arg {string} _text
    static setText = function(_text) {
        self.set(_text);
        return self;
    }
    
    ///@desc Set placeholder text
    ///@arg {string} _placeholder
    static setPlaceholder = function(_placeholder) {
        self.placeholder = _placeholder;
        return self;
    }
    
    ///@desc Set whether text is masked (displayed as dots)
    ///@arg {bool} _is_masked Enable masked mode (true) or show text (false)
    static setMasked = function(_is_masked) {
        self.is_masked = _is_masked;
        return self;
    }
    
    ///@desc Set text max length
    ///@arg {real} _max_length
    static setMaxLength = function(_max_length) {
        self.max_length = _max_length;
        return self;
    }
    
    ///@desc Set input mode
    ///@arg {real} _mode LUI_INPUT_MODE
    static setInputMode = function(_mode) {
        self.input_mode = _mode;
        return self;
    }
    
    ///@desc Set excluded characters (string)
    ///@arg {string} _chars Forbidden chars, e.g. "!@#"
    static setExcludedChars = function(_chars) {
        self.excluded_chars = _chars;
        return self;
    }
    
    ///@desc Set allowed characters (string)
    ///@arg {string} _chars Allowed chars, e.g. "!@", takes priority over excluded_chars
    static setAllowedChars = function(_chars) {
        self.allowed_chars = _chars;
        return self;
    }
    
    ///@desc Set whether input is marked as incorrect (affects border, background, and placeholder color)
    ///@arg {bool} _is_incorrect Mark input as incorrect (true) or not (false)
    static setIncorrect = function(_is_incorrect) {
        self.is_incorrect = _is_incorrect;
        return self;
    }
    
    ///@desc Return real number or _default_value
    ///@arg {real} [_default_value] Value to return if string is not a valid number, default is 0
    ///@return {real}
    static getReal = function(_default_value = 0) {
        var _v = self.get();
        var _n = string_length(string_digits(_v));
        var _is_real = _n > 0 && _n == string_length(_v) - (string_ord_at(_v, 1) == ord("-")) - (string_pos(".", _v) != 0);
        return _is_real ? real(_v) : _default_value;
    }
    
    ///@ignore
    static _limit_value = function(_string) {
        return string_copy(_string, 1, self.max_length);
    }
    
    ///@ignore
    static _filter_input = function(_input) {
        var _filtered = "";
        var _len = string_length(_input);
        for (var i = 1; i <= _len; i++) {
            var _char = string_char_at(_input, i);
            if self._is_char_allowed(_char, i == 1) {
                _filtered += _char;
            }
        }
        // Normalize sint: remove leading zeros, handle -0
        if self.input_mode == LUI_INPUT_MODE.sint {
            var _is_negative = string_char_at(_filtered, 1) == "-";
            // Remove minus temporarily
            _filtered = string_replace_all(_filtered, "-", "");
            // Remove leading zeros
            while (string_length(_filtered) > 1 && string_char_at(_filtered, 1) == "0") {
                _filtered = string_delete(_filtered, 1, 1);
            }
            // Restore minus if negative and not zero
            if _is_negative && _filtered != "0" {
                _filtered = "-" + _filtered;
            }
            // Handle -0
            if _filtered == "-0" {
                _filtered = "0";
            }
        }
        return _filtered;
    }
    
    ///@ignore
    static _is_char_allowed = function(_char, _is_first) {
        // Allow chars in allowed_chars, overriding excluded_chars
        if string_pos(_char, self.allowed_chars) > 0 return true;
        
        // Check excluded chars
        if string_pos(_char, self.excluded_chars) > 0 return false;
        
        // Mode checks
        switch (self.input_mode) {
            case LUI_INPUT_MODE.numbers:
                return string_digits(_char) != "";
            case LUI_INPUT_MODE.sint:
                if _char == "-" && _is_first return true;
                return string_digits(_char) != "";
            case LUI_INPUT_MODE.letters:
                return string_letters(_char) != "";
            case LUI_INPUT_MODE.alphanumeric:
                return string_lettersdigits(_char) != "";
            case LUI_INPUT_MODE.password:
                // Allow letters, digits, and specific symbols (!?@#$%&_); no spaces
                if _char == " " return false;
                return string_lettersdigits(_char) != "" || string_pos(_char, "!?@#$%&_") > 0;
            case LUI_INPUT_MODE.text:
                return true;  // All allowed except excluded
        }
        return false;
    }
    
    self.draw = function() {
        //Base
        if !is_undefined(self.style.sprite_input) {
            var _blend_color = self.style.color_back;
            if !self.deactivated {
                if !self.has_focus && self.isMouseHovered() {
                    _blend_color = merge_color(self.style.color_back, self.style.color_hover, 0.5);
                }
                if self.is_incorrect {
                    _blend_color = merge_color(_blend_color, self.style.color_semantic_error, 0.5);
                }
            } else {
                _blend_color = merge_color(_blend_color, c_black, 0.5);
            }
            draw_sprite_stretched_ext(self.style.sprite_input, 0, self.x, self.y, self.width, self.height, _blend_color, 1);
        }
        
        //Set text properties
        if !is_undefined(self.style.font_default) {
            draw_set_font(self.style.font_default);
        }
        if !self.deactivated {
            draw_set_color(self.style.color_text);
        } else {
            draw_set_color(merge_color(self.style.color_text, c_black, 0.5));
        }
        var _prev_alpha = draw_get_alpha();
        draw_set_alpha(1);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        
        //Get text
        var _margin = 6;
        var _txt_x = self.x + _margin;
        var _txt_y = self.y + self.height / 2;
        var _display_text = self.value;
        
        //Masked text (dots)
        if self.is_masked {
            _display_text = string_repeat(self.style.input_password, string_length(self.value));
        }
        
        //Placeholder
        if self.value == "" && !self.has_focus {
            _display_text = self.placeholder;
            draw_set_alpha(0.5);
            if self.is_incorrect {
                draw_set_color(merge_color(self.style.color_text_hint, self.style.color_semantic_error, 0.5));
            } else {
                draw_set_color(self.style.color_text_hint);
            }
        }
        
        //Cut
        if _display_text != "" {
            while(string_width(_display_text) > (self.width - (2 * _margin)))
                _display_text = string_delete(_display_text, 1, 1);
        }
        
        //Draw final text
        if _display_text != "" || self.has_focus {
            draw_text(_txt_x, _txt_y, _display_text + self.cursor_pointer);
        }
        
        draw_set_alpha(_prev_alpha);
        
        //Border
        if !is_undefined(self.style.sprite_input_border) {
            var _border_color = self.style.color_border;
            if self.has_focus {
                _border_color = self.style.color_accent;
            }
            if self.is_incorrect {
                _border_color = self.style.color_semantic_error;
            }
            draw_sprite_stretched_ext(self.style.sprite_input_border, 0, self.x, self.y, self.width, self.height, _border_color, 1);
        }
    }
    
    self.addEvent(LUI_EV_CREATE, function(_e) {
        _e.set(_e._limit_value(_e._filter_input(_e.get())));
    });
    
    self.addEvent(LUI_EV_FOCUS_SET, function(_e) {
        time_source_start(_e.cursor_timer);
        _e.cursor_pointer = _e.style.input_cursor;
        keyboard_string = get();
        _e.main_ui.waiting_for_keyboard_input = true;
        //Touch compatibility
        if os_type == os_android || os_type == os_ios {
            keyboard_virtual_show(kbv_type_default, kbv_returnkey_default, kbv_autocapitalize_none, false);
        }
    });
    
    self.addEvent(LUI_EV_FOCUS_REMOVE, function(_e) {
        time_source_stop(_e.cursor_timer);
        _e.cursor_pointer = "";
        _e.main_ui.waiting_for_keyboard_input = false;
        //Touch compatibility
        if os_type == os_android || os_type == os_ios {
            keyboard_virtual_hide();
        }
    });
    
    self.addEvent(LUI_EV_KEYBOARD_INPUT, function(_e) {
        var _new_input = _e._limit_value(_e._filter_input(keyboard_string));
        _e.set(_new_input);
        keyboard_string = _e.get();
        if keyboard_check(vk_lcontrol) && keyboard_check_pressed(ord("V")) && clipboard_has_text() {
            var _paste = _e._filter_input(clipboard_get_text());
            _e.set(_e._limit_value(_e.get() + _paste));
            keyboard_string = _e.get();
        }
    });
    
    self.addEvent(LUI_EV_DESTROY, function(_e) {
        if time_source_exists(_e.cursor_timer) {
            time_source_destroy(_e.cursor_timer);
        }
    });
}