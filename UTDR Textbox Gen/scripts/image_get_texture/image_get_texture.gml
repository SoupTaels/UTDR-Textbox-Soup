/// @func image_get_texture
/// @param {Asset.GMSprite, Struct.__CollageImageClass} sprite_index/collage_image
/// @param {Real} image_index
/// feather ignore all
function image_get_texture(_image, _index) {
	if (CollageIsImage(_image)) {
	    return _image.GetTexture(_index);
	}
	
	return sprite_get_texture(_image, _index);
}