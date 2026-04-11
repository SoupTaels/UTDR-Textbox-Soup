/// @ignore
/// feather ignore all
function __CollageHashGenerator(_spriteID){
	static _data = __CollageHashData();
	static _buff = _data.buff;

	var _width = sprite_get_bbox_right(_spriteID)-sprite_get_bbox_left(_spriteID);
	var _height = sprite_get_bbox_bottom(_spriteID)-sprite_get_bbox_top(_spriteID);
	var _size = _width*_height*4;
	var _subImages = sprite_get_number(_spriteID);
	
	if (!surface_exists(_data.surf)) {
		_data.surf = surface_create(_width, _height);
	} else if (_width != surface_get_width(_data.surf) || (_height != surface_get_height(_data.surf))) {
		surface_resize(_data.surf, _width, _height);
	}
	
	if (_size != buffer_get_size(_buff)) {
		buffer_resize(_buff, _size);
	}
	var _surf = _data.surf;
	
	var _hashes = array_create(_subImages);
	var _i = 0;
	var _x = -sprite_get_bbox_left(_spriteID)+sprite_get_xoffset(_spriteID);
	var _y = -sprite_get_bbox_top(_spriteID)+sprite_get_yoffset(_spriteID);
	repeat(_subImages) {
		surface_set_target(_surf);
		draw_clear_alpha(0, 0);
		draw_sprite(_spriteID, _i, _x, _y);
		surface_reset_target();
		buffer_get_surface(_buff, _surf, 0);
		_hashes[_i] = buffer_sha1(_buff, 0, _size);
		++_i;
	}
	return _hashes;
}