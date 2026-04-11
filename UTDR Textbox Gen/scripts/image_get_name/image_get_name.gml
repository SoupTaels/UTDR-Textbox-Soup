/// @func image_get_name(image)
/// @param {Asset.GMSprite, Struct.__CollageImageClass} sprite_index/collage_image
/// feather ignore all
function image_get_name(_image) {
	if (CollageIsImage(_image)) {
	    return _image.GetName();   
	}
	
	return sprite_get_name(_image);
}