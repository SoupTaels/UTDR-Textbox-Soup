// Feather ignore all

// TweenFire			-- required
// TweenCreate			-- required
// TweenPlay			-- required
// TweenPlayDelay		-- safe to delete
// TweenMore			-- safe to delete
// TweenScript			-- safe to delete
// TweenMoreScript		-- safe to delete
// TweenDefine			-- safe to delete

var _; // USED TO HIDE SYNTAX WARNINGS FOR NON-FEATHER ENVIRONMENT

// @function TweenFire( target, ease, mode, delta, delay, duration, prop, start, dest, ... )
/// @description Tween a property between start/destination values (auto-destroyed)
/// @param {Any}	target		instance or struct to associate with tween
/// @param {Any}	ease		easing script index or animation curve (e.g. EaseInQuad, EaseLinear)
/// @param {Any}	mode		tween mode (0="once", 1="bounce", 2="patrol", 3="loop", 4="repeat")
/// @param {Any}	delta		whether or not to use delta(seconds) timing -- false will use step timing
/// @param {Any}	delay		amount of time to delay tween before playing
/// @param {Any}	dur			duration of time to play tween
/// @param {Any}	prop		property setter string (e.g. "x") or TP*() script
/// @param {Any}	start		starting value for eased property
/// @param {Any}	dest		destination value for eased property
/// @param {Any}	[...]		[OPTIONAL] additional properties ("direction", 0, 360) or advanced actions ("-group", 2)
function TweenFire()
{
	/*
		Info:
		    Eases one or more variables/properties between a specified start and destination value over a set duration of time.
		    Additional properties can be added as optional arguments. Additional properties must use (property,start,dest) order.
    
		Examples:                                  
		    // Ease "x" value from (x) to (mouse_x), over 1 second
		    TweenFire(self, EaseInQuad, TWEEN_MODE_ONCE, true, 0.0, 1.0, "x", x, mouse_x);
        
		    // Ease "x" and "y" values from (x, y) to (mouse_x, mouse_y) over 60 steps with a 30 step delay.
		    // Tween will play back and forth, repeatedly.
		    TweenFire(obj_Player, EaseOutCubic, TWEEN_MODE_PATROL, false, 30, 60, "x", x, mouse_x, "y", y, mouse_y);
	*/

	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	
	
	
	// CHECK FIRST ARGUMENT FOR "OFF-RAIL" TWEEN CALL
	if (is_string(argument[0]) || is_array(argument[0]))
	{		
		switch(argument_count)
		{
		case  1: return TGMX_Tween(TweenFire, [argument[0]], 0);
		case  2: return TGMX_Tween(TweenFire, [argument[0],argument[1]], 0);
		case  3: return TGMX_Tween(TweenFire, [argument[0],argument[1],argument[2]], 0);
		case  4: return TGMX_Tween(TweenFire, [argument[0],argument[1],argument[2],argument[3]], 0);
		case  5: return TGMX_Tween(TweenFire, [argument[0],argument[1],argument[2],argument[3],argument[4]], 0);
		case  6: return TGMX_Tween(TweenFire, [argument[0],argument[1],argument[2],argument[3],argument[4],argument[5]], 0);
		case  7: return TGMX_Tween(TweenFire, [argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6]], 0);
		case  8: return TGMX_Tween(TweenFire, [argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7]], 0);
		case  9: return TGMX_Tween(TweenFire, [argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8]], 0);
		case 10: return TGMX_Tween(TweenFire, [argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9]], 0);
		case 11: return TGMX_Tween(TweenFire, [argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10]], 0);
			
		default:
			var i = argument_count, _args = [argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11]];
			repeat(argument_count-12)
			{
				i -= 1; 
				_args[i] = argument[i];
			}
			
			return TGMX_Tween(TweenFire, _args, 0);
		}
	}

	// DEFAULT ON-RAIL
	switch(argument_count)
	{
	case  6: return TGMX_Tween(TweenFire, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5]], 0);
	case  7: return TGMX_Tween(TweenFire, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6]], 0);
	case  8: return TGMX_Tween(TweenFire, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7]], 0);
	case  9: return TGMX_Tween(TweenFire, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8]], 0);
	case 10: return TGMX_Tween(TweenFire, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9]], 0);
	case 11: return TGMX_Tween(TweenFire, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10]], 0);
	case 12: return TGMX_Tween(TweenFire, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11]], 0);
	case 13: return TGMX_Tween(TweenFire, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12]], 0);
	case 14: return TGMX_Tween(TweenFire, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12],argument[13]], 0);
	case 15: return TGMX_Tween(TweenFire, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12],argument[13],argument[14]], 0);
		
	default: // TODO: VALIDATE THAT THE ARGUMENT LOOP ISN'T GOING TO LOW
		var i = argument_count, _args = [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12],argument[13],argument[14],argument[15]];
		repeat(argument_count-16)
		{
			_args[i] = argument[i-1];
			i -= 1;
		}

		return TGMX_Tween(TweenFire, _args, 0);
	}
}


