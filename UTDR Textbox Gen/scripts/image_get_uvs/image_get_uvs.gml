/// @func image_get_uvs(sprite_index/collage_image, image_index)
/// @param {Asset.GMSprite, Struct.__CollageImageClass} sprite_index/collage_image
/// @param {Real} image_index
/// @return {Array<Real>}
/// feather ignore all
function image_get_uvs(_sprite, _sub) {
	if (CollageIsImage(_sprite)) {
		return CollageImageGetUVsArray(_sprite, _sub);	
	}
		
	return sprite_get_uvs(_sprite, _sub);
} 
