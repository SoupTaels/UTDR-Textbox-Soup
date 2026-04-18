// Feather ignore all

//Useful functions by Limekys (This script has MIT Licence)
#macro LIMEKYS_USEFUL_FUNCTIONS_VERSION "2025.08.14"

// Debug timers (used to test prerfomance)
// add DEBUG_INIT_TIMER before code you want to test
// add DEBUG_PRINT_TIMER after code you want to test
#macro DEBUG_INIT_TIMER var __debug_timer = get_timer()
#macro DEBUG_PRINT_TIMER print(string_format(((get_timer() - __debug_timer) / 1000000), 1, 8))

/**
* Function Description
* @param {real} value Description
* @param {real} destination Description
* @param {real} amount Description
* @returns {real} Description
*/
function Approach(value, destination, amount) {
	return (value + clamp(destination-value, -amount, amount));
}

/**
* Function Description
* @param {real} value Description
* @param {real} destination Description
* @param {real} amount Description
* @returns {real} Description
*/
function ApproachDelta(value, destination, amount) {
	return (value + clamp(destination-value, -amount*DT, amount*DT));
}

/**
* Function Description
* @param {real} value Description
* @param {real} destination Description
* @param {real} smoothness Description
* @param {real} [threshold]=0.01 Description
* @returns {real} Description
*/
function SmoothApproach(value, destination, smoothness, threshold = 0.01) {
	var _difference = destination - value;
	if (abs(_difference) < threshold) return destination;
	return lerp(value, destination, 1/smoothness);
}

/**
* Function Description
* @param {real} value Description
* @param {real} destination Description
* @param {real} smoothness Description
* @param {real} [threshold]=0.01 Description
* @returns {real} Description
*/
function SmoothApproachDelta(value, destination, smoothness, threshold = 0.01) {
	var _difference = destination - value;
	if (abs(_difference) < threshold) return destination;
	var _blend = power(0.5, 1/smoothness*DT);
	return lerp(destination, value, _blend);
}

/**
* Function Description
* @param {real} value Value between 0 - 1
* @returns {bool} True/False
*/
function Chance(value) {
	return value > random(1);
}

/**
* Returns a value that will wave back and forth between [from-to] over [duration] seconds based on current time Examples: image_angle = Wave(-45,45,1,0)  -> rock back and forth 90 degrees in a second x = Wave(-10,10,0.25,0)         -> move left and right quickly Or here is a fun one! Make an object be all squishy!! ^u^ image_xscale = Wave(0.5, 2.0, 1.0, 0.0) image_yscale = Wave(2.0, 0.5, 1.0, 0.0)
* @param {real} value1 Description
* @param {real} value2 Description
* @param {real} duration Description
* @param {real} offset Description
* @returns {real} Description
*/
function Wave(value1, value2, duration, offset) {
	var _a = (value2 - value1) * 0.5;
	return value1 + _a + sin((((current_time * 0.001) + duration * offset) / duration) * (pi*2)) * _a;
}

/**
* Function Description
* @param {Constant.Color} [color] Description
* @param {Asset.GMFont} [font] Description
* @param {Constant.Halign} [haling] Description
* @param {Constant.Valign} [valing] Description
* @param {real} [alpha] Description
*/
function DrawSetText(color = undefined, font = undefined, haling = undefined, valing = undefined, alpha = undefined) {
	if !is_undefined(color) 	draw_set_colour(color);
	if !is_undefined(font) 		draw_set_font(font);
	if !is_undefined(haling) 	draw_set_halign(haling);
	if !is_undefined(valing) 	draw_set_valign(valing);
	if !is_undefined(alpha) 	draw_set_alpha(alpha);
}

/**
* Draw text with outlines
* @param {real} x Coordinates to draw
* @param {real} y Coordinates to draw
* @param {string} _string String to draw
* @param {real} outwidth Width of outline in pixels
* @param {Constant.Color} outcolor Colour of outline (main text draws with regular set colour)
* @param {real} outfidelity Fidelity of outline (recommended: 4 for small, 8 for medium, 16 for larger. Watch your performance!)
*/
function DrawTextOutline(x, y, _string, outwidth, outcolor, outfidelity) {
	var _dto_dcol = draw_get_color();
	draw_set_color(outcolor);
	for(var dto_i = 45; dto_i < 405; dto_i += 360/outfidelity) {
		draw_text(x + lengthdir_x(outwidth, dto_i), y + lengthdir_y(outwidth, dto_i), _string);
	}
	draw_set_color(_dto_dcol);
	draw_text(x,y,_string);
}


