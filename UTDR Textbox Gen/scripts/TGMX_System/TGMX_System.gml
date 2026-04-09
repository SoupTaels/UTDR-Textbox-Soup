
// [TweenGMX 1.0.8]

// Feather ignore all

/// QUICK LOOKUP (F1 OR MMB)
/// TGMX_Tween | TGMX_TweenPreprocess | TGMX_TweenProcess | TGMX_StringStrip | TGMX_ExecuteEvent

// SET SHARED TWEENER TO BE AUTOMATICALLY CREATED IN FIRST ROOM
//room_instance_add(room_first, 0, 0, o_SharedTweener);

//-------------------------------
// MACROS
//-------------------------------

// SPECIAL TWEEN IDS
#macro TWEEN_DEFAULT 1
#macro TWEEN_NULL undefined

// TWEEN SELF REFERENCING -- WE FIRST CHECK IF UNDEFINED TO SEE IF WE SHOULD GRAB VALUE FROM ARGUMENT SCRIPT RATHER THAN DIRECTLY
#macro TWEEN_SELF (global.TGMX.tween_self ?? array_get(argument[3], TGMX_T_ID))
// HIDE SYNTAX "ERROR" FOR WHEN FEATHER DISABLED
if (false){ if (TWEEN_SELF){} }

// TWEEN CALLBACK SELF REFERENCING
#macro TWEEN_CALLBACK_SELF global.TGMX.tween_callback_self

// TWEEN PLAY MODES
#macro TWEEN_MODE_ONCE 0   // TWEEN PLAYS FROM START TO FINISH, ONCE
#macro TWEEN_MODE_BOUNCE 1 // TWEEN PLAYS FROM START TO FINISH BEFORE PLAYING BACK TO START
#macro TWEEN_MODE_PATROL 2 // TWEEN PLAYS BACK AND FORTH BETWEEN START AND FINISH -- CONTINUES UNTIL MANUALLY STOPPED
#macro TWEEN_MODE_LOOP 3   // TWEEN LOOPS FROM START TO FINISH -- CONTINUES UNTIL MANUALLY STOPPED
#macro TWEEN_MODE_REPEAT 4 // TWEEN USES FINISH POSITION AS A NEW RELATIVE STARTING POSITION -- CONTINUES UNTIL MANUALLY STOOPPED

// TWEEN EVENT TYPES
#macro TWEEN_EV_PLAY 0			// WHEN TWEEN STARTS TO PLAY
#macro TWEEN_EV_FINISH 1		// WHEN TWEEN FINISHES PLAYING
#macro TWEEN_EV_STOP 2			// WHEN TWEEN IS STOPPED MANUALLY
#macro TWEEN_EV_PAUSE 3			// WHEN TWEEN IS PAUSED MANUALLY
#macro TWEEN_EV_RESUME 4		// WHEN TWEEN IS RESUMED MANUALLY
#macro TWEEN_EV_CONTINUE 5		// WHEN TWEEN BOUNCES, PATROLS, LOOPS, OR REPEATS
#macro TWEEN_EV_REVERSE 6		// WHEN TWEEN IS REVERSED MANUALLY
#macro TWEEN_EV_STOP_DELAY 7	// WHEN TWEEN IS STOPPED WHILE IT IS DELAYED
#macro TWEEN_EV_PAUSE_DELAY 8	// WHEN TWEEN IS PAUSED WHILE DELAYED
#macro TWEEN_EV_RESUME_DELAY 9	// WHEN TWEEN IS RESUMED WHILE DELAYED
#macro TWEEN_EV_FINISH_DELAY 10	// WHEN TWEEN'S DELAY FINISHES -- CALLED JUST BEFORE TWEEN_EV_PLAY
#macro TWEEN_EV_REST 11
#macro TWEEN_EV_RESTING 12
#macro TWEEN_EV_TOTAL_EVENTS 13

// TWEEN USER PROPERTIES
#macro TWEEN_USER_VALUE global.TGMX.user_value	 // TWEENED VALUE PASSED TO USER EVENT
#macro TWEEN_USER_TARGET global.TGMX.user_target // TWEENED TARGET PASSED TO USER EVENT
#macro TWEEN_USER_GET global.TGMX.tween_user_get // USED TO ALLOW 'GETTERS' FOR USER EVENT PROPERTIES
#macro TWEEN_USER_DATA global.TGMX.user_data	 // OPTIONAL DATA PASSED TO USER EVENT PROPRETIES
	
// TWEEN DATA
#macro TGMX_T_STATE 0
#macro TGMX_T_DURATION 1
#macro TGMX_T_DURATION_RAW 2
#macro TGMX_T_DELTA 3
#macro TGMX_T_SCALE 4
#macro TGMX_T_TIME 5
#macro TGMX_T_TARGET 6
#macro TGMX_T_EASE 7
#macro TGMX_T_PROPERTY_DATA 8
#macro TGMX_T_PROPERTY_DATA_RAW 9
#macro TGMX_T_GROUP 10
#macro TGMX_T_GROUP_SCALE 11
#macro TGMX_T_DIRECTION 12
#macro TGMX_T_EVENTS 13
#macro TGMX_T_DESTROY 14
#macro TGMX_T_MODE 15
#macro TGMX_T_DELAY 16
#macro TGMX_T_DELAY_START 17
#macro TGMX_T_ID 18
#macro TGMX_T_AMOUNT 19
#macro TGMX_T_CALLER 20
#macro TGMX_T_OTHER 21
#macro TGMX_T_REST 22
#macro TGMX_T_CONTINUE_COUNT 23
#macro TGMX_T_EASE_RAW 24
#macro TGMX_T_DATA_SIZE 25 // THIS HOLDS THE ARRAY SIZE FOR TWEEN DATA
// THE REMAINING MACROS DO NOT HOLD ACTUAL DATA LOCATIONS FOR EACH TWEEN
//#macro TGMX_T_CHANGE 26
#macro TGMX_T_START 27
#macro TGMX_T_DESTINATION 28
#macro TGMX_T_PROPERTY 29
#macro TGMX_T_RAW_START 30
#macro TGMX_T_RAW_DESTINATION 31
	
// TWEEN STATES
#macro TGMX_T_STATE_DESTROYED -4
#macro TGMX_T_STATE_STOPPED -10
#macro TGMX_T_STATE_PAUSED -11
#macro TGMX_T_STATE_DELAYED -12
	
// TWEEN CALLBACK DATA
#macro TGMX_CB_TWEEN 0
#macro TGMX_CB_ENABLED 1
#macro TGMX_CB_TARGET 2
#macro TGMX_CB_SCRIPT 3
#macro TGMX_CB_ARG 4


