/// @func image_get_width
/// @param {Asset.GMSprite, Struct.__CollageImageClass} sprite_index/collage_image
/// feather ignore all
function image_get_width(_image) {
	if (CollageIsImage(_image)) {
	    return _image.GetWidth();
	}
	
	return sprite_get_height(_image);
}