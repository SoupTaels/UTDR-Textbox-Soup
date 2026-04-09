// Feather ignore all

//TweenAddCallback			-- required
//TweenAddCallbackUser		-- safe to delete
//TweenCallbackEnable		-- safe to delete
//TweenCallbackInvalidate	-- safe to delete
//TweenCallbackIsEnabled	-- safe to delete
//TweenCallbackIsValid		-- safe to delete
//TweenEventClear			-- safe to delete
//TweenEventEnable			-- safe to delete
//TweenEventIsEnabled		-- safe to delete

var _; // USED TO HIDE SYNTAX WARNINGS


/// @function TweenAddCallback( tween, event, target, func|user, [arg0, ...] );
/// @description Adds function or user event to be called on specified tween event
/// @param {Any}	tween		tween id
/// @param {Any}	event		tween event macro (TWEEN_EV_*) or string ("finish")
/// @param {Any}	target		target instance id -- callback will use this environment to call function
/// @param {Any}	func		function or user event (0-15) to call on specified tween event
/// @param {Any}	[arg0]		optional arguments to pass to function call
/// @param {Any}	...			additional optional arguments
function TweenAddCallback(_tweenID, _event, _target, _func) 
{	
	// [INFO]
	// Sets a FUNCTION or USER EVENT (0-15) to be called on specified tween event.
	// Multiple callbacks can be added to the same event.
	         
	// "event" can take any of the following TWEEN_EV_* macros or strings:
	// TWEEN_EV_PLAY			"play"				"played"
	// TWEEN_EV_FINISH			"finish"			"finished"
	// TWEEN_EV_CONTINUE		"continue"			"continued"
	// TWEEN_EV_STOP			"stop"				"stopped"
	// TWEEN_EV_PAUSE			"pause"				"paused"
	// TWEEN_EV_RESUME			"resume"			"resumed"
	// TWEEN_EV_REVERSE			"reverse"			"reversed"
		 											
	// TWEEN_EV_FINISH_DELAY	"finish_delay"		"finished_delay"
	// TWEEN_EV_STOP_DELAY		"stop_delay"		"stopped_delay"
	// TWEEN_EV_PAUSE_DELAY		"pause_delay"		"paused_delay"
	// TWEEN_EV_RESUME_DELAY	"resume_delay"		"resumed_delay"
	
	var _t = TGMX_FetchTween(_tweenID);
	if (_t == undefined) { return undefined; }

	var _events_map = _t[TGMX_T_EVENTS];
	var _cb;
	
	// CHECK FOR "EVENT" STRING
	static __str_at = "@";
	static __str_at_byte = string_byte_at(__str_at, 1);

	if (is_string(_event)) 
	{ 
		_event = TGMX_StringStrip(_event, 0);
		_event = string_byte_at(_event, 1) == __str_at_byte ? global.TGMX.ArgumentLabels[? _event] : global.TGMX.ArgumentLabels[? __str_at+_event];
	}

	// CREATE AND ASSIGN EVENTS MAP IF IT DOESN'T EXIST
	if (_events_map == -1) 
	{
	    _events_map = ds_map_create();
	    _t[@ TGMX_T_EVENTS] = _events_map;
	}

	// HANDLE USER EVENT INDEXES (0-15)
	if (is_real(_func) && _func <= 15)
	{
		// NOTE: This is to prevent a user_event bug with HTML5 -- not sure why its hating it
		// ALSO note that HTML5 is considering GML functions as methods.. why??
		static _ = function(_user_event)
		{
			event_user(_user_event);	
		}
		
		_cb[4] = _func; // ADD THE USER EVENT ARGUMENT TO CALLBACK
		_func = _; // ASSIGN EVENT_USER FUNCTION TO FUNC
	}
	else
	{
		// ADD FUNCTION ARGUMENTS
		var _index = argument_count;
		repeat(_index-3) 
		{
		    --_index;
		    _cb[_index] = argument[_index];
		}
	}

	// ASSIGN TWEEN ID TO CALLBACK
	_cb[TGMX_CB_TWEEN] = _tweenID;
	// SET DEFAULT STATE AS ACTIVE
	_cb[TGMX_CB_ENABLED] = true;
	
	// SET UP TARGET -- CREATE WEAK REFERENCE FOR STRUCT OR GET INSTANCE ID IF INSTANCE
	if (_target == undefined)
	{
		if (is_method(_func)) // USE THE METHOD'S SELF AS THE CALLBACK TARGET
		{
			_target = method_get_self(_func);
			_target = is_struct(_target) ? weak_ref_create(_target) : _target.id;
		}
		else // Use the tween's target as the target
		{
			_target = _t[TGMX_T_TARGET]; // ALREADY A WEAK REFERENCE OR INSTANCE ID
		}
	}
	else
	{
		_target = is_struct(_target) ? weak_ref_create(_target) : _target.id;
	}
	
	// ASSIGN FINALIZED CALLBACK TARGET
	_cb[TGMX_CB_TARGET] = _target;
	// ASSIGN CALLBACK SCRIPT -- strip out index from method
	_cb[TGMX_CB_SCRIPT] = is_method(_func) ? method(_target, _func) : _func;

	// CHECK IF WE CAN ADD TO AN EXISTING EVENT LIST
	if (ds_map_exists(_events_map, _event))
	{ // IF event type exists...
	    // GET LIST FROM EVENTS MAP
	    var _event_list = _events_map[? _event];
	    // ADD CALLBACK TO EVENT LIST
	    ds_list_add(_event_list, _cb);
    
	    // Do some event callback cleanup if size starts to get larger than expected
	    // We don't want to handle the cleaning here in case TweenAddCallback is called during a tween event!
	    if (ds_list_size(_event_list) % 5 == 0)
	    {   
	        ds_priority_add(SharedTweener().eventCleaner, _event_list, _event_list);
	    }
	}
	else
	{	// CREATE NEW EVENT LIST
	    var _event_list = ds_list_create();
	    // ADD 'EVENT STATE' AND 'CALLBACK' TO EVENT LIST
	    ds_list_add(_event_list, true, _cb);
	    // Add event to events map -- auto-destroyed when map is destroyed
		ds_map_add_list(_events_map, _event, _event_list);
	}
	
	// Return callback array
	return _cb;
}


