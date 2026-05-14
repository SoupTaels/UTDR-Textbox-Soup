
//var result = get_open_filename_ext("Image File (.PNG Only)|*.png", "", directory_get_pictures_path(), "Select a sprite to import.");
//FACE_CURRENT = result;

//bord_clr = get_color_ext(c_white, "Change dialogue box color:");*/
/*var arr_ = [];
var credits_add = method({ arr_ }, function(text_ = "", link_ = "", scribble_ = false) {
	array_push(arr_, new LuiText({ scribbletext: scribble_, value: text_, text_halign: fa_center, text_valign: fa_middle, font: fnt_abaddon, color: c_white, xoff: 0, y: 10 }).setData("link", link_).setTooltip(link_, true, fnt_abaddon).setPadding(5)
	.addEvent(LUI_EV_CLICK, function(element_) { var link_ = element_.getData("link"); if ( link_ != "" ) { sfx_play(snd_select); execute_shell_simple(link_); } })
	.addEvent(LUI_EV_MOUSE_ENTER, function(element_) { var link_ = element_.getData("link"); if ( link_ != "" ) { element_.color = c_cyan; sfx_play(snd_sel_switch); element_.main_ui.animate(element_, "xoff", 10, 0.30, global.Ease.OutBack, 0); } })
	.addEvent(LUI_EV_MOUSE_LEAVE, function(element_) { element_.color = c_white; element_.main_ui.animate(element_, "xoff", 0, 0.15); }));
});
credits_add("[c_yellow][wobble]Credits:", , true);
credits_add(".+\\/\\/\\_______________________________________________/\\/\\/+.");
credits_add();
credits_add("Scribble, Clean Shapes, Gumshoe: JujuAdams", "https://github.com/JujuAdams");
credits_add("GMLive, ExecuteShellSimple, FileDropper: YellowAfterlife", "https://yal.cc/");
credits_add("TweenGMX: stephenloney", "https://stephenloney.com/");
credits_add("Undo Stack: alphish-creature(Alice)", "https://github.com/Alphish");
credits_add("LimeUI: Limekys", "https://github.com/Limekys");
credits_add("Quill: RefresherTowelGames", "https://github.com/RefresherTowel");
credits_add("DialogModule, FileManager: Samuel Venable", "https://itch.io/profile/samuel-venable");
credits_add("Undertale, Deltarune: Toby Fox [annoyingdog,0,0.15], Temmie Chang [annoyingtem,0,0.15]", "https://undertale.com/about/", true);
credits_add("Made in GameMaker [scale,0.15][gamemaker][/]", "https://gamemaker.io/", true);
credits_add();
credits_add("Huge thanks to [rainbow][wheel]Juju Adams[/][wheel] [scale,0.3][jujugoodpug][/] especially as this wouldn't\nhave been possible without his tools!", , true);
credits_add();
credits_add("Happy generating by yours truly, Soup Taels!", "https://souptaels.carrd.co/");
array_push(arr_, new LuiRow().setFlexJustifyContent(flexpanel_justify.center).addContent([
	new LuiImage({ value: spr_soul, color: #ed4577, draw_normal: true, y: 10 }).setSize(20, 16).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 1, 0.15, , 1.3); element_.main_ui.animate(element_, "yscale", 1, 0.15, , 1.3); sfx_play(snd_bump); }),
	new LuiImage({ value: get_icon("tinysoupy"), draw_normal: true, y: 10 }).setSize(19, 19).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 1, 0.15, , 0.5); element_.main_ui.animate(element_, "yscale", 1, 0.15, , 1.5); sfx_play(snd_squish); }),
	new LuiImage({ value: spr_soul, color: #ed4577, draw_normal: true, y: 10 }).setSize(20, 16).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function(element_) { element_.main_ui.animate(element_, "xscale", 1, 0.15, , 1.3); element_.main_ui.animate(element_, "yscale", 1, 0.15, , 1.3); sfx_play(snd_bump); }),
]));
soupy_popup(arr_, , "What lovely people!", , , , snd_chest, fnt_abaddon); //Credits with clickable text links
