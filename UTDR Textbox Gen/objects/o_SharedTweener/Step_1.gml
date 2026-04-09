/// @desc Process Tween Logic
/// Feather ignore all

//===================
// CLEAR EVENT MAPS -- USED BY TweenJust*() FUNCTIONS
//===================
var _ = global.TGMX.EventMaps;
if (!ds_map_empty(_[0]))  ds_map_clear(_[0]);
if (!ds_map_empty(_[1]))  ds_map_clear(_[1]);
if (!ds_map_empty(_[2]))  ds_map_clear(_[2]);
if (!ds_map_empty(_[3]))  ds_map_clear(_[3]);
if (!ds_map_empty(_[4]))  ds_map_clear(_[4]);
if (!ds_map_empty(_[5]))  ds_map_clear(_[5]);
if (!ds_map_empty(_[6]))  ds_map_clear(_[6]);
if (!ds_map_empty(_[7]))  ds_map_clear(_[7]);
if (!ds_map_empty(_[8]))  ds_map_clear(_[8]);
if (!ds_map_empty(_[9]))  ds_map_clear(_[9]);
if (!ds_map_empty(_[10])) ds_map_clear(_[10]);
if (!ds_map_empty(_[11])) ds_map_clear(_[11]);
if (!ds_map_empty(_[12])) ds_map_clear(_[12]);


//=======================
// MANAGE DELTA TIMING
//=======================
prevDeltaTime = deltaTime;      // STORE PREVIOUS PRACTICAL DELTA TIME FORMAT
deltaTime = delta_time/1000000; // UPDATE PRACTICAL DELTA TIME VALUE

// LET'S PREVENT DELTA TIME FROM EXHIBITING SPORADIC BEHAVIOUR, SHALL WE?
// IF THE DELTA TIME IS GREATER THAN THE MAX DELTA LIMIT...
if (deltaTime > maxDelta)
{
	deltaTime = deltaRestored ? maxDelta : prevDeltaTime; // USE MAX DELTA IF RESTORED, ELSE USE THE PREVIOUS DELTA TIME VALUE
	deltaRestored = true; // MARK DELTA TIME AS BEING RESTORED
}
else
{
    deltaRestored = false; // CLEAR RESTORED FLAG
}

deltaTime += addDelta; // ADJUST FOR UPDATE INTERVAL DIFFERENCE -- ONLY RELEVANT IF UPDATE INTERVAL NOT REACHED IN PREVIOUS STEP

//=================================
// PROCESS MAIN UPDATE LOOP
//=================================
var _tweens = tweens; // CACHE MAIN TWEENS LIST
var _time;
var _t; // USED TO REFERENCE INDIVIDUAL TWEEN DATA

inUpdateLoop = true;  // MARK UPDATE LOOP AS BEING PROCESSED

