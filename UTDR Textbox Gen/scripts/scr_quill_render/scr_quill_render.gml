/// @ignore
function __QuillRenderPushScissorGui(_x1, _y1, _x2, _y2) {
	var _prev = gpu_get_scissor();

	var _gw = display_get_gui_width();
	var _gh = display_get_gui_height();
	var _pos = application_get_position();
	var _ax = 0;
	var _ay = 0;
	var _aw = 640;
	var _ah = 480;
	if (is_array(_pos) && array_length(_pos) >= 4) {
		_ax = 0;
		_ay = 0;
		_aw = 640;
		_ah = 480;
	}

	var _sx = (_gw > 0) ? (_aw / _gw) : 1;
	var _sy = (_gh > 0) ? (_ah / _gh) : 1;

	var _x = floor(_ax + (_x1 * _sx));
	var _y = floor(_ay + (_y1 * _sy));
	var _w = ceil(max(0, (_x2 - _x1)) * _sx);
	var _h = ceil(max(0, (_y2 - _y1)) * _sy);
	gpu_set_scissor(_x, _y, _w, _h);
	return _prev;
}

/// @ignore
function __QuillRenderPopScissor(_prev) {
	if (is_struct(_prev)) {
		gpu_set_scissor(_prev);
	}
}

/// @ignore
function __QuillRenderDrawSpriteSkin(_spr, _subimg, _x, _y, _w, _h, _col, _alpha) {
	if (_spr != -1 && sprite_exists(_spr)) {
		var _sprite_name = sprite_get_name(_spr);
		draw_sprite_stretched_ext(_spr, _subimg, _x, _y, _w, _h, _col, _alpha);
		return true;
	}
	return false;
}

/// @ignore
function __QuillRenderGetBorderSpriteOutsideInsets(_spr, _outside_draw) {
	var _out = {
		left: 0,
		top: 0,
		right: 0,
		bottom: 0
	};
	if (_outside_draw != true) {
		return _out;
	}
	if (_spr == -1 || !sprite_exists(_spr)) {
		return _out;
	}

	var _ns = sprite_get_nineslice(_spr);
	if (!is_struct(_ns)) {
		return _out;
	}
	if (_ns.enabled != true) {
		return _out;
	}

	_out.left = max(0, _ns.left);
	_out.top = max(0, _ns.top);
	_out.right = max(0, _ns.right);
	_out.bottom = max(0, _ns.bottom);
	return _out;
}

/// @ignore
function __QuillRenderGetBorderSpriteInsideInsets(_spr, _outside_draw) {
	var _in = {
		left: 0,
		top: 0,
		right: 0,
		bottom: 0
	};
	if (_outside_draw == true) {
		return _in;
	}
	if (_spr == -1 || !sprite_exists(_spr)) {
		return _in;
	}

	var _ns = sprite_get_nineslice(_spr);
	if (!is_struct(_ns)) {
		return _in;
	}
	if (_ns.enabled != true) {
		return _in;
	}

	_in.left = max(0, _ns.left);
	_in.top = max(0, _ns.top);
	_in.right = max(0, _ns.right);
	_in.bottom = max(0, _ns.bottom);
	return _in;
}

/// @ignore
function __QuillRenderGetSkinBorderOutsideInsets(_t_skins) {
	if (!is_struct(_t_skins)) {
		return {
			left: 0,
			top: 0,
			right: 0,
			bottom: 0
		};
	}
	return __QuillRenderGetBorderSpriteOutsideInsets(_t_skins.border_spr, _t_skins.border_spr_outside_draw);
}

/// @ignore
function __QuillRenderGetSkinBorderInsideInsets(_t_skins) {
	if (!is_struct(_t_skins)) {
		return {
			left: 0,
			top: 0,
			right: 0,
			bottom: 0
		};
	}
	return __QuillRenderGetBorderSpriteInsideInsets(_t_skins.border_spr, _t_skins.border_spr_outside_draw);
}

/// @ignore
function __QuillRenderGetLabelBorderOutsideInsets(_t_label) {
	if (!is_struct(_t_label)) {
		return {
			left: 0,
			top: 0,
			right: 0,
			bottom: 0
		};
	}
	return __QuillRenderGetBorderSpriteOutsideInsets(_t_label.border_spr, _t_label.border_spr_outside_draw);
}

/// @ignore
function __QuillRenderGetLabelBorderInsideInsets(_t_label) {
	if (!is_struct(_t_label)) {
		return {
			left: 0,
			top: 0,
			right: 0,
			bottom: 0
		};
	}
	return __QuillRenderGetBorderSpriteInsideInsets(_t_label.border_spr, _t_label.border_spr_outside_draw);
}

/// @ignore
function __QuillVbGetFormat() {
	static _fmt = -1;
	if (_fmt < 0) {
		vertex_format_begin();
		vertex_format_add_position();
		vertex_format_add_colour();
		_fmt = vertex_format_end();
	}
	return _fmt;
}

/// @ignore
function __QuillVbWriteQuad(_vb, _x1, _y1, _x2, _y2, _col, _a) {
	vertex_position(_vb, _x1, _y1); vertex_colour(_vb, _col, _a);
	vertex_position(_vb, _x2, _y1); vertex_colour(_vb, _col, _a);
	vertex_position(_vb, _x2, _y2); vertex_colour(_vb, _col, _a);
	vertex_position(_vb, _x1, _y1); vertex_colour(_vb, _col, _a);
	vertex_position(_vb, _x2, _y2); vertex_colour(_vb, _col, _a);
	vertex_position(_vb, _x1, _y2); vertex_colour(_vb, _col, _a);
}

/// @ignore
function __QuillVbWriteBorder(_vb, _w, _h, _t, _col, _a) {
	var _th = clamp(_t, 0, min(_w * 0.5, _h * 0.5));
	if (_th <= 0) {
		return;
	}

	__QuillVbWriteQuad(_vb, 0, 0, _w, _th, _col, _a);
	__QuillVbWriteQuad(_vb, 0, _h - _th, _w, _h, _col, _a);
	__QuillVbWriteQuad(_vb, 0, _th, _th, _h - _th, _col, _a);
	__QuillVbWriteQuad(_vb, _w - _th, _th, _w, _h - _th, _col, _a);
}

/// @ignore
function __QuillVbSigEqBox(_a, _b) {
	if (!is_struct(_a) || !is_struct(_b)) return false;
	if (_a.w != _b.w) return false;
	if (_a.h != _b.h) return false;
	if (_a.need_bg != _b.need_bg) return false;
	if (_a.need_border != _b.need_border) return false;
	if (_a.bg_col != _b.bg_col) return false;
	if (_a.bg_a != _b.bg_a) return false;
	if (_a.border_col != _b.border_col) return false;
	if (_a.border_a != _b.border_a) return false;
	if (_a.border_thickness != _b.border_thickness) return false;
	return true;
}