/// @ignore
/// @function TGMX_Begin()
/// @description TGMX ADMIN: Initialization
function TGMX_Begin()
{	
	// Feather ignore all
	
	// MAKE SURE THIS IS FIRED ONLY ONCE
	static __initialized = false;
	if (__initialized) { return 0; }
	__initialized = true;
	
	// TEMPORARY WORKAROUND (FOR HTML5 BUG? IS THIS STILL NEEDED??)
	method_get_index(function(){}); 
	
	global.TGMX = {}; 
	global.TGMX.SharedTweener = noone;
	global.TGMX.tween_self = undefined;
	global.TGMX.TweenIndexMap = ds_map_create();
	global.TGMX.GroupScales = ds_map_create();
	global.TGMX.PropertySetters = ds_map_create();
	global.TGMX.PropertyGetters = ds_map_create();
	global.TGMX.PropertyNormals = ds_map_create();
	global.TGMX.Cache = ds_map_create();
	global.TGMX.TweenDefault = array_create(TGMX_T_DATA_SIZE);
	
	//-----------------------------------------------
	// DECLARE DEFAULT GLOBAL SYSTEM-WIDE SETTINGS
	//-----------------------------------------------
	global.TGMX.IsEnabled = true;         // SYSTEM'S ACTIVE STATE BOOLEAN
	global.TGMX.TimeScale = 1.0;          // EFFECTS OVERALL SPEED OF HOW FAST SYSTEM PLAYS TWEENS/DELAYS
	global.TGMX.MinDeltaFPS = 10;         // THE LOWEST FRAMERATE BEFORE DELTA TWEENS WILL BEGIN TO LAG BEHIND (IDEALLY, KEEP BETWEEN 10-15)
	global.TGMX.UpdateInterval = 1.0;     // SETS HOW OFTEN (IN STEPS) SYSTEM WILL UPDATE (1 = DEFAULT, 2 = HALF SPEED, 0.5 = DOUBLE SPEED) DO NOT SET AS 0 OR BELOW!!
	global.TGMX.AutoCleanIterations = 10; // LIMITS, EACH STEP, NUMBER OF TWEENS PASSIVELY CHECKED BY MEMORY MANAGER (DEFAULT:10)
	global.TGMX.EasyUseDelta = false;	  // EASY TWEENS USE DELTA TIME?
	global.TGMX.GroupScales[? 0] = [1.0]; // SET DEFAULT GROUP 0 TO USE A DEFAULT TIME SCALE OF 1.0
	global.TGMX.TweensIncludeDeactivated = false; // WHETHER OR NOT TO INCLUDE TWEEN'S ASSOCIATED WITH DEACTIVATED TARGETS WHEN SELECTING TWEENS

	//-------------------------------------------------
	// INITIATE TWEEN INDEX SUPPLIER AND REFERENCE MAP
	//-------------------------------------------------
	global.TGMX.TweenIndex = 1;
	global.TGMX.tween_self = undefined;
	global.TGMX.tween_callback_self = undefined;
	
	// INITIALISE EVENT MAPS FOR TweenIs*() SCRIPTS
	global.TGMX.EventMaps = array_create(TWEEN_EV_TOTAL_EVENTS);
	var i = -1;
	repeat(TWEEN_EV_TOTAL_EVENTS)
	{
		global.TGMX.EventMaps[++i] = ds_map_create();
	}

	//-----------------------------
	// TWEEN DATA LABEL INDEXING --> SOUNDS FANCIER THAN IT REALLY IS!
	//-----------------------------
	global.TGMX.TweenDataLabelMap = ds_map_create();
	var _ = global.TGMX.TweenDataLabelMap;
	
	_[? "target"] = TGMX_T_TARGET;
	_[? "?"] = TGMX_T_TARGET;
	_[? "time"] = TGMX_T_TIME;
	_[? "="] = TGMX_T_TIME;
	_[? "scale"] = TGMX_T_SCALE;
	_[? "timescale"] = TGMX_T_SCALE;
	_[? "*"] = TGMX_T_SCALE;
	_[? "amount"] = TGMX_T_AMOUNT;
	_[? "timeamount"] = TGMX_T_AMOUNT;
	_[? "%"] = TGMX_T_AMOUNT;
	_[? "ease"] = TGMX_T_EASE;
	_[? "~"] = TGMX_T_EASE;
	_[? "start"] = TGMX_T_START;
	_[? "destination"] = TGMX_T_DESTINATION;
	_[? "dest"] = TGMX_T_DESTINATION;
	_[? "rawstart"] = TGMX_T_RAW_START;
	_[? "rawdestination"] = TGMX_T_RAW_DESTINATION;
	_[? "rawdest"] = TGMX_T_RAW_DESTINATION;
	_[? "duration"] = TGMX_T_DURATION;
	_[? "$"] = TGMX_T_DURATION;
	_[? "dur"] = TGMX_T_DURATION;
	_[? "rest"] = TGMX_T_REST;
	_[? "|"] = TGMX_T_REST;
	_[? "delay"] = TGMX_T_DELAY;
	_[? "delaystart"] = TGMX_T_DELAY_START;
	_[? "group"] = TGMX_T_GROUP;
	_[? "&"] = TGMX_T_GROUP;
	_[? "state"] = TGMX_T_STATE;
	_[? "mode"] = TGMX_T_MODE;
	_[? "#"] = TGMX_T_MODE;
	_[? "delta"] = TGMX_T_DELTA;
	_[? "^"] = TGMX_T_DELTA;
	_[? "property"] = TGMX_T_PROPERTY;
	_[? "properties"] = TGMX_T_PROPERTY;
	_[? "prop"] = TGMX_T_PROPERTY;
	_[? "continuecount"] = TGMX_T_CONTINUE_COUNT;
	_[? "count"] = TGMX_T_CONTINUE_COUNT;
	_[? "cc"] = TGMX_T_CONTINUE_COUNT;
	_[? "caller"] = TGMX_T_CALLER;
	
	_[? TGMX_T_TARGET] = TGMX_T_TARGET;
	_[? TGMX_T_PROPERTY_DATA_RAW] = TGMX_T_PROPERTY_DATA_RAW;
	_[? TGMX_T_TIME] = TGMX_T_TIME;
	_[? TGMX_T_SCALE] = TGMX_T_SCALE;
	_[? TGMX_T_AMOUNT] = TGMX_T_AMOUNT;
	_[? TGMX_T_EASE] = TGMX_T_EASE;
	_[? TGMX_T_START] = TGMX_T_START;
	_[? TGMX_T_DESTINATION] = TGMX_T_DESTINATION;
	_[? TGMX_T_DURATION] = TGMX_T_DURATION;
	_[? TGMX_T_DELAY] = TGMX_T_DELAY;
	_[? TGMX_T_DELAY_START] = TGMX_T_DELAY_START;
	_[? TGMX_T_GROUP] = TGMX_T_GROUP;
	_[? TGMX_T_STATE] = TGMX_T_STATE;
	_[? TGMX_T_MODE] = TGMX_T_MODE;
	_[? TGMX_T_DELTA] = TGMX_T_DELTA;
	_[? TGMX_T_CALLER] = TGMX_T_CALLER;

	//------------------------------------------------------------------------------------------------
	// SET SUPPORTED LABELS FOR TWEEN "TAGS".
	// THERE ARE MULTIPLE VALUES FOR EACH PROPERTY, ALLOWING FOR ALTERNATIVE AND SHORTHAND LABELS.
	// MODIFY OR ADD YOUR OWN LABELS AS DESIRED!!! :)
	//------------------------------------------------------------------------------------------------

	global.TGMX.ArgumentLabels = ds_map_create();
	_ = global.TGMX.ArgumentLabels;

	// TWEEN CHAIN
	_[? ">>"] = 0;
	// CONTINUE COUNT
	_[? ">"] = TGMX_T_CONTINUE_COUNT;
	_[? "-continuecount"] = TGMX_T_CONTINUE_COUNT;
	_[? "-count"] = TGMX_T_CONTINUE_COUNT;
	_[? "-cc"] = TGMX_T_CONTINUE_COUNT;
	// TARGET
	_[? "-target"] = TGMX_T_TARGET;
	_[? "?"] = TGMX_T_TARGET;
	// EASE
	_[? "-ease"] = TGMX_T_EASE;
	_[? "~"] = TGMX_T_EASE;
	// MODE
	_[? "-mode"] = TGMX_T_MODE;
	_[? "#"] = TGMX_T_MODE;
	// DURATION
	_[? "-duration"] = TGMX_T_DURATION;
	_[? "-dur"] = TGMX_T_DURATION;
	_[? "$"] = TGMX_T_DURATION;
	// DELTA (USE SECONDS?)
	_[? "-delta"] = TGMX_T_DELTA;
	_[? "^"] = TGMX_T_DELTA;
	// DELAY
	_[? "-delay"] = TGMX_T_DELAY;
	_[? "+"] = TGMX_T_DELAY;
	// REST
	_[? "-rest"] = TGMX_T_REST;
	_[? "|"] = TGMX_T_REST;
	// GROUP
	_[? "-group"] = TGMX_T_GROUP;
	_[? "&"] = TGMX_T_GROUP;
	// TIME
	_[? "-time"] = TGMX_T_TIME;
	_[? "="] = TGMX_T_TIME;
	// TIME AMOUNT / POSITION -- RELATIVE VALUE BETWEEN 0 AND 1
	_[? "-timeamount"] = TGMX_T_AMOUNT;
	_[? "-amount"] = TGMX_T_AMOUNT;
	_[? "%"] = TGMX_T_AMOUNT;
	// TIME SCALE
	_[? "-timescale"] = TGMX_T_SCALE;
	_[? "-scale"] = TGMX_T_SCALE;
	_[? "*"] = TGMX_T_SCALE;
	// AUTO-DESTROY
	_[? "-destroy"] = TGMX_T_DESTROY;
	_[? "!"] = TGMX_T_DESTROY;

	// ADD ARGUMENT LABELS TO THE LABEL MAP
	var _key = ds_map_find_first(_);
	repeat(ds_map_size(_))
	{
		global.TGMX.TweenDataLabelMap[? _key] = _[? _key];
		_key = ds_map_find_next(_, _key);
	}

	// THIS IS THE SAME MAP AS ABOVE... THIS IS NOT CLEAR AT A GLANCE!!!!
	// CALLBACK EVENTS
	_[? "@"] = TWEEN_EV_FINISH;
	_[? "@finish"] = TWEEN_EV_FINISH;
	_[? "@finished"] = TWEEN_EV_FINISH;
	_[? "@continue"] = TWEEN_EV_CONTINUE;
	_[? "@continued"] = TWEEN_EV_CONTINUE;
	_[? "@pause"] = TWEEN_EV_PAUSE;
	_[? "@paused"] = TWEEN_EV_PAUSE;
	_[? "@play"] = TWEEN_EV_PLAY;
	_[? "@played"] = TWEEN_EV_PLAY;
	_[? "@resume"] = TWEEN_EV_RESUME;
	_[? "@resumed"] = TWEEN_EV_RESUME;
	_[? "@stop"] = TWEEN_EV_STOP;
	_[? "@stopped"] = TWEEN_EV_STOP;
	_[? "@reverse"] = TWEEN_EV_REVERSE;
	_[? "@reversed"] = TWEEN_EV_REVERSE;
	_[? "@rest"] = TWEEN_EV_REST;
	_[? "@rested"] = TWEEN_EV_REST;
	_[? "@resting"] = TWEEN_EV_RESTING;
	_[? "@finishdelay"] = TWEEN_EV_FINISH_DELAY;
	_[? "@delayfinish"] = TWEEN_EV_FINISH_DELAY;
	_[? "@finisheddelay"] = TWEEN_EV_FINISH_DELAY;
	_[? "@delayfinished"] = TWEEN_EV_FINISH_DELAY;
	_[? "@pausedelay"] = TWEEN_EV_PAUSE_DELAY;
	_[? "@delaypause"] = TWEEN_EV_PAUSE_DELAY;
	_[? "@pauseddelay"] = TWEEN_EV_PAUSE_DELAY;
	_[? "@delaypaused"] = TWEEN_EV_PAUSE_DELAY;
	_[? "@resumedelay"] = TWEEN_EV_RESUME_DELAY;
	_[? "@delayresume"] = TWEEN_EV_RESUME_DELAY;
	_[? "@resumeddelay"] = TWEEN_EV_RESUME_DELAY;
	_[? "@delayresumed"] = TWEEN_EV_RESUME_DELAY;
	_[? "@stopdelay"] = TWEEN_EV_STOP_DELAY;
	_[? "@delaystop"] = TWEEN_EV_STOP_DELAY;
	_[? "@stoppeddelay"] = TWEEN_EV_STOP_DELAY;
	_[? "@delaystopped"] = TWEEN_EV_STOP_DELAY;

	// CREATE A SHORTHAND LOOKUP TABLE FOR SHORTHAND SYMBOLS
	_ = array_create(128, false);
	_[0]   = false;
	_[33]  = TGMX_T_DESTROY;		// "!"
	_[35]  = TGMX_T_MODE;			// "#"
	_[36]  = TGMX_T_DURATION;		// "$"
	_[37]  = TGMX_T_AMOUNT;			// "%"
	_[38]  = TGMX_T_GROUP;			// "&"
	_[42]  = TGMX_T_SCALE;			// "*"
	_[43]  = TGMX_T_DELAY;			// "+"
	_[45]  = true;					// "-" THIS IS AN EXCEPTION! This is used to check for off-rail tweens -- !! DOCUMENT THIS OR CREATE A NEW TABLE !!
	_[61]  = TGMX_T_TIME;			// "="
	_[62]  = TGMX_T_CONTINUE_COUNT;	// ">"
	_[94]  = TGMX_T_DELTA;			// "^"
	_[124] = TGMX_T_REST;			// "|"
	_[126] = TGMX_T_EASE;			// "~"
	global.TGMX.ShorthandTable = _;
	

	//====================//
	// MODE "SHORT CODES" //
	//====================//
	global.TGMX.ShortCodesMode = ds_map_create();
	_ = global.TGMX.ShortCodesMode;

	// MODE "SHORT CODES"
	_[? "#0"] = TWEEN_MODE_ONCE;		_[? "0"] = TWEEN_MODE_ONCE;
	_[? "#o"] = TWEEN_MODE_ONCE;		_[? "o"] = TWEEN_MODE_ONCE;
	_[? "#once"] = TWEEN_MODE_ONCE;		_[? "once"] = TWEEN_MODE_ONCE;
	
	_[? "#1"] = TWEEN_MODE_BOUNCE;		_[? "1"] = TWEEN_MODE_BOUNCE;
	_[? "#b"] = TWEEN_MODE_BOUNCE;		_[? "b"] = TWEEN_MODE_BOUNCE;
	_[? "#bounce"] = TWEEN_MODE_BOUNCE;	_[? "bounce"] = TWEEN_MODE_BOUNCE;
	
	_[? "#2"] = TWEEN_MODE_PATROL;		_[? "2"] = TWEEN_MODE_PATROL;
	_[? "#p"] = TWEEN_MODE_PATROL;		_[? "p"] = TWEEN_MODE_PATROL;
	_[? "#patrol"] = TWEEN_MODE_PATROL; _[? "patrol"] = TWEEN_MODE_PATROL;
	
	_[? "#3"] = TWEEN_MODE_LOOP;		_[? "3"] = TWEEN_MODE_LOOP;
	_[? "#l"] = TWEEN_MODE_LOOP;		_[? "l"] = TWEEN_MODE_LOOP;
	_[? "#loop"] = TWEEN_MODE_LOOP;		_[? "loop"] = TWEEN_MODE_LOOP;
	
	_[? "#4"] = TWEEN_MODE_REPEAT;		_[? "4"] = TWEEN_MODE_REPEAT;
	_[? "#r"] = TWEEN_MODE_REPEAT;		_[? "r"] = TWEEN_MODE_REPEAT;
	_[? "#repeat"] = TWEEN_MODE_REPEAT;	_[? "repeat"] = TWEEN_MODE_REPEAT;
	
	//---------------------------
	// SET DEFAULT TWEEN
	//---------------------------
	_ = global.TGMX.TweenDefault;
	_[@ TGMX_T_ID] = TWEEN_DEFAULT;
	_[@ TGMX_T_TARGET] = noone;
	_[@ TGMX_T_EASE] = EaseLinear;
	_[@ TGMX_T_EASE_RAW] = EaseLinear;
	_[@ TGMX_T_TIME] = 0;
	_[@ TGMX_T_DURATION] = 1;
	_[@ TGMX_T_PROPERTY_DATA_RAW] = -1;
	_[@ TGMX_T_STATE] = TGMX_T_STATE_STOPPED;
	_[@ TGMX_T_SCALE] = 1;
	_[@ TGMX_T_DELTA] = false;
	_[@ TGMX_T_GROUP] = 0;
	_[@ TGMX_T_GROUP_SCALE] = global.TGMX.GroupScales[? 0];
	_[@ TGMX_T_EVENTS] = -1;
	_[@ TGMX_T_DESTROY] = 1;
	_[@ TGMX_T_DIRECTION] = 1;
	_[@ TGMX_T_MODE] = TWEEN_MODE_ONCE;
	_[@ TGMX_T_PROPERTY_DATA] = 0;
	_[@ TGMX_T_DELAY] = 0;
	_[@ TGMX_T_DELAY_START] = 0;
	_[@ TGMX_T_AMOUNT] = 0;
	_[@ TGMX_T_CALLER] = noone;
	_[@ TGMX_T_OTHER] = noone;
	_[@ TGMX_T_REST] = 0;
	_[@ TGMX_T_CONTINUE_COUNT] = -1;
	
	//-------------------------------------------------
	// ASSIGN DEFAULT TWEEN AS [1] IN INDEX MAP
	//-------------------------------------------------
	global.TGMX.TweenIndexMap[? 1] = global.TGMX.TweenDefault;
	//---------------------------------------------------
	// ASSIGN [all] AS SHORTCUT FOR AFFECTING ALL TWEENS
	//---------------------------------------------------
	global.TGMX.TweenIndexMap[? all] = {target: all}; 
	
	return 1;
} 


/// @ignore
/// @function TGMX_Cleanup()
/// @description TGMX ADMIN: Clean up system
function TGMX_Cleanup()
{
	if (global.TGMX.SharedTweener != noone)
	{		
		// REMOVE SELF AS SHARED TWEENER SINGLETON
	    global.TGMX.SharedTweener = noone;
	    // DESTROY TWEENS AND DELAYS FOR PERSISTENT ROOMS
	    TweenSystemClearRoom(all);

		// CLEAR EVENT MAPS
		var i = -1;
		repeat(TWEEN_EV_TOTAL_EVENTS)
		{
			ds_map_clear(global.TGMX.EventMaps[++i]);
		}

		//---------------------------------------------
		// DESTROY REMAINING TWEENS
		//---------------------------------------------
		var _tweens = global.TGMX.tweens;
		var _tIndex = -1;
		repeat(ds_list_size(_tweens))
		{   
		    var _t = _tweens[| ++_tIndex];             // GET TWEEN AND INCREMENT ITERATOR
		    _t[@ TGMX_T_STATE] = TGMX_T_STATE_DESTROYED; // SET STATE AS DESTROYED
		    _t[@ TGMX_T_ID] = undefined;                // NULLIFY SELF REFERENCE
    
		    // DESTROY TRWEEN EVENTS IF EVENTS MAP EXISTS
		    if (_t[TGMX_T_EVENTS] != -1)
		    {
				ds_map_destroy(_t[TGMX_T_EVENTS]);
		    }
		}

		//---------------------------------------
		// DESTROY DATA STRUCTURES
		//---------------------------------------
		ds_list_destroy(global.TGMX.tweens);
		ds_list_destroy(global.TGMX.delayedTweens);
		ds_map_destroy(global.TGMX.pRoomTweens);
		ds_map_destroy(global.TGMX.pRoomDelays);
		ds_priority_destroy(global.TGMX.eventCleaner);
		ds_queue_destroy(global.TGMX.stateChanger);
		
		//---------------------------------------
		// CLEAR DATA STRUCTURES
		//---------------------------------------
	    ds_map_clear(global.TGMX.TweenIndexMap);
		
		// PUT BACK DATA STRUCTURE DEFAULTS
		//-------------------------------------------------
		// ASSIGN DEFAULT TWEEN AS [1] IN INDEX MAP
		//-------------------------------------------------
		global.TGMX.TweenIndexMap[? 1] = global.TGMX.TweenDefault;
		//---------------------------------------------------
		// ASSIGN [all] AS SHORTCUT FOR AFFECTING ALL TWEENS
		//---------------------------------------------------
		global.TGMX.TweenIndexMap[? all] = {target: all};	 
	}
}


/// @ignore
/// @function SharedTweener()
/// @description Manages Shared Tweener creation/retrieval
function SharedTweener() 
{	
	// MAKE SURE GLOBAL SYSTEM IS INITIALIZED
	static _ = TGMX_Begin();
	
	// RETURN TWEENER IF IT ALREADY EXISTS
	if (instance_exists(global.TGMX.SharedTweener))
	{
		return global.TGMX.SharedTweener;
	}
	
	// ATTEMPT TO REACTIVATE DEACTIVATED TWEENER
	instance_activate_object(global.TGMX.SharedTweener);
	// RETURN SHARED TWEENER IF IT NOW EXISTS, ELSE CREATE AND RETURN A NEW SHARED TWEENER
	return instance_exists(global.TGMX.SharedTweener) ? global.TGMX.SharedTweener : instance_create_depth(0,0,0,o_SharedTweener);
}
	
	
/// @ignore
/// @function TGMX_FetchTween( tween_id )
/// @description TGMX ADMIN: Retrieves raw tween array from tween id
/// @param {Any} _tID
/// @return {Any}
function TGMX_FetchTween(_tID)
{
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = TGMX_Begin();
	
	if (is_array(_tID))
	{
		return _tID;
	}

	if (is_real(_tID))
	{
		// CHECK FOR TWEEN IN TWEEN INDEX MAP
		if (ds_map_exists(global.TGMX.TweenIndexMap, _tID))
		{
		    return global.TGMX.TweenIndexMap[? _tID];
		}
		
		// TWEEN OFFSET SELECT
		if (_tID != undefined && _tID <= 0)
		{
			return global.TGMX.TweenIndexMap[? global.TGMX.TweenIndex-_tID];
		}
		
		return undefined;
	}
	
	// ASSUME 'self' IS PASSED FOR A STRUCT
	if (is_struct(_tID)) 
	{
		return _tID == self ? {target: _tID} : _tID;
	}
	
	// ASSUME 'self' IS PASSED FOR AN INSTANCE
	if (_tID != undefined)
	{
		return { target: _tID.id };
	}
	
	return undefined;
}


/// @ignore
/// @function TGMX_TargetExists( target )
/// @description TGMX ADMIN: Checks to see if a tween's target is still valid
/// @param {Any} target Instance or struct id/reference
/// @return {Bool}
function TGMX_TargetExists(_target) 
{
	if (is_struct(_target)) // STRUCT TARGET
	{
		return weak_ref_alive(_target);	
	}
	
	if (_target != undefined) // ASSUME INSTANCE TARGET
	{
		if (global.TGMX.TweensIncludeDeactivated)
		{		
		    if (instance_exists(_target))
			{
		        return true;
		    }
    
			instance_activate_object(_target);
    
		    if (instance_exists(_target))
			{
		        instance_deactivate_object(_target);
		        return true;
		    }
	
		    return false;
		}
		
		return instance_exists(_target);
	}
	
	return false;
}


