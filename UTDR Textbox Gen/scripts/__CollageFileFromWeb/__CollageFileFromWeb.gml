/// @ignore
/// feather ignore all
function __CollageFileFromWeb(_fileName) {
    gml_pragma("forceinline");
    return ((os_browser != browser_not_a_browser) || 
	(string_count("http://", _fileName) > 0) ||
	(string_count("https://", _fileName) > 0) || 
	(string_count("www.", _fileName) > 0)
	);
}