/// @func draw_image_part_ext(sprite_index/collage_image, image_index, left, top, width, height, x, y, xscale, yscale, col, alpha);
/// @param {Asset.GMSprite, Struct.__CollageImageClass} sprite_index/collage_image
/// @param {Real} image_index
/// @param {Real} left
/// @param {Real} top
/// @param {Real} width
/// @param {Real} height
/// @param {Real} x
/// @param {Real} y
/// @param {Real} xscale
/// @param {Real} yscale
/// @param {Real} colour
/// @param {Real} alpha
/// feather ignore all
function draw_image_part_ext(_sprite, _sub, _left, _top, _width, _height, _x, _y, _xscale, _yscale, _col, _alpha) {
	gml_pragma("forceinline");
	if (CollageIsImage(_sprite)) {
		return CollageDrawImagePartExt(_sprite, _sub, _left, _top, _width, _height, _x, _y, _xscale, _yscale, _col, _alpha);
		
	} 
	
	draw_sprite_part_ext(_sprite, _sub, _left, _top, _width, _height, _x, _y, _xscale, _yscale, _col, _alpha);
} 