/**
* Draw text with outlines transformed
* @param {real} x Coordinates to draw
* @param {real} y Coordinates to draw
* @param {string} _string String to draw
* @param {real} xscale Horizontal scale
* @param {real} yscale Vertical scale
* @param {real} outwidth Width of outline in pixels
* @param {Constant.Color} outcolor Colour of outline (main text draws with regular set colour)
* @param {real} outfidelity Fidelity of outline (recommended: 4 for small, 8 for medium, 16 for larger. Watch your performance!)
*/
function DrawTextOutlineTransformed(x, y, _string, xscale, yscale, outwidth, outcolor, outfidelity) {
	var _dto_dcol = draw_get_color();
	draw_set_color(outcolor);
	for(var dto_i = 45; dto_i < 405; dto_i += 360/outfidelity) {
		draw_text_transformed(x + lengthdir_x(outwidth, dto_i), y + lengthdir_y(outwidth, dto_i), _string, xscale, yscale, 0);
	}
	draw_set_color(_dto_dcol);
	draw_text_transformed(x,y,_string,xscale,yscale,0);
}

/**
* Function Description
* @param {real} x Description
* @param {real} y Description
* @param {string} _string Description
* @param {real} xscale Description
* @param {real} yscale Description
* @param {real} angle Description
* @param {real} outwidth Description
* @param {Constant.Color} outcolor Description
* @param {real} outfidelity Description
*/
function DrawTextOutlineTransformedExt(x, y, _string, xscale, yscale, angle, outwidth, outcolor, outfidelity) {
	var _dto_dcol = draw_get_color();
	draw_set_color(outcolor);
	for(var dto_i = 45; dto_i < 405; dto_i += 360/outfidelity) {
		draw_text_transformed(x + lengthdir_x(outwidth, dto_i), y + lengthdir_y(outwidth, dto_i), _string, xscale, yscale, angle);
	}
	draw_set_color(_dto_dcol);
	draw_text_transformed(x,y,_string,xscale,yscale,angle);
}

/**
* Function Description
* @param {real} x Description
* @param {real} y Description
* @param {string} _string Description
*/
function DrawTextShadow(x, y, _string) {
	var _colour = draw_get_colour();
	draw_set_colour(c_black);
	draw_text(x+1, y+1, _string);
	draw_set_colour(_colour);
	draw_text(x, y, _string);
}


/**
* example: DrawTextSoftShadow(10,10,"Hello World!", font_name, c_white, c_black, 0,5,6,0.01, );
* @param {real} x Description
* @param {real} y Description
* @param {string} _string Description
* @param {Asset.GMFont} font Description
* @param {real} offset_x Description
* @param {real} offset_y Description
* @param {real} blurfactor Description
* @param {Constant.Color} shadow_colour Description
* @param {real} shadow_strenght Description
* @param {Constant.Color} text_colour Description
*/
function DrawTextSoftShadow(x, y, _string, font, offset_x, offset_y, blurfactor, shadow_colour, shadow_strenght, text_colour) {
	draw_set_font(font);
	var _shadow_strenght_calc = shadow_strenght/(blurfactor * blurfactor)
	draw_set_alpha(_shadow_strenght_calc);
	draw_set_colour(shadow_colour);
	
	var _bx = blurfactor/2;
	var _by = blurfactor/2;

	for (var ix = 0; ix < blurfactor; ix++) {
		for (var iy = 0; iy < blurfactor; iy++) {
			draw_text((x-_bx) +offset_x + ix, (y-_by) +offset_y + iy, _string);
		}
	}
	draw_set_alpha(1);
	draw_set_colour(text_colour);
	draw_text(x, y, _string);
}

/**
* Function Description
* @param {real} x1 Description
* @param {real} y1 Description
* @param {real} x2 Description
* @param {real} y2 Description
* @param {real} width Description
* @param {bool} inside Description
* @param {bool} outline Description
*/
function DrawRectangleWidth(x1, y1, x2, y2, width, inside, outline) {
	if inside == false
	for (var i = 0; i < width; ++i) {
		draw_rectangle(x1-i,y1-i,x2+i,y2+i,outline);
	}
	else
	for (var i = 0; i < width; ++i) {
		draw_rectangle(x1+i,y1+i,x2-i,y2-i,outline);
	}
}