/// @ignore
/// @function TGMX_StringStrip( string, [offset] )
/// @description Lowers strings and removes underscores -- uses cache
/// @param {Any} string
/// @param {Any} [offset]
function TGMX_StringStrip(_string, _offset=0) 
{
	// REFERENCE GLOBAL STRING CACHE
	static __cache = global.TGMX.Cache;
	
	// CHECK CACHE FOR EXISTING LOWERED STRING
	if (ds_map_exists(__cache, _string))
	{
		return __cache[? _string];
	}
	
	// STORE ORIGINAL STRING
	var _string_og = _string;
	
	// REMOVE UNDERSCORES
	_string = string_replace_all(_string, "_", "");
	
	// CONVERT STRING TO LOWERCASE
	repeat(string_length(_string)-_offset)
	{
		var _byte = string_byte_at(_string, ++_offset);
		if (_byte <= 90 && _byte >= 65)
		{
			_string = string_set_byte_at(_string, _offset, _byte+32);
		}
	}

	// STORE NEW STRING INTO CACHE
	__cache[? _string_og] = _string;
	// RETURN NEW LOWER CASE STRING
	return _string;
}

/// @ignore
/// @function TGMX_Tween( script, args, [tween_id] )
/// @description TGMX ADMIN: Base function for creating and playing tweens
/// @param {Any} script
/// @param {Any} args
/// @param {Any} tID
function TGMX_Tween(_script, _args, _tID)
{	// Feather ignore all
	// MAKE SURE GLOBAL SYSTEM IS INITIALIZED
	static _ = TGMX_Begin();
	static STR_AT = "@"; // CACHE STRING POINTER TO IMPROVE PERFORMANCE
	static TGMX_Cache = global.TGMX.Cache;
	static TGMX_TweenDefault = global.TGMX.TweenDefault;
	static TGMX_ArgumentLabels = global.TGMX.ArgumentLabels;
	
	var TGMX = global.TGMX;
	var _doStart = true;
	var _qCallbacks = undefined;				// RESERVED FOR A QUEUE HOLDING CALLBACK DATA
	var _paramCount = array_length(_args)-1;	// NUMBER OF PARAMETERS SUPPLIED --- TODO: This could be replaced by passing parameter count from the parenting tween call
	var _t, _pData, _base_target;
	var i = -1;									// THE MAIN LOOP ITERATOR... WILL BE SET BELOW BASED UPON WHERE WE NEED TO START WITHIN PASSED ARGUMENTS
	
	//var _sharedTweener = SharedTweener(); // MAKE SURE WE HAVE A SHARED TWEENER SINGLETON
	// >> START OF INLINE CALL FOR SharedTweener()
		var _sharedTweener;
		// RETURN TWEENER IF IT ALREADY EXISTS
		if (instance_exists(TGMX.SharedTweener)) { 
			_sharedTweener = TGMX.SharedTweener; 
		}
		else 
		{
			instance_activate_object(TGMX.SharedTweener); // ATTEMPT TO REACTIVATE DEACTIVATED TWEENER
			_sharedTweener = instance_exists(TGMX.SharedTweener) ? TGMX.SharedTweener : instance_create_depth(0,0,0,o_SharedTweener);
		}
	// << FINISH OF INLINE CALL FOR SharedTweener()
	
	switch(_script)
	{
	case TweenFire:
		_tID = ++TGMX.TweenIndex;												 // GET NEW UNIQUE TWEEN ID
		_pData = [];															 // CREATE ARRAY TO HOLD PROPERTY DATA

		// CREATE NEW TWEEN ARRAY
		// COPY DEFAULT VALUES INTO TWEEN ARRAY
		if (TGMX_SUPPORT_LTS == true)
		{
			_t = array_create(TGMX_T_DATA_SIZE);									 
			array_copy(_t, 0, TGMX_TweenDefault, 0, TGMX_T_DATA_SIZE);				 
		}

		if (TGMX_SUPPORT_LTS == false) // FASTER ALTERNATIVE TO ABOVE
		{
			static __array_empty = [];
			_t = array_concat(__array_empty, TGMX_TweenDefault);
		}
		
		_t[TGMX_T_ID] = _tID;													 // NEW TWEEN CREATED WITH UNIQUE ID
		_t[TGMX_T_CALLER] = is_struct(self) ? weak_ref_create(self) : id;		 // STRUCT OR INSTANCE CALLING THE SCRIPT
		_t[TGMX_T_OTHER] = is_struct(other) ? weak_ref_create(other) : other.id; // SET 'other' CALLING ENVIRONMENT
		_t[TGMX_T_DESTROY] = true;												 // DESTROY WHEN FINISHED?
		
		// WE HAVE AN "ON-RAIL" TWEEN -- WE CAN APPLY THE VALUES WE KNOW WE HAVE
		if (_args[0] == undefined) 
		{	// SET OUR KNOWN VALUES
			_t[TGMX_T_TARGET] = _args[1]; _t[TGMX_T_EASE] = _args[2]; _t[TGMX_T_MODE] = _args[3]; _t[TGMX_T_DELTA] = _args[4]; _t[TGMX_T_DELAY] = _args[5]; _t[TGMX_T_DURATION] = _args[6];
			i = 6;
		}
		else // "OFF-RAIL" TWEEN
		{
			_t[TGMX_T_TARGET] = self; // SET DEFAULT TARGET TO CALLER ENVIRONMENT
		}
		
		TGMX.TweenIndexMap[? _tID] = _t;		// ASSOCIATE TWEEN WITH GLOBAL ID
		ds_list_add(_sharedTweener.tweens, _t);	// ADD TWEEN TO GLOBAL TWEENS LIST
		
		// FINALIZE USED TARGET -- CREATE WEAK REFERENCE IF STRUCT AND GET ID IF INSTANCE
		_base_target = is_struct(_t[TGMX_T_TARGET]) ? weak_ref_create(_t[TGMX_T_TARGET]) : _t[TGMX_T_TARGET].id;	
		_t[@ TGMX_T_TARGET] = _base_target;
	break;
	
	case TweenCreate:
		_tID = ++TGMX.TweenIndex;												 // GET NEW UNIQUE TWEEN ID
		_pData = [];
		_t = array_create(TGMX_T_DATA_SIZE);									 // CREATE NEW TWEEN ARRAY
		array_copy(_t, 0, TGMX_TweenDefault, 0, TGMX_T_DATA_SIZE);				 // COPY DEFAULT VALUES INTO TWEEN ARRAY
		_t[TGMX_T_ID] = _tID;													 // NEW TWEEN CREATED WITH UNIQUE ID
		_t[TGMX_T_CALLER] = is_struct(self) ? weak_ref_create(self) : id;		 // STRUCT OR INSTANCE CALLING THE SCRIPT
		_t[TGMX_T_OTHER] = is_struct(other) ? weak_ref_create(other) : other.id; // SET 'other' CALLING ENVIRONMENT
		_t[TGMX_T_DESTROY] = false;												 // DESTROY WHEN FINISHED?

		// WE HAVE AN "ON-RAIL" TWEEN -- WE CAN APPLY THE VALUES WE KNOW WE HAVE
		if (_args[0] == undefined) 
		{	// SET OUR KNOWN VALUES
			if (_paramCount == 1)
			{
				_t[TGMX_T_TARGET] = _args[1];	
				i = 1;
			}
			else
			{
				_t[TGMX_T_TARGET] = _args[1]; _t[TGMX_T_EASE] = _args[2]; _t[TGMX_T_MODE] = _args[3]; _t[TGMX_T_DELTA] = _args[4]; _t[TGMX_T_DELAY] = _args[5]; _t[TGMX_T_DURATION] = _args[6];
				i = 6;
			}
		}
		else // WE HAVE AN "OFF-RAIL" TWEEN
		{
			_t[TGMX_T_TARGET] = self; // SET DEFAULT TARGET TO CALLER ENVIRONMENT	
		}
		
		TGMX.TweenIndexMap[? _tID] = _t;		// ASSOCIATE TWEEN WITH GLOBAL ID
		ds_list_add(_sharedTweener.tweens, _t);	// ADD TWEEN TO GLOBAL TWEENS LIST
		
		// FINALIZE USED TARGET -- CREATE WEAK REFERENCE IF STRUCT AND GET ID IF INSTANCE
		_base_target = is_struct(_t[TGMX_T_TARGET]) ? weak_ref_create(_t[TGMX_T_TARGET]) : _t[TGMX_T_TARGET].id;	
		_t[@ TGMX_T_TARGET] = _base_target;
	break;
	
	case TweenPlay:
		if (is_real(_tID))
		{ 
			_tID = (_tID > 0) ? _tID : TGMX.TweenIndexMap[? TGMX.TweenIndex-_tID];
		}
		
		if (!TweenExists(_tID)) { return TWEEN_NULL; }
		
		_t = TGMX_FetchTween(_tID);  // FETCH RAW TWEEN DATA
		_pData = _t[TGMX_T_PROPERTY_DATA_RAW]; // CACHE EXISTING VARIABLE DATA LIST
		_t[@ TGMX_T_TIME] = 0;
		_t[@ TGMX_T_DIRECTION] = 1;
		_t[@ TGMX_T_SCALE] = abs(_t[TGMX_T_SCALE]);
		
		// TODO: NEED TO FIX THE DIFFERENCE IN PARAM COUNT WHEN USING ON-RAIL VS OFF-RAIL
		if (_paramCount > 0) 
		{	//^ IF NEW ARGUMENTS ARE SUPPLIED
			_pData = [];
			
			_t[@ TGMX_T_CALLER] = is_struct(self) ? weak_ref_create(self) : id; // STRUCT OR INSTANCE CALLING THE SCRIPT
			_t[@ TGMX_T_OTHER] = is_struct(other) ? weak_ref_create(other) : other.id; // SET 'other' CALLING ENVIRONMENT
			_t[@ TGMX_T_REST] = 0;
			_t[@ TGMX_T_AMOUNT] = 0;
			_t[@ TGMX_T_DURATION_RAW] = 0;
			_t[@ TGMX_T_CONTINUE_COUNT] = -1;
			
			// WE HAVE AN "ON-RAIL" TWEEN -- WE CAN APPLY THE VALUES WE KNOW WE HAVE
			if (_args[0] == undefined) 
			{	// SET OUR KNOWN VALUES
				_t[@ TGMX_T_EASE] = _args[1]; _t[@ TGMX_T_MODE] = _args[2]; _t[@ TGMX_T_DELTA] = _args[3]; _t[@ TGMX_T_DELAY] = _args[4]; _t[@ TGMX_T_DURATION] = _args[5];
				i = 5;
			}
			else
			{
				_t[@ TGMX_T_EASE] = EaseLinear; _t[@ TGMX_T_MODE] = 0; _t[@ TGMX_T_DELAY] = 0;
			}
		}
		
		_base_target = _t[TGMX_T_TARGET];
	break;
	}

	// LOOP THROUGH AND PROCESS SCRIPT PARAMETERS
	while(i < _paramCount)
	{		
		// GET NEXT TAG
		i += 1;
		var _tag = _args[i]; 
	
		//-------------------
		// ADVANCED PROPERTY
		if (is_array(_tag)) 
		{
			var _argCount = array_length(_tag);
			var _command = _tag[0];
			var _toFrom = 58; // ":" DEFAULT
			var _firstArg = _argCount > 1 ? _tag[1] : 0;

			// CHECK FOR TO/FROM STRINGS
			if (is_string(_firstArg))
			{
				_firstArg = _argCount >= 2 ? _tag[1] : undefined;
				
				var _lastByte = string_byte_at(_firstArg, string_length(_firstArg));
			
				//if (">" or "<" or ":")
				if (_lastByte <= 62 && _lastByte >= 58)
				{	
					_toFrom = _lastByte;
					_firstArg = string_delete(_firstArg, string_length(_firstArg), 1);
				}
			}
				
			switch(_argCount)
			{
			case 1: _tag = [_command, undefined]; break;
			case 2: _tag = ds_map_exists(TGMX.PropertyNormals, _command) ? [_command, [_firstArg, 0, 0]] : [_command, _firstArg]; break;
			default:
				var _xargs = array_create(_argCount-1);
				var _iArg = 0;
				_xargs[0] = _firstArg;
				
				repeat(_argCount-2)
				{
					_iArg += 1;
					_xargs[_iArg] = _tag[_iArg+1];
				}
				
				_tag = [_command, _xargs];
			}
			
			switch(_toFrom)
			{
			case 58: // : DEFAULT
				i += 2; 
				array_push(_pData, _tag, _args[i-1], _args[i]);
			break;
			case 62: // > TO
				i += 1;
				array_push(_pData, _tag, STR_AT, _args[i]);
			break; 
			case 60: // < FROM
				i += 1;
				array_push(_pData, _tag, _args[i], STR_AT);
			break;
			}
		}
		else //------------------
		{	 // REGULAR PROPERTY
			var _argLabel = ds_map_find_value(TGMX_ArgumentLabels, TGMX_Cache[? _tag] ?? TGMX_StringStrip(_tag));
			
			// TWEEN DATA, CALLBACK, OR CHAIN TYPE (e.g. "-ease" -> TGMX_T_EASE, "-mode" -> TGMX_T_MODE, "@finish" -> TWEEN_EV_FINISH)
			if (is_numeric(_argLabel)) 
			{
				switch(string_byte_at(_tag, 1))
				{			
				case 126: // "~" Ease
					i += 1;
					_t[@ TGMX_T_EASE] = _args[i];
				break;
					
				case 64: // "@" Event Callback -- This makes sure that we use the right assigned target before actually adding the callbacks later in this function
					i += 1;
					_qCallbacks ??= ds_queue_create();
					ds_queue_enqueue(_qCallbacks, _argLabel, _args[i]);
				break;
				
				case 62: // ">" Count OR ">>" Chain
					if (string_length(_tag) == 1) // Check for ">count" first
					{
						i += 1;
						_t[@ _argLabel] = _args[i];
						break;
					}
					
					// Else we have a chain
					_doStart = false; // Tell system not to play the tween right away
				
					if (i < _paramCount && is_real(_args[i+1])) // ADD PLAY CHAIN TO SELECTED TWEEN
					{	
						i += 1;
						TweenAddCallback(_args[i] ? _args[i] : _args[i]+TGMX.TweenIndex, TWEEN_EV_FINISH, _sharedTweener, TweenPlay, _tID); // Use index based on whether or not greater than 0 ... -1
					}
					else // < ADD PLAY CHAIN TO PREVIOUSLY CREATED TWEEN
					{	
						TweenAddCallback(TGMX.TweenIndex-1, TWEEN_EV_FINISH, _sharedTweener, TweenPlay, _tID);
					}
				break;
								
				default: // SET TWEEN DATA TYPE e.g. TweenFire(..., "-mode", "patrol", "$", 100...)
					i += 1;
					if (is_string(_args[i])) { _t[@ _argLabel] = TGMX_Cache[? _args[i]] ?? TGMX_StringStrip(_args[i]); } // e.g. "patrol"
					else					 { _t[@ _argLabel] = _args[i]; } // e.g. TWEEN_MODE_PATROL
				break;
				} 
			}
			else //-----------------------------------------
			{	 // SHORTHAND SETTER *OR* VARIABLE PROPERTY (undefined)
				var _shortIndex = TGMX.ShorthandTable[string_byte_at(_tag, 1)];
			
				switch(_shortIndex)
				{
				case 0: // DEAL WITH VARIABLE PROPERTY "x", "x>", "x<", "x:"
					switch(string_byte_at(_tag, string_length(_tag)))
					{	
					case 62: // // > TO
						i += 1;
						array_push(_pData, string_delete(_tag, string_length(_tag), 1), STR_AT, _args[i]); // TODO: ADD A STRING CACHE
					break;
					case 60: // < FROM
						i += 1;
						array_push(_pData, string_delete(_tag, string_length(_tag), 1), _args[i], STR_AT);
					break;
					case 58: // : TO FROM
						i += 2; 
						array_push(_pData, string_delete(_tag, string_length(_tag), 1), _args[i-1], _args[i]); 
					break;
					default: // TO FROM 
						i += 2;
						array_push(_pData, _tag, _args[i-1], _args[i]);
					}
				break;
				case TGMX_T_EASE: _t[@ TGMX_T_EASE] = string_delete(_tag, 1, 1); break; // SET EASE ~
				case TGMX_T_MODE: _t[@ TGMX_T_MODE] = string_delete(_tag, 1, 1); break; // SET MODE #
				default: _t[@ _shortIndex] = real(string_delete(_tag, 1, 1)); break;  // SET OTHER DATA TYPE !1, $60, %0.5, ^1, &5, *0.5, |30
				}
			}
		}
	}
	
	// FINALIZE USED TARGET -- CREATE WEAK REFERENCE IF STRUCT AND GET ID IF INSTANCE
	// THIS ONLY EXECUTES IF THE TARGET WAS CHANGED EXPLICITLY FROM ITS DEFAULT VALUE
	if (_base_target != _t[TGMX_T_TARGET])
	{
		_t[@ TGMX_T_TARGET] = is_struct(_t[TGMX_T_TARGET]) ? weak_ref_create(_t[TGMX_T_TARGET]) : _t[TGMX_T_TARGET].id;	
	}
	
	// ASSIGN NEWLY CREATED VARIABLE DATA LIST
	_t[@ TGMX_T_PROPERTY_DATA_RAW] = _pData;

	// ASSIGN GROUP SCALE
	_t[@ TGMX_T_GROUP_SCALE] = TGMX.GroupScales[? _t[TGMX_T_GROUP]];
	
	// CREATE NEW GROUP SCALE IF NOT SET
	if (_t[TGMX_T_GROUP_SCALE] == undefined)
	{
		_t[@ TGMX_T_GROUP_SCALE] = [1.0];
		TGMX.GroupScales[? _t[TGMX_T_GROUP]] = _t[TGMX_T_GROUP_SCALE];
	}

	// FINALIZE USED EASE TYPE
	// ASSIGN NEWLY CREATED VARIABLE DATA LIST
	_t[@ TGMX_T_PROPERTY_DATA_RAW] = _pData;

	// ASSIGN GROUP SCALE
	_t[@ TGMX_T_GROUP_SCALE] = TGMX.GroupScales[? _t[TGMX_T_GROUP]];
	
	// CREATE NEW GROUP SCALE IF NOT SET
	if (_t[TGMX_T_GROUP_SCALE] == undefined)
	{
		_t[@ TGMX_T_GROUP_SCALE] = [1.0];
		TGMX.GroupScales[? _t[TGMX_T_GROUP]] = _t[TGMX_T_GROUP_SCALE];
	}

	// FINALIZE USED EASE TYPE
	if (is_string(_t[TGMX_T_EASE]) && string_byte_at(_t[TGMX_T_EASE], 1) == 91) // "["
	{
		_t[@ TGMX_T_EASE] = json_parse(_t[TGMX_T_EASE]);
	}
	
	static __EaseTypes__ = {"string": 0, "number": 1, "struct": 2, "ref": 3, "array": 4, };
	switch( __EaseTypes__[$ typeof(_t[TGMX_T_EASE])] )
	{
		case 0: // STRING	
			var _easeHold = _t[TGMX_T_EASE];
			_t[@ TGMX_T_EASE] = TGMX.ShortCodesEase[? TGMX_Cache[? _t[TGMX_T_EASE]] ?? TGMX_StringStrip(_t[TGMX_T_EASE])];
			
			// NEW 107 CHECK AGAINST ASSET STRING NAME TO FIND FUNCTION ID
			if (_t[TGMX_T_EASE] == undefined)
			{
				var _assetID = asset_get_index(string_replace(_easeHold, "function gml_Script_", ""));
				
				if (_assetID < 100000) // CURVE ID
				{
					var _name = (animcurve_get(_assetID).name);
				
					if (ds_map_exists(global.TGMX.ShortCodesEase, _name) == false)
					{
						var _channel = animcurve_get_channel(_assetID, 0);
						_channel.name = _name;
						global.TGMX.ShortCodesEase[? _name] = _channel;
					}
				
					_t[@ TGMX_T_EASE] = global.TGMX.ShortCodesEase[? _name];
				}
				else // FUNCTION ID
				{
					_t[@ TGMX_T_EASE] = method(undefined, _assetID);
				}
				
				var _stripped = TGMX_StringStrip(_easeHold);
				TGMX_Cache[? _easeHold] = _stripped;
				global.TGMX.ShortCodesEase[? _stripped] = _t[TGMX_T_EASE];
			}
			
			_t[@ TGMX_T_EASE_RAW] = _t[TGMX_T_EASE];
		break;
		
		case 1: // NUMBER
			if (_t[TGMX_T_EASE] < 100000) // CURVE ID
			{
				// TODO: Clean this up a bit
				var _name = (animcurve_get(_t[TGMX_T_EASE]).name);
				
				if (ds_map_exists(global.TGMX.ShortCodesEase, _name) == false)
				{
					var _channel = animcurve_get_channel(_t[TGMX_T_EASE], 0);
					_channel.name = _name;
					global.TGMX.ShortCodesEase[? _name] = _channel;
				}
				
				_t[@ TGMX_T_EASE] = global.TGMX.ShortCodesEase[? _name];
			}
			else // FUNCTION ID
			{
				_t[@ TGMX_T_EASE] = method(undefined, _t[TGMX_T_EASE]);
			}
			
			_t[@ TGMX_T_EASE_RAW] = _t[TGMX_T_EASE];
		break;
		
		case 2: // STRUCT
			// NEW 107
			if (variable_struct_exists(_t[TGMX_T_EASE], "channel"))
			{
				_t[@ TGMX_T_EASE] = animcurve_get_channel(_t[TGMX_T_EASE], 0);
				_t[@ TGMX_T_EASE_RAW] = _t[TGMX_T_EASE];
			}

			var _name = TGMX_StringStrip(_t[TGMX_T_EASE].name);
				
			if (ds_map_exists(global.TGMX.ShortCodesEase, _name) == false)
			{
				global.TGMX.ShortCodesEase[? _name] = _t[TGMX_T_EASE];
			}
		break;
		
		case 3: // REF -- TODO: CHECK IF THIS IS DIFFERENT FOR NON-LTS
			var _assetID = real(_t[TGMX_T_EASE]);
			
			if (_assetID < 100000) // CURVE ID
			{
				// TODO: Clean this up a bit
				var _name = (animcurve_get(_assetID).name);
				
				if (ds_map_exists(global.TGMX.ShortCodesEase, _name) == false)
				{
					var _channel = animcurve_get_channel(_assetID, 0);
					_channel.name = _name;
					global.TGMX.ShortCodesEase[? _name] = _channel;
				}
				
				_t[@ TGMX_T_EASE] = global.TGMX.ShortCodesEase[? _name];
			}
			else // FUNCTION ID
			{
				_t[@ TGMX_T_EASE] = method(undefined, _assetID);
			}
			
			_t[@ TGMX_T_EASE_RAW] = _t[TGMX_T_EASE];
		break;
		
		case 4: // ARRAY -- TODO: Update for other 107 changes [Is this supported by TweenSet(t, "ease", ...) ??]
			switch( __EaseTypes__[$ typeof(_t[TGMX_T_EASE][0]) ])
			{
				case 0: // STRING
					_t[TGMX_T_EASE][@ 0] = TGMX.ShortCodesEase[? TGMX_Cache[? _t[TGMX_T_EASE][0]] ?? TGMX_StringStrip(_t[TGMX_T_EASE][0])];
				break;
		
				case 1: // NUMBER
						_t[TGMX_T_EASE][@ 0] = _t[TGMX_T_EASE][0] < 100000 ? animcurve_get_channel(_t[TGMX_T_EASE][0], 0) : method(undefined, _t[TGMX_T_EASE][0]);
				break;
			
				case 2: // STRUCT
					if (variable_struct_exists(_t[TGMX_T_EASE][0], "channel"))
					{
						_t[TGMX_T_EASE][@ 0] = animcurve_get_channel(_t[TGMX_T_EASE][0], 0);
					}
				break;
				
				case 3: // REF
					_t[TGMX_T_EASE][@ 0] = (real(_t[TGMX_T_EASE][0]) < 100000) ? animcurve_get_channel(_t[TGMX_T_EASE][0], 0) : method(undefined, _t[TGMX_T_EASE][0]); 
				break;
			}
			
			switch( __EaseTypes__[$ typeof(_t[TGMX_T_EASE][1]) ])
			{
				case 0: // STRING
					_t[TGMX_T_EASE][@ 1] = TGMX.ShortCodesEase[? TGMX_Cache[? _t[TGMX_T_EASE][1]] ?? TGMX_StringStrip(_t[TGMX_T_EASE][1])];
				break;
		
				case 1: // NUMBER
						_t[TGMX_T_EASE][@ 1] = _t[TGMX_T_EASE][1] < 100000 ? animcurve_get_channel(_t[TGMX_T_EASE][1], 0) : method(undefined, _t[TGMX_T_EASE][1]);
				break;
			
				case 2: // STRUCT
					if (variable_struct_exists(_t[TGMX_T_EASE][1], "channel"))
					{
						_t[TGMX_T_EASE][@ 1] = animcurve_get_channel(_t[TGMX_T_EASE][1], 0);
					}
				break;	
				
				case 3: // REF
					_t[TGMX_T_EASE][@ 1] = (real(_t[TGMX_T_EASE][1]) < 100000) ? animcurve_get_channel(_t[TGMX_T_EASE][1], 0) : method(undefined, _t[TGMX_T_EASE][1]); 
				break;
			}
		
		// STORE RAW TWEENS FOR SWAPPING
		_t[@ TGMX_T_EASE_RAW] = _t[TGMX_T_EASE];
		// SET ACTIVE EASE FUNCTION
		_t[@ TGMX_T_EASE] = _t[TGMX_T_EASE][0];
		break;
	}
	
	// CONVERT MODE TYPE IF A STRING
	if (is_string(_t[TGMX_T_MODE]))
	{
		_t[@ TGMX_T_MODE] = TGMX.ShortCodesMode[? TGMX_Cache[? _t[TGMX_T_MODE]] ?? TGMX_StringStrip(_t[TGMX_T_MODE])];
	}
	else // TWEEN MODE WITH CONTINUE COUNT
	if (is_array(_t[TGMX_T_MODE]))
	{
		_t[@ TGMX_T_CONTINUE_COUNT] = _t[TGMX_T_MODE][1];
		_t[@ TGMX_T_MODE] = is_real(_t[TGMX_T_MODE][0]) ? _t[TGMX_T_MODE][0] : TGMX.ShortCodesMode[? TGMX_StringStrip(_t[TGMX_T_MODE][0])];
	}

	// DURATION SWAPPING
	if (is_string(_t[TGMX_T_DURATION]) && string_byte_at(_t[TGMX_T_DURATION], 1) == 91)
	{
		_t[@ TGMX_T_DURATION] = json_parse(_t[TGMX_T_DURATION]);	
	}
	
	if (is_array(_t[TGMX_T_DURATION]) && array_length(_t[TGMX_T_DURATION]) == 2)
	{
		if (_t[TGMX_T_DURATION][0] <= 0) { _t[TGMX_T_DURATION][@ 0] = 0.0000001; }
		if (_t[TGMX_T_DURATION][1] <= 0) { _t[TGMX_T_DURATION][@ 1] = 0.0000001; }
		_t[@ TGMX_T_DURATION_RAW] = _t[TGMX_T_DURATION];
		_t[@ TGMX_T_DURATION] = _t[TGMX_T_DURATION][0];
	}
	
	// DELAY AND RESTS -- TODO: UPDATE THIS FOR TWEEN SET
	if (is_array(_t[TGMX_T_DELAY]))
	{
		_t[@ TGMX_T_REST] = (array_length(_t[TGMX_T_DELAY]) == 2) ? _t[TGMX_T_DELAY][1] : [_t[TGMX_T_DELAY][1], _t[TGMX_T_DELAY][2]];
		_t[@ TGMX_T_DELAY] = _t[TGMX_T_DELAY][0];
	}
	
	// TRACK DELAY START
	_t[@ TGMX_T_DELAY_START] = _t[TGMX_T_DELAY];

		// HANDLE QUEUED CALLBACK EVENTS
	if (_qCallbacks != undefined)
	{
		// WE NEED TO USE THIS FOR ASSUMED CALLBACK TARGETS -- WE DONT WANT TO CREATE A DOUBLE WEAK REFERENCES FOR STRUCT TARGETS
		var _raw_tween_target = is_struct(_t[TGMX_T_TARGET]) ? _t[TGMX_T_TARGET].ref : _t[TGMX_T_TARGET];
		
		repeat(ds_queue_size(_qCallbacks) div 2)
		{
			var _event = ds_queue_dequeue(_qCallbacks);
			var _cbData = ds_queue_dequeue(_qCallbacks);
			
			if (!is_array(_cbData)) // REGULAR CALLBACK WITH ASSUMED TARGET BELONGING TO TWEEN
			{
				TweenAddCallback(_tID, _event, _raw_tween_target, _cbData);
			}
			else // HANDLE ADVANCED CALLBACK
			{
				var _cArgs; // Arguments to be passed to TweenAddCallback() later on
				var _cbDataTarget = _cbData[0];
				static TGMX_STR_method = "method"; // Cache string for optimization
				
				// Undefined -- use original method environment
				if (_cbDataTarget == undefined) 
				{
					_cArgs = [_tID, _event, method_get_self(_cbData[1])];
					array_copy(_cArgs, 3, _cbData, 1, array_length(_cbData)-1);
				}
				else // First argument is a method or function id -- _cbData[0] is first argument in array
				if (is_method(_cbDataTarget) || real(_cbDataTarget) >= 100000 || typeof(_cbDataTarget) == TGMX_STR_method) // typeof() is used for HTML5 bug where built-in functions can change type
				{
					_cArgs = [_tID, _event, _raw_tween_target];
					array_copy(_cArgs, 3, _cbData, 0, array_length(_cbData));
				}
				else // Explicit target using {target: some_target} -- DON'T WORRY ABOUT WEAK REFERENCES HERE, AS _cArgs IS TEMPORARY
				if (is_struct(_cbDataTarget))
				{	
					_cArgs = array_create(array_length(_cbData) + 2);
					_cArgs[0] = _tID;
					_cArgs[1] = _event;
					
					if (_cbDataTarget == self) {
						_cArgs[2] = self;
					}
					else
					if (_cbDataTarget == other) {
						_cArgs[2] = other;
					}
					else {
						_cArgs[2] = _cbData[0].target;
					}
					
					array_copy(_cArgs, 3, _cbData, 1, array_length(_cbData)-1);
				}
				else // INSTANCE self | other TARGET -- NOTE -- THE FOLLOWING IS ONLY FOR INSTANCES AND NOT STRUCTS, WHICH ARE HANDLED ABOVE
				{
					_cArgs = [_tID, _event, _raw_tween_target];
					array_copy(_cArgs, 3, _cbData, 0, array_length(_cbData));
				}
				
				
				// Execute TweenAddCallback() with defined arguments above
				script_execute_ext(TweenAddCallback, _cArgs);
			}
		}

		// Destroy temp callback queue
		ds_queue_destroy(_qCallbacks);	
	}

	// Return early for specific calls
	switch(_script)
	{
		case TweenCreate: return _tID;
	}

	// CHECK FOR DELAYED TWEEN
	if (_t[TGMX_T_DELAY] != 0)
	{   
		if (_doStart) { _t[@ TGMX_T_STATE] = TGMX_T_STATE_DELAYED; } // Set tween as waiting 
	
		// Put to starting tween position right away if a negative delay is given ( NOTE: This is a hidden feature! )
		if (_t[TGMX_T_DELAY] < 0)
		{
			_t[@ TGMX_T_DELAY] = abs(_t[TGMX_T_DELAY]);
			TGMX_TweenPreprocess(_t);
			TGMX_TweenProcess(_t, _t[TGMX_T_TIME], _t[TGMX_T_PROPERTY_DATA], is_struct(_t[TGMX_T_TARGET]) ? _t[TGMX_T_TARGET].ref : _t[TGMX_T_TARGET]);
		}
	
		ds_list_add(_sharedTweener.delayedTweens, _t); // ADD TWEEN TO DELAY LIST
		
		// RETURN WITH TWEEN ID
		return _tID;
	}
	
	// CHECK IF WE ARE TO START THE TWEEN RIGHT AWAY
	if (_doStart)
	{		
		// 1) MARK FOR CHANGING STATE LATER IF CURRENTLY IN UPDATE LOOP
		// 2) ELSE SET TWEEN AS ACTIVE -- INDICATED BY ASSIGNING TARGET AS THE STATE
		if (_sharedTweener.inUpdateLoop) { ds_queue_enqueue(_sharedTweener.stateChanger, _t, _t[TGMX_T_TARGET]); }
		else							 { _t[@ TGMX_T_STATE] = _t[TGMX_T_TARGET]; } 
		
		// SET TWEEN STATE AS TARGET
		_t[@ TGMX_T_STATE] = _t[TGMX_T_TARGET];
		
		// Pre-process tween data
		TGMX_TweenPreprocess(_t);
		// Process tween
		TGMX_TweenProcess(_t, _t[TGMX_T_TIME], _t[TGMX_T_PROPERTY_DATA],  is_struct(_t[TGMX_T_TARGET]) ? _t[TGMX_T_TARGET].ref : _t[TGMX_T_TARGET]); // TODO: Allow this to be skipped ??
		// Execute "On Play" event
		TGMX_ExecuteEvent(_t, TWEEN_EV_PLAY);
	}

	// RETURN WITH TWEEN ID
	return _tID;
}


