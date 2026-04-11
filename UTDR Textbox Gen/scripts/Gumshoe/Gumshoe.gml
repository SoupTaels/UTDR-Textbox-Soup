/*
More info for nerds that care:
Back in MS-DOS days all filesystem entries had to follow the 8+3 formula
(name + extension)
And when you made a folder, it's extension part would be an empty string.
The *.* wildcard matched all directories as well since well, it has an extension, it's empty, * matches an empty string.

Then when Microsoft released Win9x it introduced LFN (Long File Names)
This allowed you to use almost any names not longer than 255 chars.
(and also did extensions properly)
But this kinda broke backwards compatibility, since the extension was not a mandatory part of the name.
Sooo Microsoft just made *.* match all dirs as well as an edge case.

Since Linux never cared about any backwards compatibility whatsoever, *.* does not in fact match everything
It does not have that extension edge case, if you really want to match everything, use *.

Same applies for Android and non-Microsoft game consoles.

That's pretty much it.
*/

/*
Regarding the optional forceLCNames argument:
On non-Microsoft platforms the file system is case sensitive,
when exporting included files on Linux/Android/macOS, GameMaker will force all file/dir names to lower case.
If you are sure that you're only going to look in included files/savedata, better leave this at `true`. (less hassle for you)
But if you want to search in the whole file system as well, you may wish to set it to `false`.
(and please handle the case sensitivity yourself!)
On Microsoft platforms this flag does nothing as the file system is not case sensitive.
*/

/// @param directory
/// @param fileExtension
/// @param returnStruct
/// @param [forceLCNames] Force lowercase names on non-MSFT platforms, see comment(s) above for an explanation.
/// @param [structValueGenerator] when returnStruct = true, function that generates the value for the file (params: directiory, file, extension, index)
/// @param [forceForwardSlash] force all paths to use / as path separator regardless of platform
function gumshoe(_directory, _extension, _return_struct = false, _force_lcnames = true, _generator = undefined, _force_forward_slash = undefined)
{
    //Microsoft platforms handle wildcards and patterns slightly different than others (Linux or web based).
    static _is_microsoft =
    (
        os_type == os_windows || os_type == os_xboxseriesxs || os_type == os_gdk
    );
    //Path separator used on the target platform
    static _path_separator         = _is_microsoft? "\\"  :  "/";
    //Path separator inverse to what is used on the target platform
    static _inverse_path_separator = _is_microsoft? "/"   : "\\";
    //Due to MS-DOS roots, Windows and Linux have a slightly different understanding of what to consider a match-all wildcard mask.
    //(see comments above for more ramblings)
    static _match_all_mask         = _is_microsoft? "*.*" :  "*";
    
    if (_return_struct == false && _generator != undefined) {
        throw "Gumshoe: structValueGenerator can only be specified when returning a struct";
    }
    
    //The JS export does not support file search at all.
    if (os_browser != browser_not_a_browser)
    {
        throw "Gumshoe: File search is not supported in the JS export module.";
    }
	
	// path separator to use for this call (in case _force_forward_slash is true)
	var _path_sep = _path_separator;
	
	if (_force_forward_slash) {
		 _directory = string_replace_all(_directory, "\\", "/");
		 _path_sep = "/";
	}
	else {
        //Clean up weirdo directory formats that people might use
		_directory = string_replace_all(_directory, _inverse_path_separator, _path_separator);
	}
	
    if ((_directory != "") && (string_char_at(_directory, string_length(_directory)) != _path_sep))
    {
        _directory += _path_sep;
    }
    
    //Clean up the extension too
    var _pos = string_pos(".", _extension);
    if (_pos > 0) _extension = string_delete(_extension, 1, _pos);
    _extension = "." + _extension;
    
    //Force everything to lower case if on a non-Microsoft platform and an optional argument is specified.
    if (!_is_microsoft && _force_lcnames)
    {
        _directory = string_lower(_directory);
        _extension = string_lower(_extension);
    }
    
    //Execute the inner function that we want
    if (_return_struct)
    {
        global.__gumshoe_count = 0;
        return __gumshoe_struct(_directory, _extension, _match_all_mask, _path_sep, _generator);
    }
    else
    {
        return __gumshoe_array(_directory, _extension, [], _match_all_mask, _path_sep);
    }
}

/// @param directory
/// @param fileExtension
/// @param resultArray
/// @param matchAllMask
/// @param pathSeparator
function __gumshoe_array(_directory, _extension, _result, _match_all_mask, _path_sep)
{
    var _directories = [];
    
    //Search through this directory
    var _file = undefined;
    while(true)
    {
        //On Linux the attribute argument is ignored, and everything that we can read is returned (even directories with a proper pattern).
        //This doesn't affect this library in particular but good to keep that in mind.
        _file = (_file == undefined)? file_find_first(_directory + _match_all_mask, fa_directory) : file_find_next();
        if (_file == "") break;
        
        if (directory_exists(_directory + _file))
        {
            //Process this directory
            _directories[@ array_length(_directories)] = _directory + _file + _path_sep;
        }
        else if ((_extension == ".*") || (filename_ext(_file) == _extension))
        {
            //Add this matching file to the output array
            _result[@ array_length(_result)] = _directory + _file;
        }
    }
    
    file_find_close();
    
    //Now handle the directories
    var _i = 0;
    repeat(array_length(_directories))
    {
        __gumshoe_array(_directories[_i], _extension, _result, _match_all_mask, _path_sep);
        ++_i;
    }
    
    return _result;
}

/// @param directory
/// @param fileExtension
/// @param matchAllMask
/// @param pathSeparator
/// @param structValueGenerator
function __gumshoe_struct(_directory, _extension, _match_all_mask, _path_sep, _generator)
{
    var _directories = [];
    var _result = {};
    
    //Search through this directory
    var _file = undefined;
    while(true)
    {
        _file = (_file == undefined)? file_find_first(_directory + _match_all_mask, fa_directory) : file_find_next();
        if (_file == "") break;
        
        if (directory_exists(_directory + _file))
        {
            //Process this directory
            _directories[@ array_length(_directories)] = _file;
        }
        else if ((_extension == ".*") || (filename_ext(_file) == _extension))
        {
            //Add this matching file to the output array
            var value = _generator ? _generator(_directory, _file, _extension, global.__gumshoe_count) : global.__gumshoe_count;
            variable_struct_set(_result, _file, value);
            ++global.__gumshoe_count;
        }
    }
    
    file_find_close();
    
    //Now handle the directories
    var _i = 0;
    repeat(array_length(_directories))
    {
        variable_struct_set(_result, _directories[_i], __gumshoe_struct(_directory + _directories[_i] + _path_sep, _extension, _match_all_mask, _path_sep, _generator));
        ++_i;
    }
    
    return _result;
}