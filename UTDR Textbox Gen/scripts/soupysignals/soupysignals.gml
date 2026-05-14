global.soupsignal = {};
global.soupstore = {}; global.soupstore_global = {};

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
///@param {bool} global_ Whether to make sure this variable global, meaning it will never get cleared
function soup_store(name_, value_ = true, ensure_ = false, global_ = false) { 
	var var_ = global_ ? global.soupstore_global : global.soupstore;
	if ( ensure_ && !is_undefined(var_[$ name_]) ) { var_[$ name_] = value_; } else { var_[$ name_] = value_; } 
}

///@desc Adds onto a previously created soupy variable.
///@param {string} name_ Previously created soup name
///@param {string} key_ New variable to make room for
///@param {any} value_ Data to store in that variable.
///@param {bool} global_ Whether this variable is a global soupy variable
function soup_store_stock(name_, key_, value_ = true, global_ = false) { 
	var var_ = global_ ? global.soupstore_global : global.soupstore;
	with ( var_[$ name_] ) { self[$ key_] = value_;  } 
}

///@desc Retrieves a temp variable in a global struct. Once found, it'll be removed.
///@param {string} name_ Variable name
///@param {bool} remove_ Whether to remove the variable.
///@param {bool} global_ Whether this variable is a global soupy variable
function soup_checkout(name_, remove_ = true, global_ = false) { 
	var var_ = global_ ? global.soupstore_global : global.soupstore;
	var result = var_[$ name_]; if ( remove_ && !is_undefined(var_[$ name_]) ) { struct_remove(var_, name_); } return result; 
}

///@desc Same as soup_checkout, but return the async value.
///@param {string} name_ Variable name
///@param {bool} remove_ Whether to remove the variable.
function soup_checkout_async(name_, remove_ = true) {
	var async_result = async_load;
	if ( async_result[? "id"] == soup_checkout(name_, remove_) ) { return async_result[? "value"]; }	
}

///@desc Checks if the specified variable exists within the soup store.
///@param {string} name_ Variable name
///@param {bool} global_ Whether this variable is a global soupy variable
function soup_store_exists(name_, global_ = false) { 
	var var_ = global_ ? global.soupstore_global : global.soupstore;
	return !is_undefined(var_[$ name_]); 
}

///@desc Checks if the specified variable exists within the soup store, otherwise return a default value
///@param {string} name_ Variable name
///@param {any} default_ Default value to provide if this doesn't exist
///@param {bool} global_ Whether this variable is a global soupy variable
function soup_store_ensure(name_, default_ = false, global_ = false) { 
	var var_ = global_ ? global.soupstore_global : global.soupstore;
	return !is_undefined(var_[$ name_]) ? var_[$ name_] : default_; 
}

///@desc Clear the soup store of any variables.
function soup_store_clear() { delete global.soupstore; global.soupstore = {}; }