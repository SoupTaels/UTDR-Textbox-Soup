/// @func image_get_yoffset(image)
/// @param {Asset.GMSprite, Struct.__CollageImageClass} sprite_index/collage_image
/// feather ignore all
function image_get_yoffset(_image) {
	if (CollageIsImage(_image)) {
	    return _image.GetYOffset();   
	}
	
	return sprite_get_yoffset(_image);
}