/// @function TweenAddCallbackUser( tween, event, target, user_event )
/// @description Adds user event to be called at specified tween event
/// @param {Any} tween		tween id
/// @param {Any} event					tween event macro (TWEEN_EV_*) or string ("finish")
/// @param {Any} target					target instance id -- callback will use this environment to call function
/// @param {Any} user_event				User event (0-15) to call on specified tween event
function TweenAddCallbackUser(_tweenID, _event, _target, _user)
{		
	TweenAddCallback(_tweenID, _event, _target, _user);
}_=TweenAddCallbackUser;


/// @function TweenCallbackEnable( callback, enable )
/// @description Enables/disables specified callbacks
/// @param {Any} callback
/// @param {Any} enable
function TweenCallbackEnable(_callback, _enable)
{		
	if (is_array(_callback) && _callback[TGMX_CB_TWEEN] != TWEEN_NULL)
	{
	    _callback[@ TGMX_CB_ENABLED] = _enable;
	}
}_=TweenCallbackEnable;


/// @function TweenCallbackInvalidate( callback ) 
/// @description Removes callback from its associated tween event
/// @param {Any} callback
function TweenCallbackInvalidate(_callback) 
{	
	/*      
	    Example:
	        // Create tween and add callback to finish event
	        tween = TweenCreate(self);
	        cb = TweenEventAddCallback(tween, TWEEN_EV_FINISH, id, ShowMessage, "Finished!");
        
	        // Invalidate callback -- effectively removes it from tween event
	        TweenInvalidate(cb);
	*/

	if (is_array(_callback))
	{
	    // Set callback tween as null to have it marked for removal
	    _callback[@ TGMX_CB_TWEEN] = TWEEN_NULL;
		_callback[@ TGMX_CB_ENABLED] = false;
	}
}_=TweenCallbackInvalidate;


/// @function TweenCallbackIsEnabled( callback ) 
/// @description Checks if callback is enabled
/// @param {Any} callback
function TweenCallbackIsEnabled(_callback) 
{	
	if (is_array(_callback))
	{
		return _callback[TGMX_CB_ENABLED];
	}
	
	return false;
}_=TweenCallbackIsEnabled;


/// @function TweenCallbackIsValid( callback )
/// @description Checks if callback id is valid
/// @param {Any} callback
function TweenCallbackIsValid(_callback)
{	
	/*      
		Example:
		    if (TweenCallbackIsValid(callback))
		    {
		        TweenCallbackInvalidate(callback);
		    }
	*/
	
	if (is_array(_callback))
	{
		if (TweenExists(_callback[TGMX_CB_TWEEN]) && TGMX_TargetExists(_callback[TGMX_CB_TARGET]))
		{
			return true;
		}
	}
	
	return false;
}_=TweenCallbackIsValid;