/// @function TweenCreate( target, [ease, mode, delta, delay, dur, prop, start, dest, ...] )
/// @description Creates a tween to be started with TweenPlay*() (not auto-destroyed)
/// @param {Any}	target		instance or struct to associate with tween
/// @param {Any}	[ease		easing script index id (e.g. EaseInQuad, EaseLinear)
/// @param {Any}	mode		tween mode (0="once", 1="bounce", 2="patrol", 3="loop", 4="repeat")
/// @param {Any}	delta		whether or not to use delta(seconds) timing -- false will use step timing
/// @param {Any}	delay		amount of time to delay tween before playing
/// @param {Any}	dur			duration of time to play tween
/// @param {Any}	prop		property setter string or TP*() script
/// @param {Any}	start		starting value for eased property
/// @param {Any}	dest]		destination value for eased property
//  @param {Any}	...			[OPTIONAL] additional properties ("direction", 0, 360)
function TweenCreate()
{
	/*
		Creates and returns a new tween. The tween does not start right away, but must
		be played with the TweenPlay*() scripts.
		Unlike TwenFire*(), tweens created with TweenCreate() will exist in memory until either
		their target instance is destroyed or TweenDestroy(tween) is manually called.
		You can set them to auto-destroy with TweenDestroyWhenDone(tween, true):
	
		Defining a tween at creation is optional. Both of the following are valid:
			tween1 = TweenCreate(self);
			tween2 = TweenCreate(self, EaseLinear, TWEEN_MODE_ONCE, true, 0, 1, "x", 0, 100);
		
			TweenDestroyWhenDone(tween2, true); // Have tween auto-destroy when finished
	*/
	
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	
	// RETURN UNDEFINED TWEEN WITH ASSUMED TARGET IF NO ARGUMENTS GIVEN
	if (argument_count == 0)
	{
		return TGMX_Tween(TweenCreate, [undefined, self], 0); 
	}
	
	// HANDLE "OFF-RAIL" TWEEN CALL
	if (is_string(argument[0]) || is_array(argument[0]))
	{
		switch(argument_count)
		{
		case 1: return TGMX_Tween(TweenCreate, [argument[0]], 0);
		case 2: return TGMX_Tween(TweenCreate, [argument[0],argument[1]], 0);
		case 3: return TGMX_Tween(TweenCreate, [argument[0],argument[1],argument[2]], 0);
		case 4: return TGMX_Tween(TweenCreate, [argument[0],argument[1],argument[2],argument[3]], 0);
		case 5: return TGMX_Tween(TweenCreate, [argument[0],argument[1],argument[2],argument[3],argument[4]], 0);
		case 6: return TGMX_Tween(TweenCreate, [argument[0],argument[1],argument[2],argument[3],argument[4],argument[5]], 0);
		case 7: return TGMX_Tween(TweenCreate, [argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6]], 0);
		case 8: return TGMX_Tween(TweenCreate, [argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7]], 0);
		case 9: return TGMX_Tween(TweenCreate, [argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8]], 0);
		case 10: return TGMX_Tween(TweenCreate, [argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9]], 0);
			
		default:
			var i = argument_count, _args = [argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10]];
			repeat(argument_count-11)
			{
				i -= 1;
				_args[i] = argument[i];
			}
			
			return TGMX_Tween(TweenCreate, _args, 0);
		}
	}
	
	switch(argument_count)
	{
	case 1: return TGMX_Tween(TweenCreate, [undefined,argument[0]], 0); // UNDEFINED TWEEN
	case 6: return TGMX_Tween(TweenCreate, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5]], 0);
	case 7: return TGMX_Tween(TweenCreate, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6]], 0);
	case 8: return TGMX_Tween(TweenCreate, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7]], 0);
	case 9: return TGMX_Tween(TweenCreate, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8]], 0);
	case 10: return TGMX_Tween(TweenCreate, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9]], 0);
	case 11: return TGMX_Tween(TweenCreate, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10]], 0);
	case 12: return TGMX_Tween(TweenCreate, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11]], 0);
	case 13: return TGMX_Tween(TweenCreate, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12]], 0);
	case 14:  return TGMX_Tween(TweenCreate, [undefined,argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12],argument[13]], 0);
	
	default:
		var i = argument_count, _args = [undefined, argument[0],argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12],argument[13],argument[14]];
		repeat(argument_count-15)
		{
			_args[i] = argument[i-1];
			i -= 1;
		}
		
		return TGMX_Tween(TweenCreate, _args, 0);
	}
}



