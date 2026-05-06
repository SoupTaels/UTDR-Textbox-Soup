// Whenever you make a new theme, you must ensure that it inherits from QuillTheme.
function QuillTheme() constructor {
	fonts = new QuillFontSubtheme();
	textbox = new QuillTextboxSubtheme();
	label = new QuillLabelSubtheme();
	skins = new QuillSkinSubtheme();
	selection = new QuillSelectionSubtheme();
	caret = new QuillCaretSubtheme();
	scrollbar = new QuillScrollbarSubtheme();
	menu = new QuillMenuSubtheme();
	editor = new QuillEditorSubtheme();
	
	static SetFonts = function(_font_theme) {
		if (is_instanceof(_font_theme, QuillFontSubtheme)) {
			fonts = _font_theme;
		}
		return self;
	}
	
	static SetTextbox = function(_tb_theme) {
		if (is_instanceof(_tb_theme, QuillTextboxSubtheme)) {
			textbox = _tb_theme;
		}
		return self;
	}
	
	static SetLabel = function(_label_theme) {
		if (is_instanceof(_label_theme, QuillLabelSubtheme)) {
			label = _label_theme;
		}
		return self;
	}
	
	static SetSkins = function(_skin_theme) {
		if (is_instanceof(_skin_theme, QuillSkinSubtheme)) {
			skins = _skin_theme;
		}
		return self;
	}
	
	static SetSelection = function(_sel_theme) {
		if (is_instanceof(_sel_theme, QuillSelectionSubtheme)) {
			selection = _sel_theme;
		}
		return self;
	}
	
	static SetCaret = function(_caret_theme) {
		if (is_instanceof(_caret_theme, QuillCaretSubtheme)) {
			caret = _caret_theme;
		}
		return self;
	}
	
	static SetScrollbar = function(_scroll_theme) {
		if (is_instanceof(_scroll_theme, QuillScrollbarSubtheme)) {
			scrollbar = _scroll_theme;
		}
		return self;
	}
	
	static SetMenu = function(_menu_theme) {
		if (is_instanceof(_menu_theme, QuillMenuSubtheme)) {
			menu = _menu_theme;
		}
		return self;
	}
	
	static SetEditor = function(_editor_theme) {
		if (is_instanceof(_editor_theme, QuillEditorSubtheme)) {
			editor = _editor_theme;
		}
		return self;
	}
}

function QuillSubtheme() constructor {
	// Empty parent for validation
}

// The same goes for each of the subthemes, if you create a new font subtheme, it must inherit
// from the QuillFontSubtheme, and so on for all the subtheme types.
function QuillFontSubtheme() : QuillSubtheme() constructor {
	body = fnt_speech;
	code = fnt_speech;
	label = fnt_speech;
	menu = fnt_speech;
	editor_title = fnt_speech;
	editor_body = fnt_speech;
	validation = fnt_speech;
}

function QuillTextboxSubtheme() : QuillSubtheme() constructor {
	line_highlight_col = c_white;
	line_highlight_a = 1;
	
	pad_l = 6;
	pad_t = 6;
	pad_r = 6;
	pad_b = 6;
	
	text_col = c_white;
	text_a = 1;
	
	placeholder_col = c_gray;
	placeholder_a = 0.7;
	
	disabled_text_col = c_gray;
	disabled_text_a = 0.5;
	
	validation_gap = 4;
	validation_error_col = c_red;
	validation_warn_col = c_yellow;
	validation_info_col = c_aqua;
	validation_a = 0.9;
}

function QuillLabelSubtheme() : QuillSubtheme() constructor {
	pad_l = 6;
	pad_t = 4;
	pad_r = 6;
	pad_b = 4;
	
	margin_l = 0;
	margin_t = 0;
	margin_r = 0;
	margin_b = 0;
	
	text_col = c_white;
	text_a = 1;
	
	bg_spr = -1;
	bg_subimg = 0;
	border_spr = -1;
	border_subimg = 0;
	border_spr_outside_draw = false;
	
	prim_bg_col = make_colour_rgb(22, 22, 22);
	prim_bg_a = 0;
	prim_border_col = make_colour_rgb(90, 90, 90);
	prim_border_a = 0;
	prim_border_thickness = 1;
}

