/// feather disable all

#macro NEWLINE (chr(13)+chr(10))
global.ADD_FILE_OPTIONS_DEFAULT = {
	keep_buffer: false,
	filename: "",
	mimetype: "",
}
global.ADD_FILE_OPTIONS_KEYS = variable_struct_get_names(global.ADD_FILE_OPTIONS_DEFAULT);
global.bound_char_set = [
	"-","_",
	"1","2","3","4","5","6","7","8","9","0",
	"a","b","c","d","e","f","g","h","i","j","k","l","m",
	"n","o","p","q","r","s","t","u","v","w","x","y","z",
	"A","B","C","D","E","F","G","H","I","J","K","L","M",
	"N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
];
function form_get_bound_safe_char() {
	var _index = irandom(array_length(global.bound_char_set)-1);
	return global.bound_char_set[_index];
}

function FormData() constructor {
	boundary = "----" + sha1_string_utf8(date_datetime_string(date_current_datetime()));
	fields = [];
	/// @description Loads a binary file off storage and adds it to the FormData instance
	/// @param {string} name Field name in FormData body
	/// @param {string} file Filename
	/// @param {struct} options Various options for this field, including cusotm filename and mimetype
	function add_file(name,file,options={}) {
		var buffer = buffer_load(file);
		options.keep_buffer = false;
		self.add_buffer(name,buffer,fname,options);
	}
	/// @description Add a buffer to the FormData instance
	/// @param {string} name Field name in FormData body
	/// @param {Id.Buffer} buffer Buffer to add
	/// @param {Id.Buffer} fname Filename of the buffer, defaults to the field name
	/// @param {struct} options Various options for this field, including cusotm filename and mimetype
	function add_buffer(name,buffer,fname=name,options={}) {
		for (var i=0;i<array_length(global.ADD_FILE_OPTIONS_KEYS);i++) {
			var key = global.ADD_FILE_OPTIONS_KEYS[i];
			if (options[$ key] == undefined) {
				options[$ key] = global.ADD_FILE_OPTIONS_DEFAULT[$ key];
			}
		}
		if (!is_string(options.filename)) {
			options.filename = fname;
		}
		// attempt to pull a mimetype if none provided
		if (options.mimetype != "") {
			options.mimetype = get_mime_from_extension(filename_ext(options.filename));
		}
		
		
		array_push(fields,{
			type: "file",
			enctype: "binary",
			name: name,
			buffer: buffer,
			keep_buffer: ((options.file_is_buffer == true) && (options.keep_buffer == true)),
			mimetype: options.mimetype,
			filename: fname,
			
		});
		// now check the boundary.. yaaaaay
		var check_bound_byte = 1;
		for (var p=0;p<buffer_get_size(buffer);p++) {
			var byte = buffer_peek(buffer,p,buffer_u8);	
			var check_byte = ord(string_byte_at(boundary,check_bound_byte));
			if (byte == check_byte) {
				bc++;
				if (bc == string_length(boundary)) {
					boundary += form_get_bound_safe_char();
				}
			} else {
				bc = 1;
			}
		}
	}
	/// @description Add a text field to the FormData instance
	/// @param {string} field Field name
	/// @param {string} value field value
	function add_data(field,value) {
		array_push(fields,{
			type:"text",
			name:field,
			data:value,
		})
	}
	function cleanup() {
		for (var i=0;i<array_length(fields);i++) {
			var field = fields[i];
			if (field.type == "file") {
				if (field.keep_buffer != true) {
					buffer_delete(field.buffer);
				}
			}
		}
	}
	
	function post_body() {
		var buffer = buffer_create(4,buffer_grow,1);
		for (var i=0;i<array_length(fields);i++) {
			var field = fields[i];
			var name = field.name;
			
			buffer_write(buffer,buffer_text,"--"+boundary+NEWLINE);
			
			// Text field
			if (field.type=="text") {
				var data = field.data;
				buffer_write(buffer,buffer_text,"Content-Disposition: form-data; name=\""+name+"\""+NEWLINE+NEWLINE);
				buffer_write(buffer,buffer_text,string(data)+NEWLINE);
				continue;
			}
			// File field!
			if (field.filename == undefined) {
				field.filename = name;	
			}
			if (field.mimetype == undefined) {
				// apparently this should be assumed, ask rfc2045 ¯\_(ツ)_/¯
				field.mimetype = "text/plain";	
			}
			buffer_write(buffer,buffer_text,"Content-Disposition: form-data;name=\""+name+"\"; filename=\"" + field.filename + "\"" + NEWLINE);
			buffer_write(buffer,buffer_text,"Content-Type: " + field.mimetype + NEWLINE + NEWLINE);
			
			buffer_copy(field.buffer,0,buffer_get_size(field.buffer),buffer,buffer_tell(buffer));
			buffer_seek(buffer,buffer_seek_relative,buffer_get_size(field.buffer));
			buffer_write(buffer,buffer_text,NEWLINE);
		}
		buffer_write(buffer,buffer_text,"--"+boundary+"--"+NEWLINE);
		return [buffer,boundary];
	}
}


