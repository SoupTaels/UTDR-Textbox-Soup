// Feather ignore all

/*
	These macros allow for improved performance
	if various features are not needed
*/

// Whether or not to support older runtimes (LTS 2022.1~)
// At the moment, setting to [false] will allow tween callbacks to support unlimited arguments and potentially execute callbacks faster
// (Please be advised that setting as [false] is still experimental)
	// false = Makes use of newer GM functions [experimental]
	// true  = Only use functions supported by LTS runtimes [default]
	#macro TGMX_SUPPORT_LTS false

// Timing Method -- Ability to set duration based on step and/or delta timing
	// 0 = Dynamic (delta & step) [default]
	// 1 = Step only  (frames)	-- improves performance
	// 2 = Delta only (seconds)	-- improves performnace
	#macro TGMX_USE_TIMING 1

// Target Support -- Ability to use instances and/or structs as direct tween targets
	// 0 = Dynamic (instances & structs) [default]
	// 1 = Instance only (object) -- improves performance
	// 2 = Struct only			  -- improves performance (not advised)
	#macro TGMX_USE_TARGETS 0
	
// Optimise User Event Properties when using TPUser() -- Setting as [true] requires TWEEN_USER_TARGET.some_variable to access tween target environment
	// false = [default]
	// true  = May improve performance for HTML5 platform
	#macro TGMX_OPTIMISE_USER false
	

// ** ADMIN ** 
// ** DO NOT TOUCH! **
#macro TGMX_TIMING_DYNAMIC 0
#macro TGMX_TIMING_STEP 1
#macro TGMX_TIMING_DELTA  2

#macro TGMX_TARGETS_DYNAMIC 0
#macro TGMX_TARGETS_INSTANCE 1
#macro TGMX_TARGETS_STRUCT 2

