/// @func image_get_xoffset(image)
/// @param {Asset.GMSprite, Struct.__CollageImageClass} sprite_index/collage_image
/// feather ignore all
function image_get_xoffset(_image) {	
	if (CollageIsImage(_image)) {
	    return _image.GetXOffset();   
	}
	
	return sprite_get_xoffset(_image);
}