/// @ignore
function __QuillVbSigEqScrollTrack(_a, _b) {
	if (!is_struct(_a) || !is_struct(_b)) return false;
	if (_a.w != _b.w) return false;
	if (_a.h != _b.h) return false;
	if (_a.need_bg != _b.need_bg) return false;
	if (_a.need_border != _b.need_border) return false;
	if (_a.track_col != _b.track_col) return false;
	if (_a.track_a != _b.track_a) return false;
	if (_a.border_col != _b.border_col) return false;
	if (_a.border_a != _b.border_a) return false;
	return true;
}

/// @ignore
function __QuillVbSubmitTranslated(_vb, _x, _y, _dbg_key) {
	if (_vb < 0) {
		return;
	}
	if (!vertex_buffer_exists(_vb)) {
		return;
	}

	var _mw = matrix_get(matrix_world);
	var _mt = matrix_build(_x, _y, 0, 0, 0, 0, 1, 1, 1);
	var _m_out = matrix_multiply(_mw, _mt);
	matrix_set(matrix_world, _m_out);
	vertex_submit(_vb, pr_trianglelist, -1);
	matrix_set(matrix_world, _mw);
	QUILL.__VbDebugCountSubmit(_dbg_key);
}

/// @ignore
function __QuillVbEnsureBox(_cache, _sig) {
	if (!is_struct(_cache)) return -1;
	var _render = _cache[$ "render"];
	if (!is_struct(_render)) return -1;

	var _state_key = string(_sig[$ "state_key"] ?? "idle");
	var _variants = _render[$ "box_variants"];
	if (!is_struct(_variants)) {
		_variants = {};
		_render[$ "box_variants"] = _variants;
	}

	var _variant = _variants[$ _state_key];
	if (!is_struct(_variant)) {
		_variant = {
			vb: -1,
			sig: undefined,
			frozen: false,
			stable: 0,
			stable_frame: -1
		};
		_variants[$ _state_key] = _variant;
	}

	var _sig_prev = _variant[$ "sig"];
	var _same = __QuillVbSigEqBox(_sig_prev, _sig);
	var _vb_prev = _variant[$ "vb"] ?? -1;
	if (_same) {
		if (_vb_prev >= 0 && !vertex_buffer_exists(_vb_prev)) {
			_same = false;
		}
		if ((_sig.need_bg != true && _sig.need_border != true) && _vb_prev >= 0) {
			_same = false;
		}
	}
	if (!_same) {
		var _old = _variant[$ "vb"];
		if (is_real(_old) && _old >= 0 && vertex_buffer_exists(_old)) {
			vertex_delete_buffer(_old);
		}

		if (_sig.need_bg != true && _sig.need_border != true) {
			_variant[$ "vb"] = -1;
			_variant[$ "sig"] = _sig;
			_variant[$ "frozen"] = false;
			_variant[$ "stable"] = 0;
			_variant[$ "stable_frame"] = QUILL._frame_i;
			return -1;
		}

		var _vb = vertex_create_buffer();
		var _fmt = __QuillVbGetFormat();
		_render[$ "fmt_ready"] = (_fmt >= 0);
		vertex_begin(_vb, _fmt);
		if (_sig.need_bg == true) {
			__QuillVbWriteQuad(_vb, 0, 0, _sig.w, _sig.h, _sig.bg_col, _sig.bg_a);
		}
		if (_sig.need_border == true) {
			__QuillVbWriteBorder(_vb, _sig.w, _sig.h, _sig.border_thickness, _sig.border_col, _sig.border_a);
		}
		vertex_end(_vb);

		_variant[$ "vb"] = _vb;
		_variant[$ "sig"] = _sig;
		_variant[$ "frozen"] = false;
		_variant[$ "stable"] = 0;
		_variant[$ "stable_frame"] = QUILL._frame_i;
		QUILL.__VbDebugCountRebuild(_state_key);
		return _vb;
	}

	var _vb_existing = _variant[$ "vb"] ?? -1;
	if (is_real(_vb_existing) && _vb_existing >= 0 && vertex_buffer_exists(_vb_existing)) {
		if (_variant[$ "stable_frame"] != QUILL._frame_i) {
			_variant[$ "stable"] = (_variant[$ "stable"] ?? 0) + 1;
			_variant[$ "stable_frame"] = QUILL._frame_i;
		}
		if (_variant[$ "frozen"] != true && (_variant[$ "stable"] ?? 0) >= QUILL_VB_FREEZE_FRAMES) {
			vertex_freeze(_vb_existing);
			_variant[$ "frozen"] = true;
		}
	}
	else {
		_variant[$ "vb"] = -1;
		_variant[$ "frozen"] = false;
	}
	return _vb_existing;
}

/// @ignore
function __QuillVbEnsureScrollTrack(_cache, _sig, _axis = "v") {
	if (!is_struct(_cache)) return -1;
	var _render = _cache[$ "render"];
	if (!is_struct(_render)) return -1;

	var _suffix = (_axis == "h") ? "_h" : "";
	var _vb_key = "vb_scroll_track" + _suffix;
	var _sig_key = "sig_scroll_track" + _suffix;
	var _frozen_key = "frozen_scroll_track" + _suffix;
	var _stable_key = "stable_scroll_track" + _suffix;
	var _stable_frame_key = "stable_frame_scroll_track" + _suffix;

	var _sig_prev = _render[$ _sig_key];
	var _same = __QuillVbSigEqScrollTrack(_sig_prev, _sig);
	var _vb_prev = _render[$ _vb_key] ?? -1;
	if (_same) {
		if (_vb_prev >= 0 && !vertex_buffer_exists(_vb_prev)) {
			_same = false;
		}
		if ((_sig.need_bg != true && _sig.need_border != true) && _vb_prev >= 0) {
			_same = false;
		}
	}
	if (!_same) {
		var _old = _render[$ _vb_key];
		if (is_real(_old) && _old >= 0 && vertex_buffer_exists(_old)) {
			vertex_delete_buffer(_old);
		}

		if (_sig.need_bg != true && _sig.need_border != true) {
			_render[$ _vb_key] = -1;
			_render[$ _sig_key] = _sig;
			_render[$ _frozen_key] = false;
			_render[$ _stable_key] = 0;
			_render[$ _stable_frame_key] = QUILL._frame_i;
			return -1;
		}

		var _vb = vertex_create_buffer();
		var _fmt = __QuillVbGetFormat();
		_render[$ "fmt_ready"] = (_fmt >= 0);
		vertex_begin(_vb, _fmt);
		if (_sig.need_bg == true) {
			__QuillVbWriteQuad(_vb, 0, 0, _sig.w, _sig.h, _sig.track_col, _sig.track_a);
		}
		if (_sig.need_border == true) {
			__QuillVbWriteBorder(_vb, _sig.w, _sig.h, 1, _sig.border_col, _sig.border_a);
		}
		vertex_end(_vb);

		_render[$ _vb_key] = _vb;
		_render[$ _sig_key] = _sig;
		_render[$ _frozen_key] = false;
		_render[$ _stable_key] = 0;
		_render[$ _stable_frame_key] = QUILL._frame_i;
		return _vb;
	}

	var _vb_existing = _render[$ _vb_key] ?? -1;
	if (is_real(_vb_existing) && _vb_existing >= 0 && vertex_buffer_exists(_vb_existing)) {
		if (_render[$ _stable_frame_key] != QUILL._frame_i) {
			_render[$ _stable_key] = (_render[$ _stable_key] ?? 0) + 1;
			_render[$ _stable_frame_key] = QUILL._frame_i;
		}
		if (_render[$ _frozen_key] != true && (_render[$ _stable_key] ?? 0) >= QUILL_VB_FREEZE_FRAMES) {
			vertex_freeze(_vb_existing);
			_render[$ _frozen_key] = true;
		}
	}
	else {
		_render[$ _vb_key] = -1;
		_render[$ _frozen_key] = false;
	}
	return _vb_existing;
}

