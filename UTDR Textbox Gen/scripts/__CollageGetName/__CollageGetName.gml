/// @ignore
/// feather ignore all
function __CollageGetName(_string) {
	gml_pragma("forceinline");
	if (__CollageFileFromWeb(_string)) {
		var _stringStartPos = string_last_pos("/", _string)+1;
		var _stringEndPos = string_last_pos(".", _string);
		return string_copy(_string, _stringStartPos, _stringEndPos-_stringStartPos);
	} 
	
	var _pathDivider = "\\";
	
	if (string_count(_pathDivider, _string) == 0) {
		_pathDivider = "/";	
	}
	
	var _stringStartPos = string_last_pos(_pathDivider, _string)+1;
	var _stringEndPos = string_last_pos(".", _string);
	return string_copy(_string, _stringStartPos, _stringEndPos-_stringStartPos);
}