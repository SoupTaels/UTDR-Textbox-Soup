/// @func draw_image_general(sprite_index/collage_image, image_index, left, top, width, height, x, y, xscale, yscale, rot, col1, col2, col3, col4, alpha);
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
/// @param {Real} rot
/// @param {Real} col1
/// @param {Real} col2
/// @param {Real} col3
/// @param {Real} col4
/// @param {Real} alpha
/// feather ignore all
function draw_image_general(_sprite, _sub, _left, _top, _width, _height, _x, _y, _xScale, _yScale, _rot, _col1, _col2, _col3, _col4, _alpha) {
	gml_pragma("forceinline");
	if (CollageIsImage(_sprite)) {
		return CollageDrawImageGeneral(_sprite, _sub, _left, _top, _width, _height, _x, _y, _xScale, _yScale, _rot, _col1, _col2, _col3, _col4, _alpha);	
	} 
	
	draw_sprite_general(_sprite, _sub, _left, _top, _width, _height, _x, _y, _xScale, _yScale, _rot, _col1, _col2, _col3, _col4, _alpha);
} 