function QuillSkinSubtheme() : QuillSubtheme() constructor {
	// Background sprite path
	bg_spr = -1;
	bg_subimg = 0;
	
	// Border sprite path
	border_spr = -1;
	border_subimg = 0;
	border_spr_outside_draw = false;
	
	// Optional sprite paths
	caret_spr = -1;
	caret_subimg = 0;
	resize_spr = -1;
	resize_subimg = 0;
	resize_grip_size = 16;
	resize_pad = 2;
	
	// Primitive fallback colors (if sprites are -1)
	prim_bg_idle_col = make_colour_rgb(30, 30, 30);
	prim_bg_idle_a = 1;
	prim_bg_hover_col = make_colour_rgb(36, 36, 36);
	prim_bg_hover_a = 1;
	prim_bg_active_col = make_colour_rgb(40, 40, 40);
	prim_bg_active_a = 1;
	prim_bg_disabled_col = make_colour_rgb(25, 25, 25);
	prim_bg_disabled_a = 1;
	prim_bg_invalid_col = make_colour_rgb(40, 25, 25);
	prim_bg_invalid_a = 1;
	
	prim_border_idle_col = make_colour_rgb(90, 90, 90);
	prim_border_idle_a = 1;
	prim_border_hover_col = make_colour_rgb(120, 120, 120);
	prim_border_hover_a = 1;
	prim_border_active_col = make_colour_rgb(160, 160, 160);
	prim_border_active_a = 1;
	prim_border_disabled_col = make_colour_rgb(70, 70, 70);
	prim_border_disabled_a = 1;
	prim_border_invalid_col = make_colour_rgb(220, 80, 80);
	prim_border_invalid_a = 1;
	
	// if you draw borders as rect outlines
	prim_border_thickness = 1;
}

function QuillSelectionSubtheme() : QuillSubtheme() constructor {
	bg_col = make_colour_rgb(44, 58, 88);
	bg_a = 0.55;
	
	// Optional: if undefined, keep normal text color
	text_col = undefined;
	text_a = 1;
}

function QuillCaretSubtheme() : QuillSubtheme() constructor {
	col = make_colour_rgb(235, 235, 235);
	a = 1;
	w = 2;
	
	blink_ms = 530;
}

function QuillScrollbarSubtheme() : QuillSubtheme() constructor {
	bg_spr = -1;
	bg_subimg = 0;
	border_spr = -1;
	border_subimg = 0;
	border_spr_outside_draw = false;
	thumb_spr = -1;
	thumb_subimg = 0;
	move_spr = -1;
	move_subimg = 0;
	
	// If sprites are unused
	w = 8;
	pad = 2;
	thumb_min_h = 12;
	
	track_col = make_colour_rgb(0, 0, 0);
	track_a = 0.25;
	
	thumb_idle_col = make_colour_rgb(160, 160, 160);
	thumb_idle_a = 0.6;
	thumb_hover_col = make_colour_rgb(200, 200, 200);
	thumb_hover_a = 0.8;
	thumb_active_col = make_colour_rgb(220, 220, 220);
	thumb_active_a = 0.95;
	
	border_col = make_colour_rgb(60, 60, 60);
	border_a = 0.6;
}

function QuillMenuSubtheme() : QuillSubtheme() constructor {
	item_h = 22;
	pad_x = 8;
	pad_y = 6;
	prim_padd = 1;
	min_w = 140;
	max_w = 520;
	viewport_margin = 4;
	shortcut_gap = 24;
	sep_min_h = 6;
	
	// Optional sprites for menu panel
	bg_spr = -1;
	bg_subimg = 0;
	border_spr = -1;
	border_subimg = 0;
	border_spr_outside_draw = false;
	
	// Primitive fallback panel
	prim_bg_col = make_colour_rgb(22, 22, 22);
	prim_bg_a = 0.98;
	prim_border_col = make_colour_rgb(90, 90, 90);
	prim_border_a = 1;
	
	// Item states
	item_hover_col = make_colour_rgb(60, 60, 60);
	item_hover_a = 0.7;
	
	text_col = c_white;
	text_a = 1;
	disabled_text_col = c_gray;
	disabled_text_a = 0.6;
	
	sep_col = make_colour_rgb(90, 90, 90);
	sep_a = 0.5;
	sep_h = 1;
}

function QuillEditorSubtheme() : QuillSubtheme() constructor {
	title_col = c_white;
	title_a = 1;
	
	panel_bg_spr = -1;
	panel_bg_subimg = 0;
	panel_border_spr = -1;
	panel_border_subimg = 0;
	panel_border_spr_outside_draw = false;
	
	prim_panel_bg_col = make_colour_rgb(18, 18, 18);
	prim_panel_bg_a = 0.98;
	prim_panel_border_col = make_colour_rgb(90, 90, 90);
	prim_panel_border_a = 1;
	
	pad_x = 10;
	pad_y = 10;
	viewport_margin = 16;
	min_w = 320;
	max_w = 720;
	min_h = 240;
	max_h = 480;
	dim_col = c_black;
	dim_a = 0.55;
	
	btn_bg_idle_col = make_colour_rgb(42, 42, 44);
	btn_bg_idle_a = 1;
	btn_bg_hover_col = make_colour_rgb(60, 60, 64);
	btn_bg_hover_a = 1;
	btn_border_col = make_colour_rgb(90, 90, 96);
	btn_border_a = 1;
	btn_text_col = c_white;
	btn_text_a = 1;
	btn_w = 72;
	btn_h = 22;
	btn_gap = 8;
}
