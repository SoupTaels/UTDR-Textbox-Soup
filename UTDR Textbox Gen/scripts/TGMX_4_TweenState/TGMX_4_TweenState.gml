// Feather ignore all

/*
Required:
	TweenExists
	TweenStop
	TweenPause
	TweenResume
	TweenDestroy
	TweenDestroyWhenDone
	
Safe to delete:
	TweenIsActive
	TweenIsPlaying
	TweenIsPaused
	TweenIsResting
	TweenJustStarted
	TweenJustFinished
	TweenJustStopped
	TweenJustPaused
	TweenJustResumed
	TweenJustRested
	TweenJustContinued
	TweenReverse
	TweenFinish
	TweenFinishDelay
*/

var _; // USED TO HIDE SYNTAX WARNINGS FOR NON-FEATHER ENVIRONMENT


/// @function TweenExists( tween )
/// @description Checks if tween exists
/// @param {Any} tween
function TweenExists(_t) 
{		
	static _ = SharedTweener();
	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{		
	    if (_t[TGMX_T_STATE] == TGMX_T_STATE_DESTROYED) 
		{ 
			return false; 
		}
	}
	else
	if (_t == undefined)
	{
		return false;	
	}
	else
	if (is_struct(_t))
	{
	    return TGMX_TweensExecuteBool(_t, TweenExists);
	}
	
	// _t NOW MEANS TARGET... this is an optimisation trick to avoid use of local vars
	_t = _t[TGMX_T_TARGET];
	
	if (is_struct(_t)) // STRUCT TARGET
	{
		if (weak_ref_alive(_t))
		{
			return true;
		}
	}
	else // INSTANCE TARGET
	{
		if (instance_exists(_t)) { return true; }

		instance_activate_object(_t);

		if (instance_exists(_t))
		{
		    instance_deactivate_object(_t);
		    return true;
		}
	}
	
	return false;
}


/// @function TweenIsActive( tween )
/// @descriptionChecks if tween is active -- Returns true if tween is playing OR actively processing a delay
/// @param {Any} [tween]
function TweenIsActive()
{		
	static _ = SharedTweener();
	static _t = 0; // USING static INSTEAD OF var PRODUCES LESS OVERHEAD IN FUNCTION CALL
	_t = (argument_count == 0) ? TGMX_FetchTween(all) : TGMX_FetchTween(argument[0]);
	
	if (is_array(_t))
	{		
	    return (is_struct(_t[TGMX_T_STATE]) || real(_t[TGMX_T_STATE]) >= 0 || _t[TGMX_T_STATE] == TGMX_T_STATE_DELAYED);
	}
	
	if (is_struct(_t))
	{
	    return TGMX_TweensExecuteBool(_t, TweenIsActive);
	}
	
	return false;
}_=TweenIsActive;


/// @function TweenIsPlaying( [tween] )
/// @description Checks if tween is playing
/// @param {Any} [tween]
function TweenIsPlaying()
{		
	static _ = SharedTweener();
	static _t = 0; // USING static INSTEAD OF var PRODUCES LESS OVERHEAD IN FUNCTION CALL
	_t = (argument_count == 0) ? TGMX_FetchTween(all) : TGMX_FetchTween(argument[0]);
	
	if (is_array(_t))
	{		
	    return (is_struct(_t[TGMX_T_STATE]) || real(_t[TGMX_T_STATE]) >= 0);
	}

	if (is_struct(_t))
	{
	    return TGMX_TweensExecuteBool(_t, TweenIsPlaying);
	}
	
	return false;
}_=TweenIsPlaying;


/// @function TweenIsPaused( tween )
/// @description Checks if tween is paused
/// @param {Any} tween
function TweenIsPaused()
{		
	static _ = SharedTweener();
	static _t = 0; // USING static INSTEAD OF var PRODUCES LESS OVERHEAD IN FUNCTION CALL
	_t = (argument_count == 0) ? TGMX_FetchTween(all) : TGMX_FetchTween(argument[0]);

	if (is_array(_t))
	{		
	    return _t[TGMX_T_STATE] == TGMX_T_STATE_PAUSED;
	}

	if (is_struct(_t))
	{
	    return TGMX_TweensExecuteBool(_t, TweenIsPaused);
	}
	
	return false;
}_=TweenIsPaused;


