/*
	Proverbs 3:5-8
*/

/// @desc [TweenGMX 1.0.8]
/// Feather ignore all

TGMX_2_EaseFunctions();
TGMX_7_Properties();

// MAKE SURE NO TWEENER IS DEACTIVATED
instance_activate_object(o_SharedTweener);

// CLAIM SELF AS TWEENER IF NONE IS ASSIGNED
if (global.TGMX.SharedTweener == noone)
{
	global.TGMX.SharedTweener = id;
}
else // DESTROY SELF IF A TWEENER ALREADY EXISTS
if (instance_exists(global.TGMX.SharedTweener))
{
	instance_destroy(id, false);
	exit;
}
else // CLEAN UP PREVIOUS ENVIRONMENT AND ASSIGN SELF AS NEW TWEENER
{
	TGMX_Cleanup();
	global.TGMX.SharedTweener = id;	
}

// ATTEMPT TO "STAY OUT OF THE WAY"
x = -100000; y = -100000;

// GLOBAL SYSTEM-WISE SETTINGS
isEnabled = global.TGMX.IsEnabled;                     // System's active state flag
timeScale = global.TGMX.TimeScale;                     // Global time scale of tweening engine
minDeltaFPS = global.TGMX.MinDeltaFPS;                 // Minimum frame rate before delta time will lag behind
updateInterval = global.TGMX.UpdateInterval;           // Step interval to update system (default = 1)
autoCleanIterations = global.TGMX.AutoCleanIterations; // Number of tweens to check each step for auto-cleaning

// SYSTEM MAINTENANCE VARIABLES
tick = 0;									 // System update timer
autoCleanIndex = 0;							 // Used to track index when processing passive memory manager
maxDelta = 1/minDeltaFPS;					 // Cache delta cap
deltaTime = 1/game_get_speed(gamespeed_fps); // Let's make delta time more practical to work with, shall we?
prevDeltaTime = deltaTime;					 // Holds delta time from previous step
deltaRestored = false;						 // Used to help maintain predictable delta timing
addDelta = 0;								 // Amount to add to delta time if update interval not reached
flushDestroyed = false;						 // Flag to indicate if destroyed tweens should be immediately cleared
tweensProcessNumber = 0;					 // Number of tweens to be actively processed in update loop
delaysProcessNumber = 0;					 // Number of delays to be actively processed in update loop
inUpdateLoop = false;						 // Is tweening system actively processing tweens?

// REQUIRED DATA STRUCTURES
tweens = ds_list_create();           // Stores automated step tweens
delayedTweens = ds_list_create();    // Stores tween delay data
pRoomTweens = ds_map_create();       // Associates persistent rooms with stored tween lists
pRoomDelays = ds_map_create();       // Associates persistent rooms with stored tween delay lists
eventCleaner = ds_priority_create(); // Used to clean callbacks from events
stateChanger = ds_queue_create();	 // Used to delay change of tween state when in the update loop

// THESE ARE USED TO CLEAN UP THE SYSTEM AFTER SHARED TWEENER IS ALREADY GONE
global.TGMX.tweens = tweens;
global.TGMX.delayedTweens = delayedTweens;
global.TGMX.pRoomTweens = pRoomTweens;
global.TGMX.pRoomDelays = pRoomDelays;
global.TGMX.eventCleaner = eventCleaner;
global.TGMX.stateChanger = stateChanger;

// SET DEFAULTS FOR TWEEN USER PROPERTIES
TWEEN_USER_GET = 0;
TWEEN_USER_VALUE = 0;
TWEEN_USER_DATA = undefined;
TWEEN_USER_TARGET = noone;