/// @description Reuturns a mimetype from a given extension
/// @param {string} extension
function get_mime_from_extension(extension) {
	switch (string_lower(extension)) {
		case ".evy":
			return "application/envoy"
		break;
		case ".fif":
		    return "application/fractals"
		break;
		case ".spl":
		    return "application/futuresplash"
		break;
		case ".hta":
		    return "application/hta"
		break;
		case ".acx":
		    return "application/internet-property-stream"
		break;
		case ".hqx":
		    return "application/mac-binhex40"
		break;
		case ".doc":
		    return "application/msword"
		break;
		case ".dot":
		    return "application/msword"
		break;
		case ".*":
		    return "application/octet-stream"
		break;
		case ".bin":
		    return "application/octet-stream"
		break;
		case ".class":
		    return "application/octet-stream"
		break;
		case ".dms":
		    return "application/octet-stream"
		break;
		case ".exe":
		    return "application/octet-stream"
		break;
		case ".lha":
		    return "application/octet-stream"
		break;
		case ".lzh":
		    return "application/octet-stream"
		break;
		case ".oda":
		    return "application/oda"
		break;
		case ".axs":
		    return "application/olescript"
		break;
		case ".pdf":
		    return "application/pdf"
		break;
		case ".prf":
		    return "application/pics-rules"
		break;
		case ".p10":
		    return "application/pkcs10"
		break;
		case ".crl":
		    return "application/pkix-crl"
		break;
		case ".ai":
		    return "application/postscript"
		break;
		case ".eps":
		    return "application/postscript"
		break;
		case ".ps":
		    return "application/postscript"
		break;
		case ".rtf":
		    return "application/rtf"
		break;
		case ".setpay":
		    return "application/set-payment-initiation"
		break;
		case ".setreg":
		    return "application/set-registration-initiation"
		break;
		case ".xla":
		    return "application/vnd.ms-excel"
		break;
		case ".xlc":
		    return "application/vnd.ms-excel"
		break;
		case ".xlm":
		    return "application/vnd.ms-excel"
		break;
		case ".xls":
		    return "application/vnd.ms-excel"
		break;
		case ".xlt":
		    return "application/vnd.ms-excel"
		break;
		case ".xlw":
		    return "application/vnd.ms-excel"
		break;
		case ".msg":
		    return "application/vnd.ms-outlook"
		break;
		case ".sst":
		    return "application/vnd.ms-pkicertstore"
		break;
		case ".cat":
		    return "application/vnd.ms-pkiseccat"
		break;
		case ".stl":
		    return "application/vnd.ms-pkistl"
		break;
		case ".pot":
		    return "application/vnd.ms-powerpoint"
		break;
		case ".pps":
		    return "application/vnd.ms-powerpoint"
		break;
		case ".ppt":
		    return "application/vnd.ms-powerpoint"
		break;
		case ".mpp":
		    return "application/vnd.ms-project"
		break;
		case ".wcm":
		    return "application/vnd.ms-works"
		break;
		case ".wdb":
		    return "application/vnd.ms-works"
		break;
		case ".wks":
		    return "application/vnd.ms-works"
		break;
		case ".wps":
		    return "application/vnd.ms-works"
		break;
		case ".hlp":
		    return "application/winhlp"
		break;
		case ".bcpio":
		    return "application/x-bcpio"
		break;
		case ".z":
		    return "application/x-compress"
		break;
		case ".tgz":
		    return "application/x-compressed"
		break;
		case ".cpio":
		    return "application/x-cpio"
		break;
		case ".csh":
		    return "application/x-csh"
		break;
		case ".dcr":
		    return "application/x-director"
		break;
		case ".dir":
		    return "application/x-director"
		break;
		case ".dxr":
		    return "application/x-director"
		break;
		case ".dvi":
		    return "application/x-dvi"
		break;
		case ".gtar":
		    return "application/x-gtar"
		break;
		case ".gz":
		    return "application/x-gzip"
		break;
		case ".hdf":
		    return "application/x-hdf"
		break;
		case ".ins":
		    return "application/x-internet-signup"
		break;
		case ".isp":
		    return "application/x-internet-signup"
		break;
		case ".iii":
		    return "application/x-iphone"
		break;
		case ".js":
		    return "application/x-javascript"
		break;
		case ".latex":
		    return "application/x-latex"
		break;
		case ".mdb":
		    return "application/x-msaccess"
		break;
		case ".crd":
		    return "application/x-mscardfile"
		break;
		case ".clp":
		    return "application/x-msclip"
		break;
		case ".dll":
		    return "application/x-msdownload"
		break;
		case ".m13":
		    return "application/x-msmediaview"
		break;
		case ".m14":
		    return "application/x-msmediaview"
		break;
		case ".mvb":
		    return "application/x-msmediaview"
		break;
		case ".wmf":
		    return "application/x-msmetafile"
		break;
		case ".mny":
		    return "application/x-msmoney"
		break;
		case ".pub":
		    return "application/x-mspublisher"
		break;
		case ".scd":
		    return "application/x-msschedule"
		break;
		case ".trm":
		    return "application/x-msterminal"
		break;
		case ".wri":
		    return "application/x-mswrite"
		break;
		case ".cdf":
		    return "application/x-netcdf"
		break;
		case ".nc":
		    return "application/x-netcdf"
		break;
		case ".pma":
		    return "application/x-perfmon"
		break;
		case ".pmc":
		    return "application/x-perfmon"
		break;
		case ".pml":
		    return "application/x-perfmon"
		break;
		case ".pmr":
		    return "application/x-perfmon"
		break;
		case ".pmw":
		    return "application/x-perfmon"
		break;
		case ".p12":
		    return "application/x-pkcs12"
		break;
		case ".pfx":
		    return "application/x-pkcs12"
		break;
		case ".p7b":
		    return "application/x-pkcs7-certificates"
		break;
		case ".spc":
		    return "application/x-pkcs7-certificates"
		break;
		case ".p7r":
		    return "application/x-pkcs7-certreqresp"
		break;
		case ".p7c":
		    return "application/x-pkcs7-mime"
		break;
		case ".p7m":
		    return "application/x-pkcs7-mime"
		break;
		case ".p7s":
		    return "application/x-pkcs7-signature"
		break;
		case ".sh":
		    return "application/x-sh"
		break;
		case ".shar":
		    return "application/x-shar"
		break;
		case ".swf":
		    return "application/x-shockwave-flash"
		break;
		case ".sit":
		    return "application/x-stuffit"
		break;
		case ".sv4cpio":
		    return "application/x-sv4cpio"
		break;
		case ".sv4crc":
		    return "application/x-sv4crc"
		break;
		case ".tar":
		    return "application/x-tar"
		break;
		case ".tcl":
		    return "application/x-tcl"
		break;
		case ".tex":
		    return "application/x-tex"
		break;
		case ".texi":
		    return "application/x-texinfo"
		break;
		case ".texinfo":
		    return "application/x-texinfo"
		break;
		case ".roff":
		    return "application/x-troff"
		break;
		case ".t":
		    return "application/x-troff"
		break;
		case ".tr":
		    return "application/x-troff"
		break;
		case ".man":
		    return "application/x-troff-man"
		break;
		case ".me":
		    return "application/x-troff-me"
		break;
		case ".ms":
		    return "application/x-troff-ms"
		break;
		case ".ustar":
		    return "application/x-ustar"
		break;
		case ".src":
		    return "application/x-wais-source"
		break;
		case ".cer":
		    return "application/x-x509-ca-cert"
		break;
		case ".crt":
		    return "application/x-x509-ca-cert"
		break;
		case ".der":
		    return "application/x-x509-ca-cert"
		break;
		case ".pko":
		    return "application/ynd.ms-pkipko"
		break;
		case ".zip":
		    return "application/zip"
		break;
		case ".au":
		    return "audio/basic"
		break;
		case ".snd":
		    return "audio/basic"
		break;
		case ".mid":
		    return "audio/mid"
		break;
		case ".rmi":
		    return "audio/mid"
		break;
		case ".mp3":
		    return "audio/mpeg"
		break;
		case ".aif":
		    return "audio/x-aiff"
		break;
		case ".aifc":
		    return "audio/x-aiff"
		break;
		case ".aiff":
		    return "audio/x-aiff"
		break;
		case ".m3u":
		    return "audio/x-mpegurl"
		break;
		case ".ra":
		    return "audio/x-pn-realaudio"
		break;
		case ".ram":
		    return "audio/x-pn-realaudio"
		break;
		case ".wav":
		    return "audio/x-wav"
		break;
		case ".bmp":
		    return "image/bmp"
		break;
		case ".cod":
		    return "image/cis-cod"
		break;
		case ".gif":
		    return "image/gif"
		break;
		case ".ief":
		    return "image/ief"
		break;
		case ".jpe":
		    return "image/jpeg"
		break;
		case ".jpeg":
		    return "image/jpeg"
		break;
		case ".jpg":
		    return "image/jpeg"
		break;
		case ".jfif":
		    return "image/pipeg"
		break;
		case ".svg":
		    return "image/svg+xml"
		break;
		case ".tif":
		    return "image/tiff"
		break;
		case ".tiff":
		    return "image/tiff"
		break;
		case ".ras":
		    return "image/x-cmu-raster"
		break;
		case ".cmx":
		    return "image/x-cmx"
		break;
		case ".ico":
		    return "image/x-icon"
		break;
		case ".pnm":
		    return "image/x-portable-anymap"
		break;
		case ".pbm":
		    return "image/x-portable-bitmap"
		break;
		case ".pgm":
		    return "image/x-portable-graymap"
		break;
		case ".ppm":
		    return "image/x-portable-pixmap"
		break;
		case ".rgb":
		    return "image/x-rgb"
		break;
		case ".xbm":
		    return "image/x-xbitmap"
		break;
		case ".xpm":
		    return "image/x-xpixmap"
		break;
		case ".xwd":
		    return "image/x-xwindowdump"
		break;
		case ".mht":
		    return "message/rfc822"
		break;
		case ".mhtml":
		    return "message/rfc822"
		break;
		case ".nws":
		    return "message/rfc822"
		break;
		case ".css":
		    return "text/css"
		break;
		case ".323":
		    return "text/h323"
		break;
		case ".htm":
		    return "text/html"
		break;
		case ".html":
		    return "text/html"
		break;
		case ".stm":
		    return "text/html"
		break;
		case ".uls":
		    return "text/iuls"
		break;
		case ".bas":
		    return "text/plain"
		break;
		case ".c":
		    return "text/plain"
		break;
		case ".h":
		    return "text/plain"
		break;
		case ".txt":
		    return "text/plain"
		break;
		case ".rtx":
		    return "text/richtext"
		break;
		case ".sct":
		    return "text/scriptlet"
		break;
		case ".tsv":
		    return "text/tab-separated-values"
		break;
		case ".htt":
		    return "text/webviewhtml"
		break;
		case ".htc":
		    return "text/x-component"
		break;
		case ".etx":
		    return "text/x-setext"
		break;
		case ".vcf":
		    return "text/x-vcard"
		break;
		case ".mp2":
		    return "video/mpeg"
		break;
		case ".mpa":
		    return "video/mpeg"
		break;
		case ".mpe":
		    return "video/mpeg"
		break;
		case ".mpeg":
		    return "video/mpeg"
		break;
		case ".mpg":
		    return "video/mpeg"
		break;
		case ".mpv2":
		    return "video/mpeg"
		break;
		case ".mp4":
		    return "video/mp4"
		break;
		case ".mov":
		    return "video/quicktime"
		break;
		case ".qt":
		    return "video/quicktime"
		break;
		case ".lsf":
		    return "video/x-la-asf"
		break;
		case ".lsx":
		    return "video/x-la-asf"
		break;
		case ".asf":
		    return "video/x-ms-asf"
		break;
		case ".asr":
		    return "video/x-ms-asf"
		break;
		case ".asx":
		    return "video/x-ms-asf"
		break;
		case ".avi":
		    return "video/x-msvideo"
		break;
		case ".movie":
		    return "video/x-sgi-movie"
		break;
		case ".flr":
		    return "x-world/x-vrml"
		break;
		case ".vrml":
		    return "x-world/x-vrml"
		break;
		case ".wrl":
		    return "x-world/x-vrml"
		break;
		case ".wrz":
		    return "x-world/x-vrml"
		break;
		case ".xaf":
		    return "x-world/x-vrml"
		break;
		case ".xof":
		    return "x-world/x-vrml"
		break;
		default: 
			return "application/octet-stream";
		break;
		
	}
}

/// feather enable all