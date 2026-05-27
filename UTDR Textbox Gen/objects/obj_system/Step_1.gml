///@desc Context Menu, Page Count, Etc.
//if ( live_call() ) { return live_result; } 
#region Page Count and Ensure Face
	//if ( !record.enabled && !screenshot ) { var count_ = string_count("[/page]", dial_text), count_2 = string_count("[pg]", dial_text), finalcount_ = count_ + count_2; 
	//	dial_text_page_c = finalcount_ + 1; dial_text_page = clamp(dial_text_page, 0, dial_text_page_c); }
	
	if ( dial_text_page_c > 1 ) { //Prevents out of bounds array reads
		var result = array_length(dial_face);
		if ( result < dial_text_page_c ) { 
			dial_face[dial_text_page_c - 1] = -1;
			dial_face_prev[dial_text_page_c - 1] = -1; 
			dial_face_original[dial_text_page_c - 1] = -1; 
			dial_face_name[dial_text_page_c - 1] = -1; 
			dial_face_index[dial_text_page_c - 1] = 0; 
			dial_face_spd[dial_text_page_c - 1] = 0; 
		}
	}
#endregion

#region Context Menu
	var result, txt_ = textinput.GetValue(), select_ = textinput.GetSelection();
	result = textinput.ContextMenuGetItem("soupy_copy");
	result.SetEnabled(txt_ != "" && select_.has_selection); //Only enable if there's text and we've selected something
	result = textinput.ContextMenuGetItem("soupy_cut");
	result.SetEnabled(txt_ != "" && select_.has_selection); //Only enable if there's text and we've selected something
	result = textinput.ContextMenuGetItem("soupy_clear");
	result.SetEnabled(txt_ != ""); //Only enable if there's text
	result = textinput.ContextMenuGetItem("soupy_paste");
	result.SetEnabled(clipboard_has_text()); //Only enable if there's text in the clipboard
#endregion

