
global.soupsignal = {}

///@desc Sends out a signal broadcast for receivers
///@param {string} name_ Signal name
///@param {real, Id.Instance} id_ Signal unique ID
///@param {any} data_ Signal argument data(preferably a struct or array)
function signal_out(name_, id_ = -1, data_ = undefined)
{
	global.soupsignal[$ name_] = true;
	global.soupsignal[$ $"{name_} ID"] = id_;
	global.soupsignal[$ $"{name_} DATA"] = data_;
}

///@desc receives a signal broadcast. If true, will execute a function
///@param {string} name_ Signal name
///@param {real, Id.Instance} id_ Signal unique ID
///@param {function} func_ Function to run if the condition is true
function signal_in(name_, id_ = -1, func_ = function(){})
{
	if ( global.soupsignal[$ name_] && global.soupsignal[$ $"{name_} ID"] = id_ ) { func_(global.soupsignal[$ $"{name_} DATA"]); return true; } else { return false; }
}