// IF SYSTEM IS ACTIVE
if (isEnabled)
{     
    tick += 1; // INCREMENT STEP TICK
	addDelta = tick < updateInterval ? addDelta+deltaTime : 0; // MAKE ADJUSTMENT FOR DELTA TIME IF UPDATE INTERVAL NOT ACHIEVED
    
    // WHILE THE SYSTEM TICK IS GREATER THAN THE SET STEP UPDATE INTERVAL -- UPDATE FOR DELTA TIMING???
    while (tick >= updateInterval)
    {   
        tick -= updateInterval;						// DECREMENT STEP TICK BY UPDATE INTERVAL VALUE
		var _timeScale = timeScale;					// CACHE TIME SCALE
		var _timeScaleDelta = _timeScale*deltaTime; // CACHE TIME SCALE AFFECTED BY DELTA TIME
		
        // IF SYSTEM TIME SCALE ISN'T "PAUSED"
        if (_timeScale != 0)
        {  
            //========================================
            // PROCESS TWEENS
            //========================================
            var _tIndex = -1; // TWEEN INDEX ITERATOR
			repeat(tweensProcessNumber)
            {	
				// GET NEXT TWEEN 
				_tIndex += 1; // (FASTEST INCREMENT FOR YYC)
                _t = _tweens[| _tIndex];
				
                // STATE IS HOLDING THE TWEEN'S TARGET IF TWEEN IS ACTIVE
				var _target = _t[TGMX_T_STATE];
				
				// DON'T PROCESS TWEEN IF TARGET DOESN'T EXIST -- COMPILER WILL STRIP OUT UNUSED SETTINGS
				if (TGMX_USE_TARGETS == TGMX_TARGETS_INSTANCE) // FORCE ONLY INSTANCE TARGET SUPPORT
				{
					if (instance_exists(_target)) {} else { continue; } // CONTINUE LOOP IF INSTANCE TARGET DOESN'T EXIST
				}
				if (TGMX_USE_TARGETS == TGMX_TARGETS_STRUCT) // FORCE ONLY STRUCT TARGET SUPPORT
				{
					if (weak_ref_alive(_target)) { _target = _target.ref; } else { continue; } // CONTINUE LOOP IF STRUCT TARGET DOESN'T EXIST
				}
				if (TGMX_USE_TARGETS == TGMX_TARGETS_DYNAMIC) // USE DYNAMIC INSTANCE/STRUCT TARGET SUPPORT
				{
					if (is_struct(_target)) // IF STRUCT TARGET
					{
						if (weak_ref_alive(_target)) { _target = _target.ref; } else { continue; } // CONTINUE LOOP IF STRUCT TARGET DOESN'T EXIST
					}
					else
					{
						if (instance_exists(_target)) {} else { continue; } // CONTINUE LOOP IF INSTANCE TARGET DOESN'T EXIST
					}
				}

				// UPDATE TWEEN'S TIME -- COMPILER WILL STRIP OUT UNUSED SETTINGS
				if (TGMX_USE_TIMING == TGMX_TIMING_STEP) // FORCE ONLY STEP TIMING SUPPORT
				{
					_time = _t[TGMX_T_TIME] + _t[TGMX_T_SCALE] * _timeScale * _t[TGMX_T_GROUP_SCALE][0];
				}
				if (TGMX_USE_TIMING == TGMX_TIMING_DELTA) // FORCE ONLY DELTA TIMING SUPPORT
				{
					_time = _t[TGMX_T_TIME] + _t[TGMX_T_SCALE] * _timeScaleDelta * _t[TGMX_T_GROUP_SCALE][0];
				}
				if (TGMX_USE_TIMING == TGMX_TIMING_DYNAMIC) // DYNAMIC STEP/DELTA TIMING SUPPORT
				{
					_time = _t[TGMX_T_TIME] + _t[TGMX_T_SCALE] * (_t[TGMX_T_DELTA] ? _timeScaleDelta : _timeScale) * _t[TGMX_T_GROUP_SCALE][0];
				}	
				
                // IF TWEEN TIME IS WITHIN 0 AND DURATION
				if (_time < _t[TGMX_T_DURATION] && _time > 0) // OPTIMISED -- CHECK TIME AGAINST DURATION FIRST (FASTER FOR YYC)
                {
					// Assign updated time
                    _t[@ TGMX_T_TIME] = _time;
					
					// PROCESS TWEEN -- THIS IS INLINED BELOW FOR OPTIMISATION PURPOSES
					//TGMX_TweenProcess(_t, _time, _t[TGMX_T_PROPERTY_DATA], _target); continue;
					
					// ***** INLINE VERSION OF TGMX_TweenProcess() FOR IMPROVED PERFORMANCE *****
					var _d = _t[TGMX_T_PROPERTY_DATA]; // CACHE TWEEN PROPERTY DATA

					switch(_d[0]) // PROPERTY COUNT
					{
					case 1:
						if (is_method(_t[TGMX_T_EASE])) 
						{ 
							_d[1](_t[TGMX_T_EASE](_time, _d[2], _d[3], _t[TGMX_T_DURATION], _t), _target, _d[4], _t); // note: _d[4] is variable string name
						} 
						else 
						{ 
							_d[1](_d[2] + _d[3]*animcurve_channel_evaluate(_t[TGMX_T_EASE], _time/_t[TGMX_T_DURATION]), _target, _d[4], _t); 
						}
					break;
					
					case 2:
						_time = is_method(_t[TGMX_T_EASE]) ? _t[TGMX_T_EASE](_time, 0, 1, _t[TGMX_T_DURATION], _t) : animcurve_channel_evaluate(_t[TGMX_T_EASE], _time/_t[TGMX_T_DURATION]);
						_d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
						_d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					break;
					
					case 3:
						_time = is_method(_t[TGMX_T_EASE]) ? _t[TGMX_T_EASE](_time, 0, 1, _t[TGMX_T_DURATION], _t) : animcurve_channel_evaluate(_t[TGMX_T_EASE], _time/_t[TGMX_T_DURATION]);
					    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					break;
					
					case 4:
						_time = is_method(_t[TGMX_T_EASE]) ? _t[TGMX_T_EASE](_time, 0, 1, _t[TGMX_T_DURATION], _t) : animcurve_channel_evaluate(_t[TGMX_T_EASE], _time/_t[TGMX_T_DURATION]);
					    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
						_d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					break;
					
					case 5:
						_time = is_method(_t[TGMX_T_EASE]) ? _t[TGMX_T_EASE](_time, 0, 1, _t[TGMX_T_DURATION], _t) : animcurve_channel_evaluate(_t[TGMX_T_EASE], _time/_t[TGMX_T_DURATION]);
					    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
					break;
					
					case 6:
						_time = is_method(_t[TGMX_T_EASE]) ? _t[TGMX_T_EASE](_time, 0, 1, _t[TGMX_T_DURATION], _t) : animcurve_channel_evaluate(_t[TGMX_T_EASE], _time/_t[TGMX_T_DURATION]);
					    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
					    _d[21](_time*_d[23]+_d[22], _target, _d[24], _t);
					break;
					
					case 7:
					    _time = is_method(_t[TGMX_T_EASE]) ? _t[TGMX_T_EASE](_time, 0, 1, _t[TGMX_T_DURATION], _t) : animcurve_channel_evaluate(_t[TGMX_T_EASE], _time/_t[TGMX_T_DURATION]);
						_d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
					    _d[21](_time*_d[23]+_d[22], _target, _d[24], _t);
					    _d[25](_time*_d[27]+_d[26], _target, _d[28], _t);
					break;
					
					case 8:
					    _time = is_method(_t[TGMX_T_EASE]) ? _t[TGMX_T_EASE](_time, 0, 1, _t[TGMX_T_DURATION], _t) : animcurve_channel_evaluate(_t[TGMX_T_EASE], _time/_t[TGMX_T_DURATION]);
						_d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
					    _d[21](_time*_d[23]+_d[22], _target, _d[24], _t);
					    _d[25](_time*_d[27]+_d[26], _target, _d[28], _t);
						_d[29](_time*_d[31]+_d[30], _target, _d[32], _t);
					break;
					
					case 9:
						_time = is_method(_t[TGMX_T_EASE]) ? _t[TGMX_T_EASE](_time, 0, 1, _t[TGMX_T_DURATION], _t) : animcurve_channel_evaluate(_t[TGMX_T_EASE], _time/_t[TGMX_T_DURATION]);
					    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
					    _d[21](_time*_d[23]+_d[22], _target, _d[24], _t);
					    _d[25](_time*_d[27]+_d[26], _target, _d[28], _t);
						_d[29](_time*_d[31]+_d[30], _target, _d[32], _t);
						_d[33](_time*_d[35]+_d[34], _target, _d[36], _t);
					break;
					
					case 10:
						_time = is_method(_t[TGMX_T_EASE]) ? _t[TGMX_T_EASE](_time, 0, 1, _t[TGMX_T_DURATION], _t) : animcurve_channel_evaluate(_t[TGMX_T_EASE], _time/_t[TGMX_T_DURATION]);
					    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
					    _d[21](_time*_d[23]+_d[22], _target, _d[24], _t);
					    _d[25](_time*_d[27]+_d[26], _target, _d[28], _t);
						_d[29](_time*_d[31]+_d[30], _target, _d[32], _t);
						_d[33](_time*_d[35]+_d[34], _target, _d[36], _t);
						_d[37](_time*_d[39]+_d[38], _target, _d[40], _t);
					break;
					
					case 0: 
						// Break out for tweens with no properties
					break;
					
					default: // Handle "unlimited" property count
						_time = is_method(_t[TGMX_T_EASE]) ? _t[TGMX_T_EASE](_time, 0, 1, _t[TGMX_T_DURATION], _t) : animcurve_channel_evaluate(_t[TGMX_T_EASE], _time/_t[TGMX_T_DURATION]);
						_d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
					    _d[21](_time*_d[23]+_d[22], _target, _d[24], _t);
					    _d[25](_time*_d[27]+_d[26], _target, _d[28], _t);
						_d[29](_time*_d[31]+_d[30], _target, _d[32], _t);
						_d[33](_time*_d[35]+_d[34], _target, _d[36], _t);
						_d[37](_time*_d[39]+_d[38], _target, _d[40], _t);
						_d[41](_time*_d[43]+_d[42], _target, _d[44], _t);
						
						i = 45;
						repeat(_d[0]-11)
						{
							_d[i](_time*_d[i+2]+_d[i+1], _target, _d[i+3], _t);
							i += 4;
						}
					break;
					}
				}
                else // Tween has reached start or destination
				{
					TGMX_TweenHasReachedBounds(_t, _target, _time, _timeScaleDelta);
				}
            }
			
			
			//==================================
            // Process Delays
            //==================================
            var _delayedTweens = delayedTweens; // Cache list of delayed tweens
			_tIndex = -1; // Reset tween index iterator
            repeat(delaysProcessNumber)
            {
				// GET NEXT TWEEN FROM DELAYED TWEENS LIST
				_tIndex += 1;
                _t = _delayedTweens[| _tIndex];
    
                // IF tween instance exists AND delay is NOT destroyed
                if (_t[TGMX_T_STATE] == TGMX_T_STATE_DELAYED && (is_struct(_t[TGMX_T_TARGET]) ? weak_ref_alive(_t[TGMX_T_TARGET]) : instance_exists(_t[TGMX_T_TARGET])))
                { 
					// Decrement delay timer
					_t[@ TGMX_T_DELAY] = _t[TGMX_T_DELAY] - abs(_t[TGMX_T_SCALE]) * (_t[TGMX_T_DELTA] ? _timeScaleDelta : _timeScale)  * _t[TGMX_T_GROUP_SCALE][0];
					
                    // IF the delay timer has expired
                    if (_t[TGMX_T_DELAY] <= 0)
                    {	
						// Remove tween from delay list
                        ds_list_delete(_delayedTweens, _tIndex--); 
						// Set time to delay overflow
						_t[@ TGMX_T_TIME] = abs(_t[TGMX_T_DELAY]);
						// Indicate that delay has been removed from delay list
                        _t[@ TGMX_T_DELAY] = 0;										
                        // Execute FINISH DELAY event
						TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH_DELAY);
						// Set tween as active 
                        _t[@ TGMX_T_STATE] = _t[TGMX_T_TARGET];  
						// Process tween data
						TGMX_TweenPreprocess(_t);
                        // Update property with start value    
						TGMX_TweenProcess(_t, _t[TGMX_T_TIME], _t[TGMX_T_PROPERTY_DATA], is_struct(_t[TGMX_T_TARGET]) ? _t[TGMX_T_TARGET].ref : _t[TGMX_T_TARGET]); // TODO: Verify that overflow is working
						// Execute PLAY event callbacks
						TGMX_ExecuteEvent(_t, TWEEN_EV_PLAY);
                    }
                }
                else // If delay is marked for removal or tween is destroyed
                if (_t[TGMX_T_DELAY] == 0 || _t[TGMX_T_STATE] == TGMX_T_STATE_DESTROYED)
                {
                    ds_list_delete(_delayedTweens, _tIndex--); // Remove tween from delay list
                }
            }
        }
    }
}

