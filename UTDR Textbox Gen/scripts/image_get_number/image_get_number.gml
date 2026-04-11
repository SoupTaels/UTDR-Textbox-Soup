/// @func image_get_number
/// @param {Asset.GMSprite, Struct.__CollageImageClass} sprite_index/collage_image
/// feather ignore all
function image_get_number(_image) {
	if (CollageIsImage(_image)) {
	    return _image.GetFrameCount();
	}
	
	return sprite_get_number(_image);
}