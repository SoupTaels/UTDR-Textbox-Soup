///@desc A Tween object that handles animating a single property of an element.
///@arg {Struct.LuiBase} target_element The element to animate.
///@arg {String} property The name of the property to animate (e.g., "slider_x", "alpha").
///@arg {Real} end_value The target value of the property.
///@arg {Real} duration The duration of the animation in seconds.
function LuiTween(target_element, property, end_value, duration, easing_func) constructor {
	self.target = target_element;
	self.property = property;
	self.start_value = target_element[$ property];
	self.end_value = end_value;
	self.duration = max(0.01, duration);
	self.easing_func = easing_func;
	self.elapsed_time = 0;
	self.is_finished = false;

	///@desc Updates the animation state. Returns true if still running.
	static update = function(delta_time) {
		// Increment time
		self.elapsed_time += delta_time;
		
		// Calcultate porgress
		var _raw_progress = clamp(self.elapsed_time / self.duration, 0, 1);
		
		// Calcultate easing porgress
		var _eased_progress = self.easing_func(_raw_progress);
		
		// Calculate new value with easing
		var _new_value = lerp(self.start_value, self.end_value, _eased_progress);
		
		// Apply new value to variable
		self.target[$ self.property] = _new_value;
		
		// Check if end
		if (_raw_progress >= 1) {
			self.target[$ self.property] = self.end_value; 
			self.is_finished = true;
			return false; // Animation ended
		}
		
		return true; // Continue animation
    }
}

// Ease functions from easings.net
///@ignore
function _luiInitEaseFunctions() {
	global.Ease = {
		InSine: function(p) {
			return 1 - cos((p * pi) / 2);
		},
		OutSine: function(p) {
			return sin((p * pi) / 2);
		},
		InOutSine: function(p) {
			return -(cos(pi * p) - 1) / 2;
		},
		InQuad: function(p) {
			return p * p;
		},
		OutQuad: function(p) {
			return 1 - (1 - p) * (1 - p);
		},
		InOutQuad: function(p) {
			return p < 0.5 ? (2 * p * p) : (1 - power(-2 * p + 2, 2) / 2);
		},
		InCubic: function(p) {
			return p * p * p;
		},
		OutCubic: function(p) {
			return 1 - power(1 - p, 3);
		},
		InOutCubic: function(p) {
			return p < 0.5 ? (4 * p * p * p) : (1 - power(-2 * p + 2, 3) / 2);
		},
		InQuart: function(p) {
			return p * p * p * p;
		},
		OutQuart: function(p) {
			return 1 - power(1 - p, 4);
		},
		InOutQuart: function(p) {
			return p < 0.5 ? (8 * p * p * p * p) : (1 - power(-2 * p + 2, 4) / 2);
		},
		InQuint: function(p) {
			return p * p * p * p * p;
		},
		OutQuint: function(p) {
			return 1 - power(1 - p, 5);
		},
		InOutQuint: function(p) {
			return p < 0.5 ? (16 * p * p * p * p * p) : (1 - power(-2 * p + 2, 5) / 2);
		},
		InExpo: function(p) {
			return p == 0 ? 0 : power(2, 10 * p - 10);
		},
		OutExpo: function(p) {
			return p == 1 ? 1 : 1 - power(2, -10 * p);
		},
		InOutExpo: function(p) {
			return (p == 0) ? 0 : ((p == 1) ? 1 : (p < 0.5 ? power(2, 20 * p - 10) / 2 : (2 - power(2, -20 * p + 10)) / 2));
		},
		InCirc: function(p) {
			return 1 - sqrt(1 - power(p, 2));
		},
		OutCirc: function(p) {
			return sqrt(1 - power(p - 1, 2));
		},
		InOutCirc: function(p) {
			return p < 0.5 ? (1 - sqrt(1 - power(2 * p, 2))) / 2 : (sqrt(1 - power(-2 * p + 2, 2)) + 1) / 2;
		},
		InBack: function(p) {
			var c1 = 1.70158;
			var c3 = c1 + 1;
			return c3 * p * p * p - c1 * p * p;
		},
		OutBack: function(p) {
			var c1 = 1.70158;
			var c3 = c1 + 1;
			return 1 + c3 * power(p - 1, 3) + c1 * power(p - 1, 2);
		},
		InOutBack: function(p) {
			var c1 = 1.70158;
			var c2 = c1 * 1.525;
			return p < 0.5 ? (power(2 * p, 2) * ((c2 + 1) * 2 * p - c2)) / 2 : (power(2 * p - 2, 2) * ((c2 + 1) * (p * 2 - 2) + c2) + 2) / 2;
		},
		InElastic: function(p) {
			var c4 = (2 * pi) / 3;
			return (p == 0) ? 0 : ((p == 1) ? 1 : -power(2, 10 * p - 10) * sin((p * 10 - 10.75) * c4));
		},
		OutElastic: function(p) {
			var c4 = (2 * pi) / 3;
			return (p == 0) ? 0 : ((p == 1) ? 1 : power(2, -10 * p) * sin((p * 10 - 0.75) * c4) + 1);
		},
		InOutElastic: function(p) {
			var c5 = (2 * pi) / 4.5;
			return (p == 0) ? 0 : ((p == 1) ? 1 : (p < 0.5 ? -(power(2, 20 * p - 10) * sin((20 * p - 11.125) * c5)) / 2 : (power(2, -20 * p + 10) * sin((20 * p - 11.125) * c5)) / 2 + 1));
		},
		OutBounce: function(p) {
			var n1 = 7.5625;
			var d1 = 2.75;
			if (p < 1 / d1) {
				return n1 * p * p;
			} else if (p < 2 / d1) {
				var _p = p - (1.5 / d1);
				return n1 * _p * _p + 0.75;
			} else if (p < 2.5 / d1) {
				var _p = p - (2.25 / d1);
				return n1 * _p * _p + 0.9375;
			} else {
				var _p = p - (2.625 / d1);
				return n1 * _p * _p + 0.984375;
			}
		},
		InBounce: function(p) {
			return 1 - self.OutBounce(1 - p);
		},
		InOutBounce: function(p) {
			return p < 0.5 ? (1 - self.OutBounce(1 - 2 * p)) / 2 : (1 + self.OutBounce(2 * p - 1)) / 2;
		}
	};
}