/// @ignore
/// @function TGMX_TweenPreprocess( tween_array )
/// @description TGMX ADMIN: Prepares a tween's data to be useable
/// @param {Array} tween_array
function TGMX_TweenPreprocess(_t) 
{
	// Feather ignore all
	
	// CACHE STRING POINTERS -- IMPROVES PERFORMANCE
	static STR_AT = "@";		static STR_AT_PLUS = "@+";		static STR_DOLLAR = "$";
	static STR_EMPTY = "";		static STR_SPACE = " ";			static STR_DOT = "."; 
	static STR_self = "self";	static STR_other = "other";		static STR_global = "global";
	
	// CACHE SOME OTHER THINGS!
	static TGMX_PropertySetters = global.TGMX.PropertySetters;
	static TGMX_PropertyNormals = global.TGMX.PropertyNormals;
	static TGMX_Variable_Dot_Notation_Set = global.TGMX.Variable_Dot_Notation_Set;
	static TGMX_Variable_Global_Set  = global.TGMX.Variable_Global_Set;
	static TGMX_Variable_Instance_Set = global.TGMX.Variable_Instance_Set;
	
	var _target = _t[TGMX_T_TARGET];
	if (is_struct(_target)) { _target = _target.ref; }

	var _data_length = array_length(_t[TGMX_T_PROPERTY_DATA_RAW]);
	var _pData = array_create(_data_length);
	array_copy(_pData, 0, _t[TGMX_T_PROPERTY_DATA_RAW], 0, _data_length);

	var _propCount = _data_length  div 3;
	var _extIndex = -3; // Careful with this!
	var _extData = array_create(1+_propCount*4, undefined); // Create array holding properties data
	_extData[0] = _propCount; // Cache property count in first index (Used later when processing)
	
	var _caller = _t[TGMX_T_CALLER];
	if (is_struct(_caller)) { _caller = _caller.ref; }
					
	var _other = _t[TGMX_T_OTHER];
	if (is_struct(_other)) { _other = _other.ref; }
	
	// ** PARSE PROPERTY STRINGS **
	var i = -1;
	
	repeat(_propCount)
	{
		i += 1;
		var _variable = _pData[i];
	
		// PROCESS NEXT ARGUMENTS PASSED TO SETTER TYPE
		repeat(2)
		{
			i += 1;
			
			// CONTINUE IF WE HAVE A REAL NUMBER
			if (is_real(_pData[i])) { continue; }
			
			var _pValue = _pData[i];
		
			// RELATIVE ARRAY VALUES [100]
			if (is_array(_pValue))
			{	// ADD "+" FOR POSITIVE NUMBERS ... NO "-" NEEDED FOR NEGATIVE NUMBERS
				_pValue = _pValue[0] >= 0 ? STR_AT_PLUS+string(_pValue[0]) : STR_AT+string(_pValue[0]);
			}
	
			// STRING VALUES (START DEST)
			if (is_string(_pValue))
			{	// REMOVE ANY SPACES IN STRING
				_pValue = string_replace_all(_pValue, STR_SPACE, STR_EMPTY); 

				// CHECK FOR INITIAL MINUS SIGN
				var _preOp = 1;
				if (string_byte_at(_pValue, 1) == 45) // "-" MINUS
				{
					_preOp = -1;
					_pValue = string_delete(_pValue, 1, 1);
				}

				// TODO: THIS IS CAUSING AN ISSUE... POST-OP CAUSES PROBLEMS...
				var _op = 0;
				var _iOp = 1;
				repeat(string_length(_pValue)-2)
				{
					// TODO: add operator map check
					_iOp += 1;
					if (string_byte_at(_pValue, _iOp) != 46 && string_byte_at(_pValue, _iOp) <= 47 && string_byte_at(_pValue, _iOp) >= 42)
					{
						_op = _iOp;
						break;
					}
				}
			
				// UPDATE THE ACTIVE TWEEN SELF -- MACRO --> [TWEEN_SELF]
				global.TGMX.tween_self = _t[TGMX_T_ID];
			
				if (_op) // HANDLE MATH OPERATION
				{		
					var _pre = string_copy(_pValue, 1, _op-1);
					var _post = string_copy(_pValue, _op+1, string_length(_pValue)-_op);
	
					_pre = _pre == STR_AT ? TGMX_Variable_Get(_target, _variable, _caller, _other) : TGMX_Variable_Get(_target, _pre, _caller, _other);
					_post = _post == STR_AT ? TGMX_Variable_Get(_target, _variable, _caller, _other) : TGMX_Variable_Get(_target, _post, _caller, _other);

					// PERFORM OPERATION
					switch(string_byte_at(_pValue, _op)) // TODO: Add _postOp??
					{
						case 43: _pData[i] = _preOp * _pre + _post; break; // + ADD
						case 45: _pData[i] = _preOp * _pre - _post; break; // - SUB
						case 42: _pData[i] = _preOp * _pre * _post; break; // * MULTIPLY
						case 47: _pData[i] = _preOp * _pre / _post; break; // / DIVIDE
					}
				}
				else // NO MATH OPERATION
				{	
					_pData[i] = _pValue == STR_AT ? _preOp*TGMX_Variable_Get(_target, _variable, _caller, _other) : _preOp*TGMX_Variable_Get(_target, _pValue, _caller, _other);
				}
				
				// CLEAR [TWEEN_SELF] MACRO
				global.TGMX.tween_self = undefined;
			}
		}
	
		// ** PROCESS PROPERTY DATA VALUES **
		_extIndex += 4;

		if (is_array(_variable)) // ADVANCED PROPERTY
		{
			// Track raw property setter method
			_extData[_extIndex] = TGMX_PropertySetters[? _variable[0]];
			
			if (ds_map_exists(TGMX_PropertyNormals, _variable[0]))// NORMALIZED
			{	
				_extData[1+_extIndex] = 0; // normalized start
				_extData[2+_extIndex] = 1; // normalized change
				var _data = _variable[1];
				_data[@ 1] = _pData[i-1]; // start
				_data[@ 2] = _pData[i]; // change
			}
			else // NOT NORMALIZED
			{	
				_extData[1+_extIndex] = _pData[i-1]; // start
				_extData[2+_extIndex] = _pData[i] - _pData[i-1]; // change
			}
		
			_extData[3+_extIndex] = _variable[1]; // data
		}
		else // METHOD PROPERTY (TPFunc)
		if (_target[$ STR_DOLLAR+_variable] != undefined)
		{
			_extData[  _extIndex] = _target[$ STR_DOLLAR+_variable];
			_extData[1+_extIndex] = _pData[i-1]; // start
			_extData[2+_extIndex] = _pData[i] - _pData[i-1]; // change
			_extData[3+_extIndex] = _variable; // data
		}
		else // FUNCTION PROPERTY
		if (ds_map_exists(TGMX_PropertySetters, _variable))
		{
			_extData[_extIndex] = TGMX_PropertySetters[? _variable]; // Track raw property
			
			//if (!is_method(_variable) && ds_map_exists(global.TGMX.PropertyNormals, _variable))
			if (ds_map_exists(TGMX_PropertyNormals, _variable)) // NORMALIZED -- BUG IN HTML5 when checking method against a map?
			{
				_extData[_extIndex+1] = 0; // normalized start
				_extData[_extIndex+2] = 1; // normalized change
				_extData[_extIndex+3] = [_pData[i-1], _pData[i]];
			}
			else // NOT NORMALIZED
			{	
				_extData[_extIndex+1] = _pData[i-1]; // start
				_extData[_extIndex+2] = _pData[i] - _pData[i-1]; // change
				//_extData[3+_extIndex] = undefined; // data -- already set as default value for data array
			}
		}
		else // DYNAMIC PROPERTY
		{
			// NEW -- CHECK FOR STRUCTURE -- May need to extend this to support indexing object data
			var _dotPos = string_pos(STR_DOT, _variable);
			
			if (!_dotPos) // Default Dynamic Property
			{
				// ---- FOR FUTURE OPTIMISATION ----
				//if (_target[$ _variable] == undefined)
				//{
				//	_extData[_extIndex] = TGMX_Variable_Global_Set;
				//	_extData[_extIndex+3] = _variable;
				//}
				//else
				//{
				//	_extData[_extIndex] = TGMX_Variable_Instance_Set;
				//	if (TGMX_SUPPORT_LTS) { _extData[_extIndex+3] = _variable; }
				//	else				  { _extData[_extIndex+3] = variable_get_hash(_variable); }
				//}
				
				_extData[_extIndex] = _target[$ _variable] == undefined ? TGMX_Variable_Global_Set : TGMX_Variable_Instance_Set;
				_extData[_extIndex+1] = _pData[i-1]; // start
				_extData[_extIndex+2] = _pData[i] - _pData[i-1]; // change
				_extData[_extIndex+3] = _variable;
			}
			else // HANDLE DOT NOTATION
			{
				_extData[  _extIndex] = TGMX_Variable_Dot_Notation_Set; // Should rename this function for better clarity
				// These next 2 lines are potentionally redudant
				_extData[_extIndex+1] = _pData[i-1]; // start
				_extData[_extIndex+2] = _pData[i] - _pData[i-1]; // change
				
				// Handle difference between 1 or 2 dots used
				if (string_count(STR_DOT, _variable) == 1)
				{
					var _structName = string_copy(_variable, 1, _dotPos-1);
					// _extData[3+_extIndex] = undefined; // We will leave this undefined
				}
				else
				{
					var _sub_target = string_copy(_variable, 1, _dotPos-1);
					
					if (_target[$ _sub_target] != undefined)
					{
						_target = _target[$ _sub_target];
					}
					else
					if (_caller[$ _sub_target] != undefined)
					{
						_target = _caller[$ _sub_target];	
					}
					
					_variable = string_delete(_variable, 1, _dotPos);
					_dotPos = string_pos(STR_DOT, _variable);
					_structName = string_copy(_variable, 1, string_pos(STR_DOT, _variable)-1);
				}
				
				 // Lookup prefix inside target first
				if (_target[$ _structName] != undefined)
				{
					var _passTarget = _target[$ _structName];
						
					// Create weak reference if passed target is a struct
					if (is_struct(_passTarget)) 
					{
						_passTarget = weak_ref_create(_passTarget);	
					}
					
					// NEW =====================
					_variable = string_copy(_variable, _dotPos+1, 100);
					
					if (ds_map_exists(TGMX_PropertyNormals, _variable))
					{
						_extData[_extIndex+1] = 0; // start
						_extData[_extIndex+2] = 1; // change
						_extData[_extIndex+3] = [_passTarget, _variable, [_pData[i-1], _pData[i]], undefined]; // This gets sorted later for optimised properties in the slower generic setter
					}
					else
					{
						_extData[_extIndex+3] = [_passTarget, _variable, undefined, undefined]; // This gets sorted later for optimised properties in the slower generic setter
					}
				}
				else // Look for prefix inside caller
				if (_caller[$ _structName] != undefined) 
				{
					var _passTarget = _caller[$ _structName];
						
					if (is_struct(_passTarget))
					{
						_passTarget = weak_ref_create(_passTarget);	
					}
						
					// NEW =====================
					_variable = string_copy(_variable, _dotPos+1, 100);
					
					if (ds_map_exists(TGMX_PropertyNormals, _variable))
					{				
						_extData[_extIndex+1] = 0; // start
						_extData[_extIndex+2] = 1; // change
						_extData[_extIndex+3] = [_passTarget, _variable, [_pData[i-1], _pData[i]], undefined]; // This gets sorted later for optimised properties in the slower generic setter
					}
					else
					{
						_extData[_extIndex+3] = [_passTarget, _variable, undefined, undefined]; // This gets sorted later for optimised properties in the slower generic setter
					}
				}
				else
				if (variable_global_exists(_structName)) // Look for prefix in global scope
				{
					var _passTarget = variable_global_get(_structName);
						
					if (is_struct(_passTarget))
					{
						_passTarget = weak_ref_create(_passTarget);	
					}
						
					// NEW =====================
					_variable = string_copy(_variable, _dotPos+1, 100);
					
					if (ds_map_exists(TGMX_PropertyNormals, _variable))
					{
						_extData[_extIndex+1] = 0; // start
						_extData[_extIndex+2] = 1; // change
						_extData[_extIndex+3] = [_passTarget, _variable, [_pData[i-1], _pData[i]], undefined]; // This gets sorted later for optimised properties in the slower generic setter
					}
					else
					{
						_extData[_extIndex+3] = [_passTarget, _variable, undefined, undefined]; // This gets sorted later for optimised properties in the slower generic setter
					}
				}
				else
				{		
					var _objectID = asset_get_index(_structName);	
			
					if (_objectID >= 0 && object_exists(_objectID))
					{
						// NEW =====================
						_variable = string_copy(_variable, _dotPos+1, 100);
					
						if (ds_map_exists(TGMX_PropertyNormals, _variable))
						{
							_extData[_extIndex+1] = 0; // start
							_extData[_extIndex+2] = 1; // change
							_extData[_extIndex+3] = [_objectID.id, _variable, [_pData[i-1], _pData[i]], undefined]; // This gets sorted later for optimised properties in the slower generic setter
						}
						else
						{
							_extData[_extIndex+3] = [_objectID.id, _variable, undefined, undefined]; // This gets sorted later for optimised properties in the slower generic setter
						}	
					}
					else
					{
						// This is where we need to handle self and other
						if (string_count(STR_DOT, _variable) >= 2)
						{
							var _structName = string_copy(_variable, 1, _dotPos-1);
							var _passTarget;
							switch(_structName)
							{
								case STR_global: // GLOBAL
									_variable = string_delete(_variable, 1, 7);
									_dotPos = string_pos(STR_DOT, _variable);
									_passTarget = variable_global_get(string_copy(_variable, 1, _dotPos-1));
								break;
								case STR_self: // SELF
									_variable = string_delete(_variable, 1, 5);
									_dotPos = string_pos(STR_DOT, _variable);
									_passTarget = _caller[$ string_copy(_variable, 1, _dotPos-1)];
								break;
								case STR_other: // OTHER
									_variable = string_delete(_variable, 1, 6);
									_dotPos = string_pos(STR_DOT, _variable);
									_passTarget = _other[$ string_copy(_variable, 1, _dotPos-1)];
								break;
							}
							
							// Finalize used target -- create weak reference if struct or get id if instance
							_passTarget = is_struct(_passTarget) ? weak_ref_create(_passTarget) : _passTarget.id;
							
							_variable = string_copy(_variable, _dotPos+1, 100);
							
							// Normalized
							if (ds_map_exists(TGMX_PropertyNormals, _variable))
							{
								_extData[_extIndex+1] = 0; // start
								_extData[_extIndex+2] = 1; // change
								_extData[_extIndex+3] = [_passTarget, _variable, [_pData[i-1], _pData[i]], undefined];
							}
							else
							{
								_extData[3+_extIndex] = [_passTarget, _variable, undefined, undefined];
							}
						}
						else
						{	
							_variable = string_copy(_variable, _dotPos+1, 100);
							
							switch(_structName)
							{
							case STR_global: // GLOBAL
								_extData[_extIndex] = global.TGMX.Variable_Global_Set;
								_extData[_extIndex+3] = _variable;
							break;
							case STR_self: // SELF
								// NORMALIZED PROPERTY
								if (ds_map_exists(TGMX_PropertyNormals, _variable))
								{
									_extData[_extIndex+1] = 0; // start
									_extData[_extIndex+2] = 1; // change
									_extData[_extIndex+3] = [(is_struct(_caller) ? weak_ref_create(_caller) : _caller), _variable, [_pData[i-1], _pData[i]], undefined];
								}
								else // NOT NORMALIZED PROPERTY
								{
									_extData[_extIndex+3] = [(is_struct(_caller) ? weak_ref_create(_caller) : _caller), _variable, undefined, undefined];
								}
							break; // OTHER
							case STR_other:
								// NORMALIZED PROPERTY
								if (ds_map_exists(TGMX_PropertyNormals, _variable))
								{
									_extData[_extIndex+1] = 0; // start
									_extData[_extIndex+2] = 1; // change
									_extData[_extIndex+3] = [(is_struct(_other) ? weak_ref_create(_other) : _other), _variable, [_pData[i-1], _pData[i]], undefined];
								} 
								else // NOT NORMALIZED PROPERTY
								{
									// NEW SINGLE
									_extData[_extIndex+3] = [(is_struct(_other) ? weak_ref_create(_other) : _other), _variable, undefined, undefined];
								}
							break;
							
							default:
								show_error("Invalid tween property prefix! Check preceding struct or object name.", false);
							}
						}
					}
				}
			}
		}		
	}
	
	// Assign property data values
	_t[@ TGMX_T_PROPERTY_DATA] = _extData;
	
	// Handle per-step/second [durations]
	if (!is_real(_t[TGMX_T_DURATION]))
	{
		// HIDE SYNTAX WARNINGS FOR NON-FEATHER SETTING
		if (false) { use = 1; weight = 1; sum = 1; avg = 1;}
		
		var _duration = _t[TGMX_T_DURATION];
		
		// Backwards array support for normalized [duration]
		if (is_array(_duration) && array_length(_duration) == 1)
		{
			_duration = {dist: _duration[0]}
		} 
		// DON'T PUT AN else BELOW HERE... IT NEEDS TO CARRY INTO THE STRUCT CHECK BELOW ON PURPOSE!
		
		if (is_struct(_duration))
		{	
			var _count, _data = _t[TGMX_T_PROPERTY_DATA];
			static TGMX_STR_use = "use";
			static _str_map = function()
			{
				var _map = ds_map_create();
				_map[? "dist"] = 1;
				_map[? "avg"] = 2;
				_map[? "weight"] = 3;
				_map[? "sum"] = 4;
				_map[? "max"] = 5;
				_map[? "min"] = 6;
				return _map;
			}();
			
			if (variable_struct_exists(_duration, TGMX_STR_use))
			{
				_count = _duration.use;
				variable_struct_remove(_duration, TGMX_STR_use);
			}
			else
			{
				_count = array_length(_data) div 4
			}
		
			switch(_str_map[? variable_struct_get_names(_duration)[0]])
			{
			case 1: // "dist"
				switch(_count)
				{
				case 1: _t[@ TGMX_T_DURATION] = abs(_data[3] / _duration.dist); break;
				case 2: _t[@ TGMX_T_DURATION] = point_distance(0,0,_data[3],_data[7]) / _duration.dist; break;
				case 3: _t[@ TGMX_T_DURATION] = point_distance_3d(0,0,0,_data[3],_data[7],_data[11]) / _duration.dist; break;
				default:
					var _sumPwrChange = 0;
					i = 3;
					repeat(_count)
					{
						_sumPwrChange += _data[i] * _data[i];
						i += 4;
					}
	
					_t[@ TGMX_T_DURATION] = sqrt(_sumPwrChange) / _duration.dist;
				}
			break;
			
			case 2: // "avg"
				// Sum the absolute change values from each property
				var _sumAbsChange = 0;
				i = 3;	
				repeat(_count)
				{
					_sumAbsChange += abs(_data[i]);
					i += 4;
				}
				
				_t[@ TGMX_T_DURATION] = _sumAbsChange/_count/_duration.avg;
			break;
			
			case 3: // "weight"
				var _final_duration = 0;
				var _sumAbsChange = 0;
				
				i = 3;	
				repeat(_count)
				{
					_sumAbsChange += abs(_data[i]);
					i += 4;
				}
				
				i = 3;
				repeat(_count)
				{
					_final_duration += abs(_data[i] / _duration.weight * _data[i] / _sumAbsChange);
					i += 4;
				}
				
				_t[@ TGMX_T_DURATION] = _final_duration;
			break;
			
			case 4: // "sum"
				// Sum the absolute change values from each property
				var _sumAbsChange = 0;
				i = 3;	
				repeat(_count)
				{
					_sumAbsChange += abs(_data[i]);
					i += 4;
				}
				
				_t[@ TGMX_T_DURATION] = _sumAbsChange/_duration.sum;
			break;
			
			case 5: // "max"
				var _max = abs(_data[3]); 
				i = 7;
				repeat(_count-1)
				{
					if (abs(_data[i]) > _max)
					{ 
						_max = abs(_data[i]); 
					}
				
					i += 4;
				}
			
				_t[@ TGMX_T_DURATION] = _max / _duration.max;
			break;
			
			case 6: // "min"
				var _min = min(_data[3]);
				i = 7;
				repeat(_count-1)
				{
					if (min(_data[i]) < _min)  
					{ 
						_min = abs(_data[i]); 
					}
				
					i += 4;
				}
			
				_t[@ TGMX_T_DURATION] = _min / _duration.min;
			break;
			
			default:
				show_error("TweenGMX: Invalid duration key supplied -> {" + variable_struct_get_names(_duration)[0] + ": }", false);
			}
		}
	}
		
	// Make sure we don't have an invalid duration [0]
	if (_t[TGMX_T_DURATION] <= 0 || is_nan(_t[TGMX_T_DURATION]))
	{
		_t[@ TGMX_T_DURATION] = 0.000000001;	
	}
	
	// Adjust for amount
	if (_t[TGMX_T_AMOUNT] > 0)
	{
		_t[@ TGMX_T_TIME] = _t[TGMX_T_AMOUNT] * _t[TGMX_T_DURATION];	
	}
}


