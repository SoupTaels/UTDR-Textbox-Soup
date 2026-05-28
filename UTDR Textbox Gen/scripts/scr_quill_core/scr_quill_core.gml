/* -------------------------------------------------------------------------------------------------
QUILL by RefresherTowel Games

v1.0.3

Docs: https://refreshertowel.github.io/docs/quill/
Discord: https://discord.gg/QJQ4cRHPx9
More Libraries: https://refreshertowel.itch.io/

Quill is a standalone textbox library that features all of the annoying to implement things
that users expect when they encounter a textbox, while being very simple to handle as a developer.
I hope that it helps speed up your game development!

Be sure to check out the documentation, as it is thorough and should guide you through the process
of learning how to use Quill effectively.

If you like Quill, consider checking out my other libraries, I'm sure there's something else
you'll be able to find that'll help you make your games even faster!
------------------------------------------------------------------------------------------------- */

/// @ignore
/// @func __QuillContextMenuEntry(_is_separator, _label, _on_click, _key)
/// @desc Internal context menu item base constructor.
/// @param {Bool} _is_separator
/// @param {String} _label
/// @param {Function} _on_click
/// @param {String} _key
function __QuillContextMenuEntry(_is_separator = false, _label = "", _on_click = undefined, _key = "") constructor {
	static __uid = -1;
	__uid += 1;
	self.__uid = __uid;
	key = string(_key);
	is_separator = (_is_separator == true);
	label = string(_label);
	shortcut = "";
	enabled = true;
	visible = true;
	on_click = is_callable(_on_click) ? _on_click : undefined;

	/// @func SetKey(_key)
	/// @desc Set a stable semantic key for lookups and replacement.
	/// @param {String} _key
	/// @return {Struct.__QuillContextMenuEntry}
	static SetKey = function(_key) {
		key = string(_key);
		return self;
	};

	/// @func SetLabel(_label)
	/// @desc Set menu row label text.
	/// @param {String} _label
	/// @return {Struct.__QuillContextMenuEntry}
	static SetLabel = function(_label) {
		label = string(_label);
		return self;
	};

	/// @func SetShortcut(_shortcut)
	/// @desc Set shortcut hint text shown on the right side.
	/// @param {String} _shortcut
	/// @return {Struct.__QuillContextMenuEntry}
	static SetShortcut = function(_shortcut) {
		shortcut = string(_shortcut);
		return self;
	};

	/// @func SetEnabled(_flag)
	/// @desc Set whether this row is actionable.
	/// @param {Bool} _flag
	/// @return {Struct.__QuillContextMenuEntry}
	static SetEnabled = function(_flag) {
		enabled = (_flag == true);
		return self;
	};

	/// @func SetVisible(_flag)
	/// @desc Set whether this row is included when the menu opens.
	/// @param {Bool} _flag
	/// @return {Struct.__QuillContextMenuEntry}
	static SetVisible = function(_flag) {
		visible = (_flag == true);
		return self;
	};

	/// @func SetOnClick(_on_click)
	/// @desc Set callback invoked when the row is activated.
	/// @param {Function} _on_click
	/// @return {Struct.__QuillContextMenuEntry}
	static SetOnClick = function(_on_click) {
		on_click = is_callable(_on_click) ? _on_click : undefined;
		return self;
	};
}

/// @ignore
/// @func __QuillContextMenuItem(_label, _on_click, _key)
/// @desc Internal context menu action item constructor.
/// @param {String} _label
/// @param {Function} _on_click
/// @param {String} _key
function __QuillContextMenuItem(_label = "", _on_click = undefined, _key = "") : __QuillContextMenuEntry(false, _label, _on_click, _key) constructor {}

/// @ignore
/// @func __QuillContextMenuSeparator(_key)
/// @desc Internal context menu separator constructor.
/// @param {String} _key
function __QuillContextMenuSeparator(_key = "") : __QuillContextMenuEntry(true, "", undefined, _key) constructor {}

/// @func QuillContextMenuItem(_label, _on_click, _key)
/// @desc Create a standard Quill context menu action item.
/// @param {String} _label
/// @param {Function} _on_click
/// @param {String} _key
/// @return {Struct.__QuillContextMenuItem}
function QuillContextMenuItem(_label = "", _on_click = undefined, _key = "") {
	return new __QuillContextMenuItem(_label, _on_click, _key);
}

/// @func QuillContextMenuSeparator(_key)
/// @desc Create a standard Quill context menu separator item.
/// @param {String} _key
/// @return {Struct.__QuillContextMenuSeparator}
function QuillContextMenuSeparator(_key = "") {
	return new __QuillContextMenuSeparator(_key);
}

/// @func QuillContextMenuAddItem(_item)
/// @desc Add or replace a global custom context menu item for all textboxes.
/// @param {Struct} _item
/// @return {Struct}
function QuillContextMenuAddItem(_item) {
	QuillEnsure();
	return QUILL.ContextMenuAddItem(_item);
}

/// @func QuillContextMenuRemoveItem(_key_or_uid)
/// @desc Remove a global custom context menu item by key or __uid.
/// @param {Any} _key_or_uid
/// @return {Bool}
function QuillContextMenuRemoveItem(_key_or_uid) {
	QuillEnsure();
	return QUILL.ContextMenuRemoveItem(_key_or_uid);
}

/// @func QuillContextMenuGetItem(_key_or_uid)
/// @desc Get a global custom context menu item by key or __uid.
/// @param {Any} _key_or_uid
/// @return {Struct}
function QuillContextMenuGetItem(_key_or_uid) {
	QuillEnsure();
	return QUILL.ContextMenuGetItem(_key_or_uid);
}

/// @func QuillContextMenuClearItems()
/// @desc Clear all global custom context menu items.
function QuillContextMenuClearItems() {
	QuillEnsure();
	QUILL.ContextMenuClearItems();
}

/// @func QuillSetTheme(_theme)
/// @desc Set the global Quill theme baseline used by boxes without a per-box theme.
/// @param {Struct.QuillTheme} _theme
/// @return {Struct.__QuillCore}
function QuillSetTheme(_theme) {
	QuillEnsure();
	return QUILL.SetTheme(_theme);
}

/// @func QuillGetTheme()
/// @desc Get the current global Quill theme baseline.
/// @return {Struct.QuillTheme}
function QuillGetTheme() {
	QuillEnsure();
	return QUILL.GetTheme();
}

