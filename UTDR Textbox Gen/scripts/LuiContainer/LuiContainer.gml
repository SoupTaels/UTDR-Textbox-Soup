///@desc An empty, invisible container for elements with padding on the sides for elements with column stacking
///@arg {Struct} [_params] Struct with parameters
function LuiContainer(_params = {}) : LuiBase(_params) constructor {
	self.ignore_mouse = true;
}

///@desc An empty, invisible container with no padding on the sides for elements with row stacking
///@arg {Struct} [_params] Struct with parameters
function LuiRow(_params = {}) : LuiContainer(_params) constructor {
	
	self.addEvent(LUI_EV_CREATE, function(_element) {
		_element.setPadding(0).setFlexDirection(flexpanel_flex_direction.row);
	});
}

///@desc An empty, invisible container with no padding on the sides for elements with column stacking
///@arg {Struct} [_params] Struct with parameters
function LuiColumn(_params = {}) : LuiContainer(_params) constructor {
	
	self.addEvent(LUI_EV_CREATE, function(_element) {
		_element.setPadding(0).setFlexDirection(flexpanel_flex_direction.column);
	});
}

///@desc An empty, invisible container with absolute position on the screen for elements
///@arg {Struct} [_params] Struct with parameters
function LuiAbsoluteContainer(_params = {}) : LuiContainer(_params) constructor {
	
	self.addEvent(LUI_EV_CREATE, function(_element) {
		_element.setPositionAbsolute();
	});
}