/// @ignore
/// @function TGMX_TweenProcess( tween_array, time, data, target )
/// @description TGMX ADMIN: Processes tween algorithm and updates properties
/// @param {Array} tween
/// @param {Real} time
/// @param {Array} data
/// @param {Any} target
function TGMX_TweenProcess(_t, _time, _d, _target) 
{ 	
	switch(_d[0]) // Property Count
	{
	case 1:
		if (is_method(_t[TGMX_T_EASE]))
		{
			_d[1](_t[TGMX_T_EASE](_time, _d[2], _d[3], _t[TGMX_T_DURATION], _t), _target, _d[4], _t);
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
	
	case 0: // Break out for tweens with no properties
	break;
	
	default: // Handle "unlimited" properties
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


/// @ignore
/// @function TGMX_ExecuteEvent( tween_array, event_type )
/// @description TGMX_ADMIN: Executes a tween's event callbacks
/// @param {Array} tween_array
/// @param {Any} event_type
function TGMX_ExecuteEvent(_t, _eventType) 
{	
	static _ = SharedTweener();
	ds_map_set(global.TGMX.EventMaps[_eventType], _t[TGMX_T_ID], 0); // SET EVENTS MAP FOR TweenJust*() CHECKS
	
	// IF EVENTS AND EVENT TYPE INITIALIZED...
	if (_t[TGMX_T_EVENTS] != -1)
	{
	    if (ds_map_exists(_t[TGMX_T_EVENTS], _eventType))
	    {
			// TRACK TWEEN SELF
			global.TGMX.tween_self = _t[TGMX_T_ID];
	        // GET EVENT DATA
	        var _event = _t[TGMX_T_EVENTS][? _eventType];
			// INITIATE INDEX FOR LOOPING THROUGH ADDED CALLBACKS
			var _index = 0;
			
	        // Iterate through all event callbacks (isEnabled * event list size-1)
	        repeat(_event[| 0] * (ds_list_size(_event)-1))
	        {	
				_index += 1;
	            var _cb = _event[| _index]; // CACHE CALLBACK
   
				// FIRST CHECK TO SEE IF CALLBACK IS TO BE REMOVED
				if (_cb[TGMX_CB_TWEEN] == TWEEN_NULL)
				{
					ds_list_delete(_event, _index--);	
				}
				else // EXCEUTE CALLBACK SCRIPT WITH PROPER NUMBER OF ARGUMENTS
				if (_cb[TGMX_CB_ENABLED])
				{
					var _target = _cb[TGMX_CB_TARGET];
					
					// DO THIS PART AT CALLBACK EXECUTION
					if (is_struct(_target))
					{
						if (weak_ref_alive(_target))
						{
							_target = _target.ref;
						}
						else
						{
							continue;
						}
					}
					else
					if (!instance_exists(_target))
					{
						continue;
					}
					
					// UPDATE CALLBACK SELF REFERENCE MACRO
					TWEEN_CALLBACK_SELF = _cb;
					
					// EXECUTE CALLBACK
					if (TGMX_SUPPORT_LTS == false)
					{
						method_call(method(_target, _cb[TGMX_CB_SCRIPT]), _cb, TGMX_CB_ARG, array_length(_cb)-TGMX_CB_ARG);
					}

					if (TGMX_SUPPORT_LTS == true)
					{
						switch(array_length(_cb)-TGMX_CB_ARG)
						{ 
							case 0:  method(_target, _cb[TGMX_CB_SCRIPT])(); break;
							case 1:  method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG]); break;
							case 2:  method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1]); break;
							case 3:  method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2]); break;
							case 4:  method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3]); break;
							case 5:  method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4]); break;
							case 6:  method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5]); break;
							case 7:  method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6]); break;
							case 8:  method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7]); break;
							case 9:  method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8]); break;
							case 10: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9]); break;
							case 11: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10]); break;
							case 12: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10], _cb[TGMX_CB_ARG+11]); break;
							case 13: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10], _cb[TGMX_CB_ARG+11], _cb[TGMX_CB_ARG+12]); break;
							case 14: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10], _cb[TGMX_CB_ARG+11], _cb[TGMX_CB_ARG+12], _cb[TGMX_CB_ARG+13]); break;
							case 15: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10], _cb[TGMX_CB_ARG+11], _cb[TGMX_CB_ARG+12], _cb[TGMX_CB_ARG+13], _cb[TGMX_CB_ARG+14]); break;
							case 16: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10], _cb[TGMX_CB_ARG+11], _cb[TGMX_CB_ARG+12], _cb[TGMX_CB_ARG+13], _cb[TGMX_CB_ARG+14], _cb[TGMX_CB_ARG+15]); break;
							case 17: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10], _cb[TGMX_CB_ARG+11], _cb[TGMX_CB_ARG+12], _cb[TGMX_CB_ARG+13], _cb[TGMX_CB_ARG+14], _cb[TGMX_CB_ARG+15], _cb[TGMX_CB_ARG+16]); break;
							case 18: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10], _cb[TGMX_CB_ARG+11], _cb[TGMX_CB_ARG+12], _cb[TGMX_CB_ARG+13], _cb[TGMX_CB_ARG+14], _cb[TGMX_CB_ARG+15], _cb[TGMX_CB_ARG+16], _cb[TGMX_CB_ARG+17]); break;
							case 19: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10], _cb[TGMX_CB_ARG+11], _cb[TGMX_CB_ARG+12], _cb[TGMX_CB_ARG+13], _cb[TGMX_CB_ARG+14], _cb[TGMX_CB_ARG+15], _cb[TGMX_CB_ARG+16], _cb[TGMX_CB_ARG+17], _cb[TGMX_CB_ARG+18]); break;
							case 20: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10], _cb[TGMX_CB_ARG+11], _cb[TGMX_CB_ARG+12], _cb[TGMX_CB_ARG+13], _cb[TGMX_CB_ARG+14], _cb[TGMX_CB_ARG+15], _cb[TGMX_CB_ARG+16], _cb[TGMX_CB_ARG+17], _cb[TGMX_CB_ARG+18], _cb[TGMX_CB_ARG+19]); break;
							case 21: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10], _cb[TGMX_CB_ARG+11], _cb[TGMX_CB_ARG+12], _cb[TGMX_CB_ARG+13], _cb[TGMX_CB_ARG+14], _cb[TGMX_CB_ARG+15], _cb[TGMX_CB_ARG+16], _cb[TGMX_CB_ARG+17], _cb[TGMX_CB_ARG+18], _cb[TGMX_CB_ARG+19], _cb[TGMX_CB_ARG+20]); break;
							case 22: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10], _cb[TGMX_CB_ARG+11], _cb[TGMX_CB_ARG+12], _cb[TGMX_CB_ARG+13], _cb[TGMX_CB_ARG+14], _cb[TGMX_CB_ARG+15], _cb[TGMX_CB_ARG+16], _cb[TGMX_CB_ARG+17], _cb[TGMX_CB_ARG+18], _cb[TGMX_CB_ARG+19], _cb[TGMX_CB_ARG+20], _cb[TGMX_CB_ARG+21]); break;
							case 23: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10], _cb[TGMX_CB_ARG+11], _cb[TGMX_CB_ARG+12], _cb[TGMX_CB_ARG+13], _cb[TGMX_CB_ARG+14], _cb[TGMX_CB_ARG+15], _cb[TGMX_CB_ARG+16], _cb[TGMX_CB_ARG+17], _cb[TGMX_CB_ARG+18], _cb[TGMX_CB_ARG+19], _cb[TGMX_CB_ARG+20], _cb[TGMX_CB_ARG+21], _cb[TGMX_CB_ARG+22]); break;
							case 24: method(_target, _cb[TGMX_CB_SCRIPT])(_cb[TGMX_CB_ARG], _cb[TGMX_CB_ARG+1], _cb[TGMX_CB_ARG+2], _cb[TGMX_CB_ARG+3], _cb[TGMX_CB_ARG+4], _cb[TGMX_CB_ARG+5], _cb[TGMX_CB_ARG+6], _cb[TGMX_CB_ARG+7], _cb[TGMX_CB_ARG+8], _cb[TGMX_CB_ARG+9], _cb[TGMX_CB_ARG+10], _cb[TGMX_CB_ARG+11], _cb[TGMX_CB_ARG+12], _cb[TGMX_CB_ARG+13], _cb[TGMX_CB_ARG+14], _cb[TGMX_CB_ARG+15], _cb[TGMX_CB_ARG+16], _cb[TGMX_CB_ARG+17], _cb[TGMX_CB_ARG+18], _cb[TGMX_CB_ARG+19], _cb[TGMX_CB_ARG+20], _cb[TGMX_CB_ARG+21], _cb[TGMX_CB_ARG+22], _cb[TGMX_CB_ARG+23]); break;
							default: show_error("Callback maximum argument count exceeded! In TGMX_9_Settings, please set ( #macro TGMX_SUPPORT_LTS false ) to allow unlimited callback arguments.", true);
						}
					}
				}
	        }
			
			// CLEAR [TWEEN_SELF] MACRO -- WE NEED TO DO THIS SO THAT TWEEN_SELF MACRO WORKS PROPERLY INSIDE PROPERTY SCRIPT CALLS
			// DON'T USE THE MACRO HERE DIRECTLY!!
			global.TGMX.tween_self = undefined;
	    }
	}
}

