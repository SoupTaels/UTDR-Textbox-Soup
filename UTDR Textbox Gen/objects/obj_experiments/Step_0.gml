///@desc 
soupGUI.Update();

if ( keyboard_check_pressed(vk_f1) ) {
	var txt_ = soupGUI.TextboxGetText(textBox), txt_insert = "[commandpalettetest]", txt_insert_end = "[/]"
	var pos_ = soupGUI.TextboxGetPoint(textBox) + 1, pos_2 = soupGUI.TextboxGetPointSecondary(textBox) + 1;
	if ( pos_2 == pos_ ) { //Not trying to highlight anything
		var result = string_insert(txt_insert, txt_, pos_);
		soupGUI.TextboxSetText(textBox, result);
		soupGUI.TextboxSetPoint(textBox, ( pos_ + string_length(txt_insert) ) - 1);
	}
	else { //Between highlighted text
		var ending_ = pos_ > pos_2, pos_start = ending_ ? pos_2 : pos_, pos_end = ending_ ? pos_ : pos_2;
		var result = string_insert(txt_insert_end, txt_, pos_end), finalpos = pos_start - 1;
		result = string_insert(txt_insert, result, pos_start);
		soupGUI.TextboxSetText(textBox, result);
		soupGUI.TextboxSetPoint(textBox, finalpos);
		soupGUI.TextboxSetPointSecondary(textBox, finalpos);
	}
}