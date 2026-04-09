// Feather ignore all

// It is safe to delete this script

/*	
	TPTrack() targets the value of an instance or struct as a dynamic destination

	[EXAMPLE]
		
		// Move coin from current position to the player's moving position
		// (Notice that propery start/dest values are 0 and 1)
		TweenFire(o_Gold, "io", 0, true, 0, 1, TPTrack("x", x, obj_Player, "x"),0,1, TPTrack("y", y, obj_Player, "y"),0,1);	
*/


/// @function TPTrack(property, start, track_target, track_variable)
function TPTrack(_property, _start, _track_target, _track_variable)	
{ 
	return [TPTrack, _property, _start, is_struct(_track_target) ? weak_ref_create(_track_target) : _track_target, _track_variable, undefined]; 
}


TPFuncShared(TPTrack, function(_value, _target, _data, _t) 
{	
	/// Feather ignore all
	
	// Cache data execution for better performance -- called only the first time
	if (_data[4] == undefined)
	{
		if (is_array(_data[0]))
		{
			_data[@ 4] = 0;
		}
		else
		if (ds_map_exists(global.TGMX.PropertySetters, _data[0]))
		{
			_data[@ 0] = global.TGMX.PropertySetters[? _data[0]];
			
			if (ds_map_exists(global.TGMX.PropertyGetters, _data[3]))
			{
				_data[@ 4] = 1;
				_data[@ 3] = global.TGMX.PropertyGetters[? _data[3]];
			}
			else // Global Target
			if (is_real(_data[2]) && _data[2] == global)
			{
				_data[@ 4] = 2;
			}
			else // Instance Target
			{	
				_data[@ 4] = 3;
			}
		}
		else
		if (is_struct(_target) && weak_ref_alive(_target))
		{
			_data[@ 4] = 4;
		}
		else
		if (variable_instance_exists(_target, _data[0]))
		{
			_data[@ 4] = 5;
		}
		else
		{
			_data[@ 4] = 6;
		}
	}
	
	// Jump to execution type
	switch(_data[4])
	{
	case 0: // ARRAY
		var _array = _data[0];
		var _length = array_length(_array)-1;
	
		if (_length == 1)
		{	
			_data = _array[1];
		}
		else
		{
			_data = array_create(_length);
			array_copy(_data, 0, _array, 1, _length);
		}
	
		var _script = _array[0];
		_script(_value, _target, _data, _t);
	break;
	case 1: _data[0](lerp(_data[1], _data[3](_data[2]), _value), _target, _data[0], _t);			break; // Built setter with built getter
	case 2: _data[0](lerp(_data[1], variable_global_get(_data[3]), _value), _target, _data[0], _t); break; // Global with built setter
	case 3: _data[0](lerp(_data[1], _data[2][$ _data[3]], _value), _target, _data[0], _t);			break; // Target with built setter and dynamic getter
	case 4: _target.ref[$ _data[0]] = lerp(_data[1], _data[2][$ _data[3]], _value)					break; // Struct Target
	case 5: variable_instance_set(_target, _data[0], lerp(_data[1], _data[2][$ _data[3]], _value)); break; // Instance Target
	case 6: variable_global_set(_data[0], lerp(_data[1], _data[2][$ _data[3]], _value));			break; // Global Target
	}
});