/// @ignore
/// @function TGMX_TweensExecute( tweens, script, [args0, ...] )
/// @description TGMX ADMIN: Iterates over selected tweens and performs specified function for each
/// @param {Any} tweens
/// @param {Any} script
/// @param {Any} [args0,...]
function TGMX_TweensExecute(_tStruct, _script) 
{	
	// Feather ignore all

	var _tweens = SharedTweener().tweens;
	var _args, _argCount = argument_count-2;
	var _tIndex = -1;
	
	switch(_argCount)
	{
		case 0: _args = [undefined]; break;
		case 1: _args = [undefined, argument[2]]; break;
		case 2: _args = [undefined, argument[2], argument[3]]; break;
		case 3: _args = [undefined, argument[2], argument[3], argument[4]]; break;
		case 4: _args = [undefined, argument[2], argument[3], argument[4], argument[5]]; break;
		case 5: _args = [undefined, argument[2], argument[3], argument[4], argument[5], argument[6]]; break;
		case 6: _args = [undefined, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7]]; break;
		case 7: _args = [undefined, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8]]; break;
		case 8: _args = [undefined, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9]]; break;
		default: 
		_args = array_create(1+_argCount);
		var _argIndex = 0;
		repeat(_argCount)
		{
			_argIndex += 1;
			_args[_argIndex] = argument[_argIndex+1];
		}
	}
	
	// TARGET SELECT
	static STR_Target = "target";
	if (variable_struct_exists(_tStruct, STR_Target))
	{	
		if (is_array(_tStruct.target)) // ARRAY
		{
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
			    var _t = _tweens[| _tIndex];
			    var _target = _t[TGMX_T_TARGET];
						
				if (TGMX_TargetExists(_target)) 
				{
					var i = -1;
					repeat(array_length(_tStruct.target))
					{
						i += 1;
						var _selectionData = _tStruct.target[i];
						
						if (_selectionData == _tStruct) 
						{ 
							_selectionData = self;
						}
						
						if (is_struct(_target)) // STRUCT
						{
							if (is_struct(_selectionData) && _target.ref == _selectionData)
							{
								_args[0] = _t;
								script_execute_ext(_script, _args);
							}
						}
						else // INSTANCE
						if (!is_struct(_selectionData) && instance_exists(_selectionData)) 
						{ 
							if (_target == _selectionData.id || _target.object_index == _selectionData || object_is_ancestor(_target.object_index, _selectionData))
							{
								_args[0] = _t;
								script_execute_ext(_script, _args);
							}
						}
					}
				}
			}
		}
		else
		if (_tStruct.target == all) // All Targets
		{	
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
				var _t = _tweens[| _tIndex];
	            
				if (TGMX_TargetExists(_t[TGMX_T_TARGET]))
				{
					_args[0] = _t;
					script_execute_ext(_script, _args);
				}
			}
		}
		else // Specific Target
		{
			var _selectionData = (_tStruct == _tStruct.target) ? self : _tStruct.target;
			
			repeat ( ds_list_size(_tweens) ) {
				_tIndex += 1;
				var _t = _tweens[| _tIndex];
		        var _target = _t[TGMX_T_TARGET];
	
				if ( TGMX_TargetExists(_target) ) {
					if ( !is_struct(_target) && !is_struct(_selectionData) ) { //else // INSTANCE | OBJECT | CHILD
						if ( _target == _selectionData.id || _target.object_index == _selectionData || ( is_struct(_selectionData) && object_is_ancestor(_target.object_index, _selectionData) ) ) { _args[0] = _t; script_execute_ext(_script, _args); }
					}
					else { if ( _target.ref == _selectionData ) { _args[0] = _t; script_execute_ext(_script, _args); } } // STRUCT TARGET
				}
			}
		}
	}
	
	// GROUP
	static STR_Group = "group";
	var _select_group = _tStruct[$ STR_Group];
	if (_select_group != undefined)
	{	
		// SINGLE
		if (is_real(_select_group))
		{
			var _tIndex = -1;
			var _selectionData = _select_group;
        
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
		        var _t = _tweens[| _tIndex];
		        if (_t[TGMX_T_GROUP] == _selectionData && TGMX_TargetExists(_t[TGMX_T_TARGET]))
				{
					_args[0] = _t;
					script_execute_ext(_script, _args);	
				}
		    }
		}
		else // MULTI
		{
			var _tIndex = -1;
			
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
		        var _t = _tweens[| _tIndex];
				var i = -1;
				repeat(array_length(_select_group))
				{	
					i += 1;
					var _selectionData = _select_group[i];
					if (_t[TGMX_T_GROUP] == _selectionData && TGMX_TargetExists(_t[TGMX_T_TARGET]))
					{
						_args[0] = _t;
						script_execute_ext(_script, _args);
					}
				}
		    }
		}
	}
	
	// TWEEN STRUCT IDS
	static STR_Tween = "tween";
	var _tweens = _tStruct[$ STR_Tween];
	if (_tweens != undefined)
	{
		var _tIndex = -1;
		
		// SINGLE
		if (is_real(_tweens))
		{
			var _t = TGMX_FetchTween(_tweens);
		    if (is_array(_t) && TGMX_TargetExists(_t[TGMX_T_TARGET]))
			{
				_args[0] = _t;
				script_execute_ext(_script, _args);
			}
		}
        else // ARRAY
		{
			repeat(array_length(_tweens))
			{
				_tIndex += 1;
		        var _t = TGMX_FetchTween(_tweens[_tIndex]);
		        if (is_array(_t) && TGMX_TargetExists(_t[TGMX_T_TARGET]))
				{
					_args[0] = _t;
					script_execute_ext(_script, _args);
				}
		    }
		}
	}
	
	// TWEEN LISTS OR ARRAYS
	static STR_List = "list";
	_tweens = _tStruct[$ STR_List];
	if (_tweens != undefined)
	{
		var _tIndex = -1;
		
		if (is_array(_tweens)) // array
		{
			repeat(array_length(_tweens))
			{
				_tIndex += 1;
				var _t = TGMX_FetchTween(_tweens[_tIndex]);
		        if (is_array(_t) && TGMX_TargetExists(_t[TGMX_T_TARGET]))
				{
					_args[0] = _t;
					script_execute_ext(_script, _args);
				}
			}
		}
		else // ds_list
		{
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
				var _t = TGMX_FetchTween(_tweens[| _tIndex]);
		        if (is_array(_t) && TGMX_TargetExists(_t[TGMX_T_TARGET]))
				{
					_args[0] = _t;
					script_execute_ext(_script, _args);
				}
			}
		}
	}
}


