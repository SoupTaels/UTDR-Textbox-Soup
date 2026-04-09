// Feather ignore all
var _; // USED TO HIDE SYNTAX WARNINGS

//============================
// PROPERTY SETTER FUNCTIONS
//============================

/// @function TPFunc( target, name, setter, [getter] )
/// @param {Any} target		instance or struct to associate with custom setter/getter (overrides TPFuncShared())
/// @param {Any} name		string name to associate with custom setter/getter
/// @param {Any} setter		function or method to use as setter
/// @param {Any} [getter]	function or method to use as getter
function TPFunc(_target, _name, _setter)
{
	static STR_DOLLAR = "$";
	static STR_AMPERSAND = "&";
	static _assignName = "";
	_setter = method(undefined, _setter);
	
	// Check for "<" or ">" to/from and strip it for _variable name assignment
	if (string_byte_at(_name, string_length(_name)) == 60 || string_byte_at(_name, string_length(_name)) == 62)
	{
		_assignName = string_delete(_name, string_length(_name), 1);
	}
	else
	{
		_assignName = _name;
	}
	
	// Connect setter method
	_target[$ STR_DOLLAR+_assignName] = _setter;
	
	// Connect getter method
	if (argument_count == 4 && argument[3] != undefined)
	{
		_target[$ STR_AMPERSAND+_assignName] = method(undefined, argument[3]);
	}
	
	return _name; // This allows us to place this directly into a tween function if desired
}_=TPFunc;


/// @function TPFuncShared( name, setter, getter )
/// @param {Any} name	string name to associate with custom setter/getter
/// @param {Any} setter		function or method to use as setter
/// @param {Any} getter		function or method to use as getter
function TPFuncShared(_name, _setter, _getter=undefined) 
{
	// Make sure system is already initialized
	static _ = TGMX_Begin();

	// Associate shared _variable name with a setter function for all targets
	global.TGMX.PropertySetters[? _name] = method(undefined, _setter);

	if (_getter != undefined)
	{
		global.TGMX.PropertyGetters[? _name] = method(undefined, argument[2]);
	}
}


/// @function TPFuncSharedNormal( name, setter, [getter] )
/// @param {Any} name	string name to associate with custom setter/getter
/// @param {Any} setter		function or method to use as setter
/// @param {Any} [getter]	function or method to use as getter
function TPFuncSharedNormal(_name, _setter) 
{
	/*
		Normalized property scripts receive an eased _value between 0 and 1
		with additional _data passed for the start/dest values.
	*/
	
	if (argument_count == 2)
	{
		TPFuncShared(_name, _setter);	
	}
	else
	{
		TPFuncShared(_name, _setter, argument[2]);	
	}

	// Mark as a shared normalized property
	global.TGMX.PropertyNormals[? _name] = 1;
}


//============================
// Property Modifiers
//============================

/// @function TPModify( property, func, [args] )
/// @param {Any} property
/// @param {Any} func
/// @param {Any} args	MUST BE AN ARRAY
//function TPModify(_property, _func, _args) { return [TPModify, _property, undefined, undefined, undefined, undefined, undefined, [_func,_args]]; }

/// @function TPCeil( property )
/// @param {Any} property
function TPCeil(_property) { return [TPCeil, _property, undefined, undefined, undefined, undefined, undefined]; }

/// @function TPFloor( property )
/// @param {Any} property
function TPFloor(_property) { return [TPFloor, _property, undefined, undefined, undefined, undefined, undefined]; }

/// @function TPRound( property )
/// @param {Any} property
function TPRound(_property) { return [TPRound, _property, undefined, undefined, undefined, undefined, undefined]; }

/// @function TPSnap( property, snap )
/// @param {Any} property
/// @param {Any} snap
function TPSnap(_property, _snap) { return [TPSnap, _property, undefined, undefined, undefined, undefined, undefined, _snap]; }

/// @function TPShake( property, amount )
/// @param {Any} property
/// @param {Any} amount
function TPShake(_property, _amount) { return [TPShake, _property, undefined, undefined, undefined, undefined, undefined, _amount]; }





//============================
// Data Structure Properties
//============================
/// @function TPArray( array, index );
/// @param {Array} array
/// @param {Any} index
function TPArray(_array, _index) { return [TPArray, _array, _index]; }

/// @function TPGrid( grid, x, y )
/// @param {Id.DsGrid} grid
/// @param {Any} x
/// @param {Any} y
function TPGrid(_grid, _x, _y)	{ return [TPGrid, _grid, _x, _y]; }

/// @function TPList( list, index )
/// @param {Id.DsList} list
/// @param {Any} index
function TPList(_list, _index) { return [TPList, _list, _index]; }

