/// @func image_get_speed
/// @param {Asset.GMSprite, Struct.__CollageImageClass} sprite_index/collage_image
/// feather ignore all
function image_get_speed(_image) {
	if (CollageIsImage(_image)) {
	    return _image.GetSpeed();
	}
	
	return sprite_get_speed(_image);
}