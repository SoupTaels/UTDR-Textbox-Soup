/// @ignore
/// feather ignore all
function __CollageExtractTiling(_tiling) {
	gml_pragma("forceinline");
	return [_tiling >> 8, _tiling & 0x1];
}