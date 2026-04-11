/// @func draw_image_stretched(sprite_index/collage_image, image_index, x, y, width, height)
/// @param {Asset.GMSprite, Struct.__CollageImageClass} sprite_index/collage_image
/// @param {Real} image_index
/// @param {Real} x
/// @param {Real} y
/// @param {Real} width
/// @param {Real} height
/// feather ignore all
function draw_image_stretched(_sprite, _sub, _x, _y, _width, _height) {
	gml_pragma("forceinline");
	if (CollageIsImage(_sprite)) {
		return CollageDrawImageStretched(_sprite, _sub, _x, _y, _width, _height);	
	} 
	
	draw_sprite_stretched(_sprite, _sub, _x, _y, _width, _height);	
} 