/// @ignore
function __QuillRenderLabelPickFont(_st) {
	var _font = _st.fonts.label;
	if (!font_exists(_font)) {
		_font = _st.fonts.body;
	}
	if (!font_exists(_font)) {
		_font = draw_get_font();
	}
	return _font;
}

/// @ignore
function __QuillRenderLabelFitEllipsis(_text, _max_w) {
	var _s = string(_text);
	var _nl = string_pos("\n", _s);
	if (_nl > 0) {
		_s = string_copy(_s, 1, _nl - 1);
	}

	if (_max_w <= 0) {
		return "";
	}
	if (string_width(_s) <= _max_w) {
		return _s;
	}

	var _ellipsis = "...";
	var _ellipsis_w = string_width(_ellipsis);
	if (_ellipsis_w > _max_w) {
		return "";
	}

	var _len = string_length(_s);
	while (_len > 0) {
		var _prefix = string_copy(_s, 1, _len);
		if (string_width(_prefix) + _ellipsis_w <= _max_w) {
			return _prefix + _ellipsis;
		}
		_len -= 1;
	}
	return _ellipsis;
}

/// @ignore
function __QuillRenderBuildLabelLayout(_tb, _st, _tb_x1, _tb_y1, _tb_x2, _tb_y2) {
	if (!is_struct(_tb) || !is_struct(_st) || !is_struct(_st.label)) {
		return undefined;
	}
	if (_tb.label_visible != true) {
		return undefined;
	}

	var _label_text = string(_tb.label_text);
	if (string_length(_label_text) <= 0) {
		return undefined;
	}

	var _t_label = _st.label;
	var _font = __QuillRenderLabelPickFont(_st);
	var _old_font = draw_get_font();
	draw_set_font(_font);

	var _pad_l = max(0, floor(_t_label.pad_l));
	var _pad_t = max(0, floor(_t_label.pad_t));
	var _pad_r = max(0, floor(_t_label.pad_r));
	var _pad_b = max(0, floor(_t_label.pad_b));

	var _margin_l = max(0, floor(_t_label.margin_l));
	var _margin_t = max(0, floor(_t_label.margin_t));
	var _margin_r = max(0, floor(_t_label.margin_r));
	var _margin_b = max(0, floor(_t_label.margin_b));

	var _line_h = string_height("Ag");
	var _lines = [];
	var _line_count = 0;
	var _content_w = max(0, floor(_tb.label_width));
	var _content_h = _line_h;
	var _overflow = _tb.label_overflow;
	if (_overflow != eQuillLabelOverflow.Ellipsis) {
		_overflow = eQuillLabelOverflow.Wrap;
	}

	if (_overflow == eQuillLabelOverflow.Ellipsis) {
		if (_content_w <= 0) {
			var _line_src = _label_text;
			var _nl = string_pos("\n", _line_src);
			if (_nl > 0) {
				_line_src = string_copy(_line_src, 1, _nl - 1);
			}
			_content_w = string_width(_line_src);
		}
		var _line = __QuillRenderLabelFitEllipsis(_label_text, _content_w);
		array_push(_lines, _line);
		_line_count = 1;
		_content_h = _line_h;
	}
	else {
		var _wrap_on = (_content_w > 0);
		var _layout = QUILL.__TextAreaBuildLayout(_label_text, _font, _wrap_on, _content_w, undefined);
		if (!is_struct(_layout) || !is_array(_layout.lines)) {
			draw_set_font(_old_font);
			return undefined;
		}

		var _layout_lines = _layout.lines;
		var _n = array_length(_layout_lines);
		var _max_line_w = 0;
		for (var i = 0; i < _n; i++) {
			var _ln = _layout_lines[i];
			if (!is_struct(_ln)) {
				continue;
			}
			var _draw_text = string(_ln.text_draw ?? _ln.text);
			array_push(_lines, _draw_text);
			var _w = string_width(_draw_text);
			if (_w > _max_line_w) {
				_max_line_w = _w;
			}
		}

		_line_count = array_length(_lines);
		if (_line_count <= 0) {
			array_push(_lines, "");
			_line_count = 1;
		}
		_content_h = max(_line_h, (_line_count * _line_h));
		if (_content_w <= 0) {
			_content_w = _max_line_w;
		}
	}

	draw_set_font(_old_font);

	var _label_border_in = __QuillRenderGetLabelBorderInsideInsets(_t_label);
	var _label_w = _pad_l + _content_w + _pad_r + _label_border_in.left + _label_border_in.right;
	var _label_h = _pad_t + _content_h + _pad_b + _label_border_in.top + _label_border_in.bottom;
	var _label_border_out = __QuillRenderGetLabelBorderOutsideInsets(_t_label);
	var _tb_w = max(0, _tb_x2 - _tb_x1);
	var _tb_h = max(0, _tb_y2 - _tb_y1);
	var _offset = max(0, floor(_tb.label_offset));

	var _x1 = _tb_x1;
	var _y1 = _tb_y1;
	if (_tb.label_placement == eQuillLabelPlacement.Leading) {
		var _x2 = _tb_x1 - _offset - _margin_r - _label_border_out.right;
		_x1 = _x2 - _label_w;
		if (_tb.label_align == eQuillLabelAlign.Center) {
			_y1 = _tb_y1 + floor((_tb_h - _label_h) * 0.5) + _margin_t - _margin_b;
		}
		else {
			_y1 = _tb_y1 + _margin_t;
		}
	}
	else {
		var _y2 = _tb_y1 - _offset - _margin_b - _label_border_out.bottom;
		_y1 = _y2 - _label_h;
		if (_tb.label_align == eQuillLabelAlign.Center) {
			_x1 = _tb_x1 + floor((_tb_w - _label_w) * 0.5) + _margin_l - _margin_r;
		}
		else {
			_x1 = _tb_x1 + _margin_l;
		}
	}

	var _inner_x1 = _x1;
	var _inner_y1 = _y1;
	var _inner_x2 = _inner_x1 + _label_w;
	var _inner_y2 = _inner_y1 + _label_h;
	var _outer_x1 = _inner_x1 - _label_border_out.left;
	var _outer_y1 = _inner_y1 - _label_border_out.top;
	var _outer_x2 = _inner_x2 + _label_border_out.right;
	var _outer_y2 = _inner_y2 + _label_border_out.bottom;
	var _text_x1 = _inner_x1 + _label_border_in.left + _pad_l;
	var _text_y1 = _inner_y1 + _label_border_in.top + _pad_t;
	var _text_x2 = _inner_x2 - _label_border_in.right - _pad_r;
	var _text_y2 = _inner_y2 - _label_border_in.bottom - _pad_b;

	return {
		font: _font,
		overflow: _overflow,
		line_h: _line_h,
		lines: _lines,
		content_w: _content_w,
		content_h: _content_h,
		label_rect: { x1: _outer_x1, y1: _outer_y1, x2: _outer_x2, y2: _outer_y2 },
		label_inner_rect: { x1: _inner_x1, y1: _inner_y1, x2: _inner_x2, y2: _inner_y2 },
		text_rect: { x1: _text_x1, y1: _text_y1, x2: _text_x2, y2: _text_y2 }
	};
}

