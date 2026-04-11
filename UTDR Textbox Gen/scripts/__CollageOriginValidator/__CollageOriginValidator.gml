/// @ignore
/// feather ignore all
function __CollageOriginValidator(_spriteID, _xOriginValue, _yOriginValue) {
	var _results = [_xOriginValue, _yOriginValue];
	// X Origin
	switch(_xOriginValue) {
		case CollageOrigin.CENTER: _results[0] = sprite_get_width(_spriteID) div 2; break;
		case CollageOrigin.LEFT: _results[0] = 0; break;
		case CollageOrigin.RIGHT: _results[0] = sprite_get_width(_spriteID); break;
		case CollageOrigin.TOP: case CollageOrigin.BOTTOM: 
			__CollageThrow("Invalid xorigin set! Can't use " + (_xOriginValue == CollageOrigin.TOP ? "CollageOrigin.TOP" : "CollageOrigin.BOTTOM") + " as an option!"); 
		break;
	}
	
	// Y Origin
	switch(_yOriginValue) {
		case CollageOrigin.CENTER: _results[1] = sprite_get_height(_spriteID) div 2; break;
		case CollageOrigin.TOP: _results[1] = 0; break;
		case CollageOrigin.BOTTOM: _results[1] = sprite_get_height(_spriteID); break;
		case CollageOrigin.LEFT: case CollageOrigin.RIGHT: 
			__CollageThrow("Invalid yorigin set! Can't use " + (_yOriginValue == CollageOrigin.LEFT ? "CollageOrigin.LEFT" : "CollageOrigin.RIGHT") + " as an option!"); 
		break;
	}
	
	return _results;
}