/// @function TPMap( map, key )
/// @param {Id.DsMap} map
/// @param {Any} key
function TPMap(_map, _key) { return [TPMap, _map, _key]; }


//============================
// Special Properties
//============================

/// @function TPTarget( target, name )
/// @param {Any} target		instance or struct
/// @param {Any} name		variable name
//function TPTarget(_target, _name) { return [TPTarget, is_struct(_target) ? weak_ref_create(_target) : _target, _name, undefined, undefined]; }
function TPTarget(_target, _name) 
{ 
	// CREATE A PHONY NORMALIZED FUNCTION (-10) FOR HINTING OF NORMALIZED VARIABLES
	static _f = function()
	{
		// THE SETTER/GETTER FOR [TPTarget] WILL STILL BE USED
		TPFuncSharedNormal(-10, global.TGMX.PropertySetters[? TPTarget], global.TGMX.PropertyGetters[? TPTarget]);
	}
	static _ = _f();
	static _cache = {};
	
	var _is_normal = _cache[$ _name];
	if (_is_normal == undefined)
	{
		// STRIP OUT ANY SPECIAL SYMBOLS (":" ">" "<") BEFORE SEEING IF VARIABLE IS TO BE NORMALIZED -- ADD RESULT TO CACHE FOR QUICK FUTURE LOOKUP
		var _check_normal_name = string_byte_at(_name, string_length(_name)) >= 65 ? _name : string_delete(_name, string_length(_name), 1);
		_is_normal = ds_map_exists(global.TGMX.PropertyNormals, _check_normal_name);
		_cache[$ _name] = _is_normal;
	}

	// THIS IS A BIT HACKEY -- BUT IT SEEMS TO WORK FINE!
	if (_is_normal) {
		return [-10, _name, undefined, undefined, undefined, is_struct(_target) ? weak_ref_create(_target) : _target]; 
	}
	else {
		return [TPTarget, _name, is_struct(_target) ? weak_ref_create(_target) : _target, undefined, undefined, undefined];
	}
}

/// @function TPCol( name )
/// @param {Any}	name		variable name
function TPCol(_property) { return [TPCol, _property, undefined, undefined, undefined, undefined, undefined]; }

/// @function TPPath( path, absolute? )
/// @param {Any} path		path index
/// @param {Bool} absolute	use absolute path start position?
function TPPath(_path, _absolute) { return [TPPath, _path, _absolute]; }

/// @function TPPathExt( path, x, y )
/// @param {Any} path		path index
/// @param {Any} x			starting x position
/// @param {Any} y			starting y position
function TPPathExt(_path, _x, _y) { return [TPPath, _path, _x, _y]; } _=TPPathExt;

/// @function TPUser( user_event )
/// @param {Any} user_event
/// @param {Any} argument
function TPUser(_user_event)		
{ 
	if (argument_count == 1) { return [TPUser, _user_event, undefined]; }
	if (argument_count == 2) { return [TPUser, _user_event, argument[1]]; }
	
	var i = -1, _args = array_create(argument_count-1);
	repeat(argument_count-1) 
	{ 
		i += 1;
		_args[i] = argument[i+1];
	}
	
	return [TPUser, _user_event, _args];
}