/// @ignore
function __QuillRenderDrawLabel(_tb, _st, _layout) {
	if (!is_struct(_tb) || !is_struct(_st) || !is_struct(_layout) || !is_struct(_st.label)) {
		return;
	}

	var _t_label = _st.label;
	var _rect = _layout.label_inner_rect;
	if (!is_struct(_rect)) {
		_rect = _layout.label_rect;
	}
	if (!is_struct(_rect)) {
		return;
	}

	var _x1 = _rect.x1;
	var _y1 = _rect.y1;
	var _x2 = _rect.x2;
	var _y2 = _rect.y2;
	var _w = max(0, _x2 - _x1);
	var _h = max(0, _y2 - _y1);
	if (_w <= 0 || _h <= 0) {
		return;
	}

	var _bg_a = clamp(_t_label.prim_bg_a, 0, 1);
	var _border_a = clamp(_t_label.prim_border_a, 0, 1);
	var _text_a = clamp(_t_label.text_a, 0, 1);
	var _border_t = _t_label.prim_border_thickness;
	var _draw_bg = (_bg_a > 0);
	var _draw_border = (_border_a > 0 && _border_t > 0);

	var _old_a = draw_get_alpha();
	var _need_bg_prim = _draw_bg;
	var _need_bd_prim = _draw_border;
	var _border_rect = _layout.label_rect;
	var _bd_x1 = _x1;
	var _bd_y1 = _y1;
	var _bd_x2 = _x2;
	var _bd_y2 = _y2;
	if (is_struct(_border_rect)) {
		_bd_x1 = _border_rect.x1;
		_bd_y1 = _border_rect.y1;
		_bd_x2 = _border_rect.x2;
		_bd_y2 = _border_rect.y2;
	}
	var _bd_w = max(0, _bd_x2 - _bd_x1);
	var _bd_h = max(0, _bd_y2 - _bd_y1);
	if (_draw_bg && __QuillRenderDrawSpriteSkin(_t_label.bg_spr, _t_label.bg_subimg, _x1, _y1, _w, _h, _t_label.prim_bg_col, _bg_a)) {
		_need_bg_prim = false;
	}
	if (_draw_border && __QuillRenderDrawSpriteSkin(_t_label.border_spr, _t_label.border_subimg, _bd_x1, _bd_y1, _bd_w, _bd_h, _t_label.prim_border_col, _border_a)) {
		_need_bd_prim = false;
	}

	var _vb = -1;
	if (QUILL_VB_ENABLE) {
		var _cache = QUILL.__GetBoxCacheById(_tb.id);
		var _sig = {
			w: _w,
			h: _h,
			state_key: "label",
			need_bg: _need_bg_prim,
			need_border: _need_bd_prim,
			bg_col: _t_label.prim_bg_col,
			bg_a: _bg_a,
			border_col: _t_label.prim_border_col,
			border_a: _border_a,
			border_thickness: _border_t
		};
		_vb = __QuillVbEnsureBox(_cache, _sig);
	}

	if (_vb >= 0) {
		draw_set_alpha(_old_a);
		__QuillVbSubmitTranslated(_vb, _x1, _y1, "");
	}
	else if (_need_bg_prim || _need_bd_prim) {
		if (_need_bg_prim) {
			draw_set_alpha(_old_a * _bg_a);
			draw_set_color(_t_label.prim_bg_col);
			draw_rectangle(_x1, _y1, _x2, _y2, false);
		}
		if (_need_bd_prim) {
			draw_set_alpha(_old_a * _border_a);
			draw_set_color(_t_label.prim_border_col);
			__QuillRenderDrawBorderPrimitive(_x1, _y1, _x2, _y2, _border_t);
		}
	}

	if (_text_a > 0 && is_struct(_layout.text_rect) && is_array(_layout.lines)) {
		var _old_font = draw_get_font();
		draw_set_font(_layout.font);
		draw_set_color(_t_label.text_col);
		draw_set_alpha(_old_a * _text_a);

		var _text_rect = _layout.text_rect;
		var _tx = _text_rect.x1;
		var _ty = _text_rect.y1;
		var _line_h = max(1, _layout.line_h);
		var _line_count = array_length(_layout.lines);

		if (_layout.overflow == eQuillLabelOverflow.Ellipsis) {
			var _line_text = (_line_count > 0) ? string(_layout.lines[0]) : "";
			var _text_h = _line_h;
			var _y_text = _ty + max(0, floor((max(0, _layout.content_h) - _text_h) * 0.5));
			draw_text(_tx, _y_text, _line_text);
		}
		else {
			for (var i = 0; i < _line_count; i++) {
				draw_text(_tx, _ty + (i * _line_h), _layout.lines[i]);
			}
		}

		draw_set_font(_old_font);
	}

	draw_set_alpha(_old_a);
}

