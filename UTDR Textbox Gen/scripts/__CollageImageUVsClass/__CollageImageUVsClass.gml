/// @ignore
/// feather ignore all
function __CollageImageUVsClass(_texPageStruct, _texPageNum, _left, _top, _right, _bottom, _trimLeft = 0, _trimTop = 0, _ogW = 0, _ogH = 0, /*_cropRotate = 0,*/ _xOffset = 0, _yOffset = 0) constructor {
	left = _left;
	right = _right;
	top = _top;
	bottom = _bottom;
	trimLeft = _trimLeft;
	trimTop = _trimTop;
	//trimRight = _trimRight;
	//trimBottom = _trimBottom;
	//rotate = _cropRotate;
	normLeft = (_left / _texPageStruct.__width);
	normRight = normLeft + (_right / _texPageStruct.__width);
	normTop = (_top / _texPageStruct.__height);
	normBottom = normTop + (_bottom / _texPageStruct.__height);
	normWidth = normLeft+normRight;
	normHeight = normTop+normBottom;
	originalWidth = _ogW;
	originalHeight = _ogH;
	xPos = _xOffset-_trimLeft;
	yPos = _yOffset-_trimTop;
	texturePageNum = _texPageNum;
	texturePageStruct = _texPageStruct;
	
	static ExportData = function() {
		return {
			left,
			right,
			top,
			bottom,
			trimLeft,
			trimTop,
			normLeft,
			normRight,
			normTop,
			normBottom,
			normWidth,
			normHeight,
			originalWidth,
			originalHeight,
			xPos,
			yPos,
			tp: texturePageNum,
		};
	}
}