// @function TweenPlay( tween, [ease, mode, delta, delay, dur, prop, start, dest, ...] )
/// @description	Plays a tween previously created with TweenCreate()
/// @param {Any}	tween{s}	tween id of previously created tween
/// @param {Any}	[ease		tween mode (0="once", 1="bounce", 2="patrol", 3="loop", 4="repeat")
/// @param {Any}	mode		whether or not to use delta/seconds timing(true) or step timing(false)
/// @param {Any}	delta		whether or not to use delta/seconds timing(true) or step timing(false)
/// @param {Any}	delay		amount of time to delay tween before playing
/// @param {Any}	dur			duration of time to play tween
/// @param {Any}	prop		property setter string or TP*() script
/// @param {Any}	start		starting value for eased property
/// @param {Any}	dest]		destination value for eased property
//  @param {Any} ...			(optional) additional properties ("direction", 0, 360)
function TweenPlay() 
{
	/*
		Defining a tween at creation is optional. Both of the following are valid:
			tween1 = TweenCreate(self);
			tween2 = TweenCreate(self, EaseLinear, TWEEN_MODE_ONCE, true, 0, 1, "x", 0, 100);
		
			TweenPlay(tween1, EaseInQuad, 0, true, 0, 1.0, "a", 0, 100);
			TweenPlay(tween2);
	*/
	
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	static __array_empty = [];
	
	var _tween = TGMX_FetchTween(argument[0]);
	
	// MULTI-TWEEN EXECUTION
	if (is_struct(_tween)) 
	{ 
		TGMX_TweensExecute(_tween, TweenPlay); 
		return; 
	}

	// PRE-DEFINED TWEEN CALL
	if (argument_count == 1) 
	{
		return TGMX_Tween(TweenPlay, __array_empty, argument[0]); 
	}

	// OFF-RAIL TWEEN CALL
	if ( (is_string(argument[1]) && string_length(argument[1]) && global.TGMX.ShorthandTable[string_byte_at(argument[1], 1)]) || (is_array(argument[1]) && array_length(argument[1]) > 2) )
	{
		switch(argument_count)
		{
		case  2: return TGMX_Tween(TweenPlay, [argument[1]], argument[0]);
		case  3: return TGMX_Tween(TweenPlay, [argument[1],argument[2]], argument[0]);
		case  4: return TGMX_Tween(TweenPlay, [argument[1],argument[2],argument[3]], argument[0]);
		case  5: return TGMX_Tween(TweenPlay, [argument[1],argument[2],argument[3],argument[4]], argument[0]);
		case  6: return TGMX_Tween(TweenPlay, [argument[1],argument[2],argument[3],argument[4],argument[5]], argument[0]);
		case  7: return TGMX_Tween(TweenPlay, [argument[1],argument[2],argument[3],argument[4],argument[5],argument[6]], argument[0]);
		case  8: return TGMX_Tween(TweenPlay, [argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7]], argument[0]);
		case  9: return TGMX_Tween(TweenPlay, [argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8]], argument[0]);
		case 10: return TGMX_Tween(TweenPlay, [argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9]], argument[0]);
		case 11: return TGMX_Tween(TweenPlay, [argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10]], argument[0]);
		case 12: return TGMX_Tween(TweenPlay, [argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11]], argument[0]);
		default:
			var _args = [argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12]];
			var i = argument_count;
			
			repeat(argument_count-13)
			{
				i -= 1;
				_args[i-1] = argument[i];
			}
			
			return TGMX_Tween(TweenPlay, _args, argument[0]);
		}
	}
	
	// DEFAULT TWEEN CALL
	switch(argument_count)
	{
	case  6: return TGMX_Tween(TweenPlay, [undefined,argument[1],argument[2],argument[3],argument[4],argument[5]], argument[0]);
	case  7: return TGMX_Tween(TweenPlay, [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6]], argument[0]);
	case  8: return TGMX_Tween(TweenPlay, [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7]], argument[0]);
	case  9: return TGMX_Tween(TweenPlay, [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8]], argument[0]);
	case 10: return TGMX_Tween(TweenPlay, [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9]], argument[0]);
	case 11: return TGMX_Tween(TweenPlay, [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10]], argument[0]);
	case 12: return TGMX_Tween(TweenPlay, [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11]], argument[0]);
	case 13: return TGMX_Tween(TweenPlay, [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12]], argument[0]);
	case 14: return TGMX_Tween(TweenPlay, [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12],argument[13]], argument[0]);
	case 15: return TGMX_Tween(TweenPlay, [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12],argument[13],argument[14]], argument[0]);
	default:
		var i = argument_count, _args = [undefined, argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12],argument[13],argument[14],argument[15]];
		repeat(argument_count-16)
		{
			i -= 1;
			_args[i] = argument[i];
		}
	
		return TGMX_Tween(TweenPlay, _args, argument[0]);
	}
}

