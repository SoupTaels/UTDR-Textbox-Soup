/// @func Quill(_kind, _label, _placeholder)
/// @desc Create a Quill text input box (single line or multiline).
/// @param {Real} [_kind] Use QUILL_SINGLE or QUILL_MULTI.
/// @param {String} [_label]
/// @param {String} [_placeholder]
/// @return {Struct.__Quill}
function Quill(_kind = QUILL_SINGLE, _label = "", _placeholder = "") {
	QuillEnsure();
	return new __Quill(_kind, _label, _placeholder);
}

/// @func QuillSingle(_label, _placeholder)
/// @desc Convenience: create a single-line Quill text box.
/// @param {String} [_label]
/// @param {String} [_placeholder]
/// @return {Struct.__Quill}
function QuillSingle(_label = "", _placeholder = "") {
	return Quill(QUILL_SINGLE, _label, _placeholder);
}

/// @func QuillMulti(_label, _placeholder)
/// @desc Convenience: create a multiline Quill text box.
/// @param {String} [_label]
/// @param {String} [_placeholder]
/// @return {Struct.__Quill}
function QuillMulti(_label = "", _placeholder = "") {
	return Quill(QUILL_MULTI, _label, _placeholder);
}

/// @func QuillDrawOverlays()
/// @desc Convenience: draw any active Quill overlays (context menus, editors).
function QuillDrawOverlays() {
	QuillEnsure();
	global.__QUILL_CORE.__QuillDrawOverlays();
}