//==================================
// EVENT CLEANER -- This needs to stay above "Passive Tween Cleaner" to prevent errors
//==================================
if (ds_priority_size(eventCleaner))
{
    var _event = ds_priority_delete_min(eventCleaner); // GET EVENT TO CHECK FOR CLEANING

	// CYCLE THROUGH ALL CALLBACKS, EXCEPT THE NEW ONE -- MAKE SURE NOT TO CHECK EVENT STATUS INDEX IN EVENT[0]
    var _cbCheckIndex = ds_list_size(_event);
    repeat(_cbCheckIndex-1)
    {
		var _cb = _event[| --_cbCheckIndex];
		
		if (_cb[TGMX_CB_TWEEN] == TWEEN_NULL) 
		{
			ds_list_delete(_event, _cbCheckIndex); 
		}
		else
		{
			var _cbTarget = _cb[TGMX_CB_TARGET];
			
			if (is_struct(_cbTarget)) // STRUCT TARGET
			{
				if (!weak_ref_alive(_cbTarget))
				{
					ds_list_delete(_event, _cbCheckIndex);
				}
			}
			else // INSTANCE TARGET
			{
				if (!instance_exists(_cbTarget)) // CHECK IF TARGET DOESN'T EXIST
			    {	
					instance_activate_object(_cbTarget); // ATTEMPT TO ACTIVATE INSTANCE
		    
				    if (instance_exists(_cbTarget)) // IF TARGET EXISTS, PUT INSTANCE BACK TO DEACTIVATED STATE
					{	
				        instance_deactivate_object(_cbTarget);
				    }
				    else // REMOVE CALLBACK FROM EVENT
				    {	
						ds_list_delete(_event, _cbCheckIndex); 
			    	}
			    }
			}	
		}
    }
}


