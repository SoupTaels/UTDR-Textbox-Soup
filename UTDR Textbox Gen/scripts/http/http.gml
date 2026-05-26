/// feather disable all
global.HTTP_DEFAULT_OPTIONS = {
	headers: undefined,
	response_headers: undefined,
	keep_header_map: false,
	get_file: false,
	formdata: undefined,
	keep_formdata: false,
	buffer: undefined,
	keep_buffer: false,
	raw_body: "",
}
global.HTTP_DEFAULT_VARIABLE_LIST = variable_struct_get_names(global.HTTP_DEFAULT_OPTIONS);


/// @function http
/// @param {string} url request URL
/// @param {string} _method request method (GET/POST/PUT/PATCH/DELETE/etc.)
/// @param {string | buffer | struct.FormData} body Body for the HTTP request
/// @param {struct} options Struct containing one or more options that can modify the request
/// @param {function} cb
/// @param {function} cb_error
/// @param {function} cb_progress
/// feather ignore once GM1062
function http(url,_method,body,options={},cb=undefined,cb_error=undefined,cb_progress=undefined){
	if (!is_string(url)) {
		throw "url must be a string"
	}
	
	for (var i=0;i<array_length(global.HTTP_DEFAULT_VARIABLE_LIST);i++) {
		var key = global.HTTP_DEFAULT_VARIABLE_LIST[i];
		if (options[$ key] == undefined) {
			options[$ key] = global.HTTP_DEFAULT_OPTIONS[$ key];	
		}
	}
	if (!instance_exists(obj_http)) {
		instance_create_depth(0,0,0,obj_http);
	}
	if (options.headers == undefined) {
		options.headers = ds_map_create();
	}
	if (instanceof(body) == "FormData") {
		// Handle FormData uploads/POST/PUT/PATCH requests
		
		// Generates body
		options.formdata = body;
		var out = body.post_body();
		var form = out[0];
		var boundary = out[1];
		
		body = form;
		options.headers[? "Content-Type"] = "multipart/form-data; boundary=" + boundary;
		/// feather ignore once GM1041
		options.headers[? "Content-Length"] = string(buffer_get_size(body));
		
		
	} else if (is_struct(body) || is_array(body)) {
		body = json_stringify(body);
		options.headers[? "Content-Type"] = "application/json";
	}
	if (options.get_file) {
		var buffer = buffer_create(0,buffer_grow,1);
		var request = http_request(url,_method,options.headers,buffer);
		options.buffer = buffer;
		obj_http.requests[? request] = {
		    callback: cb,
			error: cb_error,
			progress: cb_progress,
			options: options,
			buffer: buffer,
		}
		return request;
	}
	var request = http_request(url,_method,options.headers,body);
	obj_http.requests[? request] = {
		callback: cb,
		error: cb_error,
		progress: cb_progress,
		options: options,
	}
	obj_http.active = true;
	
	// cleanup if needed
	
	if (options.keep_header_map == false) {
		ds_map_destroy(options.headers);	
	}
	
	if (options.formdata != undefined) {
		buffer_delete(body);
		if (options.keep_formdata == false) {
			options.formdata.cleanup();
		}
	}
	
	
	return request;
	
}
/// feather enable all

function http_get_default_config() {
	
}

function HttpBodyParser() constructor {
	static parsers = {};
	static parser_list = [];
	/// @function HttpBodyParser.add
	/// @param {string} content_type Content Type to operate on (ex: application/json, text/xml). This is case insensitive, and forced to lower case for consistency
	/// @param {Function} parser Parser function to call for this content-type
	static add = function(content_type,parser) {
		content_type = string_lower(content_type);
		parsers[$ content_type] = parser;
		array_push(parser_list,content_type);
	}
	/// @function HttpBodyParser.has
	/// @param {string} content_type The content-type to check for
	/// @returns {Bool}
	static has = function(content_type) {
		return struct_exists(parsers,content_type);
	}
	/// @function HttpbodyParser.parse
	/// @param {Id.DsMap} headers DS Map containing response headers
	/// @param {String | Id.Buffer} body The HTTP response body, as a string or buffer
	/// @param {struct} options The options struct
	/// @returns {any}
	static parse = function(headers,body,options) {	
		var type = string_lower(headers[? "Content-Type"]);
		for (var i=0;i<array_length(self.parser_list);i++) {
			if (string_pos(parser_list[i],type) > 0 || string_pos(type,parser_list[i]) > 0) {
				return parsers[$ parser_list[i]](headers,body,options);
			}
		}
	}
}
new HttpBodyParser();

// Register a JSON parser
/// @description Example parser that handles JSON
/// @param {Id.DsMap} headers HTTP Response headers for the request (or -1 if not available)
/// @param {String} http_body The HTTP Response body as a string
/// @param {Struct} options The options struct associated with this request
/// @return {Any}  result
function http_json_parse(headers,http_body, options) {
	try {
		var result = json_parse(http_body);
		return result;
	} catch(e) {
		throw (e);
	}
}
// and register the JSON parser
HttpBodyParser.add("application/json",http_json_parse);

