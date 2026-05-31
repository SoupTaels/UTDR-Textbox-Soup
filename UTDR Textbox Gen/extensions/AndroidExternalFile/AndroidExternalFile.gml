#define integrated_file_path

var _result = "";

var _path = argument0; // {String}
var _name = argument1; // {String}
var _type = argument2; // {double}

if(_type == IS_FILE) {
	_result = _path + "/" + _name;
}
else {
	if(string_length(_path) == 0 || string_length(_path) == 1 && string_char_at(_path, 1) == "/") {
		_result = directory_get_saf_root() + "/" + _name;
	}
	else {
		if(string_char_at(_path, 1) == "/") {
			_result = directory_get_saf_root() + _path + "/" + _name;
		}
		else {
			_result = directory_get_saf_root() + "/" + _path + "/" + _name;
		}
	}
}

return _result;


#define integrated_file_copy

var _src_path = argument0; // {String}
var _src_name = argument1; // {String}
var _dst_path = argument2; // {String}
var _dst_name = argument3; // {String}
var _src_type = argument4; // {double}
var _dst_type = argument5; // {double}

if(_src_type == IS_FILE) {
	if(_dst_type == IS_FILE) {
		file_copy(_src_path + "/" + _src_name, _dst_path + "/" + _dst_name);
	}
	else {
		saf_file_copy_from_file(_src_path, _src_name, _dst_path, _dst_name);
	}
}
else {
	if(_dst_type == IS_FILE) {
		saf_file_copy_to_file(_src_path, _src_name, _dst_path, _dst_name);
	}
	else {
		saf_file_copy(_src_path, _src_name, _dst_path, _dst_name);
	}
}

return;