/// @function TweenIsResting( tween )
/// @description Checks if tween is resting
/// @param {Any} tween
function TweenIsResting()
{	
	static _ = SharedTweener();
	static _t = 0; // USING static INSTEAD OF var PRODUCES LESS OVERHEAD IN FUNCTION CALL
	_t = (argument_count == 0) ? TGMX_FetchTween(all) : TGMX_FetchTween(argument[0]);

	if (is_array(_t))
	{		
	    if (is_array(_t[TGMX_T_REST]))
		{
			return _t[TGMX_T_REST][_t[TGMX_T_TIME] > 0] < 0;	
		}

		return _t[TGMX_T_REST] < 0;
	}

	if (is_struct(_t))
	{
	    return TGMX_TweensExecuteBool(_t, TweenIsResting);
	}
	
	return false;
}_=TweenIsResting;


/// @function TweenJustStarted( tween )
/// @description Checks if tween just started playing in current step
/// @param {Any} tween
function TweenJustStarted(_t)
{	
	static _ = SharedTweener();
	static m = global.TGMX.EventMaps[TWEEN_EV_PLAY];
	return ds_map_exists(m, _t);
}_=TweenJustStarted;


/// @function TweenJustFinished( tween )
/// @description Checks to see if the tween just finished in current step
/// @param {Any} tween
function TweenJustFinished(_t)
{	
	static _ = SharedTweener();
	static m = global.TGMX.EventMaps[TWEEN_EV_FINISH];
	return ds_map_exists(m, _t);
}_=TweenJustFinished;


/// @function TweenJustStopped( tween )
///	@description Checks if tween just stopped in current step	
/// @param {Any} tween	
function TweenJustStopped(_t)
{	
	static _ = SharedTweener();
	static m = global.TGMX.EventMaps[TWEEN_EV_STOP];
	return ds_map_exists(m, _t);
}_=TweenJustStopped;


/// @function TweenJustPaused( tween )
/// @description Checks if tween was just paused in current step	
/// @param {Any} tween
function TweenJustPaused(_t)
{	
	static _ = SharedTweener();
	static m = global.TGMX.EventMaps[TWEEN_EV_PAUSE];
	return ds_map_exists(m, _t);
}_=TweenJustPaused;


/// @function TweenJustResumed( tween )
/// @description Checks if tween was just resumed in current step
/// @param {Any} tween
function TweenJustResumed(_t)
{	
	static _ = SharedTweener();
	static m = global.TGMX.EventMaps[TWEEN_EV_RESUME];
	return ds_map_exists(m, _t);
}_=TweenJustResumed;


/// @function TweenJustRested( tween )
/// @description Checks if tween started to rest in current step
/// @param {Any} tween
function TweenJustRested(_t) 
{	
	static _ = SharedTweener();
	static m = global.TGMX.EventMaps[TWEEN_EV_REST];
	return ds_map_exists(m, _t);
}_=TweenJustRested;


/// @function TweenJustContinued( tween )
/// @description Checks if tween just continued in current step
/// @param {Any} tween
function TweenJustContinued(_t)
{	
	static _ = SharedTweener();
	static m = global.TGMX.EventMaps[TWEEN_EV_CONTINUE];
	return ds_map_exists(m, _t);
}_=TweenJustContinued;


