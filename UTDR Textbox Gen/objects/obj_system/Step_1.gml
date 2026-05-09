///@desc Context Menu, Page Count, Etc.
//if ( live_call() ) { return live_result; } 
#region Page Count and Ensure Face
	dial_text_page_c = string_count("[/page]", dial_text) + 1;
	dial_text_page = clamp(dial_text_page, 0, dial_text_page_c - 1);
	
	if ( dial_text_page_c > 1 ) { //Prevents out of bounds array reads
		var result = array_length(dial_face);
		if ( result < dial_text_page_c ) { 
			dial_face[dial_text_page_c - 1] = -1;
			dial_face_prev[dial_text_page_c - 1] = -1; 
			dial_face_original[dial_text_page_c - 1] = -1; 
			dial_face_name[dial_text_page_c - 1] = -1; 
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
	if ( keyboard_check_pressed(vk_escape) && is_undefined(soup_checkout("export dialogue", false)) ) {
		soup_store("export dialogue", true);
		soup_store("export dialogue func", function() { soup_store_clear(); SYSTEMUI.ui_paused = false; });
		
		var exportarr = [
			new LuiText({ value: "Ready to export your dialogue?", text_halign: fa_center, text_valign: fa_middle }),
			new LuiText({ value: "Select your export option!", text_halign: fa_center, text_valign: fa_middle }),
			
			new LuiButton({ text: "Static", height: 35, }).setTooltip("Export your dialogue as a static, non-animated screenshot.", true).addEvent(LUI_EV_CLICK, function(element_) {
				var maincan = soup_checkout("maincan"), mainfunc = soup_checkout("export dialogue func", false); maincan.destroy(); SYSTEMUI.ui_paused = false;
				soup_store("pageat", dial_text_page + 1); soup_store("bordout", bord_out); soup_store("bordvisible", bord_box_visible);
				
				#region Static Button Function
					var exportarr = [
						new LuiText({ value: "Select your static export type:", text_halign: fa_center, text_valign: fa_middle }),
						new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
							new LuiImageButton({ value: spr_export_icons, maintain_aspect: false, }).setSize(130, 130).setTooltip("Export just a standalone image of the chosen page.", true).addEvent(LUI_EV_CREATE, function(element_) { soup_store("export 1", element_); })
								.addEvent(LUI_EV_CLICK, function(element_) { soup_store("stacked", false); var option_ = soup_checkout("export 2", false); option_.setColor(#524664); element_.setColor(c_white); }),
							new LuiImageButton({ value: spr_export_icons, subimg: 1, maintain_aspect: false, }).setSize(130, 130).setTooltip("Export all your pages as one big stack.", true).addEvent(LUI_EV_CREATE, function(element_) { soup_store("export 2", element_); element_.setColor(#524664); soup_store("stacked", false); })
								.addEvent(LUI_EV_CLICK, function(element_) { soup_store("stacked", true); var option_ = soup_checkout("export 1", false); option_.setColor(#524664); element_.setColor(c_white); }),
						]),
						new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
							new LuiText({ value: "Start at page:", text_halign: fa_center, text_valign: fa_middle }),
							new LuiInput({ value: soup_checkout("pageat", false), input_mode: LUI_INPUT_MODE.numbers, offset: 12, }).bindVariable(global.soupstore, "pageat"),
						]),
						new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
							new LuiText({ value: "Border outline?", text_halign: fa_center, text_valign: fa_middle }),
							new LuiCheckbox({ value: soup_checkout("bordout", false), checkbox_spr: spr_gui_icons, checkbox_spr_index: 6, checkbox_clr: c_white, }).bindVariable(global.soupstore, "bordout"),
						]),
						new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
							new LuiText({ value: "Border visible?", text_halign: fa_center, text_valign: fa_middle }),
							new LuiCheckbox({ value: soup_checkout("bordvisible", false), checkbox_spr: spr_gui_icons, checkbox_spr_index: 6, checkbox_clr: c_white, }).bindVariable(global.soupstore, "bordvisible"),
						]),
						new LuiButton({ text: "Let's get soupy!!", height: 35, }).addEvent(LUI_EV_CLICK, function(element_) {
							var stacked_ = soup_checkout("stacked", false), page_ = soup_checkout("pageat", false), out_ = soup_checkout("bordout", false), vis_ = soup_checkout("bordvisible", false);
							var mainfunc = soup_checkout("export dialogue func", false), maincan = soup_checkout("maincan", false);
							//if ( is_undefined(stacked_) ) { SYSTEMUI.ui_paused = false; soupy_message("You haven't selected|an export option.", "Go Back", 200, , , , , , true); exit; }
							if ( page_ > SYSTEMUI.dial_text_page_c ) { SYSTEMUI.ui_paused = false; soupy_message("Starting page can't be greater|than your page count.", "Go Back", 300, , , , , , true); exit; }
							else if ( page_ == "" || page_ == 0 ) { page_ = 1; } 
						
							with ( SYSTEMUI ) { dial_text_page = real(page_ - 1); ui_export(stacked_); bord_box_visible = vis_; bord_out = out_; }
							mainfunc(); maincan.destroy();
						}),
					];
				#endregion
					
				var maincan = soupy_popup(exportarr, mainfunc, "Nevermind", 300, , , snd_select);
				soup_store("maincan", maincan);
			}),
			
			new LuiButton({ text: "Animated", height: 35, }).setTooltip("Your dialogue will be typed out, recorded, and exported as a GIF.", true).addEvent(LUI_EV_CLICK, function(element_) {
				var maincan = soup_checkout("maincan"), mainfunc = soup_checkout("export dialogue func", false); maincan.destroy(); SYSTEMUI.ui_paused = false;
				
				#region Animation Button Function
					var exportarr = [
						new LuiText({ value: "Select your animated export type:", text_halign: fa_center, text_valign: fa_middle }),
						new LuiRow().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.center).addContent([
							new LuiImageButton({ value: spr_export_icons, subimg: 2, maintain_aspect: false, }).setSize(130, 130).setTooltip("Enable the typewriter and watch\nas your dialogue plays out in sequence!", true).addEvent(LUI_EV_CREATE, function(element_) { soup_store("export 1", element_); })
								.addEvent(LUI_EV_CLICK, function(element_) { soup_store("typewrite", true); var option_ = soup_checkout("export 2", false); option_.setColor(#524664); element_.setColor(c_white); }),
							new LuiImageButton({ value: spr_export_icons, subimg: 3, maintain_aspect: false, }).setSize(130, 130).setTooltip("Animate the current page for a select amount of time.", true).addEvent(LUI_EV_CREATE, function(element_) { soup_store("export 2", element_); element_.setColor(#524664); soup_store("typewrite", true); })
								.addEvent(LUI_EV_CLICK, function(element_) { soup_store("typewrite", false); var option_ = soup_checkout("export 1", false); option_.setColor(#524664); element_.setColor(c_white); }),
						]),
						new LuiButton({ text: "Next", height: 35, }).addEvent(LUI_EV_CLICK, function(element_) {
							var typewrite = soup_checkout("typewrite", false);
							show_debug_message(typewrite);
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
#endregion