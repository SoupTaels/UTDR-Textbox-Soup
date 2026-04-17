/*********************************************************************************************
*                                        MIT License                                         *
*--------------------------------------------------------------------------------------------*
* Copyright (c) 2025 erkan612                                                                *
*                                                                                            *
* Permission is hereby granted, free of charge, to any person obtaining a copy of this       *
* software and associated documentation files (the "Software"), to deal in the Software      *
* without restriction, including without limitation the rights to use, copy, modify, merge,  *
* publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons *
* to whom the Software is furnished to do so, subject to the following conditions:           *
*                                                                                            *
* The above copyright notice and this permission notice shall be included in all copies or   *
* substantial portions of the Software.                                                      *
*                                                                                            *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,        *
* INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR   *
* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE  *
* FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR       *
* OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER     *
* DEALINGS IN THE SOFTWARE.                                                                  *
**********************************************************************************************
*--------------------------------------------------------------------------------------------*
*   					***********************************************                      *
*   					  ███╗   ███╗ █████╗      ██╗ ██████═╗██████═╗	                     *
*   					  ████╗ ████║██╔══██╗     ██║██╔═══██║██╔══██║	                     *
*   					  ██╔████╔██║███████║     ██║██║   ██║██████╔╝	                     *
*   					  ██║╚██╔╝██║██╔══██║██   ██║██║   ██║██╔══██╗	                     *
*   					  ██║ ╚═╝ ██║██║  ██║╚█████╔╝╚██████╔╝██║  ██║	                     *
*   					  ╚═╝     ╚═╝╚═╝  ╚═╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝	                     *
*   					              ██████╗ ██╗   ██╗██╗	                                 *
*   					             ██╔════╝ ██║   ██║██║	                                 *
*   					             ██║  ███╗██║   ██║██║	                                 *
*   					             ██║   ██║██║   ██║██║	                                 *
*   					             ╚██████╔╝╚██████╔╝██║	                                 *
*   					              ╚═════╝  ╚═════╝ ╚═╝	                                 *
*   						 GameMaker Retained Mode UI Library								 *
*   						            Version 1.0.0					                     *
*   																                         *
*   						            by erkan612					                         *
*   						=======================================	                         *
*   						A feature rich Immediate-Mode UI system	                         *
*   						             for GameMaker				                         *
*   						=======================================	                         *
*   						***************************************                          *
*********************************************************************************************/

/// @function SortCanvasListByZOrder_Copy(_list : ds_list) -> ds_list
function SortCanvasListByZOrder_Copy(_list) {
	var list = ds_list_create();
	ds_list_copy(list, _list);
	var size = ds_list_size(list);
	if (size < 2) {
		return list;
	};
	
	var listZLeft = ds_list_create();
	var listZRight = ds_list_create();
	for (var i = 0; i < size; i++) {
		var canvas = list[| i];
		ds_list_add(listZLeft, canvas[? "pos"].z);
	};
	ds_list_copy(listZRight, listZLeft);
	ds_list_sort(listZRight, true);
	
	var sortedList = ds_list_create();
	for (var i = 0; i < size; i++) {
		var idx = ds_list_find_index(listZLeft, listZRight[| i]);
		ds_list_add(sortedList, list[| idx]);
		ds_list_delete(listZLeft, idx);
		ds_list_delete(list, idx);
	};
	
	ds_list_destroy(list);
	ds_list_destroy(listZLeft);
	ds_list_destroy(listZRight);
	
	return sortedList;
};


/// @function FindNthOccurrenceOfString(fm_str : string, fm_substr : string, fm_occurrence : number) -> number
function FindNthOccurrenceOfString(fm_str, fm_substr, fm_occurrence) {
	if (fm_occurrence == 0) {
		return 0;
	};
	var str = fm_str;
	var p = 0;
	var t = p;
	for (var i = 1; i <= fm_occurrence; i++) {
		p = string_pos(fm_substr, str);
		t += p;
		if (p == 0) { return t; };
		str = string_copy(str, p + 1, string_length(str) - p);
	};
	return t;
};

enum wrapped_text {
	cut = 0,
	newline = 1, 
	dots = 2
};

/// @function draw_text_wrapped(fm_x : number, fm_y : number, fm_text : string, fm_width : number, fm_mode = wrapped_text.dots : wrapped_text) -> undefined
function draw_text_wrapped(fm_x, fm_y, fm_text, fm_width, fm_mode = wrapped_text.dots) {
	var oldBlend = gpu_get_blendmode();
	var charWidth = string_width("W"); // 9 by gamemaker's default font (each letter should be same)
	var charGap = 4; // gamemaker's default!
	var lineGap = 7; // gamemaker's default!
	var fontSize = draw_get_font() != -1 ? font_get_size(draw_get_font()) : 12; // gamemaker's default font's size!
	var lineHeight = fontSize + lineGap;
	
	gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
	
	switch (fm_mode) {
	case wrapped_text.cut: {
		var temptext = variable_clone(fm_text);
		var width = variable_clone(fm_width);
		var p = string_pos("\n", temptext);
		while (p != 0) {
			width += string_width(string_pos("\n", temptext));
			temptext = string_copy(temptext, p, string_length(temptext) - p);
			
			p = string_pos("\n", temptext);
		};
		draw_text(fm_x, fm_y, string_copy(fm_text, 0, floor(width / charWidth)));
	} break;
	case wrapped_text.newline: {
		draw_text_ext(fm_x, fm_y, fm_text, lineHeight, fm_width);
	} break;
	case wrapped_text.dots: {
		draw_text(fm_x, fm_y, string_copy(fm_text, 0, floor((fm_width - 3 * (charWidth + charGap)) / (charWidth + charGap))) + "...");
	} break;
	};
	
	gpu_set_blendmode(oldBlend);
};

/// @function Mix(fm_a : number, fm_b : number, fm_x : number) -> number
function Mix(fm_a, fm_b, fm_x) {
	return fm_a * (1 - fm_x) + fm_b * fm_x;
};

/// @function Vector2(fm_x : number, fm_y : number) -> Vector2
function Vector2(fm_x = 0, fm_y = 0) constructor {
	x = fm_x;
	y = fm_y;
};

/// @function Vector3(fm_x : number, fm_y : number, fm_z : number) -> Vector3
function Vector3(fm_x = 0, fm_y = 0, fm_z = 0) constructor {
	x = fm_x;
	y = fm_y;
	z = fm_z;
};

/// @function Vector4(fm_x : number, fm_y : number, fm_z : number, fm_w : number) -> Vector4
function Vector4(fm_x = 0, fm_y = 0, fm_z = 0, fm_w = 0) constructor {
	x = fm_x;
	y = fm_y;
	z = fm_z;
	w = fm_w;
};

/// @function Align(fm_horizontal : ALIGN, fm_vertical : ALIGN) -> Alignbject
function Align(fm_horizontal = ALIGN.LEFT, fm_vertical = ALIGN.TOP) constructor {
	horizontal = fm_horizontal;
	vertical = fm_vertical;
};

enum CLICKABLE_STATE {
	DISABLED = 0, 
	IDLE = 1, 
	HOVER = 2, 
	HOT = 3
};
enum ALIGN {
	LEFT = 0, 
	CENTER = 1, 
	RIGHT = 2, 
	
	TOP = 3, 
	MIDDLE = 4, 
	BOTTOM = 5
};
enum ALIGNER {
	HORIZONTAL = 0, 
	VERTICAL = 1
};

/// @function AlignGetAsGM(fm_align : ALIGN) -> number
function AlignGetAsGM(fm_align) {
	switch(fm_align) {
	case ALIGN.LEFT: {
		return fa_left;
	} break;
	case ALIGN.CENTER: {
		return fa_center;
	} break;
	case ALIGN.RIGHT: {
		return fa_right;
	} break;
	
	case ALIGN.TOP: {
		return fa_top;
	} break;
	case ALIGN.MIDDLE: {
		return fa_middle;
	} break;
	case ALIGN.BOTTOM: {
		return fa_bottom;
	} break;
	
	default: 
		return noone;
	};
};

/// @function draw_text_fontfixed(fm_x : number, fm_y : number, fm_text : string, fm_font : font) -> undefined
function draw_text_fontfixed(fm_x, fm_y, fm_text, fm_font) {
	if (fm_text == "") {
		return;
	};
	draw_set_font(fm_font);
	var targetSize = font_get_size(fm_font);
	var currentSize = string_height("|");
	var scale = targetSize / currentSize;
	draw_text_transformed(fm_x, fm_y, fm_text, scale, scale, 0);
};

/// @function GetElementTrackPosX(fm_element : ds_map) -> number
function GetElementTrackPosX(fm_element) {
	var addPos = 0;
	if (fm_element[? "parent"] != noone) {
		addPos += GetElementTrackPosX(fm_element[? "parent"]);
	};
	
	var backOnX = 0;
	
	switch (fm_element[? "alignment"].horizontal) {
	case ALIGN.LEFT: {
		backOnX = 0;
	} break;
	case ALIGN.CENTER: {
		backOnX = fm_element[? "size"].x / 2;
	} break;
	case ALIGN.RIGHT: {
		backOnX = fm_element[? "size"].x;
	} break;
	};
	
	return fm_element[? "pos"].x + addPos - backOnX;
};

/// @function GetElementTrackPosY(fm_element : ds_map) -> number
function GetElementTrackPosY(fm_element) {
	var addPos = 0;
	if (fm_element[? "parent"] != noone) {
		addPos += GetElementTrackPosY(fm_element[? "parent"]);
	};
	return fm_element[? "pos"].y + addPos;
};

/// @function GetElementStartPos(fm_element : ds_map) -> Vector2
function GetElementStartPos(fm_element) {
	var addPosX = 0, addPosY = 0;
	var backOnX = 0, backOnY = 0;
	
	if (fm_element[? "parent"] != noone) {
		var addPos = GetElementStartPos(fm_element[? "parent"]);
		addPosX = addPos.x;
		addPosY = addPos.y;
		delete addPos;
	};
	
	switch (fm_element[? "alignment"].horizontal) {
	case ALIGN.LEFT: {
		backOnX = 0;
	} break;
	case ALIGN.CENTER: {
		backOnX = fm_element[? "size"].x / 2;
	} break;
	case ALIGN.RIGHT: {
		backOnX = fm_element[? "size"].x;
	} break;
	};
	
	switch (fm_element[? "alignment"].vertical) {
	case ALIGN.TOP: {
		backOnY = 0;
	} break;
	case ALIGN.MIDDLE: {
		backOnY = fm_element[? "size"].y / 2;
	} break;
	case ALIGN.BOTTOM: {
		backOnY = fm_element[? "size"].y;
	} break;
	};
	
	var pos = new Vector2(fm_element[? "pos"].x - backOnX + addPosX, fm_element[? "pos"].y - backOnY + addPosY);
	if (ds_map_exists(fm_element, "extraAddX")) {
		pos.x += fm_element[? "extraAddX"];
	};
	if (ds_map_exists(fm_element, "extraAddY")) {
		pos.y += fm_element[? "extraAddY"];
	};
	return pos;
};

/// @function GetElementStartPosOffScreen(fm_element : ds_map) -> Vector2
function GetElementStartPosOffScreen(fm_element) {
	var backOnX, backOnY;
	
	switch (fm_element[? "alignment"].horizontal) {
	case ALIGN.LEFT: {
		backOnX = 0;
	} break;
	case ALIGN.CENTER: {
		backOnX = fm_element[? "size"].x / 2;
	} break;
	case ALIGN.RIGHT: {
		backOnX = fm_element[? "size"].x;
	} break;
	};
	
	switch (fm_element[? "alignment"].vertical) {
	case ALIGN.TOP: {
		backOnY = 0;
	} break;
	case ALIGN.MIDDLE: {
		backOnY = fm_element[? "size"].y / 2;
	} break;
	case ALIGN.BOTTOM: {
		backOnY = fm_element[? "size"].y;
	} break;
	};
	
	var pos = new Vector2(fm_element[? "pos"].x - backOnX, fm_element[? "pos"].y - backOnY);
	if (ds_map_exists(fm_element, "extraAddX")) {
		pos.x += fm_element[? "extraAddX"];
	};
	if (ds_map_exists(fm_element, "extraAddY")) {
		pos.y += fm_element[? "extraAddY"];
	};
	return pos;
};

global.MAJORGUI_SAVED_TRACKLIST = noone;

/// @function GetHoverCanvas(fm_canvas : ds_map, fm_x : number, fm_y : number, save = false : boolean) -> ds_map
function GetHoverCanvas(fm_canvas, fm_x, fm_y, save = false) {
	var result = noone;
	var highestCanvas = noone;
	
	for (var i = 0; i < ds_list_size(fm_canvas[? "elements"]); i++) {
		var element = fm_canvas[? "elements"][| i];
		if (!element[? "active"] || !element[? "hoverActive"]) {
			continue;
		};
		var pos = GetElementStartPos(element);
		var px = pos.x;
		var py = pos.y;
		delete pos;
		if 
		(
			px < fm_x 
			&& 
			py < fm_y
			&& 
			px + element[? "size"].x > fm_x
			&& 
			py + element[? "size"].y > fm_y
		) 
		{
			if (highestCanvas == noone) {
				highestCanvas = element;
			}
			else {
				if (highestCanvas[? "pos"].z < element[? "pos"].z) {
					highestCanvas = element;
				};
			};
		};
	};
	
	if (save) {
		if (global.MAJORGUI_SAVED_TRACKLIST == noone) {
			global.MAJORGUI_SAVED_TRACKLIST = ds_list_create();
		};
		ds_list_add(global.MAJORGUI_SAVED_TRACKLIST, highestCanvas);
	};
	
	if (highestCanvas != noone) {
		var temp = variable_clone(highestCanvas);
		result = GetHoverCanvas(temp, fm_x, fm_y, save);
		if (result == noone) {
			result = temp;
		};
	};
	
	return result;
};

/// @function IsHoverCanvasOptimized(fm_target : ds_map) -> boolean
function IsHoverCanvasOptimized(fm_target) {
	if (!ds_exists(global.MAJORGUI_SAVED_TRACKLIST, ds_type_list)) {
		global.MAJORGUI_SAVED_TRACKLIST = ds_list_create();
	};
	if (ds_list_find_index(global.MAJORGUI_SAVED_TRACKLIST, fm_target) != -1) {
		return true;
	};
	return false;
};

/// @function IsHoverCanvasFollower(fm_canvas : ds_map, fm_target : ds_map, fm_x : number, fm_y : number) -> ds_map
function IsHoverCanvasFollower(fm_canvas, fm_target, fm_x, fm_y) {
	result = noone;
	highestCanvas = noone;
	
	for (var i = 0; i < ds_list_size(fm_canvas[? "elements"]); i++) {
		var element = fm_canvas[? "elements"][| i];
		if (!element[? "active"] || !element[? "hoverActive"]) {
			continue;
		};
		var pos = GetElementStartPos(element);
		var px = pos.x;
		var py = pos.y;
		delete pos;
		if 
		(
			px < fm_x 
			&& 
			py < fm_y
			&& 
			px + element[? "size"].x > fm_x
			&& 
			py + element[? "size"].y > fm_y
		) 
		{
			if (highestCanvas == noone) {
				highestCanvas = element;
			}
			else {
				if (highestCanvas[? "pos"].z < element[? "pos"].z) {
					highestCanvas = element;
					if (highestCanvas == fm_target) {
						return fm_target;
					};
				};
			};
		};
	};
	
	if (highestCanvas != noone) {
		temp = variable_clone(highestCanvas);
		result = IsHoverCanvasFollower(temp, fm_target, fm_x, fm_y);
		if (result == noone) {
			result = temp;
		};
	};
	
	return result;
};

/// @function IsHoverCanvas(fm_canvas : ds_map, fm_target : ds_map, fm_x : number, fm_y : number) -> boolean
function IsHoverCanvas(fm_canvas, fm_target, fm_x, fm_y) {
	result = IsHoverCanvasFollower(fm_canvas, fm_target, fm_x, fm_y);
	if (result == fm_target) {
		return true;
	};
	return false;
};

/// @function SET_ALIGN(fm_assign : number) -> undefined
function SET_ALIGN(fm_assign) {
	switch(fm_assign) {
	case 0: { // left
		draw_set_halign(fa_left);
	} break;
	case 1: { // center
		draw_set_halign(fa_center);
	} break;
	case 2: { // right
		draw_set_halign(fa_right);
	} break;
	
	case 3: { // top
		draw_set_valign(fa_top);
	} break;
	case 4: { // middle
		draw_set_valign(fa_middle);
	} break;
	case 5: { // bottom
		draw_set_valign(fa_bottom);
	} break;
	
	default: {
		return;
	} break;
	};
};
/// @function GET_ALIGN(fm_aligner : number) -> number
function GET_ALIGN(fm_aligner) {
	switch (fm_aligner) {
	case 0: {
		switch(draw_get_halign()) {
		case fa_left: { // left
			return 0;
		} break;
		case fa_center: { // center
			return 1;
		} break;
		case fa_right: { // right
			return 2;
		} break;
		};
	} break;
	case 1: {
		switch(draw_get_valign()) {
		case fa_top: { // top
			return 3;
		} break;
		case fa_middle: { // middle
			return 4;
		} break;
		case fa_bottom: { // bottom
			return 5;
		} break;
		};
	} break;
	
	default: {
		return -1;
	} break;
	};
};

/// @function ElementSetProperty(fm_element : ds_map, fm_property : any, fm_name : string) -> any
function ElementSetProperty(fm_element, fm_property, fm_name) {
	fm_element[? fm_name] = fm_property;
	return fm_property;
};

/// @function ElementGetProperty(fm_element : ds_map, fm_name : string) -> any
function ElementGetProperty(fm_element, fm_name) {
	return fm_element[? fm_name];
};

/// @function ElementPropertyExists(fm_element : ds_map, fm_name : string) -> boolean
function ElementPropertyExists(fm_element, fm_name) {
	if (fm_element == noone) { return false; };
	return ds_map_exists(fm_element, fm_name);
};

// Global Methods
/// @function __Major_GM__ComboboxSelectableOnClick(fm_selectable : ds_map) -> undefined
function __Major_GM__ComboboxSelectableOnClick(fm_selectable) {
	var mGUI = ElementGetProperty(fm_selectable, "MajorGUI");
	var comboboxMenu = mGUI.CanvasGetParent(fm_selectable);
	var comboboxButton = ElementGetProperty(comboboxMenu, "button");
	ElementSetProperty(comboboxButton, fm_selectable, "selected");
};

/// @function __Major_GM__ComboswitchButtonsOnClick(fm_button : ds_map) -> undefined
function __Major_GM__ComboswitchButtonsOnClick(fm_button) {
	var mGUI = ElementGetProperty(fm_button, "MajorGUI");
	var panel = mGUI.CanvasGetParent(fm_button);
	var side = ElementGetProperty(fm_button, "__side");
	var currentOld = ElementGetProperty(panel, "__current");
	var onState = ElementGetProperty(fm_button, "__onStateChange");
	if (side == -1) { // left
		ElementSetProperty(panel, max(0, currentOld - 1), "__current");
	}
	else if (side == 1) { // right
		ElementSetProperty(panel, min(ds_list_size(ElementGetProperty(panel, "switchList")) - 1, currentOld + 1), "__current");
	};
	
	if (ElementGetProperty(panel, "__current") != currentOld) {
		if (onState != noone) {
			onState(panel);
		};
	};
};

// Global Definitions
global.MAJORGUI_MAIN_CANVAS = noone;

#macro MAJOR_GUI_NAMESPACE globalvar MajorGUI; MajorGUI = new MajorGUI()
function MajorGUI() constructor {
	m_canvasHover = noone;
	m_canvasLastClicked = noone;
	m_font = -1;
	
	// ------------------------------------------------
	
	// Button
	STYLER_BUTTON_UPDATE_BEFORE = function(fm_button) {
		if (ButtonGetState(fm_button) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_button)) {
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_button, CLICKABLE_STATE.HOT);
			}
			else if (ButtonGetState(fm_button) != CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_button, CLICKABLE_STATE.HOVER);
			};
			if (mouse_check_button_released(mb_left) && ButtonGetState(fm_button) == CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_button, CLICKABLE_STATE.HOVER);
				if (ButtonGetOnClick(fm_button) != noone) {
					ButtonGetOnClick(fm_button)(fm_button);
				};
			};
		}
		else {
			ButtonSetState(fm_button, CLICKABLE_STATE.IDLE);
		};
	};
	STYLER_BUTTON_UPDATE_AFTER = function(fm_button) {
	};
	STYLER_BUTTON_DRAW_BEFORE = function(fm_button) {
		var state = fm_button[? "state"];
		var color = noone;
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(31, 31, 31, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(51, 51, 51, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(22, 22, 22, 255);
		} break;
		};
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(0, 0, CanvasGetSize(fm_button).x, CanvasGetSize(fm_button).y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	STYLER_BUTTON_DRAW_AFTER = function(fm_button) {
		var color = noone;
	
		if (fm_button[? "state"] == CLICKABLE_STATE.DISABLED) {
			color = new Vector4(128, 128, 128, 255);
		}
		else {
			color = new Vector4(255, 255, 255, 255);
		};
	
		var oldHAlign = draw_get_halign();
		var oldVAlign = draw_get_valign();
		var oldFont = draw_get_font();
	
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_font(ButtonGetFont(fm_button));
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
	
		draw_text(CanvasGetSize(fm_button).x / 2, CanvasGetSize(fm_button).y / 2, ButtonGetText(fm_button));
	
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_set_halign(oldHAlign);
		draw_set_valign(oldHAlign);
		draw_set_font(oldFont);
	
		delete color;
	};

	// Checkbox
	STYLER_CHECKBOX_UPDATE_BEFORE = function(fm_checkbox) {
		if (ButtonGetState(fm_checkbox) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_checkbox)) {
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_checkbox, CLICKABLE_STATE.HOT);
				CheckboxSetCheck(fm_checkbox, !CheckboxGetCheck(fm_checkbox));
			}
			else if (ButtonGetState(fm_checkbox) != CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_checkbox, CLICKABLE_STATE.HOVER);
			};
			if (mouse_check_button_released(mb_left) && ButtonGetState(fm_checkbox) == CLICKABLE_STATE.HOT) {
				if (ButtonGetOnClick(fm_checkbox) != noone) {
					ButtonGetOnClick(fm_checkbox)(fm_checkbox);
				};
				ButtonSetState(fm_checkbox, CLICKABLE_STATE.HOVER);
			};
		}
		else {
			ButtonSetState(fm_checkbox, CLICKABLE_STATE.IDLE);
		};
	};
	STYLER_CHECKBOX_UPDATE_AFTER = function(fm_checkbox) {
	};
	STYLER_CHECKBOX_DRAW_BEFORE = function(fm_checkbox) {
		var state = ButtonGetState(fm_checkbox);
		var color = noone;
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(31, 31, 31, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(51, 51, 51, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(22, 22, 22, 255);
		} break;
		};
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(0, 0, CanvasGetSize(fm_checkbox).x, CanvasGetSize(fm_checkbox).y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	STYLER_CHECKBOX_DRAW_AFTER = function(fm_checkbox) {
		if (!CheckboxGetCheck(fm_checkbox)) {
			return;
		};
	
		var color = noone;
	
		if (ButtonGetState(fm_checkbox) == CLICKABLE_STATE.DISABLED) {
			color = new Vector4(128, 128, 128, 255);
		}
		else {
			color = new Vector4(255, 255, 255, 255);
		};
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		//draw_rectangle(gap, gap, CanvasGetSize(fm_checkbox).x - gap - 1, CanvasGetSize(fm_checkbox).y - gap - 1, false);
		var offset = new Vector2(1, 0);
		var size = CanvasGetSize(fm_checkbox);
		var divider = 4;
		var p1 = new Vector2(size.x / 2 - size.x / divider, size.y - size.y / divider);
		var p2 = new Vector2(0, size.y / 2);
		var p3 = new Vector2(size.x - size.x / divider, size.y / divider);
		
		var thickness = 2;
		draw_line_width(p1.x + offset.x, p1.y + offset.y, p2.x + offset.x, p2.y + offset.y, thickness);
		draw_line_width(p1.x + offset.x, p1.y + offset.y, p3.x + offset.x, p3.y + offset.y, thickness);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};

	// Label
	STYLER_LABEL_UPDATE_BEFORE = function(fm_label) {
		if (ElementPropertyExists(fm_label, "state")) {
			if (ButtonGetState(fm_label) == CLICKABLE_STATE.DISABLED) {
				return;
			};
		};
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_label)) {
			ButtonSetState(fm_label, CLICKABLE_STATE.HOVER);
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_label, CLICKABLE_STATE.HOT);
			};
			if (mouse_check_button(mb_left)) {
				ButtonSetState(fm_label, CLICKABLE_STATE.HOT);
			};
		}
		else {
			ButtonSetState(fm_label, CLICKABLE_STATE.IDLE);
		};
	};
	STYLER_LABEL_UPDATE_AFTER = function(fm_label) {
	};
	STYLER_LABEL_DRAW_BEFORE = function(fm_label) {
		var oldFont = draw_get_font();
		var color = LabelGetColor(fm_label);
	
		draw_set_font(LabelGetFont(fm_label));
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
	
		var oldblendmode = gpu_get_blendmode();
		gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
		
		var tox = 0, toy = 0;
		var alignH = fa_left, alignV = fa_top;
		
		switch (LabelGetTextAlignment(fm_label).horizontal) {
		case ALIGN.LEFT: {
			tox = 0;
			alignH = fa_left;
		} break;
		case ALIGN.CENTER: {
			tox = CanvasGetSize(fm_label).x / 2;
			alignH = fa_center;
		} break;
		case ALIGN.RIGHT: {
			tox = CanvasGetSize(fm_label).x;
			alignH = fa_right;
		} break;
		};
		
		switch (LabelGetTextAlignment(fm_label).vertical) {
		case ALIGN.TOP: {
			toy = 0;
			alignV = fa_top;
		} break;
		case ALIGN.MIDDLE: {
			toy = CanvasGetSize(fm_label).y / 2;
			alignV = fa_middle;
		} break;
		case ALIGN.BOTTOM: {
			toy = CanvasGetSize(fm_label).y;
			alignV = fa_bottom;
		} break;
		};
		
		var oldAlignH = draw_get_halign();
		var oldAlignV = draw_get_valign();
		draw_set_halign(alignH);
		draw_set_valign(alignV);
		
		var stringToBeDrawn = LabelGetText(fm_label);
		if (LabelGetPassword(fm_label)) { stringToBeDrawn = string_repeat(LabelGetPasswordCharacter(fm_label), string_length(LabelGetText(fm_label))); };
		
		if (LabelGetVirtualContainer(fm_label)) {
			//var width, height;
			//var oldFont_ = draw_get_font();
			//draw_set_font(LabelGetFont(fm_label));
			//width = max(string_width(LabelGetText(fm_label)), 1);
			//height = max(string_height(LabelGetText(fm_label)), 1);
			//draw_set_font(oldFont_);
			//
			//if (CanvasGetSize(fm_label).x != width && CanvasGetSize(fm_label).y != height) {
			//	CanvasSetSize(fm_label, new Vector2(width, height));
			//};
			
			draw_text_wrapped(tox, toy, stringToBeDrawn, LabelGetVirtualContainerWidth(fm_label), LabelGetWrapMode(fm_label));
		}
		else {
			draw_text(tox, toy, stringToBeDrawn);
		};
		
		
		draw_set_halign(oldAlignH);
		draw_set_valign(oldAlignV);
	
		gpu_set_blendmode(oldblendmode);
	
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_set_font(oldFont);
	};
	STYLER_LABEL_DRAW_AFTER = function(fm_label) {
	};

	// Radiobox
	STYLER_RADIOBOX_UPDATE_BEFORE = function(fm_radiobox) {
		if (ButtonGetState(fm_radiobox) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_radiobox)) {
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_radiobox, CLICKABLE_STATE.HOT);
				if (RadioboxGetGroup(fm_radiobox) != noone) {
					SelectableGroupSetSelected(RadioboxGetGroup(fm_radiobox), fm_radiobox);
				};
			}
			else if (ButtonGetState(fm_radiobox) != CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_radiobox, CLICKABLE_STATE.HOVER);
			};
			if (mouse_check_button_released(mb_left) && ButtonGetState(fm_radiobox) == CLICKABLE_STATE.HOT) {
				if (ButtonGetOnClick(fm_radiobox) != noone) {
					ButtonGetOnClick(fm_radiobox)(fm_radiobox);
				};
				ButtonSetState(fm_radiobox, CLICKABLE_STATE.HOVER);
			};
		}
		else {
			ButtonSetState(fm_radiobox, CLICKABLE_STATE.IDLE);
		};
	};
	STYLER_RADIOBOX_UPDATE_AFTER = function(fm_radiobox) {
	};
	STYLER_RADIOBOX_DRAW_BEFORE = function(fm_radiobox) {
		var state = ButtonGetState(fm_radiobox);
		var color = noone;
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(31, 31, 31, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(51, 51, 51, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(22, 22, 22, 255);
		} break;
		};
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_ellipse(0, 0, CanvasGetSize(fm_radiobox).x - 1, CanvasGetSize(fm_radiobox).y - 1, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	STYLER_RADIOBOX_DRAW_AFTER = function(fm_radiobox) {
		if (!CheckboxGetCheck(fm_radiobox)) {
			return;
		};
	
		var color = noone;
	
		if (ButtonGetState(fm_radiobox) == CLICKABLE_STATE.DISABLED) {
			color = new Vector4(128, 128, 128, 255);
		}
		else {
			color = new Vector4(255, 255, 255, 255);
		};
	
		var gap = 3;
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_ellipse(gap, gap, CanvasGetSize(fm_radiobox).x - gap - 1, CanvasGetSize(fm_radiobox).y - gap - 1, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};

	// Slidebar
	STYLER_SLIDEBAR_UPDATE_BEFORE = function(fm_slidebar) {
		if (ButtonGetState(fm_slidebar) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_slidebar)) {
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_slidebar, CLICKABLE_STATE.HOT);
				ElementSetProperty(fm_slidebar, true, "mouseTracking");
			}
			else if (ButtonGetState(fm_slidebar) != CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_slidebar, CLICKABLE_STATE.HOVER);
			};
			if (mouse_check_button_released(mb_left) && ButtonGetState(fm_slidebar) == CLICKABLE_STATE.HOT) {
				if (ButtonGetOnClick(fm_slidebar) != noone) {
					ButtonGetOnClick(fm_slidebar)(fm_slidebar);
				};
				ButtonSetState(fm_slidebar, CLICKABLE_STATE.HOVER);
			};
		}
		else {
			ButtonSetState(fm_slidebar, CLICKABLE_STATE.IDLE);
		};
	
		if (mouse_check_button_released(mb_left) && ElementGetProperty(fm_slidebar, "mouseTracking")) {
			ElementSetProperty(fm_slidebar, false, "mouseTracking");
		};
	
		if (ElementGetProperty(fm_slidebar, "mouseTracking")) {
			var sp = GetElementStartPos(fm_slidebar); // gets the element's position according to its alignment without adding its parents into the account
			var sx = sp.x;
			delete sp;
			var mx = device_mouse_x_to_gui(0) - sx;
			SlidebarSetPercentage(fm_slidebar, min(1, max(0, mx / CanvasGetSize(fm_slidebar).x)));
		};
	};
	STYLER_SLIDEBAR_UPDATE_AFTER = function(fm_slidebar) {
	};
	STYLER_SLIDEBAR_DRAW_BEFORE = function(fm_slidebar) {
		var state = ButtonGetState(fm_slidebar);
		var color = noone;
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		default: {
			color = new Vector4(31, 31, 31, 255);
		} break;
		};
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(0, 0, CanvasGetSize(fm_slidebar).x, CanvasGetSize(fm_slidebar).y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	STYLER_SLIDEBAR_DRAW_AFTER = function(fm_slidebar) {
		var color = noone;
	
		if (ButtonGetState(fm_slidebar) == CLICKABLE_STATE.DISABLED) {
			color = new Vector4(128, 128, 128, 255);
		}
		else {
			color = new Vector4(255, 255, 255, 255);
		};
	
		var p = SlidebarGetPercentage(fm_slidebar);
	
		if (p == 0) {
			delete color;
			return;
		};
	
		var currentLength = Mix(3, CanvasGetSize(fm_slidebar).x - 5, p);
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w);
		draw_rectangle(3, 3, currentLength, CanvasGetSize(fm_slidebar).y - 5, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};

	// Panel
	//STYLER_PANEL_UPDATE_BEFORE = function(fm_panel) {
	//	if (!IsHoverCanvasOptimized(fm_panel)) {
	//		return;
	//	};
	//	
	//	// Scroll
	//	if (ElementPropertyExists(fm_panel, "m_scrollbarVertical")) {
	//		var m_scrollbarVertical = ElementGetProperty(fm_panel, "m_scrollbarVertical");
	//		var m_steps = 1000;
	//		if (ElementPropertyExists(fm_panel, "m_scrollbarVerticalSteps")) {
	//			m_steps = ElementGetProperty(fm_panel, "m_scrollbarVerticalSteps");
	//		};
	//		if (!keyboard_check(vk_alt)) {
	//			if (mouse_wheel_down()) {
	//				ScrollbarScrollDown(m_scrollbarVertical, m_steps);
	//			};
	//			if (mouse_wheel_up()) {
	//				ScrollbarScrollUp(m_scrollbarVertical, m_steps);
	//			};
	//		};
	//	};
	//	if (ElementPropertyExists(fm_panel, "m_scrollbarHorizontal")) {
	//		var m_scrollbarHorizontal = ElementGetProperty(fm_panel, "m_scrollbarHorizontal");
	//		var m_steps = 1000;
	//		if (ElementPropertyExists(fm_panel, "m_scrollbarHorizontalSteps")) {
	//			m_steps = ElementGetProperty(fm_panel, "m_scrollbarHorizontalSteps");
	//		};
	//		if (keyboard_check(vk_alt)) {
	//			if (mouse_wheel_down()) {
	//				ScrollbarScrollRight(m_scrollbarHorizontal, m_steps);
	//			};
	//			if (mouse_wheel_up()) {
	//				ScrollbarScrollLeft(m_scrollbarHorizontal, m_steps);
	//			};
	//		};
	//	};
	//	
	//	// Resize
	//	var mx = device_mouse_x_to_gui(0);
	//	var my = device_mouse_y_to_gui(0);
	//	var gap = 5;
	//	var pPos = CanvasGetPosition(fm_panel);
	//	var pSize = CanvasGetSize(fm_panel);
	//	
	//	// Middle Left
	//	if 
	//	(
	//		(ElementGetProperty(fm_panel, "resizeMiddleLeft")) 
	//		&& 
	//		(mx > pPos.x - gap && mx < pPos.x + gap) 
	//		&& 
	//		(my > pPos.y + gap && my < pPos.y + pSize.y - gap)
	//	) 
	//	{
	//		//window_set_cursor(cr_size_we);
	//	};
	//	
	//	// Middle Right
	//	if 
	//	(
	//		(ElementGetProperty(fm_panel, "resizeMiddleRight")) 
	//		&& 
	//		(mx > pPos.x + pSize.x - gap && mx < pPos.x + pSize.x + gap) 
	//		&& 
	//		(my > pPos.y + gap && my < pPos.y + pSize.y - gap)
	//	) 
	//	{
	//		if (IsHoverCanvasOptimized(fm_panel)) {
	//			//window_set_cursor(cr_size_we);
	//			
	//			if (mouse_check_button_pressed(mb_left)) {
	//				// enable dragging
	//			};
	//			
	//			if (fm_panel[? "resizeDragging"]) {//////////////////////////////////////////////////////////////////
	//			};
	//		};
	//	};
	//};
	//TYLER_PANEL_UPDATE_BEFORE = function(fm_panel) {
	//	if (!IsHoverCanvasOptimized(fm_panel)) {
	//		return;
	//	};
	//
	//	// Scroll (existing code remains the same)
	//	if (ElementPropertyExists(fm_panel, "m_scrollbarVertical")) {
	//		var m_scrollbarVertical = ElementGetProperty(fm_panel, "m_scrollbarVertical");
	//		var m_steps = 1000;
	//		if (ElementPropertyExists(fm_panel, "m_scrollbarVerticalSteps")) {
	//			m_steps = ElementGetProperty(fm_panel, "m_scrollbarVerticalSteps");
	//		};
	//		if (!keyboard_check(vk_alt)) {
	//			if (mouse_wheel_down()) {
	//				ScrollbarScrollDown(m_scrollbarVertical, m_steps);
	//			};
	//			if (mouse_wheel_up()) {
	//				ScrollbarScrollUp(m_scrollbarVertical, m_steps);
	//			};
	//		};
	//	};
	//	if (ElementPropertyExists(fm_panel, "m_scrollbarHorizontal")) {
	//		var m_scrollbarHorizontal = ElementGetProperty(fm_panel, "m_scrollbarHorizontal");
	//		var m_steps = 1000;
	//		if (ElementPropertyExists(fm_panel, "m_scrollbarHorizontalSteps")) {
	//			m_steps = ElementGetProperty(fm_panel, "m_scrollbarHorizontalSteps");
	//		};
	//		if (keyboard_check(vk_alt)) {
	//			if (mouse_wheel_down()) {
	//				ScrollbarScrollRight(m_scrollbarHorizontal, m_steps);
	//			};
	//			if (mouse_wheel_up()) {
	//				ScrollbarScrollLeft(m_scrollbarHorizontal, m_steps);
	//			};
	//		};
	//	};
	//
	//	// Resize
	//	var mx = device_mouse_x_to_gui(0);
	//	var my = device_mouse_y_to_gui(0);
	//	var gap = 5;
	//	var pPos = GetElementStartPos(fm_panel);
	//	var pSize = CanvasGetSize(fm_panel);
	//
	//	var isResizing = false;
	//	var resizeEdge = 0;
	//
	//	// Check resize edges
	//	// Left edge
	//	if (ElementGetProperty(fm_panel, "resizeMiddleLeft") && mx > pPos.x - gap && mx < pPos.x + gap && my > pPos.y + gap && my < pPos.y + pSize.y - gap) {
	//		//window_set_cursor(cr_size_we);
	//		isResizing = true;
	//		resizeEdge = 1;
	//	}
	//	// Right edge
	//	else if (ElementGetProperty(fm_panel, "resizeMiddleRight") && mx > pPos.x + pSize.x - gap && mx < pPos.x + pSize.x + gap && my > pPos.y + gap && my < pPos.y + pSize.y - gap) {
	//		//window_set_cursor(cr_size_we);
	//		isResizing = true;
	//		resizeEdge = 2;
	//	}
	//	// Top edge
	//	else if (ElementGetProperty(fm_panel, "resizeTopCenter") && my > pPos.y - gap && my < pPos.y + gap && mx > pPos.x + gap && mx < pPos.x + pSize.x - gap) {
	//		//window_set_cursor(cr_size_ns);
	//		isResizing = true;
	//		resizeEdge = 3;
	//	}
	//	// Bottom edge
	//	else if (ElementGetProperty(fm_panel, "resizeBottomCenter") && my > pPos.y + pSize.y - gap && my < pPos.y + pSize.y + gap && mx > pPos.x + gap && mx < pPos.x + pSize.x - gap) {
	//		//window_set_cursor(cr_size_ns);
	//		isResizing = true;
	//		resizeEdge = 4;
	//	}
	//	// Top-left corner
	//	else if (ElementGetProperty(fm_panel, "resizeTopLeft") && mx > pPos.x - gap && mx < pPos.x + gap && my > pPos.y - gap && my < pPos.y + gap) {
	//		//window_set_cursor(cr_size_nwse);
	//		isResizing = true;
	//		resizeEdge = 5;
	//	}
	//	// Top-right corner
	//	else if (ElementGetProperty(fm_panel, "resizeTopRight") && mx > pPos.x + pSize.x - gap && mx < pPos.x + pSize.x + gap && my > pPos.y - gap && my < pPos.y + gap) {
	//		//window_set_cursor(cr_size_nesw);
	//		isResizing = true;
	//		resizeEdge = 6;
	//	}
	//	// Bottom-left corner
	//	else if (ElementGetProperty(fm_panel, "resizeBottomLeft") && mx > pPos.x - gap && mx < pPos.x + gap && my > pPos.y + pSize.y - gap && my < pPos.y + pSize.y + gap) {
	//		//window_set_cursor(cr_size_nesw);
	//		isResizing = true;
	//		resizeEdge = 7;
	//	}
	//	// Bottom-right corner
	//	else if (ElementGetProperty(fm_panel, "resizeBottomRight") && mx > pPos.x + pSize.x - gap && mx < pPos.x + pSize.x + gap && my > pPos.y + pSize.y - gap && my < pPos.y + pSize.y + gap) {
	//		//window_set_cursor(cr_size_nwse);
	//		isResizing = true;
	//		resizeEdge = 8;
	//	};
	//
	//	// Handle resize dragging
	//	if (isResizing && mouse_check_button_pressed(mb_left)) {
	//		ElementSetProperty(fm_panel, true, "resizeDragging");
	//		ElementSetProperty(fm_panel, resizeEdge, "resizeEdge");
	//		ElementSetProperty(fm_panel, mx, "resizeStartX");
	//		ElementSetProperty(fm_panel, my, "resizeStartY");
	//		ElementSetProperty(fm_panel, pSize.x, "resizeStartWidth");
	//		ElementSetProperty(fm_panel, pSize.y, "resizeStartHeight");
	//		ElementSetProperty(fm_panel, CanvasGetPosition(fm_panel).x, "resizeStartPosX");
	//		ElementSetProperty(fm_panel, CanvasGetPosition(fm_panel).y, "resizeStartPosY");
	//	};
	//
	//	if (ElementGetProperty(fm_panel, "resizeDragging")) {
	//		var resizeEdge = ElementGetProperty(fm_panel, "resizeEdge");
	//		var startX = ElementGetProperty(fm_panel, "resizeStartX");
	//		var startY = ElementGetProperty(fm_panel, "resizeStartY");
	//		var startWidth = ElementGetProperty(fm_panel, "resizeStartWidth");
	//		var startHeight = ElementGetProperty(fm_panel, "resizeStartHeight");
	//		var startPosX = ElementGetProperty(fm_panel, "resizeStartPosX");
	//		var startPosY = ElementGetProperty(fm_panel, "resizeStartPosY");
	//
	//		var deltaX = mx - startX;
	//		var deltaY = my - startY;
	//
	//		var newWidth = startWidth;
	//		var newHeight = startHeight;
	//		var newPosX = startPosX;
	//		var newPosY = startPosY;
	//
	//		// Calculate minimum size constraints
	//		var minWidth = ElementPropertyExists(fm_panel, "minWidth") ? ElementGetProperty(fm_panel, "minWidth") : 50;
	//		var minHeight = ElementPropertyExists(fm_panel, "minHeight") ? ElementGetProperty(fm_panel, "minHeight") : 50;
	//
	//		// Check if parent is an autoFit panel and calculate available space
	//		var parentPanel = CanvasGetParent(fm_panel);
	//		var isParentAutoFit = (parentPanel != noone && ElementPropertyExists(parentPanel, "autoFit") && parentPanel[? "autoFit"]);
	//		var availableSpace = new Vector2(9999, 9999); // Large default values
	//
	//		if (isParentAutoFit) {
	//			// Calculate available space based on parent's autoFit layout
	//			var parentSize = CanvasGetSize(parentPanel);
	//			var parentElements = CanvasGetElements(parentPanel);
	//	
	//			// Find this panel's line in parent's backup structure
	//			var parentBackup = parentPanel[? "backup"];
	//			var foundLine = noone;
	//			var elementIndexInLine = -1;
	//	
	//			// Search through parent's backup to find which line contains this panel
	//			for (var i = 0; i < ds_list_size(parentBackup); i++) {
	//				var line = parentBackup[| i];
	//				var lineElements = line[? "elements"];
	//		
	//				for (var j = 0; j < ds_list_size(lineElements); j++) {
	//					if (lineElements[| j] == fm_panel) {
	//						foundLine = line;
	//						elementIndexInLine = j;
	//						break;
	//					};
	//				};
	//				if (foundLine != noone) break;
	//			};
	//	
	//			if (foundLine != noone) {
	//				var lineTotalPlacement = foundLine[? "placementTotal"];
	//				var elementPlacement = fm_panel[? "placement"];
	//		
	//				if (resizeEdge == 2 || resizeEdge == 6 || resizeEdge == 8) { // Right-side resizing
	//					// Calculate maximum width based on parent's available space and other elements' placements
	//					var otherElementsTotal = lineTotalPlacement - elementPlacement;
	//					var maxWidth = (parentSize.x * elementPlacement) / lineTotalPlacement;
	//					availableSpace.x = maxWidth + (parentSize.x * otherElementsTotal) / lineTotalPlacement;
	//				}
	//				else if (resizeEdge == 4 || resizeEdge == 7 || resizeEdge == 8) { // Bottom-side resizing
	//					// Calculate maximum height based on parent's available space
	//					var maxHeight = parentSize.y - (CanvasGetPosition(fm_panel).y + startHeight);
	//					availableSpace.y = maxHeight;
	//				}
	//				else if (resizeEdge == 1 || resizeEdge == 5 || resizeEdge == 7) { // Left-side resizing
	//					// For left resizing, we need to consider position constraints
	//					availableSpace.x = startWidth + startPosX;
	//				}
	//				else if (resizeEdge == 3 || resizeEdge == 5 || resizeEdge == 6) { // Top-side resizing
	//					// For top resizing, we need to consider position constraints
	//					availableSpace.y = startHeight + startPosY;
	//				}
	//			}
	//		} else {
	//			// For non-autoFit parents, use parent boundaries
	//			if (parentPanel != noone) {
	//				var parentSize = CanvasGetSize(parentPanel);
	//				var elementPos = GetElementStartPos(fm_panel);
	//				availableSpace.x = parentSize.x - elementPos.x;
	//				availableSpace.y = parentSize.y - elementPos.y;
	//			}
	//		}
	//
	//		switch (resizeEdge) {
	//			case 1: // Left
	//				newWidth = max(minWidth, startWidth - deltaX);
	//				newPosX = startPosX + (startWidth - newWidth);
	//				break;
	//			case 2: // Right
	//				newWidth = max(minWidth, min(availableSpace.x, startWidth + deltaX));
	//				break;
	//			case 3: // Top
	//				newHeight = max(minHeight, startHeight - deltaY);
	//				newPosY = startPosY + (startHeight - newHeight);
	//				break;
	//			case 4: // Bottom
	//				newHeight = max(minHeight, min(availableSpace.y, startHeight + deltaY));
	//				break;
	//			case 5: // Top-left
	//				newWidth = max(minWidth, startWidth - deltaX);
	//				newHeight = max(minHeight, startHeight - deltaY);
	//				newPosX = startPosX + (startWidth - newWidth);
	//				newPosY = startPosY + (startHeight - newHeight);
	//				break;
	//			case 6: // Top-right
	//				newWidth = max(minWidth, min(availableSpace.x, startWidth + deltaX));
	//				newHeight = max(minHeight, startHeight - deltaY);
	//				newPosY = startPosY + (startHeight - newHeight);
	//				break;
	//			case 7: // Bottom-left
	//				newWidth = max(minWidth, startWidth - deltaX);
	//				newHeight = max(minHeight, min(availableSpace.y, startHeight + deltaY));
	//				newPosX = startPosX + (startWidth - newWidth);
	//				break;
	//			case 8: // Bottom-right
	//				newWidth = max(minWidth, min(availableSpace.x, startWidth + deltaX));
	//				newHeight = max(minHeight, min(availableSpace.y, startHeight + deltaY));
	//				break;
	//		};
	//
	//		// Apply new size and position
	//		if (newWidth != pSize.x || newHeight != pSize.y) {
	//			CanvasSetSize(fm_panel, new Vector2(newWidth, newHeight));
	//	
	//			// Update position for left/top resizing
	//			if (newPosX != startPosX || newPosY != startPosY) {
	//				CanvasGetPosition(fm_panel).x = newPosX;
	//				CanvasGetPosition(fm_panel).y = newPosY;
	//			};
	//	
	//			// If parent is autoFit, recalculate the placement portion
	//			if (isParentAutoFit) {
	//				var parentSize = CanvasGetSize(parentPanel);
	//				var newPlacement = (newWidth / parentSize.x) * foundLine[? "placementTotal"];
	//		
	//				// Update the panel's placement weight
	//				fm_panel[? "placement"] = newPlacement;
	//		
	//				// Recalculate the line's total placement
	//				var lineTotal = 0;
	//				var lineElements = foundLine[? "elements"];
	//				for (var i = 0; i < ds_list_size(lineElements); i++) {
	//					lineTotal += lineElements[| i][? "placement"];
	//				};
	//				foundLine[? "placementTotal"] = lineTotal;
	//			}
	//	
	//			// Refresh panel layout
	//			fm_panel[? "refreshRequest"] = true;
	//	
	//			// Refresh parent layout
	//			if (parentPanel != noone) {
	//				parentPanel[? "refreshRequest"] = true;
	//			};
	//		};
	//	};
	//
	//	if (mouse_check_button_released(mb_left)) {
	//		ElementSetProperty(fm_panel, false, "resizeDragging");
	//		ElementSetProperty(fm_panel, 0, "resizeEdge");
	//	};
	//;
	STYLER_PANEL_UPDATE_BEFORE = function(fm_panel) {
		if (!IsHoverCanvasOptimized(fm_panel)) {
			return;
		};
		
		if (ElementPropertyExists(fm_panel, "m_scrollbarVertical")) {
			var m_scrollbarVertical = ElementGetProperty(fm_panel, "m_scrollbarVertical");
			var m_steps = 1000;
			if (ElementPropertyExists(fm_panel, "m_scrollbarVerticalSteps")) {
				m_steps = ElementGetProperty(fm_panel, "m_scrollbarVerticalSteps");
			};
			if (!keyboard_check(vk_alt)) {
				if (mouse_wheel_down()) {
					ScrollbarScrollDown(m_scrollbarVertical, m_steps);
				};
				if (mouse_wheel_up()) {
					ScrollbarScrollUp(m_scrollbarVertical, m_steps);
				};
			};
		};
		if (ElementPropertyExists(fm_panel, "m_scrollbarHorizontal")) {
			var m_scrollbarHorizontal = ElementGetProperty(fm_panel, "m_scrollbarHorizontal");
			var m_steps = 1000;
			if (ElementPropertyExists(fm_panel, "m_scrollbarHorizontalSteps")) {
				m_steps = ElementGetProperty(fm_panel, "m_scrollbarHorizontalSteps");
			};
			if (keyboard_check(vk_alt)) {
				if (mouse_wheel_down()) {
					ScrollbarScrollRight(m_scrollbarHorizontal, m_steps);
				};
				if (mouse_wheel_up()) {
					ScrollbarScrollLeft(m_scrollbarHorizontal, m_steps);
				};
			};
		};

		// Resize
		var mx = device_mouse_x_to_gui(0);
		var my = device_mouse_y_to_gui(0);
		var gap = 5;
		var pPos = GetElementStartPos(fm_panel);
		var pSize = CanvasGetSize(fm_panel);

		var isResizing = false;
		var resizeEdge = 0;

		// Check if we're currently resizing - if so, we don't need hover checks
		var isCurrentlyDragging = ElementGetProperty(fm_panel, "resizeDragging");
	
		if (isCurrentlyDragging) {
			// We're already resizing, continue with the current edge
			isResizing = true;
			resizeEdge = ElementGetProperty(fm_panel, "resizeEdge");
		} else if (IsHoverCanvasOptimized(fm_panel)) {
			// Only check for new resize operations when hovering the panel
			// Check resize edges
			// Left edge
			if (ElementGetProperty(fm_panel, "resizeMiddleLeft") && mx > pPos.x - gap && mx < pPos.x + gap && my > pPos.y + gap && my < pPos.y + pSize.y - gap) {
				////window_set_cursor(cr_size_we);
				isResizing = true;
				resizeEdge = 1;
			}
			// Right edge
			else if (ElementGetProperty(fm_panel, "resizeMiddleRight") && mx > pPos.x + pSize.x - gap && mx < pPos.x + pSize.x + gap && my > pPos.y + gap && my < pPos.y + pSize.y - gap) {
				////window_set_cursor(cr_size_we);
				isResizing = true;
				resizeEdge = 2;
			}
			// Top edge
			else if (ElementGetProperty(fm_panel, "resizeTopCenter") && my > pPos.y - gap && my < pPos.y + gap && mx > pPos.x + gap && mx < pPos.x + pSize.x - gap) {
				////window_set_cursor(cr_size_ns);
				isResizing = true;
				resizeEdge = 3;
			}
			// Bottom edge
			else if (ElementGetProperty(fm_panel, "resizeBottomCenter") && my > pPos.y + pSize.y - gap && my < pPos.y + pSize.y + gap && mx > pPos.x + gap && mx < pPos.x + pSize.x - gap) {
				//window_set_cursor(cr_size_ns);
				isResizing = true;
				resizeEdge = 4;
			}
			// Top-left corner
			else if (ElementGetProperty(fm_panel, "resizeTopLeft") && mx > pPos.x - gap && mx < pPos.x + gap && my > pPos.y - gap && my < pPos.y + gap) {
				//window_set_cursor(cr_size_nwse);
				isResizing = true;
				resizeEdge = 5;
			}
			// Top-right corner
			else if (ElementGetProperty(fm_panel, "resizeTopRight") && mx > pPos.x + pSize.x - gap && mx < pPos.x + pSize.x + gap && my > pPos.y - gap && my < pPos.y + gap) {
				//window_set_cursor(cr_size_nesw);
				isResizing = true;
				resizeEdge = 6;
			}
			// Bottom-left corner
			else if (ElementGetProperty(fm_panel, "resizeBottomLeft") && mx > pPos.x - gap && mx < pPos.x + gap && my > pPos.y + pSize.y - gap && my < pPos.y + pSize.y + gap) {
				//window_set_cursor(cr_size_nesw);
				isResizing = true;
				resizeEdge = 7;
			}
			// Bottom-right corner
			else if (ElementGetProperty(fm_panel, "resizeBottomRight") && mx > pPos.x + pSize.x - gap && mx < pPos.x + pSize.x + gap && my > pPos.y + pSize.y - gap && my < pPos.y + pSize.y + gap) {
				//window_set_cursor(cr_size_nwse);
				isResizing = true;
				resizeEdge = 8;
			};
		};

		// Handle resize dragging - this works regardless of mouse position
		if (isResizing && mouse_check_button_pressed(mb_left)) {
			ElementSetProperty(fm_panel, true, "resizeDragging");
			ElementSetProperty(fm_panel, resizeEdge, "resizeEdge");
			ElementSetProperty(fm_panel, mx, "resizeStartX");
			ElementSetProperty(fm_panel, my, "resizeStartY");
			ElementSetProperty(fm_panel, pSize.x, "resizeStartWidth");
			ElementSetProperty(fm_panel, pSize.y, "resizeStartHeight");
			ElementSetProperty(fm_panel, CanvasGetPosition(fm_panel).x, "resizeStartPosX");
			ElementSetProperty(fm_panel, CanvasGetPosition(fm_panel).y, "resizeStartPosY");
		};

		if (ElementGetProperty(fm_panel, "resizeDragging")) {
			// Set cursor based on current resize edge
			var currentResizeEdge = ElementGetProperty(fm_panel, "resizeEdge");
			switch (currentResizeEdge) {
				case 1: case 2: //window_set_cursor(cr_size_we); break;
				case 3: case 4: //window_set_cursor(cr_size_ns); break;
				case 5: case 8: //window_set_cursor(cr_size_nwse); break;
				case 6: case 7: //window_set_cursor(cr_size_nesw); break;
			};
		
			var startX = ElementGetProperty(fm_panel, "resizeStartX");
			var startY = ElementGetProperty(fm_panel, "resizeStartY");
			var startWidth = ElementGetProperty(fm_panel, "resizeStartWidth");
			var startHeight = ElementGetProperty(fm_panel, "resizeStartHeight");
			var startPosX = ElementGetProperty(fm_panel, "resizeStartPosX");
			var startPosY = ElementGetProperty(fm_panel, "resizeStartPosY");
	
			var deltaX = mx - startX;
			var deltaY = my - startY;
	
			var newWidth = startWidth;
			var newHeight = startHeight;
			var newPosX = startPosX;
			var newPosY = startPosY;
	
			// Calculate minimum size constraints
			var minWidth = ElementPropertyExists(fm_panel, "minWidth") ? ElementGetProperty(fm_panel, "minWidth") : 50;
			var minHeight = ElementPropertyExists(fm_panel, "minHeight") ? ElementGetProperty(fm_panel, "minHeight") : 50;
	
			// Check if parent is an autoFit panel and calculate available space
			var parentPanel = CanvasGetParent(fm_panel);
			var isParentAutoFit = (parentPanel != noone && ElementPropertyExists(parentPanel, "autoFit") && parentPanel[? "autoFit"]);
			var availableSpace = new Vector2(9999, 9999); // Large default values
	
			if (isParentAutoFit) {
				// Calculate available space based on parent's autoFit layout
				var parentSize = CanvasGetSize(parentPanel);
				var parentElements = CanvasGetElements(parentPanel);
		
				// Find this panel's line in parent's backup structure
				var parentBackup = parentPanel[? "backup"];
				var foundLine = noone;
				var elementIndexInLine = -1;
		
				// Search through parent's backup to find which line contains this panel
				for (var i = 0; i < ds_list_size(parentBackup); i++) {
					var line = parentBackup[| i];
					var lineElements = line[? "elements"];
			
					for (var j = 0; j < ds_list_size(lineElements); j++) {
						if (lineElements[| j] == fm_panel) {
							foundLine = line;
							elementIndexInLine = j;
							break;
						};
					};
					if (foundLine != noone) break;
				};
		
				if (foundLine != noone) {
					var lineTotalPlacement = foundLine[? "placementTotal"];
					var elementPlacement = fm_panel[? "placement"];
			
					if (currentResizeEdge == 2 || currentResizeEdge == 6 || currentResizeEdge == 8) { // Right-side resizing
						// Calculate maximum width based on parent's available space and other elements' placements
						var otherElementsTotal = lineTotalPlacement - elementPlacement;
						var maxWidth = (parentSize.x * elementPlacement) / lineTotalPlacement;
						availableSpace.x = maxWidth + (parentSize.x * otherElementsTotal) / lineTotalPlacement;
					}
					else if (currentResizeEdge == 4 || currentResizeEdge == 7 || currentResizeEdge == 8) { // Bottom-side resizing
						// Calculate maximum height based on parent's available space
						var maxHeight = parentSize.y - (CanvasGetPosition(fm_panel).y + startHeight);
						availableSpace.y = maxHeight;
					}
					else if (currentResizeEdge == 1 || currentResizeEdge == 5 || currentResizeEdge == 7) { // Left-side resizing
						// For left resizing, we need to consider position constraints
						availableSpace.x = startWidth + startPosX;
					}
					else if (currentResizeEdge == 3 || currentResizeEdge == 5 || currentResizeEdge == 6) { // Top-side resizing
						// For top resizing, we need to consider position constraints
						availableSpace.y = startHeight + startPosY;
					}
				}
			} else {
				// For non-autoFit parents, use parent boundaries
				if (parentPanel != noone) {
					var parentSize = CanvasGetSize(parentPanel);
					var elementPos = GetElementStartPos(fm_panel);
					availableSpace.x = parentSize.x - elementPos.x;
					availableSpace.y = parentSize.y - elementPos.y;
				}
			}
	
			switch (currentResizeEdge) {
				case 1: // Left
					newWidth = max(minWidth, startWidth - deltaX);
					newPosX = startPosX + (startWidth - newWidth);
					break;
				case 2: // Right
					newWidth = max(minWidth, min(availableSpace.x, startWidth + deltaX));
					break;
				case 3: // Top
					newHeight = max(minHeight, startHeight - deltaY);
					newPosY = startPosY + (startHeight - newHeight);
					break;
				case 4: // Bottom
					newHeight = max(minHeight, min(availableSpace.y, startHeight + deltaY));
					break;
				case 5: // Top-left
					newWidth = max(minWidth, startWidth - deltaX);
					newHeight = max(minHeight, startHeight - deltaY);
					newPosX = startPosX + (startWidth - newWidth);
					newPosY = startPosY + (startHeight - newHeight);
					break;
				case 6: // Top-right
					newWidth = max(minWidth, min(availableSpace.x, startWidth + deltaX));
					newHeight = max(minHeight, startHeight - deltaY);
					newPosY = startPosY + (startHeight - newHeight);
					break;
				case 7: // Bottom-left
					newWidth = max(minWidth, startWidth - deltaX);
					newHeight = max(minHeight, min(availableSpace.y, startHeight + deltaY));
					newPosX = startPosX + (startWidth - newWidth);
					break;
				case 8: // Bottom-right
					newWidth = max(minWidth, min(availableSpace.x, startWidth + deltaX));
					newHeight = max(minHeight, min(availableSpace.y, startHeight + deltaY));
					break;
			};
	
			// Apply new size and position
			if (newWidth != pSize.x || newHeight != pSize.y) {
				CanvasSetSize(fm_panel, new Vector2(newWidth, newHeight));
		
				// Update position for left/top resizing
				if (newPosX != startPosX || newPosY != startPosY) {
					CanvasGetPosition(fm_panel).x = newPosX;
					CanvasGetPosition(fm_panel).y = newPosY;
				};
		
				// If parent is autoFit, recalculate the placement portion
				if (isParentAutoFit && foundLine != noone) {
					var parentSize = CanvasGetSize(parentPanel);
					var newPlacement = (newWidth / parentSize.x) * foundLine[? "placementTotal"];
			
					// Update the panel's placement weight
					fm_panel[? "placement"] = newPlacement;
			
					// Recalculate the line's total placement
					var lineTotal = 0;
					var lineElements = foundLine[? "elements"];
					for (var i = 0; i < ds_list_size(lineElements); i++) {
						lineTotal += lineElements[| i][? "placement"];
					};
					foundLine[? "placementTotal"] = lineTotal;
				}
		
				// Refresh panel layout
				fm_panel[? "refreshRequest"] = true;
		
				// Refresh parent layout
				if (parentPanel != noone) {
					parentPanel[? "refreshRequest"] = true;
				};
			};
		};

		if (mouse_check_button_released(mb_left)) {
			ElementSetProperty(fm_panel, false, "resizeDragging");
			ElementSetProperty(fm_panel, 0, "resizeEdge");
		};
	};
	STYLER_PANEL_UPDATE_AFTER = function(fm_panel) {
	};
	STYLER_PANEL_DRAW_BEFORE = function(fm_panel) {
		var color = CanvasGetBackgroundColor(fm_panel);
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(0, 0, CanvasGetSize(fm_panel).x, CanvasGetSize(fm_panel).y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	STYLER_PANEL_DRAW_AFTER = function(fm_panel) {
	};

	// Panel Title - Button Child (Mixed up with Checkbox)
	STYLER_PANELTITLE_UPDATE_BEFORE = function(fm_title) {
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_title) && ButtonGetState(fm_title) != CLICKABLE_STATE.DISABLED && !PanelTitleGetLock(fm_title)) {
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_title, CLICKABLE_STATE.HOT);
			}
			else if (ButtonGetState(fm_title) != CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_title, CLICKABLE_STATE.HOVER);
			};
			if (mouse_check_button_released(mb_left) && ButtonGetState(fm_title) == CLICKABLE_STATE.HOT) {
				if (ButtonGetOnClick(fm_title) != noone) {
					ButtonGetOnClick(fm_title)(fm_title);
				};
				CheckboxSetCheck(fm_title, !CheckboxGetCheck(fm_title));
				ElementSetProperty(fm_title, true, "checkcheck");
			};
		}
		else {
			ButtonSetState(fm_title, CLICKABLE_STATE.IDLE);
		};
	
		if (ElementPropertyExists(fm_title, "checkcheck")) { // if true, its an update request
			if (ElementGetProperty(fm_title, "checkcheck")) {
				ElementSetProperty(fm_title, false, "checkcheck");
			
				var elements = ElementGetProperty(fm_title, "responsibleElements");
				for (var i = 0; i < ds_list_size(elements); i++) {
					var element = elements[| i];
					
					if (!CanvasGetActive(fm_title)) {
						CanvasDeactivate(element);
						if (ElementPropertyExists(element, "checkcheck")) {
							ElementSetProperty(element, true, "checkcheck");
						};
						continue;
					};
					if (CheckboxGetCheck(fm_title)) {
						CanvasActivate(element);
					}
					else {
						CanvasDeactivate(element);
					};
					if (ElementPropertyExists(element, "checkcheck")) { // check if its a panel title
						ElementSetProperty(element, true, "checkcheck");
					};
				};
				PanelRefresh(CanvasGetParent(fm_title));
			};
		};
	};
	STYLER_PANELTITLE_UPDATE_AFTER = function(fm_title) {
	};
	STYLER_PANELTITLE_DRAW_BEFORE = function(fm_title) {
		var state = ButtonGetState(fm_title);
		var color = noone;
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(31, 31, 31, 0);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(51, 51, 51, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(22, 22, 22, 255);
		} break;
		};
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(0, 0, CanvasGetSize(fm_title).x, CanvasGetSize(fm_title).y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	STYLER_PANELTITLE_DRAW_AFTER = function(fm_title) {
		var color = noone;
	
		if (ButtonGetState(fm_title) == CLICKABLE_STATE.DISABLED) {
			color = new Vector4(128, 128, 128, 255);
		}
		else {
			color = new Vector4(255, 255, 255, 255);
		};
	
		var oldHAlign = draw_get_halign();
		var oldVAlign = draw_get_valign();
		var oldFont = draw_get_font();
	
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_set_font(ButtonGetFont(fm_title));
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
	
		if (CheckboxGetCheck(fm_title)) {
			draw_triangle(2, CanvasGetSize(fm_title).y / 2 - 2, 8, CanvasGetSize(fm_title).y / 2 - 2, 5, CanvasGetSize(fm_title).y / 2 + 2, false);
		}
		else {
			draw_triangle(4, CanvasGetSize(fm_title).y / 2 - 4, 4, CanvasGetSize(fm_title).y / 2 + 4, 8, CanvasGetSize(fm_title).y / 2, false);
		};
		draw_text(14, CanvasGetSize(fm_title).y / 2, ButtonGetText(fm_title));
		draw_line(14 + string_width(ButtonGetText(fm_title)) + 5, CanvasGetSize(fm_title).y / 2, CanvasGetSize(fm_title).x - 14, CanvasGetSize(fm_title).y / 2);
	
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_set_halign(oldHAlign);
		draw_set_valign(oldHAlign);
		draw_set_font(oldFont);
	
		delete color;
	};

	// Scrollbar Vertical - Not a child of button but a mixed version
	// Background
	STYLER_SCROLLBARVERTICALBACKGROUND_UPDATE_BEFORE = function(fm_element) {
		if (ButtonGetState(fm_element) == CLICKABLE_STATE.DISABLED) {
			return;
		};
	
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_element)) {
			ButtonSetState(fm_element, CLICKABLE_STATE.HOVER);
			if (mouse_check_button_pressed(mb_left)) {
				var anchor = ScrollbarGetAnchor(fm_element);
			
				var mdfy = device_mouse_y_to_gui(0);
				ElementSetProperty(anchor, mdfy - CanvasGetSize(anchor).y / 2, "targetPos");
				if (ElementGetProperty(anchor, "targetPos") < 0) {
					ElementSetProperty(anchor, 0, "targetPos");
				};
				if (ElementGetProperty(anchor, "targetPos") > CanvasGetPosition(fm_element).y + CanvasGetSize(fm_element).y - CanvasGetSize(anchor).y) {
					ElementSetProperty(anchor, CanvasGetPosition(fm_element).y + CanvasGetSize(fm_element).y - CanvasGetSize(anchor).y, "targetPos");
				};
			};
			if (mouse_check_button(mb_left)) {
				ButtonSetState(fm_element, CLICKABLE_STATE.HOT);
			};
		}
		else {
			ButtonSetState(fm_element, CLICKABLE_STATE.IDLE);
		};
	};
	STYLER_SCROLLBARVERTICALBACKGROUND_UPDATE_AFTER = function(fm_element) {
	};
	STYLER_SCROLLBARVERTICALBACKGROUND_DRAW_BEFORE = function(fm_element) {
		var state = ButtonGetState(fm_element);
		var color = noone;
	
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(60, 60, 60, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(60, 60, 60, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(60, 60, 60, 255);
		} break;
		};
	
		if (ElementGetProperty(ScrollbarGetAnchor(fm_element), "avg") != 1) { // 1 is full size, 0.5 is half size it can get(which is its background's size)
			draw_set_color(make_color_rgb(color.x, color.y, color.z));
			draw_set_alpha(color.w / 255);
			draw_rectangle(0, 0, CanvasGetSize(fm_element).x, CanvasGetSize(fm_element).y, false);
			draw_set_alpha(1);
			draw_set_color(c_white);
		};
	
		delete color;
	};
	STYLER_SCROLLBARVERTICALBACKGROUND_DRAW_AFTER = function(fm_element) {
	};

	// Anchor
	STYLER_SCROLLBARVERTICALANCHOR_UPDATE_BEFORE = function(fm_element) {
		if (ButtonGetState(fm_element) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		
		CanvasGetPosition(fm_element).x = CanvasGetPosition(ElementGetProperty(fm_element, "__background")).x;
		CanvasGetSize(fm_element).x = CanvasGetSize(ElementGetProperty(fm_element, "__background")).x;
		
		ElementSetProperty(fm_element, max(0, min(1, ElementGetProperty(fm_element, "ori"))), "ori");
		
		var targetCanvas = ElementGetProperty(fm_element, "targetCanvas");
		var elements = CanvasGetElements(targetCanvas);
		var targetHeight = CanvasGetSize(targetCanvas).y;
		var totalHeight = ElementGetProperty(targetCanvas, "highestPointOnY");
		ElementSetProperty(fm_element, min(1, targetHeight / totalHeight), "avg");
		var diff = max(0, totalHeight - targetHeight);
		var toAdd = Mix(0, diff, ElementGetProperty(fm_element, "ori"));
		var pos = Mix(0, CanvasGetSize(ElementGetProperty(fm_element, "__background")).y - CanvasGetSize(fm_element).y, ElementGetProperty(fm_element, "ori"));
		var oldPos = CanvasGetPosition(fm_element).y;
		CanvasGetPosition(fm_element).y = CanvasGetPosition(ElementGetProperty(fm_element, "__background")).y + pos;
		var oldSize = CanvasGetSize(fm_element).y;
		CanvasGetSize(fm_element).y = ElementGetProperty(fm_element, "avg") * CanvasGetSize(ElementGetProperty(fm_element, "__background")).y;
		if (oldSize != CanvasGetSize(fm_element).y) {
			surface_resize(fm_element[? "surface"], CanvasGetSize(fm_element).x, CanvasGetSize(fm_element).y);
		};
		
		for (var i = 0; i < ds_list_size(elements); i++) {
			var element = elements[| i];
			ElementSetProperty(element, -toAdd, "extraAddY");
		};
		
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_element)) {
			ButtonSetState(fm_element, CLICKABLE_STATE.HOVER);
			if (mouse_check_button_pressed(mb_left)) {
				ElementSetProperty(fm_element, true, "dragging");
				ElementSetProperty(fm_element, device_mouse_y_to_gui(0), "draggingStartPosMouse");
				ElementSetProperty(fm_element, CanvasGetPosition(fm_element).y, "draggingStartPosAnchor");
			};
			if (mouse_check_button(mb_left)) {
				ButtonSetState(fm_element, CLICKABLE_STATE.HOT);
			};
		}
		else {
			ButtonSetState(fm_element, CLICKABLE_STATE.IDLE);
		};
		
		if (ElementGetProperty(fm_element, "dragging")) {
			ButtonSetState(fm_element, CLICKABLE_STATE.HOT);
			var my = device_mouse_y_to_gui(0);
			var py = CanvasGetPosition(fm_element).y;
			var sz = CanvasGetSize(fm_element).y;
			var df = my - ElementGetProperty(fm_element, "draggingStartPosMouse");
			ElementSetProperty(fm_element, ElementGetProperty(fm_element, "draggingStartPosAnchor") + df, "targetPos");
		};
		
		if (ElementGetProperty(fm_element, "targetPos") < CanvasGetPosition(ElementGetProperty(fm_element, "__background")).y) {
			ElementSetProperty(fm_element, CanvasGetPosition(ElementGetProperty(fm_element, "__background")).y, "targetPos");
		};
		if (ElementGetProperty(fm_element, "targetPos") > CanvasGetPosition(ElementGetProperty(fm_element, "__background")).y + CanvasGetSize(ElementGetProperty(fm_element, "__background")).y - CanvasGetSize(fm_element).y) {
			ElementSetProperty(fm_element, CanvasGetPosition(ElementGetProperty(fm_element, "__background")).y + CanvasGetSize(ElementGetProperty(fm_element, "__background")).y - CanvasGetSize(fm_element).y, "targetPos");
		};
		
		CanvasGetPosition(fm_element).y = lerp(CanvasGetPosition(fm_element).y, ElementGetProperty(fm_element, "targetPos"), ElementGetProperty(fm_element, "lerpFactor"));
		ElementSetProperty(fm_element, (GetElementStartPosOffScreen(fm_element).y - GetElementStartPosOffScreen(ElementGetProperty(fm_element, "__background")).y) / (CanvasGetSize(ElementGetProperty(fm_element, "__background")).y - CanvasGetSize(fm_element).y), "ori");
		
		if (mouse_check_button_released(mb_left)) {
			ElementSetProperty(fm_element, false, "dragging");
		};
	};
	STYLER_SCROLLBARVERTICALANCHOR_UPDATE_AFTER = function(fm_element) {
	};
	STYLER_SCROLLBARVERTICALANCHOR_DRAW_BEFORE = function(fm_element) {
		var state = ButtonGetState(fm_element);
		var color = noone;
	
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(100, 100, 100, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(200, 200, 200, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(240, 240, 240, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(170, 170, 170, 255);
		} break;
		};
	
		if (ElementGetProperty(fm_element, "avg") != 1) {
			draw_set_color(make_color_rgb(color.x, color.y, color.z));
			draw_set_alpha(color.w / 255);
			draw_rectangle(0, 0, CanvasGetSize(fm_element).x, CanvasGetSize(fm_element).y, false);
			draw_set_alpha(1);
			draw_set_color(c_white);
		};
	
		delete color;
	};
	STYLER_SCROLLBARVERTICALANCHOR_DRAW_AFTER = function(fm_element) {
	};

	// Scrollbar Horizontal
	// Background
	STYLER_SCROLLBARHORIZONTALBACKGROUND_UPDATE_BEFORE = function(fm_element) {
		if (ButtonGetState(fm_element) == CLICKABLE_STATE.DISABLED) {
			return;
		};
	
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_element)) {
			ButtonSetState(fm_element, CLICKABLE_STATE.HOVER);
			if (mouse_check_button_pressed(mb_left)) {
				var anchor = ScrollbarGetAnchor(fm_element);
			
				var mdfy = device_mouse_x_to_gui(0);
				ElementSetProperty(anchor, mdfy - CanvasGetSize(anchor).x / 2, "targetPos");
				if (ElementGetProperty(anchor, "targetPos") < 0) {
					ElementSetProperty(anchor, 0, "targetPos");
				};
				if (ElementGetProperty(anchor, "targetPos") > CanvasGetPosition(fm_element).x + CanvasGetSize(fm_element).x - CanvasGetSize(anchor).x) {
					ElementSetProperty(anchor, CanvasGetPosition(fm_element).x + CanvasGetSize(fm_element).x - CanvasGetSize(anchor).x, "targetPos");
				};
			};
			if (mouse_check_button(mb_left)) {
				ButtonSetState(fm_element, CLICKABLE_STATE.HOT);
			};
		}
		else {
			ButtonSetState(fm_element, CLICKABLE_STATE.IDLE);
		};
	};
	STYLER_SCROLLBARHORIZONTALBACKGROUND_UPDATE_AFTER = function(fm_element) {
	};
	STYLER_SCROLLBARHORIZONTALBACKGROUND_DRAW_BEFORE = function(fm_element) {
		var state = ButtonGetState(fm_element);
		var color = noone;
	
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(80, 63, 110, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(60, 60, 60, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(60, 60, 60, 255);
		} break;
		};
	
		if (ElementGetProperty(ScrollbarGetAnchor(fm_element), "avg") != 1) {
			draw_set_color(make_color_rgb(color.x, color.y, color.z));
			draw_set_alpha(color.w / 255);
			draw_rectangle(0, 0, CanvasGetSize(fm_element).x, CanvasGetSize(fm_element).y, false);
			draw_set_alpha(1);
			draw_set_color(c_white);
		};
	
		delete color;
	};
	STYLER_SCROLLBARHORIZONTALBACKGROUND_DRAW_AFTER = function(fm_element) {
	};

	// Anchor
	STYLER_SCROLLBARHORIZONTALANCHOR_UPDATE_BEFORE = function(fm_element) {
		if (ButtonGetState(fm_element) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		
		CanvasGetPosition(fm_element).y = CanvasGetPosition(ElementGetProperty(fm_element, "__background")).y;
		CanvasGetSize(fm_element).y = CanvasGetSize(ElementGetProperty(fm_element, "__background")).y;
		
		ElementSetProperty(fm_element, max(0, min(1, ElementGetProperty(fm_element, "ori"))), "ori");
		
		var targetCanvas = ElementGetProperty(fm_element, "targetCanvas");
		var elements = CanvasGetElements(targetCanvas);
		var targetHeight = CanvasGetSize(targetCanvas).x;
		var totalHeight = ElementGetProperty(targetCanvas, "highestPointOnX");
		ElementSetProperty(fm_element, min(1, targetHeight / totalHeight), "avg");
		var diff = max(0, totalHeight - targetHeight);
		var toAdd = Mix(0, diff, ElementGetProperty(fm_element, "ori"));
		var pos = Mix(0, CanvasGetSize(ElementGetProperty(fm_element, "__background")).x - CanvasGetSize(fm_element).x, ElementGetProperty(fm_element, "ori"));
		var oldPos = CanvasGetPosition(fm_element).x;
		CanvasGetPosition(fm_element).x = CanvasGetPosition(ElementGetProperty(fm_element, "__background")).x + pos;
		var oldSize = CanvasGetSize(fm_element).x;
		CanvasGetSize(fm_element).x = ElementGetProperty(fm_element, "avg") * CanvasGetSize(ElementGetProperty(fm_element, "__background")).x;
		if (oldSize != CanvasGetSize(fm_element).x) {
			surface_resize(fm_element[? "surface"], CanvasGetSize(fm_element).x, CanvasGetSize(fm_element).y);
		};
	
		for (var i = 0; i < ds_list_size(elements); i++) {
			var element = elements[| i];
			ElementSetProperty(element, -toAdd, "extraAddX");
		};
	
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_element)) {
			ButtonSetState(fm_element, CLICKABLE_STATE.HOVER);
			if (mouse_check_button_pressed(mb_left)) {
				ElementSetProperty(fm_element, true, "dragging");
				ElementSetProperty(fm_element, device_mouse_x_to_gui(0), "draggingStartPosMouse");
				ElementSetProperty(fm_element, CanvasGetPosition(fm_element).x, "draggingStartPosAnchor");
			};
			if (mouse_check_button(mb_left)) {
				ButtonSetState(fm_element, CLICKABLE_STATE.HOT);
			};
		}
		else {
			ButtonSetState(fm_element, CLICKABLE_STATE.IDLE);
		};
	
		if (ElementGetProperty(fm_element, "dragging")) {
			ButtonSetState(fm_element, CLICKABLE_STATE.HOT);
			var my = device_mouse_x_to_gui(0);
			var py = CanvasGetPosition(fm_element).x;
			var sz = CanvasGetSize(fm_element).x;
			var df = my - ElementGetProperty(fm_element, "draggingStartPosMouse");
			ElementSetProperty(fm_element, ElementGetProperty(fm_element, "draggingStartPosAnchor") + df, "targetPos");
		};
	
		if (ElementGetProperty(fm_element, "targetPos") < CanvasGetPosition(ElementGetProperty(fm_element, "__background")).x) {
			ElementSetProperty(fm_element, CanvasGetPosition(ElementGetProperty(fm_element, "__background")).x, "targetPos");
		};
		if (ElementGetProperty(fm_element, "targetPos") > CanvasGetPosition(ElementGetProperty(fm_element, "__background")).x + CanvasGetSize(ElementGetProperty(fm_element, "__background")).x - CanvasGetSize(fm_element).x) {
			ElementSetProperty(fm_element, CanvasGetPosition(ElementGetProperty(fm_element, "__background")).x + CanvasGetSize(ElementGetProperty(fm_element, "__background")).x - CanvasGetSize(fm_element).x, "targetPos");
		};
	
		CanvasGetPosition(fm_element).x = lerp(CanvasGetPosition(fm_element).x, ElementGetProperty(fm_element, "targetPos"), ElementGetProperty(fm_element, "lerpFactor"));
		ElementSetProperty(fm_element, (GetElementStartPosOffScreen(fm_element).x - GetElementStartPosOffScreen(ElementGetProperty(fm_element, "__background")).x) / (CanvasGetSize(ElementGetProperty(fm_element, "__background")).x - CanvasGetSize(fm_element).x), "ori");
	
		if (mouse_check_button_released(mb_left)) {
			ElementSetProperty(fm_element, false, "dragging");
		};
	};
	STYLER_SCROLLBARHORIZONTALANCHOR_UPDATE_AFTER = function(fm_element) {
	};
	STYLER_SCROLLBARHORIZONTALANCHOR_DRAW_BEFORE = function(fm_element) {
		var state = ButtonGetState(fm_element);
		var color = noone;
	
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(100, 100, 100, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(154, 137, 184, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(218, 183, 230, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(154, 137, 184, 235);
		} break;
		};
	
		if (ElementGetProperty(fm_element, "avg") != 1) {
			draw_set_color(make_color_rgb(color.x, color.y, color.z));
			draw_set_alpha(color.w / 255);
			draw_rectangle(0, 0, CanvasGetSize(fm_element).x, CanvasGetSize(fm_element).y, false);
			draw_set_alpha(1);
			draw_set_color(c_white);
		};
	
		delete color;
	};
	STYLER_SCROLLBARHORIZONTALANCHOR_DRAW_AFTER = function(fm_element) {
	};

	// Textbox [[DEPRECATED]]
	// Textbox
	STYLER_TEXTBOXDP_UPDATE_BEFORE = function(fm_textbox) {
		if (fm_textbox[? "state"] == CLICKABLE_STATE.DISABLED) {
			return;
		};
		if (IsHoverCanvasOptimized(fm_textbox)) {
			fm_textbox[? "state"] = CLICKABLE_STATE.HOVER;
		}
		else {
			fm_textbox[? "state"] = CLICKABLE_STATE.IDLE;
		};
	};
	STYLER_TEXTBOXDP_UPDATE_AFTER = function(fm_textbox) {
	};
	STYLER_TEXTBOXDP_DRAW_BEFORE = function(fm_textbox) {
		var state = fm_textbox[? "state"];
		var color = noone;
	
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(41, 41, 41, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(41, 41, 41, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(41, 41, 41, 255);
		} break;
		};
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(0, 0, fm_textbox[? "size"].x, fm_textbox[? "size"].y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	STYLER_TEXTBOXDP_DRAW_AFTER = function(fm_textbox) {
	};
	// Container
	STYLER_TEXTBOXDPCONTAINER_UPDATE_BEFORE = function(fm_container) {
		if (fm_container[? "state"] == CLICKABLE_STATE.DISABLED) {
			return;
		};
		if 
		(
			CanvasGetSize(fm_container[? "textbox"]).x - fm_container[? "textbox"][? "containerGap"].x * 2 != CanvasGetSize(fm_container).x 
			|| 
			CanvasGetSize(fm_container[? "textbox"]).y - fm_container[? "textbox"][? "containerGap"].y * 2 != CanvasGetSize(fm_container).y
		) 
		{
			CanvasSetSize(fm_container, new Vector2(CanvasGetSize(fm_container[? "textbox"]).x - fm_container[? "textbox"][? "containerGap"].x * 2, CanvasGetSize(fm_container[? "textbox"]).y - fm_container[? "textbox"][? "containerGap"].y * 2));
		};
		fm_container[? "point"][? "timer"]++;
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_container)) {
			//window_set_cursor(cr_beam);
			if (fm_container[? "state"] != CLICKABLE_STATE.HOT) {
				fm_container[? "state"] = CLICKABLE_STATE.HOVER;
			};
			
			if (fm_container[? "state"] == CLICKABLE_STATE.HOT) {
				if (mouse_check_button(mb_left)) { // user is dragging, set the second selection
				};
				if (mouse_check_button_released(mb_left)) { // user stopped dragging, stop the dragging
				};
				//show_debug_message(fm_container[? "dragging"]);
			};
			if (mouse_check_button_pressed(mb_left)/* || (mouse_check_button(mb_left) && fm_container[? "state"] == CLICKABLE_STATE.HOT)*/) { // user just entered, set the selection
				fm_container[? "state"] = CLICKABLE_STATE.HOT;
				// set the point
				// find the line
				var elements = fm_container[? "elements"];
				var eSize = ds_list_size(elements);
				if (eSize > 0) {
					var extraAddX = 0;
					var extraAddY = 0;
					if (ds_map_exists(elements[| 0], "extraAddX")) {
						extraAddX = elements[| 0][? "extraAddX"];
					};
					if (ds_map_exists(elements[| 0], "extraAddY")) {
						extraAddY = elements[| 0][? "extraAddY"];
					};
					var mx = device_mouse_x_to_gui(0) - GetElementStartPos(fm_container).x + fm_container[? "lineGap"].x + extraAddX;
					var my = device_mouse_y_to_gui(0) - GetElementStartPos(fm_container).y + fm_container[? "lineGap"].y + extraAddY;
					var midx = (my - (my % (elements[| 0][? "size"].y + fm_container[? "lineGap"].y))) / (elements[| 0][? "size"].y + fm_container[? "lineGap"].y);
					var clickedLineIndex = midx;
					if (clickedLineIndex > eSize - 1) { // make it last
						clickedLineIndex = eSize - 1;
					};
					var line = elements[| clickedLineIndex];
					// find the column
					var ci = 0;
					var temptotaltext = "";
					var brokenAt = -1;
					for (var i = 0; i < string_length(line[? "text"]); i++) {
						var oldFont = draw_get_font();
						draw_set_font(line[? "font"]);
						var currentPos = GetElementStartPosOffScreen(fm_container).x + fm_container[? "lineGap"].x + string_width(temptotaltext);
						draw_set_font(oldFont);
					
						if (currentPos > mx) {
							var oldFont = draw_get_font();
							draw_set_font(line[? "font"]);
							var charWidth = string_width(string_char_at(line[? "text"], i));
							draw_set_font(oldFont);
						
							if (mx > currentPos - charWidth / 2) {
								brokenAt = i;
							}
							else {
								brokenAt = i - 1;
							};
						
							break;
						};
					
						temptotaltext += string_char_at(line[? "text"], i);
					};
					if (brokenAt == -1) { // make it last
						brokenAt = string_length(line[? "text"]);
					};
				
					if (!keyboard_check(vk_shift)) {
						fm_container[? "point1"][? "lineIndex"] = clickedLineIndex;
						fm_container[? "point1"][? "charIndex"] = brokenAt;
						fm_container[? "point"][? "lineIndex"] = fm_container[? "point1"][? "lineIndex"];
						fm_container[? "point"][? "charIndex"] = fm_container[? "point1"][? "charIndex"];
					}
					else {
						fm_container[? "point"][? "lineIndex"] = fm_container[? "point1"][? "lineIndex"];
						fm_container[? "point"][? "charIndex"] = fm_container[? "point1"][? "charIndex"];
					};
				};
			};
		}
		else {
			if (mouse_check_button_pressed(mb_left)) {
				fm_container[? "state"] = CLICKABLE_STATE.IDLE;
				//fm_container[? "point1"][? "charIndex"] = fm_container[? "point"][? "charIndex"];
			};
			if (fm_container[? "state"] != CLICKABLE_STATE.HOT) {
				fm_container[? "state"] = CLICKABLE_STATE.IDLE;
			};
		};
	
		// if the ui is focused, update the selected line
		if (fm_container[? "state"] == CLICKABLE_STATE.HOT) {
			if (mouse_check_button(mb_left)) {
				var elements = fm_container[? "elements"];
				var eSize = ds_list_size(elements);
				if (eSize > 0) {
					var extraAddX = 0;
					var extraAddY = 0;
					if (ds_map_exists(elements[| 0], "extraAddX")) {
						extraAddX = elements[| 0][? "extraAddX"];
					};
					if (ds_map_exists(elements[| 0], "extraAddY")) {
						extraAddY = elements[| 0][? "extraAddY"];
					};
					var mx = device_mouse_x_to_gui(0) - GetElementStartPos(fm_container).x + fm_container[? "lineGap"].x + extraAddX;
					var my = device_mouse_y_to_gui(0) - GetElementStartPos(fm_container).y + fm_container[? "lineGap"].y + extraAddY;
					var midx = (my - (my % (elements[| 0][? "size"].y + fm_container[? "lineGap"].y))) / (elements[| 0][? "size"].y + fm_container[? "lineGap"].y);
					var clickedLineIndex = midx;
					if (clickedLineIndex > eSize - 1) { // make it last
						clickedLineIndex = eSize - 1;
					};
					clickedLineIndex = 0; ////////
					var line = elements[| clickedLineIndex];
					//if (line == undefined) { return; };
					// find the column
					var ci = 0;
					var temptotaltext = "";
					var brokenAt = -1;
					for (var i = 0; i < string_length(line[? "text"]); i++) {
						var oldFont = draw_get_font();
						draw_set_font(line[? "font"]);
						var currentPos = GetElementStartPosOffScreen(fm_container).x + fm_container[? "lineGap"].x + string_width(temptotaltext);
						draw_set_font(oldFont);
				
						if (currentPos > mx) {
							var oldFont = draw_get_font();
							draw_set_font(line[? "font"]);
							var charWidth = string_width(string_char_at(line[? "text"], i));
							draw_set_font(oldFont);
					
							if (mx > currentPos - charWidth / 2) {
								brokenAt = i;
							}
							else {
								brokenAt = i - 1;
							};
					
							break;
						};
				
						temptotaltext += string_char_at(line[? "text"], i);
					};
					if (brokenAt == -1) { // make it last
						brokenAt = string_length(line[? "text"]);
					};
			
					fm_container[? "point"][? "lineIndex"] = clickedLineIndex;
					fm_container[? "point"][? "charIndex"] = brokenAt;
				};
			};
		
			if (keyboard_lastkey != vk_nokey) {
				if (ds_list_size(fm_container[? "elements"]) > 0) {
					var point = fm_container[? "point"];
					var point1 = fm_container[? "point1"];
				
					if (keyboard_check(vk_shift)) {
						if (keyboard_check_pressed(vk_right)) {
							point[? "charIndex"]++;
							if (keyboard_check(vk_control)) {
								var spacePos = string_pos_ext(" ", fm_container[? "elements"][| 0][? "text"], point[? "charIndex"] + 1);
								if (spacePos == 0) { // couldnt find
									spacePos = string_length(fm_container[? "elements"][| 0][? "text"]) + 1;
								};
								point[? "charIndex"] = spacePos - 1;
							};
							point[? "charIndex"] = min(string_length(fm_container[? "elements"][| 0][? "text"]), max(0, point[? "charIndex"]));
							keyboard_lastkey = vk_nokey;
							return;
						};
						if (keyboard_check_pressed(vk_left)) {
							point[? "charIndex"]--;
							if (keyboard_check(vk_control)) {
								var reversedText = "";
								for(var i = string_length(fm_container[? "elements"][| 0][? "text"]); i > 0; i--){
								    reversedText += string_char_at(fm_container[? "elements"][| 0][? "text"],i);
								};
								var spacePos = string_pos_ext(" ", fm_container[? "elements"][| 0][? "text"], string_length(fm_container[? "elements"][| 0][? "text"]) - point[? "charIndex"]);
								if (spacePos == 0) { // couldnt find
									spacePos = 0;
								}
								else {
									point[? "charIndex"] = string_length(fm_container[? "elements"][| 0][? "text"]) - spacePos;
								};
							};
							point[? "charIndex"] = min(string_length(fm_container[? "elements"][| 0][? "text"]), max(0, point[? "charIndex"]));
							keyboard_lastkey = vk_nokey;
							return;
						};
					};
				
					if (keyboard_check(vk_control)) {
						if (keyboard_check_pressed(vk_right)) {
							point[? "charIndex"]++;
							if (keyboard_check(vk_control)) {
								var spacePos = string_pos_ext(" ", fm_container[? "elements"][| 0][? "text"], point[? "charIndex"] + 1);
								if (spacePos == 0) { // couldnt find
									spacePos = string_length(fm_container[? "elements"][| 0][? "text"]) + 1;
								};
								point[? "charIndex"] = spacePos - 1;
							};
							point[? "charIndex"] = min(string_length(fm_container[? "elements"][| 0][? "text"]), max(0, point[? "charIndex"]));
							point1[? "charIndex"] = point[? "charIndex"];
						};
						if (keyboard_check_pressed(vk_left)) {
							point[? "charIndex"]--;
							if (keyboard_check(vk_control)) {
								var reversedText = "";
								for(var i = string_length(fm_container[? "elements"][| 0][? "text"]); i > 0; i--){
								    reversedText += string_char_at(fm_container[? "elements"][| 0][? "text"],i);
								};
								var spacePos = string_pos_ext(" ", fm_container[? "elements"][| 0][? "text"], string_length(fm_container[? "elements"][| 0][? "text"]) - point[? "charIndex"]);
								if (spacePos == 0) { // couldnt find
									spacePos = 0;
								}
								else {
									point[? "charIndex"] = string_length(fm_container[? "elements"][| 0][? "text"]) - spacePos;
								};
							};
							point[? "charIndex"] = min(string_length(fm_container[? "elements"][| 0][? "text"]), max(0, point[? "charIndex"]));
							point1[? "charIndex"] = point[? "charIndex"];
						};
						if (keyboard_check_pressed(ord("A"))) {
							point1[? "charIndex"] = 0;
							point[? "charIndex"] = string_length(fm_container[? "elements"][| 0][? "text"]);
						};
						if (keyboard_check_pressed(ord("C"))) {
							var ps = min(point[? "charIndex"], point1[? "charIndex"]);
							var pe = max(point[? "charIndex"], point1[? "charIndex"]);
						
							var text = "";
							for (var i = ps; i < pe; i++) {
								text += string_char_at(fm_container[? "elements"][| 0][? "text"], i + 1);
							};
						
							clipboard_set_text(text);
						};
						if (keyboard_check_pressed(ord("X"))) {
							var line = fm_container[? "elements"][| point[? "lineIndex"]];
							var text = line[? "text"];
						
							var ps = min(point[? "charIndex"], point1[? "charIndex"]);
							var pe = max(point[? "charIndex"], point1[? "charIndex"]);
					
							var textC = "";
							for (var i = ps; i < pe; i++) {
								textC += string_char_at(fm_container[? "elements"][| 0][? "text"], i + 1);
							};
						
							clipboard_set_text(textC);
					
							var newText = "";
							var textl = string_length(text);
							for (var i = 0; i < textl; i++) {
								if (i < ps || i > pe - 1) {
									newText += string_char_at(text, i + 1);
								};
							};
							line[? "text"] = newText;
					
							var width, height;
							var oldFont = draw_get_font();
							draw_set_font(line[? "font"]);
							width = max(string_width(line[? "text"]), 1);
							height = max(string_height(line[? "text"]), 1);
							draw_set_font(oldFont);
							surface_resize(line[? "surface"], width, height);
							line[? "size"].x = width;
							line[? "size"].y = height;
					
							if (point[? "charIndex"] > point1[? "charIndex"]) {
								point[? "charIndex"] = point1[? "charIndex"];
							}
							else {
								point1[? "charIndex"] = point[? "charIndex"];
							};
						
							var width, height;
							var oldFont = draw_get_font();
							draw_set_font(line[? "font"]);
							width = max(string_width(line[? "text"]), 1);
							height = max(string_height(line[? "text"]), 1);
							draw_set_font(oldFont);
							surface_resize(line[? "surface"], width, height);
							line[? "size"].x = width;
							line[? "size"].y = height;
						};
						if (keyboard_check_pressed(ord("V"))) {
							var line = fm_container[? "elements"][| point[? "lineIndex"]];
							var text = line[? "text"];
					
							var ps = min(point[? "charIndex"], point1[? "charIndex"]);
							var pe = max(point[? "charIndex"], point1[? "charIndex"]);
					
							var newText = "";
							var textl = string_length(text);
							for (var i = 0; i < textl; i++) {
								if (i < ps || i > pe - 1) {
									var cpy = newText;
									newText += string_char_at(text, i + 1);
								};
							};
							line[? "text"] = newText;
						
							var t = clipboard_get_text();
						
							var cpy = newText;
							cpy = string_insert(t, line[? "text"], point[? "charIndex"] + 1);
							var width;
							var oldFont = draw_get_font();
							draw_set_font(line[? "font"]);
							width = max(string_width(cpy), 1);
							draw_set_font(oldFont);
							if (width > fm_container[? "size"].x) {
								line[? "text"] = text;
								return;
							};
						
							if (point[? "charIndex"] > point1[? "charIndex"]) {
								point[? "charIndex"] = point1[? "charIndex"];
							}
							else {
								point1[? "charIndex"] = point[? "charIndex"];
							};
						
							line[? "text"] = string_insert(t, line[? "text"], point[? "charIndex"] + 1);
							var width, height;
							var oldFont = draw_get_font();
							draw_set_font(line[? "font"]);
							width = max(string_width(line[? "text"]), 1);
							height = max(string_height(line[? "text"]), 1);
							draw_set_font(oldFont);
							surface_resize(line[? "surface"], width, height);
							line[? "size"].x = width;
							line[? "size"].y = height;
							point[? "charIndex"] += string_length(t);
							point1[? "charIndex"] += string_length(t);
						};
						keyboard_lastkey = vk_nokey;
						return;
					};
				
				
					if (
						(fm_container[? "point"][? "charIndex"] != fm_container[? "point1"][? "charIndex"])
						&&
						!(
							keyboard_lastkey == vk_up
							||
							keyboard_lastkey == vk_down
							||
							keyboard_lastkey == vk_right
							||
							keyboard_lastkey == vk_left
						)
					) { // is there selection?
						if (keyboard_lastkey == vk_shift) {
							return;
						};
					
						var line = fm_container[? "elements"][| point[? "lineIndex"]];
						var text = line[? "text"];
					
						var ps = min(point[? "charIndex"], point1[? "charIndex"]);
						var pe = max(point[? "charIndex"], point1[? "charIndex"]);
					
						var newText = "";
						var textl = string_length(text);
						for (var i = 0; i < textl; i++) {
							if (i < ps || i > pe - 1) {
								newText += string_char_at(text, i + 1);
							};
						};
						line[? "text"] = newText;
					
						var width, height;
						var oldFont = draw_get_font();
						draw_set_font(line[? "font"]);
						width = max(string_width(line[? "text"]), 1);
						height = max(string_height(line[? "text"]), 1);
						draw_set_font(oldFont);
						surface_resize(line[? "surface"], width, height);
						line[? "size"].x = width;
						line[? "size"].y = height;
					
						if (point[? "charIndex"] > point1[? "charIndex"]) {
							point[? "charIndex"] = point1[? "charIndex"];
						}
						else {
							point1[? "charIndex"] = point[? "charIndex"];
						};
						if (keyboard_lastkey == vk_backspace || keyboard_lastkey == vk_delete) {
							keyboard_lastkey = vk_nokey;
							return;
						};
					};
				
					switch (keyboard_lastkey) {
					case vk_up: {
						fm_container[? "point"][? "lineIndex"] = min(ds_list_size(fm_container[? "elements"]) - 1, max(0, fm_container[? "point"][? "lineIndex"] - 1));
						fm_container[? "point"][? "charIndex"] = min(string_length(fm_container[? "elements"][| fm_container[? "point"][? "lineIndex"]][? "text"]), max(0, fm_container[? "point"][? "charIndex"]));
					} break;
					case vk_down: {
						fm_container[? "point"][? "lineIndex"] = min(ds_list_size(fm_container[? "elements"]) - 1, max(0, fm_container[? "point"][? "lineIndex"] + 1));
						fm_container[? "point"][? "charIndex"] = min(string_length(fm_container[? "elements"][| fm_container[? "point"][? "lineIndex"]][? "text"]), max(0, fm_container[? "point"][? "charIndex"]));
					} break;
					case vk_right: {
						fm_container[? "point"][? "charIndex"]++;
						if (fm_container[? "point"][? "charIndex"] > string_length(fm_container[? "elements"][| fm_container[? "point"][? "lineIndex"]][? "text"])) {
							var oldLineIndex = fm_container[? "point"][? "lineIndex"];
							fm_container[? "point"][? "lineIndex"] = min(ds_list_size(fm_container[? "elements"]) - 1, max(0, fm_container[? "point"][? "lineIndex"] + 1));
							if (oldLineIndex != fm_container[? "point"][? "lineIndex"]) {
								fm_container[? "point"][? "charIndex"] = 0;
							};
						};
					} break;
					case vk_left: {
						fm_container[? "point"][? "charIndex"]--;
						if (fm_container[? "point"][? "charIndex"] < 0) {
							var oldLineIndex = fm_container[? "point"][? "lineIndex"];
							fm_container[? "point"][? "lineIndex"] = min(ds_list_size(fm_container[? "elements"]) - 1, max(0, fm_container[? "point"][? "lineIndex"] - 1));
							if (oldLineIndex != fm_container[? "point"][? "lineIndex"]) {
								fm_container[? "point"][? "charIndex"] = string_length(fm_container[? "elements"][| fm_container[? "point"][? "lineIndex"]][? "text"]);
							};
						};
					} break;
					case vk_backspace: { // backspace
						var line = fm_container[? "elements"][| point[? "lineIndex"]];
						var text = line[? "text"];
					
						var newText = "";
						var textl = string_length(text);
						for (var i = 0; i < textl; i++) {
							if (i != point[? "charIndex"] - 1) {
								newText += string_char_at(text, i + 1);
							};
						};
						line[? "text"] = newText;
						point[? "charIndex"]--;
					
						var width, height;
						var oldFont = draw_get_font();
						draw_set_font(line[? "font"]);
						width = max(string_width(line[? "text"]), 1);
						height = max(string_height(line[? "text"]), 1);
						draw_set_font(oldFont);
						surface_resize(line[? "surface"], width, height);
						line[? "size"].x = width;
						line[? "size"].y = height;
					} break;
					case vk_delete: {
						var line = fm_container[? "elements"][| point[? "lineIndex"]];
						var text = line[? "text"];
					
						var newText = "";
						var textl = string_length(text);
						for (var i = 0; i < textl; i++) {
							if (i != point[? "charIndex"]) {
								newText += string_char_at(text, i + 1);
							};
						};
						line[? "text"] = newText;
					
						var width, height;
						var oldFont = draw_get_font();
						draw_set_font(line[? "font"]);
						width = max(string_width(line[? "text"]), 1);
						height = max(string_height(line[? "text"]), 1);
						draw_set_font(oldFont);
						surface_resize(line[? "surface"], width, height);
						line[? "size"].x = width;
						line[? "size"].y = height;
					} break;
					case vk_enter: { // enter
					} break;
					case vk_shift: { // enter
						//keyboard_lastkey = vk_nokey;
						//return;
					} break;
					case vk_tab: { // enter
						var line = fm_container[? "elements"][| point[? "lineIndex"]];
						var text = line[? "text"];
						text = string_insert("  ", text, point[? "charIndex"] + 1);
						var width, height;
						var oldFont = draw_get_font();
						draw_set_font(line[? "font"]);
						width = max(string_width(text), 1);
						height = max(string_height(text), 1);
						draw_set_font(oldFont);
					
						if (width > fm_container[? "size"].x) {
							break;
						};
					
						line[? "text"] = text;
						point[? "charIndex"]++;
						point[? "charIndex"]++;
						surface_resize(line[? "surface"], width, height);
						line[? "size"].x = width;
						line[? "size"].y = height;
					} break;
					default: { // char keys
						var line = fm_container[? "elements"][| point[? "lineIndex"]];
						var text = line[? "text"];
						text = string_insert(keyboard_lastchar, text, point[? "charIndex"] + 1);
						var width, height;
						var oldFont = draw_get_font();
						draw_set_font(line[? "font"]);
						width = max(string_width(text), 1);
						height = max(string_height(text), 1);
						draw_set_font(oldFont);
					
						if (width > fm_container[? "size"].x) {
							break;
						};
					
						line[? "text"] = text;
						point[? "charIndex"]++;
						surface_resize(line[? "surface"], width, height);
						line[? "size"].x = width;
						line[? "size"].y = height;
					} break
					};
					point[? "charIndex"] = min(string_length(fm_container[? "elements"][| 0][? "text"]), max(0, point[? "charIndex"]));
					point1[? "charIndex"] = point[? "charIndex"];
				};
			};
			keyboard_lastkey = vk_nokey;
		};
	
		fm_container[? "point"][? "charIndex"] = max(0, fm_container[? "point"][? "charIndex"]);
	};
	STYLER_TEXTBOXDPCONTAINER_UPDATE_AFTER = function(fm_container) {
	};
	STYLER_TEXTBOXDPCONTAINER_DRAW_BEFORE = function(fm_container) {
		var state = fm_container[? "state"];
		var color = noone;
	
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(28, 28, 28, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(28, 28, 28, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(28, 28, 28, 255);
		} break;
		};
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(0, 0, fm_container[? "size"].x, fm_container[? "size"].y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		if (state == CLICKABLE_STATE.HOT) {
			var eSize = ds_list_size(fm_container[? "elements"]);
			if (eSize > 0) { // give it a point color
				var point = fm_container[? "point"];
			
				draw_set_color(make_color_rgb(point[? "color"].x, point[? "color"].y, point[? "color"].z));
				draw_set_alpha(lerp(point[? "fade"], point[? "color"].w / 255, sin(fm_container[? "point"][? "timer"] / 6)));
				var oldFont = draw_get_font();
				draw_set_font(fm_container[? "elements"][| 0][? "font"]);
				var targetStr = fm_container[? "elements"][| point[? "lineIndex"]][? "text"];
				var stringToPoint = string_copy(targetStr, 0, point[? "charIndex"]);
				var tx = string_width(stringToPoint);
				var ty = fm_container[? "lineGap"].y + (point[? "lineIndex"] * fm_container[? "elements"][| 0][? "size"].y) + (point[? "lineIndex"] * fm_container[? "lineGap"].y);
				draw_text(tx - fm_container[? "lineGap"].x, ty, "|");
				draw_set_font(oldFont);
				draw_set_alpha(1);
				draw_set_color(c_white);
			};
		}
		else if (state != CLICKABLE_STATE.DISABLED) {
			if (fm_container[? "elements"][| 0][? "text"] == "") {
				draw_set_color(make_color_rgb(fm_container[? "ghostTextColor"].x, fm_container[? "ghostTextColor"].y, fm_container[? "ghostTextColor"].z));
				draw_set_alpha(fm_container[? "ghostTextColor"].w / 255);
				var oldFont = draw_get_font();
				draw_set_font(fm_container[? "elements"][| 0][? "font"]);
				draw_text(fm_container[? "lineGap"].x, fm_container[? "lineGap"].y, fm_container[? "ghostText"]);
				draw_set_font(oldFont);
				draw_set_alpha(1);
				draw_set_color(c_white);
			};
		};
	
		var point = fm_container[? "point"];
		var point1 = fm_container[? "point1"];
		if (point[? "charIndex"] != point1[? "charIndex"] && state == CLICKABLE_STATE.HOT) {
			var oldFont = draw_get_font();
			draw_set_font(fm_container[? "elements"][| 0][? "font"]);
			var ps = min(point[? "charIndex"], point1[? "charIndex"]);
			var pe = max(point[? "charIndex"], point1[? "charIndex"]);
			var start = string_width( string_copy( fm_container[? "elements"][| 0][? "text"], 0, ps ) );
			var width = string_width( string_copy( fm_container[? "elements"][| 0][? "text"], ps, pe - ps ) );
			var heigth = fm_container[? "elements"][| 0][? "size"].y;
			draw_set_font(oldFont);
		
			var color = new Vector4(128, 128, 255, 128);
			draw_set_color(make_color_rgb(color.x, color.y, color.z));
			draw_set_alpha(color.w / 255);
			draw_rectangle(fm_container[? "lineGap"].x + start, fm_container[? "lineGap"].y, fm_container[? "lineGap"].x + start + width, fm_container[? "lineGap"].x + heigth, false);
			draw_set_alpha(1);
			draw_set_color(c_white);
			delete color;
		};
	
		delete color;
	};
	STYLER_TEXTBOXDPCONTAINER_DRAW_AFTER = function(fm_container) {
	};
	
	// Selectable
	STYLER_SELECTABLE_UPDATE_BEFORE = function(fm_selectable) {
		if (ButtonGetState(fm_selectable) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_selectable)) {
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_selectable, CLICKABLE_STATE.HOT);
				if (ButtonGetOnClick(fm_selectable) != noone) {
					ButtonGetOnClick(fm_selectable)(fm_selectable);
				};
				if (ElementPropertyExists(fm_selectable, "group") && RadioboxGetGroup(fm_selectable) != noone) {
					SelectableGroupSetSelected(RadioboxGetGroup(fm_selectable), fm_selectable);
				};
				var timer = ElementGetProperty(fm_selectable, "doubleClickTimer");
				var lastClickPos = ElementGetProperty(fm_selectable, "lastClickPos");
				if (lastClickPos.x != device_mouse_x_to_gui(0) || lastClickPos.y != device_mouse_y_to_gui(0)) {
					ElementSetProperty(fm_selectable, 30, "doubleClickTimer");
					lastClickPos = new Vector2(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
				}
				else {
					if (timer > 0) {
						var action = ElementGetProperty(fm_selectable, "doubleClickAction");
						if (action != noone) {
							action(fm_selectable);
							timer = -1;
						};
					};
					lastClickPos = new Vector2(-1, -1);
				};
				ElementSetProperty(fm_selectable, lastClickPos, "lastClickPos");
			}
			else if (ButtonGetState(fm_selectable) != CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_selectable, CLICKABLE_STATE.HOVER);
			};
			if (mouse_check_button_released(mb_left) && ButtonGetState(fm_selectable) == CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_selectable, CLICKABLE_STATE.HOVER);
			};
		}
		else {
			ButtonSetState(fm_selectable, CLICKABLE_STATE.IDLE);
		};
		
		var timer = ElementGetProperty(fm_selectable, "doubleClickTimer");
		if (timer == 0) {
			timer = -1;
		}
		else {
			timer = clamp(timer - 1, 0, timer);
		};
		ElementSetProperty(fm_selectable, timer, "doubleClickTimer");
	};
	STYLER_SELECTABLE_UPDATE_AFTER = function(fm_selectable) {
	};
	STYLER_SELECTABLE_DRAW_BEFORE = function(fm_selectable) {
		var state = ButtonGetState(fm_selectable);
		var color = noone;
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(31, 31, 31, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(51, 51, 51, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(22, 22, 22, 255);
		} break;
		};
		
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(0, 0, CanvasGetSize(fm_selectable).x, CanvasGetSize(fm_selectable).y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
		
		delete color;
	};
	STYLER_SELECTABLE_DRAW_AFTER = function(fm_selectable) {
		var color = noone;
		
		if (ButtonGetState(fm_selectable) == CLICKABLE_STATE.DISABLED) {
			color = new Vector4(128, 128, 128, 128);
		}
		else {
			color = new Vector4(255, 255, 255, 128);
		};
		
		var gap = 0;
		
		if (CheckboxGetCheck(fm_selectable)) {
			draw_set_color(make_color_rgb(color.x, color.y, color.z));
			draw_set_alpha(color.w / 255);
			draw_rectangle(gap, gap, CanvasGetSize(fm_selectable).x - gap - 1, CanvasGetSize(fm_selectable).y - gap - 1, false);
			draw_set_alpha(1);
			draw_set_color(c_white);
		};
		
		var oldHAlign = draw_get_halign();
		var oldVAlign = draw_get_valign();
		var oldFont = draw_get_font();
	
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_set_font(SelectableGetFont(fm_selectable));
		draw_set_color(c_white);
		draw_set_alpha(1);
	
		draw_text(3, CanvasGetSize(fm_selectable).y / 2, SelectableGetName(fm_selectable));
	
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_set_halign(oldHAlign);
		draw_set_valign(oldHAlign);
		draw_set_font(oldFont);
		
		delete color;
	};
	
	// Menu
	// Canvas
	STYLER_MENUCANVAS_UPDATE_BEFORE = function(fm_canvas) {
		if (IsHoverCanvasOptimized(fm_canvas)) {
			if (mouse_check_button_pressed(mb_left)) {
				if (ButtonGetOnClick(fm_canvas) != noone && ElementPropertyExists(fm_canvas, "OnClick")) {
					ButtonGetOnClick(fm_canvas)(fm_canvas);
				};
				var menu = ElementGetProperty(fm_canvas, "m_menu");
				menu[0][? "avoidclick"] = 1;
			};
		};
	};
	STYLER_MENUCANVAS_UPDATE_AFTER = function(fm_canvas) {
	};
	STYLER_MENUCANVAS_DRAW_BEFORE = function(fm_canvas) {
		var color = CanvasGetBackgroundColor(fm_canvas);
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(0, 0, CanvasGetSize(fm_canvas).x, CanvasGetSize(fm_canvas).y, false);
		draw_set_font(draw_get_font());
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	STYLER_MENUCANVAS_DRAW_AFTER = function(fm_canvas) {
	};
	// Panel
	STYLER_MENUPANEL_UPDATE_BEFORE = function(fm_panel) {
		if (IsHoverCanvasOptimized(fm_panel)) {
			if (mouse_check_button_pressed(mb_left)) {
				if (ButtonGetOnClick(fm_panel) != noone) {
					ButtonGetOnClick(fm_panel)(fm_panel);
				};
				var menu = ElementGetProperty(fm_panel, "m_menu");
				menu[0][? "avoidclick"] = 1;
			};
		};
		
		if (!IsHoverCanvasOptimized(fm_panel)) {
			return;
		};
		
		// Scroll
		if (ElementPropertyExists(fm_panel, "m_scrollbarVertical")) {
			var m_scrollbarVertical = ElementGetProperty(fm_panel, "m_scrollbarVertical");
			var m_steps = 1000;
			if (ElementPropertyExists(fm_panel, "m_scrollbarVerticalSteps")) {
				m_steps = ElementGetProperty(fm_panel, "m_scrollbarVerticalSteps");
			};
			if (!keyboard_check(vk_alt)) {
				if (mouse_wheel_down()) {
					ScrollbarScrollDown(m_scrollbarVertical, m_steps);
				};
				if (mouse_wheel_up()) {
					ScrollbarScrollUp(m_scrollbarVertical, m_steps);
				};
			};
		};
		if (ElementPropertyExists(fm_panel, "m_scrollbarHorizontal")) {
			var m_scrollbarHorizontal = ElementGetProperty(fm_panel, "m_scrollbarHorizontal");
			var m_steps = 1000;
			if (ElementPropertyExists(fm_panel, "m_scrollbarHorizontalSteps")) {
				m_steps = ElementGetProperty(fm_panel, "m_scrollbarHorizontalSteps");
			};
			if (keyboard_check(vk_alt)) {
				if (mouse_wheel_down()) {
					ScrollbarScrollRight(m_scrollbarHorizontal, m_steps);
				};
				if (mouse_wheel_up()) {
					ScrollbarScrollLeft(m_scrollbarHorizontal, m_steps);
				};
			};
		};
	};
	STYLER_MENUPANEL_UPDATE_AFTER = function(fm_panel) {
	};
	STYLER_MENUPANEL_DRAW_BEFORE = function(fm_panel) {
		var color = CanvasGetBackgroundColor(fm_panel);
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(0, 0, CanvasGetSize(fm_panel).x, CanvasGetSize(fm_panel).y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	STYLER_MENUPANEL_DRAW_AFTER = function(fm_panel) {
	};
	// Item
	STYLER_MENUITEM_UPDATE_BEFORE = function(fm_item) {
		if (ButtonGetState(fm_item) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_item)) {
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_item, CLICKABLE_STATE.HOT);
				if (ButtonGetOnClick(fm_item) != noone) {
					ButtonGetOnClick(fm_item)(fm_item);
				};
				var page = ElementGetProperty(fm_item, "m_page");
				var menu = ElementGetProperty(page, "m_menu");
				MenuHide(menu);
			}
			else if (ButtonGetState(fm_item) != CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_item, CLICKABLE_STATE.HOVER);
			};
			if (mouse_check_button_released(mb_left) && ButtonGetState(fm_item) == CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_item, CLICKABLE_STATE.HOVER);
			};
		}
		else {
			ButtonSetState(fm_item, CLICKABLE_STATE.IDLE);
		};
	};
	STYLER_MENUITEM_UPDATE_AFTER = function(fm_item) {
	};
	STYLER_MENUITEM_DRAW_BEFORE = function(fm_item) {
		var state = ButtonGetState(fm_item);
		var color = new Vector4(16, 16, 16, 255);
		
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		
		draw_rectangle(0, 0, CanvasGetSize(fm_item).x, CanvasGetSize(fm_item).y, false);
		
		draw_set_alpha(1);
		draw_set_color(c_white);
		
		// highlight
		if (state == CLICKABLE_STATE.HOVER) {
			draw_set_color(make_color_rgb(255, 255, 255));
			draw_set_alpha(0.3333);
			draw_rectangle(0, 0, CanvasGetSize(fm_item).x - 0 - 1, CanvasGetSize(fm_item).y - 0 - 1, false);
			draw_set_alpha(1);
			draw_set_color(c_white);
		};
		
		delete color;
	};
	STYLER_MENUITEM_DRAW_AFTER = function(fm_item) {
		if (ElementGetProperty(fm_item, "m_icon16x16") != noone) {
			draw_sprite(ElementGetProperty(fm_item, "m_icon16x16"), 0, 3, 3);
		};
		
		var oldHAlign = draw_get_halign();
		var oldVAlign = draw_get_valign();
		var oldFont = draw_get_font();
	
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_set_font(ButtonGetFont(fm_item));
		draw_set_color(c_white);
		draw_set_alpha(1);
	
		draw_text(24, CanvasGetSize(fm_item).y / 2, ButtonGetText(fm_item));
	
		draw_text(24 + 180 + 3, CanvasGetSize(fm_item).y / 2, ElementGetProperty(fm_item, "m_infoText"));
	
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_set_halign(oldHAlign);
		draw_set_valign(oldHAlign);
		draw_set_font(oldFont);
	};
	// Separator
	STYLER_MENUSEPARATOR_UPDATE_BEFORE = function(fm_item) {
		if (ButtonGetState(fm_item) == CLICKABLE_STATE.DISABLED) {
			return;
		};
	};
	STYLER_MENUSEPARATOR_UPDATE_AFTER = function(fm_item) {
	};
	STYLER_MENUSEPARATOR_DRAW_BEFORE = function(fm_item) {
		var state = ButtonGetState(fm_item);
		var color = new Vector4(16, 16, 16, 255);
		
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		
		//draw_rectangle(0, 0, CanvasGetSize(fm_item).x, CanvasGetSize(fm_item).y, false);
		
		draw_set_alpha(1);
		draw_set_color(c_white);
		
		delete color;
	};
	STYLER_MENUSEPARATOR_DRAW_AFTER = function(fm_item) {
		var oldHAlign = draw_get_halign();
		var oldVAlign = draw_get_valign();
		var oldFont = draw_get_font();
	
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_set_font(ButtonGetFont(fm_item));
		draw_set_color(c_gray);
		draw_set_alpha(1);
		
		if (ButtonGetText(fm_item) != "") {
			draw_line(0, CanvasGetSize(fm_item).y / 2, 24 - 3, CanvasGetSize(fm_item).y / 2);
			draw_text(24, CanvasGetSize(fm_item).y / 2, ButtonGetText(fm_item));
			draw_line(string_width(ButtonGetText(fm_item)) + 24 + 3, CanvasGetSize(fm_item).y / 2, CanvasGetSize(fm_item).x, CanvasGetSize(fm_item).y / 2);
		}
		else {
			draw_line(0, CanvasGetSize(fm_item).y / 2, CanvasGetSize(fm_item).x, CanvasGetSize(fm_item).y / 2);
		};
		
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_set_halign(oldHAlign);
		draw_set_valign(oldHAlign);
		draw_set_font(oldFont);
	};
	// Tab
	STYLER_MENUTAB_UPDATE_BEFORE = function(fm_item) {
		if (ButtonGetState(fm_item) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_item)) {
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_item, CLICKABLE_STATE.HOT);
				MenuPageSetSelected(ElementGetProperty(fm_item, "m_page"), fm_item);
				if (ButtonGetOnClick(fm_item) != noone) {
					ButtonGetOnClick(fm_item)(fm_item);
				};
			}
			else if (ButtonGetState(fm_item) != CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_item, CLICKABLE_STATE.HOVER);
			};
			if (mouse_check_button_released(mb_left) && ButtonGetState(fm_item) == CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_item, CLICKABLE_STATE.HOVER);
			};
		}
		else {
			ButtonSetState(fm_item, CLICKABLE_STATE.IDLE);
		};
	};
	STYLER_MENUTAB_UPDATE_AFTER = function(fm_item) {
	};
	STYLER_MENUTAB_DRAW_BEFORE = function(fm_item) {
		var state = ButtonGetState(fm_item);
		var color = new Vector4(16, 16, 16, 255);
		
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		
		draw_rectangle(0, 0, CanvasGetSize(fm_item).x, CanvasGetSize(fm_item).y, false);
		
		draw_set_alpha(1);
		draw_set_color(c_white);
		
		if (CheckboxGetCheck(fm_item)) {
			draw_set_color(make_color_rgb(255, 255, 255));
			draw_set_alpha(0.55);
			draw_rectangle(0, 0, CanvasGetSize(fm_item).x - 0 - 1, CanvasGetSize(fm_item).y - 0 - 1, false);
			draw_set_alpha(1);
			draw_set_color(c_white);
		}
		else if (state == CLICKABLE_STATE.HOVER) {
			draw_set_color(make_color_rgb(255, 255, 255));
			draw_set_alpha(0.3333);
			draw_rectangle(0, 0, CanvasGetSize(fm_item).x - 0 - 1, CanvasGetSize(fm_item).y - 0 - 1, false);
			draw_set_alpha(1);
			draw_set_color(c_white);
		};
		
		delete color;
	};
	STYLER_MENUTAB_DRAW_AFTER = function(fm_item) {
		if (ElementGetProperty(fm_item, "m_icon16x16") != noone) {
			draw_sprite(ElementGetProperty(fm_item, "m_icon16x16"), 0, 3, 3);
		};
		
		var oldHAlign = draw_get_halign();
		var oldVAlign = draw_get_valign();
		var oldFont = draw_get_font();
	
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_set_font(ButtonGetFont(fm_item));
		draw_set_color(c_white);
		draw_set_alpha(1);
	
		draw_text(24, CanvasGetSize(fm_item).y / 2, ButtonGetText(fm_item));
	
		draw_text(24 + 180 + 3, CanvasGetSize(fm_item).y / 2, ElementGetProperty(fm_item, "m_infoText"));
	
		//draw_text(CanvasGetSize(fm_item).x - 20, CanvasGetSize(fm_item).y / 2, ">");
	
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_set_halign(oldHAlign);
		draw_set_valign(oldHAlign);
		draw_set_font(oldFont);
		
		draw_triangle(
			CanvasGetSize(fm_item).x - 25 + 6, CanvasGetSize(fm_item).y / 2 - 6, 
			CanvasGetSize(fm_item).x - 25 + 6, CanvasGetSize(fm_item).y / 2 + 6, 
			CanvasGetSize(fm_item).x - 25 + 12, CanvasGetSize(fm_item).y / 2, 
			false
		);
	};
	// Checkbox
	STYLER_MENUCHECKBOX_UPDATE_BEFORE = function(fm_item) {
		if (ButtonGetState(fm_item) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_item)) {
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_item, CLICKABLE_STATE.HOT);
				if (ButtonGetOnClick(fm_item) != noone) {
					ButtonGetOnClick(fm_item)(fm_item);
				};
				CheckboxSetCheck(fm_item, !CheckboxGetCheck(fm_item));
				var page = ElementGetProperty(fm_item, "m_page");
				var menu = ElementGetProperty(page, "m_menu");
				MenuHide(menu);
			}
			else if (ButtonGetState(fm_item) != CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_item, CLICKABLE_STATE.HOVER);
			};
			if (mouse_check_button_released(mb_left) && ButtonGetState(fm_item) == CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_item, CLICKABLE_STATE.HOVER);
			};
		}
		else {
			ButtonSetState(fm_item, CLICKABLE_STATE.IDLE);
		};
	};
	STYLER_MENUCHECKBOX_UPDATE_AFTER = function(fm_item) {
	};
	/*
	STYLER_CHECKBOX_DRAW_BEFORE = function(fm_checkbox) {
		var state = ButtonGetState(fm_checkbox);
		var color = noone;
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(31, 31, 31, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(51, 51, 51, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(22, 22, 22, 255);
		} break;
		};
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(0, 0, CanvasGetSize(fm_checkbox).x, CanvasGetSize(fm_checkbox).y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	STYLER_CHECKBOX_DRAW_AFTER = function(fm_checkbox) {
		if (!CheckboxGetCheck(fm_checkbox)) {
			return;
		};
	
		var color = noone;
	
		if (ButtonGetState(fm_checkbox) == CLICKABLE_STATE.DISABLED) {
			color = new Vector4(128, 128, 128, 255);
		}
		else {
			color = new Vector4(255, 255, 255, 255);
		};
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		//draw_rectangle(gap, gap, CanvasGetSize(fm_checkbox).x - gap - 1, CanvasGetSize(fm_checkbox).y - gap - 1, false);
		var offset = new Vector2(1, 0);
		var size = CanvasGetSize(fm_checkbox);
		var divider = 4;
		var p1 = new Vector2(size.x / 2 - size.x / divider, size.y - size.y / divider);
		var p2 = new Vector2(0, size.y / 2);
		var p3 = new Vector2(size.x - size.x / divider, size.y / divider);
		
		var thickness = 2;
		draw_line_width(p1.x + offset.x, p1.y + offset.y, p2.x + offset.x, p2.y + offset.y, thickness);
		draw_line_width(p1.x + offset.x, p1.y + offset.y, p3.x + offset.x, p3.y + offset.y, thickness);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	*/
	STYLER_MENUCHECKBOX_DRAW_BEFORE = function(fm_item) {
		var state = ButtonGetState(fm_item);
		var color = new Vector4(16, 16, 16, 255);
		
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		
		draw_rectangle(0, 0, CanvasGetSize(fm_item).x, CanvasGetSize(fm_item).y, false);
		
		draw_set_alpha(1);
		draw_set_color(c_white);
		
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(31, 31, 31, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(51, 51, 51, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(22, 22, 22, 255);
		} break;
		};
		
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(3, 3, 3 + 16, 3 + 16, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
		
		// highlight
		if (state == CLICKABLE_STATE.HOVER) {
			draw_set_color(make_color_rgb(255, 255, 255));
			draw_set_alpha(0.3333);
			draw_rectangle(0, 0, CanvasGetSize(fm_item).x - 0 - 1, CanvasGetSize(fm_item).y - 0 - 1, false);
			draw_set_alpha(1);
			draw_set_color(c_white);
		};
		
		delete color;
	};
	STYLER_MENUCHECKBOX_DRAW_AFTER = function(fm_item) {
		if (CheckboxGetCheck(fm_item)) {
			var color = noone;
	
			if (ButtonGetState(fm_item) == CLICKABLE_STATE.DISABLED) {
				color = new Vector4(128, 128, 128, 255);
			}
			else {
				color = new Vector4(255, 255, 255, 255);
			};
	
			draw_set_color(make_color_rgb(color.x, color.y, color.z));
			draw_set_alpha(color.w / 255);
			var offset = new Vector2(5, 4);
			var size = new Vector2(16, 16);
			var divider = 4;
			var p1 = new Vector2(size.x / 2 - size.x / divider, size.y - size.y / divider);
			var p2 = new Vector2(0, size.y / 2);
			var p3 = new Vector2(size.x - size.x / divider, size.y / divider);
		
			var thickness = 2;
			draw_line_width(p1.x + offset.x, p1.y + offset.y, p2.x + offset.x, p2.y + offset.y, thickness);
			draw_line_width(p1.x + offset.x, p1.y + offset.y, p3.x + offset.x, p3.y + offset.y, thickness);
			draw_set_alpha(1);
			draw_set_color(c_white);
	
			delete color;
		};
		
		var oldHAlign = draw_get_halign();
		var oldVAlign = draw_get_valign();
		var oldFont = draw_get_font();
		
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_set_font(ButtonGetFont(fm_item));
		draw_set_color(c_white);
		draw_set_alpha(1);
		
		draw_text(24, CanvasGetSize(fm_item).y / 2, ButtonGetText(fm_item));
		
		draw_text(24 + 180 + 3, CanvasGetSize(fm_item).y / 2, ElementGetProperty(fm_item, "m_infoText"));
		
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_set_halign(oldHAlign);
		draw_set_valign(oldHAlign);
		draw_set_font(oldFont);
	};
	
	// Textbox
	STYLER_TEXTBOX_UPDATE_BFEORE = function(fm_textbox) {
		if (ButtonGetState(fm_textbox) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		
		ElementSetProperty(fm_textbox, ElementGetProperty(fm_textbox, "timer") + 1, "timer");
		
		if (IsHoverCanvasOptimized(fm_textbox)) {
			if (ButtonGetState(fm_textbox) == CLICKABLE_STATE.IDLE) {
				ButtonSetState(fm_textbox, CLICKABLE_STATE.HOVER);
			};
			////window_set_cursor(cr_beam);
			
			// Scroll
			var scrollbarWidth = TextboxGetScrollbarWidth(fm_textbox);
			var scrollbarGap = TextboxGetScrollbarGap(fm_textbox);
			var scrollbarGapSide = TextboxGetScrollbarGapSide(fm_textbox);
			if (ElementPropertyExists(fm_textbox, "m_scrollbarVertical")) {
				var m_scrollbarVertical = ElementGetProperty(fm_textbox, "m_scrollbarVertical");
				var loc = GetElementStartPos(fm_textbox);
				CanvasGetPosition(m_scrollbarVertical).x = loc.x + CanvasGetSize(fm_textbox).x - (scrollbarWidth + scrollbarGap);
				CanvasGetPosition(m_scrollbarVertical).y = loc.y + scrollbarGapSide;
				CanvasGetPosition(m_scrollbarVertical).z = CanvasGetPosition(fm_textbox).z + 1;
				CanvasGetPosition(ScrollbarGetAnchor(m_scrollbarVertical)).z = CanvasGetPosition(m_scrollbarVertical).z + 1;
				var m_steps = 1000 * 2;
				if (ElementPropertyExists(fm_textbox, "m_scrollbarVerticalSteps")) {
					m_steps = ElementGetProperty(fm_textbox, "m_scrollbarVerticalSteps");
				};
				if (!keyboard_check(vk_alt)) {
					if (mouse_wheel_down()) {
						ScrollbarScrollDown(m_scrollbarVertical, m_steps);
					};
					if (mouse_wheel_up()) {
						ScrollbarScrollUp(m_scrollbarVertical, m_steps);
					};
				};
			};
			if (ElementPropertyExists(fm_textbox, "m_scrollbarHorizontal")) {
				var m_scrollbarHorizontal = ElementGetProperty(fm_textbox, "m_scrollbarHorizontal");
				var loc = GetElementStartPos(fm_textbox);
				CanvasGetPosition(m_scrollbarHorizontal).x = loc.x + scrollbarGapSide;
				CanvasGetPosition(m_scrollbarHorizontal).y = loc.y + CanvasGetSize(fm_textbox).y - (scrollbarWidth + scrollbarGap);
				CanvasGetPosition(m_scrollbarHorizontal).z = CanvasGetPosition(fm_textbox).z + 1;
				CanvasGetPosition(ScrollbarGetAnchor(m_scrollbarHorizontal)).z = CanvasGetPosition(m_scrollbarHorizontal).z + 1;
				var m_steps = 1000 * 2;
				if (ElementPropertyExists(fm_textbox, "m_scrollbarHorizontalSteps")) {
					m_steps = ElementGetProperty(fm_textbox, "m_scrollbarHorizontalSteps");
				};
				if (keyboard_check(vk_alt)) {
					if (mouse_wheel_down()) {
						ScrollbarScrollRight(m_scrollbarHorizontal, m_steps);
					};
					if (mouse_wheel_up()) {
						ScrollbarScrollLeft(m_scrollbarHorizontal, m_steps);
					};
				};
			};
			
			if (mouse_check_button_pressed(mb_left) && m_canvasHover == fm_textbox) {
				ButtonSetState(fm_textbox, CLICKABLE_STATE.HOT);
				keyboard_lastkey = vk_nokey;
				ElementSetProperty(fm_textbox, true, "dragging");
			};
			if (mouse_check_button(mb_left)) {
				keyboard_lastkey = vk_nokey;
			};
		}
		else {
			if (mouse_check_button_pressed(mb_left) && !(ElementPropertyExists(m_canvasLastClicked, "ori") || ElementPropertyExists(m_canvasLastClicked, "__anchor") || ElementPropertyExists(m_canvasLastClicked, "__background"))) {
				if (!(ElementPropertyExists(m_canvasHover, "ori") || ElementPropertyExists(m_canvasHover, "__anchor") || ElementPropertyExists(m_canvasHover, "__background"))) {
					ButtonSetState(fm_textbox, CLICKABLE_STATE.IDLE);
				};
			};
		};
		if (mouse_check_button_released(mb_left)) {
			ElementSetProperty(fm_textbox, false, "dragging");
		};
		
		if (ButtonGetState(fm_textbox) == CLICKABLE_STATE.HOT) {
			// Mouse Events
			if (IsHoverCanvasOptimized(fm_textbox) && ElementGetProperty(fm_textbox, "dragging")) {
				var dummy = CanvasGetElement(fm_textbox, 0);
				var tpx = ElementGetProperty(dummy, "extraAddX"), tpy = ElementGetProperty(dummy, "extraAddY");
				
				if (mouse_check_button_pressed(mb_left)) {
					var mx = device_mouse_x_to_gui(0) - GetElementStartPos(fm_textbox).x + ElementGetProperty(fm_textbox, "extraAddX") + (-tpx);
					var my = device_mouse_y_to_gui(0) - GetElementStartPos(fm_textbox).y + ElementGetProperty(fm_textbox, "extraAddY") + (-tpy);
					var lines = string_split(fm_textbox[? "text"], "\n");
					var lineHeight = font_get_size(ButtonGetFont(fm_textbox)) + ElementGetProperty(fm_textbox, "lineGap");
					var oldFont = draw_get_font();
					draw_set_font(ButtonGetFont(fm_textbox));
					var charWidth = string_width("W");
					draw_set_font(oldFont);
					var midy = floor( (my - ((my - ElementGetProperty(fm_textbox, "borderGap").y) % lineHeight)) / lineHeight );
					midy = min(midy, max(array_length(lines) - 1, 0)); // might make it -1
					midy = max(0, midy);
					var midx = floor((mx - ((mx - ElementGetProperty(fm_textbox, "borderGap").x) % charWidth)) / charWidth);
					midx = max(0, min(midx, string_length(lines[midy])));
				
					fm_textbox[? "point"] = FindNthOccurrenceOfString(fm_textbox[? "text"], "\n", midy) + midx;
					if (!keyboard_check(vk_shift)) {
						fm_textbox[? "point1"] = fm_textbox[? "point"];
					};
				};
				if (mouse_check_button(mb_left)) {
					var mx = device_mouse_x_to_gui(0) - GetElementStartPos(fm_textbox).x + ElementGetProperty(fm_textbox, "extraAddX") + (-tpx);
					var my = device_mouse_y_to_gui(0) - GetElementStartPos(fm_textbox).y + ElementGetProperty(fm_textbox, "extraAddY") + (-tpy);
					var lines = string_split(fm_textbox[? "text"], "\n");
					var lineHeight = font_get_size(ButtonGetFont(fm_textbox)) + ElementGetProperty(fm_textbox, "lineGap");
					var oldFont = draw_get_font();
					draw_set_font(ButtonGetFont(fm_textbox));
					var charWidth = string_width("W");
					draw_set_font(oldFont);
					var midy = floor( (my - ((my - ElementGetProperty(fm_textbox, "borderGap").y) % lineHeight)) / lineHeight );
					midy = min(midy, max(array_length(lines) - 1, 0)); // might make it -1
					midy = max(0, midy);
					var midx = floor((mx - ((mx - ElementGetProperty(fm_textbox, "borderGap").x) % charWidth)) / charWidth);
					midx = max(0, min(midx, string_length(lines[midy])));
				
					fm_textbox[? "point"] = FindNthOccurrenceOfString(fm_textbox[? "text"], "\n", midy) + midx;
				};
			};
			
			#region Double & Triple Click
				static doubleTimer = 0
				if ( doubleTimer > 0 ) { 
					doubleTimer--;
					if ( mouse_pressed ) { 
						doubleTimer = 0;
						mouse_clear(mb_left)
						var text = ElementGetProperty(fm_textbox, "text");
						fm_textbox[? "point1"] = 0;
						fm_textbox[? "point"] = string_length(text);
					} //Double Clicked!
				} else { doubleTimer = 0; }
			
				if ( mouse_pressed ) { doubleTimer = 15; }
			#endregion
			
			// Keyboard Events
			if ( ( keyboard_lastkey != vk_nokey && keyboard_lastkey != 20 ) ) {
				var text = ElementGetProperty(fm_textbox, "text");
				
				// char limit check-point
				var charLimit = ElementGetProperty(fm_textbox, "charLimit");
				if (charLimit != -1 && string_length(text) > charLimit) {
					return;
				};
				
				fm_textbox[? "point"] = min(string_length(text), max(0, fm_textbox[? "point"]));
				fm_textbox[? "point1"] = min(string_length(text), max(0, fm_textbox[? "point1"]));
				
				var ps = min(fm_textbox[? "point"], fm_textbox[? "point1"]);
				var pe = max(fm_textbox[? "point"], fm_textbox[? "point1"]);
				
				var isKeyShift = keyboard_check(vk_shift);
				
				// Control Keys
				if (keyboard_check(vk_control)) {
					// Jump Left-Right
					if (keyboard_check_pressed(vk_left)) {
						var oldv = fm_textbox[? "point"];
						fm_textbox[? "point"] = max(string_last_pos_ext(" ", text, ps - 1), string_last_pos_ext("\n", text, ps - 1));
						if (fm_textbox[? "point"] == oldv) {
							fm_textbox[? "point"] = string_last_pos_ext(" ", text, ps - 1);
						};
						if (!keyboard_check(vk_shift)) {
							fm_textbox[? "point1"] = fm_textbox[? "point"];
						};
					};
					if (keyboard_check_pressed(vk_right)) {
						if (fm_textbox[? "point"] == string_length(text)) {
							keyboard_lastkey = vk_nokey;
							return;
						};
						var oldv = fm_textbox[? "point"];
						fm_textbox[? "point"] = min(string_pos_ext(" ", text, ps + 1), string_pos_ext("\n", text, ps + 1) - 1);
						if (fm_textbox[? "point"] <= 0) {
							fm_textbox[? "point"] = string_length(text);
						};
						if (fm_textbox[? "point"] == oldv) {
							fm_textbox[? "point"] = string_pos_ext(" ", text, ps + 1);
						};
						if (!keyboard_check(vk_shift)) {
							fm_textbox[? "point1"] = fm_textbox[? "point"];
						};
					};
					
					if (keyboard_check_pressed(ord("A"))) {
						fm_textbox[? "point1"] = 0;
						fm_textbox[? "point"] = string_length(text);
					};
					if (keyboard_check_pressed(ord("C"))) {
						if (ps != pe) {
							clipboard_set_text(string_copy(text, ps + 1, pe - ps));
						};
					};
					if (keyboard_check_pressed(ord("X"))) {
						if (ps != pe) {
							clipboard_set_text(string_copy(text, ps + 1, pe - ps));
							text = string_delete(text, ps + 1, pe - ps);
							fm_textbox[? "point"] = ps;
							fm_textbox[? "point1"] = ps;
						};
					};
					if (keyboard_check_pressed(ord("V"))) {
						if (!clipboard_has_text()) {
							keyboard_lastkey = vk_nokey;
							return;
						};
						var cct = clipboard_get_text();
						// char limit check-point
						if (charLimit != -1 && string_length(text) + string_length(cct) > charLimit) {
							return;
						};
						if (fm_textbox[? "point"] != fm_textbox[? "point1"]) {
							text = string_delete(text, ps + 1, pe - ps);
							fm_textbox[? "point"] = ps;
							fm_textbox[? "point1"] = ps;
						};
						text = string_insert(cct, text, ps + 1);
						fm_textbox[? "point"] = ps + string_length(cct);
						fm_textbox[? "point1"] = ps + string_length(cct);
					};
					
					ElementSetProperty(fm_textbox, text, "text");
					keyboard_lastkey = vk_nokey;
					return;
				};
				
				// Move Left-Right
				if (keyboard_check(vk_left)) {
					fm_textbox[? "point"] = max(0, fm_textbox[? "point"] - 1);
					if (!isKeyShift) {
						fm_textbox[? "point1"] = fm_textbox[? "point"];
					};
					
					keyboard_lastkey = vk_nokey;
					return;
				};
				
				if (keyboard_check(vk_right)) {
					fm_textbox[? "point"] = min(string_length(text), fm_textbox[? "point"] + 1);
					if (!isKeyShift) {
						fm_textbox[? "point1"] = fm_textbox[? "point"];
					};
					
					keyboard_lastkey = vk_nokey;
					return;
				};
				
				// Move Up-Down
				if (keyboard_check(vk_up)) {
					var beforeNewLine = string_last_pos("\n", string_copy(text, 0, fm_textbox[? "point"]));
					if (beforeNewLine == 0) {
						keyboard_lastkey = vk_nokey;
						return;
					};
					var beforeBeforeNewLine = string_last_pos("\n", string_copy(text, 0, beforeNewLine - 1));
					fm_textbox[? "point"] = beforeBeforeNewLine + min(fm_textbox[? "point"] - beforeNewLine, beforeNewLine - beforeBeforeNewLine - 1);
					if (!isKeyShift) {
						fm_textbox[? "point1"] = fm_textbox[? "point"];
					};
					
					keyboard_lastkey = vk_nokey;
					return;
				};
				
				if (keyboard_check(vk_down)) {
					var beforeNewLine = string_last_pos("\n", string_copy(text, 0, fm_textbox[? "point"]));
					var afterNewLine = string_pos("\n", string_copy(text, fm_textbox[? "point"] + 1, string_length(text) - fm_textbox[? "point"]));
					if (afterNewLine == 0) {
						keyboard_lastkey = vk_nokey;
						return;
					};
					var afterAfterNewLine = max(0, string_pos_ext("\n", text, fm_textbox[? "point"] + afterNewLine + 1) - fm_textbox[? "point"]);
					if (afterAfterNewLine == 0) { afterAfterNewLine = string_length(text) - fm_textbox[? "point"]; };
					fm_textbox[? "point"] = min(fm_textbox[? "point"] + afterNewLine + max(0, (fm_textbox[? "point"] - beforeNewLine)), fm_textbox[? "point"] + afterAfterNewLine);
					if (!isKeyShift) {
						fm_textbox[? "point1"] = fm_textbox[? "point"];
					};
					
					keyboard_lastkey = vk_nokey;
					return;
				};
				
				switch (keyboard_lastkey) {
				case vk_tab: { // fix this crap
					fm_textbox[? "point"]++; // temp solution
					fm_textbox[? "point"]++;
					
					//fm_textbox[? "point"]++;
					//var ___toAdd = string_repeat(" ", 2 - ((fm_textbox[? "point"] - string_last_pos("\n", string_copy(text, 0, fm_textbox[? "point"]))) % 2));
					//text = string_insert(___toAdd, text, fm_textbox[? "point"]);
					//fm_textbox[? "point"] += string_length(___toAdd) - 1;
					//fm_textbox[? "point1"] = fm_textbox[? "point"];
				} break;
				case vk_backspace: {
					if ( text != "" ) {
						if (fm_textbox[? "point"] == fm_textbox[? "point1"]) {
							text = string_delete(text, fm_textbox[? "point"], 1);
							fm_textbox[? "point"]--;
							fm_textbox[? "point1"] = fm_textbox[? "point"];
						}
						else {
							text = string_delete(text, ps + 1, pe - ps);
							fm_textbox[? "point"] = ps;
							fm_textbox[? "point1"] = ps;
						};
					}
				} break;
				case vk_delete: {
					if ( text != "" ) {
						if (fm_textbox[? "point"] == fm_textbox[? "point1"]) {
							text = string_delete(text, fm_textbox[? "point"] + 1, 1);
							fm_textbox[? "point1"] = fm_textbox[? "point"];
						}
						else {
							text = string_delete(text, ps + 1, pe - ps);
							fm_textbox[? "point"] = ps;
							fm_textbox[? "point1"] = ps;
						};
					}
				} break;
				case vk_enter: {
					if (!ElementGetProperty(fm_textbox, "isMultiline")) { break; };
					if ( string_count("\n", text) >= ElementGetProperty(fm_textbox, "lineLimit") ) { break; }
					if (fm_textbox[? "point"] != fm_textbox[? "point1"]) {
						text = string_delete(text, ps + 1, pe - ps);
						fm_textbox[? "point"] = ps;
						fm_textbox[? "point1"] = ps;
					};
					text = string_insert("\n", text, fm_textbox[? "point"] + 1);
					fm_textbox[? "point"]++;
					fm_textbox[? "point1"] = fm_textbox[? "point"];
				} break;
				case vk_control: {
				} break;
				case vk_alt: {
				} break;
				case vk_lalt: {
				} break;
				case vk_ralt: {
				} break;
				case vk_shift: {
				} break;
				default: {
					// limit the key gap
					if (!(ord(keyboard_lastchar) > 31 && ord(keyboard_lastchar) < 127)) { break; };
					
					if (ps == pe) {
						fm_textbox[? "point"]++;
						text = string_insert(keyboard_lastchar, text, fm_textbox[? "point"]);
						fm_textbox[? "point1"] = fm_textbox[? "point"];
					}
					else {
						text = string_delete(text, ps + 1, pe - ps);
						fm_textbox[? "point"] = ps;
						fm_textbox[? "point1"] = ps;
						
						fm_textbox[? "point"]++;
						text = string_insert(keyboard_lastchar, text, fm_textbox[? "point"]);
						fm_textbox[? "point1"] = fm_textbox[? "point"];
					};
				} break;
				};
				
				ElementSetProperty(fm_textbox, text, "text");
				keyboard_lastkey = vk_nokey;
				keyboard_lastchar = vk_nokey;
			};
		};
	};
	STYLER_TEXTBOX_UPDATE_AFTER = function(fm_textbox) {
		var text = TextboxGetText(fm_textbox);
		var textWidth = 0;
		var textHeight = 0;
		var borderGap = TextboxGetBorderGap(fm_textbox);
		var fontSize = 0;
		
		{
			var oldFont = draw_get_font();
			draw_set_font(TextboxGetFont(fm_textbox));
			textWidth = string_width(text);
			textHeight = string_height(text);
			fontSize = font_get_size(draw_get_font());
			draw_set_font(oldFont);
		}
		
		var lineGap = ElementGetProperty(fm_textbox, "lineGap"); // gamemaker's default is 7!
		var lineHeight = fontSize + lineGap;
		
		fm_textbox[? "highestPointOnX"] = textWidth + borderGap.x * 2;
		fm_textbox[? "highestPointOnY"] = textHeight + borderGap.y * 2 + (string_length(text) > 0 ? (string_char_at(text, string_length(text)) == "\n" ? lineHeight : 0) : 0);
	};
	STYLER_TEXTBOX_DRAW_BFEORE = function(fm_textbox) {
		var focus = ButtonGetState(fm_textbox) == CLICKABLE_STATE.HOT;
		var color = focus ? new Vector4(39, 31, 54, 255) : new Vector4(80, 63, 110, 255);
		
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		
		draw_rectangle(0, 0, CanvasGetSize(fm_textbox).x, CanvasGetSize(fm_textbox).y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
		
		delete color;
	};
	STYLER_TEXTBOX_DRAW_AFTER = function(fm_textbox) {
		draw_set_font(ButtonGetFont(fm_textbox));
		
		var text = ButtonGetText(fm_textbox);
		var ghostText = ElementGetProperty(fm_textbox, "ghostText");
		var cChar = fm_textbox[? "point"];
		var cChar1 = fm_textbox[? "point1"];
		
		var lineGap = ElementGetProperty(fm_textbox, "lineGap"); // gamemaker's default is 7!
		var borderGapX = ElementGetProperty(fm_textbox, "borderGap").x;
		var borderGapY = ElementGetProperty(fm_textbox, "borderGap").y;
		var fontSize = font_get_size(draw_get_font());
		var lineHeight = fontSize + lineGap;
		
		var dummy = CanvasGetElement(fm_textbox, 0);
		var tpx = ElementGetProperty(dummy, "extraAddX"), tpy = ElementGetProperty(dummy, "extraAddY");
		
		var oldHAlign = draw_get_halign();
		var oldVAlign = draw_get_valign();
		var oldFont = draw_get_font();
		var oldBlendmode = gpu_get_blendmode();
		
		gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
		
		if (ButtonGetState(fm_textbox) == CLICKABLE_STATE.HOT && TextboxGetMultiline(fm_textbox)) {
			var ps = min(cChar, cChar1);
			var pe = max(cChar, cChar1);
			
			var lines = string_split(text, "\n");
			
			var index = max(array_length(string_split(string_copy(text, 0, fm_textbox[? "point"]), "\n")) - 1, 0);
			
			var lineIndex = index;
			
			var height = fontSize + 7 - 1;
			var yStart = borderGapY + (lineHeight * lineIndex);
			
			draw_set_color(c_white);
			draw_set_alpha(0.22);
			
			draw_rectangle(0, tpy + yStart, CanvasGetSize(fm_textbox).x, tpy + yStart + height, false);
			draw_set_alpha(1);
		};
		
		if (string_length(text) == 0 && (ButtonGetState(fm_textbox) != CLICKABLE_STATE.HOT || ButtonGetState(fm_textbox) == CLICKABLE_STATE.DISABLED)) {
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
			draw_set_font(ButtonGetFont(fm_textbox));
			var c = TextboxGetGhostTextColor(fm_textbox);
			draw_set_color(make_color_rgb(c.x, c.y, c.z));
			draw_set_alpha(c.w / 255);
			
			draw_text(tpx + borderGapX, tpy + borderGapY, ghostText);
			draw_set_alpha(1);
		}
		else {
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
			var c = TextboxGetTextColor(fm_textbox);
			draw_set_color(make_color_rgb(c.x, c.y, c.z));
			draw_set_alpha(c.w / 255);
			
			//draw_text(tpx, tpy, text);
			
			var lines = string_split(text, "\n");
			
			var innerLinesStart =  floor(min(array_length(lines), max(0, (max(0, abs(tpy) - borderGapY * 2)) / lineHeight)));
			var innerLinesSize = floor(min(array_length(lines), max(0, (CanvasGetSize(fm_textbox).y - borderGapY * 2) / lineHeight + 1)));
			
			for (var i = innerLinesStart; i < innerLinesStart + innerLinesSize; i++) {
				var strToDraw = ElementGetProperty(fm_textbox, "isPassword") ? string_repeat(ElementGetProperty(fm_textbox, "passwordChar"), string_length(lines[i])) : lines[i];
				draw_text(tpx + borderGapX, tpy + borderGapY + i * (fontSize + lineGap), strToDraw);
			};
			draw_set_alpha(1);
		};
		
		if (cChar != cChar1) {
			var ps = min(cChar, cChar1);
			var pe = max(cChar, cChar1);
			
			var lines = string_split(text, "\n");
			
			var indexOfStart = max(array_length(string_split(string_copy(text, 0, ps), "\n")) - 1, 0);
			var indexOfEnd = max(array_length(string_split(string_copy(text, 0, pe), "\n")) - 1, 0);
			
			var posOfStartOnLine = ps - string_last_pos_ext("\n", text, ps);
			var posOfEndOnLine = pe - string_last_pos_ext("\n", text, pe);
			
			if (indexOfStart == indexOfEnd) {
				var lineIndex = indexOfStart;
				
				var xStart = borderGapX + string_width(string_copy(lines[lineIndex], 0, posOfStartOnLine));
				var xEnd = borderGapX + string_width(string_copy(lines[lineIndex], 0, posOfEndOnLine));
				
				var height = fontSize + 7 - 1;
				var yStart = borderGapY + (lineHeight * lineIndex);
				
				draw_set_color(make_color_rgb(128, 128, 255));
				draw_set_alpha(0.5);
				
				draw_rectangle(tpx + xStart, tpy + yStart, tpx + xEnd, tpy + yStart + height, false);
				draw_set_alpha(1);
			}
			else {
				{
					var lineIndex = indexOfStart;
					
					var xStart = borderGapX + string_width(string_copy(lines[lineIndex], 0, posOfStartOnLine));
					var xEnd = borderGapX + xStart + string_width(string_copy(lines[lineIndex], posOfStartOnLine, string_length(lines[lineIndex]) - posOfStartOnLine));
					
					var height = fontSize + 7 - 1;
					var yStart = borderGapY + (lineHeight * lineIndex);
					
					draw_set_color(make_color_rgb(128, 128, 255));
					draw_set_alpha(0.5);
					
					draw_rectangle(tpx + xStart, tpy + yStart, tpx + xEnd, tpy + yStart + height, false);
					draw_set_alpha(1);
				}
				for (var i = indexOfStart + 1; i <= indexOfEnd - 1; i++) {
					var lineIndex = i;
					
					var xStart = borderGapX;
					var xEnd = borderGapX + string_width(lines[lineIndex]);
					
					var height = fontSize + 7 - 1;
					var yStart = borderGapY + (lineHeight * lineIndex);
					
					draw_set_color(make_color_rgb(128, 128, 255));
					draw_set_alpha(0.5);
					
					draw_rectangle(tpx + xStart, tpy + yStart, tpx + xEnd, tpy + yStart + height, false);
					draw_set_alpha(1);
				};
				{
					var lineIndex = indexOfEnd;
					
					var xStart = borderGapX;
					var xEnd = borderGapX + string_width(string_copy(lines[lineIndex], 0, posOfEndOnLine));
					
					var height = fontSize + 7 - 1;
					var yStart = borderGapY + (lineHeight * lineIndex);
					
					draw_set_color(make_color_rgb(128, 128, 255));
					draw_set_alpha(0.5);
					
					draw_rectangle(tpx + xStart, tpy + yStart, tpx + xEnd, tpy + yStart + height, false);
					draw_set_alpha(1);
				}
			};
		};
		
		if (ButtonGetState(fm_textbox) == CLICKABLE_STATE.HOT) {
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
			draw_set_font(ButtonGetFont(fm_textbox));
			draw_set_color(make_color_rgb(255, 255, 255));
			draw_set_alpha(lerp(128 / 255, 255 / 255, sin(ElementGetProperty(fm_textbox, "timer") / 6)));
			
			var linesToCurrent = string_split(string_copy(text, 0, cChar), "\n");
			var currentLineIndex = max(array_length(linesToCurrent) - 1, 0);
			var _x = borderGapX + string_width(linesToCurrent[currentLineIndex]) - fontSize / 4;
			var _y = borderGapY + ((lineHeight) * currentLineIndex);
			draw_text(tpx + _x, tpy + _y, "|");
			
			//var linesToCurrent1 = string_split(string_copy(text, 0, cChar1), "\n");
			//var currentLineIndex1 = max(array_length(linesToCurrent1) - 1, 0);
			//var _x1 = borderGapX + string_width(linesToCurrent1[currentLineIndex1]) - fontSize / 4;
			//var _y1 = borderGapY + (lineHeight * currentLineIndex1);
			//draw_text(_x1, _y1, "|");
			
			//var textCut = string_copy(text, 0, cChar);
			//var lastLineStart = string_last_pos("\n", textCut);
			//var lastLine = string_copy(textCut, lastLineStart + 1, cChar - lastLineStart + 1);
			//
			//var _x = string_width(lastLine) - fontSize / 4;
			//var _y = string_height(textCut + "|") - string_height("|");
			//draw_text(_x, _y, "|");
			//
			//var textCut1 = string_copy(text, 0, cChar1);
			//var lastLineStart1 = string_last_pos("\n", textCut1);
			//var lastLine1 = string_copy(textCut1, lastLineStart1 + 1, cChar1 - lastLineStart1 + 1);
			//
			//var _x1 = string_width(lastLine1) - fontSize / 4;
			//var _y1 = string_height(textCut1 + "|") - string_height("|");
			//draw_text(_x1, _y1, "|");
			
			draw_set_alpha(1);
			draw_set_color(c_white);
		};
		
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_set_halign(oldHAlign);
		draw_set_valign(oldHAlign);
		draw_set_font(oldFont);
		gpu_set_blendmode(oldBlendmode);
	};
	
	// Combobox
	STYLER_COMBOBOX_UPDATE_BEFORE = function(fm_combobox) {
		if (ButtonGetState(fm_combobox) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_combobox)) {
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_combobox, CLICKABLE_STATE.HOT);
				CheckboxSetCheck(fm_combobox, !CheckboxGetCheck(fm_combobox));
				
				if (CheckboxGetCheck(fm_combobox)) {
					var menu = ElementGetProperty(fm_combobox, "menu");
					
					CanvasActivate(menu);
					CanvasGetPosition(menu).x = GetElementStartPos(fm_combobox).x;
					CanvasGetPosition(menu).y = GetElementStartPos(fm_combobox).y + CanvasGetSize(fm_combobox).y;
					
					if (CanvasGetSize(menu).x != CanvasGetSize(fm_combobox).x) {
						var width = CanvasGetSize(fm_combobox).x;
						CanvasSetSize(menu, new Vector2(width, CanvasGetSize(menu).y));
						for (var i = 0; i < ds_list_size(CanvasGetElements(menu)); i++) {
							var element = CanvasGetElement(menu, i);
							CanvasSetSize(element, new Vector2(width, CanvasGetSize(element).y));
						};
					};
				}
				else {
					CanvasDeactivate(ElementGetProperty(fm_combobox, "menu"));
				};
			}
			else if (ButtonGetState(fm_combobox) != CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_combobox, CLICKABLE_STATE.HOVER);
			};
			if (mouse_check_button_released(mb_left) && ButtonGetState(fm_combobox) == CLICKABLE_STATE.HOT) {
				//if (ButtonGetOnClick(fm_combobox) != noone) {
				//	ButtonGetOnClick(fm_combobox)(fm_combobox);
				//};
				ButtonSetState(fm_combobox, CLICKABLE_STATE.HOVER);
			};
		}
		else {
			ButtonSetState(fm_combobox, CLICKABLE_STATE.IDLE);
		};
	};
	STYLER_COMBOBOX_UPDATE_AFTER = function(fm_combobox) {
		if (!IsHoverCanvasOptimized(fm_combobox)) {
			if (mouse_check_button_released(mb_left)) {
				CheckboxSetCheck(fm_combobox, false);
				CanvasDeactivate(ElementGetProperty(fm_combobox, "menu"));
			};
		};
	};
	STYLER_COMBOBOX_DRAW_BEFORE = function(fm_combobox) {
		var state = fm_combobox[? "state"];
		var color = noone;
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(31, 31, 31, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(51, 51, 51, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(22, 22, 22, 255);
		} break;
		};
		
		if (ElementGetProperty(fm_combobox, "check")) {
			color = new Vector4(22, 22, 22, 255);
		};
		
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(0, 0, CanvasGetSize(fm_combobox).x, CanvasGetSize(fm_combobox).y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	STYLER_COMBOBOX_DRAW_AFTER = function(fm_combobox) {
		var color = noone;
	
		if (fm_combobox[? "state"] == CLICKABLE_STATE.DISABLED) {
			color = new Vector4(128, 128, 128, 255);
		}
		else {
			color = new Vector4(255, 255, 255, 255);
		};
	
		var oldHAlign = draw_get_halign();
		var oldVAlign = draw_get_valign();
		var oldFont = draw_get_font();
	
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_set_font(ButtonGetFont(fm_combobox));
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		
		var text = ButtonGetText(fm_combobox);
		if (ElementGetProperty(fm_combobox, "selected") != noone) { text = SelectableGetName(ElementGetProperty(fm_combobox, "selected")); };
		draw_text(3, CanvasGetSize(fm_combobox).y / 2, text);
		
		//if (CheckboxGetCheck(fm_combobox)) {
			draw_triangle(
				CanvasGetSize(fm_combobox).x - 20 + 2, 
				CanvasGetSize(fm_combobox).y / 2 - 2, 
				
				CanvasGetSize(fm_combobox).x - 20 + 8, 
				CanvasGetSize(fm_combobox).y / 2 - 2, 
				
				CanvasGetSize(fm_combobox).x - 20 + 5, 
				CanvasGetSize(fm_combobox).y / 2 + 2, 
				
				false
			);
		//}
		/*else {
			draw_triangle(
				CanvasGetSize(fm_combobox).x - 20 + 4, 
				CanvasGetSize(fm_combobox).y / 2 - 4, 
				
				CanvasGetSize(fm_combobox).x - 20 + 4, 
				CanvasGetSize(fm_combobox).y / 2 + 4, 
				
				CanvasGetSize(fm_combobox).x - 20 + 8, 
				CanvasGetSize(fm_combobox).y / 2, 
				
				false
			);
		};*/
	
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_set_halign(oldHAlign);
		draw_set_valign(oldHAlign);
		draw_set_font(oldFont);
	
		delete color;
	};
	
	// Comboswitch
	STYLER_COMBOSWTICH_MIDCANVAS_DRAW_BEFORE = function(fm_canvas) {
		var color = new Vector4(31, 31, 31, 255);
		
		var panel = CanvasGetParent(fm_canvas);
		var switchList = ElementGetProperty(panel, "switchList");
		var current = ElementGetProperty(panel, "__current");
	
		var oldHAlign = draw_get_halign();
		var oldVAlign = draw_get_valign();
		var oldFont = draw_get_font();
	
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_font(ButtonGetFont(CanvasGetParent(fm_canvas)));
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		
		draw_rectangle(0, 0, CanvasGetSize(fm_canvas).x, CanvasGetSize(fm_canvas).y, false);
	
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_set_halign(oldHAlign);
		draw_set_valign(oldHAlign);
		draw_set_font(oldFont);
	
		oldHAlign = draw_get_halign();
		oldVAlign = draw_get_valign();
		oldFont = draw_get_font();
	
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_font(ButtonGetFont(CanvasGetParent(fm_canvas)));
		draw_set_color(c_white);
		draw_set_alpha(1);
		
		draw_text(CanvasGetSize(fm_canvas).x / 2, CanvasGetSize(fm_canvas).y / 2 - 4, switchList[| current]);
	
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_set_halign(oldHAlign);
		draw_set_valign(oldHAlign);
		draw_set_font(oldFont);
		
		var linePosY = CanvasGetSize(fm_canvas).y / 2 + 10;
		var length = CanvasGetSize(fm_canvas).x;
		//var gapLength = length / (ds_list_size(switchList) * ds_list_size(switchList)); // looks bad when u have less than 8 selections
		var gapLength = length / 20; // looks bad when you have more than 10 selections
		var lineLength = length / ds_list_size(switchList) - gapLength;
		for (var i = 0; i < ds_list_size(switchList); i++) {
			if (i != current) { draw_set_color(c_gray); };
			draw_line(i * lineLength + gapLength * i, linePosY, i * lineLength + gapLength * i + lineLength, linePosY);
			draw_set_color(c_white);
		};
		
		delete color;
	};
	
	// Slider
	STYLER_SLIDER_UPDATE_BEFORE = function(fm_slider) {
		if (ButtonGetState(fm_slider) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_slider)) {
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_slider, CLICKABLE_STATE.HOT);
				ElementSetProperty(fm_slider, true, "mouseTracking");
			}
			else if (ButtonGetState(fm_slider) != CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_slider, CLICKABLE_STATE.HOVER);
			};
			if (mouse_check_button_released(mb_left) && ButtonGetState(fm_slider) == CLICKABLE_STATE.HOT) {
				if (ButtonGetOnClick(fm_slider) != noone) {
					ButtonGetOnClick(fm_slider)(fm_slider);
				};
				ButtonSetState(fm_slider, CLICKABLE_STATE.HOVER);
			};
		}
		else {
			ButtonSetState(fm_slider, CLICKABLE_STATE.IDLE);
		};
	
		if (mouse_check_button_released(mb_left) && ElementGetProperty(fm_slider, "mouseTracking")) {
			ElementSetProperty(fm_slider, false, "mouseTracking");
		};
	
		if (ElementGetProperty(fm_slider, "mouseTracking")) {
			var sp = GetElementStartPos(fm_slider); // gets the element's position according to its alignment without adding its parents into the account
			var sx = sp.x;
			delete sp;
			var mx = device_mouse_x_to_gui(0) - sx;
			SlidebarSetPercentage(fm_slider, min(1, max(0, mx / CanvasGetSize(fm_slider).x)));
		};
	};
	STYLER_SLIDER_UPDATE_AFTER = function(fm_slider) {
	};
	STYLER_SLIDER_DRAW_BEFORE = function(fm_slider) {
		var state = ButtonGetState(fm_slider);
		var color = noone;
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		default: {
			color = new Vector4(200, 200, 200, 255);
		} break;
		};
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_line(ElementGetProperty(fm_slider, "__width") / 2, CanvasGetSize(fm_slider).y / 2, CanvasGetSize(fm_slider).x - ElementGetProperty(fm_slider, "__width") / 2, CanvasGetSize(fm_slider).y / 2);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	STYLER_SLIDER_DRAW_AFTER = function(fm_slider) {
		var state = ButtonGetState(fm_slider);
		var color = noone;
	
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(31, 31, 31, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(51, 51, 51, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(22, 22, 22, 255);
		} break;
		};
	
		var p = SlidebarGetPercentage(fm_slider);
		
		var currentLength = Mix(ElementGetProperty(fm_slider, "__width") / 2, CanvasGetSize(fm_slider).x - ElementGetProperty(fm_slider, "__width") / 2, p);
		
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w);
		draw_rectangle(currentLength - ElementGetProperty(fm_slider, "__width") / 2, 0, currentLength + ElementGetProperty(fm_slider, "__width") / 2, CanvasGetSize(fm_slider).y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	
	// Sprite
	STYLER_SPRITE_UPDATE_BEFORE = function(fm_sprite) {
		if (ButtonGetState(fm_sprite) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_sprite)) {
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_sprite, CLICKABLE_STATE.HOT);
			}
			else if (ButtonGetState(fm_sprite) != CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_sprite, CLICKABLE_STATE.HOVER);
			};
			if (mouse_check_button_released(mb_left) && ButtonGetState(fm_sprite) == CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_sprite, CLICKABLE_STATE.HOVER);
				if (ButtonGetOnClick(fm_sprite) != noone) {
					ButtonGetOnClick(fm_sprite)(fm_sprite);
				};
			};
		}
		else {
			ButtonSetState(fm_sprite, CLICKABLE_STATE.IDLE);
		};
	};
	STYLER_SPRITE_UPDATE_AFTER = function(fm_sprite) {
		ElementSetProperty(fm_sprite, ElementGetProperty(fm_sprite, "mIndex") + ElementGetProperty(fm_sprite, "mSpeed"), "mIndex");
		if (ElementGetProperty(fm_sprite, "mIndex") > sprite_get_number(ElementGetProperty(fm_sprite, "mSprite"))) {
			ElementSetProperty(fm_sprite, 0, "mIndex");
		};
	};
	STYLER_SPRITE_DRAW_BEFORE = function(fm_sprite) {
		//draw_sprite(ElementGetProperty(fm_sprite, "mSprite"), ElementGetProperty(fm_sprite, "mIndex"), 0, 0);
		var spr = ElementGetProperty(fm_sprite, "mSprite"), xs = ElementGetProperty(fm_sprite, "mXscale"), ys = ElementGetProperty(fm_sprite, "mYscale")
		draw_sprite_ext(spr, ElementGetProperty(fm_sprite, "mIndex"), sprite_get_xoffset(spr) * xs, sprite_get_yoffset(spr) * ys, xs, ys, 0, ElementGetProperty(fm_sprite, "mColor"), ElementGetProperty(fm_sprite, "mAlpha"));
	};
	STYLER_SPRITE_DRAW_AFTER = function(fm_sprite) {
	};
	
	// Tree View Checkbox
	STYLER_TREEVIEWCHECKBOX_UPDATE_BEFORE = function(fm_checkbox) {
		if (ButtonGetState(fm_checkbox) == CLICKABLE_STATE.DISABLED) {
			return;
		};
		var fm_mainCanvas = global.MAJORGUI_MAIN_CANVAS;
		if (IsHoverCanvasOptimized(fm_checkbox)) {
			if (mouse_check_button_pressed(mb_left)) {
				ButtonSetState(fm_checkbox, CLICKABLE_STATE.HOT);
				CheckboxSetCheck(fm_checkbox, !CheckboxGetCheck(fm_checkbox));
				ElementSetProperty(fm_checkbox, true, "checkcheck");
			}
			else if (ButtonGetState(fm_checkbox) != CLICKABLE_STATE.HOT) {
				ButtonSetState(fm_checkbox, CLICKABLE_STATE.HOVER);
			};
			if (mouse_check_button_released(mb_left) && ButtonGetState(fm_checkbox) == CLICKABLE_STATE.HOT) {
				if (ButtonGetOnClick(fm_checkbox) != noone) {
					ButtonGetOnClick(fm_checkbox)(fm_checkbox);
				};
				ButtonSetState(fm_checkbox, CLICKABLE_STATE.HOVER);
			};
		}
		else {
			ButtonSetState(fm_checkbox, CLICKABLE_STATE.IDLE);
		};
		
		if (ElementGetProperty(fm_checkbox, "checkcheck")) {
			
			var responsibleElements = ElementGetProperty(fm_checkbox, "__responsibleElements");
			var check = CheckboxGetCheck(fm_checkbox) && CanvasGetActive(fm_checkbox);
			
			for (var i = 0; i < ds_list_size(responsibleElements); i++) {
				var element = responsibleElements[| i];
				
				//if (!CanvasGetActive(fm_checkbox)) {
				//	CanvasDeactivate(element);
				//	if (ElementPropertyExists(element, "checkcheck")) {
				//		ElementSetProperty(element, true, "checkcheck");
				//	};
				//	continue;
				//};
				
				CanvasSetActive(element, check);
				
				if (ElementPropertyExists(element, "checkcheck")) { // its also a parent node
					ElementSetProperty(element, true, "checkcheck");
				};
			};
			
			ElementSetProperty(fm_checkbox, false, "checkcheck");
			
			PanelRefresh(CanvasGetParent(fm_checkbox));
			
			if (CanvasGetParent(fm_checkbox) != noone) { // treeview is a panel and it might be inside a panel, if thats the case its panel should be refreshed to update its scrollbar variables
				if (ElementPropertyExists(CanvasGetParent(fm_checkbox), "titleStack")) {
					PanelRefresh(CanvasGetParent(fm_checkbox));
				};
			};
		};
	};
	STYLER_TREEVIEWCHECKBOX_UPDATE_AFTER = function(fm_checkbox) {
	};
	STYLER_TREEVIEWCHECKBOX_DRAW_BEFORE = function(fm_checkbox) {
		var state = ButtonGetState(fm_checkbox);
		var color = noone;
		switch (state) {
		case CLICKABLE_STATE.DISABLED: {
			color = new Vector4(12, 12, 12, 255);
		} break;
		case CLICKABLE_STATE.IDLE: {
			color = new Vector4(31, 31, 31, 255);
		} break;
		case CLICKABLE_STATE.HOVER: {
			color = new Vector4(51, 51, 51, 255);
		} break;
		case CLICKABLE_STATE.HOT: {
			color = new Vector4(22, 22, 22, 255);
		} break;
		};
	
		draw_set_color(make_color_rgb(color.x, color.y, color.z));
		draw_set_alpha(color.w / 255);
		draw_rectangle(0, 0, CanvasGetSize(fm_checkbox).x, CanvasGetSize(fm_checkbox).y, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		delete color;
	};
	STYLER_TREEVIEWCHECKBOX_DRAW_AFTER = function(fm_checkbox) {
		var color = noone;
	
		if (ButtonGetState(fm_checkbox) == CLICKABLE_STATE.DISABLED) {
			color = new Vector4(128, 128, 128, 255);
		}
		else {
			color = new Vector4(255, 255, 255, 255);
		};
		
		var size = CanvasGetSize(fm_checkbox);
		var arrowSize = 4;
		
		if (CheckboxGetCheck(fm_checkbox)) {
			draw_set_color(make_color_rgb(color.x, color.y, color.z));
			draw_set_alpha(color.w / 255);
			
			var p1 = new Vector2(size.x / 2 - arrowSize, size.y / 2 - arrowSize);
			var p2 = new Vector2(size.x / 2 + arrowSize, size.y / 2 - arrowSize);
			var p3 = new Vector2(size.x / 2, size.y / 2 + arrowSize);
			
			draw_triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, false);
			
			draw_set_alpha(1);
			draw_set_color(c_white);
		}
		else{
			draw_set_color(make_color_rgb(color.x, color.y, color.z));
			draw_set_alpha(color.w / 255);
			
			var p1 = new Vector2(size.x / 2 - arrowSize, size.y / 2 - arrowSize);
			var p2 = new Vector2(size.x / 2 - arrowSize, size.y / 2 + arrowSize);
			var p3 = new Vector2(size.x / 2 + arrowSize, size.y / 2);
			
			draw_triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, false);
			
			draw_set_alpha(1);
			draw_set_color(c_white);
		};
		
		delete color;
	};
	
	// =========================================================================
	// UI ELEMENTS
	// =========================================================================
	
	/// @function CanvasCreate(pos = new Vector3(0, 0, 0) : Vector3, size = new Vector2(1, 1) : Vector2, bCol = new Vector4(0, 0, 0, 255) : Vector4, parent = noone : ds_map) -> ds_map
	CanvasCreate = function(fm_pos = new Vector3(0, 0, 0), fm_size = new Vector2(1, 1), fm_bCol = new Vector4(0, 0, 0, 255), fm_parent = noone) {
		var canvas = ds_map_create();
		
		fm_size.x = clamp(fm_size.x, 1, 9999);
		fm_size.y = clamp(fm_size.y, 1, 9999);
		
		canvas[? "pos"] = fm_pos;
		canvas[? "size"] = fm_size;
		canvas[? "bCol"] = fm_bCol;
		
		canvas[? "surface"] = surface_create(fm_size.x, fm_size.y);
		canvas[? "elements"] = ds_list_create();
		
		canvas[? "BeforeUpdate"] = noone; // takes canvas itself
		canvas[? "AfterUpdate"] = noone; // takes canvas itself
		
		canvas[? "BeforeDraw"] = noone; // takes canvas itself
		canvas[? "AfterDraw"] = noone; // takes canvas itself
		
		canvas[? "parent"] = noone;
		
		canvas[? "active"] = true;
		canvas[? "alignment"] = new Align(ALIGN.LEFT, ALIGN.TOP);
		
		canvas[? "FreeEx"] = noone;
		canvas[? "refreshRequest"] = false;
		canvas[? "Refresh"] = noone;
		
		canvas[? "extraAddX"] = 0;
		canvas[? "extraAddY"] = 0;
		
		canvas[? "highestPointOnX"] = 0;
		canvas[? "highestPointOnY"] = 0;
		
		canvas[? "shader"] = noone;
		canvas[? "shaderParameterScript"] = noone;
		
		canvas[? "hoverActive"] = true;
		
		ElementSetProperty(canvas, false, "autoScaleHorizontal");
		ElementSetProperty(canvas, false, "autoScaleVertical");
		
		ElementSetProperty(canvas, ds_list_create(), "stateEvents");
		
		if (global.MAJORGUI_MAIN_CANVAS != noone) {
			if (fm_parent == noone) {
				ds_list_add(global.MAJORGUI_MAIN_CANVAS[? "elements"], canvas);
				canvas[? "parent"] = global.MAJORGUI_MAIN_CANVAS;
			}
			else {
				ds_list_add(fm_parent[? "elements"], canvas);
				canvas[? "parent"] = fm_parent;
				if (fm_pos != undefined) {
					if (fm_pos.x + fm_size.x > fm_parent[? "highestPointOnX"]) {
						fm_parent[? "highestPointOnX"] = fm_pos.x + fm_size.x;
					};
					if (fm_pos.y + fm_size.y > fm_parent[? "highestPointOnY"]) {
						fm_parent[? "highestPointOnY"] = fm_pos.y + fm_size.y;
					};
				};
			};
		}
		else {
			global.MAJORGUI_MAIN_CANVAS = canvas;
		};
		
		canvas[? "MajorGUI"] = self;
		
		return canvas;
	};
	
	/// @function CanvasUpdate(fm_canvas : ds_map) -> undefined
	CanvasUpdate = function(fm_canvas) {
		if (!fm_canvas[? "active"] && !ElementPropertyExists(fm_canvas, "checkcheck")) { // except panel title
			return;
		};
		
		//if (!ds_exists(fm_canvas[? "elements"], ds_type_list)) {
		//	return;
		//};
		
		var elements = SortCanvasListByZOrder_Copy(fm_canvas[? "elements"]);
		ds_list_destroy(fm_canvas[? "elements"]);
		fm_canvas[? "elements"] = elements;
		
		if (CanvasGetAutoScaleHorizontal(fm_canvas) || CanvasGetAutoScaleVertical(fm_canvas)) {
			var newSize = new Vector2(1, 1);
			newSize.x = CanvasGetAutoScaleHorizontal(fm_canvas) ? max(1, CanvasGetEdgeHorizontal(fm_canvas)) : CanvasGetSize(fm_canvas).x;
			newSize.y = CanvasGetAutoScaleVertical(fm_canvas) ? max(1, CanvasGetEdgeVertical(fm_canvas)) : CanvasGetSize(fm_canvas).y;
			if (
				CanvasGetSize(fm_canvas).x != newSize.x 
				|| 
				CanvasGetSize(fm_canvas).y != newSize.y
			) 
			{
				CanvasSetSize(fm_canvas, newSize);
			};
		};
		
		if (fm_canvas[? "BeforeUpdate"] != noone) {
			fm_canvas[? "BeforeUpdate"](fm_canvas);
		};
		
		for (var i = 0; i < ds_list_size(ElementGetProperty(fm_canvas, "stateEvents")); i++) {
			var stateEvent = ElementGetProperty(fm_canvas, "stateEvents")[i];
			if (ElementPropertyExists(fm_canvas, "state")) {
				if (ButtonGetState(fm_canvas) == stateEvent[0]) {
					stateEvent[1](fm_canvas);
				};
			};
		};
		
		for (var i = 0; i < ds_list_size(fm_canvas[? "elements"]); i++) {
			var element = fm_canvas[? "elements"][| i];
			
			CanvasUpdate(element);
			
			var sp = GetElementStartPosOffScreen(element);
			var spx = sp.x, spy = sp.y;
			delete sp;
			if (spx + element[? "size"].x > fm_canvas[? "highestPointOnX"]) {
				fm_canvas[? "highestPointOnX"] = spx + element[? "size"].x;
			};
			if (spy + element[? "size"].y > fm_canvas[? "highestPointOnY"]) {
				fm_canvas[? "highestPointOnY"] = spy + element[? "size"].y;
			};
			if (CanvasGetAutoScaleHorizontal(fm_canvas) || CanvasGetAutoScaleVertical(fm_canvas)) {
				var newSize = new Vector2(1, 1);
				newSize.x = CanvasGetAutoScaleHorizontal(fm_canvas) ? max(1, CanvasGetEdgeHorizontal(fm_canvas)) : CanvasGetSize(fm_canvas).x;
				newSize.y = CanvasGetAutoScaleVertical(fm_canvas) ? max(1, CanvasGetEdgeVertical(fm_canvas)) : CanvasGetSize(fm_canvas).y;
				if (
					CanvasGetSize(fm_canvas).x != newSize.x 
					|| 
					CanvasGetSize(fm_canvas).y != newSize.y
				) 
				{
					CanvasSetSize(fm_canvas, newSize);
				};
			};
		};
		
		if (fm_canvas[? "AfterUpdate"] != noone) {
			fm_canvas[? "AfterUpdate"](fm_canvas);
		};
		
		
		if (fm_canvas[? "refreshRequest"]) {
			if (fm_canvas[? "Refresh"] != noone) {
				fm_canvas[? "Refresh"](fm_canvas);
			};
			fm_canvas[? "refreshRequest"] = false;
		};
	};
	
	/// @function CanvasDraw(fm_canvas : ds_map) -> undefined
	CanvasDraw = function(fm_canvas) {
		if (!fm_canvas[? "active"]) {
			return;
		};
		
		if (!surface_exists(fm_canvas[? "surface"])) {
			fm_canvas[? "surface"] = surface_create(fm_canvas[? "size"].x, fm_canvas[? "size"].y);
		};
		
		surface_set_target(fm_canvas[? "surface"]);
		
		draw_clear_alpha(make_color_rgb(fm_canvas[? "bCol"].x, fm_canvas[? "bCol"].y, fm_canvas[? "bCol"].z), fm_canvas[? "bCol"].w / 255);
		
		if (fm_canvas[? "BeforeDraw"] != noone) {
			fm_canvas[? "BeforeDraw"](fm_canvas);
		};
		
		for (var i = 0; i < ds_list_size(fm_canvas[? "elements"]); i++) {
			var element = fm_canvas[? "elements"][| i];
			
			CanvasDraw(element);
		};
		
		if (fm_canvas[? "AfterDraw"] != noone) {
			fm_canvas[? "AfterDraw"](fm_canvas);
		};
		
		surface_reset_target();
		
		var pos = GetElementStartPosOffScreen(fm_canvas);
		var px = pos.x;
		var py = pos.y;
		delete pos;
		
		var oldblendmode = gpu_get_blendmode();
		gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
		
		if (fm_canvas[? "shader"] == noone) {
			draw_surface(fm_canvas[? "surface"], px, py);
		}
		else {
			shader_set(fm_canvas[? "shader"]);
			if (fm_canvas[? "shaderParameterScript"] != noone) {
				fm_canvas[? "shaderParameterScript"](fm_canvas);
			};
			draw_surface(fm_canvas[? "surface"], px, py);
			shader_reset();
		};
		
		gpu_set_blendmode(oldblendmode);
	};
	
	/// @function CanvasFree(fm_canvas : ds_map) -> undefined
	CanvasFree = function(fm_canvas) {
		surface_free(fm_canvas[? "surface"]);
		delete fm_canvas[? "pos"];
		delete fm_canvas[? "size"];
		delete fm_canvas[? "bCol"];
		delete fm_canvas[? "alignment"];
		if (ds_exists(fm_canvas[? "elements"], ds_type_list)) {
			for (var i = 0; i < ds_list_size(fm_canvas[? "elements"]); i++) {
				ElementFree(fm_canvas[? "elements"][| 0]);
				i--;
			};
		};
		ds_list_destroy(fm_canvas[? "elements"]);
		
		ds_list_destroy(ElementGetProperty(fm_canvas, "stateEvents"));
		
		if (fm_canvas[? "align"] != -1) {
			delete fm_canvas[? "align"];
		};
		
		if (fm_canvas[? "autoFitScale"] != -1) {
			delete fm_canvas[? "autoFitScale"];
		};
		
		if (ds_exists(fm_canvas[? "parent"], ds_type_map)) {
			ds_list_delete(fm_canvas[? "parent"][? "elements"], ds_list_find_index(fm_canvas[? "parent"][? "elements"], fm_canvas));
		};
		ds_map_destroy(fm_canvas);
	};
	
	/// @function ElementFree(fm_element : ds_map) -> undefined
	ElementFree = function(fm_element) {
		if (ds_map_exists(fm_element, "parent")) { // does it have a parent?
			var parent = fm_element[? "parent"];
			if (parent != noone) { // make sure parent points a canvas
				if (ds_map_exists(parent, "backup")) { // is it a panel?
					// send a refresh request
					parent[? "refreshRequest"] = true;
				};
			};
		};
		
		if (ds_map_exists(fm_element, "FreeEx")) {
			if (fm_element[? "FreeEx"] != noone) {
				fm_element[? "FreeEx"](fm_element);
			};
		};
		
		CanvasFree(fm_element);
	};
	
	/// @function ElementHoverEnable(fm_element : ds_map) -> undefined
	ElementHoverEnable = function(fm_element) {
		fm_element[? "hoverActive"] = true;
	};
	
	/// @function ElementHoverDisable(fm_element : ds_map) -> undefined
	ElementHoverDisable = function(fm_element) {
		fm_element[? "hoverActive"] = false;
	};
	
	/// @function ElementGetHover(fm_element : ds_map) -> boolean
	ElementGetHover = function(fm_element) {
		return fm_element[? "hoverActive"];
	};
	
	/// @function CanvasIsHover(fm_canvas : ds_map) -> boolean
	CanvasIsHover = function(fm_canvas) {
		if (m_canvasHover == fm_canvas) {
			return true;
		};
		return false;
	};
	
	/// @function CanvasFindElement(fm_canvas : ds_map, fm_element : ds_map) -> number
	CanvasFindElement = function(fm_canvas, fm_element) {
		return ds_list_find_index(fm_canvas[? "elements"], fm_element);
	};
	
	/// @function CanvasActivate(fm_canvas : ds_map) -> undefined
	CanvasActivate = function(fm_canvas) {
		fm_canvas[? "active"] = true;
	};
	
	/// @function CanvasDeactivate(fm_canvas : ds_map) -> undefined
	CanvasDeactivate = function(fm_canvas) {
		fm_canvas[? "active"] = false;
	};
	
	/// @function CanvasAddStateEvent(fm_canvas : ds_map, fm_state : number, fm_func : function) -> array
	CanvasAddStateEvent = function(fm_canvas, fm_state, fm_func) {
		ds_list_add(ElementGetProperty(fm_canvas, "stateEvents"), [ fm_state, fm_func ]);
		return ElementGetProperty(fm_canvas, "stateEvents")[ds_list_size(ElementGetProperty(fm_canvas, "stateEvents")) - 1];
	};
	
	/// @function CanvasGetPosition(fm_canvas : ds_map) -> Vector3
	CanvasGetPosition = function(fm_canvas) {
	    return fm_canvas[? "pos"];
	};

	/// @function CanvasGetSize(fm_canvas : ds_map) -> Vector2
	CanvasGetSize = function(fm_canvas) {
	    return fm_canvas[? "size"];
	}; 

	/// @function CanvasGetBackgroundColor(fm_canvas : ds_map) -> Vector4
	CanvasGetBackgroundColor = function(fm_canvas) {
	    return fm_canvas[? "bCol"];
	}; 

	/// @function CanvasGetSurface(fm_canvas : ds_map) -> surface
	CanvasGetSurface = function(fm_canvas) {
	    return fm_canvas[? "surface"];
	}; 

	/// @function CanvasGetElement(fm_canvas : ds_map, fm_pos : number) -> ds_map
	CanvasGetElement = function(fm_canvas, fm_pos) {
	    return fm_canvas[? "elements"][| fm_pos];
	}; 

	/// @function CanvasGetElements(fm_canvas : ds_map) -> ds_list
	CanvasGetElements = function(fm_canvas) {
	    return fm_canvas[? "elements"];
	}; 

	/// @function CanvasGetElementSize(fm_canvas : ds_map) -> number
	CanvasGetElementSize = function(fm_canvas) {
	    return ds_list_size(fm_canvas[? "elements"]);
	}; 

	/// @function CanvasGetBeforeUpdate(fm_canvas : ds_map) -> function
	CanvasGetBeforeUpdate = function(fm_canvas) {
	    return fm_canvas[? "BeforeUpdate"];
	}; 

	/// @function CanvasGetAfterUpdate(fm_canvas : ds_map) -> function
	CanvasGetAfterUpdate = function(fm_canvas) {
	    return fm_canvas[? "AfterUpdate"];
	}; 

	/// @function CanvasGetBeforeDraw(fm_canvas : ds_map) -> function
	CanvasGetBeforeDraw = function(fm_canvas) {
	    return fm_canvas[? "BeforeDraw"];
	}; 

	/// @function CanvasGetAfterDraw(fm_canvas : ds_map) -> function
	CanvasGetAfterDraw = function(fm_canvas) {
	    return fm_canvas[? "AfterDraw"];
	}; 

	/// @function CanvasGetParent(fm_canvas : ds_map) -> ds_map
	CanvasGetParent = function(fm_canvas) {
	    return fm_canvas[? "parent"];
	}; 
	
	/// @function CanvasGetActive(fm_canvas : ds_map) -> boolean
	CanvasGetActive = function(fm_canvas) {
		return fm_canvas[? "active"];
	};
	
	/// @function CanvasGetAlignment(fm_canvas : ds_map) -> Align
	CanvasGetAlignment = function(fm_canvas) {
		return fm_canvas[? "alignment"];
	};
	
	/// @function CanvasGetShader(fm_canvas : ds_map) -> shader
	CanvasGetShader = function(fm_canvas) {
		return fm_canvas[? "shader"];
	};
	
	/// @function CanvasGetParameterScript(fm_canvas : ds_map) -> function
	CanvasGetParameterScript = function(fm_canvas) {
		return fm_canvas[? "shaderParameterScript"];
	};
	
	/// @function CanvasGetAutoScaleHorizontal(fm_canvas : ds_map) -> boolean
	CanvasGetAutoScaleHorizontal = function(fm_canvas) {
		return ElementGetProperty(fm_canvas, "autoScaleHorizontal");
	};
	
	/// @function CanvasGetAutoScaleVertical(fm_canvas : ds_map) -> boolean
	CanvasGetAutoScaleVertical = function(fm_canvas) {
		return ElementGetProperty(fm_canvas, "autoScaleVertical");
	};
	
	/// @function CanvasGetEdgeHorizontal(fm_canvas : ds_map) -> number
	CanvasGetEdgeHorizontal = function(fm_canvas) {
		return ElementGetProperty(fm_canvas, "highestPointOnX");
	};
	
	/// @function CanvasGetEdgeVertical(fm_canvas : ds_map) -> number
	CanvasGetEdgeVertical = function(fm_canvas) {
		return ElementGetProperty(fm_canvas, "highestPointOnY");
	};
	
	/// @function CanvasGetActive(fm_canvas : ds_map) -> boolean
	CanvasGetActive = function(fm_canvas) {
		return ElementGetProperty(fm_canvas, "active");
	};

	/// @function CanvasSetPosition(fm_canvas : ds_map, fm_pos : Vector3) -> undefined
	CanvasSetPosition = function(fm_canvas, fm_pos) {
		delete fm_canvas[? "pos"];
	    fm_canvas[? "pos"] = fm_pos;
	}; 

	/// @function CanvasSetSize(fm_canvas : ds_map, fm_size : Vector2) -> undefined
	CanvasSetSize = function(fm_canvas, fm_size) {
		if (fm_canvas[? "size"].x == fm_size.x && fm_canvas[? "size"].y == fm_size.y) {
			return;
		};
		delete fm_canvas[? "size"];
	    fm_canvas[? "size"] = fm_size;
		fm_canvas[? "size"].x = max(1, fm_canvas[? "size"].x);
		fm_canvas[? "size"].y = max(1, fm_canvas[? "size"].y);
		surface_resize(CanvasGetSurface(fm_canvas), CanvasGetSize(fm_canvas).x, CanvasGetSize(fm_canvas).y);
	}; 

	/// @function CanvasSetBackgroundColor(fm_canvas : ds_map, fm_bCol : Vector4) -> undefined
	CanvasSetBackgroundColor = function(fm_canvas, fm_bCol) {
		delete fm_canvas[? "bCol"];
	    fm_canvas[? "bCol"] = fm_bCol;
	}; 

	/// @function CanvasSetSurface(fm_canvas : ds_map, fm_surface : surface) -> undefined
	CanvasSetSurface = function(fm_canvas, fm_surface) {
		surface_free(fm_canvas[? "surface"]);
	    fm_canvas[? "surface"] = fm_surface;
	}; 

	/// @function CanvasSetBeforeUpdate(fm_canvas : ds_map, fm_beforeUpdate : function) -> undefined
	CanvasSetBeforeUpdate = function(fm_canvas, fm_beforeUpdate) {
	    fm_canvas[? "BeforeUpdate"] = fm_beforeUpdate;
	}; 

	/// @function CanvasSetAfterUpdate(fm_canvas : ds_map, fm_afterUpdate : function) -> undefined
	CanvasSetAfterUpdate = function(fm_canvas, fm_afterUpdate) {
	    fm_canvas[? "AfterUpdate"] = fm_afterUpdate;
	}; 

	/// @function CanvasSetBeforeDraw(fm_canvas : ds_map, fm_beforeDraw : function) -> undefined
	CanvasSetBeforeDraw = function(fm_canvas, fm_beforeDraw) {
	    fm_canvas[? "BeforeDraw"] = fm_beforeDraw;
	}; 

	/// @function CanvasSetAfterDraw(fm_canvas : ds_map, fm_afterDraw : function) -> undefinedI
	CanvasSetAfterDraw = function(fm_canvas, fm_afterDraw) {
	    fm_canvas[? "AfterDraw"] = fm_afterDraw;
	}; 
	
	/// @function CanvasSetAlignment(fm_canvas : ds_map, fm_alignment : Align) -> undefined
	CanvasSetAlignment = function(fm_canvas, fm_alignment) {
		delete fm_canvas[? "alignment"];
		fm_canvas[? "alignment"] = fm_alignment;
	};
	
	/// @function CanvasSetShader(fm_canvas : ds_map, fm_shader : shader) -> undefined
	CanvasSetShader = function(fm_canvas, fm_shader) {
		fm_canvas[? "shader"] = fm_shader;
	};
	
	/// @function CanvasSetParameterScript(fm_canvas : ds_map, fm_script : function) -> undefined
	CanvasSetParameterScript = function(fm_canvas, fm_script) {
		fm_canvas[? "shaderParameterScript"] = fm_script;
	};
	
	/// @function CanvasSetAutoScaleHorizontal(fm_canvas : ds_map, fm_autoScale : boolean) -> undefined
	CanvasSetAutoScaleHorizontal = function(fm_canvas, fm_autoScale) {
		ElementSetProperty(fm_canvas, fm_autoScale, "autoScaleHorizontal");
	};
	
	/// @function CanvasSetAutoScaleVertical(fm_canvas : ds_map, fm_autoScale : boolean) -> undefined
	CanvasSetAutoScaleVertical = function(fm_canvas, fm_autoScale) {
		ElementSetProperty(fm_canvas, fm_autoScale, "autoScaleVertical");
	};
	
	/// @function CanvasSetEdgeHorizontal(fm_canvas : ds_map, fm_edge : number) -> undefined
	CanvasSetEdgeHorizontal = function(fm_canvas, fm_edge) {
		ElementSetProperty(fm_canvas, fm_edge, "highestPointOnX");
	};
	
	/// @function CanvasSetEdgeVertical(fm_canvas : ds_map, fm_edge : number) -> undefined
	CanvasSetEdgeVertical = function(fm_canvas) {
		return ElementSetProperty(fm_canvas, fm_edge, "highestPointOnY");
	};
	
	/// @function CanvasSetActive(fm_canvas : ds_map, fm_active : boolean) -> undefined
	CanvasSetActive = function(fm_canvas, fm_active) {
		ElementSetProperty(fm_canvas, fm_active, "active");
	};
	
	/// @function ButtonCreate(pos : Vector3, text : string, parent = noone : ds_map, onClick = noone : function, size = new Vector2(82, 24) : Vector2, onUpdateBefore = STYLER_BUTTON_UPDATE_BEFORE : function, onUpdateAfter = STYLER_BUTTON_UPDATE_AFTER : function, onDrawBefore = STYLER_BUTTON_DRAW_BEFORE : function, onDrawAfter = STYLER_BUTTON_DRAW_AFTER : function) -> ds_map
	ButtonCreate = function (fm_pos, fm_text, fm_parent = noone, fm_onClick = noone, fm_size = new Vector2(82, 24), fm_onUpdateBefore = STYLER_BUTTON_UPDATE_BEFORE, fm_onUpdateAfter = STYLER_BUTTON_UPDATE_AFTER, fm_onDrawBefore = STYLER_BUTTON_DRAW_BEFORE, fm_onDrawAfter = STYLER_BUTTON_DRAW_AFTER) {
		var button = CanvasCreate(fm_pos, fm_size, new Vector4(0, 0, 0, 0), fm_parent);
		
		button[? "state"] = CLICKABLE_STATE.IDLE;
		button[? "text"] = fm_text;
		button[? "font"] = m_font;
		
		button[? "BeforeUpdate"] = fm_onUpdateBefore;
		button[? "AfterUpdate"] = fm_onUpdateAfter;
		button[? "BeforeDraw"] = fm_onDrawBefore;
		button[? "AfterDraw"] = fm_onDrawAfter;
		button[? "OnClick"] = fm_onClick; // takes button itself
		
		button[? "FreeEx"] = ButtonFree;
		
		return button;
	};
	
	/// @function ButtonFree(fm_button : ds_map) -> undefined
	ButtonFree = function(fm_button) {
	};
	
	/// @function ButtonEnable(fm_button : ds_map) -> undefined
	ButtonEnable = function(fm_button) {
		fm_button[? "state"] = CLICKABLE_STATE.IDLE;
	};
	
	/// @function ButtonDisable(fm_button : ds_map) -> undefined
	ButtonDisable = function(fm_button) {
		fm_button[? "state"] = CLICKABLE_STATE.DISABLED;
	};
	
	/// @function ButtonGetState(fm_button : ds_map) -> number
	ButtonGetState = function(fm_button) {
	    return fm_button[? "state"];
	}; 

	/// @function ButtonGetText(fm_button : ds_map) -> string
	ButtonGetText = function(fm_button) {
	    return fm_button[? "text"];
	}; 

	/// @function ButtonGetFont(fm_button : ds_map) -> font
	ButtonGetFont = function ButtonGetFont(fm_button) {
	    return fm_button[? "font"];
	}; 

	/// @function ButtonGetOnClick(fm_button : ds_map) -> function
	ButtonGetOnClick = function(fm_button) {
	    return fm_button[? "OnClick"];
	}; 
	
	/// @function ButtonSetState(fm_button : ds_map, fm_state : number) -> undefined
	ButtonSetState = function(fm_button, fm_state) {
	    fm_button[? "state"] = fm_state;
	}; 

	/// @function ButtonSetText(fm_button : ds_map, fm_text : string) -> undefined
	ButtonSetText = function(fm_button, fm_text) {
	    fm_button[? "text"] = fm_text;
	}; 

	/// @function ButtonSetFont(fm_button : ds_map, fm_font : font) -> undefined
	ButtonSetFont = function(fm_button, fm_font) {
	    fm_button[? "font"] = fm_font;
	}; 

	/// @function ButtonSetOnClick(fm_button : ds_map, fm_onClick : function) -> undefined
	ButtonSetOnClick = function(fm_button, fm_onClick) {
	    fm_button[? "OnClick"] = fm_onClick;
	}; 
	
	/// @function CheckboxCreate(pos : Vector3, parent = noone : ds_map, size = new Vector2(16, 16) : Vector2, onClick = noone : function, onUpdateBefore = STYLER_CHECKBOX_UPDATE_BEFORE : function, onUpdateAfter = STYLER_CHECKBOX_UPDATE_AFTER : function, onDrawBefore = STYLER_CHECKBOX_DRAW_BEFORE : function, onDrawAfter = STYLER_CHECKBOX_DRAW_AFTER : function) -> ds_map
	CheckboxCreate = function
	(
		fm_pos, 
		fm_parent = noone, 
		fm_size = new Vector2(16, 16), 
		fm_onClick = noone, 
		fm_onUpdateBefore = STYLER_CHECKBOX_UPDATE_BEFORE, 
		fm_onUpdateAfter = STYLER_CHECKBOX_UPDATE_AFTER, 
		fm_onDrawBefore = STYLER_CHECKBOX_DRAW_BEFORE, 
		fm_onDrawAfter = STYLER_CHECKBOX_DRAW_AFTER
	) 
	{
		var checkbox = ButtonCreate
		(
			fm_pos, "", 
			fm_parent, 
			fm_onClick, 
			fm_size, 
			fm_onUpdateBefore, fm_onUpdateAfter, 
			fm_onDrawBefore, fm_onDrawAfter
		);
		
		checkbox[? "check"] = false;
		
		checkbox[? "FreeEx"] = CheckboxFree;
		
		return checkbox;
	};
	
	/// @function CheckboxFree(fm_checkbox : ds_map) -> undefined
	CheckboxFree = function(fm_checkbox) {
		ButtonFree(fm_checkbox);
	};
	
	/// @function CheckboxGetCheck(fm_checkbox : ds_map) -> boolean
	CheckboxGetCheck = function(fm_checkbox) {
		return ElementGetProperty(fm_checkbox, "check");
	};
	
	/// @function CheckboxSetCheck(fm_checkbox : ds_map, fm_check : boolean) -> undefined
	CheckboxSetCheck = function(fm_checkbox, fm_check) {
		ElementSetProperty(fm_checkbox, fm_check, "check");
	};
	
	/// @function LabelCreate(pos : Vector3, text : string, parent = noone : ds_map, width = 9999 : number, wrapMode = wrapped_text.dots : wrapped_text, color = new Vector4(255, 255, 255, 255) : Vector4, font = noone : font, bCol = new Vector4(0, 0, 0, 0) : Vector4, onUpdateBefore = STYLER_LABEL_UPDATE_BEFORE : function, onUpdateAfter = STYLER_LABEL_UPDATE_AFTER : function, onDrawBefore = STYLER_LABEL_DRAW_BEFORE : function, onDrawAfter = STYLER_LABEL_DRAW_AFTER : function) -> ds_map
	LabelCreate = function
	(
		fm_pos, fm_text, 
		fm_parent = noone, 
		fm_width = 9999, 
		fm_wrapMode = wrapped_text.dots, 
		fm_color = new Vector4(255, 255, 255, 255), 
		fm_font = noone, 
		fm_bCol = new Vector4(0, 0, 0, 0), 
		fm_onUpdateBefore = STYLER_LABEL_UPDATE_BEFORE, 
		fm_onUpdateAfter = STYLER_LABEL_UPDATE_AFTER, 
		fm_onDrawBefore = STYLER_LABEL_DRAW_BEFORE, 
		fm_onDrawAfter = STYLER_LABEL_DRAW_AFTER
	) 
	{
		var _font = m_font;
		if (fm_font != noone && font_exists(fm_font)) {
			_font = fm_font;
		};
		
		var width, height;
		var oldFont = draw_get_font();
		draw_set_font(_font);
		width = max(string_width(fm_text), 1);
		height = max(string_height(fm_text), 1);
		draw_set_font(oldFont);
		
		var label = CanvasCreate(fm_pos, new Vector2(width, height), fm_bCol, fm_parent);
		
		label[? "BeforeUpdate"] = fm_onUpdateBefore;
		label[? "AfterUpdate"] = fm_onUpdateAfter;
		label[? "BeforeDraw"] = fm_onDrawBefore;
		label[? "AfterDraw"] = fm_onDrawAfter;
		
		label[? "text"] = fm_text;
		label[? "color"] = fm_color;
		label[? "textAlignment"] = new Align(ALIGN.LEFT, ALIGN.TOP);
		
		label[? "isPassword"] = false;
		label[? "passwordCharacter"] = "*";
		
		label[? "FreeEx"] = LabelFree;
		label[? "font"] = _font;
		
		ElementSetProperty(label, false, "virtualContainer"); /////////
		ElementSetProperty(label, fm_width, "virtualContainerWidth");
		ElementSetProperty(label, fm_wrapMode, "wrapMode");
		ElementSetProperty(label, false, "divide");
		ElementSetProperty(label, ds_list_create(), "textFrontend");
		
		return label;
	};
	
	/// @function LabelFree(fm_label : ds_map) -> undefined
	LabelFree = function(fm_label) {
		delete fm_label[? "color"];
		delete fm_label[? "textAlignment"];
		ds_list_destroy(fm_label[? "textFrontend"]);
	};
	
	/// @function LabelGetText(fm_label : ds_map) -> string
	LabelGetText = function(fm_label) {
		return fm_label[? "text"];
	};
	
	/// @function LabelGetColor(fm_label : ds_map) -> Vector4
	LabelGetColor = function(fm_label) {
		return fm_label[? "color"];
	};
	
	/// @function LabelGetFont(fm_label : ds_map) -> font
	LabelGetFont = function(fm_label) {
		return fm_label[? "font"];
	};
	
	/// @function LabelGetTextAlignment(fm_label : ds_map) -> Align
	LabelGetTextAlignment = function(fm_label) {
		return fm_label[? "textAlignment"];
	};
	
	/// @function LabelGetPassword(fm_label : ds_map) -> boolean
	LabelGetPassword = function(fm_label) {
		return fm_label[? "isPassword"];
	};
	
	/// @function LabelGetPasswordCharacter(fm_label : ds_map) -> stringr
	LabelGetPasswordCharacter = function(fm_label) {
		return fm_label[? "passwordCharacter"];
	};
	
	/// @function LabelGetVirtualContainer(fm_label : ds_map) -> boolean
	LabelGetVirtualContainer = function(fm_label) {
		return ElementGetProperty(fm_label, "virtualContainer");
	};
	
	/// @function LabelGetVirtualContainerWidth(fm_label : ds_map) -> number
	LabelGetVirtualContainerWidth = function(fm_label) {
		return ElementGetProperty(fm_label, "virtualContainerWidth");
	};
	
	/// @function LabelGetWrapMode(fm_label : ds_map) -> wrapped_text
	LabelGetWrapMode = function(fm_label) {
		return ElementGetProperty(fm_label, "wrapMode");
	};
	
	/// @function LabelGetDivide(fm_label : ds_map) -> boolean
	LabelGetDivide = function(fm_label) {
		return ElementGetProperty(fm_label, "divide");
	};
	
	/// @function LabelGetTextFrontend(fm_label : ds_map) -> ds_list
	LabelGetTextFrontend = function(fm_label) {
		return ElementGetProperty(fm_label, "textFrontend");
	};

	/// @function LabelRearrangeCanvas(fm_label : ds_map) -> undefined
	LabelRearrangeCanvas = function(fm_label) {
		var width, height;
		var oldFont = draw_get_font();
		var oldAlignH = draw_get_halign();
		var oldAlignV = draw_get_valign();
		draw_set_font(fm_label[? "font"]);
		draw_set_halign(AlignGetAsGM(LabelGetTextAlignment(fm_label).horizontal));
		draw_set_valign(AlignGetAsGM(LabelGetTextAlignment(fm_label).vertical));
		width = max(string_width(fm_label[? "text"]), 1);
		height = max(string_height(fm_label[? "text"]), 1);
		draw_set_font(oldFont);
		draw_set_halign(oldAlignH);
		draw_set_valign(oldAlignV);
		CanvasSetSize(fm_label, new Vector2(width, height));
	};
	/// @function LabelSetText(fm_label : ds_map, fm_text : string) -> undefined
	LabelSetText = function(fm_label, fm_text) {
		fm_label[? "text"] = fm_text;
		LabelRearrangeCanvas(fm_label);
		//var width, height;
		//var oldFont = draw_get_font();
		//var oldAlignH = draw_get_halign();
		//var oldAlignV = draw_get_valign();
		//draw_set_font(fm_label[? "font"]);
		//draw_set_halign(AlignGetAsGM(LabelGetTextAlignment(fm_label).horizontal));
		//draw_set_valign(AlignGetAsGM(LabelGetTextAlignment(fm_label).vertical));
		//width = max(string_width(fm_text), 1);
		//height = max(string_height(fm_text), 1);
		//draw_set_font(oldFont);
		//draw_set_halign(oldAlignH);
		//draw_set_valign(oldAlignV);
		//CanvasSetSize(fm_label, new Vector2(width, height));
	};
	
	/// @function LabelSetColor(fm_label : ds_map, fm_color : Vector4) -> undefined
	LabelSetColor = function(fm_label, fm_color) {
		fm_label[? "color"] = fm_color;
	};
	
	/// @function LabelSetFont(fm_label : ds_map, fm_font : font) -> undefined
	LabelSetFont = function(fm_label, fm_font) {
		fm_label[? "font"] = fm_font;
		LabelRearrangeCanvas(fm_label);
	};
	
	/// @function LabelSetTextAlignment(fm_label : ds_map, fm_alignment : Align) -> undefined
	LabelSetTextAlignment = function(fm_label, fm_alignment) {
		fm_label[? "textAlignment"] = fm_alignment;
	};
	
	/// @function LabelSetPassword(fm_label : ds_map, fm_enable : boolean) -> undefined
	LabelSetPassword = function(fm_label, fm_enable) {
		fm_label[? "isPassword"] = fm_enable;
	};
	
	/// @function LabelSetPasswordCharacter(fm_label : ds_map, fm_character : string) -> undefined
	LabelSetPasswordCharacter = function(fm_label, fm_character) {
		if (string_length(fm_character) > 1) {
			return;
		};
		fm_label[? "passwordCharacter"] = fm_character;
	};
	
	/// @function LabelSetVirtualContainer(fm_label : ds_map, fm_state : boolean) -> undefined
	LabelSetVirtualContainer = function(fm_label, fm_state) {
		ElementSetProperty(fm_label, fm_state, "virtualContainer");
	};
	
	/// @function LabelSetVirtualContainerWidth(fm_label : ds_map, fm_width : number) -> undefined
	LabelSetVirtualContainerWidth = function(fm_label, fm_width) {
		ElementSetProperty(fm_label, fm_width, "virtualContainerWidth");
	};
	
	/// @function LabelSetWrapMode(fm_label : ds_map, fm_wrapMode : wrapped_text) -> undefined
	LabelSetWrapMode = function(fm_label, fm_wrapMode) {
		ElementSetProperty(fm_label, fm_wrapMode, "wrapMode");
	};
	
	/// @function LabelSetDivide(fm_label : ds_map, fm_divide : boolean) -> undefined
	LabelSetDivide = function(fm_label, fm_divide) {
		ElementSetProperty(fm_label, fm_divide, "divide");
	};
	
	/// @function LabelSetTextFrontend(fm_label : ds_map, fm_textFrontend : ds_list) -> undefined
	LabelSetTextFrontend = function(fm_label, fm_textFrontend) {
		ElementSetProperty(fm_label, fm_textFrontend, "textFrontend");
	};
	
	/// @function RadioboxCreate(pos : Vector3, parent = noone : ds_map, size = new Vector2(16, 16) : Vector2, onClick = noone : function, onUpdateBefore = STYLER_RADIOBOX_UPDATE_BEFORE : function, onUpdateAfter = STYLER_RADIOBOX_UPDATE_AFTER : function, onDrawBefore = STYLER_RADIOBOX_DRAW_BEFORE : function, onDrawAfter = STYLER_RADIOBOX_DRAW_AFTER : function) -> ds_map
	RadioboxCreate = function
	(
		fm_pos, 
		fm_parent = noone, 
		fm_size = new Vector2(16, 16), 
		fm_onClick = noone, 
		fm_onUpdateBefore = STYLER_RADIOBOX_UPDATE_BEFORE, 
		fm_onUpdateAfter = STYLER_RADIOBOX_UPDATE_AFTER, 
		fm_onDrawBefore = STYLER_RADIOBOX_DRAW_BEFORE, 
		fm_onDrawAfter = STYLER_RADIOBOX_DRAW_AFTER
	) 
	{
		var radiobox = CheckboxCreate
		(
			fm_pos, 
			fm_parent, 
			fm_size, 
			fm_onClick, 
			fm_onUpdateBefore, 
			fm_onUpdateAfter, 
			fm_onDrawBefore, 
			fm_onDrawAfter
		);
		
		radiobox[? "FreeEx"] = RadioboxFree;
		
		radiobox[? "group"] = noone;
		
		return radiobox;
	};
	
	/// @function RadioboxFree(fm_radiobox : ds_map) -> undefined
	RadioboxFree = function(fm_radiobox) {
		if (fm_radiobox[? "group"] != noone) {
			SelectableGroupFree(fm_radiobox[? "group"]);
		};
		CheckboxFree(fm_radiobox);
	};
	
	/// @function RadioboxGetGroup(fm_radiobox : ds_map) -> ds_map
	RadioboxGetGroup = function(fm_radiobox) {
		return ElementGetProperty(fm_radiobox, "group");
	};
	
	/// @function SelectableGroupCreate() -> ds_map
	SelectableGroupCreate = function
	(
	) 
	{
		var selectableGroup = ds_map_create();
		selectableGroup[? "elements"] = ds_list_create();
		selectableGroup[? "selected"] = noone;
		
		return selectableGroup;
	};
	
	/// @function SelectableGroupFreeAll(fm_selectableGroup : ds_map) -> undefined
	SelectableGroupFreeAll = function(fm_selectableGroup) {
		for (var i = 0; i < ds_list_size(fm_selectableGroup[? "elements"]); i++) {
			if (ds_exists(fm_selectableGroup[? "elements"][| i], ds_type_map)) {
				ds_map_destroy(fm_selectableGroup[? "elements"][| i]);
			};
		};
		ds_list_destroy(fm_selectableGroup[? "elements"]);
		ds_map_destroy(fm_selectableGroup);
	};
	
	/// @function SelectableGroupFree(fm_selectableGroup : ds_map) -> undefined
	SelectableGroupFree = function(fm_selectableGroup) {
		ds_list_destroy(fm_selectableGroup[? "elements"]);
		ds_map_destroy(fm_selectableGroup);
	};
	
	/// @function SelectableGroupAddElement(fm_group : ds_map, fm_element : ds_map) -> undefined
	SelectableGroupAddElement = function
	(
		fm_group, 
		fm_element
	) 
	{
		ds_list_add(fm_group[? "elements"], fm_element);
		fm_element[? "group"] = fm_group;
	};
	
	/// @function SelectableGroupCreateRadiobox(fm_group : ds_map, pos : Vector3, parent = noone : ds_map, size = new Vector2(16, 16) : Vector2, onClick = noone : function, onUpdateBefore = STYLER_RADIOBOX_UPDATE_BEFORE : function, onUpdateAfter = STYLER_RADIOBOX_UPDATE_AFTER : function, onDrawBefore = STYLER_RADIOBOX_DRAW_BEFORE : function, onDrawAfter = STYLER_RADIOBOX_DRAW_AFTER : function) -> ds_map
	SelectableGroupCreateRadiobox = function // deprecated
	(
		fm_group, fm_pos, 
		fm_parent = noone, 
		fm_size = new Vector2(16, 16), 
		fm_onClick = noone, 
		fm_onUpdateBefore = STYLER_RADIOBOX_UPDATE_BEFORE, 
		fm_onUpdateAfter = STYLER_RADIOBOX_UPDATE_AFTER, 
		fm_onDrawBefore = STYLER_RADIOBOX_DRAW_BEFORE, 
		fm_onDrawAfter = STYLER_RADIOBOX_DRAW_AFTER
	) 
	{
		var radiobox = RadioboxCreate
					(
						fm_pos, 
						fm_parent, 
						fm_size, 
						fm_onClick, 
						fm_onUpdateBefore, 
						fm_onUpdateAfter, 
						fm_onDrawBefore, 
						fm_onDrawAfter
					);
		ds_list_add(fm_group[? "elements"], radiobox);
		
		radiobox[? "group"] = fm_group;
		
		return radiobox;
	};
	
	/// @function SelectableGroupGetSelected(fm_selectableGroup : ds_map) -> ds_map
	SelectableGroupGetSelected = function(fm_selectableGroup) {
		return fm_selectableGroup[? "selected"];
	};
	
	/// @function SelectableGroupSetSelected(fm_selectableGroup : ds_map, fm_selectable : ds_map) -> boolean
	SelectableGroupSetSelected = function(fm_selectableGroup, fm_selectable) {
		if (ds_list_find_index(fm_selectableGroup[? "elements"], fm_selectable) == -1) {
			return false;
		};
		
		if (fm_selectableGroup[? "selected"] != noone) {
			fm_selectableGroup[? "selected"][? "check"] = false;
		};
		fm_selectableGroup[? "selected"] = fm_selectable;
		if (fm_selectableGroup[? "selected"] != noone) {
			fm_selectableGroup[? "selected"][? "check"] = true;
		};
		
		return true;
	};
	/// @function SelectableGroupSetSelectedRaw(fm_selectableGroup : ds_map, fm_selectable : ds_map) -> undefined}
	SelectableGroupSetSelectedRaw = function(fm_selectableGroup, fm_selectable) {
		if (fm_selectableGroup[? "selected"] != noone) {
			fm_selectableGroup[? "selected"][? "check"] = false;
		};
		fm_selectableGroup[? "selected"] = fm_selectable;
		if (fm_selectableGroup[? "selected"] != noone) {
			fm_selectableGroup[? "selected"][? "check"] = true;
		};
	};
	
	/// @function SlidebarCreate(pos : Vector3, parent = noone : ds_map, startVal = 0 : number, endVal = 1 : number, percentage = 0 : number, length = 100 : number, width = 20 : number, onClick = noone : function, onUpdateBefore = STYLER_SLIDEBAR_UPDATE_BEFORE : function, onUpdateAfter = STYLER_SLIDEBAR_UPDATE_AFTER : function, onDrawBefore = STYLER_SLIDEBAR_DRAW_BEFORE : function, onDrawAfter = STYLER_SLIDEBAR_DRAW_AFTER : function) -> ds_map
	SlidebarCreate = function
	(
		fm_pos, 
		fm_parent = noone, 
		fm_startVal = 0, fm_endVal = 1, 
		fm_percentage = 0, 
		fm_length = 100, fm_width = 20, 
		fm_onClick = noone, 
		fm_onUpdateBefore = STYLER_SLIDEBAR_UPDATE_BEFORE, 
		fm_onUpdateAfter = STYLER_SLIDEBAR_UPDATE_AFTER, 
		fm_onDrawBefore = STYLER_SLIDEBAR_DRAW_BEFORE, 
		fm_onDrawAfter = STYLER_SLIDEBAR_DRAW_AFTER
	) 
	{
		var slidebar = CanvasCreate(fm_pos, new Vector2(fm_length, fm_width), new Vector4(0, 0, 0, 0), fm_parent);
		
		slidebar[? "state"] = CLICKABLE_STATE.IDLE;
		
		slidebar[? "BeforeUpdate"] = fm_onUpdateBefore;
		slidebar[? "AfterUpdate"] = fm_onUpdateAfter;
		slidebar[? "BeforeDraw"] = fm_onDrawBefore;
		slidebar[? "AfterDraw"] = fm_onDrawAfter;
		slidebar[? "OnClick"] = fm_onClick;
		
		slidebar[? "FreeEx"] = SlidebarFree;
		
		slidebar[? "percentage"] = fm_percentage;
		slidebar[? "startVal"] = fm_startVal;
		slidebar[? "endVal"] = fm_endVal;
		
		slidebar[? "mouseTracking"] = false;
		
		return slidebar;
	};
	
	/// @function SlidebarFree(fm_slidebar : ds_map) -> undefined
	SlidebarFree = function(fm_slidebar) {
	};
	
	/// @function SlidebarGetPercentage(fm_slidebar : ds_map) -> number
	SlidebarGetPercentage = function(fm_slidebar) {
		return fm_slidebar[? "percentage"];
	};
	
	/// @function SlidebarGetValue(fm_slidebar : ds_map) -> number
	SlidebarGetValue = function(fm_slidebar) {
		return Mix(fm_slidebar[? "startVal"], fm_slidebar[? "endVal"], SlidebarGetPercentage(fm_slidebar));
	};

	/// @function SlidebarSetPercentage(fm_slidebar : ds_map, fm_percentage : number) -> undefined
	SlidebarSetPercentage = function(fm_slidebar, fm_percentage) {
		fm_slidebar[? "percentage"] = fm_percentage;
	};
	
	/// @function SlidebarSetValue(fm_slidebar : ds_map, fm_value : number) -> undefined
	SlidebarSetValue = function(fm_slidebar, fm_value) {
		var value = max(min(fm_slidebar[? "endVal"], fm_value), fm_slidebar[? "startVal"]);
		fm_slidebar[? "percentage"] = (value - fm_slidebar[? "startVal"]) / fm_slidebar[? "endVal"];
	};
	
	/// @function PanelCreate(pos = new Vector3(0, 0, 0) : Vector3, gap = new Vector2(5, 5) : Vector2, autoFit = false : boolean, parent = noone : ds_map, bCol = new Vector4(16, 16, 16, 255) : Vector4, size = new Vector2(256, 256) : Vector2, onClick = noone : function, onUpdateBefore = STYLER_PANEL_UPDATE_BEFORE : function, onUpdateAfter = STYLER_PANEL_UPDATE_AFTER : function, onDrawBefore = STYLER_PANEL_DRAW_BEFORE : function, onDrawAfter = STYLER_PANEL_DRAW_AFTER : function, onUpdateBeforeTitle = STYLER_PANELTITLE_UPDATE_BEFORE : function, onUpdateAfterTitle = STYLER_PANELTITLE_UPDATE_AFTER : function, onDrawBeforeTitle = STYLER_PANELTITLE_DRAW_BEFORE : function, onDrawAfterTitle = STYLER_PANELTITLE_DRAW_AFTER : function) -> ds_map
	PanelCreate = function
	(
		fm_pos = new Vector3(0, 0, 0), 
		fm_gap = new Vector2(5, 5), 
		fm_autoFit = false, 
		fm_parent = noone, 
		fm_bCol = new Vector4(16, 16, 16, 255), 
		fm_size = new Vector2(256, 256), 
		fm_onClick = noone, 
		
		fm_onUpdateBefore = STYLER_PANEL_UPDATE_BEFORE, 
		fm_onUpdateAfter = STYLER_PANEL_UPDATE_AFTER, 
		fm_onDrawBefore = STYLER_PANEL_DRAW_BEFORE, 
		fm_onDrawAfter = STYLER_PANEL_DRAW_AFTER, 
		
		fm_onUpdateBeforeTitle = STYLER_PANELTITLE_UPDATE_BEFORE, 
		fm_onUpdateAfterTitle = STYLER_PANELTITLE_UPDATE_AFTER, 
		fm_onDrawBeforeTitle = STYLER_PANELTITLE_DRAW_BEFORE, 
		fm_onDrawAfterTitle = STYLER_PANELTITLE_DRAW_AFTER
	) 
	{
		var panel = CanvasCreate(fm_pos, fm_size, fm_bCol, fm_parent);
		
		panel[? "BeforeUpdate"] = fm_onUpdateBefore;
		panel[? "AfterUpdate"] = fm_onUpdateAfter;
		panel[? "BeforeDraw"] = fm_onDrawBefore;
		panel[? "AfterDraw"] = fm_onDrawAfter;
		panel[? "OnClick"] = fm_onClick;
		panel[? "BeforeUpdateTitle"] = fm_onUpdateBeforeTitle;
		panel[? "AfterUpdateTitle"] = fm_onUpdateAfterTitle;
		panel[? "BeforeDrawTitle"] = fm_onDrawBeforeTitle;
		panel[? "AfterDrawTitle"] = fm_onDrawAfterTitle;
		
		panel[? "FreeEx"] = PanelFree;
		
		panel[? "stack"] = ds_stack_create(); // map -> [elements[queue]], [autoFit], [placementTotal], [placement], [pushX], [title]
		panel[? "backup"] = ds_list_create(); // map -> [elements[list]], [autoFit], [placementTotal], [placement], [pushX], [title]
		panel[? "backupPos"] = -1;
		panel[? "currentStack"] = noone;
		panel[? "gap"] = fm_gap;
		panel[? "placementTotal"] = 0;
		
		panel[? "pushX"] = -1;
		panel[? "pushWidth"] = 16;
		panel[? "pushY"] = 0;
		
		panel[? "heighWide"] = 28;
		panel[? "lastY"] = 0;
		
		panel[? "autoFit"] = fm_autoFit;
		
		panel[? "Refresh"] = PanelRefresh;
		
		panel[? "titleStack"] = ds_list_create();
		panel[? "titleList"] = ds_list_create();
		
		panel[? "resizeTopLeft"] = false;
		panel[? "resizeTopCenter"] = false;
		panel[? "resizeTopRight"] = false;
		
		panel[? "resizeMiddleLeft"] = false;
		panel[? "resizeMiddleRight"] = false;
		
		panel[? "resizeBottomLeft"] = false;
		panel[? "resizeBottomCenter"] = false;
		panel[? "resizeBottomRight"] = false;
		
		panel[? "lock"] = false;
		
		return panel;
	};
	
	PanelSetResizeTopLeft = function(fm_panel, fm_enable) { fm_panel[? "resizeTopLeft"] = fm_enable; };
	PanelSetResizeTopCenter = function(fm_panel, fm_enable) { fm_panel[? "resizeTopCenter"] = fm_enable; };
	PanelSetResizeTopRight = function(fm_panel, fm_enable) { fm_panel[? "resizeTopRight"] = fm_enable; };
	
	PanelSetResizeMiddleLeft = function(fm_panel, fm_enable) { fm_panel[? "resizeMiddleLeft"] = fm_enable; };
	PanelSetResizeMiddleRight = function(fm_panel, fm_enable) { fm_panel[? "resizeMiddleRight"] = fm_enable; };
	
	PanelSetResizeBottomLeft = function(fm_panel, fm_enable) { fm_panel[? "resizeBottomLeft"] = fm_enable; };
	PanelSetResizeBottomCenter = function(fm_panel, fm_enable) { fm_panel[? "resizeBottomCenter"] = fm_enable; };
	PanelSetResizeBottomRight = function(fm_panel, fm_enable) { fm_panel[? "resizeBottomRight"] = fm_enable; };
	
	/// @function PanelTitleGetCheck(fm_title : ds_map) -> boolean
	PanelTitleGetCheck = function(fm_title) {
		return fm_title[? "check"];
	};
	
	/// @function PanelTitleGetLock(fm_title : ds_map) -> boolean
	PanelTitleGetLock = function(fm_title) {
		return fm_title[? "lock"];
	};
	
	/// @function PanelGetPushWidth(fm_panel : ds_map) -> number
	PanelGetPushWidth = function(fm_panel) {
		return fm_panel[? "pushWidth"];
	};
	
	/// @function PanelTitleSetLock(fm_title : ds_map, fm_lock : boolean) -> undefined
	PanelTitleSetLock = function(fm_title, fm_lock) {
		fm_title[? "lock"] = fm_lock;
	};
	
	/// @function PanelTitleSetCheck(fm_title : ds_map, fm_check : boolean) -> undefined
	PanelTitleSetCheck = function(fm_title, fm_check) {
		fm_title[? "check"] = fm_check;
		fm_title[? "checkcheck"] = true;
		if (fm_title[? "OnClick"] != noone) {
			fm_title[? "OnClick"](fm_title);
		};
	};
	
	/// @function PanelSetPushWidth(fm_panel : ds_map, fm_width : number) -> undefined
	PanelSetPushWidth = function(fm_panel, fm_width) {
		fm_panel[? "pushWidth"] = fm_width;
	};
	
	/// @function PanelTitleToggle(fm_title : ds_map) -> undefined
	PanelTitleToggle = function(fm_title) {
		 PanelTitleSetCheck(fm_title, !PanelTitleGetCheck(fm_title));
	};
	
	__PanelFree_RecursiveDestroy = function(fm_elements) {
		if (!ds_exists(fm_elements, ds_type_list)) {
			return;
		};
		for (var i = 0; i < ds_list_size(fm_elements); i++) {
			var elements = fm_elements[| i][? "elements"];
			__PanelFree_RecursiveDestroy(elements);
		};
		ds_list_destroy(fm_elements);
	};
	
	/// @function PanelFree(fm_panel : ds_map) -> undefined
	PanelFree = function(fm_panel) {
		ds_stack_destroy(fm_panel[? "stack"]);
		
		for (var i = 0; i < ds_list_size(fm_panel[? "backup"]); i++) {
			__PanelFree_RecursiveDestroy(fm_panel[? "backup"][| i][? "elements"]);
		};
		ds_list_destroy(fm_panel[? "backup"]);
		
		for (var i = 0; i < ds_list_size(fm_panel[? "titleList"]); i++) {
			ds_list_destroy(fm_panel[? "titleList"][| i][? "responsibleElements"]);
		};
		ds_list_destroy(fm_panel[? "titleList"]);
		
		ds_list_destroy(fm_panel[? "titleStack"]);
	};
	
	/// @function PanelUpdate(fm_panel : ds_map) -> undefinedd}
	PanelUpdate = function(fm_panel) {
		fm_panel[? "lastY"] = 0;
		var lastPosY = 0;
		var highestPointX = 0;
		var highestPointY = 0;
		fm_panel[? "highestPointOnX"] = 0;
		fm_panel[? "highestPointOnY"] = 0;
		
		// take each line
		for (var i = 0; i < ds_list_size(fm_panel[? "backup"]); i++) {
			var line = fm_panel[? "backup"][| i];
			
			/* whats wrong with this ??
			var atLeastOne = false;
			for (var i = 0; i < ds_list_size(line[? "elements"]); i++) {
				if (line[? "elements"][| i][? "active"]) {
					atLeastOne = true;
					show_debug_message("a");
					break;
				};
			};
			if (!atLeastOne) {
				continue;
			};
			*/
				
				var qSize = ds_list_size(line[? "elements"]);
				
				if (qSize == 0) {
					continue;
				};
				fm_panel[? "lastY"] += fm_panel[? "gap"].y;
				// take each element
				var lastPosX = line[? "pushX"] * fm_panel[? "pushWidth"];
				var lastPosXa = 0;
				var highest = fm_panel[? "heighWide"];
				var lastOnVertical = 0;
				var autoFit = line[? "autoFit"];
				var placementTotal = line[? "placementTotal"];
				var isThereNonActive = 0;
				
				var existingList = ds_list_create();
				
				for (var j = 0; j < qSize; j++) {
					var element = line[? "elements"][| j];
					
					if (element[? "active"]) {
						ds_list_add(existingList, element);
					}
					else {
						isThereNonActive = 1;
						continue;
					};
					
					//highest = 0; // for some reason works better
					
					if (CanvasGetSize(element).y > highest) {
						highest = CanvasGetSize(element).y;
					};
					switch (CanvasGetAlignment(element).vertical) {
					case ALIGN.TOP: {
						lastOnVertical = max(0, lastOnVertical);
					} break;
					case ALIGN.MIDDLE: {
						lastOnVertical = max(0.5, lastOnVertical);
					} break;
					case ALIGN.BOTTOM: {
						lastOnVertical = max(1, lastOnVertical);
					} break;
					};
				};
				fm_panel[? "lastY"] -= fm_panel[? "gap"].y * isThereNonActive;
				qSize = ds_list_size(existingList);
				
				fm_panel[? "lastY"] += highest * lastOnVertical;
				
				for (var j = 0; j < qSize; j++) {
					var element = existingList[| j];
					
					if (!element[? "active"]) {
						continue;
					};
					
					if (!autoFit) {
						var gap = fm_panel[? "gap"].x;
						lastPosX += gap;
						//CanvasSetPosition(element, new Vector3(lastPosX, fm_panel[? "lastY"], 0));
						if (CanvasGetPosition(element) != undefined) {
							CanvasGetPosition(element).x = lastPosX;
							CanvasGetPosition(element).y = fm_panel[? "lastY"];
						}
						else {
							CanvasSetPosition(element, new Vector3(lastPosX, fm_panel[? "lastY"], 0));
						};
						lastPosX += CanvasGetSize(element).x;
					}
					else {
						// set pos and align
						var gap = fm_panel[? "gap"].x;
						var p = element[? "placement"] / placementTotal * CanvasGetSize(fm_panel).x - gap - gap;
						var px = p;
						if (element[? "autoFitScale"]) {
							// scale on x
							CanvasSetSize(element, new Vector2(p, CanvasGetSize(element).y));
						};
						if (ElementPropertyExists(element, "virtualContainerWidth")) {
							ElementSetProperty(element, p, "virtualContainerWidth");
						};
						switch (CanvasGetAlignment(element).horizontal) {
						case ALIGN.LEFT: {
							px = 0;
						} break;
						case ALIGN.CENTER: {
							px /= 2;
						} break;
						case ALIGN.RIGHT: {
							px = px;
						} break;
						};
					
						//CanvasSetPosition(element, new Vector3(lastPosXa + px + gap, 0, 0)); // pos x
						if (CanvasGetPosition(element) != undefined) {
							CanvasGetPosition(element).x = lastPosXa + px + gap;
							CanvasGetPosition(element).y = 0;
						}
						else {
							CanvasSetPosition(element, new Vector3(lastPosXa + px + gap, 0, 0)); // pos x
						};
						lastPosXa += element[? "placement"] / placementTotal * CanvasGetSize(fm_panel).x;
						
						if (element[? "autoFitScale"]) {
							//CanvasSetPosition(element, new Vector3(CanvasGetPosition(element).x, 0, 0)); // pos x
							if (CanvasGetPosition(element) != undefined) {
								CanvasGetPosition(element).y = 0;
							}
							else {
								CanvasSetPosition(element, new Vector3(CanvasGetPosition(element).x, 0, 0)); // pos x
							};
						};
						
						if (!fm_panel[? "autoFit"]) {
							//CanvasSetPosition(element, new Vector3(CanvasGetPosition(element).x, fm_panel[? "lastY"], 0)); // pos y
							if (CanvasGetPosition(element) != undefined) {
								CanvasGetPosition(element).y = fm_panel[? "lastY"];
							}
							else {
								CanvasSetPosition(element, new Vector3(CanvasGetPosition(element).x, fm_panel[? "lastY"], 0)); // pos y
							};
						};
					};
				};
				ds_list_destroy(existingList);
		
				if (!fm_panel[? "autoFit"] && qSize > 0) {
					fm_panel[? "lastY"] += highest * (1 - lastOnVertical);
					if (fm_panel[? "lastY"] > highestPointY) {
						highestPointY = fm_panel[? "lastY"];
					};
				};
				
				if (lastPosX > highestPointX) {
					highestPointX = lastPosX;
				};
				
				if (lastPosXa > highestPointX) {
					highestPointX = lastPosXa;
				};
			
			
			
			
			
			if (fm_panel[? "autoFit"]) {
				var placementTotal = fm_panel[? "placementTotal"];
				
				for (var j = 0; j < ds_list_size(line[? "elements"]); j++) { // elements
					var element = line[? "elements"][| j];
					
					// set pos and align
					var gap = fm_panel[? "gap"].y;
					var p = line[? "placement"] / placementTotal * (CanvasGetSize(fm_panel).y - gap - gap);
					var px = p;
					switch (CanvasGetAlignment(element).vertical) {
					case ALIGN.TOP: {
						px = 0;
					} break;
					case ALIGN.MIDDLE: {
						px /= 2;
					} break;
					case ALIGN.BOTTOM: {
						px = px;
					} break;
					};
					
					//CanvasSetPosition(element, new Vector3(CanvasGetPosition(element).x, lastPosY + px, 0)); // pos y
					if (CanvasGetPosition(element) != undefined) {
						CanvasGetPosition(element).y = lastPosY + px + gap;
					}
					else {
						CanvasSetPosition(element, new Vector3(CanvasGetPosition(element).x, lastPosY + px + gap, 0)); // pos y
					};
					
					if (element[? "autoFitScale"]) {
						// scale on y
						CanvasSetSize(element, new Vector2(CanvasGetSize(element).x, p));
					};
					if (ElementPropertyExists(element, "virtualContainerWidth")) {
						ElementSetProperty(element, p, "virtualContainerWidth");
					};
				};
				lastPosY += line[? "placement"] / placementTotal * CanvasGetSize(fm_panel).y;
				if (lastPosY > highestPointY) {
					highestPointY = element[? "pos"].y + element[? "size"].y;
				};
			};
			
			// update refreshed line
		};
		
		fm_panel[? "highestPointOnX"] = highestPointX;
		fm_panel[? "highestPointOnY"] = highestPointY;
		
		for (var i = 0; i < ds_list_size(fm_panel[? "elements"]); i++) {
			if (ds_map_exists(fm_panel[? "elements"][| i], "autoFit")) {
				PanelUpdate(fm_panel[? "elements"][| i]);
			};
		};
	};
	
	/// @function PanelRefresh(fm_panel : ds_map) -> undefined
	PanelRefresh = function(fm_panel) {
		// make sure every element in the backup still exists
		var dss = ds_list_size(fm_panel[? "backup"]);
		for (var i = 0; i < dss; i++) {
			var line = fm_panel[? "backup"][| i];
			
			// remove unexisting elements
			var dss1 = ds_list_size(line[? "elements"]);
			for (var j = 0; j < dss1; j++) {
				var element = line[? "elements"][| j];
				if (element == undefined) {
					ds_list_delete(line[? "elements"], j);
					j -= 1;
					dss1 -= 1;
					continue;
				};
				if (!ds_exists(element, ds_type_map)) {
					ds_list_delete(line[? "elements"], j);
					j -= 1;
				};
			};
			
			if (ds_list_size(line[? "elements"]) == 0) {
				ds_list_delete(fm_panel[? "backup"], i);
				i -= 1;
				dss -= 1;
				fm_panel[? "backupPos"] -= 1;
			};
		};
		
		// update
		PanelUpdate(fm_panel);
	};
	
	/// @function PanelPush(fm_panel : ds_map, title = "" : string, placement = 1 : number, autoFit = false : boolean, tdat = { onClick : undefined, s : new Vector2(82, 24) } : ds_map) -> ds_map
	PanelPush = function(fm_panel, fm_title = "", fm_placement = 1, fm_autoFit = false, __tdat = { onClick : undefined, s : new Vector2(82, 24) }) {
		var titleButton = noone;
		if (fm_title != "") {
			PanelPush(fm_panel, "", 1, true);
			titleButton = PanelElementCreate(
				fm_panel, 
				ButtonCreate(
					new Vector3(0, 0, 0), 
					fm_title, 
					fm_panel, 
					__tdat.onClick, 
					__tdat.s, 
					fm_panel[? "BeforeUpdateTitle"], 
					fm_panel[? "AfterUpdateTitle"], 
					fm_panel[? "BeforeDrawTitle"], 
					fm_panel[? "AfterDrawTitle"]
				), 
				undefined, 
				true, 
				new Align(ALIGN.CENTER, ALIGN.MIDDLE)
			);
			PanelPop(fm_panel);
			titleButton[? "check"] = true; // default
			titleButton[? "checkcheck"] = true;
			titleButton[? "line"] = noone;
			titleButton[? "responsibleElements"] = ds_list_create();
			ds_list_add(fm_panel[? "titleList"], titleButton);
		};
		
		fm_panel[? "pushX"] += 1;
		fm_panel[? "placementTotal"] += fm_placement;
		var newMap = ds_map_create();
		newMap[? "elements"] = ds_queue_create();
		newMap[? "autoFit"] = fm_autoFit;
		newMap[? "placementTotal"] = 0;
		newMap[? "placement"] = fm_placement;
		newMap[? "pushX"] = fm_panel[? "pushX"];
		newMap[? "title"] = titleButton;
		ds_stack_push(fm_panel[? "stack"], newMap);
		var bm = ds_map_create();
		bm[? "elements"] = ds_list_create();
		bm[? "autoFit"] = fm_autoFit;
		bm[? "placementTotal"] = 0;
		bm[? "placement"] = fm_placement;
		bm[? "pushX"] = fm_panel[? "pushX"];
		bm[? "title"] = titleButton;
		if (titleButton != noone) {
			titleButton[? "line"] = bm;
			ds_list_add(fm_panel[? "titleStack"], titleButton);
		};
		ds_list_add(fm_panel[? "backup"], bm);
		fm_panel[? "backupPos"] += 1;
		
		PanelUpdate(fm_panel);
		
		return titleButton;
	};
	
	/// @function PanelPop(fm_panel : ds_map) -> undefined
	PanelPop = function(fm_panel) {
		var map = ds_stack_pop(fm_panel[? "stack"]);
		var elements = map[? "elements"];
		var mapTitle = map[? "title"];
		var responsibleElements = undefined;
		
		if (ds_list_size(fm_panel[? "titleStack"]) > 0) {
			responsibleElements = fm_panel[? "titleStack"][| ds_list_size(fm_panel[? "titleStack"]) - 1][? "responsibleElements"];
		};
		
		if (mapTitle != noone) {
			//ds_list_destroy(fm_panel[? "titleStack"][| ds_list_size(fm_panel[? "titleStack"]) - 1][? "responsibleElements"]);
			ds_list_delete(fm_panel[? "titleStack"], ds_list_size(fm_panel[? "titleStack"]) - 1);
		};
		
		fm_panel[? "pushX"] -= 1;
		//fm_panel[? "backupPos"] -= 1;
		
		delete map[? "autoFit"];
		ds_queue_destroy(elements);
		ds_map_destroy(map);
		
		PanelUpdate(fm_panel);
		
		return responsibleElements;
	};
	
	/// @function PanelElementCreate(fm_panel : ds_map, fm_element : ds_map, placement = 1 : number, autoFit = false : boolean, align = new Align(ALIGN.LEFT, ALIGN.TOP) : Align) -> ds_map
	PanelElementCreate = function(fm_panel, fm_element, fm_placement = 1, fm_autoFit = false, fm_align = new Align(ALIGN.LEFT, ALIGN.TOP)) {
		var map = ds_stack_top(fm_panel[? "stack"]);
		fm_element[? "placement"] = fm_placement;
		fm_element[? "autoFitScale"] = fm_autoFit;
		CanvasSetAlignment(fm_element, fm_align);
		map[? "placementTotal"] += fm_placement;
		ds_queue_enqueue(map[? "elements"], fm_element);
		
		var bm = fm_panel[? "backup"][| fm_panel[? "backupPos"]];
		bm[? "placementTotal"] += fm_placement;
		ds_list_add(fm_panel[? "backup"][| fm_panel[? "backupPos"]][? "elements"], fm_element);
		
		if (ds_list_size(fm_panel[? "titleStack"]) > 0) {
			var title = fm_panel[? "titleStack"][| ds_list_size(fm_panel[? "titleStack"]) - 1]
			if (title != noone) {
				ds_list_add(title[? "responsibleElements"], fm_element); // title is a button
			};
		};
		
		return fm_element;
	};
	
	/// @function ScrollbarCreate(pos : Vector3, canvas : ds_map, size : Vector2, parent : ds_map, onUpdateBeforeBackground : function, onUpdateAfterBackground : function, onDrawBeforeBackground : function, onDrawAfterBackground : function, onUpdateBeforeAnchor : function, onUpdateAfterAnchor : function, onDrawBeforeAnchor : function, onDrawAfterAnchor : function) -> ds_map
	ScrollbarCreate = function
	(
		fm_pos, 
		fm_canvas, 
		fm_size, 
		fm_parent, 
		
		fm_onUpdateBeforeBackground, 
		fm_onUpdateAfterBackground, 
		fm_onDrawBeforeBackground, 
		fm_onDrawAfterBackground, 
		
		fm_onUpdateBeforeAnchor, 
		fm_onUpdateAfterAnchor, 
		fm_onDrawBeforeAnchor, 
		fm_onDrawAfterAnchor
	) 
	{
		var background = CanvasCreate(fm_pos, fm_size, new Vector4(0, 0, 0, 0), fm_parent);
		var anchor = CanvasCreate(new Vector3(fm_pos.x, fm_pos.y, fm_pos.z + 1), new Vector2(fm_size.x, fm_size.y), new Vector4(0, 0, 0, 0), fm_parent);
		
		// Background
		background[? "BeforeUpdate"] = fm_onUpdateBeforeBackground;
		background[? "AfterUpdate"] = fm_onUpdateAfterBackground;
		background[? "BeforeDraw"] = fm_onDrawBeforeBackground;
		background[? "AfterDraw"] = fm_onDrawAfterBackground;
		
		background[? "state"] = CLICKABLE_STATE.IDLE;
		
		background[? "FreeEx"] = ScrollbarFree;
		
		background[? "targetCanvas"] = fm_canvas;
		background[? "__anchor"] = anchor;
		
		// Anchor
		anchor[? "BeforeUpdate"] = fm_onUpdateBeforeAnchor;
		anchor[? "AfterUpdate"] = fm_onUpdateAfterAnchor;
		anchor[? "BeforeDraw"] = fm_onDrawBeforeAnchor;
		anchor[? "AfterDraw"] = fm_onDrawAfterAnchor;
		
		anchor[? "state"] = CLICKABLE_STATE.IDLE;
		
		//anchor[? "FreeEx"] = ScrollbarFree;
		
		anchor[? "targetCanvas"] = fm_canvas;
		anchor[? "__background"] = background;
		
		anchor[? "avg"] = 0;
		anchor[? "ori"] = 0;
		
		anchor[? "dragging"] = false;
		anchor[? "draggingStartPosMouse"] = 0;
		anchor[? "draggingStartPosAnchor"] = 0;
		
		anchor[? "lerpFactor"] = 1;
		anchor[? "targetPos"] = 0;
		
		return background;
	};
	
	/// @function ScrollbarVerticalCreate(pos : Vector3, canvas : ds_map, size : Vector2, parent = noone : ds_map, onUpdateBeforeBackground = STYLER_SCROLLBARVERTICALBACKGROUND_UPDATE_BEFORE : function, onUpdateAfterBackground = STYLER_SCROLLBARVERTICALBACKGROUND_UPDATE_AFTER : function, onDrawBeforeBackground = STYLER_SCROLLBARVERTICALBACKGROUND_DRAW_BEFORE : function, onDrawAfterBackground = STYLER_SCROLLBARVERTICALBACKGROUND_DRAW_AFTER : function, onUpdateBeforeAnchor = STYLER_SCROLLBARVERTICALANCHOR_UPDATE_BEFORE : function, onUpdateAfterAnchor = STYLER_SCROLLBARVERTICALANCHOR_UPDATE_AFTER : function, onDrawBeforeAnchor = STYLER_SCROLLBARVERTICALANCHOR_DRAW_BEFORE : function, onDrawAfterAnchor = STYLER_SCROLLBARVERTICALANCHOR_DRAW_AFTER : function) -> ds_map
	ScrollbarVerticalCreate = function
	(
		fm_pos, 
		fm_canvas, 
		fm_size, 
		fm_parent = noone, 
		
		fm_onUpdateBeforeBackground = STYLER_SCROLLBARVERTICALBACKGROUND_UPDATE_BEFORE, 
		fm_onUpdateAfterBackground = STYLER_SCROLLBARVERTICALBACKGROUND_UPDATE_AFTER, 
		fm_onDrawBeforeBackground = STYLER_SCROLLBARVERTICALBACKGROUND_DRAW_BEFORE, 
		fm_onDrawAfterBackground = STYLER_SCROLLBARVERTICALBACKGROUND_DRAW_AFTER, 
		
		fm_onUpdateBeforeAnchor = STYLER_SCROLLBARVERTICALANCHOR_UPDATE_BEFORE, 
		fm_onUpdateAfterAnchor = STYLER_SCROLLBARVERTICALANCHOR_UPDATE_AFTER, 
		fm_onDrawBeforeAnchor = STYLER_SCROLLBARVERTICALANCHOR_DRAW_BEFORE, 
		fm_onDrawAfterAnchor = STYLER_SCROLLBARVERTICALANCHOR_DRAW_AFTER
	) 
	{
		var scrollbar = ScrollbarCreate(
			fm_pos, 
			fm_canvas, 
			fm_size, 
			fm_parent, 
			
			STYLER_SCROLLBARVERTICALBACKGROUND_UPDATE_BEFORE, 
			STYLER_SCROLLBARVERTICALBACKGROUND_UPDATE_AFTER, 
			STYLER_SCROLLBARVERTICALBACKGROUND_DRAW_BEFORE, 
			STYLER_SCROLLBARVERTICALBACKGROUND_DRAW_AFTER, 
			
			STYLER_SCROLLBARVERTICALANCHOR_UPDATE_BEFORE, 
			STYLER_SCROLLBARVERTICALANCHOR_UPDATE_AFTER, 
			STYLER_SCROLLBARVERTICALANCHOR_DRAW_BEFORE, 
			STYLER_SCROLLBARVERTICALANCHOR_DRAW_AFTER
		);
		return scrollbar;
	};
	
	/// @function ScrollbarHorizontalCreate(pos : Vector3, canvas : ds_map, size : Vector2, parent = noone : ds_map, onUpdateBeforeBackground = STYLER_SCROLLBARHORIZONTALBACKGROUND_UPDATE_BEFORE : function, onUpdateAfterBackground = STYLER_SCROLLBARHORIZONTALBACKGROUND_UPDATE_AFTER : function, onDrawBeforeBackground = STYLER_SCROLLBARHORIZONTALBACKGROUND_DRAW_BEFORE : function, onDrawAfterBackground = STYLER_SCROLLBARHORIZONTALBACKGROUND_DRAW_AFTER : function, onUpdateBeforeAnchor = STYLER_SCROLLBARHORIZONTALANCHOR_UPDATE_BEFORE : function, onUpdateAfterAnchor = STYLER_SCROLLBARHORIZONTALANCHOR_UPDATE_AFTER : function, onDrawBeforeAnchor = STYLER_SCROLLBARHORIZONTALANCHOR_DRAW_BEFORE : function, onDrawAfterAnchor = STYLER_SCROLLBARHORIZONTALANCHOR_DRAW_AFTER : function) -> ds_map
	ScrollbarHorizontalCreate = function
	(
		fm_pos, 
		fm_canvas, 
		fm_size, 
		fm_parent = noone, 
		
		fm_onUpdateBeforeBackground = STYLER_SCROLLBARHORIZONTALBACKGROUND_UPDATE_BEFORE, 
		fm_onUpdateAfterBackground = STYLER_SCROLLBARHORIZONTALBACKGROUND_UPDATE_AFTER, 
		fm_onDrawBeforeBackground = STYLER_SCROLLBARHORIZONTALBACKGROUND_DRAW_BEFORE, 
		fm_onDrawAfterBackground = STYLER_SCROLLBARHORIZONTALBACKGROUND_DRAW_AFTER, 
		
		fm_onUpdateBeforeAnchor = STYLER_SCROLLBARHORIZONTALANCHOR_UPDATE_BEFORE, 
		fm_onUpdateAfterAnchor = STYLER_SCROLLBARHORIZONTALANCHOR_UPDATE_AFTER, 
		fm_onDrawBeforeAnchor = STYLER_SCROLLBARHORIZONTALANCHOR_DRAW_BEFORE, 
		fm_onDrawAfterAnchor = STYLER_SCROLLBARHORIZONTALANCHOR_DRAW_AFTER
	) 
	{
		var scrollbar = ScrollbarCreate(
			fm_pos, 
			fm_canvas, 
			fm_size, 
			fm_parent, 
			
			STYLER_SCROLLBARHORIZONTALBACKGROUND_UPDATE_BEFORE, 
			STYLER_SCROLLBARHORIZONTALBACKGROUND_UPDATE_AFTER, 
			STYLER_SCROLLBARHORIZONTALBACKGROUND_DRAW_BEFORE, 
			STYLER_SCROLLBARHORIZONTALBACKGROUND_DRAW_AFTER, 
			
			STYLER_SCROLLBARHORIZONTALANCHOR_UPDATE_BEFORE, 
			STYLER_SCROLLBARHORIZONTALANCHOR_UPDATE_AFTER, 
			STYLER_SCROLLBARHORIZONTALANCHOR_DRAW_BEFORE, 
			STYLER_SCROLLBARHORIZONTALANCHOR_DRAW_AFTER
		);
		return scrollbar;
	};
	
	ScrollbarFreeBackground = function(fm_element) {
	};
	
	ScrollbarFreeAnchor = function(fm_element) {
	};
	
	/// @function ScrollbarFree(fm_scrollbar : ds_map) -> undefined
	ScrollbarFree = function(fm_scrollbar) {
		ElementFree(fm_scrollbar[? "__anchor"]);
		//ScrollbarFreeBackground(fm_scrollbar);
		//ScrollbarFreeAnchor(fm_scrollbar[? "__anchor"]);
	};
	
	/// @function ScrollbarScrollUp(fm_scrollbar : ds_map, fm_steps : number) -> undefined
	ScrollbarScrollUp = function(fm_scrollbar, fm_steps) {
		fm_scrollbar[? "__anchor"][? "targetPos"] -= fm_steps / CanvasGetSize(fm_scrollbar[? "targetCanvas"]).y;
	};
	
	/// @function ScrollbarScrollDown(fm_scrollbar : ds_map, fm_steps : number) -> undefined
	ScrollbarScrollDown = function(fm_scrollbar, fm_steps) {
		fm_scrollbar[? "__anchor"][? "targetPos"] += fm_steps / CanvasGetSize(fm_scrollbar[? "targetCanvas"]).y;
	};
	
	/// @function ScrollbarScrollLeft(fm_scrollbar : ds_map, fm_steps : number) -> undefined
	ScrollbarScrollLeft = function(fm_scrollbar, fm_steps) {
		fm_scrollbar[? "__anchor"][? "targetPos"] -= fm_steps / CanvasGetSize(fm_scrollbar[? "targetCanvas"]).x;
	};
	
	/// @function ScrollbarScrollRight(fm_scrollbar : ds_map, fm_steps : number) -> undefined
	ScrollbarScrollRight = function(fm_scrollbar, fm_steps) {
		fm_scrollbar[? "__anchor"][? "targetPos"] += fm_steps / CanvasGetSize(fm_scrollbar[? "targetCanvas"]).x;
	};
	
	/// @function ScrollbarGetAnchor(fm_scrollbar : ds_map) -> ds_map
	ScrollbarGetAnchor = function(fm_scrollbar) {
		return fm_scrollbar[? "__anchor"];
	};
	
	/// @function ScrollbarGetOrientation(fm_scrollbar : ds_map) -> number
	ScrollbarGetOrientation = function(fm_scrollbar) {
		return fm_scrollbar[? "__anchor"][? "ori"];
	};
	
	/// @function ScrollbarGetLerpFactor(fm_scrollbar : ds_map, fm_val : number) -> number
	ScrollbarGetLerpFactor = function(fm_scrollbar, fm_val) {
		return fm_scrollbar[? "__anchor"][? "lerpFactor"];
	};
	
	/// @function ScrollbarGetTargetPos(fm_scrollbar : ds_map) -> number
	ScrollbarGetTargetPos = function(fm_scrollbar) {
		return fm_scrollbar[? "__anchor"][? "targetPos"];
	};
	
	/// @function ScrollbarSetOrientation(fm_scrollbar : ds_map, fm_ori : number) -> undefined
	ScrollbarSetOrientation = function(fm_scrollbar, fm_ori) {
		fm_scrollbar[? "__anchor"][? "ori"] = fm_ori;
	};
	
	/// @function ScrollbarSetLerpFactor(fm_scrollbar : ds_map, fm_val : number) -> undefined
	ScrollbarSetLerpFactor = function(fm_scrollbar, fm_val) {
		fm_scrollbar[? "__anchor"][? "lerpFactor"] = fm_val;
	};
	
	/// @function ScrollbarSetTargetPos(fm_scrollbar : ds_map, fm_targetPos : number) -> undefined
	ScrollbarSetTargetPos = function(fm_scrollbar, fm_targetPos) {
		fm_scrollbar[? "__anchor"][? "targetPos"] = fm_targetPos;
	};
	
	// Textbox Methods [[DEPRECATED]]
	TextboxDpCreate = function
	(
		fm_pos, 
		fm_size = new Vector2(200, 28), 
		fm_parent = noone, 
		fm_containerGap = new Vector2(2, 2), 
		fm_lineGap = new Vector2(2, 2), 
		fm_pointColor = new Vector4(255, 255, 255, 255), 
		
		fm_onUpdateBeforeTextbox = STYLER_TEXTBOXDP_UPDATE_BEFORE, 
		fm_onUpdateAfterTextbox = STYLER_TEXTBOXDP_UPDATE_AFTER, 
		fm_onDrawBeforeTextbox = STYLER_TEXTBOXDP_DRAW_BEFORE, 
		fm_onDrawAfterTextbox = STYLER_TEXTBOXDP_DRAW_AFTER, 
		
		fm_onUpdateBeforeContainer = STYLER_TEXTBOXDPCONTAINER_UPDATE_BEFORE, 
		fm_onUpdateAfterContainer = STYLER_TEXTBOXDPCONTAINER_UPDATE_AFTER, 
		fm_onDrawBeforeContainer = STYLER_TEXTBOXDPCONTAINER_DRAW_BEFORE, 
		fm_onDrawAfterContainer = STYLER_TEXTBOXDPCONTAINER_DRAW_AFTER
	) 
	{
		var textbox = CanvasCreate(fm_pos, fm_size, new Vector4(0, 0, 0, 0), fm_parent);
		var container = CanvasCreate(new Vector3(fm_containerGap.x, fm_containerGap.y, 1), new Vector2(fm_size.x - fm_containerGap.x * 2, fm_size.y - fm_containerGap.y * 2), new Vector4(0, 0, 0, 0), textbox);
		
		ButtonSetState(textbox, CLICKABLE_STATE.IDLE);
		textbox[? "BeforeUpdate"] = fm_onUpdateBeforeTextbox;
		textbox[? "AfterUpdate"] = fm_onUpdateAfterTextbox;
		textbox[? "BeforeDraw"] = fm_onDrawBeforeTextbox;
		textbox[? "AfterDraw"] = fm_onDrawAfterTextbox;
		textbox[? "container"] = container;
		textbox[? "FreeEx"] = TextboxDpFree;
		textbox[? "containerGap"] = fm_containerGap;
		
		ButtonSetState(container, CLICKABLE_STATE.IDLE);
		container[? "BeforeUpdate"] = fm_onUpdateBeforeContainer;
		container[? "AfterUpdate"] = fm_onUpdateAfterContainer;
		container[? "BeforeDraw"] = fm_onDrawBeforeContainer;
		container[? "AfterDraw"] = fm_onDrawAfterContainer;
		container[? "textbox"] = textbox;
		container[? "lineGap"] = fm_lineGap;
		
		container[? "point"] = ds_map_create();
		container[? "point"][? "lineIndex"] = 0;
		container[? "point"][? "charIndex"] = 0;
		container[? "point"][? "timer"] = 0;
		container[? "point"][? "color"] = fm_pointColor;
		container[? "point"][? "fade"] = 0.5;
		
		container[? "point1"] = ds_map_create();
		container[? "point1"][? "lineIndex"] = 0;
		container[? "point1"][? "charIndex"] = 0;
		
		container[? "ghostText"] = "";
		container[? "ghostTextColor"] = new Vector4(128, 128, 128, 255);
		
		container[? "line"] = TextboxDpAddLine(textbox, "");
		
		return textbox;
	};
	
	TextboxDpFree = function(fm_textbox) {
		delete fm_textbox[? "container"][? "point"][? "color"];
		delete fm_textbox[? "container"][? "ghostTextColor"];
		ds_map_destroy(fm_textbox[? "container"][? "point"]);
		ds_map_destroy(fm_textbox[? "container"][? "point1"]);
	};
	
	TextboxDpUpdate = function(fm_textbox) {
		var textbox = fm_textbox;
		var container = textbox[? "container"];
		
		var containerGap = textbox[? "containerGap"];
		var lineGap = container[? "lineGap"];
		
		var lines = CanvasGetElements(container);
		var lSize = ds_list_size(lines);
		for (var i = 0; i < lSize; i++) {
			var line = lines[| i];
			var pos = CanvasGetPosition(line);
			CanvasSetPosition(line, new Vector3(lineGap.x, lineGap.y + CanvasGetSize(line).y * i + lineGap.y * i, pos.z));
		};
	};
	
	TextboxDpAddLine = function(fm_textbox, fm_text) {
		var line = LabelCreate(new Vector3(0, 0, CanvasGetElementSize(fm_textbox[? "container"])), fm_text, fm_textbox[? "container"]);
		TextboxDpUpdate(fm_textbox);
		return line;
	};
	
	TextboxDpGetContainer = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "container");
	};
	
	TextboxDpGetLine = function(fm_textbox) {
		return ElementGetProperty(TextboxDpGetContainer(fm_textbox), "line");
	};
	
	TextboxDpGetText = function(fm_textbox) {
		return LabelGetText(TextboxDpGetLine(fm_textbox));
	};
	
	TextboxDpGetPassword = function(fm_textbox) {
		return LabelGetPassword(CanvasGetElement(CanvasGetElement(fm_textbox, 0), 0));
	};
	
	TextboxDpGetPasswordCharacter =  function(fm_textbox) {
		return LabelGetPasswordCharacter(CanvasGetElement(CanvasGetElement(fm_textbox, 0), 0));
	};
	
	TextboxDpSetText = function(fm_textbox, fm_text) {
		LabelSetText(fm_textbox[? "container"][? "elements"][| 0], fm_text);
	};
	
	TextboxDpSetTextColor = function(fm_textbox, fm_color) {
		LabelSetColor(fm_textbox[? "container"][? "elements"][| 0], fm_color);
	};
	
	TextboxDpSetGhostText = function(fm_textbox, fm_text) {
		fm_textbox[? "container"][? "ghostText"] = fm_text;
	};
	
	TextboxDpSetPassword = function(fm_textbox, fm_enable) {
		LabelSetPassword(CanvasGetElement(CanvasGetElement(fm_textbox, 0), 0), fm_enable);
	};
	
	TextboxDpSetPasswordCharacter = function(fm_textbox, fm_character) {
		LabelSetPasswordCharacter(CanvasGetElement(CanvasGetElement(fm_textbox, 0), 0), fm_character);
	};
	
	/// @function SelectableCreate(pos : Vector3, name : string, parent = noone : ds_map, size = new Vector2(128, 24) : Vector2, onClick = noone : function, onUpdateBefore = STYLER_SELECTABLE_UPDATE_BEFORE : function, onUpdateAfter = STYLER_SELECTABLE_UPDATE_AFTER : function, onDrawBefore = STYLER_SELECTABLE_DRAW_BEFORE : function, onDrawAfter = STYLER_SELECTABLE_DRAW_AFTER : function) -> ds_map
	SelectableCreate = function
	(
		fm_pos, 
		fm_name, 
		fm_parent = noone, 
		fm_size = new Vector2(128, 24), 
		fm_onClick = noone, 
		fm_onUpdateBefore	=	STYLER_SELECTABLE_UPDATE_BEFORE, 
		fm_onUpdateAfter	=	STYLER_SELECTABLE_UPDATE_AFTER, 
		fm_onDrawBefore		=	STYLER_SELECTABLE_DRAW_BEFORE, 
		fm_onDrawAfter		=	STYLER_SELECTABLE_DRAW_AFTER
	) 
	{
		var selectable = CheckboxCreate(
			fm_pos, 
			fm_parent, 
			fm_size, 
			fm_onClick, 
			fm_onUpdateBefore, 
			fm_onUpdateAfter, 
			fm_onDrawBefore, 
			fm_onDrawAfter
		);
		
		ElementSetProperty(selectable, fm_name, "name");
		ElementSetProperty(selectable, m_font, "font");
		ElementSetProperty(selectable, -1, "doubleClickTimer");
		ElementSetProperty(selectable, new Vector2(-1, -1), "lastClickPos");
		ElementSetProperty(selectable, noone, "doubleClickAction");
		
		return selectable;
	};
	
	/// @function SelectableFree(fm_selectable : ds_map) -> undefined
	SelectableFree = function(fm_selectable) {
	};
	
	/// @function SelectableGetName(fm_selectable : ds_map) -> string
	SelectableGetName = function(fm_selectable) {
		return ElementGetProperty(fm_selectable, "name");
	};
	
	/// @function SelectableGetFont(fm_selectable : ds_map) -> font
	SelectableGetFont = function(fm_selectable) {
		return ElementGetProperty(fm_selectable, "font");
	};
	
	/// @function SelectableGetDoubleClickAction(fm_selectable : ds_map) -> functionn
	SelectableGetDoubleClickAction = function(fm_selectable) {
		return ElementGetProperty(fm_selectable, "doubleClickAction");
	};
	
	/// @function SelectableSetName(fm_selectable : ds_map, fm_name : string) -> undefined
	SelectableSetName = function(fm_selectable, fm_name) {
		ElementSetProperty(fm_selectable, fm_name, "name");
	};
	
	/// @function SelectableSetFont(fm_selectable : ds_map, fm_font : font) -> undefined
	SelectableSetFont = function(fm_selectable, fm_font) {
		ElementSetProperty(fm_selectable, fm_font, "font");
	};
	
	/// @function SelectableSetDoubleClickAction(fm_selectable : ds_map, fm_action : function) -> undefined
	SelectableSetDoubleClickAction = function(fm_selectable, fm_action) {
		ElementSetProperty(fm_selectable, fm_action, "doubleClickAction");
	};
	
	/// @function MenuCreate(onUpdateBeforePanel = STYLER_MENUPANEL_UPDATE_BEFORE : function, onUpdateAfterPanel = STYLER_MENUPANEL_UPDATE_AFTER : function, onDrawBeforePanel = STYLER_MENUPANEL_DRAW_BEFORE : function, onDrawAfterPanel = STYLER_MENUPANEL_DRAW_AFTER : function, onUpdateBeforeItem = STYLER_MENUITEM_UPDATE_BEFORE : function, onUpdateAfterItem = STYLER_MENUITEM_UPDATE_AFTER : function, onDrawBeforeItem = STYLER_MENUITEM_DRAW_BEFORE : function, onDrawAfterItem = STYLER_MENUITEM_DRAW_AFTER : function, onUpdateBeforeSeparator = STYLER_MENUSEPARATOR_UPDATE_BEFORE : function, onUpdateAfterSeparator = STYLER_MENUSEPARATOR_UPDATE_AFTER : function, onDrawBeforeSeparator = STYLER_MENUSEPARATOR_DRAW_BEFORE : function, onDrawAfterSeparator = STYLER_MENUSEPARATOR_DRAW_AFTER : function, onUpdateBeforeTab = STYLER_MENUTAB_UPDATE_BEFORE : function, onUpdateAfterTab = STYLER_MENUTAB_UPDATE_AFTER : function, onDrawBeforeTab = STYLER_MENUTAB_DRAW_BEFORE : function, onDrawAfterTab = STYLER_MENUTAB_DRAW_AFTER : function) -> array
	MenuCreate = function
	(
		fm_onUpdateBeforePanel					=		STYLER_MENUPANEL_UPDATE_BEFORE, 
		fm_onUpdateAfterPanel					=		STYLER_MENUPANEL_UPDATE_AFTER, 
		fm_onDrawBeforePanel					=		STYLER_MENUPANEL_DRAW_BEFORE, 
		fm_onDrawAfterPanel						=		STYLER_MENUPANEL_DRAW_AFTER, 
														
		fm_onUpdateBeforeItem					=		STYLER_MENUITEM_UPDATE_BEFORE, 
		fm_onUpdateAfterItem					=		STYLER_MENUITEM_UPDATE_AFTER, 
		fm_onDrawBeforeItem						=		STYLER_MENUITEM_DRAW_BEFORE, 
		fm_onDrawAfterItem						=		STYLER_MENUITEM_DRAW_AFTER, 
														
		fm_onUpdateBeforeSeparator				=		STYLER_MENUSEPARATOR_UPDATE_BEFORE, 
		fm_onUpdateAfterSeparator				=		STYLER_MENUSEPARATOR_UPDATE_AFTER, 
		fm_onDrawBeforeSeparator				=		STYLER_MENUSEPARATOR_DRAW_BEFORE, 
		fm_onDrawAfterSeparator					=		STYLER_MENUSEPARATOR_DRAW_AFTER, 
														
		fm_onUpdateBeforeTab					=		STYLER_MENUTAB_UPDATE_BEFORE, 
		fm_onUpdateAfterTab						=		STYLER_MENUTAB_UPDATE_AFTER, 
		fm_onDrawBeforeTab						=		STYLER_MENUTAB_DRAW_BEFORE, 
		fm_onDrawAfterTab						=		STYLER_MENUTAB_DRAW_AFTER
	) 
	{
		var menu = [ ds_map_create(), ds_list_create(), ds_list_create() ]; // [ data, menus ]
		
		menu[0][? "onUpdateBeforePanel"]		=		fm_onUpdateBeforePanel;
		menu[0][? "onUpdateAfterPanel"]			=		fm_onUpdateAfterPanel;
		menu[0][? "onDrawBeforePanel"]			=		fm_onDrawBeforePanel;
		menu[0][? "onDrawAfterPanel"]			=		fm_onDrawAfterPanel;
													
		menu[0][? "onUpdateBeforeItem"]			=		fm_onUpdateBeforeItem;
		menu[0][? "onUpdateAfterItem"]			=		fm_onUpdateAfterItem;
		menu[0][? "onDrawBeforeItem"]			=		fm_onDrawBeforeItem;
		menu[0][? "onDrawAfterItem"]			=		fm_onDrawAfterItem;
													
		menu[0][? "onUpdateBeforeCheckbox"]		=		STYLER_MENUCHECKBOX_UPDATE_BEFORE;
		menu[0][? "onUpdateAfterCheckbox"]		=		STYLER_MENUCHECKBOX_UPDATE_AFTER;
		menu[0][? "onDrawBeforeCheckbox"]		=		STYLER_MENUCHECKBOX_DRAW_BEFORE;
		menu[0][? "onDrawAfterCheckbox"]		=		STYLER_MENUCHECKBOX_DRAW_AFTER;
												
		menu[0][? "onUpdateBeforeSeparator"]	=		fm_onUpdateBeforeSeparator;
		menu[0][? "onUpdateAfterSeparator"]		=		fm_onUpdateAfterSeparator;
		menu[0][? "onDrawBeforeSeparator"]		=		fm_onDrawBeforeSeparator;
		menu[0][? "onDrawAfterSeparator"]		=		fm_onDrawAfterSeparator;
												
		menu[0][? "onUpdateBeforeTab"]			=		fm_onUpdateBeforeTab;
		menu[0][? "onUpdateAfterTab"]			=		fm_onUpdateAfterTab;
		menu[0][? "onDrawBeforeTab"]			=		fm_onDrawBeforeTab;
		menu[0][? "onDrawAfterTab"]				=		fm_onDrawAfterTab;
		
		menu[0][? "pushPos"]					=		-1;
		menu[0][? "font"]						=		m_font;
		
		menu[0][? "avoidclick"]					=		-1;
		
		return menu;
	};
	
	/// @function MenuFree(fm_menu : array) -> undefined
	MenuFree = function(fm_menu) {
		ds_list_destroy(fm_menu[2]);
		ds_list_destroy(fm_menu[1]);
		ds_map_destroy(fm_menu[0]);
	};
	
	/// @function MenuGetFont(fm_menu : array) -> font
	MenuGetFont = function(fm_menu) {
		return fm_menu[0][? "font"];
	};
	
	/// @function MenuSetFont(fm_menu : array, fm_font : font) -> undefined
	MenuSetFont = function(fm_menu, fm_font) {
		fm_menu[0][? "font"] = fm_font;
	};
	
	/// @function MenuShow(fm_menu : array, loc : Vector2) -> boolean
	MenuShow = function(fm_menu, fm_loc) {
		if (fm_menu[0][? "avoidclick"] == 0) {
			return false;
		};
		fm_menu[0][? "avoidclick"] = 0;
		CanvasActivate(fm_menu[1][| 0]);
		CanvasGetPosition(fm_menu[1][| 0]).x = fm_loc.x;
		CanvasGetPosition(fm_menu[1][| 0]).y = fm_loc.y;
		return true;
	};
	
	/// @function MenuHide(fm_menu : array) -> undefined
	MenuHide = function(fm_menu) {
		MenuPageSetSelected__RecursiveFunctionToClose(fm_menu[1][| 0]);
		fm_menu[0][? "avoidclick"] = -1;
	};
	
	/// @function MenuUpdateMouse(fm_menu : array) -> undefined
	MenuUpdateMouse = function(fm_menu) {
		if (fm_menu[0][? "avoidclick"] == -1) {
			return;
		};
		
		if (mouse_check_button_pressed(mb_left) && fm_menu[0][? "avoidclick"] == 0) {
			MenuHide(fm_menu);
		};
		
		if (fm_menu[0][? "avoidclick"] == 1) {
			fm_menu[0][? "avoidclick"] = 0;
		};
	};
	
	/// @function MenuPush(fm_menu : array, title = "" : string, infoText = "" : string, icon16x16 = noone : sprite, visibleElementCount = 12 : number) -> ds_map
	MenuPush = function(fm_menu, fm_title = "", fm_infoText = "", fm_icon16x16 = noone, fm_visibleElementCount = 12) { // { 5+5+3+3+16+3+3+48+64=150, 5+5+12*24=298 }
		var ret = noone;
		
		if (ds_list_size(fm_menu[2]) == 0) { // main panel
			ret = MenuPageCreate(fm_menu, new Vector2(5 + 24 + 180 + 3 + 100 + 5, 5 + fm_visibleElementCount * 24 + fm_visibleElementCount * 4 - 4 + 5));
		}
		else { // sub panel
			ret = MenuPageCreate(fm_menu, new Vector2(5 + 24 + 180 + 3 + 100 + 5, 5 + fm_visibleElementCount * 24 + fm_visibleElementCount * 4 - 4 + 5));
			MenuTab(fm_menu, ret, fm_title, fm_infoText, fm_icon16x16);
		};
		
		CanvasDeactivate(ret);
		ds_list_add(fm_menu[2], ret);
		
		return ret;
	};
	
	/// @function MenuPop(fm_menu : array) -> undefined
	MenuPop = function(fm_menu) {
		ds_list_delete(fm_menu[2], ds_list_size(fm_menu[2]) - 1);
	};
	
	/// @function MenuItem(fm_menu : array, title : string, infoText = "" : string, icon16x16 = noone : sprite, onClick = noone : function) -> ds_map
	MenuItem = function(fm_menu, fm_title, fm_infoText = "", fm_icon16x16 = noone, fm_onClick = noone) {
		var pagePanel = CanvasGetElement(fm_menu[2][| ds_list_size(fm_menu[2]) - 1], 0);
		PanelPush(pagePanel, undefined, undefined, true);
			var item = PanelElementCreate(
				pagePanel, 
				CanvasCreate(
					new Vector3(0, 0, 0), 
					new Vector2(1, 24), 
					new Vector4(0, 0, 0, 0), 
					pagePanel
				), 
				undefined, 
				true
			);
		PanelPop(pagePanel);
		
		ButtonSetState(item, CLICKABLE_STATE.IDLE);
		
		ElementSetProperty(item, fm_title, "text");
		ElementSetProperty(item, fm_infoText, "m_infoText");
		ElementSetProperty(item, fm_icon16x16, "m_icon16x16");
		ElementSetProperty(item, fm_menu[0][? "font"], "font");
		ElementSetProperty(item, fm_onClick, "OnClick");
		
		ElementSetProperty(item, fm_menu[2][| ds_list_size(fm_menu[2]) - 1], "m_page");
		
		ElementSetProperty(item, fm_menu[0][? "onUpdateBeforeItem"], "BeforeUpdate");
		ElementSetProperty(item, fm_menu[0][? "onUpdateAfterItem"], "AfterUpdate");
		ElementSetProperty(item, fm_menu[0][? "onDrawBeforeItem"], "BeforeDraw");
		ElementSetProperty(item, fm_menu[0][? "onDrawAfterItem"], "AfterDraw");
		
		return item;
	};
	
	/// @function MenuCheckbox(fm_menu : array, title : string, infoText = "" : string, onClick = noone : function) -> ds_map
	MenuCheckbox = function(fm_menu, fm_title, fm_infoText = "", fm_onClick = noone) {
		var pagePanel = CanvasGetElement(fm_menu[2][| ds_list_size(fm_menu[2]) - 1], 0);
		PanelPush(pagePanel, undefined, undefined, true);
			var item = PanelElementCreate(
				pagePanel, 
				CanvasCreate(
					new Vector3(0, 0, 0), 
					new Vector2(1, 24), 
					new Vector4(0, 0, 0, 0), 
					pagePanel
				), 
				undefined, 
				true
			);
		PanelPop(pagePanel);
		
		ButtonSetState(item, CLICKABLE_STATE.IDLE);
		
		ElementSetProperty(item, fm_title, "text");
		ElementSetProperty(item, fm_infoText, "m_infoText");
		ElementSetProperty(item, false, "check");
		ElementSetProperty(item, fm_menu[0][? "font"], "font");
		ElementSetProperty(item, fm_onClick, "OnClick");
		
		ElementSetProperty(item, fm_menu[2][| ds_list_size(fm_menu[2]) - 1], "m_page");
		
		ElementSetProperty(item, fm_menu[0][? "onUpdateBeforeCheckbox"], "BeforeUpdate");
		ElementSetProperty(item, fm_menu[0][? "onUpdateAfterCheckbox"], "AfterUpdate");
		ElementSetProperty(item, fm_menu[0][? "onDrawBeforeCheckbox"], "BeforeDraw");
		ElementSetProperty(item, fm_menu[0][? "onDrawAfterCheckbox"], "AfterDraw");
		
		return item;
	};
	
	/// @function MenuSeparator(fm_menu : array, title = "" : string) -> ds_map
	MenuSeparator = function(fm_menu, fm_title = "") {
		var pagePanel = CanvasGetElement(fm_menu[2][| ds_list_size(fm_menu[2]) - 1], 0);
		PanelPush(pagePanel, undefined, undefined, true);
			var item = PanelElementCreate(
				pagePanel, 
				CanvasCreate(
					new Vector3(0, 0, 0), 
					new Vector2(1, 24), 
					new Vector4(0, 0, 0, 0), 
					pagePanel
				), 
				undefined, 
				true
			);
		PanelPop(pagePanel);
		
		ButtonSetState(item, CLICKABLE_STATE.IDLE);
		
		ElementSetProperty(item, fm_title, "text");
		ElementSetProperty(item, fm_menu[0][? "font"], "font");
		
		ElementSetProperty(item, fm_menu[2][| ds_list_size(fm_menu[2]) - 1], "m_page");
		
		ElementSetProperty(item, fm_menu[0][? "onUpdateBeforeSeparator"], "BeforeUpdate");
		ElementSetProperty(item, fm_menu[0][? "onUpdateAfterSeparator"], "AfterUpdate");
		ElementSetProperty(item, fm_menu[0][? "onDrawBeforeSeparator"], "BeforeDraw");
		ElementSetProperty(item, fm_menu[0][? "onDrawAfterSeparator"], "AfterDraw");
		
		return item;
	};
	
	/// @function MenuTab(fm_menu : array, targetPage : ds_map, title : string, infoText = "" : string, icon16x16 = noone : sprite, onClick = noone : function) -> ds_map
	MenuTab = function(fm_menu, fm_targetPage, fm_title, fm_infoText = "", fm_icon16x16 = noone, fm_onClick = noone) {
		var pagePanel = CanvasGetElement(fm_menu[2][| ds_list_size(fm_menu[2]) - 1], 0);
		PanelPush(pagePanel, undefined, undefined, true);
			var item = PanelElementCreate(
				pagePanel, 
				CanvasCreate(
					new Vector3(0, 0, 0), 
					new Vector2(1, 24), 
					new Vector4(0, 0, 0, 0), 
					pagePanel
				), 
				undefined, 
				true
			);
		PanelPop(pagePanel);
		
		ButtonSetState(item, CLICKABLE_STATE.IDLE);
		
		ElementSetProperty(item, fm_title, "text");
		ElementSetProperty(item, fm_infoText, "m_infoText");
		ElementSetProperty(item, fm_icon16x16, "m_icon16x16");
		ElementSetProperty(item, fm_menu[0][? "font"], "font");
		ElementSetProperty(item, fm_onClick, "OnClick");
		
		ElementSetProperty(item, false, "check");
		ElementSetProperty(item, fm_menu[2][| ds_list_size(fm_menu[2]) - 1], "m_page");
		ElementSetProperty(item, fm_targetPage, "m_targetPage");
		
		ElementSetProperty(item, fm_menu[0][? "onUpdateBeforeTab"], "BeforeUpdate");
		ElementSetProperty(item, fm_menu[0][? "onUpdateAfterTab"], "AfterUpdate");
		ElementSetProperty(item, fm_menu[0][? "onDrawBeforeTab"], "BeforeDraw");
		ElementSetProperty(item, fm_menu[0][? "onDrawAfterTab"], "AfterDraw");
		
		return item;
	};
	
	/// @function MenuPageGetSelected(fm_page : ds_map) -> ds_map
	MenuPageGetSelected = function(fm_page) {
		return ElementGetProperty(fm_page, "m_selected")
	};
	
	MenuPageSetSelected__RecursiveFunctionToClose = function(fm_targetPage) {
		var tp_selected = MenuPageGetSelected(fm_targetPage);
		if (tp_selected != noone) {
			MenuPageSetSelected__RecursiveFunctionToClose(ElementGetProperty(tp_selected, "m_targetPage"));
			MenuPageSetSelected(fm_targetPage, noone);
		};
		CanvasDeactivate(fm_targetPage);
	};
	
	/// @function MenuPageSetSelected(fm_page : ds_map, fm_element : ds_map) -> undefined
	MenuPageSetSelected = function(fm_page, fm_element) {
		var selected = MenuPageGetSelected(fm_page);
		
		// if same is clicked, close it(for now, just ignore it)
		if (selected == fm_element) {
			MenuPageSetSelected__RecursiveFunctionToClose(ElementGetProperty(selected, "m_targetPage"));
			CheckboxSetCheck(selected, false);
			ElementSetProperty(fm_page, noone, "m_selected");
			return;
		};
		
		// close the selected
		if (selected != noone) {
			MenuPageSetSelected__RecursiveFunctionToClose(ElementGetProperty(selected, "m_targetPage"));
			CheckboxSetCheck(selected, false);
		};
		
		// set the element as selected
		ElementSetProperty(fm_page, fm_element, "m_selected");
		selected = fm_element;
		
		// open the selected
		if (selected != noone) {
			CanvasActivate(ElementGetProperty(selected, "m_targetPage"));
			CanvasGetPosition(ElementGetProperty(selected, "m_targetPage")).x = CanvasGetPosition(fm_page).x + CanvasGetSize(fm_page).x;
			CanvasGetPosition(ElementGetProperty(selected, "m_targetPage")).y = CanvasGetPosition(fm_page).y + 5 + CanvasGetPosition(selected).y;
			CheckboxSetCheck(selected, true);
		};
	};
	
	MenuPageCreate = function
	(
		fm_menu, 
		fm_size
	) 
	{
		var page = CanvasCreate(new Vector3(0, 0, 9999), fm_size, new Vector4(16, 16, 16, 255));
		ElementSetProperty(page, fm_menu, "m_menu");
		ElementSetProperty(page, noone, "m_selected");
		CanvasSetBeforeUpdate(page, STYLER_MENUCANVAS_UPDATE_BEFORE);
		CanvasSetAfterUpdate(page, STYLER_MENUCANVAS_UPDATE_AFTER);
		CanvasSetBeforeDraw(page, STYLER_MENUCANVAS_DRAW_BEFORE);
		CanvasSetAfterDraw(page, STYLER_MENUCANVAS_DRAW_AFTER);
		
		var panel = PanelCreate(
			new Vector3(5, 5, 0), 
			new Vector2(0, 0), 
			undefined, 
			page, 
			undefined, 
			new Vector2(fm_size.x - 10, fm_size.y - 10), 
			undefined, 
			fm_menu[0][? "onUpdateBeforePanel"], 
			fm_menu[0][? "onUpdateAfterPanel"], 
			fm_menu[0][? "onDrawBeforePanel"], 
			fm_menu[0][? "onDrawAfterPanel"]
		);
		ElementSetProperty(panel, fm_menu, "m_menu");
		
		var scrollbarWidth = 5;
		var scrollbarRightGap = 3;
		var scrollbar = ScrollbarVerticalCreate(new Vector3(fm_size.x - scrollbarWidth - scrollbarRightGap, 3, 100), panel, new Vector2(scrollbarWidth, fm_size.y - 3 * 2), page);
		ElementSetProperty(panel, scrollbar, "m_scrollbarVertical");
		ElementSetProperty(panel, 2000, "m_scrollbarVerticalSteps");
		
		ds_list_add(fm_menu[1], page);
		return page;
	};
	
	MenuPageFree = function() {
	};
	
	/// @function TextboxCreate(pos : Vector3, size = new Vector2(200, 28) : Vector2, parent = noone : ds_map, scrollbarWidth = 4 : number, scrollbarGap = 2 : number, scrollbarGapSide = 2 : number) -> ds_map
	TextboxCreate = function
	(
		fm_pos, 
		fm_size = new Vector2(200, 28), 
		fm_parent = noone, 
		fm_scrollbarWidth = 4, 
		fm_scrollbarGap = 2, 
		fm_scrollbarGapSide = 2,
		fm_lineLimit = 8,
	) 
	{
		if (fm_pos == undefined) { fm_pos = new Vector3(0, 0, 0); };
		if (fm_size == undefined) { fm_size = new Vector2(1, 1); };
		
		var textbox = CanvasCreate(fm_pos, fm_size, new Vector4(31, 31, 31, 255), fm_parent);
		CanvasSetBeforeUpdate(textbox, STYLER_TEXTBOX_UPDATE_BFEORE);
		CanvasSetAfterUpdate(textbox, STYLER_TEXTBOX_UPDATE_AFTER);
		CanvasSetBeforeDraw(textbox, STYLER_TEXTBOX_DRAW_BFEORE);
		CanvasSetAfterDraw(textbox, STYLER_TEXTBOX_DRAW_AFTER);
		textbox[? "FreeEx"] = TextboxFree; // dont forget to make a setter&getter for this
		
		ElementSetProperty(textbox, "", "text");
		ElementSetProperty(textbox, "", "ghostText");
		ElementSetProperty(textbox, m_font, "font");
		ElementSetProperty(textbox, 0, "timer");
		ElementSetProperty(textbox, 0, "point");
		ElementSetProperty(textbox, 0, "point1");
		ElementSetProperty(textbox, new Vector2(3, 3), "borderGap");
		ElementSetProperty(textbox, 7, "lineGap");
		ElementSetProperty(textbox, false, "isMultiline");
		ElementSetProperty(textbox, false, "isPassword");
		ElementSetProperty(textbox, "*", "passwordChar");
		ElementSetProperty(textbox, new Vector4(255, 255, 255, 255), "textColor");
		ElementSetProperty(textbox, new Vector4(128, 128, 128, 255), "ghostTextColor");
		ElementSetProperty(textbox, LabelCreate(ElementGetProperty(textbox, "borderGap"), "", textbox), "dummy");
		ElementSetProperty(textbox, false, "dragging");
		ElementSetProperty(textbox, ScrollbarVerticalCreate(new Vector3(0, 0, 0), textbox, new Vector2(fm_scrollbarWidth, fm_size.y - fm_scrollbarWidth * 2)), "m_scrollbarVertical");
		ElementSetProperty(textbox, ScrollbarHorizontalCreate(new Vector3(0, 0, 0), textbox, new Vector2(fm_size.x - fm_scrollbarWidth * 2, fm_scrollbarWidth)), "m_scrollbarHorizontal");
		ElementSetProperty(textbox, fm_scrollbarWidth, "scrollbarWidth");
		ElementSetProperty(textbox, fm_scrollbarGap, "scrollbarGap");
		ElementSetProperty(textbox, fm_scrollbarGapSide, "scrollbarGapSide");
		ElementSetProperty(textbox, -1, "charLimit");
		ElementSetProperty(textbox, fm_lineLimit, "lineLimit");
		
		return textbox;
	};
	
	/// @function TextboxFree(fm_textbox : ds_map) -> undefined
	function TextboxFree(fm_textbox) {
	};
	
	/// @function TextboxGetText(fm_textbox : ds_map) -> string
	TextboxGetText = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "text");
	};
	
	/// @function TextboxGetGhostText(fm_textbox : ds_map) -> string
	TextboxGetGhostText = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "ghostText");
	};
	
	/// @function TextboxGetFocus(fm_textbox : ds_map) -> boolean
	TextboxGetFocus = function(fm_textbox) {
		return ButtonGetState(fm_textbox) == CLICKABLE_STATE.HOT;
	};
	
	/// @function TextboxGetMultiline(fm_textbox : ds_map) -> boolean
	TextboxGetMultiline = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "isMultiline");
	};
	
	/// @function TextboxGetPassword(fm_textbox : ds_map) -> boolean
	TextboxGetPassword = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "isPassword");
	};
	
	/// @function TextboxGetPasswordCharacter(fm_textbox : ds_map) -> string
	TextboxGetPasswordCharacter = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "passwordChar");
	};
	
	/// @function TextboxGetLineGap(fm_textbox : ds_map) -> number
	TextboxGetLineGap = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "lineGap");
	};
	
	/// @function TextboxGetBorderGap(fm_textbox : ds_map) -> Vector2
	TextboxGetBorderGap = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "borderGap");
	};
	
	/// @function TextboxGetFont(fm_textbox : ds_map) -> font
	TextboxGetFont = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "font");
	};
	
	/// @function TextboxGetPoint(fm_textbox : ds_map) -> number
	TextboxGetPoint = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "point");
	};
	
	/// @function TextboxGetPointSecondary(fm_textbox : ds_map) -> number
	TextboxGetPointSecondary = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "point1");
	};
	
	/// @function TextboxGetTextColor(fm_textbox : ds_map) -> Vector4
	TextboxGetTextColor = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "textColor");
	};
	
	/// @function TextboxGetGhostTextColor(fm_textbox : ds_map) -> Vector4
	TextboxGetGhostTextColor = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "ghostTextColor");
	};
	
	/// @function TextboxGetCharacterLimit(fm_textbox : ds_map) -> number
	TextboxGetCharacterLimit = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "charLimit");
	};
	
	/// @function TextboxGetScrollbarWidth(fm_textbox : ds_map) -> number
	TextboxGetScrollbarWidth = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "scrollbarWidth");
	};
	
	/// @function TextboxGetScrollbarGap(fm_textbox : ds_map) -> number
	TextboxGetScrollbarGap = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "scrollbarGap");
	};
	
	/// @function TextboxGetScrollbarGapSide(fm_textbox : ds_map) -> number
	TextboxGetScrollbarGapSide = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "scrollbarGapSide");
	};
	
	/// @function TextboxGetScrollbarVertical(fm_textbox : ds_map) -> ds_map
	TextboxGetScrollbarVertical = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "m_scrollbarVertical")
	};
	
	/// @function TextboxGetScrollbarHorizontal(fm_textbox : ds_map) -> ds_map
	TextboxGetScrollbarHorizontal = function(fm_textbox) {
		return ElementGetProperty(fm_textbox, "m_scrollbarHorizontal")
	};
	
	/// @function TextboxSetText(fm_textbox : ds_map, fm_text : string) -> undefined
	TextboxSetText = function(fm_textbox, fm_text) {
		ElementSetProperty(fm_textbox, fm_text, "text");
	};
	
	/// @function TextboxSetGhostText(fm_textbox : ds_map, fm_text : string) -> undefined
	TextboxSetGhostText = function(fm_textbox, fm_text) {
		ElementSetProperty(fm_textbox, fm_text, "ghostText");
	};
	
	/// @function TextboxSetFocus(fm_textbox : ds_map, fm_focus : boolean) -> undefined
	TextboxSetFocus = function(fm_textbox, fm_focus) {
		ButtonSetState(fm_textbox, fm_focus ? CLICKABLE_STATE.HOT : CLICKABLE_STATE.IDLE);
	};
	
	/// @function TextboxSetMultiline(fm_textbox : ds_map, fm_multiline : boolean) -> undefined
	TextboxSetMultiline = function(fm_textbox, fm_multiline) {
		ElementSetProperty(fm_textbox, fm_multiline, "isMultiline");
	};
	
	/// @function TextboxSetPassword(fm_textbox : ds_map, fm_password : boolean) -> undefined
	TextboxSetPassword = function(fm_textbox, fm_password) {
		ElementSetProperty(fm_textbox, fm_password, "isPassword");
	};
	
	/// @function TextboxSetPasswordCharacter(fm_textbox : ds_map, fm_character : string) -> undefined
	TextboxSetPasswordCharacter = function(fm_textbox, fm_character) {
		ElementSetProperty(fm_textbox, string_char_at(fm_character, 0), "passwordChar");
	};
	
	/// @function TextboxSetLineGap(fm_textbox : ds_map, fm_gap : number) -> undefined
	TextboxSetLineGap = function(fm_textbox, fm_gap) {
		ElementSetProperty(fm_textbox, fm_gap, "lineGap");
	};
	
	/// @function TextboxSetBorderGap(fm_textbox : ds_map, fm_gap : Vector2) -> undefined
	TextboxSetBorderGap = function(fm_textbox, fm_gap) {
		ElementSetProperty(fm_textbox, fm_gap, "borderGap");
	};
	
	/// @function TextboxSetFont(fm_textbox : ds_map, fm_font : font) -> undefined
	TextboxSetFont = function(fm_textbox, fm_font) {
		ElementSetProperty(fm_textbox, fm_font, "font");
	};
	
	/// @function TextboxSetPoint(fm_textbox : ds_map, fm_point : number) -> undefined
	TextboxSetPoint = function(fm_textbox, fm_point) {
		ElementSetProperty(fm_textbox, fm_point, "point");
	};
	
	/// @function TextboxSetPointSecondary(fm_textbox : ds_map, fm_point : number) -> undefined
	TextboxSetPointSecondary = function(fm_textbox, fm_point) {
		ElementSetProperty(fm_textbox, fm_point, "point1");
	};
	
	/// @function TextboxSetTextColor(fm_textbox : ds_map, fm_color : Vector4) -> undefined
	TextboxSetTextColor = function(fm_textbox, fm_color) {
		ElementSetProperty(fm_textbox, fm_color, "textColor");
	};
	
	/// @function TextboxSetGhostTextColor(fm_textbox : ds_map, fm_color : Vector4) -> undefined
	TextboxSetGhostTextColor = function(fm_textbox, fm_color) {
		ElementSetProperty(fm_textbox, fm_color, "ghostTextColor");
	};
	
	/// @function TextboxSetCharacterLimit(fm_textbox : ds_map, fm_charLimit : number) -> undefined
	TextboxSetCharacterLimit = function(fm_textbox, fm_charLimit) {
		ElementSetProperty(fm_textbox, fm_charLimit, "charLimit");
	};
	
	/// @function TextboxSetScrollbarWidth(fm_textbox : ds_map, fm_width : number) -> undefined
	TextboxSetScrollbarWidth = function(fm_textbox, fm_width) {
		ElementSetProperty(fm_textbox, "scrollbarWidth", fm_width);
	};
	
	/// @function TextboxSetScrollbarGap(fm_textbox : ds_map, fm_gap : number) -> undefined
	TextboxSetScrollbarGap = function(fm_textbox, fm_gap) {
		ElementSetProperty(fm_textbox, "scrollbarGap", fm_gap);
	};
	
	/// @function TextboxSetScrollbarGapSide(fm_textbox : ds_map, fm_gapSide : number) -> undefined
	TextboxSetScrollbarGapSide = function(fm_textbox, fm_gapSide) {
		ElementSetProperty(fm_textbox, "scrollbarGapSide", fm_gapSide);
	};
	
	TextboxSetScrollbarVertical = function(fm_textbox, fm_scrollbar) {
		ElementSetProperty(fm_textbox, fm_scrollbar, "m_scrollbarVertical")
	};
	
	TextboxSetScrollbarHorizontal = function(fm_textbox, fm_scrollbar) {
		ElementSetProperty(fm_textbox, fm_scrollbar, "m_scrollbarHorizontal")
	};
	
	/// @function ComboboxCreate(pos = new Vector3(0, 0, 0) : Vector3, defaultText = "Select" : string, parent = noone : ds_map, size = new Vector2(124, 24) : Vector2, selectableHeight = 24 : number) -> ds_map
	ComboboxCreate = function
	(
		fm_pos = new Vector3(0, 0, 0), 
		fm_defaultText = "Select", 
		fm_parent = noone, 
		fm_size = new Vector2(124, 24), 
		fm_selectableHeight = 24
	) 
	{
		var comboboxButton = ButtonCreate(fm_pos, fm_defaultText, fm_parent, undefined, fm_size, STYLER_COMBOBOX_UPDATE_BEFORE, STYLER_COMBOBOX_UPDATE_AFTER, STYLER_COMBOBOX_DRAW_BEFORE, STYLER_COMBOBOX_DRAW_AFTER);
		comboboxButton[? "FreeEx"] = ComboboxFree;
		
		var comboboxMenu = CanvasCreate(new Vector3(fm_pos.x, fm_pos.y + fm_size.y, 99999), new Vector2(fm_size.x, 1), new Vector4(8, 8, 8, 255), noone);
		CanvasDeactivate(comboboxMenu);
		
		ElementSetProperty(comboboxButton, false, "check");
		ElementSetProperty(comboboxButton, noone, "selected");
		ElementSetProperty(comboboxButton, SelectableGroupCreate(), "selectableGroup");
		ElementSetProperty(comboboxButton, comboboxMenu, "menu");
		ElementSetProperty(comboboxMenu, fm_size.y, "selectableHeight");
		ElementSetProperty(comboboxMenu, comboboxButton, "button");
		
		return comboboxButton;
	};
	
	/// @function ComboboxFree(fm_combobox : ds_map) -> undefined
	ComboboxFree = function(fm_combobox) {
		var menu = ElementGetProperty(fm_combobox, "menu");
		
		SelectableGroupFree(ElementGetProperty(fm_combobox, "selectableGroup"));
		ds_map_delete(fm_combobox, "check");
		ButtonFree(fm_combobox);
	};
	
	/// @function ComboboxPush(fm_combobox : ds_map, name : string) -> ds_map
	ComboboxPush = function(fm_combobox, fm_name) {
		var menu = ElementGetProperty(fm_combobox, "menu");
		
		var selectable = SelectableCreate(new Vector3(0, ElementGetProperty(menu, "selectableHeight") * ds_list_size(CanvasGetElements(menu)), 0), fm_name, menu, new Vector2(CanvasGetSize(menu).x, ElementGetProperty(menu, "selectableHeight")), __Major_GM__ComboboxSelectableOnClick);
		SelectableGroupAddElement(ElementGetProperty(fm_combobox, "selectableGroup"), selectable);
		CanvasSetSize(menu, new Vector2(CanvasGetSize(menu).x, ElementGetProperty(menu, "selectableHeight") * ds_list_size(CanvasGetElements(menu))));
		
		return selectable;
	};
	
	/// @function ComboboxSelect(fm_combobox : ds_map, selectable : ds_map) -> undefined
	ComboboxSelect = function(fm_combobox, fm_selectable) {
		var group = ElementGetProperty(fm_combobox, "selectableGroup");
		SelectableGroupSetSelected(group, fm_selectable);
		ElementSetProperty(fm_combobox, fm_selectable, "selected");
	};
	
	/// @function ComboswitchCreate(pos = new Vector3(0, 0, 0) : Vector3, parent = noone : ds_map, onState = noone : function, width = 250 : number, height = 30 : number) -> ds_map
	ComboswitchCreate = function
	(
		fm_pos = new Vector3(0, 0, 0), 
		fm_parent = noone, 
		fm_onState = noone, 
		fm_width = 250, 
		fm_height = 30
	) 
	{
		var panel = PanelCreate(undefined, new Vector2(0, 0), true, fm_parent, new Vector4(31, 31, 31, 255), new Vector2(fm_width, fm_height));
		var buttonLeft = noone;
		var midCanvas = noone;
		var buttonRight = noone;
		
		PanelPush(panel, undefined, undefined, true);
			buttonLeft = PanelElementCreate(
				panel, 
				ButtonCreate(new Vector3(0, 0, 0), "<", panel), 
				fm_width / 2 / 4, 
				true
			);
			midCanvas = PanelElementCreate(
				panel, 
				CanvasCreate(new Vector3(0, 0, 0), new Vector2(1, 1), new Vector4(0, 0, 0, 0), panel), 
				fm_width / 2, 
				true
			);
			buttonRight = PanelElementCreate(
				panel, 
				ButtonCreate(new Vector3(0, 0, 0), ">", panel), 
				fm_width / 2 / 4, 
				true
			);
		PanelPop(panel);
		
		ElementSetProperty(buttonLeft, -1, "__side");
		ElementSetProperty(buttonRight, 1, "__side");
		ElementSetProperty(buttonLeft,  fm_onState, "__onStateChange");
		ElementSetProperty(buttonRight, fm_onState, "__onStateChange");
		ElementSetProperty(panel, ds_list_create(), "switchList");
		ElementSetProperty(panel, ComboswitchFree, "FreeEx");
		ElementSetProperty(panel, 0, "__current");
		
		ButtonSetOnClick(buttonLeft, __Major_GM__ComboswitchButtonsOnClick);
		ButtonSetOnClick(buttonRight, __Major_GM__ComboswitchButtonsOnClick);
		
		CanvasSetBeforeDraw(midCanvas, STYLER_COMBOSWTICH_MIDCANVAS_DRAW_BEFORE);
		ButtonSetFont(panel, m_font);
		
		return panel;
	};
	
	/// @function ComboswitchFree(fm_comboswitch : ds_map) -> undefined
	ComboswitchFree = function(fm_comboswitch) {
		ds_list_destroy(ElementGetProperty(fm_comboswitch, "switchList"));
	};
	
	/// @function ComboswitchPush(fm_comboswitch : ds_map, text : string) -> number
	ComboswitchPush = function(fm_comboswitch, fm_text) {
		var list = ElementGetProperty(fm_comboswitch, "switchList");
		ds_list_add(list, fm_text);
		return ds_list_size(list) - 1;
	};
	
	/// @function ComboswitchCurrent(fm_comboswitch : ds_map) -> string
	ComboswitchCurrent = function(fm_comboswitch) {
		var list = ElementGetProperty(fm_comboswitch, "switchList");
		return list[| ElementGetProperty(fm_comboswitch, "__current")];
	};
	
	/// @function ComboswitchSetCurrentIndex(fm_comboswitch : ds_map, index : number) -> undefined
	ComboswitchSetCurrentIndex = function(fm_comboswitch, fm_index) {
		ElementSetProperty(fm_comboswitch, fm_index, "__current");
	};
	
	/// @function ComboswitchDelete(fm_comboswitch : ds_map, index : number) -> undefined
	ComboswitchDelete = function(fm_comboswitch, fm_index) {
		var list = ElementGetProperty(fm_comboswitch, "switchList");
		ds_list_delete(list, fm_index);
	};
	
	/// @function ComboswitchGetButtonLeft(fm_comboswitch : ds_map) -> ds_map
	ComboswitchGetButtonLeft = function(fm_comboswitch) {
		return CanvasGetElement(fm_comboswitch, 0);
	};
	
	/// @function ComboswitchGetButtonRight(fm_comboswitch : ds_map) -> ds_map
	ComboswitchGetButtonRight = function(fm_comboswitch) {
		return CanvasGetElement(fm_comboswitch, 2);
	};
	
	/// @function SliderCreate(pos = new Vector3(0, 0, 0) : Vector3, parent = noone : ds_map, startVal = 0 : number, endVal = 1 : number, percentage = 0 : number, length = 100 : number, width = 8 : number, height = 20 : number, onClick = noone : function, onUpdateBefore = STYLER_SLIDER_UPDATE_BEFORE : function, onUpdateAfter = STYLER_SLIDER_UPDATE_AFTER : function, onDrawBefore = STYLER_SLIDER_DRAW_BEFORE : function, onDrawAfter = STYLER_SLIDER_DRAW_AFTER : function) -> ds_map
	SliderCreate = function
	(
		fm_pos = new Vector3(0, 0, 0), 
		fm_parent = noone, 
		fm_startVal = 0, fm_endVal = 1, 
		fm_percentage = 0, 
		fm_length = 100, 
		fm_width = 8, fm_height = 20, 
		fm_onClick = noone, 
		fm_onUpdateBefore	=	STYLER_SLIDER_UPDATE_BEFORE, 
		fm_onUpdateAfter	=	STYLER_SLIDER_UPDATE_AFTER, 
		fm_onDrawBefore		=	STYLER_SLIDER_DRAW_BEFORE, 
		fm_onDrawAfter		=	STYLER_SLIDER_DRAW_AFTER
	) 
	{
		var slider = CanvasCreate(fm_pos, new Vector2(fm_length, fm_height), new Vector4(0, 0, 0, 0), fm_parent);
		
		slider[? "state"] = CLICKABLE_STATE.IDLE;
		
		slider[? "BeforeUpdate"] = fm_onUpdateBefore;
		slider[? "AfterUpdate"] = fm_onUpdateAfter;
		slider[? "BeforeDraw"] = fm_onDrawBefore;
		slider[? "AfterDraw"] = fm_onDrawAfter;
		slider[? "OnClick"] = fm_onClick;
		
		slider[? "FreeEx"] = SliderFree;
		
		slider[? "percentage"] = fm_percentage;
		slider[? "startVal"] = fm_startVal;
		slider[? "endVal"] = fm_endVal;
		slider[? "__width"] = fm_width;
		
		slider[? "mouseTracking"] = false;
		
		return slider;
	};
	
	/// @function SliderFree(fm_slider : ds_map) -> undefined
	SliderFree = function(fm_slider) {
	};
	
	/// @function SliderGetPercentage(fm_slider : ds_map) -> numberage
	SliderGetPercentage = function(fm_slider) {
		return fm_slider[? "percentage"];
	};
	
	/// @function SliderGetValue(fm_slider : ds_map) -> number
	SliderGetValue = function(fm_slider) {
		return Mix(fm_slider[? "startVal"], fm_slider[? "endVal"], SliderGetPercentage(fm_slider));
	};

	/// @function SliderSetPercentage(fm_slider : ds_map, fm_percentage : number) -> undefined}
	SliderSetPercentage = function(fm_slider, fm_percentage) {
		fm_slider[? "percentage"] = fm_percentage;
	};
	
	/// @function SliderSetValue(fm_slider : ds_map, fm_value : number) -> undefined
	SliderSetValue = function(fm_slider, fm_value) {
		var value = max(min(fm_slider[? "endVal"], fm_value), fm_slider[? "startVal"]);
		fm_slider[? "percentage"] = (value - fm_slider[? "startVal"]) / fm_slider[? "endVal"];
	};
	
	/// @function TableChartCreate(pos = new Vector3(0, 0, 0) : Vector3, size = new Vector2(500, 200) : Vector2, arrHeaders = noone : array, arrElements = noone : array, parent = noone : ds_map) -> ds_map
	TableChartCreate = function
	(
		fm_pos = new Vector3(0, 0, 0), 
		fm_size = new Vector2(500, 200), 
		fm_arrHeaders = noone, 
		fm_arrElements = noone, 
		fm_parent = noone
	) 
	{
		var chart = PanelCreate(fm_pos, undefined, false, fm_parent, undefined, fm_size);
		
		if (fm_arrHeaders != noone) {
			PanelPush(chart, undefined, undefined, true);
				for (var i = 0; i < array_length(fm_arrHeaders); i++) {
					PanelElementCreate(
						chart, 
						LabelCreate(
							new Vector3(0, 0, 0), fm_arrHeaders[i][0], chart
						), 
						fm_arrHeaders[i][1], 
						undefined, 
						new Align(ALIGN.LEFT, ALIGN.TOP)
					);
				};
			PanelPop(chart);
		};
		
		for (var i = 0; i < array_length(fm_arrElements); i++) {
			PanelPush(chart, undefined, undefined, true);
				for (var j = 0; j < min(array_length(fm_arrHeaders), array_length(fm_arrElements[i])); j++) {
						PanelElementCreate(
							chart, 
							LabelCreate(
								new Vector3(0, 0, 0), fm_arrElements[i][j], chart
							), 
							fm_arrHeaders[j][1], 
							undefined, 
							new Align(ALIGN.LEFT, ALIGN.TOP)
						);
				};
			PanelPop(chart);
		};
		
		return chart;
	};
	
	/// @function SpriteCreate(pos : Vector3, sprite : sprite, index = 0 : number, speed = 1 : number, parent = noone : ds_map, onClick = noone : function, onUpdateBefore = STYLER_SPRITE_UPDATE_BEFORE : function, onUpdateAfter = STYLER_SPRITE_UPDATE_AFTER : function, onDrawBefore = STYLER_SPRITE_DRAW_BEFORE : function, onDrawAfter = STYLER_SPRITE_DRAW_AFTER : function) -> ds_map
	SpriteCreate = function
	(
		fm_pos, 
		fm_sprite, 
		fm_index = 0, 
		fm_speed = 1,
		fm_xscale = 1,
		fm_yscale = 1,
		fm_blend = c_white,
		fm_alpha = 1,
		fm_parent = noone, 
		fm_onClick = noone, 
		fm_onUpdateBefore	=	STYLER_SPRITE_UPDATE_BEFORE, 
		fm_onUpdateAfter	=	STYLER_SPRITE_UPDATE_AFTER, 
		fm_onDrawBefore		=	STYLER_SPRITE_DRAW_BEFORE, 
		fm_onDrawAfter		=	STYLER_SPRITE_DRAW_AFTER
	) 
	{
		var sprite = CanvasCreate(fm_pos, new Vector2(sprite_get_width(fm_sprite) * fm_xscale, sprite_get_height(fm_sprite) * fm_yscale), new Vector4(0, 0, 0, 0), fm_parent);
		
		CanvasSetBeforeUpdate(sprite, fm_onUpdateBefore);
		CanvasSetAfterUpdate(sprite, fm_onUpdateAfter);
		CanvasSetBeforeDraw(sprite, fm_onDrawBefore);
		CanvasSetAfterDraw(sprite, fm_onDrawAfter);
		
		ElementSetProperty(sprite, fm_sprite, "mSprite");
		ElementSetProperty(sprite, fm_index, "mIndex");
		ElementSetProperty(sprite, fm_speed, "mSpeed");
		ElementSetProperty(sprite, fm_xscale, "mXscale");
		ElementSetProperty(sprite, fm_yscale, "mYscale");
		ElementSetProperty(sprite, fm_blend, "mColor");
		ElementSetProperty(sprite, fm_alpha, "mAlpha");
		ButtonSetState(sprite, CLICKABLE_STATE.IDLE);
		ButtonSetOnClick(sprite, fm_onClick);
		
		ElementSetProperty(sprite, SpriteFree, "FreeEx");
		
		return sprite;
	};
	
	/// @function SpriteFree(fm_sprite : ds_map) -> undefined
	SpriteFree = function(fm_sprite) {
	};
	
	/// @function SpriteGetSprite(fm_sprite : ds_map) -> sprite
	SpriteGetSprite = function(fm_sprite) {
		return ElementGetProperty(fm_sprite, "mSprite");
	};
	
	/// @function SpriteGetIndex(fm_sprite : ds_map) -> number
	SpriteGetIndex = function(fm_sprite) {
		return ElementGetProperty(fm_sprite, "mIndex");
	};
	
	/// @function SpriteGetSpeed(fm_sprite : ds_map) -> number
	SpriteGetSpeed = function(fm_sprite) {
		return ElementGetProperty(fm_sprite, "mSpeed");
	};
	
	/// @function SpriteSetSprite(fm_sprite : ds_map, fm_asset : sprite) -> undefined
	SpriteSetSprite = function(fm_sprite, fm_asset) {
		ElementSetProperty(fm_sprite, fm_asset, "mSprite");
	};
	
	/// @function SpriteSetIndex(fm_sprite : ds_map, fm_index : number) -> undefined
	SpriteSetIndex = function(fm_sprite, fm_index) {
		ElementSetProperty(fm_sprite, fm_index, "mIndex");
	};
	
	/// @function SpriteSetSpeed(fm_sprite : ds_map, fm_speed : number) -> undefined
	SpriteSetSpeed = function(fm_sprite, fm_speed) {
		ElementSetProperty(fm_sprite, fm_speed, "mSpeed");
	};
	
	/// @function TreeViewCreate(position : Vector3, size : Vector2, parent : ds_map) -> ds_map
	TreeViewCreate = function(fm_position, fm_size, fm_parent) {
		var treeView = PanelCreate(fm_position, new Vector2(2, -2), undefined, fm_parent, undefined, fm_size);
		
		treeView[? "FreeEx"] = TreeViewFree;
		
		ElementSetProperty(treeView, ds_list_create(), "parentNodeElements");
		ElementSetProperty(treeView, -1, "listPos");
		ElementSetProperty(treeView, 24 + 2, "pushWidth");
		
		ElementSetProperty(treeView, SelectableGroupCreate(), "group");
		
		return treeView;
	};
	
	/// @function TreeViewFree(fm_treeView : ds_map) -> undefined
	TreeViewFree = function(fm_treeView) {
		var parentNodeElements = ElementGetProperty(fm_treeView, "parentNodeElements");
		var group = ElementGetProperty(fm_treeView, "group");
		
		for (var i = 0; i < ds_list_size(parentNodeElements); i++) {
			var e = parentNodeElements[| i];
			if (ds_exists(e, ds_type_list)) {
				ds_list_destroy(e);
			};
		};
		
		SelectableGroupFree(group);
	};
	
	/// @function TreeViewGetGroup(fm_treeView : ds_map) -> ds_map
	TreeViewGetGroup = function(fm_treeView) {
		ElementGetProperty(fm_treeView, "group");
	};
	
	/// @function TreeViewPushParentNode(fm_treeView : ds_map, name : string) -> array
	TreeViewPushParentNode = function(fm_treeView, fm_name, fm_check = false) {
		var parentNodeElements = ElementGetProperty(fm_treeView, "parentNodeElements");
		var listPos = ElementGetProperty(fm_treeView, "listPos");
		var group = ElementGetProperty(fm_treeView, "group");
		
		PanelPush(fm_treeView, undefined, undefined, false);
		ds_list_add(parentNodeElements, ds_list_create());
		listPos++;
		var responsibleElements = parentNodeElements[| listPos];
		var checkbox = PanelElementCreate(
			fm_treeView, 
			CheckboxCreate(undefined, fm_treeView, new Vector2(24, 24))
		);
		CanvasSetBeforeUpdate(checkbox, STYLER_TREEVIEWCHECKBOX_UPDATE_BEFORE);
		CanvasSetAfterUpdate(checkbox, STYLER_TREEVIEWCHECKBOX_UPDATE_AFTER);
		CanvasSetBeforeDraw(checkbox, STYLER_TREEVIEWCHECKBOX_DRAW_BEFORE);
		CanvasSetAfterDraw(checkbox, STYLER_TREEVIEWCHECKBOX_DRAW_AFTER);
		ElementSetProperty(checkbox, true, "checkcheck"); // update call to activate/deactivate responsible elements
		ElementSetProperty(checkbox, responsibleElements, "__responsibleElements");
		CheckboxSetCheck(checkbox, fm_check);
		var selectable = PanelElementCreate(
			fm_treeView, 
			SelectableCreate(undefined, fm_name, fm_treeView)
		);
		SelectableGroupAddElement(group, selectable);
		if (listPos - 1 != -1) {
			ds_list_add(parentNodeElements[| listPos - 1], checkbox);
			ds_list_add(parentNodeElements[| listPos - 1], selectable);
		};
		
		ElementSetProperty(fm_treeView, listPos, "listPos");
		return [ checkbox, selectable ];
	};
	
	/// @function TreeViewPopParentNode(fm_treeView : ds_map) -> undefined
	TreeViewPopParentNode = function(fm_treeView) {
		var parentNodeElements = ElementGetProperty(fm_treeView, "parentNodeElements");
		var listPos = ElementGetProperty(fm_treeView, "listPos");
		
		ds_list_add(parentNodeElements, ds_list_create());
		ElementSetProperty(fm_treeView, listPos + 1, "listPos");
		PanelPop(fm_treeView);
	};
	
	/// @function TreeViewAddChildNode(fm_treeView : ds_map, name : string) -> ds_map
	TreeViewAddChildNode = function(fm_treeView, fm_name) {
		var parentNodeElements = ElementGetProperty(fm_treeView, "parentNodeElements");
		var listPos = ElementGetProperty(fm_treeView, "listPos");
		var group = ElementGetProperty(fm_treeView, "group");
		
		PanelPush(fm_treeView, undefined, undefined, false);
		var selectable = PanelElementCreate(
			fm_treeView, 
			SelectableCreate(undefined, fm_name, fm_treeView)
		);
		SelectableGroupAddElement(group, selectable);
		PanelPop(fm_treeView);
		
		ds_list_add(parentNodeElements[| listPos], selectable);
		
		return selectable;
	};
	
	/// @function Setup(screenSize : Vector2) -> undefined
	Setup = function(fm_screenSize) {
		CanvasCreate(new Vector3(0, 0, 0), fm_screenSize, new Vector4(0, 0, 0, 0));
		CanvasSetAlignment(global.MAJORGUI_MAIN_CANVAS, new Align(ALIGN.LEFT, ALIGN.TOP));
	};
	
	/// @function Update() -> undefined
	Update = function() {
		if (global.MAJORGUI_SAVED_TRACKLIST != noone) {
			ds_list_clear(global.MAJORGUI_SAVED_TRACKLIST);
		};
		self.m_canvasHover = GetHoverCanvas(global.MAJORGUI_MAIN_CANVAS, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), true);
		if (mouse_check_button_pressed(mb_left)) { m_canvasLastClicked = self.m_canvasHover; };

		//window_set_cursor(cr_arrow);
		
		CanvasUpdate(global.MAJORGUI_MAIN_CANVAS);
	};
	
	/// @function Draw() -> undefined
	Draw = function() {
		CanvasDraw(global.MAJORGUI_MAIN_CANVAS);
	};
	
	/// @function Free() -> undefined
	Free = function() {
		ElementFree(global.MAJORGUI_MAIN_CANVAS);
		global.MAJORGUI_MAIN_CANVAS = noone;
		if (ds_exists(global.MAJORGUI_SAVED_TRACKLIST, ds_type_list)) { ds_list_destroy(global.MAJORGUI_SAVED_TRACKLIST); };
		global.MAJORGUI_SAVED_TRACKLIST = noone;
	};
};

// TODO: FIX BUG: if titles in a panel gets closed one by one from bottom to top, scrollbar wont change its limit

// TODO make Textbox scrollbar scroll on enter and each key + keyboard and mouse scrolls

// TODO fix label customization

// TODO add hover
// TODO add slider - multiple anchors

/* FEATURE LIST
* Canvas
* Button
* Label
* Checkbox
* Radiobox
* Slidebar
* Panel
* Scrollbar
* Textbox - single line [[DEPRECATED]]
* Textbox
* Combobox
* Comboswitch
* Slider
* TableChart
* Sprite
* Selectable
* TreeView
*/

