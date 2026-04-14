function TextChange(txt) : UndoableChange() constructor {
	prev_txt = obj_system.dial_text;
	prev_box = obj_system.inputbox.get_text();
	mytxt = txt;
	
	static apply = function() {
		obj_system.dial_text = mytxt;
		audio_play_sound(snd_equip, 0, false);
    }

    static undo = function() {
		with ( obj_system ) { dial_text = other.prev_txt; keyboard_string = dial_text; audio_play_sound(snd_cancel, 0, false); }
	}
}