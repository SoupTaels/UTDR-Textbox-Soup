// Feather ignore all

/*
	It is safe to delete Any function from this script
	or to delete this whole script entirely
*/

var _; // USED TO HIDE SYNTAX WARNINGS FOR NON-FEATHER ENVIRONMENT

/// @function TweenEasyMove( x1, y1, x2, y2, delay, duration, ease, [mode] )
/// @description Eases x|y position over a duration of time
/// @param {Any} x1			start x position
/// @param {Any} y1			start y position
/// @param {Any} x2			destination x position
/// @param {Any} y2			destination y position
/// @param {Any} delay		delay before starting tween in steps/seconds
/// @param {Any} duration	duration of time play tween steps/seconds
/// @param {Any} ease		easing algorithm to use
/// @param {Any} [mode]		tween play mode to use (default=0, "once", TWEEN_MODE_ONCE)
function TweenEasyMove(_x1, _y1, _x2, _y2, _delay, _duration, _ease, _mode=0)
{	
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	
	if (variable_instance_exists(self, "__TweenEasyMove") && TweenExists(__TweenEasyMove))
	{
		TweenDestroy(__TweenEasyMove);
	}
	
	if (argument_count > 8)
	{
		var _args = [self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "x", _x1, _x2, "y", _y1, _y2];
		var i = 7; repeat(argument_count-8) { array_push(_args, argument[++i]); }
		__TweenEasyMove = script_execute_ext(TweenFire, _args);
	}
	else
	{
		__TweenEasyMove = TweenFire(self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "x", _x1, _x2, "y", _y1, _y2);	
	}

	return __TweenEasyMove;
}_=TweenEasyMove;


/// @function TweenEasyScale( x1, y1, x2, y2, delay, duration, ease, [mode] ) 
/// @description Eases image x|y scale over a duration of time
/// @param {Any} x1
/// @param {Any} y1
/// @param {Any} x2
/// @param {Any} y2
/// @param {Any} delay
/// @param {Any} duration
/// @param {Any} ease
/// @param {Any} [mode]
function TweenEasyScale(_x1, _y1, _x2, _y2, _delay, _duration, _ease, _mode=0) 
{
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	
	if (variable_instance_exists(self, "__TweenEasyScale") && TweenExists(__TweenEasyScale))
	{
		TweenDestroy(__TweenEasyScale);
	}
	
	if (argument_count > 8)
	{
		var _args = [self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "image_xscale", _x1, _x2, "image_yscale", _y1, _y2];
		var i = 7; repeat(argument_count-8) { array_push(_args, argument[++i]); }
		__TweenEasyScale = script_execute_ext(TweenFire, _args);
	}
	else
	{
		__TweenEasyScale = TweenFire(self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "image_xscale", _x1, _x2, "image_yscale", _y1, _y2);
	}
	
	return __TweenEasyScale;
}_=TweenEasyScale;


/// @function TweenEasyRotate( angle1, angle2, delay, duration, ease, [mode] )
/// @description Eases image angle over a duration of time
/// @param {Any} angle1
/// @param {Any} angle2
/// @param {Any} delay
/// @param {Any} duration
/// @param {Any} ease
/// @param {Any} [mode]
function TweenEasyRotate(_angle1, _angle2, _delay, _duration, _ease, _mode=0)
{
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	
	if (variable_instance_exists(self, "__TweenEasyRotate") && TweenExists(__TweenEasyRotate))
	{
		TweenDestroy(__TweenEasyRotate);
	}

	if (argument_count > 6)
	{
		var _args = [self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "image_angle", _angle1, _angle2];
		var i = 5; repeat(argument_count-6) { array_push(_args, argument[++i]); }
		__TweenEasyRotate = script_execute_ext(TweenFire, _args);
	}
	else
	{
		__TweenEasyRotate = TweenFire(self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "image_angle", _angle1, _angle2);
	}
	
	return __TweenEasyRotate;
}_=TweenEasyRotate;


