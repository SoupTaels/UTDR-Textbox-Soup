/// @func CollageDrawImageTiled(image, image_index, x, y);
/// @param {Struct.__CollageImageClass} collage_image
/// @param {Real} image_index
/// @param {Real} x
/// @param {Real} y
/// feather ignore all
function CollageDrawImageTiled(_imageData, _imageIndex, _x, _y) {
	gml_pragma("forceinline");
	if (!is_struct(_imageData)) __CollageThrow("Invalid collage_image! Got " + string(_imageData) + " instead!");
	var _uvs = _imageData.__InternalGetUvs(_imageIndex);
	
	if (!_uvs.texturePageStruct.__isLoaded) _uvs.texturePageStruct.CheckSurface();
	
	var _xPos = _x-_uvs.xPos;
	var _yPos = _y-_uvs.yPos;
	var _scale = _imageData.__scaled;
	var _bboxLeft = _uvs.left;
	var _bboxTop = _uvs.top;
	var _bboxRight = _uvs.right;
	var _bboxBottom = _uvs.bottom;
	var _bboxWidth = _uvs.originalWidth;
	var _bboxHeight = _uvs.originalHeight;
	var _surface = _uvs.texturePageStruct.__surface;
	var _col = draw_get_colour();
	var _alpha = draw_get_alpha();
	
	var _i = 0;
	var _j = 0;
	var _viewCam = view_camera[view_current];
	var _w = camera_get_view_width(_viewCam);
	var _h = camera_get_view_height(_viewCam);
	
	repeat((_w div _bboxWidth)+1) {
		_j = 0;
		repeat((_h div _bboxHeight)+1) {
			draw_surface_part_ext(_surface, 
				_bboxLeft,
				_bboxTop,
				_bboxRight,
				_bboxBottom, 
				_xPos + ((_i * _bboxWidth) * _scale), 
				_yPos + ((_j * _bboxHeight) * _scale), 
				_scale, 
				_scale, 
				_col, 
				_alpha
			);		
			++_j;
		}	
		++_i;
	}
}
