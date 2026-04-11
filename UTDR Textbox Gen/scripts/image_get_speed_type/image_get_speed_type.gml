/// @func image_get_speed_type
/// @param {Asset.GMSprite, Struct.__CollageImageClass} sprite_index/collage_image
/// feather ignore all
function image_get_speed_type(_image) {
	if (CollageIsImage(_image)) {
	    return _image.GetSpeedType();
	}
	
	return sprite_get_speed_type(_image);
}