/// @ignore
/// @func __QuillCore()
/// @desc Internal Quill manager (registry, input, overlays, helpers).
function __QuillCore() constructor {
	_boxes = [];
	_by_id = {};
	_next_id = 1;
	_actionenabled = true;

	_active_id = 0;
	_hover_id = 0;
	_mouse_capture_id = 0;
	_scroll_capture_id = 0;
	_resize_capture_id = 0;

	_regs = [];
	_frame_seq = 0;
	_frame_i = 0;
	_vb_dbg_rebuilds = 0;
	_vb_dbg_submits = 0;
	_vb_dbg_last_log_frame = 0;

	_double_click_ms = 320;

	// Key repeat timings (Echo Chamber parity defaults).
	_key_repeat_delay_ms = 350;
	_key_repeat_rate_ms = 40;

	// Context menu overlay state (stored, user-drawn).
	_context_menu_open = false;
	_context_menu_owner_id = 0;
	_context_menu_items = [];
	_context_menu_item_count = 0;
	_context_menu_global_items = [];
	_context_menu_x = 0;
	_context_menu_y = 0;
	_context_menu_w = 0;
	_context_menu_h = 0;
	_context_menu_pad = 8;
	_context_menu_row_h = 20;
	_context_menu_sep_min_h = 6;
	_context_menu_rect = undefined;
	_context_menu_inner_rect = undefined;
	_context_menu_hover_i = -1;
	_context_menu_key_i = -1;
	_context_menu_open_time = 0;

	// Overlay editor state (modal, user-drawn).
	_editor_open = false;
	_editor_owner_id = 0;
	_editor_tb_id = 0;
	_editor_tb_ref = undefined;
	_editor_prev_active_id = 0;
	_editor_original_text = "";
	_editor_rect = undefined;
	_editor_outer_rect = undefined;
	_editor_title = "Edit text";

	global_theme = new QuillTheme();
	
	/// @func OpenContextMenu(_items, _x, _y, _owner_id)
	/// @desc Open a context menu overlay at a GUI position.
	/// @param {Array} _items
	/// @param {Real} _x
	/// @param {Real} _y
	/// @param {Real} _owner_id
	static OpenContextMenu = function(_items, _x, _y, _owner_id) {
		if (!is_array(_items)) {
			return;
		}
		
		_context_menu_items = _items;
		_context_menu_item_count = array_length(_items);
		if (_context_menu_item_count <= 0) {
			CloseContextMenu();
			return;
		}
		
		_context_menu_open = true;
		_context_menu_owner_id = max(0, floor(_owner_id));
		_context_menu_x = _x;
		_context_menu_y = _y;
		_context_menu_open_time = current_time;
		
		var _owner = __GetBoxById(_context_menu_owner_id);
		var _st = __BuildResolvedStyleForTb(_owner);
		var _t_menu = _st.menu;
		_context_menu_pad = max(0, floor(_t_menu.pad_x));
		_context_menu_row_h = max(1, floor(_t_menu.item_h));
		_context_menu_sep_min_h = max(1, floor(_t_menu.sep_min_h));
		
		_context_menu_hover_i = -1;
		_context_menu_key_i = __ContextMenuFindFirstSelectable();
		
		__ContextMenuRecalcRect();
	};
	
	/// @func CloseContextMenu()
	/// @desc Close the active context menu overlay (if open).
	static CloseContextMenu = function() {
		_context_menu_open = false;
		_context_menu_owner_id = 0;
		_context_menu_items = [];
		_context_menu_item_count = 0;
		_context_menu_hover_i = -1;
		_context_menu_key_i = -1;
		_context_menu_rect = undefined;
		_context_menu_inner_rect = undefined;
	};
	
	/// @func IsContextMenuOpen()
	/// @desc Returns true if the context menu overlay is open.
	/// @return {Bool}
	static IsContextMenuOpen = function() {
		return _context_menu_open;
	};

	/// @func ContextMenuAddItem(_item)
	/// @desc Add or replace a global custom context menu item.
	/// @param {Struct} _item
	/// @return {Struct}
	static ContextMenuAddItem = function(_item) {
		var _res = __ContextMenuCollectionAdd(_context_menu_global_items, _item);
		_context_menu_global_items = _res.items;
		return _res.item;
	};

	/// @func ContextMenuRemoveItem(_key_or_uid)
	/// @desc Remove a global custom context menu item by key or __uid.
	/// @param {Any} _key_or_uid
	/// @return {Bool}
	static ContextMenuRemoveItem = function(_key_or_uid) {
		var _res = __ContextMenuCollectionRemove(_context_menu_global_items, _key_or_uid);
		_context_menu_global_items = _res.items;
		return _res.removed;
	};

	/// @func ContextMenuGetItem(_key_or_uid)
	/// @desc Get a global custom context menu item by key or __uid.
	/// @param {Any} _key_or_uid
	/// @return {Struct}
	static ContextMenuGetItem = function(_key_or_uid) {
		return __ContextMenuCollectionGet(_context_menu_global_items, _key_or_uid);
	};

	/// @func ContextMenuClearItems()
	/// @desc Clear all global custom context menu items.
	/// @return {Struct.__QuillCore}
	static ContextMenuClearItems = function() {
		_context_menu_global_items = [];
		return self;
	};

	/// @func SetTheme(_theme)
	/// @desc Replace the global theme used by textboxes that do not have a per-box theme.
	/// @param {Struct.QuillTheme} _theme
	/// @return {Struct.__QuillCore}
	static SetTheme = function(_theme) {
		if (!is_instanceof(_theme, QuillTheme)) {
			return self;
		}

		global_theme = _theme;
		__InvalidateAllTextboxStyles();
		return self;
	};

	/// @func GetTheme()
	/// @desc Return the current global Quill theme.
	/// @return {Struct.QuillTheme}
	static GetTheme = function() {
		return global_theme;
	};

	/// @ignore
	static __InvalidateAllTextboxStyles = function() {
		var _n = array_length(_boxes);
		for (var i = 0; i < _n; i++) {
			var _tb = __GetBoxById(_boxes[i]);
			if (is_struct(_tb)) {
				_tb.__style_gen += 1;
			}
		}
	};

	/// @ignore
	static __GetThemeForTb = function(_tb) {
		if (is_struct(_tb) && is_struct(_tb.theme)) {
			return _tb.theme;
		}
		return global_theme;
	};

	/// @ignore
	static __ResolveSubtheme = function(_theme_sub, _ovr_sub, _keys) {
		var _out = {};
		var _ovr = is_struct(_ovr_sub) ? _ovr_sub : {};
		var _base = is_struct(_theme_sub) ? _theme_sub : {};
		var _n = array_length(_keys);
		for (var i = 0; i < _n; i++) {
			var _k = _keys[i];
			_out[$ _k] = _ovr[$ _k] ?? _base[$ _k];
		}
		return _out;
	};

	/// @ignore
	static __BuildResolvedStyleForTb = function(_tb) {
		
		static __fonts_keys = ["mainfont", "body", "code", "label", "menu", "editor_title", "editor_body", "validation"];
		static __tb_keys = [
		"pad_l", "pad_t", "pad_r", "pad_b",
		"text_col", "text_a",
		"placeholder_col", "placeholder_a",
		"disabled_text_col", "disabled_text_a",
		"validation_gap", "line_highlight_col", "line_highlight_a",
		"validation_error_col", "validation_warn_col", "validation_info_col", "validation_a"
		];
		static __label_keys = [
		"pad_l", "pad_t", "pad_r", "pad_b",
		"margin_l", "margin_t", "margin_r", "margin_b",
		"text_col", "text_a",
		"bg_spr", "bg_subimg",
		"border_spr", "border_subimg", "border_spr_outside_draw",
		"prim_bg_col", "prim_bg_a",
		"prim_border_col", "prim_border_a", "prim_border_thickness"
		];
		static __skin_keys = [
		"bg_spr", "bg_subimg",
		"border_spr", "border_subimg", "border_spr_outside_draw",
		"caret_spr", "caret_subimg",
		"resize_spr", "resize_subimg",
		"resize_grip_size", "resize_pad",
		"prim_bg_idle_col", "prim_bg_idle_a",
		"prim_bg_hover_col", "prim_bg_hover_a",
		"prim_bg_active_col", "prim_bg_active_a",
		"prim_bg_disabled_col", "prim_bg_disabled_a",
		"prim_bg_invalid_col", "prim_bg_invalid_a",
		"prim_border_idle_col", "prim_border_idle_a",
		"prim_border_hover_col", "prim_border_hover_a",
		"prim_border_active_col", "prim_border_active_a",
		"prim_border_disabled_col", "prim_border_disabled_a",
		"prim_border_invalid_col", "prim_border_invalid_a",
		"prim_border_thickness"
		];
		static __selection_keys = ["bg_col", "bg_a", "text_col", "text_a"];
		static __caret_keys = ["col", "a", "w", "blink_ms"];
		static __scrollbar_keys = [
		"bg_spr", "bg_subimg",
		"border_spr", "border_subimg", "border_spr_outside_draw",
		"thumb_spr", "thumb_subimg",
		"move_spr", "move_subimg",
		"w", "pad", "thumb_min_h",
		"track_col", "track_a",
		"thumb_idle_col", "thumb_idle_a",
		"thumb_hover_col", "thumb_hover_a",
		"thumb_active_col", "thumb_active_a",
		"border_col", "border_a"
		];
		static __menu_keys = [
		"item_h", "pad_x", "pad_y", "prim_padd",
		"min_w", "max_w", "viewport_margin", "shortcut_gap", "sep_min_h",
		"bg_spr", "bg_subimg",
		"border_spr", "border_subimg", "border_spr_outside_draw",
		"prim_bg_col", "prim_bg_a",
		"prim_border_col", "prim_border_a",
		"item_hover_col", "item_hover_a",
		"text_col", "text_a",
		"disabled_text_col", "disabled_text_a",
		"sep_col", "sep_a", "sep_h"
		];
		static __editor_keys = [
		"title_col", "title_a",
		"panel_bg_spr", "panel_bg_subimg",
		"panel_border_spr", "panel_border_subimg", "panel_border_spr_outside_draw",
		"prim_panel_bg_col", "prim_panel_bg_a",
		"prim_panel_border_col", "prim_panel_border_a",
		"pad_x", "pad_y",
		"viewport_margin", "min_w", "max_w", "min_h", "max_h", "dim_col", "dim_a",
		"btn_bg_idle_col", "btn_bg_idle_a",
		"btn_bg_hover_col", "btn_bg_hover_a",
		"btn_border_col", "btn_border_a",
		"btn_text_col", "btn_text_a",
		"btn_w", "btn_h", "btn_gap"
		];
		
		var _theme = __GetThemeForTb(_tb);
		var _ovr = is_struct(_tb) ? _tb.overrides : {};

		return {
			fonts: __ResolveSubtheme(
			_theme.fonts,
			_ovr[$ "fonts"],
			__fonts_keys
			),
			textbox: __ResolveSubtheme(
			_theme.textbox,
			_ovr[$ "textbox"],
			__tb_keys
			),
			label: __ResolveSubtheme(
			_theme.label,
			_ovr[$ "label"],
			__label_keys
			),
			skins: __ResolveSubtheme(
			_theme.skins,
			_ovr[$ "skins"],
			__skin_keys
			),
			selection: __ResolveSubtheme(
			_theme.selection,
			_ovr[$ "selection"],
			__selection_keys
			),
			caret: __ResolveSubtheme(
			_theme.caret,
			_ovr[$ "caret"],
			__caret_keys
			),
			scrollbar: __ResolveSubtheme(
			_theme.scrollbar,
			_ovr[$ "scrollbar"],
			__scrollbar_keys
			),
			menu: __ResolveSubtheme(
			_theme.menu,
			_ovr[$ "menu"],
			__menu_keys
			),
			editor: __ResolveSubtheme(
			_theme.editor,
			_ovr[$ "editor"],
			__editor_keys
			)
		};
	};

	/// @ignore
	static __GetResolvedStyleCachedForTb = function(_tb) {
		if (!is_struct(_tb)) {
			return __BuildResolvedStyleForTb(_tb);
		}
		if (!is_struct(_tb.__style_cache) || _tb.__style_cache_gen != _tb.__style_gen) {
			_tb.__style_cache = __BuildResolvedStyleForTb(_tb);
			_tb.__style_cache_gen = _tb.__style_gen;
		}
		return _tb.__style_cache;
	};

	/// @ignore
	static __ResolveTextboxFont = function(_tb, _config, _st = undefined, _fallback_font = undefined) {
		var _font = is_struct(_config) ? _config[$ "font"] : undefined;
		if (font_exists(_font)) {
			return _font;
		}

		var _style = is_struct(_st) ? _st : __GetResolvedStyleCachedForTb(_tb);
		var _style_fonts = is_struct(_style) ? _style[$ "fonts"] : undefined;
		if (is_struct(_style_fonts)) {
			var _mode = is_struct(_config) ? (_config[$ "input_mode"] ?? QUILL_TEXTMODE_TEXT) : QUILL_TEXTMODE_TEXT;
			if (_mode == QUILL_TEXTMODE_CODE) {
				_font = _style_fonts[$ "code"];
				if (font_exists(_font)) {
					return _font;
				}
			}
			_font = _style_fonts[$ "body"];
			if (font_exists(_font)) {
				return _font;
			}
		}

		var _fallback = _fallback_font;
		if (!font_exists(_fallback)) {
			_fallback = draw_get_font();
		}
		return _fallback;
	};

	/// @ignore
	static __VbDebugCountRebuild = function(_state_key) {
		if (!QUILL_VB_DEBUG) {
			return;
		}
		_vb_dbg_rebuilds += 1;
	};

	/// @ignore
	static __VbDebugCountSubmit = function(_state_key) {
		if (!QUILL_VB_DEBUG) {
			return;
		}
		_vb_dbg_submits += 1;
	};

	/// @ignore
	static __EnsureManagerInstance = function() {
		if (instance_exists(obj_quill_core)) {
			return;
		}
		instance_create_depth(0, 0, -15999, obj_quill_core);
	};

	/// @ignore
	static __CreateRegistryEntry = function(_tb) {
		return {
			wr: weak_ref_create(_tb),
			cache: {
				render: {
					fmt_ready: false,
					box_variants: {},
					vb_scroll_track: -1,
					sig_scroll_track: undefined,
					frozen_scroll_track: false,
					stable_scroll_track: 0,
					stable_frame_scroll_track: -1,
					vb_scroll_track_h: -1,
					sig_scroll_track_h: undefined,
					frozen_scroll_track_h: false,
					stable_scroll_track_h: 0,
					stable_frame_scroll_track_h: -1
				}
			}
		};
	};

	/// @ignore
	static __ReleaseRegistryCache = function(_cache) {
		if (!is_struct(_cache)) {
			return;
		}

		var _render = _cache[$ "render"];
		if (is_struct(_render)) {
			var _box_variants = _render[$ "box_variants"];
			if (is_struct(_box_variants)) {
				var _box_keys = variable_struct_get_names(_box_variants);
				var _box_n = array_length(_box_keys);
				for (var i = 0; i < _box_n; i++) {
					var _k = _box_keys[i];
					var _variant = _box_variants[$ _k];
					if (is_struct(_variant)) {
						var _vb_variant = _variant[$ "vb"] ?? -1;
						if (is_real(_vb_variant) && _vb_variant >= 0 && vertex_buffer_exists(_vb_variant)) {
							vertex_delete_buffer(_vb_variant);
						}
					}
				}
			}

			var _vb_box_legacy = _render[$ "vb_box"];
			if (is_real(_vb_box_legacy) && _vb_box_legacy >= 0 && vertex_buffer_exists(_vb_box_legacy)) {
				vertex_delete_buffer(_vb_box_legacy);
			}

			var _vb_scroll = _render[$ "vb_scroll_track"];
			if (is_real(_vb_scroll) && _vb_scroll >= 0 && vertex_buffer_exists(_vb_scroll)) {
				vertex_delete_buffer(_vb_scroll);
			}

			var _vb_scroll_h = _render[$ "vb_scroll_track_h"];
			if (is_real(_vb_scroll_h) && _vb_scroll_h >= 0 && vertex_buffer_exists(_vb_scroll_h)) {
				vertex_delete_buffer(_vb_scroll_h);
			}
		}
		_cache[$ "render"] = undefined;
	};

	/// @ignore
	static __GetEntryById = function(_id) {
		return _by_id[$ string(_id)];
	};

	/// @ignore
	static __DeleteEntryById = function(_id) {
		var _id_i = max(0, floor(_id));
		if (_id_i <= 0) {
			return;
		}

		var _key = string(_id_i);
		var _entry = _by_id[$ _key];
		if (is_struct(_entry)) {
			__ReleaseRegistryCache(_entry.cache);
		}
		_by_id[$ _key] = undefined;

		if (_active_id == _id_i) {
			_active_id = 0;
		}
		if (_hover_id == _id_i) {
			_hover_id = 0;
		}
		if (_mouse_capture_id == _id_i) {
			_mouse_capture_id = 0;
		}
		if (_scroll_capture_id == _id_i) {
			_scroll_capture_id = 0;
		}
		if (_resize_capture_id == _id_i) {
			_resize_capture_id = 0;
		}
		if (_context_menu_owner_id == _id_i) {
			CloseContextMenu();
		}

		if (_editor_owner_id == _id_i || _editor_tb_id == _id_i) {
			_editor_open = false;
			_editor_owner_id = 0;
			if (_editor_tb_id == _id_i) {
				_editor_tb_ref = undefined;
			}
			_editor_tb_id = (_editor_tb_id == _id_i) ? 0 : _editor_tb_id;
			_editor_rect = undefined;
			_editor_outer_rect = undefined;
		}
		if (_editor_prev_active_id == _id_i) {
			_editor_prev_active_id = 0;
		}
	};

	/// @ignore
	static __PruneDeadBoxes = function() {
		for (var i = array_length(_boxes) - 1; i >= 0; i--) {
			var _id = _boxes[i];
			var _entry = __GetEntryById(_id);
			var _dead = !is_struct(_entry);
			if (!_dead) {
				_dead = (weak_ref_alive(_entry.wr) != true);
			}
			if (_dead) {
				__DeleteEntryById(_id);
				array_delete(_boxes, i, 1);
			}
		}
	};

	/// @ignore
	static __RegisterBox = function(_tb) {
		if (!is_struct(_tb)) {
			return 0;
		}

		if (!instance_exists(obj_quill_core)) {
			__EnsureManagerInstance();
		}

		if (_tb.id > 0) {
			var _id_existing = floor(_tb.id);
			var _entry_existing = __GetEntryById(_id_existing);
			if (is_struct(_entry_existing)) {
				_entry_existing.wr = weak_ref_create(_tb);
			}
			else {
				_by_id[$ string(_id_existing)] = __CreateRegistryEntry(_tb);
				array_push(_boxes, _id_existing);
			}
			return _tb.id;
		}

		var _id = _next_id;
		_next_id += 1;

		_tb.id = _id;
		array_push(_boxes, _id);
		_by_id[$ string(_id)] = __CreateRegistryEntry(_tb);
		return _id;
	};

	/// @ignore
	static __GetBoxById = function(_id) {
		var _entry = __GetEntryById(_id);
		if (!is_struct(_entry)) {
			return undefined;
		}
		var _wr = _entry.wr;
		if (!is_struct(_wr)) {
			return undefined;
		}
		if (weak_ref_alive(_wr) != true) {
			return undefined;
		}
		return _wr.ref;
	};

	/// @ignore
	static __GetBoxCacheById = function(_id) {
		var _entry = __GetEntryById(_id);
		if (is_struct(_entry)) {
			return _entry.cache;
		}
		return undefined;
	};

	/// @ignore
	static __EmitFocus = function(_tb) {
		if (!is_struct(_tb)) {
			return;
		}
		if (is_callable(_tb.on_focus)) {
			_tb.on_focus(_tb);
		}
	};

	/// @ignore
	static __EmitBlur = function(_tb) {
		if (!is_struct(_tb)) {
			return;
		}
		if (is_callable(_tb.on_blur)) {
			_tb.on_blur(_tb);
		}
	};

	/// @ignore
	static __EmitSubmit = function(_tb) {
		if (!is_struct(_tb)) {
			return;
		}
		if (is_callable(_tb.on_submit)) {
			_tb.on_submit(_tb, _tb.GetValue());
		}
	};

	/// @ignore
	static __EmitCancel = function(_tb) {
		if (!is_struct(_tb)) {
			return;
		}
		if (is_callable(_tb.on_cancel)) {
			_tb.on_cancel(_tb);
		}
	};

	/// @ignore
	static __TabGetOrderForBox = function(_tb) {
		if (!is_struct(_tb)) {
			return 1000000000;
		}
		var _ord = _tb.tab_order;
		if (is_real(_ord) && _ord >= 0) {
			return _ord;
		}
		return 1000000 + _tb.id;
	};

	/// @ignore
	static __TabCanFocus = function(_tb) {
		if (!is_struct(_tb)) {
			return false;
		}
		return (_tb.tab_enabled == true && _tb.enabled == true);
	};

	/// @ignore
	static __FocusMoveTab = function(_from_id, _dir) {
		var _from = max(0, floor(_from_id));
		var _step = (_dir >= 0) ? 1 : -1;
		var _from_tb = __GetBoxById(_from);
		var _from_order = __TabGetOrderForBox(_from_tb);

		var _best = 0;
		var _best_order = 0;
		var _best_id = 0;
		var _wrap = 0;
		var _wrap_order = 0;
		var _wrap_id = 0;
		var _have_best = false;
		var _have_wrap = false;

		var _n = array_length(_boxes);
		for (var i = 0; i < _n; i++) {
			var _id = _boxes[i];
			if (_id == _from) {
				continue;
			}
			var _tb = __GetBoxById(_id);
			if (!__TabCanFocus(_tb)) {
				continue;
			}

			var _ord = __TabGetOrderForBox(_tb);
			var _after = false;
			if (_step > 0) {
				_after = (_ord > _from_order) || (_ord == _from_order && _id > _from);
			}
			else {
				_after = (_ord < _from_order) || (_ord == _from_order && _id < _from);
			}

			if (_after) {
				if (!_have_best) {
					_best = _id;
					_best_order = _ord;
					_best_id = _id;
					_have_best = true;
				}
				else if (_step > 0) {
					if (_ord < _best_order || (_ord == _best_order && _id < _best_id)) {
						_best = _id;
						_best_order = _ord;
						_best_id = _id;
					}
				}
				else {
					if (_ord > _best_order || (_ord == _best_order && _id > _best_id)) {
						_best = _id;
						_best_order = _ord;
						_best_id = _id;
					}
				}
			}

			if (!_have_wrap) {
				_wrap = _id;
				_wrap_order = _ord;
				_wrap_id = _id;
				_have_wrap = true;
			}
			else if (_step > 0) {
				if (_ord < _wrap_order || (_ord == _wrap_order && _id < _wrap_id)) {
					_wrap = _id;
					_wrap_order = _ord;
					_wrap_id = _id;
				}
			}
			else {
				if (_ord > _wrap_order || (_ord == _wrap_order && _id > _wrap_id)) {
					_wrap = _id;
					_wrap_order = _ord;
					_wrap_id = _id;
				}
			}
		}

		if (_have_best) {
			__SetActive(_best);
			return true;
		}
		if (_have_wrap) {
			__SetActive(_wrap);
			return true;
		}
		return false;
	};

	/// @ignore
	static __SetActive = function(_id) {
		var _next = max(0, floor(_id));
		if (_next > 0) {
			var _target = __GetBoxById(_next);
			if (!is_struct(_target) || _target.enabled != true) {
				return;
			}
		}
		if (_next == _active_id) {
			return;
		}

		if (_mouse_capture_id > 0) {
			var _cap = __GetBoxById(_mouse_capture_id);
			if (is_struct(_cap)) {
				__TextInputEndMouseSelection(_cap);
			}
			_mouse_capture_id = 0;
		}

		var _prev_tb = __GetBoxById(_active_id);
		if (is_struct(_prev_tb)) {
			__TextInputClearSelection(_prev_tb);
			__EmitBlur(_prev_tb);
		}

		_active_id = _next;

		var _tb = __GetBoxById(_active_id);
		if (is_struct(_tb)) {
			_tb.__SyncFromBinding();
			__TextInputResetCaretBlink(_tb);
			var _cfg = _tb.config;
			if (is_struct(_cfg) && _cfg[$ "select_all_on_focus"] == true) {
				__TextInputSelectAll(_tb, _cfg);
			}
			else {
				__TextAreaUpdatePreferredXFromCaret(_tb, _cfg);
			}
			__EmitFocus(_tb);
		}
	};

	/// @ignore
	static __RegisterDraw = function(_payload) {
		if (!is_struct(_payload)) {
			return 0;
		}
		_frame_seq += 1;
		_payload[$ "seq"] = _frame_seq;
		array_push(_regs, _payload);
		return _frame_seq;
	};
	
	/// @ignore
	static __HoverConsiderRect = function(_id, _x1, _y1, _x2, _y2) {
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
		
		if (_mx < _x1 || _mx > _x2 || _my < _y1 || _my > _y2) {
			return false;
		}
		
		// Last drawn wins: we’re called in draw order, so later calls override.
		_hover_id = _id;
		return true;
	};

	/// @ignore
	static __ResolveHoverId = function(_mx, _my) {
		var _best_id = 0;
		var _best_seq = -1;
		var _len = array_length(_regs);
		for (var i = 0; i < _len; i++) {
			var _r = _regs[i];
			if (!is_struct(_r)) continue;

			if (!__RegPointInHoverRect(_r, _mx, _my)) continue;
			var _tb = __GetBoxById(_r[$ "id"] ?? 0);
			if (!is_struct(_tb) || _tb.enabled != true) continue;

			var _seq = _r[$ "seq"] ?? -1;
			if (_seq >= _best_seq) {
				_best_seq = _seq;
				_best_id = _r[$ "id"] ?? 0;
			}
		}
		_hover_id = _best_id;
		return _best_id;
	};

	/// @ignore
	static __RegPointInRect = function(_x1, _y1, _x2, _y2, _mx, _my) {
		return (_mx >= _x1 && _mx <= _x2 && _my >= _y1 && _my <= _y2);
	};

	/// @ignore
	static __FindRegTopmostById = function(_id) {
		var _best = undefined;
		var _best_seq = -1;
		var _len = array_length(_regs);
		for (var i = 0; i < _len; i++) {
			var _r = _regs[i];
			if (!is_struct(_r)) continue;
			if ((_r[$ "id"] ?? 0) != _id) continue;
			var _seq = _r[$ "seq"] ?? -1;
			if (_seq >= _best_seq) {
				_best_seq = _seq;
				_best = _r;
			}
		}
		return _best;
	};

	/// @ignore
	static __RegPointInTextboxRect = function(_reg, _mx, _my) {
		if (!is_struct(_reg)) {
			return false;
		}

		var _x1 = _reg[$ "tbx1"] ?? _reg[$ "x1"];
		var _y1 = _reg[$ "tby1"] ?? _reg[$ "y1"];
		var _x2 = _reg[$ "tbx2"] ?? _reg[$ "x2"];
		var _y2 = _reg[$ "tby2"] ?? _reg[$ "y2"];
		if (!is_real(_x1) || !is_real(_y1) || !is_real(_x2) || !is_real(_y2)) {
			return false;
		}

		return __RegPointInRect(_x1, _y1, _x2, _y2, _mx, _my);
	};

	/// @ignore
	static __RegPointInHoverRect = function(_reg, _mx, _my) {
		if (!is_struct(_reg)) {
			return false;
		}

		if (__RegPointInTextboxRect(_reg, _mx, _my)) {
			return true;
		}

		var _lbx1 = _reg[$ "lbx1"];
		var _lby1 = _reg[$ "lby1"];
		var _lbx2 = _reg[$ "lbx2"];
		var _lby2 = _reg[$ "lby2"];
		if (is_real(_lbx1) && is_real(_lby1) && is_real(_lbx2) && is_real(_lby2)) {
			return __RegPointInRect(_lbx1, _lby1, _lbx2, _lby2, _mx, _my);
		}

		var _x1 = _reg[$ "x1"];
		var _y1 = _reg[$ "y1"];
		var _x2 = _reg[$ "x2"];
		var _y2 = _reg[$ "y2"];
		if (!is_real(_x1) || !is_real(_y1) || !is_real(_x2) || !is_real(_y2)) {
			return false;
		}

		return __RegPointInRect(_x1, _y1, _x2, _y2, _mx, _my);
	};

	/// @ignore
	static __TextFromConfigMasked = function(_text, _config) {
		if (is_struct(_config) && _config[$ "password_mask"] == true) {
			var _ch = string(_config[$ "password_mask_char"] ?? "*");
			if (string_length(_ch) <= 0) _ch = "*";
			_ch = string_char_at(_ch, 1);
			return string_repeat(_ch, string_length(string(_text)));
		}
		return string(_text);
	};

	/// @ignore
	static __TextGetVisualTabToken = function(_config) {
		var _count = is_struct(_config) ? (_config[$ "tab_spaces"] ?? 4) : 4;
		_count = max(1, floor(_count));
		return string_repeat(" ", _count);
	};

	/// @ignore
	static __TextExpandTabsForVisual = function(_text, _config) {
		var _s = string(_text);
		if (string_pos("\t", _s) <= 0) {
			return _s;
		}
		return string_replace_all(_s, "\t", __TextGetVisualTabToken(_config));
	};

	/// @ignore
	static __TextMeasureVisualWidth = function(_text, _font, _config) {
		var _s = string(_text);
		if (string_length(_s) <= 0) {
			return 0;
		}
		var _tab_token = __TextGetVisualTabToken(_config);
		var _tab_w = 0;
		var _old_font = draw_get_font();
		draw_set_font(_font);
		if (string_pos("\t", _s) > 0) {
			_tab_w = string_width(_tab_token);
		}
		var _w = 0;
		var _n = string_length(_s);
		for (var i = 1; i <= _n; i++) {
			var _ch = string_char_at(_s, i);
			if (_ch == "\t") {
				_w += _tab_w;
			}
			else {
				_w += string_width(_ch);
			}
		}
		draw_set_font(_old_font);
		return _w;
	};

	/// @ignore
	static __TextGetAlignMode = function(_config) {
		var _align = is_struct(_config) ? (_config[$ "text_align"] ?? eQuillTextAlign.Left) : eQuillTextAlign.Left;
		if (_align == eQuillTextAlign.Center) {
			return eQuillTextAlign.Center;
		}
		if (_align == eQuillTextAlign.Right) {
			return eQuillTextAlign.Right;
		}
		return eQuillTextAlign.Left;
	};

	/// @ignore
	static __TextGetAlignOffset = function(_line_text, _font, _view_w, _config) {
		var _avail = max(0, _view_w);
		if (_avail <= 0) {
			return 0;
		}
		var _align = __TextGetAlignMode(_config);
		if (_align == eQuillTextAlign.Left) {
			return 0;
		}
		var _line_w = __TextMeasureVisualWidth(_line_text, _font, _config);
		var _space = max(0, _avail - _line_w);
		if (_align == eQuillTextAlign.Center) {
			return floor(_space * 0.5);
		}
		return _space;
	};

	/// @ignore
	static __IndexFromRegPoint = function(_tb, _reg, _mx, _my) {
		if (!is_struct(_tb) || !is_struct(_reg)) {
			return 0;
		}

		var _cfg = _tb.config;
		var _font = _reg[$ "font"];
		var _multiline = (_reg[$ "multiline"] == true);
		var _tx1 = _reg[$ "tx1"];
		var _ty1 = _reg[$ "ty1"];

		if (!_multiline) {
			var _src = __TextFromConfigMasked(_tb.GetValue(), _cfg);
			var _view_w = max(0, (_reg[$ "tx2"] ?? _tx1) - _tx1);
			var _offset = __TextGetAlignOffset(_src, _font, _view_w, _cfg);
			var _scroll_x = __TextInputGetScrollX(_tb);
			var _local_x = (_mx - _tx1) - _offset + _scroll_x;
			return __TextInputIndexFromX(_src, _font, _local_x, _cfg);
		}

		var _layout = __GetActiveLayoutForTb(_tb, _cfg);
		if (!is_struct(_layout)) {
			return 0;
		}

		var _scroll_y = __TextAreaGetScrollY(_cfg);
		var _scroll_x = __TextAreaGetScrollX(_tb, _cfg);
		var _local_x2 = (_mx - _tx1) + _scroll_x;
		var _local_y2 = (_my - _ty1) + _scroll_y;
		return __TextAreaIndexFromPoint(_layout, _font, _local_x2, _local_y2, _cfg);
	};

	/// @ignore
	static __PostDraw = function() {
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
		var _mouse_l_down = mouse_check_button(mb_left);
		var _mouse_l_pressed = mouse_check_button_pressed(mb_left);
		var _mouse_r_pressed = mouse_check_button_pressed(mb_right);
		var _wheel_delta = mouse_wheel_up() - mouse_wheel_down();
		var _shift = keyboard_check(vk_shift);

		// Scrollbar drag capture.
		if (_scroll_capture_id > 0) {
			var _tb_sc = __GetBoxById(_scroll_capture_id);
			var _reg_sc = __FindRegTopmostById(_scroll_capture_id);
			if (!is_struct(_tb_sc) || !is_struct(_reg_sc) || !is_struct(_tb_sc.config) || _tb_sc.config[$ "multiline"] != true) {
				_scroll_capture_id = 0;
			}
			else if (!_mouse_l_down) {
				var _st = _tb_sc.config[$ "scroll_state"];
				if (is_struct(_st)) {
					_st.dragging = false;
					_st.drag_axis = "";
					_st.drag_offset_x = 0;
					_st.drag_offset_y = 0;
				}
				_scroll_capture_id = 0;
			}
			else {
				var _st2 = _tb_sc.config[$ "scroll_state"];
				var _layout_sc = __GetActiveLayoutForTb(_tb_sc, _tb_sc.config);
				if (is_struct(_st2) && is_struct(_layout_sc)) {
					var _axis = string(_st2.drag_axis ?? "v");
					if (_axis == "h" && is_struct(_tb_sc.last_scroll_h_track_rect) && is_struct(_tb_sc.last_scroll_h_thumb_rect)) {
						var _track_hz = _tb_sc.last_scroll_h_track_rect;
						var _thumb_hz = _tb_sc.last_scroll_h_thumb_rect;
						var _track_w = max(0, _track_hz.x2 - _track_hz.x1);
						var _thumb_w = max(1, _thumb_hz.x2 - _thumb_hz.x1);
						var _travel_x = max(1, _track_w - _thumb_w);
						var _view_w = max(0, _tb_sc.config[$ "view_w"] ?? 0);
						var _max_scroll_x = max(0, (_layout_sc.content_w ?? 0) - _view_w);

						var _off_x = _st2.drag_offset_x ?? 0;
						var _x = clamp((_mx - _track_hz.x1) - _off_x, 0, _travel_x);
						var _t_x = _x / _travel_x;
						var _next_x = _t_x * _max_scroll_x;
						_next_x = __ClampScrollX(_next_x, (_layout_sc.content_w ?? 0), _view_w);
						__TextAreaSetScrollX(_tb_sc, _tb_sc.config, _next_x);
					}
					else if (is_struct(_tb_sc.last_scroll_track_rect) && is_struct(_tb_sc.last_scroll_thumb_rect)) {
						var _track = _tb_sc.last_scroll_track_rect;
						var _thumb = _tb_sc.last_scroll_thumb_rect;
						var _track_h = max(0, _track.y2 - _track.y1);
						var _thumb_h = max(1, _thumb.y2 - _thumb.y1);
						var _travel = max(1, _track_h - _thumb_h);
						var _view_h = max(0, _tb_sc.config[$ "view_h"] ?? 0);
						var _max_scroll = max(0, _layout_sc.content_h - _view_h);

						var _off = _st2.drag_offset_y ?? 0;
						var _y = clamp((_my - _track.y1) - _off, 0, _travel);
						var _t = _y / _travel;
						var _next = _t * _max_scroll;
						_next = __ClampScroll(_next, _layout_sc.content_h, _view_h);
						__TextAreaSetScrollY(_tb_sc.config, _next);
					}
				}
			}
			__ClearFrameRegs();
			return;
		}

		// Resize grip drag capture.
		if (_resize_capture_id > 0) {
			var _tb_rs = __GetBoxById(_resize_capture_id);
			if (!is_struct(_tb_rs) || !_mouse_l_down) {
				if (is_struct(_tb_rs)) {
					_tb_rs.__resize_dragging = false;
				}
				_resize_capture_id = 0;
			}
			else {
				var _dx = _mx - _tb_rs.__resize_start_mx;
				var _dy = _my - _tb_rs.__resize_start_my;
				var _next_w = _tb_rs.__resize_start_w + _dx;
				_next_w = max(1, _next_w);
				var _next_h = _tb_rs.__resize_start_h + _dy;
				_next_h = max(_tb_rs.min_height, _next_h);
				if (_tb_rs.max_height > 0) {
					_next_h = min(_next_h, _tb_rs.max_height);
				}
				_tb_rs.preferred_width = _next_w;
				_tb_rs.preferred_height = _next_h;
				_tb_rs.__InvalidateMeasuredSize();
			}
			__ClearFrameRegs();
			return;
		}

		// Context menu gate: close on click-out and block underlying click routing.
		if (_context_menu_open && is_struct(_context_menu_rect)) {
			var _r = _context_menu_rect;
			var _inside2 = (_mx >= _r.x1 && _mx <= _r.x2 && _my >= _r.y1 && _my <= _r.y2);
			if ((_mouse_l_pressed || _mouse_r_pressed) && !_inside2) {
				CloseContextMenu();
			}
			else if (_inside2 && (_mouse_l_pressed || _mouse_r_pressed)) {
				__ClearFrameRegs();
				return;
			}
		}

		// Modal overlay editor gate: clicks should not fall through.
		if (_editor_open) {
			var _owner = __GetBoxById(_editor_owner_id);
			var _editor_hit_rect = is_struct(_editor_outer_rect) ? _editor_outer_rect : _editor_rect;
			if (is_struct(_owner) && is_struct(_editor_hit_rect)) {
				var _inside = (_mx >= _editor_hit_rect.x1 && _mx <= _editor_hit_rect.x2 && _my >= _editor_hit_rect.y1 && _my <= _editor_hit_rect.y2);
				if (!_inside && _mouse_l_pressed) {
					__OverlayEditorDone(true);
					__ClearFrameRegs();
					return;
				}
			}
		}

		// Resolve hover from this frame's registrations.
		var _hover = __ResolveHoverId(_mx, _my);

		// Start scrollbar drag capture (topmost hovered).
		if (_mouse_l_pressed && _hover > 0) {
			var _tb_hd = __GetBoxById(_hover);
			if (is_struct(_tb_hd) && is_struct(_tb_hd.config) && _tb_hd.config[$ "multiline"] == true) {
				var _st3 = _tb_hd.config[$ "scroll_state"];
				if (is_struct(_st3) && is_struct(_tb_hd.last_scroll_thumb_rect) && is_struct(_tb_hd.last_scroll_track_rect)) {
					var _th = _tb_hd.last_scroll_thumb_rect, _th_padd = _tb_hd.scrollbar_padding;
					var _in_thumb = (_mx >= _th.x1 - _th_padd && _mx <= _th.x2 + _th_padd && _my >= _th.y1 - _th_padd && _my <= _th.y2 + _th_padd);
					if (_in_thumb) {
						_st3.dragging = true;
						_st3.drag_axis = "v";
						_st3.drag_offset_x = 0;
						_st3.drag_offset_y = _my - _th.y1;
						_scroll_capture_id = _tb_hd.id;
						__ClearFrameRegs();
						return;
					}
				}
				if (is_struct(_st3) && is_struct(_tb_hd.last_scroll_h_thumb_rect) && is_struct(_tb_hd.last_scroll_h_track_rect)) {
					var _th_h = _tb_hd.last_scroll_h_thumb_rect, _th_padd = _tb_hd.scrollbar_padding;;
					var _in_thumb_h = (_mx >= _th_h.x1 - _th_padd && _mx <= _th_h.x2 + _th_padd && _my >= _th_h.y1 - _th_padd && _my <= _th_h.y2 + _th_padd);
					if (_in_thumb_h) {
						_st3.dragging = true;
						_st3.drag_axis = "h";
						_st3.drag_offset_x = _mx - _th_h.x1;
						_st3.drag_offset_y = 0;
						_scroll_capture_id = _tb_hd.id;
						__ClearFrameRegs();
						return;
					}
				}

				if (_tb_hd.resizable == true && _tb_hd.show_resize_grip == true && is_struct(_tb_hd.last_resize_grip_rect)) {
					var _gr = _tb_hd.last_resize_grip_rect;
					var _in_grip = (_mx >= _gr.x1 && _mx <= _gr.x2 && _my >= _gr.y1 && _my <= _gr.y2);
					if (_in_grip) {
						_tb_hd.__resize_dragging = true;
						_tb_hd.__resize_start_mx = _mx;
						_tb_hd.__resize_start_my = _my;
						var _w0 = _tb_hd.preferred_width;
						if (!is_real(_w0) || _w0 <= 0) {
							if (is_struct(_tb_hd.last_rect)) {
								_w0 = _tb_hd.last_rect.x2 - _tb_hd.last_rect.x1;
							}
							else {
								_w0 = 1;
							}
						}
						var _h0 = _tb_hd.preferred_height;
						if (!is_real(_h0) || _h0 <= 0) {
							if (is_struct(_tb_hd.last_rect)) {
								_h0 = _tb_hd.last_rect.y2 - _tb_hd.last_rect.y1;
							}
							else {
								_h0 = 0;
							}
						}
						_tb_hd.__resize_start_w = _w0;
						_tb_hd.__resize_start_h = _h0;
						_resize_capture_id = _tb_hd.id;
						__ClearFrameRegs();
						return;
					}
				}
			}
		}

		// Wheel scroll (hovered multiline).
		if (_wheel_delta != 0 && _hover > 0) {
			var _tbw = __GetBoxById(_hover);
			if (is_struct(_tbw)) {
				var _cfgw = _tbw.config;
				if (is_struct(_cfgw) && _cfgw[$ "multiline"] == true) {
					var _old = draw_get_font();
					var _st_w = __GetResolvedStyleCachedForTb(_tbw);
					var _fontw = __ResolveTextboxFont(_tbw, _cfgw, _st_w, _old);
					draw_set_font(_fontw);
					var _line_h = string_height("Ag");
					draw_set_font(_old);

					var _layoutw = __GetActiveLayoutForTb(_tbw, _cfgw);
					if (is_struct(_layoutw)) {
						var _step = max(8, floor(_line_h * 1.5));
						__TextAreaApplyWheelScroll(_tbw, _cfgw, _layoutw, _wheel_delta, _shift, _step);
					}
				}
			}
		}

		// If capturing, update selection until release.
		if (_mouse_capture_id > 0) {
			var _cap_tb = __GetBoxById(_mouse_capture_id);
			var _cap_reg = __FindRegTopmostById(_mouse_capture_id);
			if (!is_struct(_cap_tb) || !is_struct(_cap_reg)) {
				_mouse_capture_id = 0;
			}
			else if (!_mouse_l_down) {
				__TextInputEndMouseSelection(_cap_tb);
				_mouse_capture_id = 0;
			}
			else {
				var _idx = __IndexFromRegPoint(_cap_tb, _cap_reg, _mx, _my);
				__TextInputUpdateMouseSelection(_cap_tb, _idx, _cap_tb.config);

				// Optional auto-scroll while selecting (multiline).
				var _cfg2 = _cap_tb.config;
				if (is_struct(_cfg2) && _cfg2[$ "multiline"] == true) {
					var _layout2 = __GetActiveLayoutForTb(_cap_tb, _cfg2);
					if (is_struct(_layout2) && is_struct(_cap_tb.last_text_rect)) {
						var _tr = _cap_tb.last_text_rect;
						var _view_h2 = max(0, _cfg2[$ "view_h"] ?? 0);
						if (_view_h2 > 0) {
							var _scroll_y2 = __TextAreaGetScrollY(_cfg2);
							var _edge = 8;
							var _step = max(4, floor(_layout2.line_h * 0.5));
							if (_my < _tr.y1 + _edge) {
								_scroll_y2 -= _step;
							}
							else if (_my > _tr.y2 - _edge) {
								_scroll_y2 += _step;
							}
							_scroll_y2 = __ClampScroll(_scroll_y2, _layout2.content_h, _view_h2);
							__TextAreaSetScrollY(_cfg2, _scroll_y2);
						}
						var _wrap2 = ((_cfg2[$ "wrap"] ?? true) == true);
						var _view_w2 = max(0, _cfg2[$ "view_w"] ?? 0);
						var _max_scroll_x2 = max(0, (_layout2.content_w ?? 0) - _view_w2);
						if (!_wrap2 && _view_w2 > 0 && _max_scroll_x2 > 0) {
							var _scroll_x2 = __TextAreaGetScrollX(_cap_tb, _cfg2);
							var _edge_x = 8;
							var _step_x = max(4, floor((_layout2.line_h ?? 0) * 0.5));
							if (_mx < _tr.x1 + _edge_x) {
								_scroll_x2 -= _step_x;
							}
							else if (_mx > _tr.x2 - _edge_x) {
								_scroll_x2 += _step_x;
							}
							_scroll_x2 = __ClampScrollX(_scroll_x2, (_layout2.content_w ?? 0), _view_w2);
							__TextAreaSetScrollX(_cap_tb, _cfg2, _scroll_x2);
						}
					}
				}
			}
			__ClearFrameRegs();
			return;
		}

		// Left click sets active and begins selection capture.
		if (_mouse_l_pressed) {
			if (_hover > 0) {
				__SetActive(_hover);
				var _tb = __GetBoxById(_hover);
				var _reg = __FindRegTopmostById(_hover);
				if (is_struct(_tb) && is_struct(_reg)) {
					if (__RegPointInTextboxRect(_reg, _mx, _my)) {
						var _idx2 = __IndexFromRegPoint(_tb, _reg, _mx, _my);

						var _click_count = 1;
						if ((current_time - _tb.last_click_time) <= _double_click_ms && _tb.last_click_id == _tb.id) {
							if (_tb.last_click_index == _idx2) {
								_click_count = max(1, floor(_tb.last_click_count ?? 1)) + 1;
							}
						}
						if (_click_count > 3) {
							_click_count = 1;
						}
						_tb.last_click_time = current_time;
						_tb.last_click_index = _idx2;
						_tb.last_click_id = _tb.id;
						_tb.last_click_count = _click_count;

						__TextInputBeginMouseSelection(_tb, _idx2, _shift, _click_count, _tb.config);
						_mouse_capture_id = _tb.id;
					}
				}
			}
			else {
				__SetActive(0);
			}
		}

		// Right click opens context menu.
		//var _tb = __GetBoxById(_hover);
		if ( _mouse_r_pressed ) {
			if (_hover > 0) {
				__SetActive(_hover);

				var _tb2 = __GetBoxById(_hover);
				var _reg2 = __FindRegTopmostById(_hover);
				if (is_struct(_tb2) && is_struct(_reg2) && __RegPointInTextboxRect(_reg2, _mx, _my)) {
					var _idx3 = __IndexFromRegPoint(_tb2, _reg2, _mx, _my);
					var _has_sel2 = __TextInputHasSelection(_tb2);
					if (!_has_sel2) {
						__TextInputSetCaret(_tb2, _idx3, false, _tb2.config);
					}

					if ( _tb2.context_menu_enabled ) { OpenContextMenu(__BuildContextMenuForTb(_tb2), _mx, _my, _tb2.id); }
				}
			}
			else {
				CloseContextMenu(); 
			}
		}

		__ClearFrameRegs();
	};

	/// @ignore
	static __ClearFrameRegs = function() {
		_regs = [];
		_frame_seq = 0;
	};

	/// @ignore
	static __Step = function() {
		_frame_i += 1;
		if (QUILL_VB_DEBUG) {
			var _elapsed = _frame_i - _vb_dbg_last_log_frame;
			if (_elapsed >= 60) {
				show_debug_message(
				"[Quill VB] frame="
				+ string(_frame_i)
				+ " rebuilds="
				+ string(_vb_dbg_rebuilds)
				+ " submits="
				+ string(_vb_dbg_submits)
				);
				_vb_dbg_rebuilds = 0;
				_vb_dbg_submits = 0;
				_vb_dbg_last_log_frame = _frame_i;
			}
		}
		__PruneDeadBoxes();

		if (_editor_open) {
			var _ed = __GetBoxById(_editor_tb_id);
			if (is_struct(_ed)) {
				__StepKeyboardForTb(_ed, true);
				return;
			}
		}

		if (_active_id <= 0) {
			return;
		}

		var _tb = __GetBoxById(_active_id);
		if (!is_struct(_tb)) {
			return;
		}
		if (_tb.enabled != true) {
			__SetActive(0);
			return;
		}
		__StepKeyboardForTb(_tb, false);
	};

	/// @ignore
	static __StepKeyboardForTb = function(_tb, _is_overlay_editor) {
		var _cfg = _tb.config;
		if (!is_struct(_cfg)) {
			return;
		}

		_tb.__SyncFromBinding();

		var _read_only = (_cfg[$ "read_only"] == true);
		var _ctrl = keyboard_check(vk_control);
		var _shift = keyboard_check(vk_shift);
		var _multiline = (_cfg[$ "multiline"] == true);
		var _menu_open_for_owner = (_context_menu_open && _context_menu_owner_id == _tb.id);

		// Overlay editor global escape.
		if (_is_overlay_editor) {
			if (keyboard_check_pressed(vk_escape) && !_menu_open_for_owner) {
				__OverlayEditorCancel();
				return;
			}
		}
		else {
			if (keyboard_check_pressed(vk_escape) && !_menu_open_for_owner) {
				__EmitCancel(_tb);
				return;
			}
			if (keyboard_check_pressed(vk_tab) && _cfg[$ "tab_inserts"] != true && !_menu_open_for_owner) {
				__FocusMoveTab(_tb.id, _shift ? -1 : 1);
				return;
			}
		}

		if (_menu_open_for_owner) {
			__TextInputPumpLiveChange(_tb, _cfg);
			return;
		}

		if (keyboard_check_pressed(vk_enter) && !_menu_open_for_owner) {
			if (!_multiline) {
				__EmitSubmit(_tb);
				return;
			}
			else if (_ctrl && _tb.multiline_submit_on_ctrl_enter == true) {
				__EmitSubmit(_tb);
				return;
			}
		}

		if (_ctrl) {
			if (keyboard_check_pressed(ord("A"))) {
				__TextInputSelectAll(_tb, _cfg);
				return;
			}
			if (keyboard_check_pressed(ord("C"))) {
				__TextInputCopySelection(_tb, _cfg);
				return;
			}
			if (keyboard_check_pressed(ord("X")) && !_read_only) {
				__TextInputCutSelection(_tb, _cfg);
				return;
			}
			if (keyboard_check_pressed(ord("V")) && !_read_only) {
				__TextInputPasteClipboard(_tb, _cfg);
				return;
			}
			if (keyboard_check_pressed(ord("Z")) && !_read_only && _actionenabled ) {
				if (_shift) {
					__TextInputRedo(_tb, _cfg);
				}
				else {
					__TextInputUndo(_tb, _cfg);
				}
				return;
			}
			if (keyboard_check_pressed(ord("Y")) && !_read_only && _actionenabled ) {
				__TextInputRedo(_tb, _cfg);
				return;
			}
		}

		if (__TextInputKeyRepeat(_tb, vk_left)) {
			if (_ctrl) {
				__TextInputMoveCaretWord(_tb, -1, _shift, _cfg);
			}
			else {
				__TextInputMoveCaret(_tb, -1, _shift, _cfg);
			}
		}
		if (__TextInputKeyRepeat(_tb, vk_right)) {
			if (_ctrl) {
				__TextInputMoveCaretWord(_tb, 1, _shift, _cfg);
			}
			else {
				__TextInputMoveCaret(_tb, 1, _shift, _cfg);
			}
		}

		if (_multiline) {
			if (__TextInputKeyRepeat(_tb, vk_up)) {
				__TextAreaMoveCaretVertical(_tb, -1, _shift, _cfg);
			}
			if (__TextInputKeyRepeat(_tb, vk_down)) {
				__TextAreaMoveCaretVertical(_tb, 1, _shift, _cfg);
			}
		}

		if (keyboard_check_pressed(vk_home)) {
			if (_multiline && !_ctrl) {
				var _layout = __GetActiveLayoutForTb(_tb, _cfg);
				if (is_struct(_layout) && is_array(_layout.lines)) {
					var _li = __TextAreaFindLineAtIndex(_layout, _tb.caret_index);
					var _ln = _layout.lines[_li];
					__TextInputSetCaret(_tb, _ln.start, _shift, _cfg);
					__TextAreaEnsureCaretVisible(_tb, _cfg);
				}
				else {
					__TextInputSetCaret(_tb, 0, _shift, _cfg);
				}
			}
			else {
				__TextInputSetCaret(_tb, 0, _shift, _cfg);
			}
		}
		if (keyboard_check_pressed(vk_end)) {
			if (_multiline && !_ctrl) {
				var _layout2 = __GetActiveLayoutForTb(_tb, _cfg);
				if (is_struct(_layout2) && is_array(_layout2.lines)) {
					var _li2 = __TextAreaFindLineAtIndex(_layout2, _tb.caret_index);
					var _ln2 = _layout2.lines[_li2];
					__TextInputSetCaret(_tb, _ln2.start + _ln2.len, _shift, _cfg);
					__TextAreaEnsureCaretVisible(_tb, _cfg);
				}
				else {
					__TextInputSetCaret(_tb, string_length(_tb.text), _shift, _cfg);
				}
			}
			else {
				__TextInputSetCaret(_tb, string_length(_tb.text), _shift, _cfg);
			}
		}

		if (!_read_only) {
			if (_multiline) {
				if (__TextInputKeyRepeat(_tb, vk_enter)) {
					__TextAreaInsertAutoIndentNewline(_tb, _cfg);
				}
			}

			if (_cfg[$ "tab_inserts"] == true) {
				if (__TextInputKeyRepeat(_tb, vk_tab)) {
					var _mode = _cfg[$ "input_mode"] ?? QUILL_TEXTMODE_TEXT;
					if (_multiline && _mode == QUILL_TEXTMODE_CODE) {
						if (_shift) {
							__TextAreaOutdentSelection(_tb, _cfg);
						}
						else {
							__TextAreaIndentSelection(_tb, _cfg);
						}
					}
					else {
						__TextAreaInsertTabToken(_tb, _cfg);
					}
				}
			}

			if (__TextInputKeyRepeat(_tb, vk_backspace)) {
				if (__TextInputHasSelection(_tb)) {
					__TextInputDeleteSelection(_tb, _cfg);
				}
				else if (_ctrl) {
					__TextInputDeleteWord(_tb, -1, _cfg);
				}
				else {
					__TextInputDeleteChar(_tb, -1, _cfg);
				}
			}
			if (__TextInputKeyRepeat(_tb, vk_delete)) {
				if (__TextInputHasSelection(_tb)) {
					__TextInputDeleteSelection(_tb, _cfg);
				}
				else if (_ctrl) {
					__TextInputDeleteWord(_tb, 1, _cfg);
				}
				else {
					__TextInputDeleteChar(_tb, 1, _cfg);
				}
			}

			var _ch = keyboard_lastchar;
			if (string_length(_ch) > 0 && !_ctrl && !keyboard_check(vk_alt)) {
				var _code = ord(_ch);
				if (_code >= 32) {
					if (_ch != _tb.last_char) {
						_tb.last_char = _ch;
						_tb.last_char_key = keyboard_lastkey;
					}
					var _key = _tb.last_char_key;
					if (_key > 0 && __TextInputKeyRepeat(_tb, _key)) {
						__TextInputInsertText(_tb, _ch, _cfg);
					}
				}
			}
		}

		__TextInputPumpLiveChange(_tb, _cfg);
	};

	/// @ignore
	static __ContextMenuCoerceItem = function(_item) {
		if (is_instanceof(_item, __QuillContextMenuEntry)) {
			return _item;
		}
		if (!is_struct(_item)) {
			return undefined;
		}

		var _is_sep = (_item[$ "is_separator"] ?? false);
		var _key = string(_item[$ "key"] ?? "");
		if (_is_sep) {
			return new __QuillContextMenuSeparator(_key);
		}

		var _label = string(_item[$ "label"] ?? "");
		var _on_click = _item[$ "on_click"];
		var _coerced = new __QuillContextMenuItem(_label, _on_click, _key);
		_coerced.shortcut = string(_item[$ "shortcut"] ?? "");
		_coerced.enabled = ((_item[$ "enabled"] ?? true) == true);
		_coerced.visible = ((_item[$ "visible"] ?? true) == true);
		return _coerced;
	};

	/// @ignore
	static __ContextMenuBuildLookup = function(_key_or_uid) {
		var _has_uid = false;
		var _uid = -1;
		var _has_key = false;
		var _key = "";
		if (is_struct(_key_or_uid)) {
			var _uid_raw = _key_or_uid[$ "__uid"];
			if (is_real(_uid_raw)) {
				_has_uid = true;
				_uid = floor(_uid_raw);
			}
			_key = string(_key_or_uid[$ "key"] ?? "");
			_has_key = (string_length(_key) > 0);
		}
		else if (is_real(_key_or_uid)) {
			_has_uid = true;
			_uid = floor(_key_or_uid);
		}
		else {
			_key = string(_key_or_uid);
			_has_key = (string_length(_key) > 0);
		}
		return {
			has_uid: _has_uid,
			uid: _uid,
			has_key: _has_key,
			key: _key
		};
	};

	/// @ignore
	static __ContextMenuItemMatches = function(_item, _lookup) {
		if (!is_struct(_item)) {
			return false;
		}
		if (!is_struct(_lookup)) {
			return false;
		}

		if (_lookup.has_key) {
			var _item_key = string(_item[$ "key"] ?? "");
			if (_item_key == _lookup.key) {
				return true;
			}
		}
		if (_lookup.has_uid) {
			var _item_uid = _item[$ "__uid"];
			if (is_real(_item_uid) && floor(_item_uid) == _lookup.uid) {
				return true;
			}
		}
		return false;
	};

	/// @ignore
	static __ContextMenuFindItemIndex = function(_items, _key_or_uid) {
		if (!is_array(_items)) {
			return -1;
		}
		var _lookup = __ContextMenuBuildLookup(_key_or_uid);
		if (!_lookup.has_key && !_lookup.has_uid) {
			return -1;
		}
		var _n = array_length(_items);
		for (var i = 0; i < _n; i++) {
			if (__ContextMenuItemMatches(_items[i], _lookup)) {
				return i;
			}
		}
		return -1;
	};

	/// @ignore
	static __ContextMenuCollectionAdd = function(_items, _item) {
		var _out_items = is_array(_items) ? _items : [];
		var _coerced = __ContextMenuCoerceItem(_item);
		if (!is_struct(_coerced)) {
			return { items: _out_items, item: undefined };
		}

		var _idx = -1;
		var _key = string(_coerced[$ "key"] ?? "");
		if (string_length(_key) > 0) {
			_idx = __ContextMenuFindItemIndex(_out_items, _key);
		}
		else {
			_idx = __ContextMenuFindItemIndex(_out_items, _coerced);
		}

		if (_idx >= 0) {
			_out_items[_idx] = _coerced;
		}
		else {
			array_push(_out_items, _coerced);
		}
		return { items: _out_items, item: _coerced };
	};

	/// @ignore
	static __ContextMenuCollectionRemove = function(_items, _key_or_uid) {
		var _out_items = is_array(_items) ? _items : [];
		var _idx = __ContextMenuFindItemIndex(_out_items, _key_or_uid);
		var _removed = false;
		if (_idx >= 0) {
			array_delete(_out_items, _idx, 1);
			_removed = true;
		}
		return { items: _out_items, removed: _removed };
	};

	/// @ignore
	static __ContextMenuCollectionGet = function(_items, _key_or_uid) {
		if (!is_array(_items)) {
			return undefined;
		}
		var _idx = __ContextMenuFindItemIndex(_items, _key_or_uid);
		if (_idx < 0) {
			return undefined;
		}
		return _items[_idx];
	};

	/// @ignore
	static __ContextMenuSnapshotItem = function(_item) {
		if (!is_struct(_item)) {
			return undefined;
		}

		var _visible = ((_item[$ "visible"] ?? true) == true);
		if (!_visible) {
			return undefined;
		}

		var _sep = ((_item[$ "is_separator"] ?? false) == true);
		if (_sep) {
			return {
				__uid: _item[$ "__uid"] ?? undefined,
				key: string(_item[$ "key"] ?? ""),
				is_separator: true
			};
		}

		return {
			__uid: _item[$ "__uid"] ?? undefined,
			key: string(_item[$ "key"] ?? ""),
			is_separator: false,
			label: string(_item[$ "label"] ?? ""),
			shortcut: string(_item[$ "shortcut"] ?? ""),
			enabled: ((_item[$ "enabled"] ?? true) == true),
			on_click: _item[$ "on_click"]
		};
	};

	/// @ignore
	static __ContextMenuAppendCollection = function(_items, _collection) {
		var _out_items = is_array(_items) ? _items : [];
		if (!is_array(_collection)) {
			return _out_items;
		}
		var _n = array_length(_collection);
		for (var i = 0; i < _n; i++) {
			var _snap = __ContextMenuSnapshotItem(_collection[i]);
			if (is_struct(_snap)) {
				array_push(_out_items, _snap);
			}
		}
		return _out_items;
	};

	/// @ignore
	static __ContextMenuNormalizeItems = function(_items) {
		var _out = [];
		if (!is_array(_items)) {
			return _out;
		}

		var _prev_sep = true;
		var _n = array_length(_items);
		for (var i = 0; i < _n; i++) {
			var _it = _items[i];
			if (!is_struct(_it)) {
				continue;
			}

			var _sep = ((_it[$ "is_separator"] ?? false) == true);
			if (_sep) {
				if (_prev_sep) {
					continue;
				}
				array_push(_out, { is_separator: true });
				_prev_sep = true;
			}
			else {
				array_push(_out, _it);
				_prev_sep = false;
			}
		}

		var _out_n = array_length(_out);
		if (_out_n > 0 && ((_out[_out_n - 1][$ "is_separator"] ?? false) == true)) {
			array_delete(_out, _out_n - 1, 1);
		}
		return _out;
	};

	/// @ignore
	static __ContextMenuFindFirstSelectable = function() {
		for (var _i = 0; _i < _context_menu_item_count; _i++) {
			var _it = _context_menu_items[_i];
			if (!is_struct(_it)) continue;
			if ((_it[$ "is_separator"] ?? false)) continue;
			var _en = (_it[$ "enabled"] ?? true);
			if (_en == true) return _i;
		}
		return -1;
	};

	/// @ignore
	static __ContextMenuMoveKeySelection = function(_dir) {
		if (_context_menu_item_count <= 0) return;

		var _i = _context_menu_key_i;
		if (_i < 0) _i = __ContextMenuFindFirstSelectable();
		if (_i < 0) return;

		for (var _step = 0; _step < _context_menu_item_count; _step++) {
			_i += _dir;
			if (_i < 0) _i = _context_menu_item_count - 1;
			if (_i >= _context_menu_item_count) _i = 0;

			var _it = _context_menu_items[_i];
			if (!is_struct(_it)) continue;
			if ((_it[$ "is_separator"] ?? false)) continue;
			var _en = (_it[$ "enabled"] ?? true);
			if (_en != true) continue;

			_context_menu_key_i = _i;
			return;
		}
	};

	/// @ignore
	static __ContextMenuGetItemHeight = function(_it) {
		if (is_struct(_it) && (_it[$ "is_separator"] ?? false)) {
			return max(_context_menu_sep_min_h, floor(_context_menu_row_h * 0.5));
		}
		return _context_menu_row_h;
	};

	/// @ignore
	static __ContextMenuRecalcRect = function() {
		var _owner = __GetBoxById(_context_menu_owner_id);
		var _st = __BuildResolvedStyleForTb(_owner);
		var _t_menu = _st.menu;
		var _pad = _context_menu_pad;
		var _row_h = _context_menu_row_h;
		var _old_font = draw_get_font();
		var _menu_font = _st.fonts.menu;
		if (is_real(_menu_font) && _menu_font >= 0 && font_exists(_menu_font)) {
			draw_set_font(_menu_font);
		}

		var _max_w = 0;
		var _total_h = 0;

		for (var _i = 0; _i < _context_menu_item_count; _i++) {
			var _it = _context_menu_items[_i];
			if (!is_struct(_it)) continue;

			var _h = __ContextMenuGetItemHeight(_it);
			_total_h += _h;

			if (_it[$ "is_separator"] ?? false) {
				continue;
			}

			var _label = string(_it[$ "label"] ?? "");
			var _shortcut = string(_it[$ "shortcut"] ?? "");
			var _shortcut_gap = max(0, floor(_t_menu.shortcut_gap));

			var _w = string_width(_label);
			if (string_length(_shortcut) > 0) {
				_w += _shortcut_gap + string_width(_shortcut);
			}
			if (_w > _max_w) _max_w = _w;
		}
		draw_set_font(_old_font);

		var _min_w = max(1, floor(_t_menu.min_w));
		var _max_w_cap = max(_min_w, floor(_t_menu.max_w));

		var _menu_border_in = __QuillRenderGetBorderSpriteInsideInsets(_t_menu.border_spr, _t_menu.border_spr_outside_draw);
		var _w_final = clamp(_max_w + _pad * 2 + _menu_border_in.left + _menu_border_in.right, _min_w, _max_w_cap);
		var _h_final = _total_h + _pad * 2 + _menu_border_in.top + _menu_border_in.bottom;
		var _menu_border_out = __QuillRenderGetBorderSpriteOutsideInsets(_t_menu.border_spr, _t_menu.border_spr_outside_draw);
		var _w_outer = _w_final + _menu_border_out.left + _menu_border_out.right;
		var _h_outer = _h_final + _menu_border_out.top + _menu_border_out.bottom;

		_context_menu_w = _w_final;
		_context_menu_h = _h_final;

		var _gw = display_get_gui_width();
		var _gh = display_get_gui_height();
		var _margin = max(0, floor(_t_menu.viewport_margin));

		var _inner_x1 = _context_menu_x;
		var _inner_y1 = _context_menu_y;
		var _x1 = _inner_x1 - _menu_border_out.left;
		var _y1 = _inner_y1 - _menu_border_out.top;

		if (_x1 + _w_outer > _gw - _margin) {
			_x1 = max(_margin, _gw - _margin - _w_outer);
		}
		if (_y1 + _h_outer > _gh - _margin) {
			_y1 = max(_margin, _gh - _margin - _h_outer);
		}
		if (_x1 < _margin) {
			_x1 = _margin;
		}
		if (_y1 < _margin) {
			_y1 = _margin;
		}

		_inner_x1 = _x1 + _menu_border_out.left;
		_inner_y1 = _y1 + _menu_border_out.top;

		_context_menu_x = _inner_x1;
		_context_menu_y = _inner_y1;
		_context_menu_rect = { x1: _x1, y1: _y1, x2: _x1 + _w_outer, y2: _y1 + _h_outer };
		_context_menu_inner_rect = {
			x1: _inner_x1,
			y1: _inner_y1,
			x2: _inner_x1 + _w_final,
			y2: _inner_y1 + _h_final
		};
	};

	/// @ignore
	static __ContextMenuDrawOverlay = function() {
		if (!_context_menu_open) {
			return;
		}

		if (keyboard_check_pressed(vk_escape)) {
			CloseContextMenu();
			return;
		}

		if (!is_struct(_context_menu_rect)) {
			__ContextMenuRecalcRect();
			if (!is_struct(_context_menu_rect)) return;
		}

		var _owner = __GetBoxById(_context_menu_owner_id);
		var _st = __BuildResolvedStyleForTb(_owner);
		var _t_menu = _st.menu;

		var _r = is_struct(_context_menu_inner_rect) ? _context_menu_inner_rect : _context_menu_rect;
		var _x1 = _r.x1;
		var _y1 = _r.y1;
		var _x2 = _r.x2;
		var _y2 = _r.y2;

		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
		var _mouse_l_pressed = mouse_check_button_pressed(mb_left);
		var _mouse_r_pressed = mouse_check_button_pressed(mb_right);

		var _outer_r = _context_menu_rect;
		var _outside_x1 = _x1;
		var _outside_y1 = _y1;
		var _outside_x2 = _x2;
		var _outside_y2 = _y2;
		if (is_struct(_outer_r)) {
			_outside_x1 = _outer_r.x1;
			_outside_y1 = _outer_r.y1;
			_outside_x2 = _outer_r.x2;
			_outside_y2 = _outer_r.y2;
		}
		var _inside = (_mx >= _outside_x1 && _mx <= _outside_x2 && _my >= _outside_y1 && _my <= _outside_y2);

		// Close on click-out.
		if ((_mouse_l_pressed || _mouse_r_pressed) && !_inside) {
			CloseContextMenu();
			return;
		}

		// Keyboard navigation
		if (keyboard_check_pressed(vk_down)) __ContextMenuMoveKeySelection(1);
		if (keyboard_check_pressed(vk_up)) __ContextMenuMoveKeySelection(-1);

		var _old_font = draw_get_font();
		var _menu_font = _st.fonts.menu;
		if ( font_exists(_menu_font) ) {
			draw_set_font(_menu_font);
		}

		var _old_alpha = draw_get_alpha();
		var _panel_w = max(0, _x2 - _x1);
		var _panel_h = max(0, _y2 - _y1);
		var _menu_border_in = __QuillRenderGetBorderSpriteInsideInsets(_t_menu.border_spr, _t_menu.border_spr_outside_draw);
		var _menu_border_out = __QuillRenderGetBorderSpriteOutsideInsets(_t_menu.border_spr, _t_menu.border_spr_outside_draw);
		var _panel_outer_x1 = _x1 - _menu_border_out.left;
		var _panel_outer_y1 = _y1 - _menu_border_out.top;
		var _panel_outer_x2 = _x2 + _menu_border_out.right;
		var _panel_outer_y2 = _y2 + _menu_border_out.bottom;
		var _panel_outer_w = max(0, _panel_outer_x2 - _panel_outer_x1);
		var _panel_outer_h = max(0, _panel_outer_y2 - _panel_outer_y1);
		var _owner_cache = __GetBoxCacheById(_context_menu_owner_id);
		var _need_panel_bg_prim = !__QuillRenderDrawSpriteSkin(_t_menu.bg_spr, _t_menu.bg_subimg, _x1, _y1, _panel_w, _panel_h, _t_menu.prim_bg_col, _t_menu.prim_bg_a);
		var _need_panel_bd_prim = !__QuillRenderDrawSpriteSkin(_t_menu.border_spr, _t_menu.border_subimg, _panel_outer_x1, _panel_outer_y1, _panel_outer_w, _panel_outer_h, _t_menu.prim_border_col, _t_menu.prim_border_a);
		var _panel_vb = -1;
		if (QUILL_VB_ENABLE && is_struct(_owner_cache)) {
			var _panel_sig = {
				w: _panel_w,
				h: _panel_h,
				state_key: "menu_panel",
				need_bg: _need_panel_bg_prim,
				need_border: _need_panel_bd_prim,
				bg_col: _t_menu.prim_bg_col,
				bg_a: _t_menu.prim_bg_a,
				border_col: _t_menu.prim_border_col,
				border_a: _t_menu.prim_border_a,
				border_thickness: 1
			};
			_panel_vb = __QuillVbEnsureBox(_owner_cache, _panel_sig);
		}
		if (_panel_vb >= 0) {
			draw_set_alpha(_old_alpha);
			__QuillVbSubmitTranslated(_panel_vb, _x1, _y1, "menu_panel");
		}
		else {
			if (_need_panel_bg_prim) {
				draw_set_alpha(_old_alpha * _t_menu.prim_bg_a);
				draw_set_color(_t_menu.prim_bg_col);
				draw_rectangle(_x1, _y1, _x2, _y2, false);
			}
			if (_need_panel_bd_prim) {
				draw_set_alpha(_old_alpha * _t_menu.prim_border_a);
				draw_set_color(_t_menu.prim_border_col);
				__QuillRenderDrawBorderPrimitive(_panel_outer_x1 - _t_menu.prim_padd, _panel_outer_y1 - _t_menu.prim_padd, _panel_outer_x2 + _t_menu.prim_padd, _panel_outer_y2 + _t_menu.prim_padd, _t_menu.prim_padd);
			}
		}
		draw_set_alpha(_old_alpha);

		var _pad = _context_menu_pad;
		var _content_x1 = _x1 + _menu_border_in.left;
		var _content_y1 = _y1 + _menu_border_in.top;
		var _content_x2 = _x2 - _menu_border_in.right;
		var _content_y2 = _y2 - _menu_border_in.bottom;
		if (_content_x2 < _content_x1) _content_x2 = _content_x1;
		if (_content_y2 < _content_y1) _content_y2 = _content_y1;
		var _cy = _content_y1 + _pad;

		_context_menu_hover_i = -1;

		for (var _i = 0; _i < _context_menu_item_count; _i++) {
			var _it = _context_menu_items[_i];
			if (!is_struct(_it)) continue;

			var _h = __ContextMenuGetItemHeight(_it);
			var _row_y1 = _cy;
			var _row_y2 = _cy + _h;

			var _sep = (_it[$ "is_separator"] ?? false);
			if (_sep) {
				var _ly = floor((_row_y1 + _row_y2) * 0.5);
				var _sep_h = max(1, floor(_t_menu.sep_h));
				var _sep_x1 = _content_x1 + _pad;
				var _sep_x2 = _content_x2 - _pad;
				var _sep_w = max(0, _sep_x2 - _sep_x1);
				var _sep_vb = -1;
				if (QUILL_VB_ENABLE && is_struct(_owner_cache)) {
					var _sep_sig = {
						w: _sep_w,
						h: _sep_h,
						state_key: "menu_sep",
						need_bg: true,
						need_border: false,
						bg_col: _t_menu.sep_col,
						bg_a: _t_menu.sep_a,
						border_col: c_black,
						border_a: 0,
						border_thickness: 0
					};
					_sep_vb = __QuillVbEnsureBox(_owner_cache, _sep_sig);
				}
				if (_sep_vb >= 0) {
					draw_set_alpha(_old_alpha);
					__QuillVbSubmitTranslated(_sep_vb, _sep_x1, _ly, "menu_sep");
				}
				else {
					draw_set_alpha(_old_alpha * _t_menu.sep_a);
					draw_set_color(_t_menu.sep_col);
					draw_rectangle(_sep_x1, _ly, _sep_x2, _ly + _sep_h, false);
				}
				draw_set_alpha(_old_alpha);
				_cy = _row_y2;
				continue;
			}

			var _en = (_it[$ "enabled"] ?? true);
			_en = (_en == true);

			var _row_inside = (_inside && _my >= _row_y1 && _my <= _row_y2);
			if (_row_inside && _en) {
				_context_menu_hover_i = _i;
				_context_menu_key_i = _i;
			}

			var _is_hot = (_i == _context_menu_hover_i) || (_i == _context_menu_key_i);
			if (_is_hot) {
				var _hot_x1 = _content_x1 + 1;
				var _hot_x2 = _content_x2 - 1;
				var _hot_w = max(0, _hot_x2 - _hot_x1);
				var _hot_h = max(0, _row_y2 - _row_y1);
				var _hot_vb = -1;
				if (QUILL_VB_ENABLE && is_struct(_owner_cache)) {
					var _hot_sig = {
						w: _hot_w,
						h: _hot_h,
						state_key: "menu_row_hover",
						need_bg: true,
						need_border: false,
						bg_col: _t_menu.item_hover_col,
						bg_a: _t_menu.item_hover_a,
						border_col: c_black,
						border_a: 0,
						border_thickness: 0
					};
					_hot_vb = __QuillVbEnsureBox(_owner_cache, _hot_sig);
				}
				if (_hot_vb >= 0) {
					draw_set_alpha(_old_alpha);
					__QuillVbSubmitTranslated(_hot_vb, _hot_x1, _row_y1, "menu_row_hover");
				}
				else {
					draw_set_alpha(_old_alpha * _t_menu.item_hover_a);
					draw_set_color(_t_menu.item_hover_col);
					draw_rectangle(_hot_x1, _row_y1, _hot_x2, _row_y2, false);
				}
				draw_set_alpha(_old_alpha);
			}

			var _label = string(_it[$ "label"] ?? "");
			var _shortcut = string(_it[$ "shortcut"] ?? "");

			if (_en) {
				draw_set_color(_t_menu.text_col);
				draw_set_alpha(_old_alpha * _t_menu.text_a);
			}
			else {
				draw_set_color(_t_menu.disabled_text_col);
				draw_set_alpha(_old_alpha * _t_menu.disabled_text_a);
			}

			draw_text(_content_x1 + _pad, _row_y1 + max(0, floor((_h - string_height(_label)) * 0.5)), _label);
			if (string_length(_shortcut) > 0) {
				var _sw = string_width(_shortcut);
				draw_text(_content_x2 - _pad - _sw, _row_y1 + max(0, floor((_h - string_height(_shortcut)) * 0.5)), _shortcut);
			}
			draw_set_alpha(_old_alpha);

			// Click activates.
			if (_mouse_l_pressed && _row_inside) {
				var _on_click = _it[$ "on_click"];
				if (_en && is_callable(_on_click)) {
					_on_click();
					CloseContextMenu();
					draw_set_font(_old_font);
					return;
				}
			}

			_cy = _row_y2;
		}

		// Enter activates keyboard selection
		if (keyboard_check_pressed(vk_enter) && _context_menu_key_i >= 0) {
			var _it2 = _context_menu_items[_context_menu_key_i];
			if (is_struct(_it2)) {
				var _en2 = (_it2[$ "enabled"] ?? true);
				_en2 = (_en2 == true);
				var _on2 = _it2[$ "on_click"];
				if (_en2 && is_callable(_on2)) {
					_on2();
					CloseContextMenu();
				}
			}
		}
		draw_set_font(_old_font);
	};

	/// @ignore
	static __BuildContextMenuForTb = function(_tb) {
		var _items = [];
		if (!is_struct(_tb)) return _items;
		if (_tb.enabled != true) return _items;
		var _cfg = _tb.config;

		var _read_only = is_struct(_cfg) ? (_cfg[$ "read_only"] == true) : false;

		var _can_copy = __TextInputHasSelection(_tb);
		if (_can_copy) {
			var _sel_range = __TextInputGetSelectionRange(_tb);
			_can_copy = (_sel_range._end > _sel_range.start);
		}

		var _can_copy_pwd = true;
		if (is_struct(_cfg) && _cfg[$ "password_mask"] == true && _cfg[$ "password_allow_copy"] != true) {
			_can_copy_pwd = false;
		}

		var _scope = { tb_id: _tb.id };
		var _base = [];
		//array_push(_base, new __QuillContextMenuItem("Cut", method(_scope, __ContextActionCut), "builtin_cut").SetShortcut("Ctrl+X").SetEnabled(!_read_only && _can_copy && _can_copy_pwd));
		//array_push(_base, new __QuillContextMenuItem("Copy", method(_scope, __ContextActionCopy), "builtin_copy").SetShortcut("Ctrl+C").SetEnabled(_can_copy && _can_copy_pwd));
		//array_push(_base, new __QuillContextMenuItem("Paste", method(_scope, __ContextActionPaste), "builtin_paste").SetShortcut("Ctrl+V").SetEnabled(!_read_only));
		//array_push(_base, new __QuillContextMenuSeparator("builtin_sep_core"));
		//array_push(_base, new __QuillContextMenuItem("Select all", method(_scope, __ContextActionSelectAll), "builtin_select_all").SetShortcut("Ctrl+A").SetEnabled(string_length(_tb.GetValue()) > 0));

		if (is_struct(_cfg) && _cfg[$ "multiline"] == true && (_tb.use_overlay_editor == true)) {
			array_push(_base, new __QuillContextMenuSeparator("builtin_sep_editor"));
			array_push(_base, new __QuillContextMenuItem("Edit...", method(_scope, __ContextActionOpenEditor), "builtin_open_editor"));
		}

		_items = __ContextMenuAppendCollection(_items, _base);
		_items = __ContextMenuAppendCollection(_items, _context_menu_global_items);
		_items = __ContextMenuAppendCollection(_items, _tb.context_menu_items);
		_items = __ContextMenuNormalizeItems(_items);
		return _items;
	};

	/// @ignore
	static __ContextActionCut = function() {
		var _tb = global.__QUILL_CORE.__GetBoxById(self.tb_id);
		if (!is_struct(_tb)) return;
		var _cfg = _tb.config;
		global.__QUILL_CORE.__TextInputCutSelection(_tb, _cfg);
	};

	/// @ignore
	static __ContextActionCopy = function() {
		var _tb = global.__QUILL_CORE.__GetBoxById(self.tb_id);
		if (!is_struct(_tb)) return;
		var _cfg = _tb.config;
		global.__QUILL_CORE.__TextInputCopySelection(_tb, _cfg);
	};

	/// @ignore
	static __ContextActionPaste = function() {
		var _tb = global.__QUILL_CORE.__GetBoxById(self.tb_id);
		if (!is_struct(_tb)) return;
		var _cfg = _tb.config;
		global.__QUILL_CORE.__TextInputPasteClipboard(_tb, _cfg);
	};

	/// @ignore
	static __ContextActionSelectAll = function() {
		var _tb = global.__QUILL_CORE.__GetBoxById(self.tb_id);
		if (!is_struct(_tb)) return;
		var _cfg = _tb.config;
		global.__QUILL_CORE.__TextInputSelectAll(_tb, _cfg);
	};

	/// @ignore
	static __ContextActionOpenEditor = function() {
		global.__QUILL_CORE.__OverlayEditorOpen(self.tb_id);
	};

	/// @ignore
	static __OverlayEditorOpen = function(_owner_id) {
		var _tb = __GetBoxById(_owner_id);
		if (!is_struct(_tb)) return;
		var _cfg = _tb.config;
		if (!is_struct(_cfg) || _cfg[$ "multiline"] != true) return;
		if (_tb.use_overlay_editor != true) return;

		_editor_open = true;
		_editor_owner_id = _tb.id;
		_editor_original_text = _tb.GetValue();
		_editor_prev_active_id = _active_id;
		_editor_rect = undefined;
		_editor_outer_rect = undefined;
		_editor_title = string(_tb.overlay_editor_title ?? "Edit text");

		// Create or reset the overlay editor box.
		var _ed = is_struct(_editor_tb_ref) ? _editor_tb_ref : __GetBoxById(_editor_tb_id);
		if (!is_struct(_ed)) {
			_ed = new __Quill(QUILL_MULTI, "", "");
			_ed.use_overlay_editor = false;
			_ed.resizable = false;
			_ed.show_resize_grip = false;
			_editor_tb_id = _ed.id;
			_editor_tb_ref = _ed;
		}
		else {
			_editor_tb_id = _ed.id;
			_editor_tb_ref = _ed;
		}

		_ed.bind_struct = undefined;
		_ed.bind_key = "";
		_ed.on_change = undefined;
		_ed.on_focus = undefined;
		_ed.on_blur = undefined;
		_ed.on_submit = undefined;
		_ed.on_cancel = undefined;
		_ed.tab_enabled = false;
		_ed.tab_order = -1;
		_ed.multiline_submit_on_ctrl_enter = false;
		_ed.enabled = true;
		_ed.transformers = _tb.transformers;
		_ed.auto_trim = (_tb.auto_trim == true);
		_ed.auto_upper = (_tb.auto_upper == true);
		_ed.auto_lower = (_tb.auto_lower == true);
		_ed.placeholder = "";
		_ed.theme = _tb.theme;
		_ed.overrides = _tb.overrides;
		_ed.__style_gen += 1;

		_ed.config[$ "read_only"] = (_cfg[$ "read_only"] == true);
		_ed.config[$ "max_length"] = _cfg[$ "max_length"] ?? 0;
		_ed.config[$ "allow_chars"] = string(_cfg[$ "allow_chars"] ?? "");
		_ed.config[$ "deny_chars"] = string(_cfg[$ "deny_chars"] ?? "");
		_ed.config[$ "numeric_only"] = (_cfg[$ "numeric_only"] == true);
		_ed.config[$ "numeric_allow_decimal"] = (_cfg[$ "numeric_allow_decimal"] == true);
		_ed.config[$ "numeric_allow_negative"] = (_cfg[$ "numeric_allow_negative"] == true);
		_ed.config[$ "filter_fn"] = _cfg[$ "filter_fn"];
		_ed.config[$ "input_mode"] = _cfg[$ "input_mode"] ?? QUILL_TEXTMODE_TEXT;
		_ed.config[$ "tab_inserts"] = (_cfg[$ "tab_inserts"] == true);
		_ed.config[$ "tab_use_spaces"] = (_cfg[$ "tab_use_spaces"] == true);
		_ed.config[$ "tab_spaces"] = _cfg[$ "tab_spaces"] ?? 4;
		_ed.config[$ "auto_indent"] = (_cfg[$ "auto_indent"] == true);
		_ed.config[$ "password_mask"] = (_cfg[$ "password_mask"] == true);
		_ed.config[$ "password_mask_char"] = string(_cfg[$ "password_mask_char"] ?? "*");
		_ed.config[$ "password_allow_copy"] = (_cfg[$ "password_allow_copy"] == true);
		_ed.config[$ "text_align"] = _cfg[$ "text_align"] ?? eQuillTextAlign.Left;
		_ed.config[$ "multiline"] = true;
		_ed.config[$ "wrap"] = (_cfg[$ "wrap"] == true);
		var _f = _cfg[$ "font"];
		if (!is_real(_f) || _f < 0 || !font_exists(_f)) {
			_f = -1;
		}
		_ed.config[$ "font"] = _f;
		
		_ed.config[$ "scroll_state"] = { scroll_x: 0, scroll_y: 0, dragging: false, drag_axis: "", drag_offset_x: 0, drag_offset_y: 0 };

		_ed.text = string(_editor_original_text);
		_ed.caret_index = string_length(_ed.text);
		_ed.selection_anchor = -1;
		_ed.scroll_x = 0;
		_ed.undo_stack = [];
		_ed.redo_stack = [];
		_ed.key_repeat_next = {};
		_ed.last_char = "";
		_ed.last_char_key = 0;
		_ed.live_dirty = false;
		_ed.live_next_at = 0;
		__TextInputBumpGen(_ed);
		__TextInputResetCaretBlink(_ed);

		__SetActive(_ed.id);
	};

	/// @ignore
	static __OverlayEditorCancel = function() {
		if (!_editor_open) return;
		_editor_open = false;
		_editor_owner_id = 0;
		_editor_rect = undefined;
		_editor_outer_rect = undefined;
		__SetActive(_editor_prev_active_id);
	};

	/// @ignore
	static __OverlayEditorDone = function(_commit) {
		if (!_editor_open) return;
		var _owner = __GetBoxById(_editor_owner_id);
		var _ed = __GetBoxById(_editor_tb_id);
		if (is_struct(_owner) && is_struct(_ed) && _commit) {
			_owner.SetValue(_ed.GetValue());
		}
		_editor_open = false;
		_editor_owner_id = 0;
		_editor_rect = undefined;
		_editor_outer_rect = undefined;
		__SetActive(is_struct(_owner) ? _owner.id : _editor_prev_active_id);
	};

	/// @ignore
	static __DrawOverlaysForOwner = function(_owner_id) {
		var _old_halign = draw_get_halign();
		var _old_valign = draw_get_valign();
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);

		if (_editor_open && _editor_owner_id == _owner_id) {
			__OverlayEditorDrawOverlay();
		}
		if (_context_menu_open && _context_menu_owner_id == _owner_id) {
			__ContextMenuDrawOverlay();
		}

		draw_set_halign(_old_halign);
		draw_set_valign(_old_valign);
	};

	/// @ignore
	static __QuillDrawOverlays = function() {
		var _old_halign = draw_get_halign();
		var _old_valign = draw_get_valign();
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);

		if (_editor_open) {
			__OverlayEditorDrawOverlay();
		}
		if (_context_menu_open) {
			__ContextMenuDrawOverlay();
		}

		draw_set_halign(_old_halign);
		draw_set_valign(_old_valign);
	};

	/// @ignore
	static __OverlayEditorDrawOverlay = function() {
		if (!_editor_open) {
			return;
		}

		var _tb_owner = __GetBoxById(_editor_owner_id);
		var _tb = __GetBoxById(_editor_tb_id);
		if (!is_struct(_tb_owner) || !is_struct(_tb)) {
			_editor_open = false;
			_editor_owner_id = 0;
			_editor_rect = undefined;
			_editor_outer_rect = undefined;
			return;
		}

		var _gw = display_get_gui_width();
		var _gh = display_get_gui_height();
		var _st = __BuildResolvedStyleForTb(_tb_owner);
		var _t_editor = _st.editor;

		var _pr = _editor_rect;
		var _ed_border_in = __QuillRenderGetBorderSpriteInsideInsets(_t_editor.panel_border_spr, _t_editor.panel_border_spr_outside_draw);
		var _ed_border_out = __QuillRenderGetBorderSpriteOutsideInsets(_t_editor.panel_border_spr, _t_editor.panel_border_spr_outside_draw);
		if (!is_struct(_pr)) {
			var _margin = max(0, floor(_t_editor.viewport_margin));
			var _outer_max_w = max(0, _gw - (_margin * 2));
			var _outer_max_h = max(0, _gh - (_margin * 2));
			var _pw = min(max(1, floor(_t_editor.max_w)), max(0, _outer_max_w - _ed_border_out.left - _ed_border_out.right));
			var _ph = min(max(1, floor(_t_editor.max_h)), max(0, _outer_max_h - _ed_border_out.top - _ed_border_out.bottom));
			_pw = max(max(1, floor(_t_editor.min_w)), _pw);
			_ph = max(max(1, floor(_t_editor.min_h)), _ph);
			_pw = max(_pw, _ed_border_in.left + _ed_border_in.right + 1);
			_ph = max(_ph, _ed_border_in.top + _ed_border_in.bottom + 1);
			var _ow = _pw + _ed_border_out.left + _ed_border_out.right;
			var _oh = _ph + _ed_border_out.top + _ed_border_out.bottom;
			var _outer_x1 = floor((_gw - _ow) * 0.5);
			var _outer_y1 = floor((_gh - _oh) * 0.5);
			_outer_x1 = clamp(_outer_x1, _margin, max(_margin, _gw - _margin - _ow));
			_outer_y1 = clamp(_outer_y1, _margin, max(_margin, _gh - _margin - _oh));
			var _px1 = _outer_x1 + _ed_border_out.left;
			var _py1 = _outer_y1 + _ed_border_out.top;
			_pr = { x1: _px1, y1: _py1, x2: _px1 + _pw, y2: _py1 + _ph };
			_editor_rect = _pr;
		}

		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
		var _mouse_l_pressed = mouse_check_button_pressed(mb_left);

		// Esc closes (Cancel).
		if (keyboard_check_pressed(vk_escape)) {
			__OverlayEditorCancel();
			return;
		}

		// Dim background.
		var _old_a = draw_get_alpha();
		var _owner_cache = __GetBoxCacheById(_editor_owner_id);
		var _dim_vb = -1;
		if (QUILL_VB_ENABLE && is_struct(_owner_cache)) {
			var _dim_sig = {
				w: _gw,
				h: _gh,
				state_key: "editor_dim",
				need_bg: true,
				need_border: false,
				bg_col: _t_editor.dim_col,
				bg_a: _t_editor.dim_a,
				border_col: c_black,
				border_a: 0,
				border_thickness: 0
			};
			_dim_vb = __QuillVbEnsureBox(_owner_cache, _dim_sig);
		}
		if (_dim_vb >= 0) {
			draw_set_alpha(_old_a);
			__QuillVbSubmitTranslated(_dim_vb, 0, 0, "editor_dim");
		}
		else {
			draw_set_alpha(_old_a * _t_editor.dim_a);
			draw_set_color(_t_editor.dim_col);
			draw_rectangle(0, 0, _gw, _gh, false);
		}
		draw_set_alpha(_old_a);

		var _x1 = _pr.x1;
		var _y1 = _pr.y1;
		var _x2 = _pr.x2;
		var _y2 = _pr.y2;
		var _outer_x1 = _x1 - _ed_border_out.left;
		var _outer_y1 = _y1 - _ed_border_out.top;
		var _outer_x2 = _x2 + _ed_border_out.right;
		var _outer_y2 = _y2 + _ed_border_out.bottom;
		_editor_outer_rect = { x1: _outer_x1, y1: _outer_y1, x2: _outer_x2, y2: _outer_y2 };
		var _panel_inner_x1 = _x1 + _ed_border_in.left;
		var _panel_inner_y1 = _y1 + _ed_border_in.top;
		var _panel_inner_x2 = _x2 - _ed_border_in.right;
		var _panel_inner_y2 = _y2 - _ed_border_in.bottom;
		if (_panel_inner_x2 < _panel_inner_x1) _panel_inner_x2 = _panel_inner_x1;
		if (_panel_inner_y2 < _panel_inner_y1) _panel_inner_y2 = _panel_inner_y1;

		var _w = max(0, _x2 - _x1);
		var _h = max(0, _y2 - _y1);
		var _need_ed_panel_bg = !__QuillRenderDrawSpriteSkin(_t_editor.panel_bg_spr, _t_editor.panel_bg_subimg, _x1, _y1, _w, _h, _t_editor.prim_panel_bg_col, _t_editor.prim_panel_bg_a);
		var _outer_w = max(0, _outer_x2 - _outer_x1);
		var _outer_h = max(0, _outer_y2 - _outer_y1);
		var _need_ed_panel_bd = !__QuillRenderDrawSpriteSkin(_t_editor.panel_border_spr, _t_editor.panel_border_subimg, _outer_x1, _outer_y1, _outer_w, _outer_h, _t_editor.prim_panel_border_col, _t_editor.prim_panel_border_a);
		var _editor_panel_vb = -1;
		if (QUILL_VB_ENABLE && is_struct(_owner_cache)) {
			var _ed_panel_sig = {
				w: _w,
				h: _h,
				state_key: "editor_panel",
				need_bg: _need_ed_panel_bg,
				need_border: _need_ed_panel_bd,
				bg_col: _t_editor.prim_panel_bg_col,
				bg_a: _t_editor.prim_panel_bg_a,
				border_col: _t_editor.prim_panel_border_col,
				border_a: _t_editor.prim_panel_border_a,
				border_thickness: 1
			};
			_editor_panel_vb = __QuillVbEnsureBox(_owner_cache, _ed_panel_sig);
		}
		if (_editor_panel_vb >= 0) {
			draw_set_alpha(_old_a);
			__QuillVbSubmitTranslated(_editor_panel_vb, _x1, _y1, "editor_panel");
		}
		else {
			if (_need_ed_panel_bg) {
				draw_set_alpha(_old_a * _t_editor.prim_panel_bg_a);
				draw_set_color(_t_editor.prim_panel_bg_col);
				draw_rectangle(_x1, _y1, _x2, _y2, false);
			}
			if (_need_ed_panel_bd) {
				draw_set_alpha(_old_a * _t_editor.prim_panel_border_a);
				draw_set_color(_t_editor.prim_panel_border_col);
				__QuillRenderDrawBorderPrimitive(_outer_x1, _outer_y1, _outer_x2, _outer_y2, 1);
			}
		}
		draw_set_alpha(_old_a);

		var _pad_x = max(0, floor(_t_editor.pad_x));
		var _pad_y = max(0, floor(_t_editor.pad_y));
		var _row_h = max(1, floor(_t_editor.btn_h));
		var _btn_h = max(1, floor(_t_editor.btn_h));
		var _btn_w = max(1, floor(_t_editor.btn_w));
		var _gap = max(0, floor(_t_editor.btn_gap));

		var _btn_y2 = _panel_inner_y2 - _pad_y;
		var _btn_y1 = _btn_y2 - _btn_h;
		var _btn_done_x2 = _panel_inner_x2 - _pad_x;
		var _btn_done_x1 = _btn_done_x2 - _btn_w;
		var _btn_cancel_x2 = _btn_done_x1 - _gap;
		var _btn_cancel_x1 = _btn_cancel_x2 - _btn_w;

		var _title_y = _panel_inner_y1 + _pad_y;
		var _editor_y1 = _title_y + _row_h + _gap;
		var _editor_y2 = _btn_y1 - _gap;
		var _editor_x1 = _panel_inner_x1 + _pad_x;
		var _editor_x2 = _panel_inner_x2 - _pad_x;

		// Click outside -> Done (commit).
		var _inside = (_mx >= _outer_x1 && _mx <= _outer_x2 && _my >= _outer_y1 && _my <= _outer_y2);
		if (!_inside && _mouse_l_pressed) {
			__OverlayEditorDone(true);
			return;
		}

		var _old_font = draw_get_font();
		var _title_font = _st.fonts.editor_title;
		if (!(is_real(_title_font) && _title_font >= 0 && font_exists(_title_font))) {
			_title_font = _old_font;
		}
		draw_set_font(_title_font);
		draw_set_alpha(_old_a * _t_editor.title_a);
		draw_set_color(_t_editor.title_col);
		draw_text(_panel_inner_x1 + _pad_x, _title_y, _editor_title);
		draw_set_alpha(_old_a);

		// Buttons.
		var _body_font = _st.fonts.editor_body;
		if (is_real(_body_font) && _body_font >= 0 && font_exists(_body_font)) {
			draw_set_font(_body_font);
		}
		else {
			draw_set_font(_old_font);
		}

		var _hover_done = (_mx >= _btn_done_x1 && _mx <= _btn_done_x2 && _my >= _btn_y1 && _my <= _btn_y2);
		var _hover_cancel = (_mx >= _btn_cancel_x1 && _mx <= _btn_cancel_x2 && _my >= _btn_y1 && _my <= _btn_y2);
		var _btn_w_now = max(0, _btn_cancel_x2 - _btn_cancel_x1);
		var _btn_h_now = max(0, _btn_y2 - _btn_y1);
		var _btn_cancel_vb = -1;
		if (QUILL_VB_ENABLE && is_struct(_owner_cache)) {
			var _btn_cancel_sig = {
				w: _btn_w_now,
				h: _btn_h_now,
				state_key: _hover_cancel ? "editor_btn_hover" : "editor_btn_idle",
				need_bg: true,
				need_border: true,
				bg_col: _hover_cancel ? _t_editor.btn_bg_hover_col : _t_editor.btn_bg_idle_col,
				bg_a: _hover_cancel ? _t_editor.btn_bg_hover_a : _t_editor.btn_bg_idle_a,
				border_col: _t_editor.btn_border_col,
				border_a: _t_editor.btn_border_a,
				border_thickness: 1
			};
			_btn_cancel_vb = __QuillVbEnsureBox(_owner_cache, _btn_cancel_sig);
		}
		if (_btn_cancel_vb >= 0) {
			draw_set_alpha(_old_a);
			__QuillVbSubmitTranslated(_btn_cancel_vb, _btn_cancel_x1, _btn_y1, _hover_cancel ? "editor_btn_hover" : "editor_btn_idle");
		}
		else {
			draw_set_alpha(_old_a * (_hover_cancel ? _t_editor.btn_bg_hover_a : _t_editor.btn_bg_idle_a));
			draw_set_color(_hover_cancel ? _t_editor.btn_bg_hover_col : _t_editor.btn_bg_idle_col);
			draw_rectangle(_btn_cancel_x1, _btn_y1, _btn_cancel_x2, _btn_y2, false);
			draw_set_alpha(_old_a * _t_editor.btn_border_a);
			draw_set_color(_t_editor.btn_border_col);
			__QuillRenderDrawBorderPrimitive(_btn_cancel_x1, _btn_y1, _btn_cancel_x2, _btn_y2, 1);
		}
		draw_set_alpha(_old_a * _t_editor.btn_text_a);
		draw_set_color(_t_editor.btn_text_col);
		var _cancel = "Cancel";
		draw_text(
		_btn_cancel_x1 + max(0, floor((_btn_w - string_width(_cancel)) * 0.5)),
		_btn_y1 + max(0, floor((_btn_h - string_height(_cancel)) * 0.5)),
		_cancel
		);

		var _btn_done_vb = -1;
		if (QUILL_VB_ENABLE && is_struct(_owner_cache)) {
			var _btn_done_sig = {
				w: _btn_w_now,
				h: _btn_h_now,
				state_key: _hover_done ? "editor_btn_hover" : "editor_btn_idle",
				need_bg: true,
				need_border: true,
				bg_col: _hover_done ? _t_editor.btn_bg_hover_col : _t_editor.btn_bg_idle_col,
				bg_a: _hover_done ? _t_editor.btn_bg_hover_a : _t_editor.btn_bg_idle_a,
				border_col: _t_editor.btn_border_col,
				border_a: _t_editor.btn_border_a,
				border_thickness: 1
			};
			_btn_done_vb = __QuillVbEnsureBox(_owner_cache, _btn_done_sig);
		}
		if (_btn_done_vb >= 0) {
			draw_set_alpha(_old_a);
			__QuillVbSubmitTranslated(_btn_done_vb, _btn_done_x1, _btn_y1, _hover_done ? "editor_btn_hover" : "editor_btn_idle");
		}
		else {
			draw_set_alpha(_old_a * (_hover_done ? _t_editor.btn_bg_hover_a : _t_editor.btn_bg_idle_a));
			draw_set_color(_hover_done ? _t_editor.btn_bg_hover_col : _t_editor.btn_bg_idle_col);
			draw_rectangle(_btn_done_x1, _btn_y1, _btn_done_x2, _btn_y2, false);
			draw_set_alpha(_old_a * _t_editor.btn_border_a);
			draw_set_color(_t_editor.btn_border_col);
			__QuillRenderDrawBorderPrimitive(_btn_done_x1, _btn_y1, _btn_done_x2, _btn_y2, 1);
		}
		draw_set_alpha(_old_a * _t_editor.btn_text_a);
		draw_set_color(_t_editor.btn_text_col);
		var _done = "Done";
		draw_text(
		_btn_done_x1 + max(0, floor((_btn_w - string_width(_done)) * 0.5)),
		_btn_y1 + max(0, floor((_btn_h - string_height(_done)) * 0.5)),
		_done
		);
		draw_set_alpha(_old_a);

		if (_mouse_l_pressed) {
			if (_hover_cancel) {
				__OverlayEditorCancel();
				draw_set_font(_old_font);
				return;
			}
			if (_hover_done) {
				__OverlayEditorDone(true);
				draw_set_font(_old_font);
				return;
			}
		}

		// Editor area uses the overlay editor box.
		// Keep textbox outer bounds inside the editor content lane when border sprites draw outside.
		var _st_overlay_tb = __BuildResolvedStyleForTb(_tb);
		var _overlay_tb_border_out = __QuillRenderGetSkinBorderOutsideInsets(_st_overlay_tb.skins);
		var _editor_draw_x1 = _editor_x1 + _overlay_tb_border_out.left;
		var _editor_draw_y1 = _editor_y1 + _overlay_tb_border_out.top;
		var _editor_draw_x2 = _editor_x2 - _overlay_tb_border_out.right;
		var _editor_draw_y2 = _editor_y2 - _overlay_tb_border_out.bottom;
		if (_editor_draw_x2 < _editor_draw_x1) {
			_editor_draw_x2 = _editor_draw_x1;
		}
		if (_editor_draw_y2 < _editor_draw_y1) {
			_editor_draw_y2 = _editor_draw_y1;
		}
		_tb.Draw(_editor_draw_x1, _editor_draw_y1, _editor_draw_x2 - _editor_draw_x1, _editor_draw_y2 - _editor_draw_y1);
		draw_set_font(_old_font);
	};

	/// @ignore
	static __ClampScroll = function(_scroll_y, _content_h, _view_h) {
		var _max_scroll = max(0, _content_h - _view_h);
		return clamp(_scroll_y, 0, _max_scroll);
	};

	/// @ignore
	static __ClampScrollX = function(_scroll_x, _content_w, _view_w) {
		var _max_scroll = max(0, _content_w - _view_w);
		return clamp(_scroll_x, 0, _max_scroll);
	};

	/// @ignore
	static __TextInputResetCaretBlink = function(_tb) {
		_tb.caret_visible = true;
		_tb.caret_blink_time = current_time;
	};

	/// @ignore
	static __TextInputClampIndices = function(_tb) {
		var _len = string_length(_tb.text);
		_tb.caret_index = clamp(_tb.caret_index, 0, _len);
		if (_tb.selection_anchor >= 0) {
			_tb.selection_anchor = clamp(_tb.selection_anchor, 0, _len);
		}
	};

	/// @ignore
	static __TextInputHasSelection = function(_tb) {
		return (_tb.selection_anchor >= 0 && _tb.selection_anchor != _tb.caret_index);
	};

	/// @ignore
	static __TextInputGetSelectionRange = function(_tb) {
		if (!__TextInputHasSelection(_tb)) {
			return { start: _tb.caret_index, _end: _tb.caret_index };
		}
		var _s = min(_tb.selection_anchor, _tb.caret_index);
		var _e = max(_tb.selection_anchor, _tb.caret_index);
		return { start: _s, _end: _e };
	};

	/// @ignore
	static __TextInputClearSelection = function(_tb) {
		call_later(2, time_source_units_frames, method({ _tb }, function() { _tb.selection_anchor = -1; }));
	};

	/// @ignore
	static __TextInputSetCaretEx = function(_tb, _index, _extend_selection, _update_preferred_x, _config) {
		var _len = string_length(_tb.text);
		var _next = clamp(_index, 0, _len);
		if (_extend_selection) {
			if (_tb.selection_anchor < 0) {
				_tb.selection_anchor = _tb.caret_index;
			}
		}
		else {
			_tb.selection_anchor = -1;
		}
		_tb.caret_index = _next;
		__TextInputResetCaretBlink(_tb);

		if (_update_preferred_x) {
			__TextAreaUpdatePreferredXFromCaret(_tb, _config);
		}
		__TextInputEnsureCaretVisible(_tb, _config);
	};

	/// @ignore
	static __TextInputSetCaret = function(_tb, _index, _extend_selection, _config) {
		__TextInputSetCaretEx(_tb, _index, _extend_selection, true, _config);
	};

	/// @ignore
	static __TextInputSelectAll = function(_tb, _config) {
		_tb.selection_anchor = 0;
		_tb.caret_index = string_length(_tb.text);
		__TextInputResetCaretBlink(_tb);
		__TextAreaUpdatePreferredXFromCaret(_tb, _config);
		__TextInputEnsureCaretVisible(_tb, _config);
	};

	/// @ignore
	static __TextInputGetSelectedText = function(_tb) {
		if (!__TextInputHasSelection(_tb)) return "";
		var _range = __TextInputGetSelectionRange(_tb);
		var _len = _range._end - _range.start;
		if (_len <= 0) return "";
		return string_copy(_tb.text, _range.start + 1, _len);
	};

	/// @ignore
	static __TextInputIsWordChar = function(_ch) {
		if (string_length(_ch) <= 0) return false;
		var _code = ord(_ch);
		if (_code >= 48 && _code <= 57) return true;
		if (_code >= 65 && _code <= 90) return true;
		if (_code >= 97 && _code <= 122) return true;
		return (_code == 95);
	};

	/// @ignore
	static __TextInputFindWordStart = function(_text, _index) {
		var _len = string_length(_text);
		var _i = clamp(_index, 0, _len);
		while (_i > 0) {
			var _ch = string_char_at(_text, _i);
			if (__TextInputIsWordChar(_ch)) break;
			_i--;
		}
		while (_i > 0) {
			var _ch2 = string_char_at(_text, _i);
			if (!__TextInputIsWordChar(_ch2)) break;
			_i--;
		}
		return _i;
	};

	/// @ignore
	static __TextInputFindWordEnd = function(_text, _index) {
		var _len = string_length(_text);
		var _i = clamp(_index, 0, _len);
		while (_i < _len) {
			var _ch = string_char_at(_text, _i + 1);
			if (__TextInputIsWordChar(_ch)) break;
			_i++;
		}
		while (_i < _len) {
			var _ch2 = string_char_at(_text, _i + 1);
			if (!__TextInputIsWordChar(_ch2)) break;
			_i++;
		}
		return _i;
	};

	/// @ignore
	static __TextInputGetWordRange = function(_text, _index) {
		var _len = string_length(_text);
		if (_len <= 0) return { start: 0, _end: 0 };
		var _i = clamp(_index, 0, _len - 1);
		var _ch = string_char_at(_text, _i + 1);
		if (!__TextInputIsWordChar(_ch)) {
			return { start: _i, _end: _i + 1 };
		}
		var _start = __TextInputFindWordStart(_text, _i);
		var _end = __TextInputFindWordEnd(_text, _i + 1);
		return { start: _start, _end: _end };
	};

	/// @ignore
	static __TextInputGetLineRange = function(_text, _index, _config) {
		var _len = string_length(_text);
		if (_len <= 0) {
			return { start: 0, _end: 0 };
		}
		if (!is_struct(_config) || _config[$ "multiline"] != true) {
			return { start: 0, _end: _len };
		}

		var _i = clamp(_index, 0, _len);
		var _start = __TextAreaFindLogicalLineStart(_text, _i);
		var _end = __TextAreaFindLogicalLineEnd(_text, _i);
		return { start: _start, _end: _end };
	};

	/// @ignore
	static __TextInputIndexFromX = function(_text, _font, _x, _config = undefined) {
		var _len = string_length(_text);
		if (_len <= 0) return 0;
		var _old_font = draw_get_font();
		draw_set_font(_font);
		var _local_x = max(0, _x);
		var _acc = 0;
		var _idx = _len;
		var _tab_w = string_width(__TextGetVisualTabToken(_config));
		for (var _i = 1; _i <= _len; _i++) {
			var _ch = string_char_at(_text, _i);
			var _w = (_ch == "\t") ? _tab_w : string_width(_ch);
			if (_local_x < (_acc + (_w * 0.5))) {
				_idx = _i - 1;
				break;
			}
			_acc += _w;
		}
		draw_set_font(_old_font);
		return clamp(_idx, 0, _len);
	};

	/// @ignore
	static __TextInputKeyRepeat = function(_tb, _key) {
		var _key_str = string(_key);
		if (!keyboard_check(_key)) {
			_tb.key_repeat_next[$ _key_str] = undefined;
			return false;
		}
		if (keyboard_check_pressed(_key)) {
			_tb.key_repeat_next[$ _key_str] = current_time + _tb.key_repeat_delay_ms;
			return true;
		}
		var _next = _tb.key_repeat_next[$ _key_str];
		if (is_undefined(_next)) {
			_tb.key_repeat_next[$ _key_str] = current_time + _tb.key_repeat_delay_ms;
			return false;
		}
		if (current_time >= _next) {
			_tb.key_repeat_next[$ _key_str] = current_time + _tb.key_repeat_rate_ms;
			return true;
		}
		return false;
	};

	/// @ignore
	static __TextInputPushUndo = function(_tb) {
		if (_tb.undo_limit <= 0) return;
		var _entry = { text: _tb.text, caret: _tb.caret_index, anchor: _tb.selection_anchor };
		array_push(_tb.undo_stack, _entry);
		var _len = array_length(_tb.undo_stack);
		if (_len > _tb.undo_limit) {
			array_delete(_tb.undo_stack, 0, _len - _tb.undo_limit);
		}
		_tb.redo_stack = [];
	};

	/// @ignore
	static __TextInputUndo = function(_tb, _config) {
		var _len = array_length(_tb.undo_stack);
		if (_len <= 0) return;
		var _entry = _tb.undo_stack[_len - 1];
		array_delete(_tb.undo_stack, _len - 1, 1);
		var _redo = { text: _tb.text, caret: _tb.caret_index, anchor: _tb.selection_anchor };
		array_push(_tb.redo_stack, _redo);
		if (is_struct(_entry)) {
			_tb.__SetValueRaw(string(_entry[$ "text"]));
			_tb.caret_index = _entry[$ "caret"] ?? 0;
			_tb.selection_anchor = _entry[$ "anchor"] ?? -1;
			__TextInputClampIndices(_tb);
			__TextInputResetCaretBlink(_tb);
			__TextInputMarkEdited(_tb, _config);
		}
	};

	/// @ignore
	static __TextInputRedo = function(_tb, _config) {
		var _len = array_length(_tb.redo_stack);
		if (_len <= 0) return;
		var _entry = _tb.redo_stack[_len - 1];
		array_delete(_tb.redo_stack, _len - 1, 1);
		var _undo = { text: _tb.text, caret: _tb.caret_index, anchor: _tb.selection_anchor };
		array_push(_tb.undo_stack, _undo);
		if (is_struct(_entry)) {
			_tb.__SetValueRaw(string(_entry[$ "text"]));
			_tb.caret_index = _entry[$ "caret"] ?? 0;
			_tb.selection_anchor = _entry[$ "anchor"] ?? -1;
			__TextInputClampIndices(_tb);
			__TextInputResetCaretBlink(_tb);
			__TextInputMarkEdited(_tb, _config);
		}
	};

	/// @ignore
	static __TextInputReplaceRange = function(_tb, _start, _end, _insert, _config) {
		var _text = _tb.text;
		var _len = string_length(_text);
		var _s = clamp(_start, 0, _len);
		var _e = clamp(_end, 0, _len);
		if (_e < _s) {
			var _tmp = _s;
			_s = _e;
			_e = _tmp;
		}
		var _before = (_s > 0) ? string_copy(_text, 1, _s) : "";
		var _after = (_e < _len) ? string_copy(_text, _e + 1, _len - _e) : "";
		var _next = _before + string(_insert) + _after;
		if (_next == _text) {
			_tb.caret_index = _s + string_length(_insert);
			__TextInputClearSelection(_tb);
			return false;
		}
		__TextInputPushUndo(_tb);
		_tb.__SetValueRaw(_next);
		_tb.caret_index = _s + string_length(_insert);
		_tb.selection_anchor = -1;
		__TextInputResetCaretBlink(_tb);
		__TextInputMarkEdited(_tb, _config);
		return true;
	};

	/// @ignore
	static __TextInputApplyTransforms = function(_tb, _text) {
		var _out = string(_text);
		if (!is_struct(_tb)) {
			return _out;
		}
		if (_tb.auto_trim == true) {
			_out = string_trim(_out);
		}
		if (_tb.auto_upper == true) {
			_out = string_upper(_out);
		}
		else if (_tb.auto_lower == true) {
			_out = string_lower(_out);
		}
		if (is_array(_tb.transformers)) {
			var _n = array_length(_tb.transformers);
			for (var i = 0; i < _n; i++) {
				var _fn = _tb.transformers[i];
				if (is_callable(_fn)) {
					_out = string(_fn(_out));
				}
			}
		}
		return _out;
	};

	/// @ignore
	static __TextInputFilterInsert = function(_tb, _insert, _range, _config) {
		var _raw = string(_insert);
		if (!is_struct(_range)) return _raw;

		_raw = __TextInputApplyTransforms(_tb, _raw);
		var _filter_fn = is_struct(_config) ? _config[$ "filter_fn"] : undefined;
		if (is_callable(_filter_fn)) {
			_raw = string(_filter_fn(_raw));
		}
		if (string_length(_raw) <= 0) return "";

		var _multiline = is_struct(_config) ? (_config[$ "multiline"] == true) : false;
		if (_multiline) {
			_raw = string_replace_all(_raw, "\r\n", "\n");
			_raw = string_replace_all(_raw, "\r", "\n");
		}

		var _allow = is_struct(_config) ? string(_config[$ "allow_chars"] ?? "") : "";
		var _deny = is_struct(_config) ? string(_config[$ "deny_chars"] ?? "") : "";
		var _numeric = is_struct(_config) ? (_config[$ "numeric_only"] == true) : false;
		var _allow_decimal = is_struct(_config) ? (_config[$ "numeric_allow_decimal"] == true) : false;
		var _allow_negative = is_struct(_config) ? (_config[$ "numeric_allow_negative"] == true) : false;
		var _mode = is_struct(_config) ? (_config[$ "input_mode"] ?? QUILL_TEXTMODE_TEXT) : QUILL_TEXTMODE_TEXT;

		var _base_text = _tb.text;
		var _base_len = string_length(_base_text);
		var _sel_len = _range._end - _range.start;
		var _head = (_range.start > 0) ? string_copy(_base_text, 1, _range.start) : "";
		var _tail = (_range._end < _base_len) ? string_copy(_base_text, _range._end + 1, _base_len - _range._end) : "";
		var _base = _head + _tail;
		var _has_decimal = (string_pos(".", _base) > 0);
		var _has_minus = (string_pos("-", _base) > 0);

		var _out = "";
		var _raw_len = string_length(_raw);
		for (var _i = 1; _i <= _raw_len; _i++) {
			var _ch = string_char_at(_raw, _i);

			if (!_multiline) {
				if (_ch == "\r" || _ch == "\n") continue;

				// Tabs are optional in single-line (default off).
				if (_ch == "\t") {
					var _tab_ok = is_struct(_config) ? (_config[$ "tab_inserts"] == true) : false;
					if (_tab_ok) {
						var _spaces = is_struct(_config) ? (_config[$ "tab_use_spaces"] == true) : false;
						if (_spaces) {
							var _count = is_struct(_config) ? (_config[$ "tab_spaces"] ?? 4) : 4;
							_count = max(0, floor(_count));
							if (_count > 0) _out += string_repeat(" ", _count);
						}
						else {
							_out += _ch;
						}
					}
					continue;
				}
			}
			else {
				// Preserve newline as a structural character (do not filter it through allow/deny/numeric).
				if (_ch == "\n") {
					_out += _ch;
					continue;
				}

				// Tabs are optional in multiline (default off).
				if (_ch == "\t") {
					var _tab_ok2 = is_struct(_config) ? (_config[$ "tab_inserts"] == true) : false;
					if (_tab_ok2) {
						var _spaces2 = is_struct(_config) ? (_config[$ "tab_use_spaces"] == true) : false;
						if (_spaces2) {
							var _count2 = is_struct(_config) ? (_config[$ "tab_spaces"] ?? 4) : 4;
							_count2 = max(0, floor(_count2));
							if (_count2 > 0) _out += string_repeat(" ", _count2);
						}
						else {
							_out += _ch;
						}
					}
					continue;
				}

				// CR is normalized earlier, but ignore defensively.
				if (_ch == "\r") continue;
			}

			// Mode layer (built-in).
			if (_mode == QUILL_TEXTMODE_IDENTIFIER) {
				var _code2 = ord(_ch);
				var _ok = false;
				if (_ch == "_") {
					_ok = true;
				}
				else if (_code2 >= 48 && _code2 <= 57) {
					var _leading = (_range.start <= 0 && string_length(_out) <= 0);
					_ok = !_leading;
				}
				else if ((_code2 >= 65 && _code2 <= 90) || (_code2 >= 97 && _code2 <= 122)) {
					_ok = true;
				}
				if (!_ok) continue;
			}
			else if (_mode == QUILL_TEXTMODE_PATH) {
				var _code3 = ord(_ch);
				var _ok2 = false;
				if (_ch == " " || _ch == "_" || _ch == "/" || _ch == "\\" || _ch == ":" || _ch == "-" || _ch == ".") {
					_ok2 = true;
				}
				else if (_code3 >= 48 && _code3 <= 57) {
					_ok2 = true;
				}
				else if ((_code3 >= 65 && _code3 <= 90) || (_code3 >= 97 && _code3 <= 122)) {
					_ok2 = true;
				}
				if (!_ok2) continue;
			}

			if (string_length(_allow) > 0 && string_pos(_ch, _allow) <= 0) continue;
			if (string_length(_deny) > 0 && string_pos(_ch, _deny) > 0) continue;

			if (_numeric) {
				if (_ch == ".") {
					if (!_allow_decimal || _has_decimal) continue;
					_has_decimal = true;
				}
				else if (_ch == "-") {
					if (!_allow_negative) continue;
					if (string_length(_out) > 0) continue;
					if (_range.start > 0) continue;
					if (_has_minus) continue;
					_has_minus = true;
				}
				else {
					var _code4 = ord(_ch);
					if (_code4 < 48 || _code4 > 57) continue;
				}
			}

			_out += _ch;
		}

		var _max_len = is_struct(_config) ? (_config[$ "max_length"] ?? 0) : 0;
		if (is_real(_max_len) && _max_len > 0) {
			var _base_len2 = _base_len - _sel_len;
			var _room = _max_len - _base_len2;
			if (_room <= 0) return "";
			if (string_length(_out) > _room) {
				_out = string_copy(_out, 1, _room);
			}
		}

		return _out;
	};

	/// @ignore
	static __TextInputInsertText = function(_tb, _insert, _config) {
		var _range = __TextInputGetSelectionRange(_tb);
		var _filtered = __TextInputFilterInsert(_tb, _insert, _range, _config);
		if (string_length(_filtered) <= 0) return false;
		return __TextInputReplaceRange(_tb, _range.start, _range._end, _filtered, _config);
	};

	/// @ignore
	static __TextInputSetExternalValue = function(_tb, _value, _config) {
		if (!is_struct(_tb)) {
			return;
		}
		var _len = string_length(_tb.text);
		var _range = { start: 0, _end: _len };
		var _filtered = __TextInputFilterInsert(_tb, string(_value), _range, _config);
		if (_filtered == _tb.text) {
			return;
		}
		__TextInputReplaceRange(_tb, 0, _len, _filtered, _config);
	};

	/// @ignore
	static __TextInputDeleteSelection = function(_tb, _config) {
		if (!__TextInputHasSelection(_tb)) return false;
		var _range = __TextInputGetSelectionRange(_tb);
		return __TextInputReplaceRange(_tb, _range.start, _range._end, "", _config);
	};

	/// @ignore
	static __TextInputDeleteChar = function(_tb, _dir, _config) {
		var _len = string_length(_tb.text);
		if (_dir < 0) {
			if (_tb.caret_index <= 0) return false;
			return __TextInputReplaceRange(_tb, _tb.caret_index - 1, _tb.caret_index, "", _config);
		}
		if (_tb.caret_index >= _len) return false;
		return __TextInputReplaceRange(_tb, _tb.caret_index, _tb.caret_index + 1, "", _config);
	};

	/// @ignore
	static __TextInputDeleteWord = function(_tb, _dir, _config) {
		if (_dir < 0) {
			var _start = __TextInputFindWordStart(_tb.text, _tb.caret_index);
			return __TextInputReplaceRange(_tb, _start, _tb.caret_index, "", _config);
		}
		var _end = __TextInputFindWordEnd(_tb.text, _tb.caret_index);
		return __TextInputReplaceRange(_tb, _tb.caret_index, _end, "", _config);
	};

	/// @ignore
	static __TextInputMoveCaret = function(_tb, _delta, _extend_selection, _config) {
		__TextInputSetCaret(_tb, _tb.caret_index + _delta, _extend_selection, _config);
	};

	/// @ignore
	static __TextInputMoveCaretWord = function(_tb, _dir, _extend_selection, _config) {
		var _next = _tb.caret_index;
		if (_dir < 0) {
			_next = __TextInputFindWordStart(_tb.text, _tb.caret_index);
		}
		else {
			_next = __TextInputFindWordEnd(_tb.text, _tb.caret_index);
		}
		__TextInputSetCaret(_tb, _next, _extend_selection, _config);
	};

	/// @ignore
	static __TextInputBumpGen = function(_tb) {
		_tb.edit_gen += 1;
		_tb.layout_cache = undefined;
		_tb.layout_cache_gen = -1;
		_tb.layout_cache_wrap = false;
		_tb.layout_cache_view_w = 0;
		_tb.layout_cache_font = undefined;
		_tb.layout_cache_password_mask = false;
		_tb.layout_cache_password_char = "*";
		_tb.layout_cache_tab_spaces = 4;
	};

	/// @ignore
	static __TextInputMarkEdited = function(_tb, _config) {
		__TextInputBumpGen(_tb);
		__TextAreaUpdatePreferredXFromCaret(_tb, _config);
		__TextInputEnsureCaretVisible(_tb, _config);

		var _fn = is_struct(_config) ? _config[$ "on_live_change"] : undefined;
		if (!is_callable(_fn)) {
			return;
		}
		var _rate = is_struct(_config) ? (_config[$ "live_change_rate_ms"] ?? 0) : 0;
		if (!is_real(_rate)) _rate = 0;
		_rate = max(0, _rate);

		if (_rate <= 0) {
			_fn(string(_tb.GetValue()));
			_tb.live_dirty = false;
			_tb.live_next_at = 0;
		}
		else {
			_tb.live_dirty = true;
			if (_tb.live_next_at <= 0 || current_time >= _tb.live_next_at) {
				_tb.live_next_at = current_time + _rate;
			}
		}
	};

	/// @ignore
	static __TextInputPumpLiveChange = function(_tb, _config) {
		if (!_tb.live_dirty) {
			return;
		}
		var _fn = is_struct(_config) ? _config[$ "on_live_change"] : undefined;
		if (!is_callable(_fn)) {
			_tb.live_dirty = false;
			_tb.live_next_at = 0;
			return;
		}
		var _rate = is_struct(_config) ? (_config[$ "live_change_rate_ms"] ?? 0) : 0;
		if (!is_real(_rate)) _rate = 0;
		_rate = max(0, _rate);
		if (_rate <= 0) {
			_fn(string(_tb.GetValue()));
			_tb.live_dirty = false;
			_tb.live_next_at = 0;
			return;
		}
		if (_tb.live_next_at > 0 && current_time < _tb.live_next_at) {
			return;
		}
		_fn(string(_tb.GetValue()));
		_tb.live_dirty = false;
		_tb.live_next_at = current_time + _rate;
	};

	/// @ignore
	static __TextInputCopySelection = function(_tb, _config) {
		if (is_struct(_config) && _config[$ "password_mask"] == true && _config[$ "password_allow_copy"] != true) {
			return;
		}
		var _sel = __TextInputGetSelectedText(_tb);
		if (string_length(_sel) <= 0) return;
		clipboard_set_text(_sel);
	};

	/// @ignore
	static __TextInputCutSelection = function(_tb, _config) {
		if (is_struct(_config) && _config[$ "password_mask"] == true && _config[$ "password_allow_copy"] != true) {
			return;
		}
		if (!__TextInputHasSelection(_tb)) return;
		__TextInputCopySelection(_tb, _config);
		__TextInputDeleteSelection(_tb, _config);
	};

	/// @ignore
	static __TextInputPasteClipboard = function(_tb, _config) {
		var _clip = clipboard_get_text();
		if ( is_undefined(_clip) || _clip == "" ) return;
		__TextInputInsertText(_tb, string(_clip), _config);
	};

	/// @ignore
	static __TextInputGetTabToken = function(_config) {
		var _spaces = is_struct(_config) ? (_config[$ "tab_use_spaces"] == true) : false;
		if (_spaces) {
			var _count = is_struct(_config) ? (_config[$ "tab_spaces"] ?? 4) : 4;
			_count = max(0, floor(_count));
			if (_count <= 0) return "";
			return string_repeat(" ", _count);
		}
		return "\t";
	};

	/// @ignore
	static __TextInputApplyEdit = function(_tb, _next_text, _next_caret, _next_anchor, _config) {
		var _next = string(_next_text);
		if (_next == _tb.text) {
			return false;
		}
		__TextInputPushUndo(_tb);
		_tb.__SetValueRaw(_next);
		_tb.caret_index = _next_caret;
		_tb.selection_anchor = _next_anchor;
		__TextInputClampIndices(_tb);
		__TextInputResetCaretBlink(_tb);
		__TextInputMarkEdited(_tb, _config);
		return true;
	};

	/// @ignore
	static __TextAreaFindLogicalLineStart = function(_text, _pos) {
		var _s = string(_text);
		var _len = string_length(_s);
		var _i = clamp(floor(_pos), 0, _len);
		while (_i > 0) {
			if (string_char_at(_s, _i) == "\n") {
				break;
			}
			_i -= 1;
		}
		return _i;
	};

	/// @ignore
	static __TextAreaFindLogicalLineEnd = function(_text, _pos) {
		var _s = string(_text);
		var _len = string_length(_s);
		var _i = clamp(floor(_pos), 0, _len);
		while (_i < _len) {
			if (string_char_at(_s, _i + 1) == "\n") {
				break;
			}
			_i += 1;
		}
		return _i;
	};

	/// @ignore
	static __TextAreaInsertTabToken = function(_tb, _config) {
		var _token = __TextInputGetTabToken(_config);
		if (string_length(_token) <= 0) return false;
		return __TextInputInsertText(_tb, _token, _config);
	};

	/// @ignore
	static __TextAreaIndentSelection = function(_tb, _config) {
		if (!is_struct(_config) || _config[$ "multiline"] != true) {
			return __TextAreaInsertTabToken(_tb, _config);
		}

		var _token = __TextInputGetTabToken(_config);
		var _tok_len = string_length(_token);
		if (_tok_len <= 0) return false;

		var _text = _tb.text;
		var _len = string_length(_text);

		var _caret = _tb.caret_index;
		var _anchor = _tb.selection_anchor;

		var _starts = [];

		if (__TextInputHasSelection(_tb)) {
			var _range = __TextInputGetSelectionRange(_tb);
			var _end_for_lines = _range._end;
			if (_end_for_lines > 0 && string_char_at(_text, _end_for_lines) == "\n") {
				_end_for_lines = max(0, _end_for_lines - 1);
			}

			var _pos = __TextAreaFindLogicalLineStart(_text, _range.start);
			while (_pos <= _end_for_lines) {
				array_push(_starts, _pos);

				var _found = false;
				for (var i = _pos; i < _len; i++) {
					if (string_char_at(_text, i + 1) == "\n") {
						_pos = i + 1;
						_found = true;
						break;
					}
				}
				if (!_found) break;
			}
		}
		else {
			array_push(_starts, __TextAreaFindLogicalLineStart(_text, _caret));
		}

		var _n = array_length(_starts);
		if (_n <= 0) return false;

		var _next = _text;
		for (var _i = _n - 1; _i >= 0; _i--) {
			var _at = _starts[_i];
			_at = clamp(_at, 0, string_length(_next));
			var _before = (_at > 0) ? string_copy(_next, 1, _at) : "";
			var _after = string_copy(_next, _at + 1, string_length(_next) - _at);
			_next = _before + _token + _after;

			if (_caret >= _at) _caret += _tok_len;
			if (_anchor >= 0 && _anchor >= _at) _anchor += _tok_len;
		}

		return __TextInputApplyEdit(_tb, _next, _caret, _anchor, _config);
	};

	/// @ignore
	static __TextAreaOutdentSelection = function(_tb, _config) {
		if (!is_struct(_config) || _config[$ "multiline"] != true) {
			return false;
		}

		var _text = _tb.text;
		var _len = string_length(_text);
		if (_len <= 0) return false;

		var _tab_spaces = is_struct(_config) ? (_config[$ "tab_spaces"] ?? 4) : 4;
		_tab_spaces = max(0, floor(_tab_spaces));

		var _caret = _tb.caret_index;
		var _anchor = _tb.selection_anchor;

		var _starts = [];

		if (__TextInputHasSelection(_tb)) {
			var _range = __TextInputGetSelectionRange(_tb);
			var _end_for_lines = _range._end;
			if (_end_for_lines > 0 && string_char_at(_text, _end_for_lines) == "\n") {
				_end_for_lines = max(0, _end_for_lines - 1);
			}

			var _pos = __TextAreaFindLogicalLineStart(_text, _range.start);
			while (_pos <= _end_for_lines) {
				array_push(_starts, _pos);

				var _found = false;
				for (var i = _pos; i < _len; i++) {
					if (string_char_at(_text, i + 1) == "\n") {
						_pos = i + 1;
						_found = true;
						break;
					}
				}
				if (!_found) break;
			}
		}
		else {
			array_push(_starts, __TextAreaFindLogicalLineStart(_text, _caret));
		}

		var _n = array_length(_starts);
		if (_n <= 0) return false;

		var _next = _text;
		var _changed = false;

		for (var _i = _n - 1; _i >= 0; _i--) {
			var _at = clamp(_starts[_i], 0, string_length(_next));
			if (_at >= string_length(_next)) continue;

			var _rem = 0;
			var _ch = string_char_at(_next, _at + 1);
			if (_ch == "\t") {
				_rem = 1;
			}
			else if (_ch == " " && _tab_spaces > 0) {
				while (_rem < _tab_spaces && (_at + _rem) < string_length(_next) && string_char_at(_next, _at + _rem + 1) == " ") {
					_rem += 1;
				}
			}

			if (_rem <= 0) continue;

			var _before = (_at > 0) ? string_copy(_next, 1, _at) : "";
			var _after = string_copy(_next, _at + _rem + 1, string_length(_next) - (_at + _rem));
			_next = _before + _after;
			_changed = true;

			if (_caret > _at) {
				if (_caret >= _at + _rem) _caret -= _rem;
				else _caret = _at;
			}
			if (_anchor >= 0 && _anchor > _at) {
				if (_anchor >= _at + _rem) _anchor -= _rem;
				else _anchor = _at;
			}
		}

		if (!_changed) return false;
		return __TextInputApplyEdit(_tb, _next, _caret, _anchor, _config);
	};

	/// @ignore
	static __TextAreaInsertAutoIndentNewline = function(_tb, _config) {
		if (!is_struct(_config) || _config[$ "multiline"] != true) {
			return false;
		}

		var _mode = _config[$ "input_mode"] ?? QUILL_TEXTMODE_TEXT;
		if (_mode != QUILL_TEXTMODE_CODE || _config[$ "auto_indent"] != true) {
			return __TextInputInsertText(_tb, "\n", _config);
		}

		var _token = __TextInputGetTabToken(_config);
		var _text = _tb.text;
		var _caret = _tb.caret_index;

		var _ls = __TextAreaFindLogicalLineStart(_text, _caret);
		var _le = __TextAreaFindLogicalLineEnd(_text, _caret);
		var _line = (_le > _ls) ? string_copy(_text, _ls + 1, _le - _ls) : "";
		var _line_before = (_caret > _ls) ? string_copy(_text, _ls + 1, _caret - _ls) : "";
		var _line_scan = _line_before;
		if (string_length(_line_scan) <= 0) {
			_line_scan = _line;
		}

		var _indent = "";
		var _ln = string_length(_line_scan);
		var _has_non_ws = false;
		for (var i = 1; i <= _ln; i++) {
			var _ch = string_char_at(_line_scan, i);
			if (_ch == " " || _ch == "\t") {
				_indent += _ch;
			}
			else {
				_has_non_ws = true;
				break;
			}
		}
		if (!_has_non_ws) {
			_indent = "";
		}

		var _extra_token = _token;
		if (string_pos("\t", _indent) > 0) {
			_extra_token = "\t";
		}

		var _extra = "";
		if (_has_non_ws) {
			for (var k = _ln; k >= 1; k--) {
				var _c3 = string_char_at(_line_scan, k);
				if (_c3 == " " || _c3 == "\t") {
					continue;
				}
				if (_c3 == "{") {
					_extra = _extra_token;
				}
				break;
			}
		}

		return __TextInputInsertText(_tb, "\n" + _indent + _extra, _config);
	};

	/// @ignore
	static __TextInputBeginMouseSelection = function(_tb, _index, _shift_down, _click_count, _config) {
		var _count = max(1, floor(_click_count));
		if (_shift_down) {
			_count = 1;
		}

		if (_count >= 3) {
			var _range_line = __TextInputGetLineRange(_tb.text, _index, _config);
			_tb.mouse_select_mode = 2;
			_tb.mouse_select_anchor_start = _range_line.start;
			_tb.mouse_select_anchor_end = _range_line._end;
			_tb.selection_anchor = _range_line.start;
			_tb.caret_index = _range_line._end;
			__TextInputResetCaretBlink(_tb);
			__TextInputEnsureCaretVisible(_tb, _config);
		}
		else if (_count == 2) {
			var _range = __TextInputGetWordRange(_tb.text, _index);
			_tb.mouse_select_mode = 1;
			_tb.mouse_select_anchor_start = _range.start;
			_tb.mouse_select_anchor_end = _range._end;
			_tb.selection_anchor = _range.start;
			_tb.caret_index = _range._end;
			__TextInputResetCaretBlink(_tb);
			__TextInputEnsureCaretVisible(_tb, _config);
		}
		else {
			_tb.mouse_select_mode = 0;
			_tb.mouse_select_anchor_start = -1;
			_tb.mouse_select_anchor_end = -1;
			__TextInputSetCaret(_tb, _index, _shift_down, _config);
			if (!_shift_down) {
				_tb.selection_anchor = _tb.caret_index;
			}
		}
		__TextAreaUpdatePreferredXFromCaret(_tb, _config);
		_tb.mouse_selecting = true;
	};

	/// @ignore
	static __TextInputUpdateMouseSelection = function(_tb, _index, _config) {
		var _len = string_length(_tb.text);
		var _next = clamp(_index, 0, _len);

		var _mode = max(0, floor(_tb.mouse_select_mode ?? 0));
		if (_mode == 1 || _mode == 2) {
			var _anchor_start = _tb.mouse_select_anchor_start;
			var _anchor_end = _tb.mouse_select_anchor_end;
			if (!is_real(_anchor_start) || !is_real(_anchor_end) || _anchor_start < 0 || _anchor_end < 0) {
				_anchor_start = _tb.selection_anchor;
				_anchor_end = _tb.caret_index;
				if (!is_real(_anchor_start)) _anchor_start = 0;
				if (!is_real(_anchor_end)) _anchor_end = 0;
				if (_anchor_end < _anchor_start) {
					var _tmp = _anchor_start;
					_anchor_start = _anchor_end;
					_anchor_end = _tmp;
				}
			}

			var _range2 = (_mode == 2)
			? __TextInputGetLineRange(_tb.text, _next, _config)
			: __TextInputGetWordRange(_tb.text, _next);

			if (_range2._end <= _anchor_start) {
				_tb.selection_anchor = _anchor_end;
				_tb.caret_index = _range2.start;
			}
			else if (_range2.start >= _anchor_end) {
				_tb.selection_anchor = _anchor_start;
				_tb.caret_index = _range2._end;
			}
			else {
				_tb.selection_anchor = _anchor_start;
				_tb.caret_index = _anchor_end;
			}

			__TextInputResetCaretBlink(_tb);
			__TextAreaUpdatePreferredXFromCaret(_tb, _config);
			__TextInputEnsureCaretVisible(_tb, _config);
			return;
		}

		if (_tb.selection_anchor < 0) {
			_tb.selection_anchor = _tb.caret_index;
		}
		_tb.caret_index = _next;
		__TextInputResetCaretBlink(_tb);
		__TextAreaUpdatePreferredXFromCaret(_tb, _config);
		__TextInputEnsureCaretVisible(_tb, _config);
	};

	/// @ignore
	static __TextInputEndMouseSelection = function(_tb) {
		_tb.mouse_selecting = false;
		_tb.mouse_select_mode = 0;
		_tb.mouse_select_anchor_start = -1;
		_tb.mouse_select_anchor_end = -1;
		if (!__TextInputHasSelection(_tb)) {
			_tb.selection_anchor = -1;
		}
	};

	/// @ignore
	static __TextAreaBuildLayout = function(_text, _font, _wrap, _view_w, _config = undefined) {
		var _s = string(_text);
		var _len = string_length(_s);

		var _old = draw_get_font();
		draw_set_font(_font);
		var _line_h = string_height("Ag");

		var _lines = [];
		var _content_w = 0;
		var _pos = 0;
		var _wrap_on = (_wrap == true) && (_view_w > 0);
		var _tab_w = string_width(__TextGetVisualTabToken(_config));

		while (_pos < _len) {
			var _logical_end = _pos;
			while (_logical_end < _len) {
				var _ch = string_char_at(_s, _logical_end + 1);
				if (_ch == "\n") {
					break;
				}
				_logical_end++;
			}

			if (_logical_end <= _pos) {
				array_push(_lines, { start: _pos, len: 0, w: 0, text: "", text_draw: "" });
			}
			else if (!_wrap_on) {
				var _seg_len = _logical_end - _pos;
				var _seg = string_copy(_s, _pos + 1, _seg_len);
				var _seg_w = 0;
				for (var _cw_i = 0; _cw_i < _seg_len; _cw_i++) {
					var _cw_ch = string_char_at(_s, _pos + _cw_i + 1);
					_seg_w += (_cw_ch == "\t") ? _tab_w : string_width(_cw_ch);
				}
				_content_w = max(_content_w, _seg_w);
				array_push(_lines, { start: _pos, len: _seg_len, w: _seg_w, text: _seg, text_draw: __TextExpandTabsForVisual(_seg, _config) });
			}
			else {
				var _seg_pos = _pos;
				while (_seg_pos < _logical_end) {
					var _line_start = _seg_pos;
					var _line_w = 0;
					var _last_break = -1;
					var _i = _seg_pos;

					while (_i < _logical_end) {
						var _ch2 = string_char_at(_s, _i + 1);
						var _cw = (_ch2 == "\t") ? _tab_w : string_width(_ch2);

						if ((_i > _line_start) && (_line_w + _cw > _view_w)) {
							break;
						}

						_line_w += _cw;
						if (_ch2 == " ") {
							_last_break = _i + 1;
						}
						_i++;
					}

					var _break_at = _i;
					var _did_overflow = (_i < _logical_end);
					if (_break_at <= _line_start) {
						_break_at = _line_start + 1;
					}
					else if (_did_overflow && _last_break > _line_start && _last_break < _break_at) {
						_break_at = _last_break;
					}

					var _take = _break_at - _line_start;
					var _seg2 = (_take > 0) ? string_copy(_s, _line_start + 1, _take) : "";
					var _seg2_w = 0;
					for (var _cw_j = 0; _cw_j < _take; _cw_j++) {
						var _cw_ch2 = string_char_at(_s, _line_start + _cw_j + 1);
						_seg2_w += (_cw_ch2 == "\t") ? _tab_w : string_width(_cw_ch2);
					}
					_content_w = max(_content_w, _seg2_w);
					array_push(_lines, { start: _line_start, len: _take, w: _seg2_w, text: _seg2, text_draw: __TextExpandTabsForVisual(_seg2, _config) });

					_seg_pos = _break_at;
				}
			}

			if (_logical_end < _len && string_char_at(_s, _logical_end + 1) == "\n") {
				_pos = _logical_end + 1;
			}
			else {
				_pos = _logical_end;
			}
		}

		if (_len <= 0) {
			array_push(_lines, { start: 0, len: 0, w: 0, text: "", text_draw: "" });
		}
		else if (string_char_at(_s, _len) == "\n") {
			array_push(_lines, { start: _len, len: 0, w: 0, text: "", text_draw: "" });
		}

		var _content_h = array_length(_lines) * _line_h;

		draw_set_font(_old);

		return {
			line_h: _line_h,
			lines: _lines,
			content_w: _content_w,
			content_h: _content_h
		};
	};

	/// @ignore
	static __GetActiveLayoutForTb = function(_tb, _config) {
		if (!is_struct(_tb) || !is_struct(_config)) {
			return undefined;
		}
		if (_config[$ "multiline"] != true) {
			return undefined;
		}

		var _gen = _tb.edit_gen;
		var _wrap2 = (_config[$ "wrap"] ?? true) == true;
		var _vw = max(0, _config[$ "view_w"] ?? 0);
		var _font = __ResolveTextboxFont(_tb, _config);

		var _mask_on = false;
		var _mask_char = "*";
		if (_config[$ "password_mask"] == true) {
			_mask_on = true;
			_mask_char = string(_config[$ "password_mask_char"] ?? "*");
			if (string_length(_mask_char) <= 0) _mask_char = "*";
			_mask_char = string_char_at(_mask_char, 1);
		}
		var _tab_spaces = _config[$ "tab_spaces"] ?? 4;
		_tab_spaces = max(1, floor(_tab_spaces));

		var _hit = is_struct(_tb.layout_cache)
		&& _tb.layout_cache_gen == _gen
		&& _tb.layout_cache_wrap == _wrap2
		&& _tb.layout_cache_view_w == _vw
		&& _tb.layout_cache_font == _font
		&& _tb.layout_cache_password_mask == _mask_on
		&& _tb.layout_cache_password_char == _mask_char
		&& _tb.layout_cache_tab_spaces == _tab_spaces;

		if (_hit) {
			return _tb.layout_cache;
		}

		var _src = _mask_on ? string_repeat(_mask_char, string_length(_tb.text)) : _tb.text;
		var _layout = __TextAreaBuildLayout(_src, _font, _wrap2, _vw, _config);

		_tb.layout_cache = _layout;
		_tb.layout_cache_gen = _gen;
		_tb.layout_cache_wrap = _wrap2;
		_tb.layout_cache_view_w = _vw;
		_tb.layout_cache_font = _font;
		_tb.layout_cache_password_mask = _mask_on;
		_tb.layout_cache_password_char = _mask_char;
		_tb.layout_cache_tab_spaces = _tab_spaces;
		return _layout;
	};

	/// @ignore
	static __TextAreaFindLineAtIndex = function(_layout, _index) {
		if (!is_struct(_layout)) return 0;
		var _lines = _layout[$ "lines"];
		if (!is_array(_lines)) return 0;
		var _count = array_length(_lines);
		if (_count <= 0) return 0;

		var _idx = _index;
		for (var _i = 0; _i < _count; _i++) {
			var _ln = _lines[_i];
			if (!is_struct(_ln)) continue;
			var _s = _ln[$ "start"] ?? 0;
			var _e = _s + (_ln[$ "len"] ?? 0);
			if (_idx < _s) {
				return max(0, _i - 1);
			}
			if (_idx <= _e) {
				return _i;
			}
		}
		return _count - 1;
	};

	/// @ignore
	static __TextAreaIndexFromPoint = function(_layout, _font, _local_x, _local_y, _config = undefined) {
		if (!is_struct(_layout)) return 0;
		var _lines = _layout[$ "lines"];
		if (!is_array(_lines)) return 0;
		var _count = array_length(_lines);
		if (_count <= 0) return 0;

		var _line_h = _layout[$ "line_h"] ?? 0;
		if (_line_h <= 0) _line_h = string_height("Ag");
		var _li = floor(max(0, _local_y) / max(1, _line_h));
		_li = clamp(_li, 0, _count - 1);

		var _ln = _lines[_li];
		if (!is_struct(_ln)) return 0;
		var _txt = string(_ln[$ "text"] ?? "");
		var _view_w = is_struct(_config) ? (_config[$ "view_w"] ?? 0) : 0;
		var _align_off = __TextGetAlignOffset(_txt, _font, _view_w, _config);
		var _off = __TextInputIndexFromX(_txt, _font, _local_x - _align_off, _config);
		return (_ln[$ "start"] ?? 0) + _off;
	};

	/// @ignore
	static __TextInputGetScrollX = function(_tb) {
		if (!is_struct(_tb)) {
			return 0;
		}
		return max(0, _tb.scroll_x ?? 0);
	};

	/// @ignore
	static __TextInputSetScrollX = function(_tb, _x) {
		if (!is_struct(_tb)) {
			return;
		}
		_tb.scroll_x = max(0, _x);
	};

	/// @ignore
	static __TextInputEnsureCaretVisible = function(_tb, _config, _view_w_override = undefined, _font_override = undefined, _caret_w_override = undefined) {
		if (!is_struct(_tb)) {
			return;
		}

		if (is_struct(_config) && _config[$ "multiline"] == true) {
			__TextAreaEnsureCaretVisible(_tb, _config);
			return;
		}

		var _view_w = is_struct(_config) ? max(0, _config[$ "view_w"] ?? 0) : 0;
		if (is_real(_view_w_override)) {
			_view_w = max(0, _view_w_override);
		}
		if (_view_w <= 0) {
			__TextInputSetScrollX(_tb, 0);
			return;
		}

		var _font = _font_override;
		var _font_ok = (_font == -1);
		if (!_font_ok && !is_undefined(_font)) {
			_font_ok = font_exists(_font);
		}
		if (!_font_ok) {
			_font = __ResolveTextboxFont(_tb, _config);
			_font_ok = (_font == -1);
			if (!_font_ok && !is_undefined(_font)) {
				_font_ok = font_exists(_font);
			}
		}
		if (!_font_ok) {
			_font = draw_get_font();
			_font_ok = (_font == -1);
			if (!_font_ok && !is_undefined(_font)) {
				_font_ok = font_exists(_font);
			}
		}
		if (!_font_ok) {
			_font = -1;
		}

		var _caret_w = 1;
		if (is_real(_caret_w_override)) {
			_caret_w = max(1, floor(_caret_w_override));
		}
		else {
			var _st = __GetResolvedStyleCachedForTb(_tb);
			if (is_struct(_st) && is_struct(_st.caret) && is_real(_st.caret.w)) {
				_caret_w = max(1, floor(_st.caret.w));
			}
		}

		var _src = __TextFromConfigMasked(_tb.GetValue(), _config);
		var _text_w = __TextMeasureVisualWidth(_src, _font, _config);
		var _pad = 2;
		var _content_w = _text_w + _caret_w + _pad;
		var _max_scroll_x = max(0, _content_w - _view_w);
		if (_max_scroll_x <= 0) {
			__TextInputSetScrollX(_tb, 0);
			return;
		}
		var _scroll_x = clamp(__TextInputGetScrollX(_tb), 0, _max_scroll_x);

		var _align_off = __TextGetAlignOffset(_src, _font, _view_w, _config);
		var _ci = clamp(_tb.caret_index, 0, string_length(_src));
		var _prefix = (_ci > 0) ? string_copy(_src, 1, _ci) : "";
		var _caret_x = (_ci > 0) ? __TextMeasureVisualWidth(_prefix, _font, _config) : 0;
		var _caret_local_x = _align_off + _caret_x;
		var _caret_right_x = _caret_local_x + _caret_w;

		if (_caret_local_x - _scroll_x < _pad) {
			_scroll_x = max(0, _caret_local_x - _pad);
		}
		else if (_caret_right_x - _scroll_x > (_view_w - _pad)) {
			_scroll_x = min(_max_scroll_x, _caret_right_x - (_view_w - _pad));
		}

		__TextInputSetScrollX(_tb, _scroll_x);
	};

	/// @ignore
	static __TextAreaUpdatePreferredXFromCaret = function(_tb, _config) {
		if (!is_struct(_config) || _config[$ "multiline"] != true) {
			_tb.preferred_x = 0;
			_tb.preferred_x_valid = false;
			return;
		}

		var _font = __ResolveTextboxFont(_tb, _config);
		var _layout = __GetActiveLayoutForTb(_tb, _config);
		if (!is_struct(_layout)) {
			_tb.preferred_x = 0;
			_tb.preferred_x_valid = false;
			return;
		}

		var _li = __TextAreaFindLineAtIndex(_layout, _tb.caret_index);
		var _lines = _layout.lines;
		if (!is_array(_lines) || _li < 0 || _li >= array_length(_lines)) {
			_tb.preferred_x = 0;
			_tb.preferred_x_valid = false;
			return;
		}
		var _ln = _lines[_li];
		var _s = _ln.start;
		var _local_i = clamp(_tb.caret_index - _s, 0, _ln.len);
		var _prefix = (_local_i > 0) ? string_copy(_ln.text, 1, _local_i) : "";
		var _prefix_w = (_local_i > 0) ? __TextMeasureVisualWidth(_prefix, _font, _config) : 0;
		var _view_w = max(0, _config[$ "view_w"] ?? 0);
		var _align_off = __TextGetAlignOffset(_ln.text, _font, _view_w, _config);
		_tb.preferred_x = _align_off + _prefix_w;
		_tb.preferred_x_valid = true;
	};

	/// @ignore
	static __TextAreaGetScrollY = function(_config) {
		var _st = is_struct(_config) ? _config[$ "scroll_state"] : undefined;
		if (is_struct(_st)) {
			return _st.scroll_y ?? 0;
		}
		return 0;
	};

	/// @ignore
	static __TextAreaGetScrollX = function(_tb, _config) {
		var _st = is_struct(_config) ? _config[$ "scroll_state"] : undefined;
		if (is_struct(_st)) {
			if (is_real(_st.scroll_x)) {
				return _st.scroll_x;
			}
		}
		return __TextInputGetScrollX(_tb);
	};

	/// @ignore
	static __TextAreaSetScrollX = function(_tb, _config, _x) {
		var _x2 = max(0, _x);
		__TextInputSetScrollX(_tb, _x2);
		var _st = is_struct(_config) ? _config[$ "scroll_state"] : undefined;
		if (is_struct(_st)) {
			_st.scroll_x = _x2;
		}
	};

	/// @ignore
	static __TextAreaSetScrollY = function(_config, _y) {
		var _st = is_struct(_config) ? _config[$ "scroll_state"] : undefined;
		if (is_struct(_st)) {
			_st.scroll_y = _y;
		}
	};

	/// @ignore
	static __TextAreaApplyWheelScroll = function(_tb, _config, _layout, _wheel_delta, _shift, _step) {
		if (!is_struct(_tb) || !is_struct(_config) || !is_struct(_layout) || _wheel_delta == 0) {
			return false;
		}

		var _view_w = max(0, _config[$ "view_w"] ?? 0);
		var _view_h = max(0, _config[$ "view_h"] ?? 0);
		var _step_use = max(1, floor(_step));
		if (_shift == true) {
			var _wrap = ((_config[$ "wrap"] ?? true) == true);
			if (!_wrap && _view_w > 0) {
				var _max_scroll_x = max(0, (_layout.content_w ?? 0) - _view_w);
				if (_max_scroll_x > 0) {
					var _next_x = __TextAreaGetScrollX(_tb, _config) - (_wheel_delta * _step_use);
					_next_x = __ClampScrollX(_next_x, (_layout.content_w ?? 0), _view_w);
					__TextAreaSetScrollX(_tb, _config, _next_x);
					return true;
				}
			}
		}

		if (_view_h <= 0) {
			return false;
		}
		var _max_scroll_y = max(0, _layout.content_h - _view_h);
		if (_max_scroll_y <= 0) {
			return false;
		}
		var _next_y = __TextAreaGetScrollY(_config) - (_wheel_delta * _step_use);
		_next_y = __ClampScroll(_next_y, _layout.content_h, _view_h);
		__TextAreaSetScrollY(_config, _next_y);
		return true;
	};

	/// @ignore
	static __TextAreaEnsureCaretVisible = function(_tb, _config) {
		if (!is_struct(_config) || _config[$ "multiline"] != true) {
			return;
		}

		var _font = __ResolveTextboxFont(_tb, _config);
		var _wrap = (_config[$ "wrap"] ?? true);
		var _view_w = max(0, _config[$ "view_w"] ?? 0);
		var _view_h = max(0, _config[$ "view_h"] ?? 0);
		if (_view_h <= 0) {
			return;
		}

		var _layout = __GetActiveLayoutForTb(_tb, _config);
		if (!is_struct(_layout)) {
			return;
		}

		var _lines = _layout.lines;
		var _count = is_array(_lines) ? array_length(_lines) : 0;
		if (_count <= 0) {
			return;
		}

		var _line_h = _layout.line_h;
		var _li = __TextAreaFindLineAtIndex(_layout, _tb.caret_index);
		_li = clamp(_li, 0, _count - 1);

		var _top = _li * _line_h;
		var _bot = _top + _line_h;

		var _scroll_y = __TextAreaGetScrollY(_config);
		if (_top < _scroll_y) {
			_scroll_y = _top;
		}
		else if (_bot > (_scroll_y + _view_h)) {
			_scroll_y = _bot - _view_h;
		}

		_scroll_y = __ClampScroll(_scroll_y, _layout.content_h, _view_h);
		__TextAreaSetScrollY(_config, _scroll_y);

		if (_wrap != true && _view_w > 0) {
			var _ln = _lines[_li];
			var _s = _ln.start;
			var _local_i = clamp(_tb.caret_index - _s, 0, _ln.len);
			var _prefix = (_local_i > 0) ? string_copy(_ln.text, 1, _local_i) : "";
			var _caret_x = (_local_i > 0) ? __TextMeasureVisualWidth(_prefix, _font, _config) : 0;
			var _max_scroll_x = max(0, (_layout.content_w ?? 0) - _view_w);
			var _scroll_x = clamp(__TextAreaGetScrollX(_tb, _config), 0, _max_scroll_x);
			var _pad = 2;
			if (_caret_x - _scroll_x < _pad) {
				_scroll_x = max(0, _caret_x - _pad);
			}
			else if (_caret_x - _scroll_x > (_view_w - _pad)) {
				_scroll_x = min(_max_scroll_x, _caret_x - (_view_w - _pad));
			}
			__TextAreaSetScrollX(_tb, _config, _scroll_x);
		}
		else {
			__TextAreaSetScrollX(_tb, _config, 0);
		}
	};

	/// @ignore
	static __TextAreaMoveCaretVertical = function(_tb, _dir, _extend_selection, _config) {
		if (!is_struct(_config) || _config[$ "multiline"] != true) {
			return;
		}

		var _font = __ResolveTextboxFont(_tb, _config);
		var _layout = __GetActiveLayoutForTb(_tb, _config);
		if (!is_struct(_layout)) {
			return;
		}

		var _lines = _layout.lines;
		var _count = is_array(_lines) ? array_length(_lines) : 0;
		if (_count <= 0) {
			return;
		}

		if (!_tb.preferred_x_valid) {
			__TextAreaUpdatePreferredXFromCaret(_tb, _config);
		}
		var _px = _tb.preferred_x_valid ? _tb.preferred_x : 0;

		var _cur = __TextAreaFindLineAtIndex(_layout, _tb.caret_index);
		var _next = clamp(_cur + _dir, 0, _count - 1);
		if (_next == _cur) {
			return;
		}

		var _ln = _lines[_next];
		var _view_w2 = max(0, _config[$ "view_w"] ?? 0);
		var _align_off2 = __TextGetAlignOffset(_ln.text, _font, _view_w2, _config);
		var _off = __TextInputIndexFromX(_ln.text, _font, _px - _align_off2, _config);
		var _idx = _ln.start + _off;

		__TextInputSetCaretEx(_tb, _idx, _extend_selection, false, _config);
		__TextAreaEnsureCaretVisible(_tb, _config);
	};
}

function QuillEnsure() {
	if (is_instanceof(QUILL, __QuillCore)) return true;
	
	// Something has destroyed Quill, so rebuild it
	QUILL = new __QuillCore();
	return false;
}

// Global singleton (created once).
global.__QUILL_CORE = new __QuillCore();