/// @ignore
function TGMX_PROCESS_PROPERTY_MODIFIER(_value, _target, _data, _tween)
{	
	// data array
	// 0 property
	// 1 data 1
	// 2 data 2
	// 3 data extended
	// 4 target
	// 5 execution type
	// 6 modifier data
	
	static STR_DOT = ".";
	static STR_GLOBAL_DOT = "global.";
	static STR_SELF_DOT = "self.";
	static STR_OTHER_DOT = "other.";
	static STR_DOLLAR = "$";
	
	if (_data[5] == undefined)
	{
		var _prop = _data[0];
		//_data[@ 6] = _prop; // KEEP TRACK OF RAW PROPERTY
		_data[@ 5] = 1; // DEFAULT EXECUTION TYPE

		if (is_array(_prop))
		{
			_data[@ 0] = _prop[0];										// ASSIGN FUNCTION SETTER	
			array_delete(_prop, 0, 1);									// KEEP ONLY THE PASSED DATA
			_data[@ 3] = array_length(_prop) == 1 ? _prop[0] : _prop;	// ASSIGN DIRECT VALUE IF ONLY ONE ARGUMENT, ELSE PASS THE WHOLE DATA ARRAY
			return; // RETURN EARLY
		}
	
		if (string_pos(STR_DOT, _prop))
		{
			if (string_pos(STR_GLOBAL_DOT, _prop))
			{
				if (ds_map_exists(global.TGMX.PropertySetters, _prop)) // SHARED BUILT SETTER (TPFuncShared)
				{
					_data[@ 0] = global.TGMX.PropertySetters[? _prop];
				}
				else
				{
					_data[@ 0] = global.TGMX.Variable_Global_Set;
					_data[@ 3] = string_replace(_prop, STR_GLOBAL_DOT, ""); // SET EXTENDED DATA
				}
			
				return; // RETURN EARLY
			}

			if (string_pos(STR_SELF_DOT, _prop))
			{
				_prop = string_replace(_prop, STR_SELF_DOT, "");
				_target = self;				
			}
			else // other
			if (string_pos(STR_OTHER_DOT, _prop))
			{
				_prop = string_replace(_prop, STR_OTHER_DOT, "");
				_target = other;
			}
			else // EXPLICIT TARGET
			{
				var _prefix = string_copy( _prop, 1, string_pos(STR_DOT, _prop)-1 );
				var _prop = string_copy(_prop, 1+string_pos(STR_DOT, _prop), 100);
				
				if (object_exists(asset_get_index(_prefix)))
				{
					_target = asset_get_index(_prefix).id;
				}
				else
				if (_target[$ _prefix] != undefined) // 
				{
					_target = _target[$ _prefix];
				}
				else
				if (_tween[TGMX_T_CALLER][$ _prefix] != undefined)
				{
					_target = _tween[TGMX_T_CALLER][$ _prefix];
				}
				else
				{
					_target = variable_global_get(_prefix);
				}
			}
			
			// FINALIZE EXPLICIT TARGET
			if (is_struct(_target))
			{
				_data[@ 4] = weak_ref_create(_target);
				_data[@ 5] = 2; // SET EXECUTION TYPE
			}
			else
			{
				_data[@ 4] = _target;
				_data[@ 5] = 3;	// SET EXECUTION TYPE
			}
		}		
			
		if (_target[$ STR_DOLLAR+_prop] != undefined) // LOCAL BUILT SETTER
		{
			_data[@ 0] = _target[$ STR_DOLLAR+_prop]
		}
		else 
		if (ds_map_exists(global.TGMX.PropertySetters, _prop)) // SHARED BUILT SETTER (TPFuncShared)
		{
			_data[@ 0] = global.TGMX.PropertySetters[? _prop];
		}
		else
		if (_target[$ _prop] != undefined) // ASSUME GENERIC SETTER
		{
			_data[@ 0] = global.TGMX.Variable_Instance_Set;
			_data[@ 3] = _prop; // SET EXTENDED DATA
		}
	}
	
	switch(_data[5])
	{
	case 1: _data[0](_value, _target, _data[3], _tween); break; // THIS USES THE TWEEN'S TARGET --> TARGET CHECK ISN'T NEEDED BECAUSE THE TWEEN WILL AREADY TAKE CARE OF THAT?
	case 2: if (weak_ref_alive(_data[4])) { _data[0](_value, _data[4].ref, _data[3], _tween); }
	case 3: if (instance_exists(_data[4])) { _data[0](_value, _data[4], _data[3], _tween); }
	}
}