//=========================================
// PASSIVE TWEEN CLEANER
//=========================================
// CHECK TO SEE IF SYSTEM IS BEING FLUSHED
// ELSE CLAMP NUMBER OF CLEANING ITERATIONS
var _cleanIterations;
if (flushDestroyed)
{
    flushDestroyed = false;                   // CLEAR "FLUSH" FLAG
    autoCleanIndex = ds_list_size(_tweens);   // SET STARTING CLEAN INDEX TO LIST SIZE
    _cleanIterations = ds_list_size(_tweens); // SET NUMBER OF ITERATIONS TO LIST SIZE
}
else
{
    _cleanIterations = min(autoCleanIterations, autoCleanIndex, ds_list_size(_tweens)); // CLAMP!
}

// START THE CLEANING!
repeat(_cleanIterations)
{   
    // GET NEXT TWEEN TO CHECK FOR REMOVAL
	autoCleanIndex -= 1;
    _t = _tweens[| autoCleanIndex];
    
	if (is_struct(_t[TGMX_T_TARGET])) // IS STRUCT TARGET
	{
		// LET'S SEE IF THE STRUCT IS 'DEAD'
		if (!weak_ref_alive(_t[TGMX_T_TARGET]))
		{
			// REMOVE TWEEN FROM TWEENS LIST
            ds_list_delete(_tweens, autoCleanIndex); 
			// SET TWEEN STATE AS DESTROYED
			_t[@ TGMX_T_STATE] = TGMX_T_STATE_DESTROYED; 
            
			// INVALIDATE TWEEN HANDLE
            if (ds_map_exists(global.TGMX.TweenIndexMap, _t[TGMX_T_ID]))
            {
                ds_map_delete(global.TGMX.TweenIndexMap, _t[TGMX_T_ID]);
			}
            
			// DESTROY TWEEN EVENTS IF EVENTS MAP EXISTS
	        if (_t[TGMX_T_EVENTS] != -1)
	        {
	            ds_map_destroy(_t[TGMX_T_EVENTS]); // DESTROY EVENTS MAP -- INTERNAL LISTS ARE MARKED
	        }
		}
	}
	else // CHECK IF INSTANCE TARGET DOES NOT EXIST
	{
		if (!instance_exists(_t[TGMX_T_TARGET]))
	    {
	        // ATTEMPT TO ACTIVATE TARGET INSTANCE
			instance_activate_object(_t[TGMX_T_TARGET]);
			
			// IF INSTANCE NOW EXISTS, PUT IT BACK TO DEACTIVATED STATE
	        if (instance_exists(_t[TGMX_T_TARGET]))
	        {
	            instance_deactivate_object(_t[TGMX_T_TARGET]);
	        }
	        else // HANDLE TWEEN DESTRUCTION...
	        {
				// REMOVE TWEEN FROM TWEENS LIST
	            ds_list_delete(_tweens, autoCleanIndex);  
				// SET TWEEN STATE AS DESTROYED
				_t[@ TGMX_T_STATE] = TGMX_T_STATE_DESTROYED;
	            
				// INVALIDATE TWEEN HANDLE
	            if (ds_map_exists(global.TGMX.TweenIndexMap, _t[TGMX_T_ID]))
	            {
	                ds_map_delete(global.TGMX.TweenIndexMap, _t[TGMX_T_ID]);
				}
	            
				// DESTROY TWEEN EVENTS IF EVENTS MAP EXISTS
	            if (_t[TGMX_T_EVENTS] != -1)
	            {
	                ds_map_destroy(_t[TGMX_T_EVENTS]); // DESTROY EVENTS MAP -- INTERNAL LISTS ARE MARKED
	            }
	        }
	    }
	}
}

// PLACE AUTO CLEAN INDEX TO SIZE OF TWEENS LIST IF BELOW OR EQUAL TO 0
if (autoCleanIndex <= 0) { autoCleanIndex = ds_list_size(_tweens); }

// INDICATE THAT WE ARE FINISHED PROCESSING THE MAIN UPDATE LOOP
inUpdateLoop = false;

// STATE CHANGER
repeat(ds_queue_size(stateChanger) div 2)
{
	_t = ds_queue_dequeue(stateChanger);
	var _state = ds_queue_dequeue(stateChanger);
	
	if (TweenExists(_t))
	{
		_t[@ TGMX_T_STATE] = _state;
	}
}