/// @function TweenEasyFade( alpha1, alpha2, delay, duration, ease, [mode] )
/// @description Eases image alpha over a duration of time
/// @param {Any} alpha1
/// @param {Any} alpha2
/// @param {Any} delay
/// @param {Any} duration
/// @param {Any} ease
/// @param {Any} [mode]
function TweenEasyFade(_alpha1, _alpha2, _delay, _duration, _ease, _mode=0)
{
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	
	if (variable_instance_exists(self, "__TweenEasyFade") && TweenExists(__TweenEasyFade))
	{
		TweenDestroy(__TweenEasyFade);
	}

	if (argument_count > 6)
	{
		var _args = [self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "image_alpha", _alpha1, _alpha2];
		var i = 5; repeat(argument_count-6) { array_push(_args, argument[++i]); }
		__TweenEasyFade = script_execute_ext(TweenFire, _args);
	}
	else
	{
		__TweenEasyFade = TweenFire(self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "image_alpha", _alpha1, _alpha2);
	}
	
	return __TweenEasyFade;
}_=TweenEasyFade;


/// @function TweenEasyBlend( col1, col2, delay, duration, ease, [mode] )
/// @description Eases image blend over a duration of time
/// @param {Any} col1
/// @param {Any} col2
/// @param {Any} delay
/// @param {Any} duration
/// @param {Any} ease
/// @param {Any} [mode]
function TweenEasyBlend(_col1, _col2, _delay, _duration, _ease, _mode=0)
{	
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	
	if (variable_instance_exists(self, "__TweenEasyBlend") && TweenExists(__TweenEasyBlend))
	{
		TweenDestroy(__TweenEasyBlend);
	}
	
	if (argument_count > 6)
	{
		var _args = [self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "image_blend", _col1, _col2];
		var i = 5; repeat(argument_count-6) { array_push(_args, argument[++i]); }
		__TweenEasyBlend = script_execute_ext(TweenFire, _args);
	}
	else
	{
		__TweenEasyBlend = TweenFire(self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "image_blend", _col1, _col2);
	}
	
	return __TweenEasyBlend;
}_=TweenEasyBlend;


/// @function TweenEasyImage( index1, index2, delay, duration, ease, [mode] ) 
/// @description Eases image index over a duration of time
/// @param {Any} index1
/// @param {Any} index2
/// @param {Any} delay
/// @param {Any} duration
/// @param {Any} ease
/// @param {Any} [mode]
function TweenEasyImage(_index1, _index2, _delay, _duration, _ease, _mode=0) 
{	
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	
	if (variable_instance_exists(self, "__TweenEasyImage") && TweenExists(__TweenEasyImage))
	{
		TweenDestroy(__TweenEasyImage);
	}

	if (argument_count > 6)
	{
		var _args = [self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "image_index", _index1, _index2];
		var i = 5; repeat(argument_count-6) { array_push(_args, argument[++i]); }
		__TweenEasyImage = script_execute_ext(TweenFire, _args);
	}
	else
	{
		__TweenEasyImage = TweenFire(self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "image_index", _index1, _index2);
	}
	
	return __TweenEasyImage;
}_=TweenEasyImage;


/// @function TweenEasyTurn( dir1, dir2, delay, duration, ease, [mode] )
/// @description Eases direction over a duration of time
/// @param {Any} dir1
/// @param {Any} dir2
/// @param {Any} delay
/// @param {Any} duration
/// @param {Any} ease
/// @param {Any} [mode]
function TweenEasyTurn(_dir1, _dir2, _delay, _duration, _ease, _mode=0)
{
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	
	if (variable_instance_exists(self, "__TweenEasyTurn") && TweenExists(__TweenEasyTurn))
	{
		TweenDestroy(__TweenEasyTurn);
	}

	if (argument_count > 6)
	{
		var _args = [self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "direction", _dir1, _dir2];
		var i = 5; repeat(argument_count-6) { array_push(_args, argument[++i]); }
		__TweenEasyTurn = script_execute_ext(TweenFire, _args);
	}
	else
	{
		__TweenEasyTurn = TweenFire(self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "direction", _dir1, _dir2);
	}
	
	return __TweenEasyTurn;
}_=TweenEasyTurn;