/// @ignore
function TGMX_7_Properties()
{
	// MAKE SURE THIS ONLY FIRES ONCE
	static __initialized = false;
	if (__initialized) { return 0; }
	__initialized = true;
	
	// DEFAULT INSTANCE PROPERTIES
	TPFuncShared("undefined",			function(){}, function(){return 0;});
	TPFuncShared("x",					function(_v,_t){_t.x=_v;}, function(_t){return _t.x;});
	TPFuncShared("y",					function(_v,_t){_t.y=_v;}, function(_t){return _t.y;});
	TPFuncShared("z",					function(_v,_t){_t.z=_v;}, function(_t){return _t.z;});
	TPFuncShared("direction",			function(_v,_t){_t.direction=_v;}, function(_t){return _t.direction;});
	TPFuncShared("speed",				function(_v,_t){_t.speed=_v;}, function(_t){return _t.speed;});
	TPFuncShared("hspeed",				function(_v,_t){_t.hspeed=_v;}, function(_t){return _t.hspeed;});
	TPFuncShared("vspeed",				function(_v,_t){_t.vspeed=_v;}, function(_t){return _t.vspeed;});
	TPFuncShared("image_angle",			function(_v,_t){_t.image_angle=_v;}, function(_t){return _t.image_angle;});
	TPFuncShared("image_alpha",			function(_v,_t){_t.image_alpha=_v;}, function(_t){return _t.image_alpha;});
	TPFuncShared("image_speed",			function(_v,_t){_t.image_speed=_v;}, function(_t){return _t.image_speed;});
	TPFuncShared("image_index",			function(_v,_t){_t.image_index=_v;}, function(_t){return _t.image_index;});
	TPFuncShared("image_xscale",		function(_v,_t){_t.image_xscale=_v;}, function(_t){return _t.image_xscale;});
	TPFuncShared("image_yscale",		function(_v,_t){_t.image_yscale=_v;}, function(_t){return _t.image_yscale;});
	TPFuncShared("image_scale",			function(_v,_t){_t.image_xscale=_v; _t.image_yscale=_v;}, function(_t){return _t.image_xscale;});
	TPFuncShared("scale!",				function(_v,_t){_t.image_xscale=_v; _t.image_yscale=_v;}, function(_t){return _t.image_xscale;});
	TPFuncSharedNormal("image_blend",	function(_v,_t,_d){_t.image_blend=merge_colour(_d[0],_d[1],_v);}, function(_t){return _t.image_blend;});
	TPFuncShared("path_position",		function(_v,_t){_t.path_position=_v;}, function(_t){return _t.path_position;});
	TPFuncShared("path_scale",			function(_v,_t){_t.path_scale=_v;},	function(_t){return _t.path_scale;});
	TPFuncShared("path_speed",			function(_v,_t){_t.path_speed=_v;},	function(_t){return _t.path_speed;});
	TPFuncShared("path_orientation",	function(_v,_t){_t.path_orientation=_v;}, function(_t){return _t.path_orientation;});
	TPFuncShared("depth",				function(_v,_t){_t.depth=_v;}, function(_t){return _t.depth;});
	TPFuncShared("friction",			function(_v,_t){_t.friction=_v;}, function(_t){return _t.friction;});
	TPFuncShared("gravity",				function(_v,_t){_t.gravity=_v;}, function(_t){return _t.gravity;});
	TPFuncShared("gravity_direction",	function(_v,_t){_t.gravity_direction=_v;},function(_t){return _t.gravity_direction;});

	// Handle Built-in global variables as GameMaker doesn't seem to be recognising them as global values :(
	// Need this for the "Getters" to work right
	TPFuncShared("mouse_x", function(){},function(){return mouse_x;});
	TPFuncShared("mouse_y", function(){},function(){return mouse_y;});
	TPFuncShared("room_width", function(_v){},function(){return room_width;});
	TPFuncShared("room_height", function(_v){},function(){return room_height;});
	
	// Legacy Support
	TPFuncShared("health!", function(_v){health=_v;}, function(){return health;});
	TPFuncShared("health", function(_v,_t) {
		if (_t[$ "health"] != undefined) { _t.health=_v; } else {health=_v;}
	}, 
	function(_t) {
		if (_t[$ "health"] != undefined) {return _t.health;} else {return health;}
	});
	
	TPFuncShared("score!", function(_v){score=_v;}, function(){return score;});
	TPFuncShared("score", function(_v,_t) {
		if (_t[$ "score"] != undefined) { _t.score=_v; } else {score=_v;}
	}, 
	function() {
		if (_t[$ "score"] != undefined) {return _t.score;} else {return score;}
	});
	

	#region PROPERTY MODIFIERS -------------------------------
	
	//TPFuncShared(TPModify, function(_value, _target, _data, _tween) 
	//{	
	//	TGMX_PROCESS_PROPERTY_MODIFIER(_data[6][0](_value,_data[6][1]), _target, _data, _tween);
	//});
	
	TPFuncShared(TPCeil, function(_value, _target, _data, _tween)
	{	
		TGMX_PROCESS_PROPERTY_MODIFIER(ceil(_value), _target, _data, _tween);
	});

	TPFuncShared(TPFloor, function(_value, _target, _data, _tween) 
	{	
		TGMX_PROCESS_PROPERTY_MODIFIER(floor(_value), _target, _data, _tween);
	});

	TPFuncShared(TPRound, function(_value, _target, _data, _tween) 
	{	
		TGMX_PROCESS_PROPERTY_MODIFIER(round(_value), _target, _data, _tween);
	});
	
	TPFuncShared(TPSnap, function(_value, _target, _data, _tween) 
	{	
		TGMX_PROCESS_PROPERTY_MODIFIER(10000 * _value div (10000*_data[6]) * (10000*_data[6]) / 10000, _target, _data, _tween);
	});
	
	TPFuncShared(TPShake, function(_value, _target, _data, _tween) 
	{	
		// "SHAKE" THE FINAL VALUE
		if (_tween[TGMX_T_TIME] > 0 && _tween[TGMX_T_TIME] < _tween[TGMX_T_DURATION])
		{
			_value += random_range(-_data[6], _data[6]);
		}

		TGMX_PROCESS_PROPERTY_MODIFIER(_value, _target, _data, _tween);
	});
	

	#endregion ----------------------------------
	
	
	#region DATA STRUCTURE PROPERTIES ------------------------------------
	
	TPFuncShared(TPArray, 
	function(_value, _target, _data) 
	{
		if (is_string(_data[0])) 
		{ 
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		array_set(_data[0], _data[1], _value);
	}, 
	function(_target, _data) 
	{
		if (is_string(_data[0])) 
		{ 
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		return _data[0][_data[1]]; 
	});

	TPFuncShared(TPList, 
	function(_value, _target, _data) 
	{
		if (is_string(_data[0]))
		{
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		ds_list_replace(_data[0], _data[1], _value);
	}, 
	function(_target, _data) 
	{
		if (is_string(_data[0]))
		{
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
	
		return ds_list_find_value(_data[0], _data[1]);
	});

	TPFuncShared(TPGrid, 
	function(_value, _target, _data) 
	{
		if (is_string(_data[0]))
		{
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		ds_grid_set(_data[0], _data[1], _data[2], _value);
	}, 
	function(_target, _data) 
	{
		if (is_string(_data[0]))
		{
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		return ds_grid_get(_data[0], _data[1], _data[2]);
	});

	TPFuncShared(TPMap, 
	function(_value, _target, _data) 
	{
		if (is_string(_data[0]))
		{
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		ds_map_replace(_data[0], _data[1], _value);
	},
	function(_target, _data) 
	{
		if (is_string(_data[0]))
		{
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		return ds_map_find_value(_data[0], _data[1]);
	});
	
	#endregion --------------------------------------------------
	
	
	#region SPECIAL PROPERTIES ----------------------------------------
	
	TPFuncShared(TPTarget, 
	function(_value, _target, _data, _tween)
	{	
		static str_dollar = "$";

		// EXECUTE ONCE IF NOT YET DEFINED [3]
		if (_data[3] == undefined)
		{
			_data[@ 3] = true;	// MARK AS DEFINED 
			_target = is_struct(_data[1]) ? _data[1].ref : _data[1]; // DON'T USE THE TWEEN'S REAL TARGET
			var _prop = _data[0];	
			
			// EXTENDED ARRAY SETTER [X_JITTER, 10] (Left over from TPExt?) -- MIGHT REMOVE THIS LATER
			if (is_array(_prop))
			{
				_data[@ 0] = _prop[0];										// ASSIGN FUNCTION SETTER	
				array_delete(_prop, 0, 1);									// KEEP ONLY THE PASSED DATA
				_data[@ 2] = array_length(_prop) == 1 ? _prop[0] : _prop;	// ASSIGN DIRECT VALUE IF ONLY ONE ARGUMENT, ELSE PASS THE WHOLE DATA ARRAY
			}
			else // LOCAL BUILT SETTER -- TPFunc
			if (_target[$ str_dollar+_prop] != undefined) 
			{
				_data[@ 0] = _target[$ str_dollar+_prop]
			}
			else // BUILT PROPERTY SETTER -- TPFuncShared
			if (ds_map_exists(global.TGMX.PropertySetters, _prop))
			{
				_data[@ 0] = global.TGMX.PropertySetters[? _prop];
				
				// THIS IS FOR NORMALIZED PROPERTIES
				if (_data[4] != undefined)
				{
					_data[@ 2] = [_data[1], _data[2]]; 
					_data[@ 1] = _data[4];
				}
			}
			else // GENERIC SETTER
			{
				_data[@ 0] = global.TGMX.Variable_Instance_Set;
				_data[@ 2] = _prop;
			}
		}

		// UPDATE PROPERTY
		if (is_struct(_data[1])) // IS STRUCT TARGET
		{
			if (weak_ref_alive(_data[1]))
			{
				_data[0](_value, _data[1].ref, _data[2]);
			}
		}
		else // IS INSTANCE TARGET
		if (instance_exists(_data[1]))
		{
			_data[0](_value, _data[1], _data[2]);
		}
	}, 
	function(_target, _data, _tween)
	{
		if (global.TGMX.PropertyGetters[? _data[0]] != undefined) 
		{
			return global.TGMX.PropertyGetters[? _data[0]](_target);
		}
		
		if (is_struct(_data[1])) 
		{
			return weak_ref_alive(_data[1]) ? _data[1].ref[$ _data[0]] : 0;
		}
		else 
		{
			return instance_exists(_data[1]) ? _data[1][$ _data[0]] : 0;
		}
	});


	TPFuncShared(TPUser, 
	function(_value, _target, _data) 
	{
		TWEEN_USER_VALUE = _value;
		TWEEN_USER_TARGET = _target;
		TWEEN_USER_DATA = _data[1];
		
		if (TGMX_OPTIMISE_USER)
		{
			event_perform_object(_target.object_index, ev_other, ev_user0+_data[0]);
		}
		else
		with(TWEEN_USER_TARGET)
		{
			event_user(_data[0]);
		}
	}, 
	function(_target, _data) 
	{
		TWEEN_USER_GET = 1;
		TWEEN_USER_TARGET = _target;
		TWEEN_USER_DATA = _data[1];
		
		if (TGMX_OPTIMISE_USER)
		{
			event_perform_object(TWEEN_USER_TARGET.object_index, ev_other, ev_user0+_data[0]);
		}
		else
		with(TWEEN_USER_TARGET)
		{
			event_user(_data[0]);
		}
		
		_data = TWEEN_USER_GET; // Repurpose '_data' to avoid var overhead
		TWEEN_USER_GET = 0;
		return _data;
	});

	TPFuncSharedNormal(TPCol, 
	function(_value, _target, _data, _tween)
	{
		TGMX_PROCESS_PROPERTY_MODIFIER(merge_colour(_data[1], _data[2], _value), _target, _data, _tween)
	});

	TPFuncShared(TPPath,
	function(_amount, _target, _path_data, _tween) // SETTER
	{
		var _path, _xstart, _ystart, _xrelative, _yrelative;
		
		if (is_array(_path_data))
		{	
			_path = _path_data[0];
			_xstart = path_get_x(_path, 0);
			_ystart = path_get_y(_path, 0);
		
			if (array_length(_path_data) == 3)
			{
				_xrelative = _path_data[1] - _xstart;
				_yrelative = _path_data[2] - _ystart;
			}
			else
			if (_path_data[1]) // Absolute
			{
				_xrelative = 0;
				_yrelative = 0;
			}
			else
			{
				_xrelative = _target.x - _xstart;
				_yrelative = _target.y - _ystart;
				_path_data[@ 1] = _target.x; // Right... if I don't do this, it'll always use the update x/y position to offset.. which is wrong!
				_path_data[@ 2] = _target.y;
			}
		}
		else
		{
			// ABSOLUTE
			_path = _path_data;
			_xstart = path_get_x(_path, 0);
			_ystart = path_get_y(_path, 0);
			_xrelative = 0;
			_yrelative = 0;
		}
	
		if (_tween[TGMX_T_MODE] == TWEEN_MODE_REPEAT)
		{
			var _xDif = path_get_x(_path, 1) - _xstart;
			var _yDif = path_get_y(_path, 1) - _ystart;
	            
			if (_amount >= 0)
			{   
				_xrelative += _xDif * floor(_amount); 
				_yrelative += _yDif * floor(_amount);
				_amount = _amount % 1;
			}
			else 
			if (_amount < 0)
			{
				_xrelative += _xDif * ceil(_amount-1);
				_yrelative += _yDif * ceil(_amount-1);
				_amount = 1 + _amount % 1;
			}
				
			_target.x = path_get_x(_path, _amount) + _xrelative;
			_target.y = path_get_y(_path, _amount) + _yrelative;
		}
		else
		if (_amount > 0)
		{
			if (path_get_closed(_path) || _amount < 1)
			{
				_target.x = path_get_x(_path, _amount % 1) + _xrelative;
				_target.y = path_get_y(_path, _amount % 1) + _yrelative;
			}
			else
			{
				var _length = path_get_length(_path) * (abs(_amount)-1);
				var _direction = point_direction(path_get_x(_path, 0.999), path_get_y(_path, 0.999), path_get_x(_path, 1), path_get_y(_path, 1));
	                
				_target.x = path_get_x(_path, 1) + _xrelative + lengthdir_x(_length, _direction);
				_target.y = path_get_y(_path, 1) + _yrelative + lengthdir_y(_length, _direction);
			}
		}
		else 
		if (_amount < 0)
		{
			if (path_get_closed(_path))
			{
				_target.x = path_get_x(_path, 1+_amount) + _xrelative;
				_target.y = path_get_y(_path, 1+_amount) + _yrelative;
			}
			else
			{
				var _length = path_get_length(_path) * abs(_amount);
				var _direction = point_direction(_xstart, _ystart, path_get_x(_path, 0.001), path_get_y(_path, 0.001));
	                
				_target.x = _xstart + _xrelative - lengthdir_x(_length, _direction);
				_target.y = _ystart + _yrelative - lengthdir_y(_length, _direction);
			}
		}
		else // _amount == 0
		{
			_target.x = _xstart + _xrelative;
			_target.y = _ystart + _yrelative;
		}
	},
	function(_target, _data, _tween) // GETTER
	{
		return _target.path_position;	
	});
	#endregion


	#region AUTO PROPERTIES ----------------------------------------

	// Default global property setter
	global.TGMX.Variable_Global_Set = function(_value, _null, _variable) 
	{
		return variable_global_set(_variable, _value);
		_null = 0; // Prevent complaint about unused 'null' (_target)
	}


	// Default instance property setter
	global.TGMX.Variable_Instance_Set = function(_value, _target, _variable) 
	{
		_target[$ _variable] = _value;
		
		// ---- FUTURE UPDATE OPTIMISATION ----
		//if (TGMX_SUPPORT_LTS) { _target[$ _variable] = _value; }
		//else				  { struct_set_from_hash(_target, _variable, _value); }
	}

	// This is used for dot . syntax
	global.TGMX.Variable_Dot_Notation_Set = function(_value, _target, _data, _tween) 
	{	
		static str_dollar = "$";

		if (_data[3] == undefined) // SEE IF PROPERTY HAS BEEN DEFINED
		{
			_data[@ 3] = true; // MARK PROPERTY AS DEFINED
			_target = is_struct(_data[0]) ? _data[0].ref : _data[0]; // DON'T USE THE TWEEN'S REAL TARGET

			// METHOD
			if (_target[$ str_dollar+_data[1]] != undefined)
			{
				_data[@ 1] = _target[$ str_dollar+_data[1]];
			}
			else // FUNCTION
			if (ds_map_exists(global.TGMX.PropertySetters, _data[1]))
			{
				_data[@ 1] = global.TGMX.PropertySetters[? _data[1]];
			}
			else // DYNAMIC
			{
				_data[@ 2] = _data[1]; // SWAP 2 TO HOLD VARIABLE NAME
				_data[@ 1] = global.TGMX.Variable_Instance_Set;
			}
		}
		
		if (is_struct(_data[0])) // STRUCT TARGET
		{
			if (weak_ref_alive(_data[0]))
			{
				_data[1](_value, _data[0].ref, _data[2], _tween); 
			}
		}
		else // INSTANCE TARGET
		if (instance_exists(_data[0]))
		{
			_data[1](_value, _data[0], _data[2], _tween); 
		}
	}
	#endregion

}


// NOTE: Do not try to optimise these checks. They need to be checked each time anyway.
// NOTE: Keep this as a function to improve performance!!
/// @ignore
function TGMX_Variable_Get(_target, _variable, _caller, _caller_other) 
{		
	static _ = TGMX_Begin();
	static STR_DOT = ".";
	static STR_SELF = "self";
	static STR_OTHER = "other";
	static STR_GLOBAL = "global";
	static STR_AMPERSAND = "&";
	
	// ADVANCED ARRAY
	if (is_array(_variable))
	{	
		// SCRIPT -- Return
		if (ds_map_exists(global.TGMX.PropertyGetters, _variable[0])) 
		{
			return global.TGMX.PropertyGetters[? _variable[0]](_target, _variable[1]);
		}

		// Get _variable string from advanced _data and keep executing below...
		_variable = _variable[1];
		
		// Get _variable string name from inner array if WE MUST GO DEEPER! Muhahaha (I'm ok)
		// Note: _variable[0] becomes a method after property optmisation, otherwise grab [0] index on initial call
		if (is_array(_variable)) 
		{ 
			_variable = is_method(_variable[0]) ? _variable[3] : _variable[0];
		}
	}
	
	if (_target[$ STR_AMPERSAND+_variable] != undefined)
	{	
		return _target[$ STR_AMPERSAND+_variable](_target, _variable);
	}

	// FUNCTION
	if (ds_map_exists(global.TGMX.PropertyGetters, _variable)) 
	{
		return global.TGMX.PropertyGetters[? _variable](_target);
	}

	// INSTANCE
	if (_target[$ _variable] != undefined)
	{
		return _target[$ _variable];
	}
	
	// CALLER
	if (_caller[$ _variable] != undefined)
	{
		return _caller[$ _variable];
	}
	
	// GLOBAL
	if (variable_global_exists(_variable)) 
	{
		return variable_global_get(_variable);
	}
	
	// NUMBER
	if (string_byte_at(_variable, 1) <= 57) 
	{
		return real(_variable);
	}
	
	// Extended
	// global.thing.sub_thing
	if (string_count(STR_DOT, _variable) >= 2)
	{
		var _dotPos = string_pos(STR_DOT,_variable);
		var _prefix = string_copy(_variable, 1, _dotPos-1);
		
		_variable = string_copy(_variable, _dotPos+1, 100);
		var _postfix = string_copy(_variable, string_pos(STR_DOT, _variable)+1, 100);
		
		// Object _variable
		if (object_exists(asset_get_index(_prefix)))
		{
			_target = asset_get_index(_prefix).id[$ string_copy(_variable, 1, string_pos(STR_DOT, _variable)-1)];
		}
		else
		switch(_prefix)
		{
			case STR_SELF:
				_target = _caller[$ string_copy(_variable, 1, string_pos(STR_DOT, _variable)-1)];
			break;
			
			case STR_GLOBAL:
				_target = variable_global_get(string_copy(_variable, 1, string_pos(STR_DOT, _variable)-1));
			break;
			
			case STR_OTHER:
				_target = _caller_other[$ string_copy(_variable, 1, string_pos(STR_DOT, _variable)-1)];
			break;
		}
		
		// METHOD
		if (_target[$ STR_AMPERSAND+_postfix] != undefined)
		{	
			return _target[$ STR_AMPERSAND+_postfix](_target, _postfix);
		}
		
		// FUNCTION
		if (ds_map_exists(global.TGMX.PropertyGetters, _postfix))
		{
			return global.TGMX.PropertyGetters[? _postfix](_target);
		}
		
		// DYNAMIC
		return _target[$ string_copy(_variable, string_pos(STR_DOT, _variable)+1, 100)];
	}
	
	// EXPRESSION -- Short
	var _prefix = string_copy( _variable, 1, string_pos(STR_DOT, _variable)-1 );
	var _postfix = string_copy(_variable, 1+string_pos(STR_DOT, _variable), 100);
	
	// Object _variable
	if (object_exists(asset_get_index(_prefix)))
	{
		return variable_instance_get(asset_get_index(_prefix).id, _postfix);
	}

	// Caller/Self _variable
	if (_prefix == STR_SELF)
	{	
		// METHOD
		if (_caller[$ STR_AMPERSAND+_postfix] != undefined)
		{	
			return _caller[$ STR_AMPERSAND+_postfix](_caller, _postfix);
		}
		
		// FUNCTION
		if (ds_map_exists(global.TGMX.PropertyGetters, _postfix))
		{
			return global.TGMX.PropertyGetters[? _postfix](_caller);
		}

		// DYNAMIC
		return _caller[$ _postfix];
	}
	
	// Other _variable
	if (_prefix == STR_OTHER)
	{
		// METHOD
		if (_caller_other[$ STR_AMPERSAND+_postfix] != undefined)
		{	
			return _caller_other[$ STR_AMPERSAND+_postfix](_caller_other, _postfix);
		}
		
		// FUNCTION
		if (ds_map_exists(global.TGMX.PropertyGetters, _postfix))
		{
			return global.TGMX.PropertyGetters[? _postfix](_caller_other);
		}
		
		// DYNAMIC
		return _caller_other[$ _postfix];
	}
	
	//
	// I NEED TO ADD OPTIMSED CHECKS HERE!!!
	//
	
	// Global _variable
	if (_prefix == STR_GLOBAL)
	{
		// NOTE: Optimisation check not required here because of Optimisation check above (Teach to use "global.value" with TPFuncShared()
		return variable_global_get(_postfix);
	}
	
	// Target _variable
	if (_target[$ _prefix] != undefined)
	{
		_target = _target[$ _prefix];
		
		// METHOD
		if (_target[$ STR_AMPERSAND+_postfix] != undefined)
		{	
			return _target[$ STR_AMPERSAND+_postfix](_target, _postfix);
		}
		
		// FUNCTION
		if (ds_map_exists(global.TGMX.PropertyGetters, _postfix))
		{
			return global.TGMX.PropertyGetters[? _postfix](_target);
		}
		
		return _target[$ _postfix];
	}

	// Caller _variable
	if (_caller[$ _prefix] != undefined)
	{
		_target = _caller[$ _prefix];
		
		// METHOD
		if (_target[$ STR_AMPERSAND+_postfix] != undefined)
		{	
			return _target[$ STR_AMPERSAND+_postfix](_target, _postfix);
		}
		
		// FUNCTION
		if (ds_map_exists(global.TGMX.PropertyGetters, _postfix))
		{
			return global.TGMX.PropertyGetters[? _postfix](_target);
		}
		
		// DYNAMIC
		return _target[$ _postfix];
	}

	// Global
	_target = variable_global_get(_prefix);
	return _target[$ _postfix];
}