/**
* Returns string as a string with zeroes if it has fewer than nubmer characters eg StringZeroes(150,6) returns "000150" or StringZeroes(mins,2)+":"+StringZeroes(secs,2) might return "21:02" Created by Andrew McCluskey, use it freely
* @param {any} _string Description
* @param {real} nubmer Description
* @returns {string} Description
*/
function StringZeroes(_string, nubmer) {
	var _str = "";
	if string_length(string(_string)) < nubmer {
		repeat(nubmer-string_length(string(_string))) _str += "0";
	}
	_str += string(_string);
	return _str;
}

/**
* Function Description
* @param {real} x Center of circle
* @param {real} y Center of circle
* @param {real} radius Radius
* @param {real} bones Amount of bones. More bones = more quality, but less speed. Minimum — 3
* @param {real} angle Angle of first circle's point
* @param {real} angleadd Angle of last circle's point (relative to ang)
* @param {real} width Width of circle (may be positive or negative)
* @param {bool} outline False = curve, True = sector
*/
function DrawCircleCurve(x, y, radius, bones, angle, angleadd, width, outline) {
	bones = max(3,bones);
	
	var a,lp,lm,dp,dm,AAa,Wh;
	a = angleadd/bones;
	Wh = width/2;
	lp = radius+Wh;
	lm = radius-Wh;
	AAa = angle+angleadd;
	
	if outline {
		//OUTLINE
		draw_primitive_begin(pr_trianglestrip); //Change to pr_linestrip, to see how it works.
		draw_vertex(x+lengthdir_x(lm,angle),y+lengthdir_y(lm,angle)); //First point.
		for(var i=1; i<=bones; ++i)
		{
			dp = angle+a*i;
			dm = dp-a;
			draw_vertex(x+lengthdir_x(lp,dm),y+lengthdir_y(lp,dm));
			draw_vertex(x+lengthdir_x(lm,dp),y+lengthdir_y(lm,dp));
		}
		draw_vertex(x+lengthdir_x(lp,AAa),y+lengthdir_y(lp,AAa));
		draw_vertex(x+lengthdir_x(lm,AAa),y+lengthdir_y(lm,AAa)); //Last two points to make circle look right.
		//OUTLINE
	} else {
		//SECTOR
		draw_primitive_begin(pr_trianglefan); //Change to pr_linestrip, to see how it works.
		draw_vertex(x,y); //First point in the circle's center.
		for(var i=1; i<=bones; ++i)
		{
			dp = angle+a*i;
			dm = dp-a;
			draw_vertex(x+lengthdir_x(lp,dm),y+lengthdir_y(lp,dm));
		}
		draw_vertex(x+lengthdir_x(lp,AAa),y+lengthdir_y(lp,AAa)); //Last point.
		//SECTOR
	}
	draw_primitive_end();
}

/**
* Function Description
* @param {real} center_x Description
* @param {real} center_y Description
* @param {real} radius Description
* @param {real} start_ang Description
* @param {real} health Description
* @param {Asset.GMSprite} sprite Description
*/
function DrawHealthbarCircular(center_x, center_y, radius, start_ang, health, sprite) {
	var tex,steps,thick,oc;
	tex = sprite_get_texture(sprite,0);
	steps = 200;
	thick = sprite_get_height(sprite);

	if ceil(steps*(health/100)) >= 1 {
		
		oc = draw_get_color();
		draw_set_color(c_white);
		
		var step,ang,side,hps,hpd;
		step = 0;
		ang = start_ang;
		side = 0;
		draw_primitive_begin_texture(pr_trianglestrip,tex);
		draw_vertex_texture(center_x+lengthdir_x(radius-thick/2+thick*side,ang),center_y+lengthdir_y(radius-thick/2+thick*side,ang),side,side);
		side = !side;
		draw_vertex_texture(center_x+lengthdir_x(radius-thick/2+thick*side,ang),center_y+lengthdir_y(radius-thick/2+thick*side,ang),side,side);
		side = !side;
		draw_vertex_texture(center_x+lengthdir_x(radius-thick/2+thick*side,ang+360/steps),center_y+lengthdir_y(radius-thick/2+thick*side,ang+360/steps),side,side);
		side = !side;
		hps = health/(ceil(steps*(health/100))+1);
		hpd = 0;
		repeat ceil(steps*(health/100)+1) {
			step++;
			if step == ceil(steps*(health/100)+1) { //final step
				ang += (360/steps)*(health - hpd)/2;
				if ang>start_ang+360 ang=start_ang+360
				draw_vertex_texture(center_x+lengthdir_x(radius-thick/2+thick*side,ang),center_y+lengthdir_y(radius-thick/2+thick*side,ang),side,side);
				side = !side;
				draw_vertex_texture(center_x+lengthdir_x(radius-thick/2+thick*side,ang),center_y+lengthdir_y(radius-thick/2+thick*side,ang),side,side);
			}
			else {
				ang+=360/steps;
				draw_vertex_texture(center_x+lengthdir_x(radius-thick/2+thick*side,ang),center_y+lengthdir_y(radius-thick/2+thick*side,ang),side,side);
				side = !side;
			}
			hpd += hps;
		}
		draw_primitive_end();
		draw_set_color(oc);
	}
}