/// @function TweenStop( tweens[s] )
/// @description Stops selected tweens[s]
/// @param {Any} tween{s} Tween Id[s]
function TweenStop(_t)
{	
	static _ = SharedTweener();
	
	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{
	    if (is_struct(_t[TGMX_T_STATE]) || real(_t[TGMX_T_STATE] >= 0) || _t[TGMX_T_STATE] <= TGMX_T_STATE_PAUSED)
	    {
	        _t[@ TGMX_T_STATE] = TGMX_T_STATE_STOPPED;
        
	        if (_t[TGMX_T_DELAY] >= 0) // NOTE: Careful with the -1 jump delays...
	        {
	            _t[@ TGMX_T_DELAY] = 0;   
	            TGMX_ExecuteEvent(_t, TWEEN_EV_STOP_DELAY);
	        }
	        else
	        {
	            TGMX_ExecuteEvent(_t, TWEEN_EV_STOP);
	        }
            
	        if (_t[TGMX_T_DESTROY]) { TweenDestroy(_t); }
	    }
	}
	else
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenStop);
	}
}


/// @function TweenPause( tween[s] )
/// @description Pauses selected tweens[s]
/// @param {Any} tween{s}
function TweenPause(_t)
{
	static _ = SharedTweener();
	
	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{
	    if (is_struct(_t[TGMX_T_STATE]) || real(_t[TGMX_T_STATE]) >= 0) 
		{
	        _t[@ TGMX_T_STATE] = TGMX_T_STATE_PAUSED;
	        TGMX_ExecuteEvent(_t, TWEEN_EV_PAUSE);
	    }
		else 
		if (_t[TGMX_T_STATE] == TGMX_T_STATE_DELAYED) 
		{
	        _t[@ TGMX_T_STATE] = TGMX_T_STATE_PAUSED;
	        TGMX_ExecuteEvent(_t, TWEEN_EV_PAUSE_DELAY);
	    }
	}
	else
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenPause);
	}
}


/// @function TweenResume( tween[s] )
/// @description Resumes selected tweens[s]
/// @param {Any} tween{s}
function TweenResume(_t) 
{	
	static _ = SharedTweener();
	
	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{		
	    if (_t[TGMX_T_STATE] == TGMX_T_STATE_PAUSED)
	    {		
	        if (_t[TGMX_T_DELAY] > 0)
	        {
	            _t[@ TGMX_T_STATE] = TGMX_T_STATE_DELAYED;
	            TGMX_ExecuteEvent(_t, TWEEN_EV_RESUME_DELAY);
	        }
	        else
	        {
	            _t[@ TGMX_T_STATE] = _t[TGMX_T_TARGET];
	            TGMX_ExecuteEvent(_t, TWEEN_EV_RESUME);
	        }
	    }
	}
	else
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenResume);
	}
}


/// @function TweenReverse( tween[s] )
/// @description Reverses selected tween[s]
/// @param {Any} tween{s}
function TweenReverse(_t)
{	
	static _ = SharedTweener();
	
	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{
	    if (is_struct(_t[TGMX_T_STATE]) || real(_t[TGMX_T_STATE]) >= 0 || _t[TGMX_T_STATE] == TGMX_T_STATE_PAUSED)
	    {
	        _t[@ TGMX_T_DIRECTION] = -_t[TGMX_T_DIRECTION];
	        _t[@ TGMX_T_SCALE] = -_t[TGMX_T_SCALE];
	        TGMX_ExecuteEvent(_t, TWEEN_EV_REVERSE);
	    }
	}
	else
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenReverse);
	}
}


