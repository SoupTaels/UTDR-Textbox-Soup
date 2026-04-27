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
	body = fnt_default;
	code = fnt_code;
	label = fnt_default;
	menu = fnt_default;
	editor_title = fnt_default;
	editor_body = fnt_default;
	validation = fnt_default;
}

function QuillTextboxSubtheme() : QuillSubtheme() constructor {
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

// ================================
// Theme: VoidMango
// Dark void purple base with mango + cyan accents.
function QuillTheme_VoidMango() : QuillTheme() constructor {
	var _void_0 = make_colour_rgb(14, 12, 24);
	var _void_1 = make_colour_rgb(20, 16, 34);
	var _void_2 = make_colour_rgb(28, 22, 44);
	var _void_disabled = make_colour_rgb(10, 9, 16);
	var _wine_invalid = make_colour_rgb(34, 14, 18);
	
	var _lavender = make_colour_rgb(80, 70, 110);
	var _mango = make_colour_rgb(255, 190, 70);
	var _cyan = make_colour_rgb(90, 255, 220);
	var _pink = make_colour_rgb(255, 92, 120);
	
	var _text = make_colour_rgb(240, 240, 250);
	var _muted = make_colour_rgb(140, 130, 170);
	var _disabled_text = make_colour_rgb(120, 110, 140);
	
	// Textbox
	textbox.text_col = _text;
	textbox.text_a = 1;
	textbox.placeholder_col = _muted;
	textbox.placeholder_a = 0.75;
	textbox.disabled_text_col = _disabled_text;
	textbox.disabled_text_a = 0.55;
	
	textbox.validation_error_col = _pink;
	textbox.validation_warn_col = _mango;
	textbox.validation_info_col = _cyan;
	textbox.validation_a = 0.95;
	
	// Skins
	skins.prim_bg_idle_col = _void_0;
	skins.prim_bg_idle_a = 1;
	skins.prim_bg_hover_col = _void_1;
	skins.prim_bg_hover_a = 1;
	skins.prim_bg_active_col = _void_2;
	skins.prim_bg_active_a = 1;
	skins.prim_bg_disabled_col = _void_disabled;
	skins.prim_bg_disabled_a = 1;
	skins.prim_bg_invalid_col = _wine_invalid;
	skins.prim_bg_invalid_a = 1;
	
	skins.prim_border_idle_col = _lavender;
	skins.prim_border_idle_a = 0.9;
	skins.prim_border_hover_col = _cyan;
	skins.prim_border_hover_a = 1;
	skins.prim_border_active_col = _mango;
	skins.prim_border_active_a = 1;
	skins.prim_border_disabled_col = make_colour_rgb(60, 56, 74);
	skins.prim_border_disabled_a = 0.8;
	skins.prim_border_invalid_col = _pink;
	skins.prim_border_invalid_a = 1;
	
	skins.prim_border_thickness = 2;
	
	// Selection + caret
	selection.bg_col = _mango;
	selection.bg_a = 0.28;
	selection.text_col = _void_2;
	selection.text_a = 1;
	
	caret.col = _cyan;
	caret.a = 1;
	caret.w = 2;
	
	// Scrollbar
	scrollbar.track_col = c_black;
	scrollbar.track_a = 0.18;
	
	scrollbar.thumb_idle_col = _mango;
	scrollbar.thumb_idle_a = 0.42;
	scrollbar.thumb_hover_col = _cyan;
	scrollbar.thumb_hover_a = 0.65;
	scrollbar.thumb_active_col = _mango;
	scrollbar.thumb_active_a = 0.9;
	
	scrollbar.border_col = _lavender;
	scrollbar.border_a = 0.5;
	
	// Menu
	menu.prim_bg_col = _void_1;
	menu.prim_bg_a = 0.98;
	menu.prim_border_col = _cyan;
	menu.prim_border_a = 0.9;
	
	menu.item_hover_col = _mango;
	menu.item_hover_a = 0.22;
	
	menu.text_col = _text;
	menu.text_a = 1;
	menu.disabled_text_col = _disabled_text;
	menu.disabled_text_a = 0.6;
	
	menu.sep_col = _lavender;
	menu.sep_a = 0.5;
	
	// Editor
	editor.prim_panel_bg_col = _void_0;
	editor.prim_panel_bg_a = 0.98;
	editor.prim_panel_border_col = _cyan;
	editor.prim_panel_border_a = 0.9;
	
	editor.title_col = _text;
	editor.title_a = 1;
	
	editor.dim_col = c_black;
	editor.dim_a = 0.6;
	
	editor.btn_bg_idle_col = _void_2;
	editor.btn_bg_idle_a = 1;
	editor.btn_bg_hover_col = _void_1;
	editor.btn_bg_hover_a = 1;
	editor.btn_border_col = _mango;
	editor.btn_border_a = 1;
	editor.btn_text_col = _text;
	editor.btn_text_a = 1;
	
	// Label
	label.text_col = _text;
	label.text_a = 1;
	
	label.prim_bg_col = _void_1;
	label.prim_bg_a = 0.6;
	label.prim_border_col = _lavender;
	label.prim_border_a = 0.6;
	label.prim_border_thickness = 2;
}


// ================================
// Theme: ChunkyCandy
// Pastel "marshmallow" base with loud candy-shell accents.
// Also bumps sizing across subthemes so everything feels thicker.
function QuillTheme_ChunkyCandy() : QuillTheme() constructor {
	// Palette
	var _marshmallow_0 = make_colour_rgb(248, 240, 250);
	var _marshmallow_1 = make_colour_rgb(240, 228, 248);
	var _marshmallow_2 = make_colour_rgb(232, 212, 244);
	
	var _ink = make_colour_rgb(28, 18, 34);
	var _muted = make_colour_rgb(92, 78, 108);
	var _disabled_ink = make_colour_rgb(120, 112, 132);
	
	var _bubblegum = make_colour_rgb(255, 70, 156);
	var _mint = make_colour_rgb(48, 230, 190);
	var _lemon = make_colour_rgb(255, 214, 72);
	var _grape = make_colour_rgb(148, 92, 255);
	var _berry_red = make_colour_rgb(255, 64, 92);
	
	var _disabled_bg = make_colour_rgb(224, 220, 230);
	var _invalid_bg = make_colour_rgb(255, 226, 233);
	
	// Textbox (chunky padding)
	textbox.pad_l = 12;
	textbox.pad_t = 10;
	textbox.pad_r = 12;
	textbox.pad_b = 10;
	
	textbox.text_col = _ink;
	textbox.text_a = 1;
	
	textbox.placeholder_col = _muted;
	textbox.placeholder_a = 0.72;
	
	textbox.disabled_text_col = _disabled_ink;
	textbox.disabled_text_a = 0.55;
	
	textbox.validation_gap = 8;
	textbox.validation_error_col = _berry_red;
	textbox.validation_warn_col = _lemon;
	textbox.validation_info_col = _mint;
	textbox.validation_a = 0.95;
	
	// Label (chunky padding + border thickness)
	label.pad_l = 12;
	label.pad_t = 8;
	label.pad_r = 12;
	label.pad_b = 8;
	
	label.text_col = _ink;
	label.text_a = 1;
	
	label.prim_bg_col = _marshmallow_1;
	label.prim_bg_a = 0.75;
	label.prim_border_col = _grape;
	label.prim_border_a = 0.85;
	label.prim_border_thickness = 3;
	
	// Skins (chunky borders + bigger resize grip)
	skins.resize_grip_size = 22;
	skins.resize_pad = 4;
	
	skins.prim_bg_idle_col = _marshmallow_0;
	skins.prim_bg_idle_a = 1;
	skins.prim_bg_hover_col = _marshmallow_1;
	skins.prim_bg_hover_a = 1;
	skins.prim_bg_active_col = _marshmallow_2;
	skins.prim_bg_active_a = 1;
	skins.prim_bg_disabled_col = _disabled_bg;
	skins.prim_bg_disabled_a = 1;
	skins.prim_bg_invalid_col = _invalid_bg;
	skins.prim_bg_invalid_a = 1;
	
	// Candy-shell borders
	skins.prim_border_idle_col = _grape;
	skins.prim_border_idle_a = 0.95;
	skins.prim_border_hover_col = _mint;
	skins.prim_border_hover_a = 1;
	skins.prim_border_active_col = _bubblegum;
	skins.prim_border_active_a = 1;
	skins.prim_border_disabled_col = make_colour_rgb(160, 154, 172);
	skins.prim_border_disabled_a = 0.9;
	skins.prim_border_invalid_col = _berry_red;
	skins.prim_border_invalid_a = 1;
	
	skins.prim_border_thickness = 4;
	
	// Selection + caret (thicker caret)
	selection.bg_col = _mint;
	selection.bg_a = 0.35;
	selection.text_col = _ink;
	selection.text_a = 1;
	
	caret.col = _grape;
	caret.a = 1;
	caret.w = 4;
	
	// Scrollbar (chunky width + thumb)
	scrollbar.w = 14;
	scrollbar.pad = 4;
	scrollbar.thumb_min_h = 20;
	scrollbar.bg_spr = spr_pixel;
	scrollbar.border_spr = spr_border;
	scrollbar.border_spr_outside_draw = true;
	
	scrollbar.track_col = _grape;
	scrollbar.track_a = 0.16;
	
	scrollbar.thumb_idle_col = _bubblegum;
	scrollbar.thumb_idle_a = 0.55;
	scrollbar.thumb_hover_col = _mint;
	scrollbar.thumb_hover_a = 0.75;
	scrollbar.thumb_active_col = _lemon;
	scrollbar.thumb_active_a = 0.9;
	
	scrollbar.border_col = _grape;
	scrollbar.border_a = 0.55;
	
	// Menu (chunkier rows, padding, separators)
	menu.item_h = 30;
	menu.pad_x = 12;
	menu.pad_y = 10;
	menu.min_w = 180;
	menu.viewport_margin = 8;
	menu.shortcut_gap = 30;
	menu.sep_min_h = 10;
	menu.sep_h = 2;
	
	menu.prim_bg_col = _marshmallow_1;
	menu.prim_bg_a = 0.98;
	menu.prim_border_col = _bubblegum;
	menu.prim_border_a = 0.95;
	
	menu.item_hover_col = _mint;
	menu.item_hover_a = 0.22;
	
	menu.text_col = _ink;
	menu.text_a = 1;
	menu.disabled_text_col = _disabled_ink;
	menu.disabled_text_a = 0.6;
	
	menu.sep_col = _grape;
	menu.sep_a = 0.45;
	
	// Editor (bigger panel padding + chunkier buttons)
	editor.prim_panel_bg_col = _marshmallow_0;
	editor.prim_panel_bg_a = 0.98;
	editor.prim_panel_border_col = _bubblegum;
	editor.prim_panel_border_a = 0.95;
	
	editor.title_col = _ink;
	editor.title_a = 1;
	
	editor.pad_x = 16;
	editor.pad_y = 16;
	editor.viewport_margin = 20;
	editor.min_w = 360;
	editor.max_w = 820;
	editor.min_h = 260;
	editor.max_h = 540;
	
	editor.dim_col = c_black;
	editor.dim_a = 0.38;
	
	editor.btn_bg_idle_col = _marshmallow_2;
	editor.btn_bg_idle_a = 1;
	editor.btn_bg_hover_col = _marshmallow_1;
	editor.btn_bg_hover_a = 1;
	editor.btn_border_col = _grape;
	editor.btn_border_a = 0.95;
	editor.btn_text_col = _ink;
	editor.btn_text_a = 1;
	
	editor.btn_w = 96;
	editor.btn_h = 30;
	editor.btn_gap = 12;
}

// ================================
// Theme: NeonCircuit
// Deep space navy + teal circuitry + magenta energy accents.
function QuillTheme_NeonCircuit() : QuillTheme() constructor {
	// Palette
	var _space_0 = make_colour_rgb(10, 14, 24);
	var _space_1 = make_colour_rgb(14, 20, 34);
	var _space_2 = make_colour_rgb(18, 28, 48);
	
	var _teal = make_colour_rgb(44, 210, 220);
	var _cyan = make_colour_rgb(120, 255, 242);
	var _magenta = make_colour_rgb(255, 72, 214);
	var _phosphor = make_colour_rgb(80, 255, 140);
	
	var _text = make_colour_rgb(220, 245, 250);
	var _muted = make_colour_rgb(120, 150, 170);
	var _disabled_text = make_colour_rgb(90, 104, 120);
	
	var _disabled_bg = make_colour_rgb(12, 14, 18);
	var _invalid_bg = make_colour_rgb(44, 12, 22);
	
	// Textbox
	textbox.text_col = _text;
	textbox.text_a = 1;
	
	textbox.placeholder_col = _muted;
	textbox.placeholder_a = 0.72;
	
	textbox.disabled_text_col = _disabled_text;
	textbox.disabled_text_a = 0.55;
	
	textbox.validation_gap = 4;
	textbox.validation_error_col = make_colour_rgb(255, 72, 92);
	textbox.validation_warn_col = make_colour_rgb(255, 200, 70);
	textbox.validation_info_col = _teal;
	textbox.validation_a = 0.95;
	
	// Label
	label.text_col = _text;
	label.text_a = 1;
	
	label.prim_bg_col = _space_1;
	label.prim_bg_a = 0.55;
	label.prim_border_col = _teal;
	label.prim_border_a = 0.75;
	label.prim_border_thickness = 1;
	
	// Skins
	skins.prim_bg_idle_col = _space_0;
	skins.prim_bg_idle_a = 1;
	skins.prim_bg_hover_col = _space_1;
	skins.prim_bg_hover_a = 1;
	skins.prim_bg_active_col = _space_2;
	skins.prim_bg_active_a = 1;
	skins.prim_bg_disabled_col = _disabled_bg;
	skins.prim_bg_disabled_a = 1;
	skins.prim_bg_invalid_col = _invalid_bg;
	skins.prim_bg_invalid_a = 1;
	
	skins.prim_border_idle_col = _teal;
	skins.prim_border_idle_a = 1;
	skins.prim_border_hover_col = _cyan;
	skins.prim_border_hover_a = 1;
	skins.prim_border_active_col = _magenta;
	skins.prim_border_active_a = 1;
	skins.prim_border_disabled_col = make_colour_rgb(44, 60, 74);
	skins.prim_border_disabled_a = 1;
	skins.prim_border_invalid_col = make_colour_rgb(255, 72, 92);
	skins.prim_border_invalid_a = 1;
	
	skins.prim_border_thickness = 1;
	
	// Selection + caret
	selection.bg_col = _teal;
	selection.bg_a = 0.26;
	selection.text_col = make_colour_rgb(12, 18, 26);
	selection.text_a = 1;
	
	caret.col = _phosphor;
	caret.a = 1;
	caret.w = 2;
	
	// Scrollbar
	scrollbar.track_col = c_black;
	scrollbar.track_a = 0.22;
	
	scrollbar.thumb_idle_col = _teal;
	scrollbar.thumb_idle_a = 0.48;
	scrollbar.thumb_hover_col = _cyan;
	scrollbar.thumb_hover_a = 0.72;
	scrollbar.thumb_active_col = _magenta;
	scrollbar.thumb_active_a = 0.9;
	
	scrollbar.border_col = _teal;
	scrollbar.border_a = 0.5;
	
	// Menu
	menu.prim_bg_col = _space_1;
	menu.prim_bg_a = 0.98;
	menu.prim_border_col = _teal;
	menu.prim_border_a = 0.9;
	
	menu.item_hover_col = _magenta;
	menu.item_hover_a = 0.18;
	
	menu.text_col = _text;
	menu.text_a = 1;
	menu.disabled_text_col = _disabled_text;
	menu.disabled_text_a = 0.6;
	
	menu.sep_col = _teal;
	menu.sep_a = 0.35;
	
	// Editor
	editor.prim_panel_bg_col = _space_0;
	editor.prim_panel_bg_a = 0.98;
	editor.prim_panel_border_col = _teal;
	editor.prim_panel_border_a = 0.9;
	
	editor.title_col = _text;
	editor.title_a = 1;
	
	editor.dim_col = c_black;
	editor.dim_a = 0.6;
	
	editor.btn_bg_idle_col = _space_2;
	editor.btn_bg_idle_a = 1;
	editor.btn_bg_hover_col = _space_1;
	editor.btn_bg_hover_a = 1;
	editor.btn_border_col = _magenta;
	editor.btn_border_a = 0.9;
	editor.btn_text_col = _text;
	editor.btn_text_a = 1;
}
