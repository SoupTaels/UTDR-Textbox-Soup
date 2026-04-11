/// @func draw_image(sprite_index/collage_image, image_index, x, y)
/// @param {Asset.GMSprite, Struct.__CollageImageClass} sprite_index/collage_image
/// @param {Real} image_index
/// @param {Real} x
/// @param {Real} y
/// feather ignore all
function draw_image(_sprite, _sub, _x, _y) {
	gml_pragma("forceinline");
	if (CollageIsImage(_sprite)) {
		return CollageDrawImage(_sprite, _sub, _x, _y);	
	} 
	
	draw_sprite(_sprite, _sub, _x, _y);
} 
