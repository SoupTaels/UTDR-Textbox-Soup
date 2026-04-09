// Feather ignore all

// Ease				-- safe to delete
// EaseToString		-- required
// EaseToCurve		-- required

var _; // USED TO HIDE SYNTAX WARNINGS WHEN FEATHER DISABLED

/// @function Ease( value1, value2, amount, ease )
/// @description Interpolates two values by a given amount using specified ease algorithm
/// @param {Any} value1		start value
/// @param {Any} value2		end value
/// @param {Any} amount		(0-1) amount to interpolate values
/// @param {Any} ease		ease algorithm function, string, or curve
function Ease(_value1, _value2, _amount, _ease) 
{	
	/*
		Example:
		    x = Ease(x, mouse_x, 0.5, EaseInOutQuad);
	*/

	// MAKE SURE SHARED TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = SharedTweener();
	static __EaseTypes__ = {number: 0, method: 1, ref: 2}
	
	if (is_string(_ease))
	{
		_ease = global.TGMX.ShortCodesEase[? global.TGMX.Cache[? _ease] ?? TGMX_StringStrip(_ease)];
	}
	
	switch(__EaseTypes__[$ typeof(_ease)])
	{
	case 0: // NUMBER
		return _ease >= 100000 ? script_execute(_ease, _amount, _value1, _value2-_value1, 1) // Function ID
		: _value1+(_value2-_value1)*animcurve_channel_evaluate(animcurve_get_channel(_ease, 0), _amount); // Animation Curve ID
	case 1: // METHOD
		return _ease(_amount, _value1, _value2-_value1, 1);
	case 2: // REF
		return (real(_ease) >= 100000) ? script_execute(_ease, _amount, _value1, _value2-_value1, 1) // Function ID
		: _value1+(_value2-_value1)*animcurve_channel_evaluate(animcurve_get_channel(_ease, 0), _amount); // Animation Curve ID
	default: // Assume Animation Curve Channel
		return _value1+(_value2-_value1)*animcurve_channel_evaluate(_ease, _amount);
	}
}_=Ease;


/// @function EaseToString( name, ease|curve|channel, [channel] )
/// @description Assigns usable "string" name to a ease function or animation curve
/// @param {Any} name		name to associate with ease type
/// @param {Any} ease		ease function/method, curve id, or curve channel
/// @param {Any} [channel]	optional curve channel (if curve is used)
function EaseToString(_name, _ease, _channel=0)
{		
	static _ = TGMX_Begin();
	static __EaseTypes__ = {number: 0, struct: 1, ref: 2}
	
	switch(__EaseTypes__[$ typeof(_ease)])
	{
		case 0: // NUMBER
			if (_ease >= 100000) // SCRIPT ID
			{
				_ease = method(undefined, _ease);
			}
			else // ANIMCURVE ID
			{
				var _curve = animcurve_get(_ease);
				var _assetName = TGMX_StringStrip(_curve.name);
				_channel = animcurve_get_channel(_curve, _channel);
				_channel.name = _assetName;
				_ease = _channel;
				global.TGMX.ShortCodesEase[? _assetName] = _ease;
			}
		break;
		
		case 1: // STRUCT
			_ease = animcurve_get_channel(animcurve_get(_ease), _channel);
		break;
		
		case 2: // REF
			//_ease = animcurve_get_channel(animcurve_get(_ease), _channel);
			// TODO: NEW 107 -- MIGHT NEED TO DO THE SAME AS ABOVE IN NUMBER FOR ANIM CURVE ASSET TYPES (FOR NON-LTS)
			var _curve = animcurve_get(_ease);
			var _assetName = TGMX_StringStrip(_curve.name);
			_channel = animcurve_get_channel(_curve, _channel);
			_channel.name = _assetName;
			_ease = _channel;
			global.TGMX.ShortCodesEase[? _assetName] = _ease;
		break;
	}
	
	_name = TGMX_StringStrip(_name);
	global.TGMX.ShortCodesEase[? _name] = _ease;
	global.TGMX.ShortCodesEase[? "~"+_name] = _ease;
} 