/**
* Function Description
* @param {string} _string Description
* @param {struct} struct Description
* @returns {string} Description
*/
function print_format(_string, struct) {
	var list = variable_struct_get_names(struct);
	for(var i = 0; i < array_length(list); i++){
		var find = "${"+list[i]+"}"
		_string = string_replace_all(_string, find, struct[$ list[i]]);
	}
	return _string;
}

/**
* Extended show_debug_message function
* @param {any} argument[0] Description
*/
function print() {
	var time = print_format("[${hour}:${minute}:${second}]",{
		hour: current_hour,
		minute: current_minute,
		second: current_second
	});
	var caller = print_format("[${caller}]",{caller: argument[0]});
	var msg = "";
	for(var i = 1; i < argument_count; i++){
		msg += string(argument[i]) + " ";
	}
	var result = time+caller+": "+msg;
	show_debug_message(result);
	//ds_list_insert(global.console_output, 0, result);
	//var file = file_text_open_append(global.LOG_FILE);
	//file_text_write_string(file,result);
	//file_text_writeln(file);
	//file_text_close(file);
}

/**
* Saves a successively numbered screenshot within the working directory Returns true on success, false otherwise. name prefix to assign screenshots, string folder subfolder to save to (eg. "screens\"), string
* @param {string} filename Filename
* @returns {bool} File is exists (True/False)
*/
function SaveScreenshot(filename) {
	var i = 0, _filename;
	
	if !directory_exists(working_directory + "Screenshots") directory_create(working_directory+"Screenshots");
	// If there is a file with the current name and number,
	// advance counter and keep looking:
	do {
		_filename = working_directory+"\\" + "Screenshots\\" + filename + "_" + string(i) + ".png";
		i++;
	} until (!file_exists(_filename));
	// Once we've got a unused number we'll save the screenshot under it:
	screen_save(_filename);
	return file_exists(_filename);
}

/**
* Returns the background data captured on the screen which can then be drawn later on.
* @returns {Asset.GMSprite} Description
*/
function MakeScreenshot() {
	var _ret = -1;
	var _sfc_width = surface_get_width(application_surface);
	var _sfc_height = surface_get_height(application_surface);

	// Create drawing surface
	var _sfc = surface_create(_sfc_width,_sfc_height);
	surface_set_target(_sfc);
	// Clear screen;
	// Both draw_clear and draw_rectangle will clear your screen BUT
	// on some systems, it creates ghostly images, for example, when
	// sprites are animated. To prevent those images, both are used.
	var _gpu_cwe = gpu_get_colorwriteenable();
	gpu_set_colorwriteenable(true, true, true, true);
	draw_clear_alpha(c_white, 0);
	draw_rectangle_colour(0,0,_sfc_width,_sfc_height,c_black,c_black,c_black,c_black,false);
	gpu_set_colorwriteenable(true, true, true, false);
	// Capture screen
	draw_surface(application_surface,0,0);
	_ret = sprite_create_from_surface(_sfc, 0, 0, _sfc_width, _sfc_height, false, false, 0, 0);
	// Finalise drawing process and clear surface from memory
	surface_reset_target();
	gpu_set_colorwriteenable(_gpu_cwe[0], _gpu_cwe[1], _gpu_cwe[2], _gpu_cwe[3]);
	surface_free(_sfc);

	return _ret;
}