/// @function TweenEasySpeed( spd1, spd2, delay, duration, ease, [mode] )
/// @description Eases speed over a duration of time
/// @param {Any} spd1
/// @param {Any} spd2
/// @param {Any} delay
/// @param {Any} duration
/// @param {Any} ease
/// @param {Any} [mode]
function TweenEasySpeed(_spd1, _spd2, _delay, _duration, _ease, _mode=0)
{
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	
	if (variable_instance_exists(self, "__TweenEasySpeed") && TweenExists(__TweenEasySpeed))
	{
		TweenDestroy(__TweenEasySpeed);
	}

	if (argument_count > 6)
	{
		var _args = [self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "speed", _spd1, _spd2];
		var i = 5; repeat(argument_count-6) { array_push(_args, argument[++i]); }
		__TweenEasySpeed = script_execute_ext(TweenFire, _args);
	}
	else
	{
		__TweenEasySpeed = TweenFire(self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "speed", _spd1, _spd2);
	}
	
	return __TweenEasySpeed;
}_=TweenEasySpeed;


/// @function TweenEasySpeedHV( hspd1, vspd1, hspd2, vspd2, delay, duration, ease, [mode] )
/// @description Eases hspeed and vspeed over a duration of time
/// @param {Any} hspd1
/// @param {Any} vpsd1
/// @param {Any} hspd2
/// @param {Any} vspd2
/// @param {Any} delay
/// @param {Any} duration
/// @param {Any} ease
/// @param {Any} [mode]
function TweenEasySpeedHV(_hspd1, _vspd1, _hspd2, _vspd2, _delay, _duration, _ease, _mode=0)
{
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	
	if (variable_instance_exists(self, "__TweenEasySpeedHV") && TweenExists(__TweenEasySpeedHV))
	{
		TweenDestroy(__TweenEasySpeedHV);
	}

	if (argument_count > 8)
	{
		var _args = [self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "hspeed", _hspd1, _hspd2, "vspeed", _vspd1, _vspd2];
		var i = 7; repeat(argument_count-8) { array_push(_args, argument[++i]); }
		__TweenEasySpeedHV = script_execute_ext(TweenFire, _args);
	}
	else
	{
		__TweenEasySpeedHV = TweenFire(self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, "hspeed", _hspd1, _hspd2, "vspeed", _vspd1, _vspd2);
	}
	
	return __TweenEasySpeedHV;
}_=TweenEasySpeedHV;


/// @function TweenEasyPath( path, absolute, delay, duration, ease, [mode] )
/// @description Eases position using a path resource over a duration of time
/// @param {Any} path
/// @param {Any} absolute
/// @param {Any} delay
/// @param {Any} duration
/// @param {Any} ease
/// @param {Any} [mode]
function TweenEasyPath(_path, _absolute, _delay, _duration, _ease, _mode=0)
{
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	
	if (variable_instance_exists(self, "__TweenEasyPath") && TweenExists(__TweenEasyPath))
	{
		TweenDestroy(__TweenEasyPath);
	}
					
	if (argument_count > 6)
	{
		var _args = [self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, _absolute ? [TPPath, _path] : [TPPath, _path, x, y], 0, 1];
		var i = 5; repeat(argument_count-6) { array_push(_args, argument[++i]); }
		__TweenEasyPath = script_execute_ext(TweenFire, _args);
	}
	else
	{
		__TweenEasyPath = TweenFire(self, _ease, _mode, global.TGMX.EasyUseDelta, _delay, _duration, _absolute ? [TPPath, _path] : [TPPath, _path, x, y], 0, 1);
	}
	
	return __TweenEasyPath;
}_=TweenEasyPath;




