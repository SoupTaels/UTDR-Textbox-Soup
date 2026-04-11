/// @function CollageIsPowerTwo(number)
/// @param {Real} number
/// feather ignore all
function CollageIsPowerTwo(_num) {
	gml_pragma("forceinline");
    return (_num & (_num - 1)) == 0;
}