/**
* Function Description
* @param {Asset.GMSprite} sprite Description
* @param {real} subimg Description
* @param {real} x Description
* @param {real} y Description
* @param {real} [xscale]=1 Description
* @param {real} [yscale]=1 Description
* @param {real} [rotation]=0 Description
* @param {Constant.Color} [color]=c_white Description
* @param {real} [alpha]=1 Description
* @param {real} [x_offset]=0 Description
* @param {real} [y_offset]=0 Description
*/
function DrawSpriteOffset(sprite, subimg, x, y, xscale = 1, yscale = 1, rotation = 0, color = c_white, alpha = 1, x_offset = 0, y_offset = 0) {
	//Calculate rotation
	var _c = dcos(rotation);
	var _s = dsin(rotation);
	var _rot_x = _c * x_offset + _s * y_offset;
	var _rot_y = _c * y_offset - _s * x_offset;
	//Draw
	draw_sprite_ext(sprite, subimg, x - _rot_x, y - _rot_y, xscale, yscale, rotation, color, alpha);
}

/**
* Function Description
* @param {real} x Description
* @param {real} y Description
* @param {string} text Description
* @param {Asset.GMSprite} sprite_shadow Description
*/
function DrawTextSpriteShadow(x, y, text, sprite_shadow) {
	var _txt_w = string_width(text) + 70;
	//var _txt_h = string_height(_text);
	
	draw_sprite_stretched_ext(sprite_shadow, 0, x - _txt_w/2, y - 44, _txt_w, 88, c_white, 0.5);
	draw_text(x, y, text);
}

/**
* Returns new range from old range
* @param {real} value Description
* @param {real} old_min Description
* @param {real} old_max Description
* @param {real} new_min Description
* @param {real} new_max Description
*/
function Range(value, old_min, old_max, new_min, new_max) {
	return ((value - old_min) / (old_max - old_min)) * (new_max - new_min) + new_min;
}

/**
* Function Description
* @param {string} name Description
* @param {real} seconds Description
* @param {function} _function Description
* @param {real} [start_from]=0 Description
*/
function IntervalUpdateFunction(name, seconds, _function, start_from = 0) {
	var n1 = name + "_interval";
	var n2 = name + "_interval_lenght";
	if !variable_instance_exists(self, n1) self[$ n1] = start_from;
	if !variable_instance_exists(self, n2) self[$ n2] = seconds;
	
	self[$ n1] += DT;
	if self[$ n1] >= self[$ n2] {
		self[$ n1] -= self[$ n2];
		_function();
	}
}

/**
* Custom array shuffle
* @param {array<any>} array Description
*/
function ArrayShuffle(array) {
	var _size = array_length(array), i, j, k;
	for (i = 0; i < _size; i++)
	{
		j = irandom_range(i, _size - 1);
		if (i != j)
		{
			k = array[i];
			array[i] = array[j];
			array[j] = k;
		}
	}
}

/**
* Draws a sprite with a fill in the circle (by YAL)
* @param {asset.gmsprite} _sprite Sprite asset
* @param {real} _subimg image index
* @param {real} _value 0.0 - 1.0
* @param {real} _x x coordinate to draw
* @param {real} _y y coordinate to draw
* @param {real} _xscale horizontal scale
* @param {real} _yscale vertical scale
* @param {constant.color} _color color
* @param {real} _alpha alpha
* @param {bool} [_uncrop]=true indicates whether the sprite is cropped and should be measured to avoid drawing the polygon bigger than it should be.
*/
function drawSpriteRadial(_sprite, _subimg, _value, _x, _y, _xscale, _yscale, _color, _alpha, _uncrop = true) {
	var _x1, _y1, _x2, _y2;
	if (_uncrop) {
		var _ox = sprite_get_xoffset(_sprite);
		var _oy = sprite_get_yoffset(_sprite);
		_x1 = _x + _xscale * (sprite_get_bbox_left(_sprite) - _ox);
		_x2 = _x + _xscale * (sprite_get_bbox_right(_sprite) + 1 - _ox);
		_y1 = _y + _yscale * (sprite_get_bbox_top(_sprite) - _oy);
		_y2 = _y + _yscale * (sprite_get_bbox_bottom(_sprite) + 1 - _oy);
	} else {
		_x1 =  _x - _xscale * sprite_get_xoffset(_sprite);
		_x2 = _x1 + _xscale * sprite_get_width(_sprite);
		_y1 = _y -  _yscale * sprite_get_yoffset(_sprite);
		_y2 = _y1 + _yscale * sprite_get_height(_sprite);
	}
	drawTextureRadial(sprite_get_texture(_sprite, _subimg), _value, _x1, _y1, _x2, _y2, _color, _alpha);
}