/// @ignore
function __QuillRenderDrawTextBox(_tb, _st, _x1, _y1, _x2, _y2, _active, _hover) {
	var _t_skins = _st.skins;
	var _w = max(0, _x2 - _x1);
	var _h = max(0, _y2 - _y1);
	var _cfg = _tb.config;
	var _disabled = (_tb.enabled != true);
	var _invalid = (_tb.validation_visible == true && string_length(string(_tb.validation_message)) > 0);

	var _col_bg = _t_skins.prim_bg_idle_col;
	var _a_bg = _t_skins.prim_bg_idle_a;
	var _col_bd = _t_skins.prim_border_idle_col;
	var _a_bd = _t_skins.prim_border_idle_a;
	var _state_key = "idle";
	if (_disabled) {
		_state_key = "disabled";
		_col_bg = _t_skins.prim_bg_disabled_col;
		_a_bg = _t_skins.prim_bg_disabled_a;
		_col_bd = _t_skins.prim_border_disabled_col;
		_a_bd = _t_skins.prim_border_disabled_a;
	}
	else if (_invalid) {
		_state_key = "invalid";
		_col_bg = _t_skins.prim_bg_invalid_col;
		_a_bg = _t_skins.prim_bg_invalid_a;
		_col_bd = _t_skins.prim_border_invalid_col;
		_a_bd = _t_skins.prim_border_invalid_a;
	}
	else if (_active) {
		_state_key = "active";
		_col_bg = _t_skins.prim_bg_active_col;
		_a_bg = _t_skins.prim_bg_active_a;
		_col_bd = _t_skins.prim_border_active_col;
		_a_bd = _t_skins.prim_border_active_a;
	}
	else if (_hover) {
		_state_key = "hover";
		_col_bg = _t_skins.prim_bg_hover_col;
		_a_bg = _t_skins.prim_bg_hover_a;
		_col_bd = _t_skins.prim_border_hover_col;
		_a_bd = _t_skins.prim_border_hover_a;
	}

	var _old_a = draw_get_alpha();
	var _need_bg_prim = true;
	var _need_bd_prim = true;
	var _bd_out = __QuillRenderGetSkinBorderOutsideInsets(_t_skins);
	var _bd_x1 = _x1 - _bd_out.left;
	var _bd_y1 = _y1 - _bd_out.top;
	var _bd_x2 = _x2 + _bd_out.right;
	var _bd_y2 = _y2 + _bd_out.bottom;
	var _bd_w = max(0, _bd_x2 - _bd_x1);
	var _bd_h = max(0, _bd_y2 - _bd_y1);
	if (__QuillRenderDrawSpriteSkin(_t_skins.bg_spr, _t_skins.bg_subimg, _x1, _y1, _w, _h, _col_bg, _a_bg)) {
		_need_bg_prim = false;
	}

	if (__QuillRenderDrawSpriteSkin(_t_skins.border_spr, _t_skins.border_subimg, _bd_x1, _bd_y1, _bd_w, _bd_h, _col_bd, _a_bd)) {
		_need_bd_prim = false;
	}

	var _border_thickness = _t_skins.prim_border_thickness;
	var _vb = -1;
	if (QUILL_VB_ENABLE) {
		var _cache = QUILL.__GetBoxCacheById(_tb.id);
		var _sig = {
			w: _w,
			h: _h,
			state_key: _state_key,
			need_bg: _need_bg_prim,
			need_border: _need_bd_prim,
			bg_col: _col_bg,
			bg_a: _a_bg,
			border_col: _col_bd,
			border_a: _a_bd,
			border_thickness: _border_thickness
		};
		_vb = __QuillVbEnsureBox(_cache, _sig);
	}

	if (_vb >= 0) {
		draw_set_alpha(_old_a);
		__QuillVbSubmitTranslated(_vb, _x1, _y1, "");
	}
	else if (_need_bg_prim || _need_bd_prim) {
		if (_need_bg_prim) {
			draw_set_alpha(_old_a * _a_bg);
			draw_set_color(_col_bg);
			draw_rectangle(_x1, _y1, _x2, _y2, false);
		}
		if (_need_bd_prim) {
			draw_set_alpha(_old_a * _a_bd);
			draw_set_color(_col_bd);
			__QuillRenderDrawBorderPrimitive(_x1, _y1, _x2, _y2, _border_thickness);
		}
	}

	draw_set_alpha(_old_a);
}

/// @ignore
function __QuillRenderDrawBorderPrimitive(_x1, _y1, _x2, _y2, _thickness) {
	var _w = max(0, _x2 - _x1);
	var _h = max(0, _y2 - _y1);
	if (_w <= 0 || _h <= 0) {
		return;
	}

	var _t = floor(_thickness);
	var _t_max = floor(min(_w * 0.5, _h * 0.5));
	if (_t > _t_max) {
		_t = _t_max;
	}
	if (_t <= 0) {
		return;
	}

	draw_rectangle(_x1, _y1, _x2, _y1 + _t, false);
	draw_rectangle(_x1, _y2 - _t, _x2, _y2, false);
	draw_rectangle(_x1, _y1 + _t, _x1 + _t, _y2 - _t, false);
	draw_rectangle(_x2 - _t, _y1 + _t, _x2, _y2 - _t, false);
}

/// @ignore
function __QuillRenderDrawSelectionSingle(_t_sel, _x, _y, _h, _x1, _x2) {
	var _old_a = draw_get_alpha();
	draw_set_alpha(_old_a * _t_sel.bg_a);
	draw_set_color(_t_sel.bg_col);
	draw_rectangle(_x + _x1, _y, _x + _x2, _y + _h, false);
	draw_set_alpha(_old_a);
}

/// @ignore
function __QuillRenderDrawCaret(_st, _x, _y, _h, _fade, _fadespd) {
	var _t_skins = _st.skins;
	if (__QuillRenderDrawSpriteSkin(_t_skins.caret_spr, _t_skins.caret_subimg, _x, _y, _st.caret.w, _h, _st.caret.col, _st.caret.a)) {
		return;
	}
	var _old_a = draw_get_alpha(), _anim = abs(sin(current_time/ _fadespd));
	draw_set_alpha(!_fade ? _old_a * _st.caret.a : _anim);
	draw_set_color(_st.caret.col);
	draw_rectangle(_x, _y, _x + _st.caret.w, ( _y + _h ) + 4, false);
	draw_set_alpha(_old_a);
}