#region Export Dialogue
	var endkey = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_end) || keyboard_check_pressed(vk_f1);
	if ( ( !screenshot && !record.enabled ) && ( endkey ) && is_undefined(soup_checkout("export dialogue", false)) && !ui_viewing ) {
		soup_store("export dialogue", true);
		soup_store("export dialogue func", function() { soup_store_clear(); SYSTEMUI.ui_paused = false; });
		
		var exportarr = [
			new LuiText({ value: "Ready to export your dialogue?", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }),
			new LuiText({ value: "Select your export option!", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }),
			
			new LuiButton({ text: "Static", height: 35, }).setTooltip("Export your dialogue as a static, non-animated screenshot.", true).addEvent(LUI_EV_CLICK, function(element_) {
				var maincan = soup_checkout("maincan"), mainfunc = soup_checkout("export dialogue func", false); maincan.destroy(); SYSTEMUI.ui_paused = false;
				soup_store("pageat", dial_text_page + 1); soup_store("bordout", bord_out); soup_store("bordvisible", bord_box_visible); soup_store("xoff", 0); soup_store("yoff", 0);
				
				#region Static Button Function
					var exportarr = [
						new LuiText({ value: "Select your static export type:", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }),
						new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
							new LuiImageButton({ value: spr_export_icons, maintain_aspect: false, }).setSize(130, 130).setTooltip("Export just a standalone image of the chosen page.", true).addEvent(LUI_EV_CREATE, function(element_) { soup_store("export 1", element_); })
								.addEvent(LUI_EV_CLICK, function(element_) { soup_store("stacked", false); var option_ = soup_checkout("export 2", false); option_.setColor(#524664); element_.setColor(c_white); }),
							new LuiImageButton({ value: spr_export_icons, subimg: 1, maintain_aspect: false, }).setSize(130, 130).setTooltip($"Export all your pages as one big stack.{global.pref.sizematters ? "\n[c_red]Disabled while [c_yellow]Bigger Resolution[c_red] is enabled." : ""}", true, , true).addEvent(LUI_EV_CREATE, function(element_) { soup_store("export 2", element_); element_.setColor(#524664); soup_store("stacked", false); })
								.addEvent(LUI_EV_CLICK, function(element_) { if ( global.pref.sizematters ) { sfx_play(snd_error); exit; } soup_store("stacked", true); var option_ = soup_checkout("export 1", false); option_.setColor(#524664); element_.setColor(c_white); }),
						]),
						new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
							new LuiText({ value: "Start at page:", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }),
							new LuiInput({ value: soup_checkout("pageat", false), placeholder: $"1 - {dial_text_page_c}", input_mode: LUI_INPUT_MODE.numbers, offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).bindVariable(global.soupstore, "pageat"),
						]),
						new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
							new LuiText({ value: "Stack Gap:", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }).setTooltip("The gap between stacks of dialogue pages.\nOnly affects the dialogue stack option.", true),
							new LuiInput({ value: soup_checkout("yoff", false), placeholder: "0 - 10 Recommended", input_mode: LUI_INPUT_MODE.numbers, offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).bindVariable(global.soupstore, "yoff"),
						]),
						new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
							new LuiText({ value: "Stack Shift:", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }).setTooltip("Times to right shift the next dialogue stack by.\nOnly affects the dialogue stack option.", true),
							new LuiInput({ value: soup_checkout("xoff", false), placeholder: "0 - 10 Recommended", input_mode: LUI_INPUT_MODE.numbers, offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).bindVariable(global.soupstore, "xoff"),
						]),
						new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
							new LuiText({ value: "Border outline?", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }).setTooltip("Should the dialogue box have an outline?\nBorder must be visible.", true),
							new LuiToggleSwitch({ value: soup_checkout("bordout", false), ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3, }).bindVariable(global.soupstore, "bordout"),
						]),
						new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
							new LuiText({ value: "Border visible?", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }).setTooltip("Should the dialogue box be visible?", true),
							new LuiToggleSwitch({ value: soup_checkout("bordvisible", false), ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3, }).bindVariable(global.soupstore, "bordvisible"),
						]),
						new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
							new LuiText({ value: "Filename:", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }).setTooltip("The name to save the result as.\nLeave blank to use a soupy filename.", true),
							new LuiInput({ value: SYSTEMUI.file_newname, height: 35, offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).bindVariable(SYSTEMUI, "file_newname"),
						]),
						new LuiButton({ text: "Let's get soupy!!", height: 35, }).addEvent(LUI_EV_CLICK, function(element_) {
							var stacked_ = soup_checkout("stacked", false), page_ = soup_checkout("pageat", false), out_ = soup_checkout("bordout", false), vis_ = soup_checkout("bordvisible", false), xx_ = soup_checkout("xoff", false), yy_ = soup_checkout("yoff", false);
							var mainfunc = soup_checkout("export dialogue func", false), maincan = soup_checkout("maincan", false);
							if ( stacked_ && SYSTEMUI.dial_text_page_c <= 1 ) { SYSTEMUI.ui_paused = false; soupy_message("You must have more than one page.", "Go Back", 300, , , snd_error, , , true); exit; }
							if ( string_lettersdigits(dial_text) == "" ) { SYSTEMUI.ui_paused = false; soupy_message("You haven't even written any|dialogue yet!!", "Go Back", 300, , , snd_error, , , true); exit; }
							if ( string_lettersdigits(page_) == "" ) { page_ = 0; } if ( string_lettersdigits(xx_) == "" ) { xx_ = 0; } if ( string_lettersdigits(yy_) == "" ) { yy_ = 0; }
							if ( page_ > SYSTEMUI.dial_text_page_c ) { SYSTEMUI.ui_paused = false; soupy_message("Starting page can't be greater|than your page count.", "Go Back", 300, , , snd_error, , , true); exit; } else if ( page_ == "" || page_ == 0 ) { page_ = 1; } 
							if ( xx_ == "" ) { xx_ = 0; } if ( yy_ == "" ) { yy_ = 0; }
							
							with ( SYSTEMUI ) { dial_text_page = real(page_ - 1); ui_export(stacked_ ? 3 : 0, , , , real(xx_), real(yy_)); bord_box_visible = vis_; bord_out = out_; }
							mainfunc(); maincan.destroy();
						}),
					];
				#endregion
					
				var maincan = soupy_popup(exportarr, mainfunc, "Nevermind", 300, , , snd_select, , , 0);
				soup_store("maincan", maincan);
			}),
			
			new LuiButton({ text: "Animated", height: 35, }).setTooltip("Your dialogue will be animated and recorded as a GIF.", true).addEvent(LUI_EV_CLICK, function(element_) {
				var maincan = soup_checkout("maincan"), mainfunc = soup_checkout("export dialogue func", false); maincan.destroy(); SYSTEMUI.ui_paused = false;
				
				#region Animation Button Function
					var exportarr = [
						new LuiText({ value: "Select your animated export type:", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }),
						new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
							new LuiImageButton({ value: spr_export_icons, subimg: 2, maintain_aspect: false, }).setSize(130, 130).setTooltip("Leverage the power of Typewriter Mode, enable it,\nand watch as your dialogue plays out in sequence!", true).addEvent(LUI_EV_CREATE, function(element_) { soup_store("export 1", element_); })
								.addEvent(LUI_EV_CLICK, function(element_) { soup_store("typewrite", true); var option_ = soup_checkout("export 2", false); option_.setColor(#524664); element_.setColor(c_white); }),
							new LuiImageButton({ value: spr_export_icons, subimg: 3, maintain_aspect: false, }).setSize(130, 130).setTooltip("Animate the current page for a select amount of time.\nNo Typewriter Mode.", true).addEvent(LUI_EV_CREATE, function(element_) { soup_store("export 2", element_); element_.setColor(#524664); soup_store("typewrite", true); })
								.addEvent(LUI_EV_CLICK, function(element_) { soup_store("typewrite", false); var option_ = soup_checkout("export 1", false); option_.setColor(#524664); element_.setColor(c_white); }),
						]),
						new LuiButton({ text: "Next", height: 35, }).addEvent(LUI_EV_CLICK, function(element_) {
							var maincan = soup_checkout("maincan"), mainfunc = soup_checkout("export dialogue func", false); maincan.destroy(); SYSTEMUI.ui_paused = false;
							var typewrite = soup_checkout("typewrite", false); soup_store("pageat", 0); soup_store("bordout", bord_out); soup_store("bordvisible", bord_box_visible); soup_store("timerfor", 180); soup_store("delayb", record.delay); soup_store("quant", record.quant);
							
							var exportarr = []; 
							if ( !typewrite ) {
								array_push(exportarr, new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
									new LuiText({ value: "Record for:", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }).setTooltip("The amount of frames per seconds to record for.\n[c_yellow]60[/] = [c_lime]1 second[/], [c_yellow]30[/] = [c_lime]0.5 seconds[/], [c_yellow]120[/] = [c_lime]2 seconds[/], etc.", true, , true),
									new LuiInput({ value: soup_checkout("timerfor", false), placeholder: "123456", input_mode: LUI_INPUT_MODE.numbers, offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).bindVariable(global.soupstore, "timerfor"),
								]));
							}
							else {
								array_push(exportarr, new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
									new LuiText({ value: "Delay between pages:", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }).setTooltip("How long to wait until the next dialogue page plays out?\nThis is measured in frames per second.\n[c_yellow]60[/] = [c_lime]1 second[/], [c_yellow]30[/] = [c_lime]0.5 seconds[/], [c_yellow]120[/] = [c_lime]2 seconds[/], etc.", true, , true),
									new LuiInput({ value: soup_checkout("delayb", false), placeholder: "123456", input_mode: LUI_INPUT_MODE.numbers, offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).bindVariable(global.soupstore, "delayb"),
								]));
							}
							
							array_push(exportarr, 
								new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
									new LuiText({ value: "Start at page:", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }),
									new LuiInput({ value: 0, placeholder: $"1 - {dial_text_page_c}", input_mode: LUI_INPUT_MODE.numbers, offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).bindVariable(global.soupstore, "pageat"),
								]),
								new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
									new LuiText({ value: "Border outline?", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }).setTooltip("Should the dialogue box have an outline?\nBorder must be visible.", true),
									new LuiToggleSwitch({ value: soup_checkout("bordout", false), ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3, }).bindVariable(global.soupstore, "bordout"),
								]),
								new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
									new LuiText({ value: "Border visible?", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }).setTooltip("Should the dialogue box be visible?", true),
									new LuiToggleSwitch({ value: soup_checkout("bordvisible", false), ease: global.Ease.OutBack, sound_click: snd_bump, sound_click_pitch: 1.3, }).bindVariable(global.soupstore, "bordvisible"),
								]),
								new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
									new LuiText({ value: "Quantization:", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }).setTooltip("The amount of processing color quantization will have.\nA value between 0 - 3, full quant to low quant.\nThe lower the number, the smaller the GIF will be\nat the cost of quality and color count.", true),
									new LuiInput({ value: soup_checkout("quant", false), placeholder: "0 - 3", input_mode: LUI_INPUT_MODE.numbers, offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).bindVariable(global.soupstore, "quant"),
								]),
								new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
									new LuiText({ value: "Filename:", text_halign: fa_center, text_valign: fa_middle, auto_width: false, auto_height: false, }).setTooltip("The name to save the result as.\nLeave blank to use a soupy filename.", true),
									new LuiInput({ value: SYSTEMUI.file_newname, height: 35, offset: 12, type_sfx: snd_txttype, color_normal: c_white, color_hover: c_gray, }).bindVariable(SYSTEMUI, "file_newname"),
								]),
								new LuiButton({ text: "Let's get soupy!!", height: 35, }).addEvent(LUI_EV_CLICK, function(element_) {
									var typewrite = soup_checkout("typewrite", false), page_ = soup_checkout("pageat", false), out_ = soup_checkout("bordout", false), vis_ = soup_checkout("bordvisible", false), timer_ = soup_checkout("timerfor", false), delay_ = soup_checkout("delayb", false), quant_ = soup_checkout("quant", false);
									var mainfunc = soup_checkout("export dialogue func", false), maincan = soup_checkout("maincan", false);
									if ( string_lettersdigits(page_) == "" ) { page_ = 0; } if ( string_lettersdigits(timer_) == "" ) { timer_ = 180; } if ( string_lettersdigits(delay_) == "" ) { delay_ = 60; } if ( string_lettersdigits(quant_) == "" ) { quant_ = 1; }
									if ( page_ > SYSTEMUI.dial_text_page_c ) { SYSTEMUI.ui_paused = false; soupy_message("Starting page can't be greater|than your page count.", "Go Back", 300, , , snd_error, , , true); exit; } else if ( page_ == "" || page_ == 0 ) { page_ = 1; }
									if ( string_lettersdigits(dial_text) == "" ) { SYSTEMUI.ui_paused = false; soupy_message("You haven't even written any|dialogue yet!!", "Go Back", 300, , , snd_error, , , true); exit; }
									quant_ = clamp(quant_, 0, 3);
						
									with ( SYSTEMUI ) { dial_text_page = real(page_ - 1); ui_export(typewrite ? 1 : 2, timer_, delay_, quant_); bord_box_visible = vis_; bord_out = out_; }
									mainfunc(); maincan.destroy();
								}),
							);
							
							var maincan = soupy_popup(exportarr, mainfunc, "Nevermind", 400, , , snd_select);
							soup_store("maincan", maincan);
						}),
					];
				#endregion
				
				var maincan = soupy_popup(exportarr, mainfunc, "Nevermind", 300, , , snd_select);
				soup_store("maincan", maincan);
			}),
		];
		var maincan = soupy_popup(exportarr, function() { soup_store_clear(); }, "Nevermind", 300, , , snd_select);
		soup_store("maincan", maincan);
	}
	
	#region Quick Exports
		if ( keyboard_check(vk_control) && !ui_paused ) {
			var valid_ = false;
			if ( keyboard_check_pressed(ord("Q")) ) { ui_export(); valid_ = true; } //Static
			if ( keyboard_check_pressed(ord("W")) ) { ui_export(1); valid_ = true; } //Typewriter
			if ( keyboard_check_pressed(ord("E")) ) { ui_export(3); valid_ = true; } //Stack
			if ( keyboard_check_pressed(ord("R")) ) { ui_export(2); valid_ = true; } //Animated
			if ( keyboard_check_pressed(ord("1")) ) { ui_updateref(); } //Update Ref
			if ( keyboard_check_pressed(ord("2")) ) { var func_ = ui_viewing ? ui_unviewref : ui_viewref; func_(); if ( ui_viewing ) { sfx_play(snd_enc1); } } //View Ref
			if ( valid_ ) { bord_box_visible = true; bord_out = true; }
		}
	#endregion
#endregion