/// @function TweenEventClear( tween[s], event )
/// @description Invalidates all callbacks associated with tween event
/// @param {Any} tween{s}		tween id[s]
/// @param {Any} event			tween event macro (TWEEN_EV_*) or string ("finish")
function TweenEventClear(_t, _event)
{		
	// NOTE!!
	// We don't want to immediately clear the event list in case the event is actively being called!

	if (_event == undefined)
	{
		show_error("No event given for TweenEventClear(tween, event)", false);	
	}

	_t = TGMX_FetchTween(_t);
	
	// CHECK FOR "EVENT" STRING
	static __str_at = "@";
	static __str_at_byte = string_byte_at(__str_at, 1);

	if (is_string(_event)) 
	{ 
		_event = TGMX_StringStrip(_event, 0);
		_event = string_byte_at(_event, 1) == __str_at_byte ? global.TGMX.ArgumentLabels[? _event] : global.TGMX.ArgumentLabels[? __str_at+_event];
	}

	if (is_array(_t))
	{
	    var _events_map = _t[TGMX_T_EVENTS];
    
	    if (_events_map != -1)
	    {    
	        if (ds_map_exists(_events_map, _event))
	        {
	            var _event_list = _events_map[? _event]; 
	            var _index = 0;
            
	            repeat(ds_list_size(_event_list)-1)
	            {
	                // Invalidate callback
					_event_list[| ++_index][@ TGMX_CB_TWEEN] = TWEEN_NULL;
	            }
	        }
	    }
	}
	else 
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenEventClear, _event);
	}
}


/// @function TweenEventEnable( tween[s], event, enable? )
/// @description Enables/disables specified tween event
/// @param {Any} tween{s}	tween id[s]
/// @param {Any} event		tween event macro (TWEEN_EV_*) or string ("finish")
/// @param {Any} enable?		enable event?
function TweenEventEnable(_t, _event, _enable)
{	
	_t = TGMX_FetchTween(_t);

	// CHECK FOR "EVENT" STRING
	static __str_at = "@";
	static __str_at_byte = string_byte_at(__str_at, 1);

	if (is_string(_event)) 
	{ 
		_event = TGMX_StringStrip(_event, 0);
		_event = string_byte_at(_event, 1) == __str_at_byte ? global.TGMX.ArgumentLabels[? _event] : global.TGMX.ArgumentLabels[? __str_at+_event];
	}

	if (is_array(_t))
	{
	    var _events_map = _t[TGMX_T_EVENTS];
    
	    // Create and assign events map if it doesn't exist
	    if (_events_map == -1)
	    {
	        _events_map = ds_map_create();
	        _t[@ TGMX_T_EVENTS] = _events_map;
	    }
    
		// IF NOT ALREADY CREATED, CREATE NEW EVENT LIST AND ADD TO EVENTS MAP
	    if (!ds_map_exists(_events_map, _event))
	    {
	        var _event_list = ds_list_create(); // CREATE EVENT LIST
	        _events_map[? _event] = _event_list; // ADD EVENT LIST TO EVENTS MAP
	    }
    
	    // SET TWEEN EVENT STATE
	    var _event_list = _events_map[? _event];
	    _event_list[| 0] = _enable;
	}
	else
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenEventEnable, _event, _enable);
	}
}


/// @function TweenEventIsEnabled( tween, event )
/// @description Checks if tween event is enabled
/// @param {Any} tween	tween id
/// @param {Any} event	tween event macro (TWEEN_EV_*) or string ("finish")
function TweenEventIsEnabled(_t, _event)
{	
	_t = TGMX_FetchTween(_t);
	if (_t == undefined) { return false; }
	
	// CHECK FOR "EVENT" STRING
	static __str_at = "@";
	static __str_at_byte = string_byte_at(__str_at, 1);

	if (is_string(_event)) 
	{ 
		_event = TGMX_StringStrip(_event, 0);
		_event = string_byte_at(_event, 1) == __str_at_byte ? global.TGMX.ArgumentLabels[? _event] : global.TGMX.ArgumentLabels[? __str_at+_event];
	}

	// Get events map from tween
	var _events_map = _t[TGMX_T_EVENTS];
	// Return true if events don't exist
	if (_events_map == -1) { return true; }
	// Return true if event type doesn't exist
	if (!ds_map_exists(_events_map, _event)) { return true; }
	// Return event's [enabled] state boolean
	return ds_list_find_value(_events_map[? _event], 0);
}_=TweenEventIsEnabled;