/// @ignore
function __QuillRenderDrawTextSingle(_tb, _st, _config, _text_rect, _active) {
	var _font = global.__QUILL_CORE.__ResolveTextboxFont(_tb, _config, _st);
	var _read_only = (_config[$ "read_only"] == true);
	var _enabled = (_tb.enabled == true);

	var _raw = _tb.GetValue();
	var _src = global.__QUILL_CORE.__TextFromConfigMasked(_raw, _config);

	var _is_placeholder = false;
	var _draw_text = _src;
	if (string_length(_src) <= 0 && !_active) {
		_draw_text = string(_tb.placeholder);
		_is_placeholder = true;
	}
	var _draw_text_vis = global.__QUILL_CORE.__TextExpandTabsForVisual(_draw_text, _config);

	var _old_font = draw_get_font();
	draw_set_font(_font);

	var _view_w = max(0, _text_rect.x2 - _text_rect.x1);
	global.__QUILL_CORE.__TextInputEnsureCaretVisible(_tb, _config, _view_w, _font, _st.caret.w);
	var _scroll_x = global.__QUILL_CORE.__TextInputGetScrollX(_tb);
	var _align_off = global.__QUILL_CORE.__TextGetAlignOffset(_draw_text, _font, _view_w, _config);
	var _tx = (_text_rect.x1 - _scroll_x) + _align_off;
	var _ty = _text_rect.y1 + max(0, floor(((_text_rect.y2 - _text_rect.y1) - string_height("Ag")) * 0.5));
	var _clip_prev = __QuillRenderPushScissorGui(_text_rect.x1 - 2, _text_rect.y1 - 2, _text_rect.x2 + 2, _text_rect.y2 + 2);

	if (_enabled && _active && !_is_placeholder && global.__QUILL_CORE.__TextInputHasSelection(_tb)) {
		var _sel = global.__QUILL_CORE.__TextInputGetSelectionRange(_tb);
		var _a = min(_sel.start, _sel._end);
		var _b = max(_sel.start, _sel._end);
		var _pre = (_a > 0) ? string_copy(_draw_text, 1, _a) : "";
		var _mid = (_b > _a) ? string_copy(_draw_text, _a + 1, _b - _a) : "";
		var _x1 = (_a > 0) ? global.__QUILL_CORE.__TextMeasureVisualWidth(_pre, _font, _config) : 0;
		var _x2 = _x1 + ((string_length(_mid) > 0) ? global.__QUILL_CORE.__TextMeasureVisualWidth(_mid, _font, _config) : 0);
		__QuillRenderDrawSelectionSingle(_st.selection, _tx, _text_rect.y1, _text_rect.y2 - _text_rect.y1, _x1, _x2);
	}

	var _old_a = draw_get_alpha();
	if (!_enabled) {
		draw_set_alpha(_old_a * _st.textbox.disabled_text_a);
		draw_set_color(_st.textbox.disabled_text_col);
	}
	else if (_is_placeholder) {
		draw_set_alpha(_old_a * _st.textbox.placeholder_a);
		draw_set_color(_st.textbox.placeholder_col);
	}
	else {
		draw_set_alpha(_old_a * _st.textbox.text_a);
		draw_set_color(_st.textbox.text_col);
	}
	draw_text(_tx, _ty, _draw_text_vis);
	draw_set_alpha(_old_a);

	if (_enabled && _active && !_read_only && !_is_placeholder) {
		var _blink_ms = max(1, floor(_st.caret.blink_ms));
		if ((current_time - _tb.caret_blink_time) >= _blink_ms) && ( _tb.caret_blink ) {
			_tb.caret_visible = !_tb.caret_visible;
			_tb.caret_blink_time = current_time;
		}
		if (_tb.caret_visible) {
			var _ci = clamp(_tb.caret_index, 0, string_length(_draw_text));
			var _prefix = (_ci > 0) ? string_copy(_draw_text, 1, _ci) : "";
			var _px = (_ci > 0) ? global.__QUILL_CORE.__TextMeasureVisualWidth(_prefix, _font, _config) : 0;
			var _cx = _tx + _px;
			var _ch = max(0, _text_rect.y2 - _text_rect.y1);
			__QuillRenderDrawCaret(_st, _cx, _text_rect.y1 - 4, _ch, _tb.caret_fade, _tb.caret_fade_time);
		}
	}

	__QuillRenderPopScissor(_clip_prev);
	draw_set_font(_old_font);
}

/// @ignore
function __QuillRenderDrawTextMulti(_tb, _st, _config, _text_rect, _active) {
	var _font = global.__QUILL_CORE.__ResolveTextboxFont(_tb, _config, _st);
	var _read_only = (_config[$ "read_only"] == true);

	var _layout = global.__QUILL_CORE.__GetActiveLayoutForTb(_tb, _config);
	if (!is_struct(_layout)) {
		return;
	}
	var _lines = _layout.lines;
	var _count = is_array(_lines) ? array_length(_lines) : 0;

	var _scroll_y = global.__QUILL_CORE.__TextAreaGetScrollY(_config);
	var _scroll_x = global.__QUILL_CORE.__TextAreaGetScrollX(_tb, _config);

	var _old_font = draw_get_font();
	draw_set_font(_font);

	var _clip_prev = __QuillRenderPushScissorGui(_text_rect.x1 - 2, _text_rect.y1 - 2, _text_rect.x2 + 2, _text_rect.y2 + 2);

	var _raw = _tb.GetValue();
	var _src = global.__QUILL_CORE.__TextFromConfigMasked(_raw, _config);
	var _is_placeholder = false;
	if (string_length(_src) <= 0 && !_active) {
		_src = string(_tb.placeholder);
		_is_placeholder = true;
	}

	var _draw_lines = _lines;
	var _draw_count = _count;
	var _draw_line_h = _layout.line_h;
	if (_is_placeholder) {
		var _wrap = ((_config[$ "wrap"] ?? true) == true);
		var _view_w = max(0, _text_rect.x2 - _text_rect.x1);
		var _ph_layout = global.__QUILL_CORE.__TextAreaBuildLayout(_src, _font, _wrap, _view_w, _config);
		if (is_struct(_ph_layout) && is_array(_ph_layout.lines)) {
			_draw_lines = _ph_layout.lines;
			_draw_count = array_length(_draw_lines);
			_draw_line_h = _ph_layout.line_h;
		}
	}

	var _old_a = draw_get_alpha();
	var _enabled = _tb.IsEnabled();
	
	var _li = global.__QUILL_CORE.__TextAreaFindLineAtIndex(_layout, _tb.caret_index);
	_li = clamp(_li, 0, _count - 1);
	var _cy = _text_rect.y1 + (_li * _layout.line_h) - _scroll_y;

	draw_sprite_ensure(spr_pixel, 0, _text_rect.x1, _cy - 2, _text_rect.x2 - _text_rect.x1, _layout.line_h + 2, 0, _st.textbox.line_highlight_col, _st.textbox.line_highlight_a);
	
	// Selection highlights.
	if (_enabled && _active && !_is_placeholder && global.__QUILL_CORE.__TextInputHasSelection(_tb)) {
		var _sel = global.__QUILL_CORE.__TextInputGetSelectionRange(_tb);
		var _sa = min(_sel.start, _sel._end);
		var _sb = max(_sel.start, _sel._end);

		for (var i = 0; i < _count; i++) {
			var _ln = _lines[i];
			if (!is_struct(_ln)) continue;
			var _ls = _ln.start;
			var _le = _ls + _ln.len;

			if (_sb <= _ls) continue;
			if (_sa >= _le) continue;

			var _a = clamp(_sa, _ls, _le);
			var _b = clamp(_sb, _ls, _le);

			var _local_a = max(0, _a - _ls);
			var _local_b = max(0, _b - _ls);

			var _pre = (_local_a > 0) ? string_copy(_ln.text, 1, _local_a) : "";
			var _mid = (_local_b > _local_a) ? string_copy(_ln.text, _local_a + 1, _local_b - _local_a) : "";
			var _align_off = global.__QUILL_CORE.__TextGetAlignOffset(_ln.text, _font, max(0, _text_rect.x2 - _text_rect.x1), _config);

			var _x1 = (_local_a > 0) ? global.__QUILL_CORE.__TextMeasureVisualWidth(_pre, _font, _config) : 0;
			var _x2 = _x1 + ((string_length(_mid) > 0) ? global.__QUILL_CORE.__TextMeasureVisualWidth(_mid, _font, _config) : 0);

			var _yy = _text_rect.y1 + (i * _layout.line_h) - _scroll_y;
			draw_set_alpha(_old_a * _st.selection.bg_a);
			draw_set_color(_st.selection.bg_col);
			draw_rectangle((_text_rect.x1 - _scroll_x) + _align_off + _x1, _yy, (_text_rect.x1 - _scroll_x) + _align_off + _x2, _yy + _layout.line_h, false);
		}
	}

	// Text.
	if (!_enabled) {
		draw_set_alpha(_old_a * _st.textbox.disabled_text_a);
		draw_set_color(_st.textbox.disabled_text_col);
	}
	else if (_is_placeholder) {
		draw_set_alpha(_old_a * _st.textbox.placeholder_a);
		draw_set_color(_st.textbox.placeholder_col);
	}
	else {
		draw_set_alpha(_old_a * _st.textbox.text_a);
		draw_set_color(_st.textbox.text_col);
	}
	for (var j = 0; j < _draw_count; j++) {
		var _ln2 = _draw_lines[j];
		if (!is_struct(_ln2)) continue;
		var _yy2 = _text_rect.y1 + (j * _draw_line_h) - _scroll_y;
		var _align_off2 = global.__QUILL_CORE.__TextGetAlignOffset(_ln2.text, _font, max(0, _text_rect.x2 - _text_rect.x1), _config);
		draw_text((_text_rect.x1 - _scroll_x) + _align_off2, _yy2, _ln2.text_draw ?? _ln2.text);
	}

	// Caret.
	if (_enabled && _active && !_read_only && !_is_placeholder) {
		var _blink_ms = max(1, floor(_st.caret.blink_ms));
		if ((current_time - _tb.caret_blink_time) >= _blink_ms) && ( _tb.caret_blink ) {
			_tb.caret_visible = !_tb.caret_visible;
			_tb.caret_blink_time = current_time;
		}
		if (_tb.caret_visible && _count > 0) {
			var _li = global.__QUILL_CORE.__TextAreaFindLineAtIndex(_layout, _tb.caret_index);
			_li = clamp(_li, 0, _count - 1);
			var _ln3 = _lines[_li];
			var _local_i = clamp(_tb.caret_index - _ln3.start, 0, _ln3.len);
			var _prefix2 = (_local_i > 0) ? string_copy(_ln3.text, 1, _local_i) : "";
			var _px2 = (_local_i > 0) ? global.__QUILL_CORE.__TextMeasureVisualWidth(_prefix2, _font, _config) : 0;
			var _align_off3 = global.__QUILL_CORE.__TextGetAlignOffset(_ln3.text, _font, max(0, _text_rect.x2 - _text_rect.x1), _config);
			var _cx = (_text_rect.x1 - _scroll_x) + _align_off3 + _px2;
			var _cy = _text_rect.y1 + (_li * _layout.line_h) - _scroll_y;
			__QuillRenderDrawCaret(_st, _cx, _cy - 4, _layout.line_h, _tb.caret_fade, _tb.caret_fade_time);
		}
	}

	draw_set_alpha(_old_a);
	__QuillRenderPopScissor(_clip_prev);
	draw_set_font(_old_font);
}

