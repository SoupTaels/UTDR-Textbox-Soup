/// @func draw_image_tiled_ext(sprite_index/collage_image, image_index, x, y, xscale, yscale, col, alpha);
/// @param {Asset.GMSprite, Struct.__CollageImageClass} sprite_index/collage_image
/// @param {Real} image_index
/// @param {Real} x
/// @param {Real} y
/// @param {Real} xscale
/// @param {Real} yscale
/// @param {Real} col
/// @param {Real} alpha
/// feather ignore all
function draw_image_tiled_ext(_sprite, _sub, _x, _y, _xscale, _yscale, _col, _alpha) {
	gml_pragma("forceinline");
	if (CollageIsImage(_sprite)) {
		return CollageDrawImageTiledExt(_sprite, _sub, _x, _y, _xscale, _yscale, _col, _alpha);
			
	}

	draw_sprite_tiled_ext(_sprite, _sub, _x, _y, _xscale, _yscale, _col, _alpha);
} 
