function text_outliner_shitty(x_, y_, line_sp, wrap_) {
	#region Main
		var scrib_dial = scribble(dial_text).starting_format(dial_font, dial_text_outline).scale(dial_text_scale).line_spacing(line_sp).page(dial_text_page).wrap(wrap_)
		.draw(x_ + dial_text_outline_thick, y_, dial_text_gif ? typist : undefined); //Right
		var scrib_dial = scribble(dial_text).starting_format(dial_font, dial_text_outline).scale(dial_text_scale).line_spacing(line_sp).page(dial_text_page).wrap(wrap_)
		.draw(x_ - dial_text_outline_thick, y_, dial_text_gif ? typist : undefined); //Left
		var scrib_dial = scribble(dial_text).starting_format(dial_font, dial_text_outline).scale(dial_text_scale).line_spacing(line_sp).page(dial_text_page).wrap(wrap_)
		.draw(x_, y_ + dial_text_outline_thick, dial_text_gif ? typist : undefined); //Up
		var scrib_dial = scribble(dial_text).starting_format(dial_font, dial_text_outline).scale(dial_text_scale).line_spacing(line_sp).page(dial_text_page).wrap(wrap_)
		.draw(x_, y_ - dial_text_outline_thick, dial_text_gif ? typist : undefined); //Down
	#endregion
	#region Corners
		var scrib_dial = scribble(dial_text).starting_format(dial_font, dial_text_outline).scale(dial_text_scale).line_spacing(line_sp).page(dial_text_page).wrap(wrap_)
		.draw(x_ + dial_text_outline_thick, y_ - dial_text_outline_thick, dial_text_gif ? typist : undefined); //Left Up
		var scrib_dial = scribble(dial_text).starting_format(dial_font, dial_text_outline).scale(dial_text_scale).line_spacing(line_sp).page(dial_text_page).wrap(wrap_)
		.draw(x_ + dial_text_outline_thick, y_ + dial_text_outline_thick, dial_text_gif ? typist : undefined); //Left Down
		var scrib_dial = scribble(dial_text).starting_format(dial_font, dial_text_outline).scale(dial_text_scale).line_spacing(line_sp).page(dial_text_page).wrap(wrap_)
		.draw(x_ - dial_text_outline_thick, y_ + dial_text_outline_thick, dial_text_gif ? typist : undefined); //Right Down
		var scrib_dial = scribble(dial_text).starting_format(dial_font, dial_text_outline).scale(dial_text_scale).line_spacing(line_sp).page(dial_text_page).wrap(wrap_)
		.draw(x_ - dial_text_outline_thick, y_ - dial_text_outline_thick, dial_text_gif ? typist : undefined); //Right Up
	#endregion
}

function text_outliner_shitty_point(x_, y_) {
	#region Main
		var scrib_point = scribble(dial_point_chr) //Dialogue Point
		.starting_format(dial_font, dial_text_outline).scale(dial_text_scale)
		.draw(x_ - dial_text_outline_thick, y_) //Left
		var scrib_point = scribble(dial_point_chr) //Dialogue Point
		.starting_format(dial_font, dial_text_outline).scale(dial_text_scale)
		.draw(x_ + dial_text_outline_thick, y_) //Right
		var scrib_point = scribble(dial_point_chr) //Dialogue Point
		.starting_format(dial_font, dial_text_outline).scale(dial_text_scale)
		.draw(x_, y_ - dial_text_outline_thick) //Up
		var scrib_point = scribble(dial_point_chr) //Dialogue Point
		.starting_format(dial_font, dial_text_outline).scale(dial_text_scale)
		.draw(x_, y_ + dial_text_outline_thick) //Down
	#endregion
	#region Corners
		var scrib_point = scribble(dial_point_chr) //Dialogue Point
		.starting_format(dial_font, dial_text_outline).scale(dial_text_scale)
		.draw(x_ - dial_text_outline_thick, y_ - dial_text_outline_thick) //Left Up
		var scrib_point = scribble(dial_point_chr) //Dialogue Point
		.starting_format(dial_font, dial_text_outline).scale(dial_text_scale)
		.draw(x_ - dial_text_outline_thick, y_ + dial_text_outline_thick) //Left Down
		var scrib_point = scribble(dial_point_chr) //Dialogue Point
		.starting_format(dial_font, dial_text_outline).scale(dial_text_scale)
		.draw(x_ + dial_text_outline_thick, y_ - dial_text_outline_thick) //Right Up
		var scrib_point = scribble(dial_point_chr) //Dialogue Point
		.starting_format(dial_font, dial_text_outline).scale(dial_text_scale)
		.draw(x_ + dial_text_outline_thick, y_ + dial_text_outline_thick) //Right Down
	#endregion
}