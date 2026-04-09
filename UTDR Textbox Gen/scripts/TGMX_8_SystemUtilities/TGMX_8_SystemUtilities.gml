// Feather ignore all

/*
	It is safe to delete:
		TweenSystemGet
		TweenSystemSet
		TweenSystemFlushDestroyed
*/

var _; // USED TO HIDE SYNTAX WARNINGS

/// @function TweenSystemGet( data_label )
/// @description Return value for selected tweening system property
/// @param {Any} data_label		Data type string (See function for list of supported strings)
function TweenSystemGet(_data_label)
{	
	/*
	    SUPPORTED DATA LABELS:
	        "enabled"			// is system enabled?
	        "time_scale"		// global time scale
	        "update_interval"	// how often system should update in steps (default = 1)
	        "min_delta_fps"		// minimum frame rate before delta time lags begin (default=10)
	        "auto_clean_count"	// number of tweens to check for auto-cleaning each step (default=10)
	        "delta_time"		// tweening systems internal delta time
	        "delta_time_scaled" // tweening systems scaled delta time
			"tween_count"			// returns total number of tweens in current room
			"tween_count_playing"	// returns total number of playing tweens
			"tween_count_paused"	// returns total number of paused tween
			"tween_count_stopped"	// returns total number of stopped tweens
	*/
	
	// MAKE SURE GLOBAL SYSTEM IS INITIALIZED
	static _ = TGMX_Begin();
	
	switch(_data_label)
	{
	    case "delta_time":			return SharedTweener().deltaTime;
	    case "delta_time_scaled":	return SharedTweener().deltaTime * global.TGMX.TimeScale;
	    case "time_scale":			return global.TGMX.TimeScale;
		case "enabled": 			return global.TGMX.IsEnabled;
	    case "update_interval": 	return global.TGMX.UpdateInterval;
	    case "min_delta_fps":		return global.TGMX.MinDeltaFPS;
	    case "auto_clean_count":	return global.TGMX.AutoCleanIterations;
		case "tween_count": 		return ds_list_size(SharedTweener().tweens);
	}

	/*
		Tween Counts!
	*/
	var _tweens = SharedTweener().tweens;
	var _total = 0;
	var _index = -1;

	switch(_data_label)
	{ 
	    case "tween_count_playing":
	        repeat(ds_list_size(_tweens))
	        {
	            var _tween = _tweens[| ++_index];
	            _total += _tween[TGMX_T_STATE] >= 0 || is_struct(_tween[TGMX_T_STATE]);
	        }
	    break;
    
	    case "tween_count_paused":
	        repeat(ds_list_size(_tweens))
	        {
	            var _tween = _tweens[| ++_index];
	            _total += _tween[TGMX_T_STATE] == TGMX_T_STATE_PAUSED;
	        }
	    break;
    
	    case "tween_count_stopped":
	        repeat(ds_list_size(_tweens))
	        {
	            var _tween = _tweens[| ++_index];
	            _total += _tween[TGMX_T_STATE] == TGMX_T_STATE_STOPPED;
	        }
	    break;
	}

	return _total;
}_=TweenSystemGet;


/// @function TweenSystemSet( data_label, value )
/// @description Set value for specified tweening system property
/// @param {Any} data_label		string name for data type (See function for supported strings)
/// @param {Any} value				value to assign
function TweenSystemSet(_data_label, _value) 
{	
	/*
	    SUPPORTED DATA LABELS:
	        "enabled"
	        "time_scale"
	        "update_interval"
	        "min_delta_fps"
	        "auto_clean_count"
	*/
	
	// MAKE SURE GLOBAL SYSTEM IS INITIALIZED
	static _ = TGMX_Begin();

	instance_activate_object(o_SharedTweener);

	switch(_data_label)
	{
	    case "enabled":
	        global.TGMX.IsEnabled = _value;
			
			if (instance_exists(global.TGMX.SharedTweener)) {
				global.TGMX.SharedTweener.isEnabled = _value;
			}
			
	    break;
    
	    case "time_scale":
	        global.TGMX.TimeScale = _value;
			
			if (instance_exists(global.TGMX.SharedTweener)) {
				global.TGMX.SharedTweener.timeScale = _value;
			}
	    break;
    
	    case "update_interval":
	        global.TGMX.UpdateInterval = _value;
			
			if (instance_exists(global.TGMX.SharedTweener)) {
				global.TGMX.SharedTweener.updateInterval = _value;
			}
	    break;
    
	    case "min_delta_fps":
	        global.TGMX.MinDeltaFPS = _value;
			
			if (instance_exists(global.TGMX.SharedTweener)) {
				global.TGMX.SharedTweener.minDeltaFPS = _value;
				global.TGMX.SharedTweener.maxDelta = 1/_value;
			}
	    break;
    
	    case "auto_clean_count":
	        global.TGMX.AutoCleanIterations = _value;
			
			if (instance_exists(global.TGMX.SharedTweener)) {
				global.TGMX.SharedTweener.autoCleanIterations = _value;
			}
	    break; 
	}
}_=TweenSystemSet;


/// @function TweenSystemFlushDestroyed()
/// @description Override memory manager to immediately clear destroyed tweens
function TweenSystemFlushDestroyed() 
{
	static _ = TGMX_Begin();
	
	if (instance_exists(global.TGMX.SharedTweener))
	{
	    global.TGMX.SharedTweener.flushDestroyed = true;
	}
}_=TweenSystemFlushDestroyed;


/// @function TweenSystemClear( room )
/// @description Clear tweens in inactive persistent room[s]
/// @param {Any} room		room id or [all] keyword for all rooms
function TweenSystemClearRoom(_room) 
{	
	// MAKE SURE GLOBAL SYSTEM IS INITIALIZED
	static _ = TGMX_Begin();
	
	var _pRoomTweens = global.TGMX.pRoomTweens;
	var _pRoomDelays = global.TGMX.pRoomDelays;
	var _key = _room;

	// Clear all rooms if "all" keyword is used
	if (_key == all)
	{
		repeat(ds_map_size(_pRoomTweens))
		{
			TweenSystemClearRoom(ds_map_find_first(_pRoomTweens));
		}
	
		return 0;
	}

	// Destroy tweens for persistent room
	if (ds_map_exists(_pRoomTweens, _key))
	{
	    // Delete stored delays
	    ds_queue_destroy(ds_map_find_value(_pRoomDelays, _key));
	    ds_map_delete(_pRoomDelays, _key);
    
	    // Get stored tweens queue
	    var _queue = ds_map_find_value(_pRoomTweens, _key);
    
	    // Destroy all stored tweens in queue
	    repeat(ds_queue_size(_queue))
	    {
	        var _t = ds_queue_dequeue(_queue); // Get next tween from room's queue
        
	        // Invalidate tween handle
	        if (ds_map_exists(global.TGMX.TweenIndexMap, _t[TGMX_T_ID]))
	        {
	            ds_map_delete(global.TGMX.TweenIndexMap, _t[TGMX_T_ID]);
	        }
        
	        _t[@ TGMX_T_STATE] = TGMX_T_STATE_DESTROYED; // Set state as destroyed
	        _t[@ TGMX_T_ID] = undefined; // Nullify self reference ... Is this even needed?
        
	        // Destroy tween events if events map exists
	        if (_t[TGMX_T_EVENTS] != -1)
	        {
				ds_map_destroy(_t[TGMX_T_EVENTS]); // Destroy events map
			}
	    }
    
	    ds_queue_destroy(_queue);          // Destroy room's queue for stored tweens
	    ds_map_delete(_pRoomTweens, _key); // Delete persistent room id from stored tweens map
	}
}