/**
* Draws a texture with a fill in the circle (by YAL)
* @param {pointer.texture} _tex Description
* @param {real} _value Description
* @param {real} _x1 Description
* @param {real} _y1 Description
* @param {real} _x2 Description
* @param {real} _y2 Description
* @param {constant.color} _color Description
* @param {real} _alpha Description
*/
function drawTextureRadial(_tex, _value, _x1, _y1, _x2, _y2, _color, _alpha) {
	if (_value <= 0) exit;
	if (_value >= 1) {
		draw_primitive_begin_texture(pr_trianglelist, _tex);
		draw_vertex_texture_color(_x1, _y1, 0, 0, _color, _alpha);
		repeat (2) {
			draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
			draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
		}
		draw_vertex_texture_color(_x2, _y2, 1, 1, _color, _alpha);
		draw_primitive_end();
		exit;
	}
	
	// middle point:
	var _mx = (_x1 + _x2) / 2;
	var _my = (_y1 + _y2) / 2;
	draw_primitive_begin_texture(pr_trianglelist, _tex);
	draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
	draw_vertex_texture_color(_mx, _y1, 0.5, 0, _color, _alpha);
	
	// corners, each of these finishes the last triangle and starts a new one:
	if (_value >= 1/8) {
		draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
		//
		draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
		draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
	}
	if (_value >= 3/8) {
		draw_vertex_texture_color(_x2, _y2, 1, 1, _color, _alpha);
		//
		draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
		draw_vertex_texture_color(_x2, _y2, 1, 1, _color, _alpha);
	}
	if (_value >= 5/8) {
		draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
		//
		draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
		draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
	}
	if (_value >= 7/8) {
		draw_vertex_texture_color(_x1, _y1, 0, 0, _color, _alpha);
		//
		draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
		draw_vertex_texture_color(_x1, _y1, 0, 0, _color, _alpha);
	}
	
	// final vertex (towards value-angle):
	var _dir = pi * (_value * 2 - 0.5);
	var _dx = cos(_dir);
	var _dy = sin(_dir);
	// normalize:
	var _dmax = max(abs(_dx), abs(_dy));
	if (_dmax < 1) {
		_dx /= _dmax;
		_dy /= _dmax;
	}
	//
	_dx = (1 + _dx) / 2;
	_dy = (1 + _dy) / 2;
	draw_vertex_texture_color(
		lerp(_x1, _x2, _dx), lerp(_y1, _y2, _dy),
		_dx, _dy, _color, _alpha
	);
	draw_primitive_end();
}

// Helper function to copy a struct
function struct_copy(_struct) {
	var _copy = {};
	var names = variable_struct_get_names(_struct);
	for (var i = 0; i < array_length(names); i++) {
		_copy[$ names[i]] = _struct[$ names[i]];
	}
	return _copy;
}

// Helper function to merge two structs (overwrites defaults with new values)
function struct_merge(_default, _new) {
	var _result = struct_copy(_default);
	var names = variable_struct_get_names(_new);
	for (var i = 0; i < array_length(names); i++) {
		_result[$ names[i]] = _new[$ names[i]];
	}
	return _result;
}

///@desc Return true if string is unsigned integer number
function string_is_uint(_string) {
	var n = string_length(string_digits(_string));
	return n > 0 && n == string_length(_string);
}

///@desc Return true if string is signed integer number
function string_is_int(_string) {
	var n = string_length(string_digits(_string));
	return n > 0 && n == string_length(_string) - (string_ord_at(_string, 1) == ord("-"));
}

///@desc Return true if string is real number
function string_is_real(_string) {
	var n = string_length(string_digits(_string));
	return n > 0 && n == string_length(_string) - (string_ord_at(_string, 1) == ord("-")) - (string_pos(".", _string) != 0);
}

///@desc Return true if string is real exponential number
function string_is_real_exp(_string) {
	var s = argument0;
	var n = string_length(string_digits(_string));
	var p = string_pos(".", _string);
	var e = string_pos("e", _string);
	switch (e) {
	    case 0: break; // ok!
	    case 1: return false; // "e#"
	    case 2: if (p > 0) return false; break; // ".e#" or "1e."
	    default: if (p > 0 && e < p) return false; break; // "1e3.3"
	}
	return n && n == string_length(_string) - (string_char_at(_string, 1) == "-") - (p != 0) - (e != 0);
}

