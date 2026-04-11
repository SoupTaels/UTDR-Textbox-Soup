/// @param controlPointArray
/// @param segments

function CleanSpline(_controlArray, _segments)
{
    return new __CleanClassSpline(_controlArray, _segments);
}

function __CleanClassSpline(_controlArray, _segments) constructor
{
    if (!is_array(_controlArray)) __CleanError("Invalid datatype given for argument0 (", typeof(_controlArray), "), was expecting an array");
    if ((array_length(_controlArray) mod 2) != 0) __CleanError("Points array must have an even number of elements (x/y pairs)");
    
    __pointArray = undefined;
    __colour     = CLEAN_DEFAULT_SPLINE_COLOUR;
    __alpha      = CLEAN_DEFAULT_SPLINE_ALPHA;
    __blendArray = undefined;
    
    __thickness = CLEAN_DEFAULT_SPLINE_THICKNESS;
    
    __join     = CLEAN_DEFAULT_SPLINE_JOIN;
    __capStart = CLEAN_DEFAULT_SPLINE_START_CAP;
    __capEnd   = CLEAN_DEFAULT_SPLINE_END_CAP;
    
    
    
    #region Generate point array
    
    var _controlPoints = array_length(_controlArray);
    
    var _points = _segments + 1;
    var _pointArray = array_create(2*_points);
    __pointArray = _pointArray;
    
    var _incr = 1/_segments;
    var _t = 0;
    var _i = 0;
    
    if ((_controlPoints mod 2) != 0)
    {
        __CleanError("There must be an even number of elements in the control point array (x/y pairs)");
    }
    else if (_controlPoints < 4)
    {
        __CleanError("Insufficient control points specified");
    }
    else if (_controlPoints == 4)
    {
        //Basic straight line
        
        var _x0 = _controlArray[0];
        var _y0 = _controlArray[1];
        var _x1 = _controlArray[2];
        var _y1 = _controlArray[3];
        
        repeat(_points)
        {
            _pointArray[@ _i  ] = lerp(_x0,  _x1,  _t);
            _pointArray[@ _i+1] = lerp(_y0,  _y1,  _t);
            
            _i += 2;
            _t += _incr;
        }
    }
    else if (_controlPoints == 6)
    {
        //Quadratic curve
        
        var _x0 = _controlArray[0];
        var _y0 = _controlArray[1];
        var _x1 = _controlArray[2];
        var _y1 = _controlArray[3];
        var _x2 = _controlArray[4];
        var _y2 = _controlArray[5];
        
        repeat(_points)
        {
            var _x01 = lerp(_x0,  _x1,  _t);
            var _x12 = lerp(_x1,  _x2,  _t);
            var _x   = lerp(_x01, _x12, _t);
            
            var _y01 = lerp(_y0,  _y1,  _t);
            var _y12 = lerp(_y1,  _y2,  _t);
            var _y   = lerp(_y01, _y12, _t);
            
            _pointArray[@ _i  ] = _x;
            _pointArray[@ _i+1] = _y;
            
            _i += 2;
            _t += _incr;
        }
    }
    else if (_controlPoints == 8)
    {
        //Cubic curve
        
        var _x0 = _controlArray[0];
        var _y0 = _controlArray[1];
        var _x1 = _controlArray[2];
        var _y1 = _controlArray[3];
        var _x2 = _controlArray[4];
        var _y2 = _controlArray[5];
        var _x3 = _controlArray[6];
        var _y3 = _controlArray[7];
        
        repeat(_points)
        {
            var _x01   = lerp(_x0,    _x1,    _t);
            var _x12   = lerp(_x1,    _x2,    _t);
            var _x23   = lerp(_x2,    _x3,    _t);
            var _x0112 = lerp(_x01,   _x12,   _t);
            var _x1223 = lerp(_x12,   _x23,   _t);
            var _x     = lerp(_x0112, _x1223, _t);
            
            var _y01   = lerp(_y0,    _y1,    _t);
            var _y12   = lerp(_y1,    _y2,    _t);
            var _y23   = lerp(_y2,    _y3,    _t);
            var _y0112 = lerp(_y01,   _y12,   _t);
            var _y1223 = lerp(_y12,   _y23,   _t);
            var _y     = lerp(_y0112, _y1223, _t);
            
            _pointArray[@ _i  ] = _x;
            _pointArray[@ _i+1] = _y;
            
            _i += 2;
            _t += _incr;
        }
    }
    else
    {
        repeat(_points)
        {
            var _result = __CleanSplineInterpolate(_controlArray, _t);
            _pointArray[@ _i  ] = _result[0];
            _pointArray[@ _i+1] = _result[1];
            
            _i += 2;
            _t += _incr;
        }
    }
    
    #endregion
    
    /// @param color
    /// @param alpha
    static Blend = function(_colour, _alpha)
    {
        __colour = _colour;
        __alpha  = _alpha;
        
        return self;
    }
    
    /// @param colour1
    /// @param alpha1
    /// @param colour2
    /// @param alpha2
    static Blend2 = function(_c1, _a1, _c2, _a2)
    {
        var _points = array_length(__pointArray) div 2;
        
        var _blendArray = array_create(2*_points, 0);
        
        var _incr = 1 / (_points - 1);
        var _t = 0;
        var _i = 0;
        repeat(_points)
        {
            _blendArray[@ _i  ] = merge_colour(_c1, _c2, _t);
            _blendArray[@ _i+1] = lerp(_a1, _a2, _t);
            
            _i += 2;
            _t += _incr;
        }
        
        __colour     = undefined;
        __alpha      = undefined;
        __blendArray = _blendArray;
        
        return self;
    }
    
    /// @param blendArray
    static BlendExt = function(_inputArray)
    {
        if (!is_array(_inputArray)) __CleanError("Invalid datatype given for argument0 (", typeof(_inputArray), "), was expecting an array");
        if ((array_length(_inputArray) mod 2) != 0) __CleanError("Blend array must have an even number of elements (RGB/alpha pairs)");
        
        var _colours    = array_length(_inputArray) div 2;
        var _points     = array_length(__pointArray) div 2;
        var _blendArray = array_create(2*_points, 0);
        
        var _incr = (_colours - 1) / (_points - 1);
        var _t = 0;
        var _i = 0;
        repeat(_points)
        {
            var _int  = 2*floor(_t);
            var _frac = frac(_t);
            
            if (_frac == 0.0)
            {
                var _colour = _inputArray[_int  ];
                var _alpha  = _inputArray[_int+1];
            }
            else
            {
                var _colour = merge_colour(_inputArray[_int], _inputArray[_int + 2], _frac);
                var _alpha  = lerp(_inputArray[_int + 1], _inputArray[_int + 3], _frac);
            }
            
            _blendArray[@ _i  ] = _colour;
            _blendArray[@ _i+1] = _alpha;
            
            _i += 2;
            _t += _incr;
        }
        
        __colour     = undefined;
        __alpha      = undefined;
        __blendArray = _blendArray;
        
        return self;
    }
    
    static Thickness = function(_thickness)
    {
        __thickness = _thickness;
        
        return self;
    }
    
    /// @param startType
    /// @param endType
    static Cap = function(_cap_start, _cap_end)
    {
        __capStart = _cap_start;
        __capEnd   = _cap_end;
        
        return self;
    }
    
    /// @param type
    static Join = function(_join)
    {
        __join = _join;
        
        return self;
    }
    
    static Draw = function()
    {
        __CleanDraw();
        return undefined;
    }
    
    /// @param vertexBuffer
    static __Build = function(_vbuff)
    {
        return __CleanBuildPolyline(_vbuff);
    }
}