/// @ignore
/// @function TGMX_TweensExecuteBool( tweens, script, [args0, ...] )
/// @description TGMX ADMIN: Iterates over selected tweens and returns true if any condition for tween is true
/// @param {Any} tweens
/// @param {Any} script
/// @param {Any} [args0,...]
function TGMX_TweensExecuteBool(_tStruct, _script) 
{	
	// Currently takes only a max of 3 optional arguments
	// Feather ignore all

	var _tweens = SharedTweener().tweens;
	var _args, _argCount = argument_count-2;
	var _tIndex = -1;
	
	switch(_argCount)
	{
		case 0: _args = [undefined]; break;
		case 1: _args = [undefined, argument[2]]; break;
		case 2: _args = [undefined, argument[2], argument[3]]; break;
		case 3: _args = [undefined, argument[2], argument[3], argument[4]]; break;
		case 4: _args = [undefined, argument[2], argument[3], argument[4], argument[5]]; break;
		case 5: _args = [undefined, argument[2], argument[3], argument[4], argument[5], argument[6]]; break;
		case 6: _args = [undefined, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7]]; break;
		case 7: _args = [undefined, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8]]; break;
		case 8: _args = [undefined, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9]]; break;
		default: 
		_args = array_create(1+_argCount);
		var _argIndex = 0;
		repeat(_argCount)
		{
			_argIndex += 1;
			_args[_argIndex] = argument[_argIndex+1];
		}
	}
	
	// TARGET SELECT
	static STR_Target = "target";
	if (variable_struct_exists(_tStruct, STR_Target))
	{	
		if (is_array(_tStruct.target)) // ARRAY
		{
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
			    var _t = _tweens[| _tIndex];
			    var _target = _t[TGMX_T_TARGET];
						
				if (TGMX_TargetExists(_target)) 
				{
					var i = -1;
					repeat(array_length(_tStruct.target))
					{
						i += 1;
						var _selectionData = _tStruct.target[i];
						
						if (_selectionData == _tStruct) 
						{ 
							_selectionData = self; 
						}
						
						if (is_struct(_target)) // STRUCT
						{
							if (is_struct(_selectionData) && _target.ref == _selectionData)
							{
								_args[0] = _t;
								if (script_execute_ext(_script, _args))
								{
									return true;	
								}
							}
						}
						else // INSTANCE
						if (!is_struct(_selectionData) && instance_exists(_selectionData)) 
						{ 
							if (_target == _selectionData.id || _target.object_index == _selectionData || object_is_ancestor(_target.object_index, _selectionData))
							{
								_args[0] = _t;
								if (script_execute_ext(_script, _args))
								{
									return true;	
								}
							}
						}	
					}
				}
			}
		}
		else
		if (_tStruct.target == all) // All Targets
		{	
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
				var _t = _tweens[| _tIndex];
	            
				if (TGMX_TargetExists(_t[TGMX_T_TARGET]))
				{
					_args[0] = _t;
					if (script_execute_ext(_script, _args))
					{
						return true;	
					}
				}
			}
		}
		else // Specific Target
		{
			var _selectionData = (_tStruct == _tStruct.target) ? self : _tStruct.target;
			
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
				var _t = _tweens[| _tIndex];
		        var _target = _t[TGMX_T_TARGET];
	
				if (TGMX_TargetExists(_target))
				{
					if (is_struct(_target)) // STRUCT TARGET
					{
						if (_target.ref == _selectionData)
						{
							_args[0] = _t;
							if (script_execute_ext(_script, _args))
							{
								return true;	
							}
						}
					}
					else // INSTANCE | OBJECT | CHILD
					{
						if (_target == _selectionData.id || _target.object_index == _selectionData || object_is_ancestor(_target.object_index, _selectionData))
						{
							_args[0] = _t;
							if (script_execute_ext(_script, _args))
							{
								return true;	
							}
						}
					}
				}
			}
		}
	}
	
	// GROUP
	static STR_Group = "group";
	var _select_group = _tStruct[$ STR_Group];
	if (_select_group != undefined)
	{	
		// SINGLE
		if (is_real(_select_group))
		{
			var _tIndex = -1;
			var _selectionData = _select_group;
        
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
		        var _t = _tweens[| _tIndex];
		        if (_t[TGMX_T_GROUP] == _selectionData && TGMX_TargetExists(_t[TGMX_T_TARGET]))
				{
					_args[0] = _t;
					if (script_execute_ext(_script, _args))
					{
						return true;	
					}
				}
		    }
		}
		else // MULTI
		{
			var _tIndex = -1;
			
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
		        var _t = _tweens[| _tIndex];
				var i = -1;
				repeat(array_length(_select_group))
				{	
					i += 1;
					var _selectionData = _select_group[i];
					if (_t[TGMX_T_GROUP] == _selectionData && TGMX_TargetExists(_t[TGMX_T_TARGET]))
					{
						_args[0] = _t;
						if (script_execute_ext(_script, _args))
						{
							return true;	
						}
					}
				}
		    }
		}
	}
	
	// TWEEN STRUCT IDS
	static STR_Tween = "tween";
	var _tweens = _tStruct[$ STR_Tween];
	if (_tweens != undefined)
	{
		var _tIndex = -1;
		
		// SINGLE
		if (is_real(_tweens))
		{
			var _t = TGMX_FetchTween(_tweens);
		    if (is_array(_t) && TGMX_TargetExists(_t[TGMX_T_TARGET]))
			{
				_args[0] = _t;
				if (script_execute_ext(_script, _args))
				{
					return true;	
				}
			}
		}
        else // ARRAY
		{
			repeat(array_length(_tweens))
			{
				_tIndex += 1;
		        var _t = TGMX_FetchTween(_tweens[_tIndex]);
		        if (is_array(_t) && TGMX_TargetExists(_t[TGMX_T_TARGET]))
				{
					_args[0] = _t;
					if (script_execute_ext(_script, _args))
					{
						return true;	
					}
				}
		    }
		}
	}
	
	// TWEEN LISTS OR ARRAYS
	static STR_List = "list";
	_tweens = _tStruct[$ STR_List];
	if (_tweens != undefined)
	{
		var _tIndex = -1;
		
		if (is_array(_tweens)) // array
		{
			repeat(array_length(_tweens))
			{
				_tIndex += 1;
				var _t = TGMX_FetchTween(_tweens[_tIndex]);
		        if (is_array(_t) && TGMX_TargetExists(_t[TGMX_T_TARGET]))
				{
					_args[0] = _t;
					if (script_execute_ext(_script, _args))
					{
						return true;	
					}
				}
			}
		}
		else // ds_list
		{
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
				var _t = TGMX_FetchTween(_tweens[| _tIndex]);
		        if (is_array(_t) && TGMX_TargetExists(_t[TGMX_T_TARGET]))
				{
					_args[0] = _t;
					if (script_execute_ext(_script, _args))
					{
						return true;	
					}
				}
			}
		}
	}
	
	// MAKE SURE TO RETURN FALSE IF WE HAVE NO TRUE CONDITION ABOVE ^^
	return false;
}


