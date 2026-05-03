global.soupsignal = {}
global.soupstore = {}

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

///@desc Stores a new temp variable in a global struct.
///@param {string} name_ Variable name
///@param {any} value_ Data to store in that variable.
///@param {bool} ensure_ Whether to make sure this variable doesn't already exist
function soup_store(name_, value_, ensure_ = false) { if ( ensure_ && !is_undefined(global.soupstore[$ name_]) ) { global.soupstore[$ name_] = value_; } else { global.soupstore[$ name_] = value_; } }

///@desc Adds onto a previously created soupy variable.
///@param {string} name_ Previously created soup name
///@param {string} key_ New variable to make room for
///@param {any} value_ Data to store in that variable.
function soup_store_stock(name_, key_, value_) { with ( global.soupstore[$ name_] ) { self[$ key_] = value_;  } }

///@desc Retrieves a temp variable in a global struct. Once found, it'll be removed.
///@param {string} name_ Variable name
///@param {bool} remove_ Whether to remove the variable.
function soup_checkout(name_, remove_ = true) { var result = global.soupstore[$ name_]; if ( remove_ && !is_undefined(global.soupstore[$ name_]) ) { struct_remove(global.soupstore, name_); } return result; }

///@desc Same as soup_checkout, but return the async value.
///@param {string} name_ Variable name
function soup_checkout_async(name_) {
	var async_result = async_load;
	if ( async_result[? "id"] == soup_checkout(name_) ) { return async_result[? "value"]; }	
}

///@desc Clear the soup store of any variables.
function soup_store_clear() { delete global.soupstore; global.soupstore = {}; }