global.__cleanSplineArray = [];

function __CleanSplineInterpolate(_array, _time)
{
    var _result = global.__cleanSplineArray;
    
    if (_time <= 0.0)
    {
        _result[@ 0] = _array[0];
        _result[@ 1] = _array[1];
        return _result;
    }
    
    var _length = array_length(_array);
    
    if (_time >= 1.0)
    {
        _result[@ 0] = _array[_length-2];
        _result[@ 1] = _array[_length-1];
        return _result;
    }
    
    if (_result == undefined) _result = array_create(_length);
    array_resize(_result, _length);
    array_copy(_result, 0, _array, 0, _length);
    
    var _count = _length div 2;
    repeat(_count)
    {
        --_count;
        __CleanSplineReduce(_time, _result, _count);
    }
    
    return _result;
}

function __CleanSplineReduce(_time, _array, _count)
{
    var _x1 = undefined;
    var _y1 = undefined;
    var _x2 = _array[0];
    var _y2 = _array[1];
    
    var _i = 0;
    var _j = 2;
    repeat(_count)
    {
        _x1 = _x2;
        _y1 = _y2;
        _x2 = _array[_j];
        _y2 = _array[_j+1];
        
        _array[@ _i  ] = lerp(_x1, _x2, _time);
        _array[@ _i+1] = lerp(_y1, _y2, _time);
        
        _i = _j;
        _j += 2;
    }
}