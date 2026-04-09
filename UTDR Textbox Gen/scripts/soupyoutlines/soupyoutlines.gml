#region Soupy Outlines
	///@desc Initalizes an outline surface and shader.
	///@param {real} r_ Outline's red color channel (0 - 255)
	///@param {real} g_ Outline's blue color channel (0 - 255)
	///@param {real} b_ Outline's green color channel (0 - 255)
	///@param {real} a_ Outline's opacity
	///@param {real} thick_ Outline's thickness. The higher the value, the more you start to see the outline's sprite copies separating.
	///@param {bool} extrathick_ Whether to copy sprites in 8 directions or 4 to create this outline trick
	function outlinesoup_init(r_ = 0, g_ = 0, b_ = 0, a_ = 1, thick_ = 1, extrathick_ = true)
	{
		out_shader = shd_outliner;
		out_handler = shader_get_uniform(out_shader, "outtext"); //Outline Texture
		out_u_thick = shader_get_uniform(out_shader, "outthick"); //Outline Thickness
		out_u_color = shader_get_uniform(out_shader, "outcol"); //Outline Color
		out_u_thicker = shader_get_uniform(out_shader, "outthicker"); //Outline Extra Thickness (8-directional outlines or 4)

		out_color = outlinesoup_color(r_, g_, b_, a_); //Outline Color (R, G, B, A)
		out_thick = thick_; //Outline Thickness
		out_thicc = extrathick_; //Outline Extra Thickness?
		out_surf = -1; //Outline Surface
	}

	///@desc Converts RGB values to be a value between 0 and 1.
	///@param {real} r_ Outline's red color channel (0 - 255)
	///@param {real} g_ Outline's blue color channel (0 - 255)
	///@param {real} b_ Outline's green color channel (0 - 255)
	///@param {real} a_ Outline's opacity
	function outlinesoup_color(r_, g_, b_, a_) { return [r_ / 255, g_ / 255, b_ / 255, a_]; }

	///@desc Sets the outline color dynamically
	///@param {real} r_ Outline's red color channel (0 - 255)
	///@param {real} g_ Outline's blue color channel (0 - 255)
	///@param {real} b_ Outline's green color channel (0 - 255)
	///@param {real} a_ Outline's opacity
	function outlinesoup_blend(r_= 255, g_ = 255, b_ = 255, a_ = 1) { out_color = outlinesoup_color(r_, g_, b_, a_); } //Outline Color (R, G, B, A)

	///@desc Makes sure a surface is always present for the outline.
	function outlinesoup_step(w_ = room_width, h_ = room_height)
	{
		if ( !surface_exists(out_surf) ) { out_surf = surface_create(w_, h_); }
		/*
		Reason why we're using a surface is cause I shouldn't have to add unneccessary
		padding to my sprites just so their outline doesn't get cut off in places, but also so that
		we can have as many sprites get an outline without having to pass in multiple sprite textures
		and such. It's just easier in general.
		*/
	}

	///@desc Cleans up the outline surface
	function outlinesoup_cleanup()
	{
		if ( surface_exists(out_surf) ) { surface_free(out_surf); show_debug_message($"OUTLINE SURFACE FOR {asset_get_name(id.object_index)}(ID: {id}) CLEARED"); }
	}

	///@desc Starting draw function for the outline. Everything in the draw event you want to have an outline should be called for after this function.
	function outlinesoup_start()
	{
		//Outline Surface
		if ( out_color[3] > 0 ) {
			if ( surface_exists(out_surf) ) {
				surface_set_target(out_surf);
				draw_clear_alpha(c_black, 0);
			}
		}
	}

	///@desc Ending draw function for the outline. Everything in the draw event you want to have an outline should be called for before this function.
	function outlinesoup_end(overrideR = -1, overrideG = -1, overrideB = -1, overrideA = -1, overrideThick = -1, overrideThicc = -1, overrideScaleX = 1, overrideScaleY = 1, overrideSurfAlpha = 1, overrideX = 0, overrideY = 0)
	{
		if ( out_color[3] > 0 ) {
			if ( surface_exists(out_surf) ) {
				surface_reset_target();
				//Outline Shader
				shader_set(out_shader);

				var tex = surface_get_texture(out_surf);
				var tex_w = texture_get_texel_width(tex);
				var tex_h = texture_get_texel_height(tex);

				shader_set_uniform_f(out_handler, tex_w, tex_h); // Outline Texture
				shader_set_uniform_f(out_u_thick, overrideThick = -1 ? out_thick : overrideThick); //Outline Thickness
				shader_set_uniform_f(out_u_thicker, overrideThicc = -1 ? out_thicc : overrideThicc); //Outline Extra Thickness
				var getr = overrideR = -1 ? out_color[0] : ( overrideR * 255 ) / 255;
				var getg = overrideG = -1 ? out_color[1] : ( overrideG * 255 ) / 255;
				var getb = overrideB = -1 ? out_color[2] : ( overrideB * 255 ) / 255;
				var geta = overrideA = -1 ? out_color[3] : ( overrideA * 255 ) / 255;
				shader_set_uniform_f(out_u_color, getr, getg, getb, geta); //Outline Color

				draw_surface_ext(out_surf, overrideX, overrideY, overrideScaleX, overrideScaleY, 0, c_white, overrideSurfAlpha); //Give everything drawn to this surface an outline

				shader_reset();
			}
		}
	}
#endregion