/// @ignore
function TGMX_TweenBoundsSwap(_t)
{
	// SWAP DURATION //
	if (is_array(_t[TGMX_T_DURATION_RAW]))
	{
		if (_t[TGMX_T_DURATION] == _t[TGMX_T_DURATION_RAW][0])
		{
			_t[@ TGMX_T_DURATION] = _t[TGMX_T_DURATION_RAW][1];
			// NOTE: This silently updates the internal time value... be careful!
			
			if (_t[TGMX_T_MODE] <= TWEEN_MODE_PATROL)
			{
				_t[@ TGMX_T_TIME] += _t[TGMX_T_DURATION_RAW][1] - _t[TGMX_T_DURATION_RAW][0];
			}
		}
		else
		{
			_t[@ TGMX_T_DURATION] = _t[TGMX_T_DURATION_RAW][0];
		}
	}
	
	// SWAP EASE ALGORITHM //
	if (is_array(_t[TGMX_T_EASE_RAW]))
	{
		// Deal with method ease
		if (is_method(_t[TGMX_T_EASE]))
		{
			if (is_method(_t[TGMX_T_EASE_RAW][0]))
			{
				if (method_get_index(_t[TGMX_T_EASE]) == method_get_index(_t[TGMX_T_EASE_RAW][0]))
				{
					_t[@ TGMX_T_EASE] = _t[TGMX_T_EASE_RAW][1];
				}
				else
				{
					_t[@ TGMX_T_EASE] = _t[TGMX_T_EASE_RAW][0];
				}
			}
			else
			{
				if (method_get_index(_t[TGMX_T_EASE]) == _t[TGMX_T_EASE_RAW][0])
				{
					_t[@ TGMX_T_EASE] = _t[TGMX_T_EASE_RAW][1];
				}
				else
				{
					_t[@ TGMX_T_EASE] = _t[TGMX_T_EASE_RAW][0];
				}
			}
		}
		else // animation channel
		{
			if (is_method(_t[TGMX_T_EASE_RAW][0]))
			{
				if (_t[TGMX_T_EASE] == method_get_index(_t[TGMX_T_EASE_RAW][0]))
				{
					_t[@ TGMX_T_EASE] = _t[TGMX_T_EASE_RAW][1];
				}
				else
				{
					_t[@ TGMX_T_EASE] = _t[TGMX_T_EASE_RAW][0];
				}
			}
			else
			{
				if (_t[TGMX_T_EASE] == _t[TGMX_T_EASE_RAW][0])
				{
					_t[@ TGMX_T_EASE] = _t[TGMX_T_EASE_RAW][1];
				}
				else
				{
					_t[@ TGMX_T_EASE] = _t[TGMX_T_EASE_RAW][0];
				}
			}
		}
	}
}

/// @ignore
function TGMX_TweenHasReachedBounds(_t, _target, _time, _timeScaleDelta)
{
	if (_t[TGMX_T_SCALE] != 0 && _t[TGMX_T_GROUP_SCALE][0] != 0 && (!_t[TGMX_T_DELTA] || _timeScaleDelta != 0)) // Make sure time scale isn't "paused"
    {			
        // Update tween based on its play mode -- Could put overflow wait time in here????
        switch(_t[TGMX_T_MODE])
        {
	    case TWEEN_MODE_ONCE:
			// Set tween's state as STOPPED
	        _t[@ TGMX_T_STATE] = TGMX_T_STATE_STOPPED;	 
			// Update tween's time to duration or 0
			_t[@ TGMX_T_TIME] = _time > 0 ? _t[TGMX_T_DURATION] : 0;
	        // Update property
			TGMX_TweenProcess(_t, _t[TGMX_T_TIME], _t[TGMX_T_PROPERTY_DATA], _target);
	        // Execute FINISH event
	        TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH);
			// Destroy tween if temporary
	        if (_t[TGMX_T_DESTROY]) { TweenDestroy(_t); }
	    break;
                        
		case TWEEN_MODE_BOUNCE:
		    if (_time > 0)
		    {	
				// UPDATE TIME
				_t[@ TGMX_T_TIME] = _time;
								
				// REST
				if (_t[TGMX_T_REST] > 0)
				{
					// Mark as resting
					_t[@ TGMX_T_REST] = -_t[TGMX_T_REST];
					// Update property
					TGMX_TweenProcess(_t, _t[TGMX_T_DURATION], _t[TGMX_T_PROPERTY_DATA], _target);
					// Execute Rest Event
					TGMX_ExecuteEvent(_t, TWEEN_EV_REST);
				}
									
				// CONTINUE
				if (_time >= _t[TGMX_T_DURATION] - _t[TGMX_T_REST])
				{
					// Mark as no longer resting
					_t[@ TGMX_T_REST] = -_t[TGMX_T_REST];
					// Assign raw time to tween -- adjust for overflow
					_t[@ TGMX_T_TIME] = 2*_t[TGMX_T_DURATION] + _t[TGMX_T_REST] - _time;	
					// NOTE: This can silently update tween's time
					TGMX_TweenBoundsSwap(_t);
					// Reverse direction
				    _t[@ TGMX_T_DIRECTION] = -_t[TGMX_T_DIRECTION];  
					// Reverse time scale
				    _t[@ TGMX_T_SCALE] = -_t[TGMX_T_SCALE];
				    // Update property
				    TGMX_TweenProcess(_t, _t[TGMX_T_TIME], _t[TGMX_T_PROPERTY_DATA], _target);
					// Execute CONTINUE event
				    TGMX_ExecuteEvent(_t, TWEEN_EV_CONTINUE);
				}
				else
				{	// Execute Resting Event
					TGMX_ExecuteEvent(_t, TWEEN_EV_RESTING);	
				}
		    }
		    else // FINISH
		    {
				// Update tween's time
				_t[@ TGMX_T_TIME] = 0;		
				// Reverse direction
			    _t[@ TGMX_T_DIRECTION] = -_t[TGMX_T_DIRECTION];
				// Reverse time scale
			    _t[@ TGMX_T_SCALE] = -_t[TGMX_T_SCALE];
				// Set tween state as STOPPED
		        _t[@ TGMX_T_STATE] = TGMX_T_STATE_STOPPED;
				// Update property
		        TGMX_TweenProcess(_t, 0, _t[TGMX_T_PROPERTY_DATA], _target);
		        // Execute FINISH event
				TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH);
				// Destroy tween if temporary
		        if (_t[TGMX_T_DESTROY]) { TweenDestroy(_t); }    
		    }
		break;
                        
	    case TWEEN_MODE_PATROL:		
			// FINISH
			if (_t[TGMX_T_CONTINUE_COUNT] == 0) 
			{
				// Update tween's time
				_t[@ TGMX_T_TIME] = _time > 0 ? _t[TGMX_T_DURATION] : 0;
				// Reverse direction
				_t[@ TGMX_T_DIRECTION] = -_t[TGMX_T_DIRECTION];  
				// Reverse time scale
				_t[@ TGMX_T_SCALE] = -_t[TGMX_T_SCALE];
				// Set tween state as STOPPED
				_t[@ TGMX_T_STATE] = TGMX_T_STATE_STOPPED;
				// Update property
				TGMX_TweenProcess(_t, _t[TGMX_T_TIME], _t[TGMX_T_PROPERTY_DATA], _target);
				// Execute FINISH event
				TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH);
				// Destroy tween if temporary
				if (_t[TGMX_T_DESTROY]) { TweenDestroy(_t); }   
								
				break;
			}
						
			// UPDATE TIME
			_t[@ TGMX_T_TIME] = _time;
							
			if (is_real(_t[TGMX_T_REST]))
			{
				_t[@ TGMX_T_REST] = array_create(2, _t[TGMX_T_REST]);	
			}
							
			var _rest = _t[TGMX_T_REST];
			var _restIndex = _time > 0;
							
			// REST
			if (_rest[_restIndex] > 0)
			{
				// Mark as resting by setting to negative value
				_rest[@ _restIndex] = -_rest[_restIndex];
				// Update property
				TGMX_TweenProcess(_t, _time <= 0 ? 0 : _t[TGMX_T_DURATION], _t[TGMX_T_PROPERTY_DATA], _target);
				// Execute Rest Event
				TGMX_ExecuteEvent(_t, TWEEN_EV_REST);
			}
			
			// CONTINUE
			if (_time >= _t[TGMX_T_DURATION] - _rest[_restIndex] || _time <= _rest[_restIndex])
			{
				// Decrement continue counter
				_t[@ TGMX_T_CONTINUE_COUNT] = _t[TGMX_T_CONTINUE_COUNT] - 1;
				// Mark as no longer resting
				_rest[@ _restIndex] = -_rest[_restIndex];
				// Assign raw time to tween -- adjust for overflow
				_t[@ TGMX_T_TIME] = _time > 0 ? 2*_t[TGMX_T_DURATION] + _rest[_restIndex] - _time : abs(_time)-_rest[_restIndex];
				// NOTE: This can silently update tween's time
				TGMX_TweenBoundsSwap(_t);
				// Reverse direction
				_t[@ TGMX_T_DIRECTION] = -_t[TGMX_T_DIRECTION];  
				// Reverse time scale
				_t[@ TGMX_T_SCALE] = -_t[TGMX_T_SCALE];
				// Update property
				TGMX_TweenProcess(_t, _t[TGMX_T_TIME], _t[TGMX_T_PROPERTY_DATA], _target);
				// Execute CONTINUE event
				TGMX_ExecuteEvent(_t, TWEEN_EV_CONTINUE);
			}
			else
			{	// Execute Resting Event
				TGMX_ExecuteEvent(_t, TWEEN_EV_RESTING);
			}
	    break;
                        
	    case TWEEN_MODE_LOOP:		
			// FINISH
			if (_t[TGMX_T_CONTINUE_COUNT] == 0) 
			{
				// Update tween's time
				_t[@ TGMX_T_TIME] = _t[TGMX_T_DURATION];		 
				// Set tween state as STOPPED
				_t[@ TGMX_T_STATE] = TGMX_T_STATE_STOPPED;
				// Update property
				TGMX_TweenProcess(_t, _t[TGMX_T_TIME], _t[TGMX_T_PROPERTY_DATA], _target);
				// Execute FINISH event
				TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH);
				// Destroy tween if temporary
				if (_t[TGMX_T_DESTROY]) { TweenDestroy(_t); }   
				// Break out of mode's switch case
				break;
			}
						
			// UPDATE TIME
			_t[@ TGMX_T_TIME] = _time;
						
			// REST
			if (_t[TGMX_T_REST] > 0)
			{
				// Mark as resting
				_t[@ TGMX_T_REST] = -_t[TGMX_T_REST];
				// Update property
				TGMX_TweenProcess(_t, _time <= 0 ? 0 : _t[TGMX_T_DURATION], _t[TGMX_T_PROPERTY_DATA], _target);
				// Execute Rest Event
				TGMX_ExecuteEvent(_t, TWEEN_EV_REST);
			}
								
			// Check for continue
			if (_time >= _t[TGMX_T_DURATION] - _t[TGMX_T_REST] || _time <= _t[TGMX_T_REST])
			{
				_t[@ TGMX_T_CONTINUE_COUNT] = _t[TGMX_T_CONTINUE_COUNT] - 1;
				// Mark as no longer resting
				_t[@ TGMX_T_REST] = -_t[TGMX_T_REST];
				// Assign raw time to tween
				_t[@ TGMX_T_TIME] = _time > 0 ? _time-_t[TGMX_T_DURATION]-_t[TGMX_T_REST] : _time+_t[TGMX_T_DURATION]+_t[TGMX_T_REST];
				// Swap eases or duration -- can silenty change tween's time
				TGMX_TweenBoundsSwap(_t);
		        // Update property
		        TGMX_TweenProcess(_t, _t[TGMX_T_TIME], _t[TGMX_T_PROPERTY_DATA], _target);
		        // Execute CONTINUE event
		        TGMX_ExecuteEvent(_t, TWEEN_EV_CONTINUE);
			}
			else // Keep resting
			{
				TGMX_ExecuteEvent(_t, TWEEN_EV_RESTING);
			}
		break;
                        
	    case TWEEN_MODE_REPEAT:
							
			// FINISH
			if (_t[TGMX_T_CONTINUE_COUNT] == 0) 
			{
				// Update tween's time
				_t[@ TGMX_T_TIME] = _t[TGMX_T_DURATION];		 
				// Set tween state as STOPPED
				_t[@ TGMX_T_STATE] = TGMX_T_STATE_STOPPED;
				// Update property
				TGMX_TweenProcess(_t, _t[TGMX_T_TIME], _t[TGMX_T_PROPERTY_DATA], _target);
				// Execute FINISH event
				TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH);
				// Destroy tween if temporary
				if (_t[TGMX_T_DESTROY]) { TweenDestroy(_t); }   
				// Break out of switch case
				break;
			}
							
			// UPDATE TIME
			_t[@ TGMX_T_TIME] = _time;
							
			// REST
			if (_t[TGMX_T_REST] > 0)
			{
				// Mark as resting
				_t[@ TGMX_T_REST] = -_t[TGMX_T_REST];
				// Update property
				TGMX_TweenProcess(_t, _time <= 0 ? 0 : _t[TGMX_T_DURATION], _t[TGMX_T_PROPERTY_DATA], _target);
				// Execute Rest Event
				TGMX_ExecuteEvent(_t, TWEEN_EV_REST);
			}
								
			// CONTINUE
			if (_time >= _t[TGMX_T_DURATION] - _t[TGMX_T_REST] || _time <= _t[TGMX_T_REST])
			{
				// Decrement countinue counter
				_t[@ TGMX_T_CONTINUE_COUNT] = _t[TGMX_T_CONTINUE_COUNT] - 1;
				// Mark as no longer resting
				_t[@ TGMX_T_REST] = -_t[TGMX_T_REST];
				// Update raw time with epsilon compensation
				_t[@ TGMX_T_TIME] = _time > 0 ? _time-_t[TGMX_T_DURATION]-_t[TGMX_T_REST] : _time+_t[TGMX_T_DURATION]+_t[TGMX_T_REST];
				// NOTE: This can silently update tween's time
				TGMX_TweenBoundsSwap(_t);
				// Update new relative start position
				var _data = _t[TGMX_T_PROPERTY_DATA];
				var i = 2;
				repeat(array_length(_data) div 4)
				{
					_data[@ i] += _time > 0 ? _data[i+1] : -_data[i+1];
					i += 4;
				}
		        // Update property
		        TGMX_TweenProcess(_t, _t[TGMX_T_TIME], _t[TGMX_T_PROPERTY_DATA], _target);
		        // Execute CONTINUE event
				TGMX_ExecuteEvent(_t, TWEEN_EV_CONTINUE);
			}
			else
			{
				TGMX_ExecuteEvent(_t, TWEEN_EV_RESTING);
			}
	    break;
                        
	    default:
	        show_error("Invalid Tween Mode! --> Forcing TWEEN_MODE_ONCE", false);
	        _t[@ TGMX_T_MODE] = TWEEN_MODE_ONCE;
        }
    }
}






