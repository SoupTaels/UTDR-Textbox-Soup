/// @func not_implemented_exception
/// @desc Creates an exception message for a struct not implementing a given method.
/// @param {String} method_name
/// @returns {String}
function not_implemented_exception(method_name) {
    return "Method " + method_name + " was not implemented for " + instanceof(self) + ".";
}