/// @function TweenMore( tween, target, ease, mode, delta, delay, dur, prop, start, dest, ... )
/// @description Allows for chaining of tweens by adding a tween to be fired after the indicated tween finishes
/// @param {Any} tween		tween id
/// @param {Any} target		instance or struct to associate with tween
/// @param {Any} ease		easing script index id (e.g. EaseInQuad, EaseLinear)
/// @param {Any} mode		tween mode (0=ONCE, 1=BOUNCE, 2=PATROL, 3=LOOP, 4=REPEAT)
/// @param {Any} delta		whether or not to use delta(seconds) timing -- false will use step timing
/// @param {Any} delay		amount of time to delay tween before playing
/// @param {Any} dur		duration of time to play tween
/// @param {Any} prop		property setter string or TP*() script
/// @param {Any} start		starting value for eased property
/// @param {Any} dest		destination value for eased property
//  @param {Any} [...]		(optional) additional properties ("direction", 0, 360)
function TweenMore()
{	
	/*
	    Info:
			Allows for chaining of tweens by adding a tween to be fired after the indicated tween finishes.
			Multiple new tweens can be added to the same tween, allowing for branching chains.
			Tween is automatically destroyed when finished, stopped, or if its associated target instance is destroyed.
			Returns unique tween id.   
    
	    Examples:
	        // Chain various tweens to fire one after another
			tween1 = TweenFire(self, EaseOutBounce, 0, true, 0, 1.0, "y", -100, y);
			tween2 = TweenMore(tween1, self, EaseInOutQuad, 0, true, 0, 0.5, "image_yscale", 1, 0.25);
			tween3 = TweenMore(tween2, self, EaseInOutSine, 0, true, 0, 1.0, "image_angle", 0, 360);
			tween4 = TweenMore(tween3, self, EaseInOutQuad, 0, true, 0, 2.0, "image_xscale", 1, 0.5);
		
			t = TweenFire(self, EaseOutBounce, 0, true, 0, 1.0, "y", -100, y);
			TweenMore(t, self, EaseInOutQuad, 0, true, 0, 0.5, "image_yscale", 1, 0.25);
			TweenMore(t+1, self, EaseInOutSine, 0, true, 0, 1.0, "image_angle", 0, 360);
			TweenMore(t+2, self, EaseInOutQuad, 0, true, 0, 2.0, "image_xscale", 1, 0.5);
		
			// 0 can be used to refer to the last created tween
			TweenFire(self, EaseOutBounce, 0, true, 0, 1.0, "y", -100, y);
			TweenMore(0, self, EaseInOutQuad, 0, true, 0, 0.5, "image_yscale", 1, 0.25);
			TweenMore(0, self, EaseInOutSine, 0, true, 0, 1.0, "image_angle", 0, 360);
			TweenMore(0, self, EaseInOutQuad, 0, true, 0, 2.0, "image_xscale", 1, 0.5);
	*/
	
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	
	if (argument[0] == TWEEN_NULL)
	{
		return TWEEN_NULL;	
	}
	
	var _args;

	// OFF-RAIL TWEEN
	if (is_string(argument[1]) || is_array(argument[1]))
	{
		switch(argument_count)
		{
		case  2: _args = [argument[1]]; break;
		case  3: _args = [argument[1],argument[2]]; break;
		case  4: _args = [argument[1],argument[2],argument[3]]; break;
		case  5: _args = [argument[1],argument[2],argument[3],argument[4]]; break;
		case  6: _args = [argument[1],argument[2],argument[3],argument[4],argument[5]]; break;
		case  7: _args = [argument[1],argument[2],argument[3],argument[4],argument[5],argument[6]]; break;
		case  8: _args = [argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7]]; break;
		case  9: _args = [argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8]]; break;
		case 10: _args = [argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9]]; break;
		default:
			_args = [argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10]];
			var i = 9;
			repeat(argument_count-11)
			{
				i += 1;
				_args[i] = argument[i+1];	
			}
		}
	}
	else // DEAFULT ON-RAIL TWEEN
	{
		switch(argument_count)
		{
		case  7: _args = [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6]]; break;
		case  8: _args = [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7]]; break;
		case  9: _args = [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8]]; break;
		case 10: _args = [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9]]; break;
		case 11: _args = [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10]]; break;
		case 12: _args = [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11]]; break;
		case 13: _args = [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12]]; break;
		case 14: _args = [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12],argument[13]]; break;
		case 15: _args = [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12],argument[13],argument[14]]; break;
		default:
			_args = [undefined,argument[1],argument[2],argument[3],argument[4],argument[5],argument[6],argument[7],argument[8],argument[9],argument[10],argument[11],argument[12],argument[13],argument[14],argument[15]];
			var i = 15;
			repeat(argument_count-16)
			{
				i += 1;
				_args[i] = argument[i];
			}
		}
	}
	
	

	var _tween = TGMX_FetchTween(argument[0]);
	var _newTween = TGMX_Tween(TweenCreate, _args, 0);


	TweenDestroyWhenDone(_newTween, _tween[TGMX_T_DESTROY]);
	TweenAddCallback(_tween, TWEEN_EV_FINISH, SharedTweener(), TweenPlay, _newTween);
	return _newTween;
}_=TweenMore;