// @function TweenFinish( tween[s], call_event, finish_delay, call_delay_event )
/// @description Finishes selected tween{s}
/// @param {Any} tween{s}			tween id[s]
/// @param {Any} call_event			Call FINISH event callbacks?
/// @param {Any} finish_delay		Finish if tween is still delayed?
/// @param {Any} call_delay_event	Call FINISH DELAY event callbacks?
function TweenFinish(_t, _callEvent=true, _finishDelay=true, _callDelayEvent=true)
{
	/*      
	    INFO:
	        Finishes the specified tween, updating it to its destination.
	        DOES NOT affect tweens using PATROL|LOOP|REPEAT play modes when a specified continue count is not given.
	*/
	
	static _ = SharedTweener();

	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{	// Deal with delays
		if (_t[TGMX_T_DELAY] > 0 && _finishDelay)
	    {
			//> Mark delay for removal from delay list
	        _t[@ TGMX_T_DELAY] = 0;
	        //> Execute FINISH DELAY event
	        if (_callDelayEvent) { TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH_DELAY); }
			//> Set tween as active
	        _t[@ TGMX_T_STATE] = _t[TGMX_T_TARGET];                
			//> Preprocess tween
			TGMX_TweenPreprocess(_t);
			//> Process tween
			TGMX_TweenProcess(_t, 0, _t[TGMX_T_PROPERTY_DATA], is_struct(_t[TGMX_T_TARGET]) ? _t[TGMX_T_TARGET].ref : _t[TGMX_T_TARGET]);
			//> Execute PLAY event
	        TGMX_ExecuteEvent(_t, TWEEN_EV_PLAY);
	    }
		
		// Return early if tween retained delay
	    if (_t[TGMX_T_DELAY] > 0) { return 0; }
    
    	// Let's finish the tween!
	    if (is_struct(_t[TGMX_T_STATE]) || real(_t[TGMX_T_STATE] >= 0) || _t[TGMX_T_STATE] == TGMX_T_STATE_PAUSED)
	    {
	        switch(_t[TGMX_T_MODE])
	        {
	        case TWEEN_MODE_ONCE: 
				//> Set time to tween end
				_t[@ TGMX_T_TIME] = _t[TGMX_T_DURATION];
			break;
	        
			case TWEEN_MODE_BOUNCE: 
				//> Set time to tween start
				_t[@ TGMX_T_TIME] = 0; 
			break;
			
			case TWEEN_MODE_PATROL:
				//> Exit script early if count is endless
				if (_t[TGMX_T_CONTINUE_COUNT] <= -1) return;
				
				//> Determine start/end based on odd/even count
				if (_t[TGMX_T_CONTINUE_COUNT] % 2 == 0) {
					_t[@ TGMX_T_TIME] = _t[TGMX_T_DIRECTION] == 1 ? _t[TGMX_T_DURATION] : 0;
				}
				else {
					_t[@ TGMX_T_TIME] = _t[TGMX_T_DIRECTION] == 1 ? 0 : _t[TGMX_T_DURATION];
				}	
			break;
			
			case TWEEN_MODE_LOOP:
				//> Exit script early if count is endless
				if (_t[TGMX_T_CONTINUE_COUNT] <= -1) return;
				//> Set time to tween end
				_t[@ TGMX_T_TIME] = _t[TGMX_T_DURATION];	
			break;
			
			case TWEEN_MODE_REPEAT:
				//> Exit script early if count is endless
				if (_t[TGMX_T_CONTINUE_COUNT] <= -1) return;
				//> Set time to tween end
				_t[@ TGMX_T_TIME] = _t[TGMX_T_DURATION];
				
				//> Loop through data array and change start positions
				var _data = _t[TGMX_T_PROPERTY_DATA];
				var i = -2;
				repeat(_data[0])
				{
					i += 4;
					_data[@ i] += _data[i+1] * _t[TGMX_T_CONTINUE_COUNT]; 
				}
			break;
	        }
        
			//> Set tween state as STOPPED
	        _t[@ TGMX_T_STATE] = TGMX_T_STATE_STOPPED; 
	        //> Update property with start value
			TGMX_TweenProcess(_t, _t[TGMX_T_TIME], _t[TGMX_T_PROPERTY_DATA], is_struct(_t[TGMX_T_TARGET]) ? _t[TGMX_T_TARGET].ref : _t[TGMX_T_TARGET]);
	        //> Execute finish event IF set to do so
	        if (_callEvent) { TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH); }
	        //> Destroy tween if it is set to be destroyed
	        if (_t[TGMX_T_DESTROY]) { TweenDestroy(_t); }
	    }
	}
	else
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenFinish, _callEvent);
	}
}

	
/// @function TweenFinishDelay( tween[s], [call_event?] )
/// @description Finishes delay for selected tweens[s]
/// @param {Any} tween{s}
/// @param {Any} call_event
function TweenFinishDelay(_t, _callEvent=true) 
{		
	static _ = SharedTweener();
	
	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{
	    if (_t[TGMX_T_DELAY] > 0)
	    {
			//> Mark delay for removal from delay list
	        _t[@ TGMX_T_DELAY] = 0;
	        //> Execute FINISH DELAY event
	        if (_callEvent) { TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH_DELAY); }
			//> Set tween as active
	        _t[@ TGMX_T_STATE] = _t[TGMX_T_TARGET];                
			//> Preprocess tween
			TGMX_TweenPreprocess(_t);
			//> Process tween
			TGMX_TweenProcess(_t, 0, _t[TGMX_T_PROPERTY_DATA], is_struct(_t[TGMX_T_TARGET]) ? _t[TGMX_T_TARGET].ref : _t[TGMX_T_TARGET]);
			//> Execute PLAY event
	        TGMX_ExecuteEvent(_t, TWEEN_EV_PLAY);
	    }
	}
	else
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenFinishDelay, _callEvent);
	}
}