/// @ignore
/// @func __Quill(_kind, _label, _placeholder)
/// @desc Internal textbox struct.
function __Quill(_kind, _label, _placeholder) constructor {
	id = 0;

	text = "";
	label_text = string(_label);
	label_visible = (string_length(label_text) > 0);
	label_placement = eQuillLabelPlacement.Above;
	label_align = eQuillLabelAlign.Start;
	label_overflow = eQuillLabelOverflow.Wrap;
	label_offset = 4;
	label_width = -1;
	placeholder = string(_placeholder);

	bind_struct = undefined;
	bind_key = "";
	on_change = undefined;
	on_focus = undefined;
	on_blur = undefined;
	on_submit = undefined;
	on_cancel = undefined;

	tab_enabled = true;
	tab_order = -1;
	multiline_submit_on_ctrl_enter = false;
	enabled = true;
	transformers = [];
	auto_trim = false;
	auto_upper = false;
	auto_lower = false;

	config = {
		read_only: false,
		max_length: 0,
		allow_chars: "",
		deny_chars: "",
		numeric_only: false,
		numeric_allow_decimal: false,
		numeric_allow_negative: false,
		select_all_on_focus: false,
		filter_fn: undefined,
		on_live_change: undefined,
		live_change_rate_ms: 0,
		input_mode: QUILL_TEXTMODE_TEXT,
		tab_inserts: false,
		tab_use_spaces: false,
		tab_spaces: 4,
		auto_indent: false,
		password_mask: false,
		password_mask_char: "*",
		password_allow_copy: false,
		multiline: false,
		wrap: true,
		view_w: 0,
		view_h: 0,
		font: -1,
		text_align: eQuillTextAlign.Left,
		scroll_state: undefined
	};

	// Per-box editor state.
	caret_index = 0;
	selection_anchor = -1;
	scroll_x = 0;
	preferred_x = 0;
	preferred_x_valid = false;
	caret_visible = true;
	caret_blink = true;
	caret_blink_time = 0;
	caret_fade = false;
	caret_fade_time = 0;

	last_click_time = 0;
	last_click_index = -1;
	last_click_id = 0;
	last_click_count = 0;

	last_char = "";
	last_char_key = 0;

	mouse_selecting = false;
	mouse_select_mode = 0;
	mouse_select_anchor_start = -1;
	mouse_select_anchor_end = -1;

	undo_stack = [];
	redo_stack = [];
	undo_limit = 64;

	key_repeat_next = {};
	key_repeat_delay_ms = 350;
	key_repeat_rate_ms = 40;

	edit_gen = 0;
	layout_cache = undefined;
	layout_cache_gen = -1;
	layout_cache_wrap = false;
	layout_cache_view_w = 0;
	layout_cache_font = undefined;
	layout_cache_password_mask = false;
	layout_cache_password_char = "*";
	layout_cache_tab_spaces = 4;

	live_dirty = false;
	live_next_at = 0;

	// Multiline extras (Echo parity fields).
	visible_rows = 6;
	preferred_width = 150;
	preferred_height = 0;
	min_height = 48;
	max_height = 0;
	resizable = true;
	show_resize_grip = true;
	use_overlay_editor = true;
	overlay_editor_title = "Edit text";
	context_menu_items = [];
	context_menu_enabled = true;

	// Validation message (inline by default).
	validation_message = "";
	validation_kind = "error"; // "error"|"warn"|"info"
	validation_visible = false;
	validation_display = "inline"; // "inline"|"tooltip"|"auto"

	theme = -1;
	overrides = {};
	__style_cache = undefined;
	__style_cache_gen = 0;
	__style_gen = 1;

	last_rect = undefined;
	last_label_rect = undefined;
	last_textbox_rect = undefined;
	last_component_rect = undefined;
	last_text_rect = undefined;
	last_draw_seq = 0;

	last_scroll_track_rect = undefined;
	last_scroll_thumb_rect = undefined;
	last_scroll_h_track_rect = undefined;
	last_scroll_h_thumb_rect = undefined;
	last_resize_grip_rect = undefined;

	__measured_dirty = true;
	__measured_style_gen = -1;
	__measured_edit_gen = -1;
	__measured_w_hint = undefined;
	__measured_h_hint = undefined;
	__measured_box_w = 0;
	__measured_box_h = 0;
	__measured_component_w = 0;
	__measured_component_h = 0;

	__resize_dragging = false;
	__resize_start_mx = 0;
	__resize_start_my = 0;
	__resize_start_w = 0;
	__resize_start_h = 0;

	// Multiline kind setup.
	if (_kind == QUILL_MULTI) {
		config[$ "multiline"] = true;
		config[$ "wrap"] = true;
		config[$ "tab_inserts"] = true;
		config[$ "scroll_state"] = { scroll_x: 0, scroll_y: 0, dragging: false, drag_axis: "", drag_offset_x: 0, drag_offset_y: 0 };
	}
	else {
		config[$ "multiline"] = false;
		config[$ "wrap"] = false;
		config[$ "tab_inserts"] = false;
		config[$ "scroll_state"] = undefined;
	}

	global.__QUILL_CORE.__RegisterBox(self);

	/// @func GetValue()
	/// @desc Return the current string value (bound or unbound).
	/// @return {String}
	static GetValue = function() {
		if (is_struct(bind_struct) && string_length(bind_key) > 0) {
			var _v = bind_struct[$ bind_key];
			return is_undefined(_v) ? "" : string(_v);
		}
		return string(text);
	};
	
	/// @func SetValue(_v)
	/// @desc Set the current string value through textbox transform/filter constraints.
	/// @param {Any} _v
	static SetValue = function(_v) {
		global.__QUILL_CORE.__TextInputSetExternalValue(self, _v, config);
	};
	
	/// @func AllowActions(_bool)
	/// @desc Allow/ Disallow the ability to undo/ redo.
	/// @param {bool} _bool
	static AllowActions = function(_bool) {
		global.__QUILL_CORE._actionenabled = _bool;
		return self;
	};
	
	static ContextMenuAllow = function(_bool) {
		context_menu_enabled = _bool;
		return self;
	};

	/// @func GetCaret()
	/// @desc Get the current caret index.
	/// @return {Real}
	static GetCaret = function() {
		return max(0, floor(caret_index));
	};

	/// @func SetCaret(_index, _extend)
	/// @desc Set caret index and optionally extend selection.
	/// @param {Real} _index
	/// @param {Bool} [_extend]
	/// @return {Struct.__Quill}
	static SetCaret = function(_index, _extend = false) {
		global.__QUILL_CORE.__TextInputSetCaret(self, floor(_index), (_extend == true), config);
		return self;
	};
	
	///@desc Sets whether the cursor can blink.
	static SetCaretBlink = function(_bool = true) {
		caret_blink = _bool;
		return self;
	};
	
	///@desc Sets whether the cursor can have a fade in and out animation when blink is disabled.
	static SetCaretFade = function(_bool = false) {
		caret_fade = _bool;
		return self;
	};
	
	///@desc Sets the fading speed when the cursor has a fading animation
	static SetCaretFadeTime = function(_time = 0) {
		caret_fade_time = _time;
		return self;
	};
	
	//@desc Sets the delay before the last pressed key starts to repeat itself
	static SetCaretRepeatDelay = function(_time = 0) {
		key_repeat_delay_ms = _time;
		return self;
	};
	
	//@desc Sets the delay between time to print the last key
	static SetCaretRepeatRate = function(_time = 0) {
		key_repeat_rate_ms = _time;
		return self;
	};

	/// @func GetSelection()
	/// @desc Get the current selection range.
	/// @return {Struct}
	static GetSelection = function() {
		var _has = global.__QUILL_CORE.__TextInputHasSelection(self);
		var _range = global.__QUILL_CORE.__TextInputGetSelectionRange(self);
		return {
			has_selection: _has,
			start: _range.start,
			_end: _range._end
		};
	};

	/// @func GetWidth()
	/// @desc Get the most recently drawn component width (textbox plus label union).
	/// @return {Real}
	static GetWidth = function() {
		__EnsureMeasuredSize();
		return max(0, __measured_component_w);
	};

	/// @func GetHeight()
	/// @desc Get the most recently drawn component height (textbox plus label union).
	/// @return {Real}
	static GetHeight = function() {
		__EnsureMeasuredSize();
		return max(0, __measured_component_h);
	};

	/// @func GetBoxWidth()
	/// @desc Get the most recently drawn textbox width (textbox only, no label).
	/// @return {Real}
	static GetBoxWidth = function() {
		__EnsureMeasuredSize();
		return max(0, __measured_box_w);
	};

	/// @func GetBoxHeight()
	/// @desc Get the most recently drawn textbox height (textbox only, no label).
	/// @return {Real}
	static GetBoxHeight = function() {
		__EnsureMeasuredSize();
		return max(0, __measured_box_h);
	};

	/// @func SetSelection(_start, _end)
	/// @desc Set selection anchors using text indices.
	/// @param {Real} _start
	/// @param {Real} _end
	/// @return {Struct.__Quill}
	static SetSelection = function(_start, _end) {
		var _len = string_length(text);
		var _s = clamp(floor(_start), 0, _len);
		var _e = clamp(floor(_end), 0, _len);
		selection_anchor = _s;
		caret_index = _e;
		global.__QUILL_CORE.__TextInputResetCaretBlink(self);
		global.__QUILL_CORE.__TextAreaUpdatePreferredXFromCaret(self, config);
		global.__QUILL_CORE.__TextInputEnsureCaretVisible(self, config);
		return self;
	};

	/// @func SelectAll()
	/// @desc Select all text in this textbox.
	/// @return {Struct.__Quill}
	static SelectAll = function() {
		global.__QUILL_CORE.__TextInputSelectAll(self, config);
		return self;
	};

	/// @desc Bind this box to a struct field.
	/// @param {Struct} _struct
	/// @param {String} _key
	/// @return {Struct.__Quill}
	static BindText = function(_struct, _key) {
		if (is_struct(_struct)) {
			bind_struct = _struct;
			bind_key = string(_key);
			__SyncFromBinding();
		}
		return self;
	};

	/// @desc Set placeholder text shown when empty and not active.
	/// @param {Any} _text
	/// @return {Struct.__Quill}
	static SetPlaceholder = function(_text) {
		placeholder = string(_text);
		return self;
	};

	/// @desc Set label text drawn around this textbox.
	/// @param {Any} _text
	/// @return {Struct.__Quill}
	static SetLabel = function(_text) {
		label_text = string(_text);
		__InvalidateMeasuredSize();
		return self;
	};

	/// @desc Set whether label drawing and label layout are enabled.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetLabelVisible = function(_flag) {
		label_visible = (_flag == true);
		__InvalidateMeasuredSize();
		return self;
	};

	/// @desc Set label placement (Above or Leading).
	/// @param {Real} _placement
	/// @return {Struct.__Quill}
	static SetLabelPlacement = function(_placement) {
		if (_placement == eQuillLabelPlacement.Leading) {
			label_placement = eQuillLabelPlacement.Leading;
		}
		else {
			label_placement = eQuillLabelPlacement.Above;
		}
		__InvalidateMeasuredSize();
		return self;
	};

	/// @desc Set label alignment (Start or Center).
	/// @param {Real} _align
	/// @return {Struct.__Quill}
	static SetLabelAlign = function(_align) {
		if (_align == eQuillLabelAlign.Center) {
			label_align = eQuillLabelAlign.Center;
		}
		else {
			label_align = eQuillLabelAlign.Start;
		}
		__InvalidateMeasuredSize();
		return self;
	};

	/// @desc Set label overflow mode (Wrap or Ellipsis).
	/// @param {Real} _overflow
	/// @return {Struct.__Quill}
	static SetLabelOverflow = function(_overflow) {
		if (_overflow == eQuillLabelOverflow.Ellipsis) {
			label_overflow = eQuillLabelOverflow.Ellipsis;
		}
		else {
			label_overflow = eQuillLabelOverflow.Wrap;
		}
		__InvalidateMeasuredSize();
		return self;
	};

	/// @desc Set label distance from textbox. Above uses vertical distance, Leading uses horizontal distance.
	/// @param {Real} _pixels
	/// @return {Struct.__Quill}
	static SetLabelOffset = function(_pixels) {
		label_offset = max(0, _pixels);
		__InvalidateMeasuredSize();
		return self;
	};

	/// @desc Set label width in pixels (-1 = auto width).
	/// @param {Real} _width
	/// @return {Struct.__Quill}
	static SetLabelWidth = function(_width) {
		var _w = floor(_width);
		label_width = (_w > 0) ? _w : -1;
		__InvalidateMeasuredSize();
		return self;
	};

	/// @desc Set a callback fired on every value write: on_change(tb, new_value).
	/// @param {Function} _fn
	/// @return {Struct.__Quill}
	static OnChange = function(_fn) {
		if (is_callable(_fn)) {
			on_change = _fn;
		}
		else {
			on_change = undefined;
		}
		return self;
	};

	/// @desc Set a callback fired when this textbox gains focus: on_focus(tb).
	/// @param {Function} _fn
	/// @return {Struct.__Quill}
	static OnFocus = function(_fn) {
		if (is_callable(_fn)) {
			on_focus = _fn;
		}
		else {
			on_focus = undefined;
		}
		return self;
	};

	/// @desc Set a callback fired when this textbox loses focus: on_blur(tb).
	/// @param {Function} _fn
	/// @return {Struct.__Quill}
	static OnBlur = function(_fn) {
		if (is_callable(_fn)) {
			on_blur = _fn;
		}
		else {
			on_blur = undefined;
		}
		return self;
	};

	/// @desc Set a callback fired when this textbox submits: on_submit(tb, value).
	/// @param {Function} _fn
	/// @return {Struct.__Quill}
	static OnSubmit = function(_fn) {
		if (is_callable(_fn)) {
			on_submit = _fn;
		}
		else {
			on_submit = undefined;
		}
		return self;
	};

	/// @desc Set a callback fired when this textbox is canceled: on_cancel(tb).
	/// @param {Function} _fn
	/// @return {Struct.__Quill}
	static OnCancel = function(_fn) {
		if (is_callable(_fn)) {
			on_cancel = _fn;
		}
		else {
			on_cancel = undefined;
		}
		return self;
	};

	/// @func Focus()
	/// @desc Focus this textbox.
	/// @return {Struct.__Quill}
	static Focus = function() {
		global.__QUILL_CORE.__SetActive(id);
		return self;
	};

	/// @func Blur()
	/// @desc Remove focus from this textbox.
	/// @return {Struct.__Quill}
	static Blur = function() {
		if (global.__QUILL_CORE._active_id == id) {
			global.__QUILL_CORE.__SetActive(0);
		}
		return self;
	};

	/// @func IsFocused()
	/// @desc Returns true if this textbox is currently focused.
	/// @return {Bool}
	static IsFocused = function() {
		return (global.__QUILL_CORE._active_id == id);
	};

	/// @desc Set whether this textbox can be focused by Tab navigation.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetTabEnabled = function(_flag) {
		tab_enabled = (_flag == true);
		return self;
	};

	/// @desc Set tab order index. Use -1 to use default creation order.
	/// @param {Real} _order
	/// @return {Struct.__Quill}
	static SetTabOrder = function(_order) {
		var _next = floor(_order);
		if (_next < 0) {
			tab_order = -1;
		}
		else {
			tab_order = _next;
		}
		return self;
	};

	/// @desc Set multiline submit behavior for Ctrl+Enter.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetMultilineSubmitOnCtrlEnter = function(_flag) {
		multiline_submit_on_ctrl_enter = (_flag == true);
		return self;
	};

	/// @desc Set whether this textbox is enabled for interaction and focus.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetEnabled = function(_flag) {
		enabled = (_flag == true);
		if (!enabled) {
			if (global.__QUILL_CORE._active_id == id) {
				global.__QUILL_CORE.__SetActive(0);
			}
			if (global.__QUILL_CORE._context_menu_owner_id == id) {
				global.__QUILL_CORE.CloseContextMenu();
			}
		}
		return self;
	};

	/// @desc Returns true when this textbox is enabled for interaction.
	/// @return {Bool}
	static IsEnabled = function() {
		return (enabled == true);
	};

	/// @func ContextMenuAddItem(_item)
	/// @desc Add or replace a custom context menu item for this textbox.
	/// @param {Struct} _item
	/// @return {Struct.__Quill}
	static ContextMenuAddItem = function(_item) {
		var _res = global.__QUILL_CORE.__ContextMenuCollectionAdd(context_menu_items, _item);
		context_menu_items = _res.items;
		return self;
	};

	/// @func ContextMenuRemoveItem(_key_or_uid)
	/// @desc Remove a custom context menu item on this textbox by key or __uid.
	/// @param {Any} _key_or_uid
	/// @return {Struct.__Quill}
	static ContextMenuRemoveItem = function(_key_or_uid) {
		var _res = global.__QUILL_CORE.__ContextMenuCollectionRemove(context_menu_items, _key_or_uid);
		context_menu_items = _res.items;
		return self;
	};

	/// @func ContextMenuGetItem(_key_or_uid)
	/// @desc Get a custom context menu item on this textbox by key or __uid.
	/// @param {Any} _key_or_uid
	/// @return {Struct}
	static ContextMenuGetItem = function(_key_or_uid) {
		return global.__QUILL_CORE.__ContextMenuCollectionGet(context_menu_items, _key_or_uid);
	};

	/// @func ContextMenuClearItems()
	/// @desc Clear all custom context menu items on this textbox.
	/// @return {Struct.__Quill}
	static ContextMenuClearItems = function() {
		context_menu_items = [];
		return self;
	};

	/// @desc Set horizontal text alignment for textbox content.
	/// @param {Real} _align
	/// @return {Struct.__Quill}
	static SetTextAlign = function(_align) {
		if (_align == eQuillTextAlign.Center) {
			config[$ "text_align"] = eQuillTextAlign.Center;
		}
		else if (_align == eQuillTextAlign.Right) {
			config[$ "text_align"] = eQuillTextAlign.Right;
		}
		else {
			config[$ "text_align"] = eQuillTextAlign.Left;
		}
		global.__QUILL_CORE.__TextInputBumpGen(self);
		return self;
	};

	/// @desc Add an input transformer: fn(text)->text (runs before filter_fn and validators).
	/// @param {Function} _fn
	/// @return {Struct.__Quill}
	static AddTransform = function(_fn) {
		if (is_callable(_fn)) {
			array_push(transformers, _fn);
		}
		return self;
	};

	/// @desc Clear all custom input transformers.
	/// @return {Struct.__Quill}
	static ClearTransforms = function() {
		transformers = [];
		return self;
	};

	/// @desc Enable or disable automatic trimming transform.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetAutoTrim = function(_flag) {
		auto_trim = (_flag == true);
		return self;
	};

	/// @desc Enable or disable automatic uppercase transform.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetAutoUpper = function(_flag) {
		auto_upper = (_flag == true);
		if (auto_upper) {
			auto_lower = false;
		}
		return self;
	};

	/// @desc Enable or disable automatic lowercase transform.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetAutoLower = function(_flag) {
		auto_lower = (_flag == true);
		if (auto_lower) {
			auto_upper = false;
		}
		return self;
	};

	/// @desc Set whether this box is read-only.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetReadOnly = function(_flag) {
		config[$ "read_only"] = (_flag == true);
		return self;
	};

	/// @desc Set the maximum number of characters allowed (0 = unlimited).
	/// @param {Real} _len
	/// @return {Struct.__Quill}
	static SetMaxLength = function(_len) {
		config[$ "max_length"] = max(0, _len);
		return self;
	};

	/// @desc Restrict input to the characters in the given string (empty = allow all).
	/// @param {String} _chars
	/// @return {Struct.__Quill}
	static SetAllowedChars = function(_chars) {
		config[$ "allow_chars"] = string(_chars);
		return self;
	};

	/// @desc Reject any characters contained in the given string.
	/// @param {String} _chars
	/// @return {Struct.__Quill}
	static SetDeniedChars = function(_chars) {
		config[$ "deny_chars"] = string(_chars);
		return self;
	};

	/// @desc Restrict input to numeric characters.
	/// @param {Bool} _flag
	/// @param {Bool} [_allow_decimal]
	/// @param {Bool} [_allow_negative]
	/// @return {Struct.__Quill}
	static SetNumericOnly = function(_flag, _allow_decimal = false, _allow_negative = false) {
		config[$ "numeric_only"] = (_flag == true);
		config[$ "numeric_allow_decimal"] = (_allow_decimal == true);
		config[$ "numeric_allow_negative"] = (_allow_negative == true);
		return self;
	};

	/// @desc Select all text when the box gains focus.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetSelectAllOnFocus = function(_flag) {
		config[$ "select_all_on_focus"] = (_flag == true);
		return self;
	};

	/// @desc Set an optional filter function: filter_fn(insert_text) -> string.
	/// @param {Function} _fn
	/// @return {Struct.__Quill}
	static SetFilterFn = function(_fn) {
		config[$ "filter_fn"] = is_callable(_fn) ? _fn : undefined;
		return self;
	};

	/// @desc Set a callback fired while typing (optional, throttled).
	/// @param {Function} _fn function(_text)
	/// @param {Real} [_rate_ms]
	/// @return {Struct.__Quill}
	static SetOnLiveChange = function(_fn, _rate_ms = 0) {
		config[$ "on_live_change"] = is_callable(_fn) ? _fn : undefined;
		config[$ "live_change_rate_ms"] = max(0, _rate_ms);
		return self;
	};

	/// @desc Set the input mode (TEXT/INT/FLOAT/IDENTIFIER/PATH/CODE/PASSWORD).
	/// @param {Real} _mode
	/// @return {Struct.__Quill}
	static SetInputMode = function(_mode) {
		config[$ "input_mode"] = _mode;
		if (_mode == QUILL_TEXTMODE_INT) {
			config[$ "numeric_only"] = true;
			config[$ "numeric_allow_decimal"] = false;
			config[$ "numeric_allow_negative"] = true;
			config[$ "tab_inserts"] = false;
			config[$ "password_mask"] = false;
			config[$ "auto_indent"] = false;
		}
		else if (_mode == QUILL_TEXTMODE_FLOAT) {
			config[$ "numeric_only"] = true;
			config[$ "numeric_allow_decimal"] = true;
			config[$ "numeric_allow_negative"] = true;
			config[$ "tab_inserts"] = false;
			config[$ "password_mask"] = false;
			config[$ "auto_indent"] = false;
		}
		else if (_mode == QUILL_TEXTMODE_PASSWORD) {
			config[$ "numeric_only"] = false;
			config[$ "tab_inserts"] = false;
			config[$ "password_mask"] = true;
			config[$ "auto_indent"] = false;
		}
		else if (_mode == QUILL_TEXTMODE_CODE) {
			config[$ "numeric_only"] = false;
			config[$ "tab_inserts"] = true;
			config[$ "auto_indent"] = true;
			config[$ "password_mask"] = false;
		}
		else {
			config[$ "numeric_only"] = false;
			config[$ "tab_inserts"] = false;
			config[$ "password_mask"] = false;
			config[$ "auto_indent"] = false;
		}
		global.__QUILL_CORE.__TextInputBumpGen(self);
		return self;
	};

	/// @desc Enable or disable Tab insertion while editing.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetTabInserts = function(_flag) {
		config[$ "tab_inserts"] = (_flag == true);
		return self;
	};

	/// @desc Set whether Tab inserts spaces instead of a tab character.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetTabUsesSpaces = function(_flag) {
		config[$ "tab_use_spaces"] = (_flag == true);
		return self;
	};

	/// @desc Set how many spaces are inserted when Tab uses spaces.
	/// @param {Real} _count
	/// @return {Struct.__Quill}
	static SetTabSpaces = function(_count) {
		config[$ "tab_spaces"] = max(0, floor(_count));
		global.__QUILL_CORE.__TextInputBumpGen(self);
		return self;
	};

	/// @desc Enable or disable auto-indent (multiline code mode).
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetAutoIndent = function(_flag) {
		config[$ "auto_indent"] = (_flag == true);
		return self;
	};

	/// @desc Enable or disable password masking.
	/// @param {Bool} _flag
	/// @param {String} [_mask_char]
	/// @param {Bool} [_allow_copy]
	/// @return {Struct.__Quill}
	static SetPasswordMask = function(_flag, _mask_char = "*", _allow_copy = false) {
		config[$ "password_mask"] = (_flag == true);
		config[$ "password_mask_char"] = string(_mask_char);
		config[$ "password_allow_copy"] = (_allow_copy == true);
		global.__QUILL_CORE.__TextInputBumpGen(self);
		return self;
	};

	/// @desc Enable or disable word wrapping (multiline only).
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetWrap = function(_flag) {
		config[$ "wrap"] = (_flag == true);
		global.__QUILL_CORE.__TextInputBumpGen(self);
		return self;
	};

	/// @desc Set the font used for measuring and drawing.
	/// @param {Asset.GMFont} _font
	/// @return {Struct.__Quill}
	static SetFont = function(_font) {
		config[$ "font"] = _font;
		global.__QUILL_CORE.__TextInputBumpGen(self);
		return self;
	};

	/// @func SetPreferredWidth(_width)
	/// @desc Set default textbox width in pixels used when Draw width is omitted.
	/// @param {Real} _width
	/// @return {Struct.__Quill}
	static SetPreferredWidth = function(_width) {
		preferred_width = max(1, floor(_width));
		__InvalidateMeasuredSize();
		return self;
	};

	/// @func GetPreferredWidth()
	/// @desc Return default textbox width in pixels used when Draw width is omitted.
	/// @return {Real}
	static GetPreferredWidth = function() {
		return max(1, floor(preferred_width));
	};

	/// @func SetVisibleRows(_rows)
	/// @desc Set preferred multiline row count when preferred height is not overridden.
	/// @param {Real} _rows
	/// @return {Struct.__Quill}
	static SetVisibleRows = function(_rows) {
		visible_rows = max(1, floor(_rows));
		__InvalidateMeasuredSize();
		return self;
	};

	/// @func GetVisibleRows()
	/// @desc Return the configured multiline row count.
	/// @return {Real}
	static GetVisibleRows = function() {
		return max(1, floor(visible_rows));
	};

	/// @func SetPreferredHeight(_height)
	/// @desc Set explicit textbox height in pixels (0 uses row-based sizing).
	/// @param {Real} _height
	/// @return {Struct.__Quill}
	static SetPreferredHeight = function(_height) {
		preferred_height = max(0, floor(_height));
		if (max_height > 0 && preferred_height > max_height) {
			preferred_height = max_height;
		}
		if (preferred_height > 0 && preferred_height < min_height) {
			preferred_height = min_height;
		}
		__InvalidateMeasuredSize();
		return self;
	};

	/// @func GetPreferredHeight()
	/// @desc Return explicit textbox height in pixels (0 means auto height).
	/// @return {Real}
	static GetPreferredHeight = function() {
		return max(0, floor(preferred_height));
	};

	/// @func SetMinHeight(_height)
	/// @desc Set minimum textbox height in pixels.
	/// @param {Real} _height
	/// @return {Struct.__Quill}
	static SetMinHeight = function(_height) {
		min_height = max(0, floor(_height));
		if (max_height > 0 && min_height > max_height) {
			min_height = max_height;
		}
		if (preferred_height > 0 && preferred_height < min_height) {
			preferred_height = min_height;
		}
		__InvalidateMeasuredSize();
		return self;
	};

	/// @func GetMinHeight()
	/// @desc Return minimum textbox height in pixels.
	/// @return {Real}
	static GetMinHeight = function() {
		return max(0, floor(min_height));
	};

	/// @func SetMaxHeight(_height)
	/// @desc Set maximum textbox height in pixels (0 disables max cap).
	/// @param {Real} _height
	/// @return {Struct.__Quill}
	static SetMaxHeight = function(_height) {
		max_height = max(0, floor(_height));
		if (max_height > 0) {
			if (min_height > max_height) {
				min_height = max_height;
			}
			if (preferred_height > max_height) {
				preferred_height = max_height;
			}
		}
		__InvalidateMeasuredSize();
		return self;
	};

	/// @func GetMaxHeight()
	/// @desc Return maximum textbox height in pixels (0 means no cap).
	/// @return {Real}
	static GetMaxHeight = function() {
		return max(0, floor(max_height));
	};

	/// @func SetResizable(_flag)
	/// @desc Set whether multiline resize grip behavior is enabled.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetResizable = function(_flag) {
		resizable = (_flag == true);
		return self;
	};

	/// @func IsResizable()
	/// @desc Returns true if multiline resize behavior is enabled.
	/// @return {Bool}
	static IsResizable = function() {
		return (resizable == true);
	};

	/// @func SetShowResizeGrip(_flag)
	/// @desc Set whether the multiline resize grip is drawn.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetShowResizeGrip = function(_flag) {
		show_resize_grip = (_flag == true);
		return self;
	};

	/// @func IsResizeGripVisible()
	/// @desc Returns true if the multiline resize grip is visible.
	/// @return {Bool}
	static IsResizeGripVisible = function() {
		return (show_resize_grip == true);
	};

	/// @func SetUseOverlayEditor(_flag)
	/// @desc Set whether multiline context menus include the overlay editor action.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetUseOverlayEditor = function(_flag) {
		use_overlay_editor = (_flag == true);
		if (!use_overlay_editor) {
			if (global.__QUILL_CORE._editor_open && global.__QUILL_CORE._editor_owner_id == id) {
				global.__QUILL_CORE.__OverlayEditorCancel();
			}
		}
		return self;
	};

	/// @func IsUsingOverlayEditor()
	/// @desc Returns true if overlay editor support is enabled.
	/// @return {Bool}
	static IsUsingOverlayEditor = function() {
		return (use_overlay_editor == true);
	};

	/// @func SetOverlayEditorTitle(_title)
	/// @desc Set the title shown on the multiline overlay editor panel.
	/// @param {Any} _title
	/// @return {Struct.__Quill}
	static SetOverlayEditorTitle = function(_title) {
		overlay_editor_title = string(_title);
		return self;
	};

	/// @func GetOverlayEditorTitle()
	/// @desc Return the current multiline overlay editor title text.
	/// @return {String}
	static GetOverlayEditorTitle = function() {
		return string(overlay_editor_title);
	};

	/// @desc Set a validation message (drawn inline by default).
	/// @param {Any} _text
	/// @param {String} [_kind] "error", "warn", or "info"
	/// @return {Struct.__Quill}
	static SetValidationMessage = function(_text, _kind = "error") {
		validation_message = string(_text);
		validation_kind = string(_kind);
		validation_visible = true;
		return self;
	};

	/// @desc Clear the validation message.
	/// @return {Struct.__Quill}
	static ClearValidationMessage = function() {
		validation_message = "";
		validation_visible = false;
		return self;
	};

	/// @desc Set whether validation messaging is visible.
	/// @param {Bool} _flag
	/// @return {Struct.__Quill}
	static SetValidationVisible = function(_flag) {
		validation_visible = (_flag == true);
		return self;
	};

	/// @desc Set the theme for this textbox. Pass a QuillTheme or -1 to use global theme.
	/// @param {Struct.QuillTheme|Real} _theme
	/// @return {Struct.__Quill}
	static SetTheme = function(_theme) {
		if (is_instanceof(_theme, QuillTheme)) {
			theme = _theme;
		}
		else {
			theme = -1;
		}
		__style_gen += 1;
		return self;
	};

	/// @desc Set label font override (-1 to use theme default).
	/// @param {Any} _font
	/// @return {Struct.__Quill}
	static SetLabelFont = function(_font) {
		var _fonts = __FontsEnsureOverrides();
		_fonts[$ "label"] = _font;
		__style_gen += 1;
		return self;
	};

	/// @desc Set label padding in pixels.
	/// @param {Real} _l
	/// @param {Real} _t
	/// @param {Real} _r
	/// @param {Real} _b
	/// @return {Struct.__Quill}
	static SetLabelPadding = function(_l, _t, _r, _b) {
		var _label = __LabelEnsureOverrides();
		_label[$ "pad_l"] = max(0, floor(_l));
		_label[$ "pad_t"] = max(0, floor(_t));
		_label[$ "pad_r"] = max(0, floor(_r));
		_label[$ "pad_b"] = max(0, floor(_b));
		__style_gen += 1;
		return self;
	};

	/// @desc Set label margin in pixels.
	/// @param {Real} _l
	/// @param {Real} _t
	/// @param {Real} _r
	/// @param {Real} _b
	/// @return {Struct.__Quill}
	static SetLabelMargin = function(_l, _t, _r, _b) {
		var _label = __LabelEnsureOverrides();
		_label[$ "margin_l"] = max(0, floor(_l));
		_label[$ "margin_t"] = max(0, floor(_t));
		_label[$ "margin_r"] = max(0, floor(_r));
		_label[$ "margin_b"] = max(0, floor(_b));
		__style_gen += 1;
		return self;
	};

	/// @desc Set label text color and alpha.
	/// @param {Real} _col
	/// @param {Real} _alpha
	/// @return {Struct.__Quill}
	static SetLabelTextStyle = function(_col, _alpha = 1) {
		var _label = __LabelEnsureOverrides();
		_label[$ "text_col"] = is_real(_col) ? _col : c_white;
		_label[$ "text_a"] = clamp(_alpha, 0, 1);
		__style_gen += 1;
		return self;
	};

	/// @desc Set label background sprite override (-1 to clear).
	/// @param {Any} _spr
	/// @param {Real} [_subimg]
	/// @return {Struct.__Quill}
	static SetLabelBackgroundSprite = function(_spr, _subimg = 0) {
		var _label = __LabelEnsureOverrides();
		_label[$ "bg_spr"] = (_spr != -1 && sprite_exists(_spr)) ? _spr : -1;
		_label[$ "bg_subimg"] = max(0, floor(_subimg));
		__style_gen += 1;
		return self;
	};

	/// @desc Set label border sprite override (-1 to clear).
	/// @param {Any} _spr
	/// @param {Real} [_subimg]
	/// @return {Struct.__Quill}
	static SetLabelBorderSprite = function(_spr, _subimg = 0) {
		var _label = __LabelEnsureOverrides();
		_label[$ "border_spr"] = (_spr != -1 && sprite_exists(_spr)) ? _spr : -1;
		_label[$ "border_subimg"] = max(0, floor(_subimg));
		__style_gen += 1;
		return self;
	};

	/// @desc Set label primitive background color and alpha.
	/// @param {Real} _col
	/// @param {Real} _alpha
	/// @return {Struct.__Quill}
	static SetLabelPrimitiveBackground = function(_col, _alpha = 1) {
		var _label = __LabelEnsureOverrides();
		_label[$ "prim_bg_col"] = is_real(_col) ? _col : c_black;
		_label[$ "prim_bg_a"] = clamp(_alpha, 0, 1);
		__style_gen += 1;
		return self;
	};

	/// @desc Set label primitive border color, alpha, and thickness.
	/// @param {Real} _col
	/// @param {Real} _alpha
	/// @param {Real} [_thickness]
	/// @return {Struct.__Quill}
	static SetLabelPrimitiveBorder = function(_col, _alpha = 1, _thickness = 1) {
		var _label = __LabelEnsureOverrides();
		_label[$ "prim_border_col"] = is_real(_col) ? _col : c_white;
		_label[$ "prim_border_a"] = clamp(_alpha, 0, 1);
		_label[$ "prim_border_thickness"] = max(0, _thickness);
		__style_gen += 1;
		return self;
	};

	/// @desc Set the background sprite for this input (-1 to clear).
	/// @param {Any} _spr
	/// @param {Real} [_subimg]
	/// @return {Struct.__Quill}
	static SetSkinBackgroundSprite = function(_spr, _subimg = 0) {
		var _skins = overrides[$ "skins"];
		if (!is_struct(_skins)) {
			_skins = {};
			overrides[$ "skins"] = _skins;
		}
		_skins[$ "bg_spr"] = (_spr != -1 && sprite_exists(_spr)) ? _spr : -1;
		_skins[$ "bg_subimg"] = max(0, floor(_subimg));
		__style_gen += 1;
		return self;
	};

	/// @desc Set the border sprite for this input (-1 to clear).
	/// @param {Any} _spr
	/// @param {Real} [_subimg]
	/// @return {Struct.__Quill}
	static SetSkinBorderSprite = function(_spr, _subimg = 0) {
		var _skins = overrides[$ "skins"];
		if (!is_struct(_skins)) {
			_skins = {};
			overrides[$ "skins"] = _skins;
		}
		_skins[$ "border_spr"] = (_spr != -1 && sprite_exists(_spr)) ? _spr : -1;
		_skins[$ "border_subimg"] = max(0, floor(_subimg));
		__style_gen += 1;
		return self;
	};

	/// @func Draw(_x, _y, _w, _h)
	/// @desc Draw the component at the given GUI position and register it for same-frame hit testing.
	/// @param {Real} _x
	/// @param {Real} _y
	/// @param {Real} [_w]
	/// @param {Real} _h
	static Draw = function(_x, _y, _w = undefined, _h = undefined) {
		var _old_halign = draw_get_halign();
		var _old_valign = draw_get_valign();
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);

		__SyncFromBinding();

		if (__style_cache_gen != __style_gen) {
			__style_cache = global.__QUILL_CORE.__BuildResolvedStyleForTb(self);
			__style_cache_gen = __style_gen;
		}
		var _st = __style_cache;

		var _font = global.__QUILL_CORE.__ResolveTextboxFont(self, config, _st);
		__EnsureMeasuredSize(_w, _h, false);

		var _w_use = __measured_box_w;
		var _h_use = __measured_box_h;

		var _tb_x1 = _x;
		var _tb_y1 = _y;
		var _tb_x2 = _x + _w_use;
		var _tb_y2 = _y + max(0, _h_use);
		var _tb_border_out = __QuillRenderGetSkinBorderOutsideInsets(_st.skins);
		var _tb_outer_x1 = _tb_x1 - _tb_border_out.left;
		var _tb_outer_y1 = _tb_y1 - _tb_border_out.top;
		var _tb_outer_x2 = _tb_x2 + _tb_border_out.right;
		var _tb_outer_y2 = _tb_y2 + _tb_border_out.bottom;

		var _label_layout = __QuillRenderBuildLabelLayout(self, _st, _tb_outer_x1, _tb_outer_y1, _tb_outer_x2, _tb_outer_y2);
		var _label_rect = is_struct(_label_layout) ? _label_layout.label_rect : undefined;

		var _comp_x1 = _tb_outer_x1;
		var _comp_y1 = _tb_outer_y1;
		var _comp_x2 = _tb_outer_x2;
		var _comp_y2 = _tb_outer_y2;
		if (is_struct(_label_rect)) {
			_comp_x1 = min(_comp_x1, _label_rect.x1);
			_comp_y1 = min(_comp_y1, _label_rect.y1);
			_comp_x2 = max(_comp_x2, _label_rect.x2);
			_comp_y2 = max(_comp_y2, _label_rect.y2);
		}

		var _shift_x = _x - _comp_x1;
		var _shift_y = _y - _comp_y1;
		if (_shift_x != 0 || _shift_y != 0) {
			_tb_x1 += _shift_x;
			_tb_y1 += _shift_y;
			_tb_x2 += _shift_x;
			_tb_y2 += _shift_y;
			_tb_outer_x1 += _shift_x;
			_tb_outer_y1 += _shift_y;
			_tb_outer_x2 += _shift_x;
			_tb_outer_y2 += _shift_y;

			_comp_x1 += _shift_x;
			_comp_y1 += _shift_y;
			_comp_x2 += _shift_x;
			_comp_y2 += _shift_y;

			if (is_struct(_label_rect)) {
				_label_rect.x1 += _shift_x;
				_label_rect.y1 += _shift_y;
				_label_rect.x2 += _shift_x;
				_label_rect.y2 += _shift_y;

				var _label_inner_rect = _label_layout.label_inner_rect;
				if (is_struct(_label_inner_rect)) {
					_label_inner_rect.x1 += _shift_x;
					_label_inner_rect.y1 += _shift_y;
					_label_inner_rect.x2 += _shift_x;
					_label_inner_rect.y2 += _shift_y;
				}

				var _label_text_rect = _label_layout.text_rect;
				if (is_struct(_label_text_rect)) {
					_label_text_rect.x1 += _shift_x;
					_label_text_rect.y1 += _shift_y;
					_label_text_rect.x2 += _shift_x;
					_label_text_rect.y2 += _shift_y;
				}
			}
		}

		last_rect = { x1: _tb_outer_x1, y1: _tb_outer_y1, x2: _tb_outer_x2, y2: _tb_outer_y2 };
		last_textbox_rect = last_rect;
		last_label_rect = _label_rect;
		last_component_rect = { x1: _comp_x1, y1: _comp_y1, x2: _comp_x2, y2: _comp_y2 };

		var _pad_l = max(0, _st.textbox.pad_l);
		var _pad_t = max(0, _st.textbox.pad_t);
		var _pad_r = max(0, _st.textbox.pad_r);
		var _pad_b = max(0, _st.textbox.pad_b);
		var _tb_border_in = __QuillRenderGetSkinBorderInsideInsets(_st.skins);
		var _tx1 = _tb_x1 + _tb_border_in.left + _pad_l;
		var _ty1 = _tb_y1 + _tb_border_in.top + _pad_t;
		var _tx2 = _tb_x2 - _tb_border_in.right - _pad_r;
		var _ty2 = _tb_y2 - _tb_border_in.bottom - _pad_b;

		var _active = (global.__QUILL_CORE._active_id == id);
		var _hover = (global.__QUILL_CORE._hover_id == id);

		if (is_struct(_label_layout)) {
			__QuillRenderDrawLabel(self, _st, _label_layout);
		}
		__QuillRenderDrawTextBox(self, _st, _tb_x1, _tb_y1, _tb_x2, _tb_y2, _active, _hover);

		if (config[$ "multiline"] == true) {
			var _base_view_w = max(0, _tx2 - _tx1);
			var _base_view_h = max(0, _ty2 - _ty1);
			var _sb_w = max(1, floor(_st.scrollbar.w));
			var _sb_pad = max(0, floor(_st.scrollbar.pad));
			var _sb_border_out = __QuillRenderGetBorderSpriteOutsideInsets(_st.scrollbar.border_spr, _st.scrollbar.border_spr_outside_draw);
			var _sb_border_in = __QuillRenderGetBorderSpriteInsideInsets(_st.scrollbar.border_spr, _st.scrollbar.border_spr_outside_draw);
			var _sb_draw_w = _sb_w + _sb_border_in.left + _sb_border_in.right;
			var _sb_draw_h = _sb_w + _sb_border_in.top + _sb_border_in.bottom;
			var _sb_total_v = _sb_draw_w + (_sb_pad * 2) + _sb_border_out.left + _sb_border_out.right;
			var _sb_total_h = _sb_draw_h + (_sb_pad * 2) + _sb_border_out.top + _sb_border_out.bottom;
			var _wrap = ((config[$ "wrap"] ?? true) == true);

			var _show_scroll_v = false;
			var _show_scroll_h = false;
			var _view_w = _base_view_w;
			var _view_h = _base_view_h;
			var _layout = undefined;
			for (var _iter = 0; _iter < 3; _iter++) {
				_view_w = max(0, _base_view_w - (_show_scroll_v ? _sb_total_v : 0));
				_view_h = max(0, _base_view_h - (_show_scroll_h ? _sb_total_h : 0));

				if (config[$ "view_w"] != _view_w) {
					config[$ "view_w"] = _view_w;
					layout_cache_gen = -1;
				}
				if (config[$ "view_h"] != _view_h) {
					config[$ "view_h"] = _view_h;
					layout_cache_gen = -1;
				}

				_layout = global.__QUILL_CORE.__GetActiveLayoutForTb(self, config);
				if (!is_struct(_layout)) {
					_show_scroll_v = false;
					_show_scroll_h = false;
					break;
				}

				var _next_v = (_layout.content_h > _view_h + 0.5);
				var _next_h = (!_wrap && _layout.content_w > _view_w + 0.5);
				if (_next_v == _show_scroll_v && _next_h == _show_scroll_h) {
					break;
				}
				_show_scroll_v = _next_v;
				_show_scroll_h = _next_h;
			}

			_view_w = max(0, _base_view_w - (_show_scroll_v ? _sb_total_v : 0));
			_view_h = max(0, _base_view_h - (_show_scroll_h ? _sb_total_h : 0));
			if (config[$ "view_w"] != _view_w) {
				config[$ "view_w"] = _view_w;
				layout_cache_gen = -1;
			}
			if (config[$ "view_h"] != _view_h) {
				config[$ "view_h"] = _view_h;
				layout_cache_gen = -1;
			}
			_layout = global.__QUILL_CORE.__GetActiveLayoutForTb(self, config);

			var _text_x2 = _tx2 - (_show_scroll_v ? _sb_total_v : 0);
			var _text_y2 = _ty2 - (_show_scroll_h ? _sb_total_h : 0);

			last_scroll_track_rect = undefined;
			last_scroll_thumb_rect = undefined;
			last_scroll_h_track_rect = undefined;
			last_scroll_h_thumb_rect = undefined;

			if (is_struct(_layout)) {
				var _scroll_y = global.__QUILL_CORE.__TextAreaGetScrollY(config);
				_scroll_y = global.__QUILL_CORE.__ClampScroll(_scroll_y, _layout.content_h, _view_h);
				global.__QUILL_CORE.__TextAreaSetScrollY(config, _scroll_y);
				var _scroll_x = global.__QUILL_CORE.__TextAreaGetScrollX(self, config);
				_scroll_x = global.__QUILL_CORE.__ClampScrollX(_scroll_x, _layout.content_w, _view_w);
				global.__QUILL_CORE.__TextAreaSetScrollX(self, config, _scroll_x);

				if (_show_scroll_v) {
					var _v_track_draw_x1 = _text_x2 + _sb_pad + _sb_border_out.left;
					var _v_track_draw_y1 = _ty1 + _sb_pad + _sb_border_out.top;
					var _v_track_draw_x2 = _v_track_draw_x1 + _sb_draw_w;
					var _v_track_draw_y2 = _text_y2 - _sb_pad - _sb_border_out.bottom;
					var _v_track_draw = { x1: _v_track_draw_x1, y1: _v_track_draw_y1, x2: _v_track_draw_x2, y2: _v_track_draw_y2 };

					var _v_track_lane_x1 = _v_track_draw.x1 + _sb_border_in.left;
					var _v_track_lane_y1 = _v_track_draw.y1 + _sb_border_in.top;
					var _v_track_lane_x2 = _v_track_draw.x2 - _sb_border_in.right;
					var _v_track_lane_y2 = _v_track_draw.y2 - _sb_border_in.bottom;
					var _v_track = {
						x1: _v_track_lane_x1,
						y1: _v_track_lane_y1,
						x2: max(_v_track_lane_x1, _v_track_lane_x2),
						y2: max(_v_track_lane_y1, _v_track_lane_y2)
					};
					last_scroll_track_rect = _v_track;

					var _v_track_h = max(0, _v_track.y2 - _v_track.y1);
					var _v_thumb_h = (_view_h * _view_h) / max(1, _layout.content_h);
					var _thumb_min_h = max(1, floor(_st.scrollbar.thumb_min_h));
					_v_thumb_h = clamp(_v_thumb_h, _thumb_min_h, _v_track_h);
					var _max_scroll_y = max(0, _layout.content_h - _view_h);
					var _t_v = (_max_scroll_y <= 0) ? 0 : (_scroll_y / _max_scroll_y);
					var _v_travel = max(0, _v_track_h - _v_thumb_h);
					var _v_thumb_y1 = _v_track.y1 + (_t_v * _v_travel);
					var _v_thumb = { x1: _v_track.x1, y1: _v_thumb_y1, x2: _v_track.x2, y2: _v_thumb_y1 + _v_thumb_h };
					last_scroll_thumb_rect = _v_thumb;
					__QuillRenderDrawScrollbarV(self, _st, _v_track_draw, _v_thumb, _active);
				}

				if (_show_scroll_h) {
					var _h_track_draw_x1 = _tx1 + _sb_pad + _sb_border_out.left;
					var _h_track_draw_y1 = _text_y2 + _sb_pad + _sb_border_out.top;
					var _h_track_draw_x2 = _text_x2 - _sb_pad - _sb_border_out.right;
					var _h_track_draw_y2 = _h_track_draw_y1 + _sb_draw_h;
					var _h_track_draw = { x1: _h_track_draw_x1, y1: _h_track_draw_y1, x2: _h_track_draw_x2, y2: _h_track_draw_y2 };

					var _h_track_lane_x1 = _h_track_draw.x1 + _sb_border_in.left;
					var _h_track_lane_y1 = _h_track_draw.y1 + _sb_border_in.top;
					var _h_track_lane_x2 = _h_track_draw.x2 - _sb_border_in.right;
					var _h_track_lane_y2 = _h_track_draw.y2 - _sb_border_in.bottom;
					var _h_track = {
						x1: _h_track_lane_x1,
						y1: _h_track_lane_y1,
						x2: max(_h_track_lane_x1, _h_track_lane_x2),
						y2: max(_h_track_lane_y1, _h_track_lane_y2)
					};
					last_scroll_h_track_rect = _h_track;

					var _h_track_w = max(0, _h_track.x2 - _h_track.x1);
					var _h_thumb_w = (_view_w * _view_w) / max(1, _layout.content_w);
					var _thumb_min_w = max(1, floor(_st.scrollbar.thumb_min_h));
					_h_thumb_w = clamp(_h_thumb_w, _thumb_min_w, _h_track_w);
					var _max_scroll_x = max(0, _layout.content_w - _view_w);
					var _t_h = (_max_scroll_x <= 0) ? 0 : (_scroll_x / _max_scroll_x);
					var _h_travel = max(0, _h_track_w - _h_thumb_w);
					var _h_thumb_x1 = _h_track.x1 + (_t_h * _h_travel);
					var _h_thumb = { x1: _h_thumb_x1, y1: _h_track.y1, x2: _h_thumb_x1 + _h_thumb_w, y2: _h_track.y2 };
					last_scroll_h_thumb_rect = _h_thumb;
					__QuillRenderDrawScrollbarH(self, _st, _h_track_draw, _h_thumb, _active);
				}
			}

			last_text_rect = { x1: _tx1, y1: _ty1, x2: _text_x2, y2: _text_y2 };
			__QuillRenderDrawTextMulti(self, _st, config, last_text_rect, _active);

			if (resizable == true && show_resize_grip == true) {
				var _gr_size = max(1, floor(_st.skins.resize_grip_size));
				var _gr_pad = max(0, floor(_st.skins.resize_pad));
				var _gr = { x1: _tb_outer_x2 - (_gr_size + _gr_pad), y1: _tb_outer_y2 - (_gr_size + _gr_pad), x2: _tb_outer_x2 - _gr_pad, y2: _tb_outer_y2 - _gr_pad };
				last_resize_grip_rect = _gr;
				__QuillRenderDrawResizeGrip(self, _st, _gr);
			}
			else {
				last_resize_grip_rect = undefined;
			}
		}
		else {
			config[$ "view_w"] = max(0, _tx2 - _tx1);
			config[$ "view_h"] = max(0, _ty2 - _ty1);
			last_text_rect = { x1: _tx1, y1: _ty1, x2: _tx2, y2: _ty2 };
			__QuillRenderDrawTextSingle(self, _st, config, last_text_rect, _active);
			last_scroll_track_rect = undefined;
			last_scroll_thumb_rect = undefined;
			last_scroll_h_track_rect = undefined;
			last_scroll_h_thumb_rect = undefined;
			last_resize_grip_rect = undefined;
		}

		__QuillRenderDrawValidationInline(self, _st, _tb_x1, _tb_y2, _tb_x2 - _tb_x1);

		last_draw_seq = global.__QUILL_CORE.__RegisterDraw({
			id: id,
			x1: _comp_x1,
			y1: _comp_y1,
			x2: _comp_x2,
			y2: _comp_y2,
			tbx1: _tb_outer_x1,
			tby1: _tb_outer_y1,
			tbx2: _tb_outer_x2,
			tby2: _tb_outer_y2,
			lbx1: is_struct(last_label_rect) ? last_label_rect.x1 : undefined,
			lby1: is_struct(last_label_rect) ? last_label_rect.y1 : undefined,
			lbx2: is_struct(last_label_rect) ? last_label_rect.x2 : undefined,
			lby2: is_struct(last_label_rect) ? last_label_rect.y2 : undefined,
			multiline: (config[$ "multiline"] == true),
			wrap: (config[$ "wrap"] == true),
			view_w: max(0, last_text_rect.x2 - last_text_rect.x1),
			view_h: max(0, last_text_rect.y2 - last_text_rect.y1),
			font: _font,
			tx1: _tx1,
			ty1: _ty1,
			tx2: _tx2,
			ty2: _ty2
		});

		draw_set_halign(_old_halign);
		draw_set_valign(_old_valign);
	};

	/// @func DrawOverlay()
	/// @desc Draw overlays owned by this box (context menu, overlay editor) if present.
	static DrawOverlay = function() {
		global.__QUILL_CORE.__DrawOverlaysForOwner(id);
	};
	
	/// @ignore
	/// @func __SetValueRaw(_v)
	/// @desc Internal raw value write (no transform/filter pipeline).
	/// @param {Any} _v
	static __SetValueRaw = function(_v) {
		var _s = is_undefined(_v) ? "" : string(_v);
		if (_s == text && (!is_struct(bind_struct) || string_length(bind_key) <= 0)) {
			return;
		}
		
		if (is_struct(bind_struct) && string_length(bind_key) > 0) {
			bind_struct[$ bind_key] = _s;
		}
		text = _s;
		
		if (is_callable(on_change)) {
			on_change(self, _s);
		}
	};
	
	/// @ignore
	static __SyncFromBinding = function() {
		if (is_struct(bind_struct) && string_length(bind_key) > 0) {
			var _v = bind_struct[$ bind_key];
			var _s = is_undefined(_v) ? "" : string(_v);
			if (_s != text) {
				text = _s;
				global.__QUILL_CORE.__TextInputClampIndices(self);
				global.__QUILL_CORE.__TextInputBumpGen(self);
			}
		}
	};

	/// @ignore
	static __InvalidateMeasuredSize = function() {
		__measured_dirty = true;
	};

	/// @ignore
	static __EnsureMeasuredSize = function(_w_hint = undefined, _h_hint = undefined, _allow_cached_hints = true) {
		var _w_target = _w_hint;
		if (_allow_cached_hints && is_undefined(_w_target)) {
			_w_target = __measured_w_hint;
		}
		var _h_target = _h_hint;
		if (_allow_cached_hints && is_undefined(_h_target)) {
			_h_target = __measured_h_hint;
		}

		var _same_w_hint = false;
		if (is_undefined(__measured_w_hint) && is_undefined(_w_target)) {
			_same_w_hint = true;
		}
		else if (!is_undefined(__measured_w_hint) && !is_undefined(_w_target) && __measured_w_hint == _w_target) {
			_same_w_hint = true;
		}

		var _same_h_hint = false;
		if (is_undefined(__measured_h_hint) && is_undefined(_h_target)) {
			_same_h_hint = true;
		}
		else if (!is_undefined(__measured_h_hint) && !is_undefined(_h_target) && __measured_h_hint == _h_target) {
			_same_h_hint = true;
		}

		var _needs_rebuild = (__measured_dirty == true)
		|| (__measured_style_gen != __style_gen)
		|| (__measured_edit_gen != edit_gen)
		|| (!_same_w_hint)
		|| (!_same_h_hint);
		if (!_needs_rebuild) {
			return;
		}

		if (__style_cache_gen != __style_gen) {
			__style_cache = global.__QUILL_CORE.__BuildResolvedStyleForTb(self);
			__style_cache_gen = __style_gen;
		}
		var _st = __style_cache;
		var _font = global.__QUILL_CORE.__ResolveTextboxFont(self, config, _st);
		var _tb_border_in = __QuillRenderGetSkinBorderInsideInsets(_st.skins);
		var _pad_l_auto = max(0, _st.textbox.pad_l);
		var _pad_t_auto = max(0, _st.textbox.pad_t);
		var _pad_r_auto = max(0, _st.textbox.pad_r);
		var _pad_b_auto = max(0, _st.textbox.pad_b);
		var _w_min = max(1, _tb_border_in.left + _tb_border_in.right + _pad_l_auto + _pad_r_auto + 1);
		var _h_min = max(1, _tb_border_in.top + _tb_border_in.bottom + _pad_t_auto + _pad_b_auto + 1);

		var _w_use = _w_target;
		if (is_undefined(_w_use)) {
			_w_use = preferred_width;
		}
		_w_use = max(_w_min, _w_use);

		var _h_use = _h_target;
		if (is_undefined(_h_use)) {
			var _old_font = draw_get_font();
			draw_set_font(_font);
			var _line_h = string_height("Ag");
			draw_set_font(_old_font);

			if (config[$ "multiline"] == true) {
				if (preferred_height > 0) {
					_h_use = preferred_height;
				}
				else {
					_h_use = max(0, (visible_rows * _line_h) + _pad_t_auto + _pad_b_auto + _tb_border_in.top + _tb_border_in.bottom);
				}
				_h_use = max(_h_use, min_height);
				if (max_height > 0) {
					_h_use = min(_h_use, max_height);
				}
			}
			else {
				_h_use = max(0, _line_h + _pad_t_auto + _pad_b_auto + _tb_border_in.top + _tb_border_in.bottom);
			}
		}
		_h_use = max(_h_min, _h_use);

		var _tb_x1 = 0;
		var _tb_y1 = 0;
		var _tb_x2 = _tb_x1 + _w_use;
		var _tb_y2 = _tb_y1 + _h_use;
		var _tb_border_out = __QuillRenderGetSkinBorderOutsideInsets(_st.skins);
		var _tb_outer_x1 = _tb_x1 - _tb_border_out.left;
		var _tb_outer_y1 = _tb_y1 - _tb_border_out.top;
		var _tb_outer_x2 = _tb_x2 + _tb_border_out.right;
		var _tb_outer_y2 = _tb_y2 + _tb_border_out.bottom;
		var _label_layout = __QuillRenderBuildLabelLayout(self, _st, _tb_outer_x1, _tb_outer_y1, _tb_outer_x2, _tb_outer_y2);
		var _label_rect = is_struct(_label_layout) ? _label_layout.label_rect : undefined;

		var _comp_x1 = _tb_outer_x1;
		var _comp_y1 = _tb_outer_y1;
		var _comp_x2 = _tb_outer_x2;
		var _comp_y2 = _tb_outer_y2;
		if (is_struct(_label_rect)) {
			_comp_x1 = min(_comp_x1, _label_rect.x1);
			_comp_y1 = min(_comp_y1, _label_rect.y1);
			_comp_x2 = max(_comp_x2, _label_rect.x2);
			_comp_y2 = max(_comp_y2, _label_rect.y2);
		}

		__measured_w_hint = _w_target;
		__measured_h_hint = _h_target;
		__measured_box_w = max(0, _tb_x2 - _tb_x1);
		__measured_box_h = max(0, _tb_y2 - _tb_y1);
		__measured_component_w = max(0, _comp_x2 - _comp_x1);
		__measured_component_h = max(0, _comp_y2 - _comp_y1);
		__measured_style_gen = __style_gen;
		__measured_edit_gen = edit_gen;
		__measured_dirty = false;
	};
	
	/// @ignore
	static __LabelEnsureOverrides = function() {
		var _label = overrides[$ "label"];
		if (!is_struct(_label)) {
			_label = {};
			overrides[$ "label"] = _label;
		}
		return _label;
	};

	/// @ignore
	static __FontsEnsureOverrides = function() {
		var _fonts = overrides[$ "fonts"];
		if (!is_struct(_fonts)) {
			_fonts = {};
			overrides[$ "fonts"] = _fonts;
		}
		return _fonts;
	};
}