/// @function TweenScript( target, delta, dur, script, [arg0, ...] )
/// @description Schedules a script to be executed after a set duration of time
/// @param {Any} target		target instance id
/// @param {Any} delta		use seconds timing? (true=seconds | false = steps)
/// @param {Any} dur		duration of time before script is called
/// @param {Any} script		script to execute when timer expires
/// @param {Any} [arg0,...]	(optional) additonal arguments to pass to script
function TweenScript(_target, _delta, _dur, _script)
{	
	/*
	    Info:
	        Schedules a script to be executed after a set duration of time.
	        Since this uses the tweening system, the returned tween script works with any regular tweening scripts,
			such as TweenPause(), TweenResume(), TweenMore(), etc...
    
	    Examples:
			// Display a message after 1 second
	        ts = TweenScript(id, true, 1.0, ShowMessage, "Hello, World!");
		
			// Schedule another script to be fired 2 seconds after first one finishes
			ts = TweenMoreScript(ts, id, true, 2.0, ShowMessage, "Goodbye, World!");
		
			// Fire a tween after showing second message
			t = TweenMore(ts, id, EaseInOutQuad, 0, true, 0.0, 1.0, "image_scale", 1.0, 0.0); 
	*/

	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	static __str_delta = "^";
	static __str_dollar = "$";
	static __str_question = "?";

	var _args = array_create(argument_count);
	_args[1] = TWEEN_EV_FINISH;
	_args[3] = _script; //cb script
	
	// Handle advanced target setting
	if (_target == undefined)
	{
		_args[0] = TweenFire(__str_delta, _delta, __str_dollar, _dur); 
		_args[2] = _target; // cb target
	}
	else
	if (is_array(_target)) // Set a different tween target and callback target [tween, callback]
	{
		var _target_array = _target;
		_args[0] = TweenFire(__str_question, _target_array[0], __str_delta, _delta, __str_dollar, _dur); 
		_args[2] = _target_array[1]; // cb target
	}
	else // ASSUME INSTANCE OR STRUCT TARGET
	{
		_args[0] = TweenFire(__str_question, _target, __str_delta, _delta, __str_dollar, _dur); 
		_args[2] = _target; // cb target
	}
	
	var i = 3;
	repeat(argument_count-4)
	{
		i += 1;
		_args[i] = argument[i];
	}
	
	script_execute_ext(TweenAddCallback, _args);
	return _args[0];
}_=TweenScript;


