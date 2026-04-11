/// @function CollageConvertPowerTwo(number)
/// @param {Real} number
/// feather ignore all
function CollageConvertPowerTwo(_num) {
	gml_pragma("forceinline");
	return power(2,round(log2(_num)));	
}