/// @function TweenDestroy( tween[s] )
/// @description Manually destroys selected tweens[s]
/// @param {Any} tween{s}
function TweenDestroy(_t) 
{	
	/*
	    Note: Tweens are always automatically destroyed when their target instance is destroyed.
	*/
	
	static _ = SharedTweener();
	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{
		if (_t[TGMX_T_STATE] == TGMX_T_STATE_DESTROYED)
		{
		    return undefined;
		}
    
		// NOTE: Don't need the extra map-check here, as the handle SHOULD always exist at this point, if reached
	
		// Invalidate tween handle
		ds_map_delete(global.TGMX.TweenIndexMap, _t[TGMX_T_ID]);
    
		// NOTE: We don't have to destroy the property list here... that will be done in the auto-cleaner
	
		_t[@ TGMX_T_STATE] = TGMX_T_STATE_DESTROYED; // Set state as destroyed
		_t[@ TGMX_T_ID] = undefined; // Nullify self reference
    
		// Invalidate tween target or destroy target instance depending on destroy mode
		if (_t[TGMX_T_DESTROY] == 2)
		{	
			if (!is_struct(_t[TGMX_T_TARGET]))
			{
				// Destroy Target Instance
			    if (instance_exists(_t[TGMX_T_TARGET]))
			    {
			        with(_t[TGMX_T_TARGET]) instance_destroy(_t[TGMX_T_TARGET]);
			    }
			    else
			    {
			        instance_activate_object(_t[TGMX_T_TARGET]); // Attempt to activate target by chance it was deactivated
			        with(_t[TGMX_T_TARGET]) instance_destroy(); // Attempt to destroy target
			    } 
			}
		}
	
		_t[@ TGMX_T_TARGET] = noone; // Invalidate tween target
		return undefined;
	}
	else
	if (is_struct(_t))
	{
		TGMX_TweensExecute(_t, TweenDestroy);
	}

	return undefined;
}


/// @function TweenDestroyWhenDone( tween[s], [destroy?], [kill_target?] )
/// @description Forces tween to be destroyed when finished or stopped
/// @param	{Any} tween{s}			tween id[s]
/// @param	{Any} [destroy?]		destroy tween[s] when finished or stopped?
/// @param	{Any} [kill_target?]	(optional) destroy target when tween finished or stopped?
function TweenDestroyWhenDone(_t, _destroy=1, _kill_target=0)
{	
	static _ = SharedTweener();
	
	_t = TGMX_FetchTween(_t);

	if (bool(_kill_target))
	{
		_destroy = 2;	
	}

	if (is_array(_t))
	{
		_t[@ TGMX_T_DESTROY] = real(_destroy);
	}
	else
	if (is_struct(_t))
	{
		TGMX_TweensExecute(_t, TweenDestroyWhenDone, real(_destroy));
	}
}