/// @ignore
function __QuillRenderDrawValidationInline(_tb, _st, _x1, _y2, _w) {
	if (!is_struct(_tb)) return;
	if (_tb.validation_visible != true) return;
	var _msg = string(_tb.validation_message);
	if (string_length(_msg) <= 0) return;

	var _col = _st.textbox.validation_error_col;
	if (_tb.validation_kind == "warn") _col = _st.textbox.validation_warn_col;
	else if (_tb.validation_kind == "info") _col = _st.textbox.validation_info_col;

	var _old_font = draw_get_font();
	var _vf = _st.fonts.validation;
	if (!is_real(_vf) || _vf < 0 || !font_exists(_vf)) {
		_vf = _st.fonts.body;
	}
	if (is_real(_vf) && _vf >= 0 && font_exists(_vf)) {
		draw_set_font(_vf);
	}

	var _old_a = draw_get_alpha();
	draw_set_alpha(_old_a * _st.textbox.validation_a);
	draw_set_color(_col);
	draw_text(_x1, _y2 + _st.textbox.validation_gap, _msg);
	draw_set_alpha(_old_a);
	draw_set_font(_old_font);
}

/// @ignore
function __QuillRenderDrawScrollbarV(_tb, _st, _track_rect, _thumb_rect, _active) {
	if (!is_struct(_track_rect) || !is_struct(_thumb_rect)) return;
	var _t_scroll = _st.scrollbar;
	var _track_border_out = __QuillRenderGetBorderSpriteOutsideInsets(_t_scroll.border_spr, _t_scroll.border_spr_outside_draw);

	var _thumb_col = _active ? _t_scroll.thumb_active_col : _t_scroll.thumb_idle_col;
	var _thumb_a = _active ? _t_scroll.thumb_active_a : _t_scroll.thumb_idle_a;

	var _old_a = draw_get_alpha();
	var _track_w = max(0, _track_rect.x2 - _track_rect.x1);
	var _track_h = max(0, _track_rect.y2 - _track_rect.y1);
	var _track_outer_x1 = _track_rect.x1 - _track_border_out.left;
	var _track_outer_y1 = _track_rect.y1 - _track_border_out.top;
	var _track_outer_x2 = _track_rect.x2 + _track_border_out.right;
	var _track_outer_y2 = _track_rect.y2 + _track_border_out.bottom;
	var _track_outer_w = max(0, _track_outer_x2 - _track_outer_x1);
	var _track_outer_h = max(0, _track_outer_y2 - _track_outer_y1);
	var _need_track_bg_prim = true;
	var _need_track_bd_prim = true;
	if (__QuillRenderDrawSpriteSkin(_t_scroll.bg_spr, _t_scroll.bg_subimg, _track_rect.x1, _track_rect.y1, _track_w, _track_h, _t_scroll.track_col, _t_scroll.track_a)) {
		_need_track_bg_prim = false;
	}
	if (__QuillRenderDrawSpriteSkin(_t_scroll.border_spr, _t_scroll.border_subimg, _track_outer_x1, _track_outer_y1, _track_outer_w, _track_outer_h, _t_scroll.border_col, _t_scroll.border_a)) {
		_need_track_bd_prim = false;
	}

	var _track_vb = -1;
	if (QUILL_VB_ENABLE) {
		var _cache = QUILL.__GetBoxCacheById(_tb.id);
		var _sig = {
			w: _track_w,
			h: _track_h,
			need_bg: _need_track_bg_prim,
			need_border: _need_track_bd_prim,
			track_col: _t_scroll.track_col,
			track_a: _t_scroll.track_a,
			border_col: _t_scroll.border_col,
			border_a: _t_scroll.border_a
		};
		_track_vb = __QuillVbEnsureScrollTrack(_cache, _sig, "v");
	}

	if (_track_vb >= 0) {
		draw_set_alpha(_old_a);
		__QuillVbSubmitTranslated(_track_vb, _track_rect.x1, _track_rect.y1, "");
	}
	else if (_need_track_bg_prim || _need_track_bd_prim) {
		if (_need_track_bg_prim) {
			draw_set_alpha(_old_a * _t_scroll.track_a);
			draw_set_color(_t_scroll.track_col);
			draw_rectangle(_track_rect.x1, _track_rect.y1, _track_rect.x2, _track_rect.y2, false);
		}
		if (_need_track_bd_prim) {
			draw_set_alpha(_old_a * _t_scroll.border_a);
			draw_set_color(_t_scroll.border_col);
			__QuillRenderDrawBorderPrimitive(_track_outer_x1, _track_outer_y1, _track_outer_x2, _track_outer_y2, 1);
		}
	}

	var _w = max(0, _thumb_rect.x2 - _thumb_rect.x1);
	var _h = max(0, _thumb_rect.y2 - _thumb_rect.y1);

	if (!__QuillRenderDrawSpriteSkin(_t_scroll.thumb_spr, _t_scroll.thumb_subimg, _thumb_rect.x1, _thumb_rect.y1, _w, _h, _thumb_col, _thumb_a)) {
		draw_set_alpha(_old_a * _thumb_a);
		draw_set_color(_thumb_col);
		draw_rectangle(_thumb_rect.x1 + 1, _thumb_rect.y1 + 1, _thumb_rect.x2 - 1, _thumb_rect.y2 - 1, false);
	}
	draw_set_alpha(_old_a);
}

