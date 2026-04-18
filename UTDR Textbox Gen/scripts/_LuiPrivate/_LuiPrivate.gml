///@ignore
function _luiPrintError(_text) {
	if LUI_LOG_ERROR_MODE >= 1 {
		var _element_name = self[$ "name"];
		print($"LIME_UI.ERROR.{_element_name}.{instanceof(self)}: " + _text);
	}
}

///@ignore
function _luiPrintWarning(_text) {
	if LUI_LOG_ERROR_MODE >= 2 {
		var _element_name = self[$ "name"];
		print($"LIME_UI.WARNING.{_element_name}.{instanceof(self)}: " + _text);
	}
}