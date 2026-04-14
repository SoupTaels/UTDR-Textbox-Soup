/// @func instance_single(obj)
/// @desc Retrieves an instance of an object and ensures it's the only one.
/// @param {Asset.GMObject} obj
/// @returns {Id.Instance}
function instance_single(obj) {
    var count = instance_number(obj);
    if (count != 1)
        throw "Exactly one instance of " + object_get_name(obj) + " expected, " + string(count) + " found.";
    
    return obj.id;
}