/// @function TweenMoreScript( tween, target, delta, dur, script, [arg0, ...])
/// @description Allows for the chaining of script scheduling
/// @param {Any} tween		tween id
/// @param {Any} target		target instance
/// @param {Any} delta		use seconds timing? (true=seconds | false = steps)
/// @param {Any} dur		duration of time before script is called
/// @param {Any} script		script to execute when timer expires
/// @param {Any} [arg0,...]	(optional) arguments to pass to script
function TweenMoreScript()
{	
	/*	
	    Info:
	        Allows for the chaining of script scheduling.
	        Since this uses the tweening system, the returned tween script works with any regular tweening scripts,
			such as TweenPause(), TweenResume(), TweenMore(), etc...
    
	    Examples:
			// Display a message after 1 second
	        ts = TweenScript(id, true, 1.0, ShowMessage, "Hello, World!");
		
			// Schedule another script to be fired 2 seconds after first one finishes
			ts = TweenMoreScript(ts, id, true, 2.0, ShowMessage, "Goodbye!");
		
			// Fire a tween after showing second message
			t = TweenMore(ts, id, EaseInOutQuad, 0, true, 0.0, 1.0, "image_scale", 1.0, 0.0); 
	*/

	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	static __str_delta = "^";
	static __str_dollar = "$";
	static __str_question = "?";

	if (argument[0] == TWEEN_NULL)
	{
		return TWEEN_NULL;	
	}

	var _newTween;
	var _ogTween = TGMX_FetchTween(argument[0]); // Note: This needs to be first inorder to support [0] relevant tween ids
	var _args = array_create(argument_count-1);
	_args[1] = TWEEN_EV_FINISH;
	_args[3] = argument[4]; // Script
	
	if (argument[1] == undefined) // TARGET IS UNDEFINED
	{
		_newTween = TweenCreate(__str_delta, argument[2], __str_dollar, argument[3]);
		_args[2] = argument[1]; // cb target
	}
	else
	if (is_array(argument[1])) // ARRAY TARGET [tween_target, callback_target]
	{
		var _target_array = argument[1];
		_newTween = TweenCreate(__str_question, _target_array[0], __str_delta, argument[2], __str_dollar, argument[3]);
		_args[2] = _target_array[1]; // cb target
	}
	else // ASSUME INSTANCE OR STRUCT TARGET
	{
		_newTween = TweenCreate(__str_question, argument[1], __str_delta, argument[2], __str_dollar, argument[3]);
		_args[2] = argument[1]; // cb target
	}
	
	_args[0] = _newTween;
	TweenDestroyWhenDone(_newTween, true);
	TweenAddCallback(_ogTween[TGMX_T_ID], TWEEN_EV_FINISH, SharedTweener(), TweenPlay, _newTween);

	// Add remaining script arguments
	var i = 3;
	repeat(argument_count-5)
	{
		i += 1;
		_args[i] = argument[i+1];
	}
	
	script_execute_ext(TweenAddCallback, _args);
	return _newTween;
}_=TweenMoreScript;