/// @ignore
/// @function EaseToCurve( ease, [num_points], [force] )
/// @param ease
/// @param num_points
/// @param force
function EaseToCurve(_ease, _num_points=120, _force=false)
{		
	// JS is faster not using animation curves in many cases... so exit early with a method instead
	if (os_browser != browser_not_a_browser && _force == false) // IF WEB BROWSER AND NOT FORCED
	{	
		return method(undefined, _ease);
	}

	var _points = array_create(_num_points+1);
	var i = -1;
	repeat(_num_points+1)
	{
		var _time = ++i/_num_points;
		_points[i] = animcurve_point_new();
		_points[i].posx = _time;
		_points[i].value = _ease(_time, 0, 1, 1);
	}

	var _channel = animcurve_channel_new();
	_channel.type = animcurvetype_linear;
	_channel.iterations = 1;
	_channel.points = _points;
	
	return _channel;
}


//=============================
// PENNER'S EASING ALGORITHMS
//=============================
/*
	Terms of Use: Easing Functions (Equations)
	Open source under the MIT License and the 3-Clause BSD License.

	MIT License
	Copyright © 2001 Robert Penner

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	BSD License
	Copyright © 2001 Robert Penner

	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


// LINEAR

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseLinear(_time, _start, _change, _duration)
{		
	return _change * _time / _duration + _start;
}


// QUAD

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInQuad(_time, _start, _change, _duration)
{		
	return _change * _time/_duration * _time/_duration + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutQuad(_time, _start, _change, _duration)
{	
	return -_change * _time/_duration * (_time/_duration-2) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutQuad(_time, _start, _change, _duration)
{
	_time = 2*_time/_duration;
	return _time < 1 ? _change * 0.5 * _time * _time + _start
					 : _change * -0.5 * ((_time-1) * (_time - 3) - 1) + _start;
}


// CUBIC

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInCubic(_time, _start, _change, _duration)
{
	return _change * power(_time/_duration, 3) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutCubic(_time, _start, _change, _duration)
{
	return _change * (power(_time/_duration - 1, 3) + 1) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutCubic(_time, _start, _change, _duration)
{
	_time = 2 * _time / _duration;
	return _time < 1 ? _change * 0.5 * power(_time, 3) + _start
					 : _change * 0.5 * (power(_time-2, 3) + 2) + _start;
}


// QUART

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInQuart(_time, _start, _change, _duration)
{
	return _change * power(_time/_duration, 4) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutQuart(_time, _start, _change, _duration)
{
	//return -_change * (power(_time/_duration - 1, 4) - 1) + _start; // THIS BREAKS ANDROID YYC!
	return _change * -(power(_time/_duration - 1, 4) - 1) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutQuart(_time, _start, _change, _duration)
{
	_time = 2*_time/_duration;
	return _time < 1 ? _change * 0.5 * power(_time, 4) + _start
					 : _change * -0.5 * (power(_time - 2, 4) - 2) + _start;
}


// QUINT

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInQuint(_time, _start, _change, _duration)
{
	return _change * power(_time/_duration, 5) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutQuint(_time, _start, _change, _duration)
{
	return _change * (power(_time/_duration - 1, 5) + 1) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutQuint(_time, _start, _change, _duration)
{
	_time = 2*_time/_duration;
	return _time < 1 ? _change * 0.5 * power(_time, 5) + _start
					 : _change * 0.5 * (power(_time - 2, 5) + 2) + _start;
}


// SINE

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInSine(_time, _start, _change, _duration)
{
	return _change * (1 - cos(_time/_duration * (pi/2))) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutSine(_time, _start, _change, _duration)
{
	return _change * sin(_time/_duration * (pi/2)) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutSine(_time, _start, _change, _duration)
{
	return _change * 0.5 * (1 - cos(pi*_time/_duration)) + _start;
}


// CIRC

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInCirc(_time, _start, _change, _duration)
{
	return _change * (1 - sqrt(1 - _time/_duration * _time/_duration)) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutCirc(_time, _start, _change, _duration)
{
	_time = _time/_duration - 1;
	return _change * sqrt(abs(1 - _time * _time)) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutCirc(_time, _start, _change, _duration)
{
	_time = 2*_time/_duration;
	return _time < 1 ? _change * 0.5 * (1 - sqrt(abs(1 - _time * _time))) + _start
					 : _change * 0.5 * (sqrt(abs(1 - (_time-2) * (_time-2))) + 1) + _start;
}


// EXPO

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInExpo(_time, _start, _change, _duration)
{
	return (_time == 0) ? _start : _change * power(2, 10 * (_time/_duration - 1)) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutExpo(_time, _start, _change, _duration)
{
	return (_time == _duration) ? _start + _change : _change * (-power(2, -10 * _time / _duration) + 1) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutExpo(_time, _start, _change, _duration)
{
	if (_time == 0) { return _start; }
	if (_time == _duration) { return _start + _change; }
	
	_time = 2 * _time / _duration;
	return (_time < 1) ? _change * 0.5 * power(2, 10 * (_time-1)) + _start : _change * 0.5 * (-power(2, -10 * (_time-1)) + 2) + _start;
}
	
	
// BACK

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInBack(_time, _start, _change, _duration)
{
	_time /= _duration;
	_duration = 1.70158; // repurpose _duration as Robert Penner's "s" value -- You can hardcode this into wherever you see '_duration' in the next line
	return _change * _time * _time * ((_duration + 1) * _time - _duration) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutBack(_time, _start, _change, _duration)
{
	_time = _time/_duration - 1;
	_duration = 1.70158; // "s"
	return _change * (_time * _time * ((_duration + 1) * _time + _duration) + 1) + _start;
}	

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutBack(_time, _start, _change, _duration)
{
	_time = _time/_duration*2;
	_duration = 1.70158; // "s"

	if (_time < 1)
	{
	    _duration *= 1.525;
	    return _change * 0.5 * (((_duration + 1) * _time - _duration) * _time * _time) + _start;
	}

	_time -= 2;
	_duration *= 1.525;

	return _change * 0.5 * (((_duration + 1) * _time + _duration) * _time * _time + 2) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInBackSoft(_time, _start, _change, _duration)
{
	_time /= _duration;
	_duration = 0.7; // repurpose _duration as Robert Penner's "s" value -- You can hardcode this into wherever you see '_duration' in the next line
	return _change * _time * _time * ((_duration + 1) * _time - _duration) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInBackSofter(_time, _start, _change, _duration)
{
	_time /= _duration;
	_duration = 0.3; // repurpose _duration as Robert Penner's "s" value -- You can hardcode this into wherever you see '_duration' in the next line
	return _change * _time * _time * ((_duration + 1) * _time - _duration) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutBackSoft(_time, _start, _change, _duration)
{
    _time = _time/_duration - 1;
    _duration = 0.7; // "s"
    
    return _change * (_time * _time * ((_duration + 1) * _time + _duration) + 1) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutBackSofter(_time, _start, _change, _duration)
{
    _time = _time/_duration - 1;
    _duration = 0.3; // "s"
    
    return _change * (_time * _time * ((_duration + 1) * _time + _duration) + 1) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutBackSoft(_time, _start, _change, _duration)
{
	_time = _time/_duration*2;
	_duration = 0.7; // "s"

	if (_time < 1)
	{
	    _duration *= 1.525;
	    return _change * 0.5 * (((_duration + 1) * _time - _duration) * _time * _time) + _start;
	}

	_time -= 2;
	_duration *= 1.525;

	return _change * 0.5 * (((_duration + 1) * _time + _duration) * _time * _time + 2) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutBackSofter(_time, _start, _change, _duration)
{
	_time = _time/_duration*2;
	_duration = 0.3; // "s"

	if (_time < 1)
	{
	    _duration *= 1.525;
	    return _change * 0.5 * (((_duration + 1) * _time - _duration) * _time * _time) + _start;
	}

	_time -= 2;
	_duration *= 1.525;

	return _change * 0.5 * (((_duration + 1) * _time + _duration) * _time * _time + 2) + _start;
}


// BOUNCE

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInBounce(_time, _start, _change, _duration)
{	
	return _change - EaseOutBounce(_duration - _time, 0, _change, _duration) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutBounce(_time, _start, _change, _duration)
{
	_time /= _duration;

	if (_time < 1/2.75)
	{
	    return _change * 7.5625 * _time * _time + _start;
	}
	else
	if (_time < 2/2.75)
	{
	    _time -= 1.5/2.75;
	    return _change * (7.5625 * _time * _time + 0.75) + _start;
	}
	else
	if (_time < 2.5/2.75)
	{
	    _time -= 2.25/2.75;
	    return _change * (7.5625 * _time * _time + 0.9375) + _start;
	}
	else
	{
	    _time -= 2.625/2.75;
	    return _change * (7.5625 * _time * _time + 0.984375) + _start;
	}
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutBounce(_time, _start, _change, _duration)
{
	return _time < _duration*0.5 ? EaseInBounce(_time*2, 0, _change, _duration)*0.5 + _start
							     : EaseOutBounce(_time*2 - _duration, 0, _change, _duration)*0.5 + _change*0.5 + _start;
}
	
	
// ELASTIC

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInElastic(_time, _start, _change, _duration)
{
	var _s = 1.70158;
	var _p = _duration*0.3;
	var _a = _change;
	var _val = _time;
	
	if (_val == 0 || _a == 0) { return _start; }

	_val /= _duration;

	if (_val == 1) { return _start+_change; }

	if (_a < abs(_change)) 
	{ 
	    _a = _change; // lol, wut?
	    _s = _p*0.25; 
	}
	else
	{
	    _s = _p / (2*pi) * arcsin(_change/_a);
	}

	return -(_a * power(2,10 * (_val-1)) * sin(((_val-1) * _duration - _s) * (2*pi) / _p)) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutElastic(_time, _start, _change, _duration)
{
	var _s = 1.70158;
	var _p = _duration * 0.3;
	var _a = _change;
	var _val = _time;

	if (_val == 0 || _a == 0) { return _start; }

	_val /= _duration;

	if (_val == 1) { return _start + _change; }

	if (_a < abs(_change)) 
	{ 
	    _a = _change; // lol, wut?
	    _s = _p * 0.25; 
	}
	else
	{
	    _s = _p / (2*pi) * arcsin (_change/_a);
	}

	return _a * power(2, -10 * _val) * sin((_val * _duration - _s) * (2*pi) / _p ) + _change + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutElastic(_time, _start, _change, _duration)
{
	var _s = 1.70158;
	var _p = _duration * (0.3 * 1.5);
	var _a = _change;
	var _val = _time;

	if (_val == 0 || _a == 0) { return _start; }

	_val /= _duration*0.5;

	if (_val == 2) { return _start+_change; }

	if (_a < abs(_change)) 
	{ 
	    _a = _change;
	    _s = _p * 0.25;
	}
	else
	{
	    _s = _p / (2*pi) * arcsin (_change / _a);
	}

	if (_val < 1) { return -0.5 * (_a * power(2, 10 * (_val-1)) * sin(((_val-1) * _duration - _s) * (2*pi) / _p)) + _start; }

	return _a * power(2, -10 * (_val-1)) * sin(((_val-1) * _duration - _s) * (2*pi) / _p) * 0.5 + _change + _start;
}

/// @ignore
function TGMX_2_EaseFunctions()
{
	// MAKE SURE SYSTEM IS INTITIALIZED
	static _ = TGMX_Begin();
	
	// MAKE SURE THIS ONLY FIRES ONCE
	static __initialized = false;
	if (__initialized) { return 0; }
	__initialized = true;
	
	//======================
	// EASING "SHORT CODES"
	//======================
	//Convert Stringed Ease Functions to use Curves ** improves performance for most platforms -- HTML5 will still use the raw function calls **

	global.TGMX.ShortCodesEase = ds_map_create();

	// Help automate shortcode creation
	/// @func f(ease, name, [...])
	var f = function(_ease)
	{ 
		if (!is_struct(_ease))
		{
			_ease = method(undefined, _ease);
		}
		
		var map = global.TGMX.ShortCodesEase;
		var i = 0;
		repeat(argument_count-1)
		{
			var _str = argument[++i];
			map[? _str] = _ease;
			map[? "~"+_str] = _ease;
		}
		
		// NEW 107
		if (is_struct(_ease))
		{
			_ease.name = argument[argument_count-1];	
		}
	}

	// Linear
	var _ease = EaseToCurve(EaseLinear, 1);
	global.TGMX.ShortCodesEase[? ""] = _ease;
	f(_ease, "linear");

	// Sine -- Default
	f(EaseToCurve(EaseInSine), "i", "in", "isine", "insine");
	f(EaseToCurve(EaseOutSine), "o", "out", "osine", "outsine");
	f(EaseToCurve(EaseInOutSine), "sine", "io", "inout", "iosine", "inoutsine");

	// Quad
	f(EaseToCurve(EaseInQuad), "iquad", "inquad");
	f(EaseToCurve(EaseOutQuad), "oquad", "outquad");
	f(EaseToCurve(EaseInOutQuad), "quad", "ioquad", "inoutquad");

	// Cubic
	f(EaseToCurve(EaseInCubic), "icubic", "incubic");
	f(EaseToCurve(EaseOutCubic), "ocubic", "outcubic");
	f(EaseToCurve(EaseInOutCubic), "cubic", "iocubic", "inoutcubic");

	// Quart
	f(EaseToCurve(EaseInQuart), "iquart", "inquart");	
	f(EaseToCurve(EaseOutQuart), "oquart", "outquart");
	f(EaseToCurve(EaseInOutQuart), "quart", "ioquart", "inoutquart");
	
	// Quint
	f(EaseToCurve(EaseInQuint), "iquint", "inquint");
	f(EaseToCurve(EaseOutQuint), "oquint", "outquint");
	f(EaseToCurve(EaseInOutQuint), "quint", "ioquint", "inoutquint");

	// Circ
	f(EaseToCurve(EaseInCirc), "icirc", "incirc");
	f(EaseToCurve(EaseOutCirc), "ocirc", "outcirc");
	f(EaseToCurve(EaseInOutCirc), "circ", "iocirc", "inoutcirc");

	// Expo
	f(EaseToCurve(EaseInExpo), "iexpo", "inexpo");
	f(EaseToCurve(EaseOutExpo), "oexpo", "outexpo");
	f(EaseToCurve(EaseInOutExpo), "expo", "ioexpo", "inoutexpo");

	// Back
	f(EaseToCurve(EaseInBack), "iback", "inback");
	f(EaseToCurve(EaseOutBack), "oback", "outback");
	f(EaseToCurve(EaseInOutBack), "back", "ioback", "inoutback");
	
	// Soft
	f(EaseToCurve(EaseInBackSoft), "ibacksoft", "inbacksoft");
	f(EaseToCurve(EaseOutBackSoft), "obacksoft", "outbacksoft");
	f(EaseToCurve(EaseInOutBackSoft), "backsoft", "iobacksoft", "inoutbacksoft");
	
	// Softer
	f(EaseToCurve(EaseInBackSofter), "ibacksofter", "inbacksofter");
	f(EaseToCurve(EaseOutBackSofter), "obacksofter", "outbacksofter");
	f(EaseToCurve(EaseInOutBackSofter), "backsofter", "iobacksofter", "inoutbacksofter");

	// Bounce
	f(EaseToCurve(EaseInBounce), "ibounce", "inbounce");
	f(EaseToCurve(EaseOutBounce), "obounce", "outbounce");
	f(EaseToCurve(EaseInOutBounce), "bounce", "iobounce", "inoutbounce");

	// Elastic
	f(EaseToCurve(EaseInElastic, undefined, true), "ielastic", "inelastic");
	f(EaseToCurve(EaseOutElastic, undefined, true), "oelastic", "outelastic");
	f(EaseToCurve(EaseInOutElastic, undefined, true), "elastic", "ioelastic", "inoutelastic");
	
	// Fast To Slow
	if (asset_get_index("EaseFastToSlow") != -1)
	{
		EaseToString("fasttoslow", EaseFastToSlow);
		EaseToString("fastslow", EaseFastToSlow);
	}

	// Mid Slow
	if (asset_get_index("EaseMidSlow") != -1)
	{
		EaseToString("midslow", EaseMidSlow);
	}
	
	// Heartbeat
	if (asset_get_index("EaseHeartbeat") != -1)
	{
		EaseToString("heartbeat", EaseHeartbeat);
		EaseToString("heart", EaseHeartbeat);
	}
}













