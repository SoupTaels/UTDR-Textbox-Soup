/// @ignore
/// feather ignore all
function __CollageBuildImage(_vbuffer, _imageData, _index, _x, _y, _z, _widthValue, _heightValue, _angleValue, _colourValue, _alpha, _respectOrigin, _func = __CollageVertexAdd){
	var _uvs = _imageData.GetUVs(_index);
	
	// Get UV info
	var _left, _right, _top, _bottom, _x1, _y1;
	_left =			_uvs.normLeft; 
	_top =			_uvs.normTop;
	_right =		_uvs.normRight;
	_bottom =		_uvs.normBottom; 
    var _c = dcos(_angleValue+90);
    var _s = dsin(_angleValue+90);
    
    var _colour;
	static _colArray = array_create(4);
	if (is_array(_colourValue)) {
		_colour = _colourValue;	
	} else if (is_numeric(_colourValue)) {
		_colArray[0] =_colourValue;
		_colArray[1] =_colourValue;
		_colArray[2] =_colourValue;
		_colArray[3] =_colourValue;
		_colour = _colArray;
    }
	
	var _xPos = (_respectOrigin) ? -_uvs.xPos : 0;
	var _yPos = (_respectOrigin) ? -_uvs.yPos : 0;
	var _width = _imageData.__cropWidth*_widthValue;
	var _height = _imageData.__cropHeight*_heightValue;
    
    var _pLeft = _xPos*_widthValue, _pTop = _yPos*_heightValue, _pBottom = (_pTop + _height), _pRight = (_pLeft + _width);
    
    var _x0 = _x + (-_pTop *  _c + _pLeft * _s);
    var _y0 = _y + (-_pTop * -_s + _pLeft * _c);
    var _x1 = _x + (-_pTop *  _c + _pRight * _s);
    var _y1 = _y + (-_pTop * -_s + _pRight * _c);
    var _x2 = _x + (-_pBottom *  _c + _pRight * _s);
    var _y2 = _y + (-_pBottom * -_s + _pRight * _c);
    var _x3 = _x + (-_pBottom *  _c + _pLeft * _s);
    var _y3 = _y + (-_pBottom * -_s + _pLeft * _c);
	
	static _xy = array_create(4);
	_xy[0][0] = _x0;
	_xy[0][1] = _y0;
	
	_xy[1][0] = _x1;
	_xy[1][1] = _y1;
	
	_xy[2][0] = _x2;
	_xy[2][1] = _y2;
	
	_xy[3][0] = _x3;
	_xy[3][1] = _y3;
	
	_func(_vbuffer, _xy, _z, _left, _top, _right, _bottom, _colour, _alpha);
}