/// @ignore
function __QuillRenderDrawScrollbarH(_tb, _st, _track_rect, _thumb_rect, _active) {
	if (!is_struct(_track_rect) || !is_struct(_thumb_rect)) return;
	var _t_scroll = _st.scrollbar;
	var _track_border_out = __QuillRenderGetBorderSpriteOutsideInsets(_t_scroll.border_spr, _t_scroll.border_spr_outside_draw);

	var _thumb_col = _active ? _t_scroll.thumb_active_col : _t_scroll.thumb_idle_col;
	var _thumb_a = _active ? _t_scroll.thumb_active_a : _t_scroll.thumb_idle_a;

	var _old_a = draw_get_alpha();
	var _track_w = max(0, _track_rect.x2 - _track_rect.x1);
	var _track_h = max(0, _track_rect.y2 - _track_rect.y1);
	var _track_outer_x1 = _track_rect.x1 - _track_border_out.left;
	var _track_outer_y1 = _track_rect.y1 - _track_border_out.top;
	var _track_outer_x2 = _track_rect.x2 + _track_border_out.right;
	var _track_outer_y2 = _track_rect.y2 + _track_border_out.bottom;
	var _track_outer_w = max(0, _track_outer_x2 - _track_outer_x1);
	var _track_outer_h = max(0, _track_outer_y2 - _track_outer_y1);
	var _need_track_bg_prim = true;
	var _need_track_bd_prim = true;
	if (__QuillRenderDrawSpriteSkin(_t_scroll.bg_spr, _t_scroll.bg_subimg, _track_rect.x1, _track_rect.y1, _track_w, _track_h, _t_scroll.track_col, _t_scroll.track_a)) {
		_need_track_bg_prim = false;
	}
	if (__QuillRenderDrawSpriteSkin(_t_scroll.border_spr, _t_scroll.border_subimg, _track_outer_x1, _track_outer_y1, _track_outer_w, _track_outer_h, _t_scroll.border_col, _t_scroll.border_a)) {
		_need_track_bd_prim = false;
	}

	var _track_vb = -1;
	if (QUILL_VB_ENABLE) {
		var _cache = QUILL.__GetBoxCacheById(_tb.id);
		var _sig = {
			w: _track_w,
			h: _track_h,
			need_bg: _need_track_bg_prim,
			need_border: _need_track_bd_prim,
			track_col: _t_scroll.track_col,
			track_a: _t_scroll.track_a,
			border_col: _t_scroll.border_col,
			border_a: _t_scroll.border_a
		};
		_track_vb = __QuillVbEnsureScrollTrack(_cache, _sig, "h");
	}

	if (_track_vb >= 0) {
		draw_set_alpha(_old_a);
		__QuillVbSubmitTranslated(_track_vb, _track_rect.x1, _track_rect.y1, "");
	}
	else if (_need_track_bg_prim || _need_track_bd_prim) {
		if (_need_track_bg_prim) {
			draw_set_alpha(_old_a * _t_scroll.track_a);
			draw_set_color(_t_scroll.track_col);
			draw_rectangle(_track_rect.x1, _track_rect.y1, _track_rect.x2, _track_rect.y2, false);
		}
		if (_need_track_bd_prim) {
			draw_set_alpha(_old_a * _t_scroll.border_a);
			draw_set_color(_t_scroll.border_col);
			__QuillRenderDrawBorderPrimitive(_track_outer_x1, _track_outer_y1, _track_outer_x2, _track_outer_y2, 1);
		}
	}

	var _w = max(0, _thumb_rect.x2 - _thumb_rect.x1);
	var _h = max(0, _thumb_rect.y2 - _thumb_rect.y1);

	if (!__QuillRenderDrawSpriteSkin(_t_scroll.thumb_spr, _t_scroll.thumb_subimg, _thumb_rect.x1, _thumb_rect.y1, _w, _h, _thumb_col, _thumb_a)) {
		draw_set_alpha(_old_a * _thumb_a);
		draw_set_color(_thumb_col);
		draw_rectangle(_thumb_rect.x1 + 1, _thumb_rect.y1 + 1, _thumb_rect.x2 - 1, _thumb_rect.y2 - 1, false);
	}
	draw_set_alpha(_old_a);
}

/// @ignore
function __QuillRenderDrawResizeGrip(_tb, _st, _rect) {
	if (!is_struct(_rect)) return;
	var _t_skins = _st.skins;
	var _w = max(0, _rect.x2 - _rect.x1);
	var _h = max(0, _rect.y2 - _rect.y1);

	if (__QuillRenderDrawSpriteSkin(_t_skins.resize_spr, _t_skins.resize_subimg, _rect.x1, _rect.y1, _w, _h, _t_skins.prim_border_hover_col, _t_skins.prim_border_hover_a)) {
		return;
	}

	var _old_a = draw_get_alpha();
	draw_set_alpha(_old_a * _t_skins.prim_border_hover_a);
	draw_set_color(_t_skins.prim_border_hover_col);
	draw_line(_rect.x2 - 2, _rect.y2 - 2, _rect.x1 + 2, _rect.y2 - 2);
	draw_line(_rect.x2 - 2, _rect.y2 - 2, _rect.x2 - 2, _rect.y1 + 2);
	draw_set_alpha(_old_a);
}
