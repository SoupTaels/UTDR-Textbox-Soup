///@desc Init
live_auto_call_nr
#region Dialogue Box
	spr_bord = spr_border_undertale; //Border Sprite
	bord_clr = c_white; //Border Color
#endregion

#region Dialogue Text
	dial_text = "* Test dialogue text 1, 2, 3.....\n* Test dialogue text 4, 5, 6.....\n* Test dialogue text 7, 8, 9....."; //Dialogue Text
	dial_font = "DEFAULT"; //Dialogue Font
	dial_text_scale = 2; //Text Scale
	
	dial_point_auto = true; //Whether to automatically add points
	dial_point_chr = "*"; //Dialogue Point Character
	dial_point_clr = c_white; //Dialogue Point Clr
	dial_auto_wrap = true; //Whether to automatically wrap dialogue to new lines
#endregion

#region Dialogue Shadow
	dial_text_shdw = true; //Whether text should have a shadow
	dial_text_shdw_clr = #040478; //Shadow Color
	dial_text_shdw_thick = 1; //Shadow Thickness
#endregion

#region Dialogue Face
	dial_face = -1; //Dialogue Face
	dial_face_index = 0; //Dialogue Face Frame
	dial_face_clr = c_white; //Dialogue Face Clr
#endregion


if ( !scribble_font_exists("DEFAULT") ) { scribble_font_bake_outline_and_shadow("fnt_determination", "DEFAULT", 1, 1, SCRIBBLE_OUTLINE.NO_OUTLINE, 1, false); }
scribble_font_set_default("DEFAULT"); //Use the normal dialogue font by default when using Scribble