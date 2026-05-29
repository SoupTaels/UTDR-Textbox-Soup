/// @param pointArray

function CleanConvex(_array)
{
    return new __CleanClassConvex(_array);
}

function __CleanClassConvex(_array) constructor
{
    if (!is_array(_array)) __CleanError("Invalid datatype given for argument0 (", typeof(_array), "), was expecting an array");
    
    var _size = array_length(_array);
    if ((_size mod 2) != 0) __CleanError("Points array must have an even number of elements (x/y pairs)");
    
    __pointArray = _array;
    __colour     = CLEAN_DEFAULT_CONVEX_COLOUR;
    __alpha      = CLEAN_DEFAULT_CONVEX_ALPHA;
    __blendArray = undefined;
    
    __borderThickness = CLEAN_DEFAULT_CONVEX_BORDER_THICKNESS;
    __borderColour    = CLEAN_DEFAULT_CONVEX_BORDER_COLOUR;
    __borderAlpha     = CLEAN_DEFAULT_CONVEX_BORDER_ALPHA;
    __borderArray      = undefined;
    
    __rounding = CLEAN_DEFAULT_CONVEX_ROUNDING;
    
    /// @param color
    /// @param alpha
    static Blend = function(_colour, _alpha)
    {
        __colour     = _colour;
        __alpha      = _alpha;
        __blendArray = undefined;
        return self;
    }
    
    /// @param blendArray
    static BlendExt = function(_array)
    {
        if (!is_array(_array)) __CleanError("Invalid datatype given for argument0 (", typeof(_array), "), was expecting an array");
        if ((array_length(_array) mod 2) != 0) __CleanError("Blend array must have an even number of elements (RGB/alpha pairs)");
        
        __colour     = undefined;
        __alpha      = undefined;
        __blendArray = _array;
        
        return self;
    }
    
    static Border = function(_thickness, _colour, _alpha)
    {
        __borderThickness = _thickness;
        __borderColour    = _colour;
        __borderAlpha     = _alpha;
        __borderArray      = undefined;
        return self;
    }
    
    static BorderExt = function(_thickness, _array)
    {
        if (!is_array(_array)) __CleanError("Invalid datatype given for argument1 (", typeof(_array), "), was expecting an array");
        if ((array_length(_array) mod 2) != 0) __CleanError("Border array must have an even number of elements (RGB/alpha pairs)");
        
        __borderThickness = _thickness;
        __borderColour    = undefined;
        __borderAlpha     = undefined;
        __borderArray      = _array;
        return self;
    }
    
    static Rounding = function(_radius)
    {
        __rounding = _radius;
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
        var _pointArray  = __pointArray;
        var _blendArray  = __blendArray;
        var _borderArray = __borderArray;
        
        var _rounding        = __rounding;
        var _borderThickness = __borderThickness;
        
        var _blendIsArray  = is_array(_blendArray);
        var _borderIsArray = is_array(_borderArray);
        
        var _size  = array_length(_pointArray);
        var _count = floor(_size / 2);
        
        #region Detect and fix clockwise definitions
        
        if ((CLEAN_CONVEX_FIX_COUNTERCLOCKWISE_POINTS || CLEAN_CONVEX_ERROR_COUNTERCLOCKWISE_POINTS)
        &&  !__CleanIsClockwise(_pointArray[0], _pointArray[1], _pointArray[2], _pointArray[3], _pointArray[4], _pointArray[5]))
        {
            if (CLEAN_CONVEX_ERROR_COUNTERCLOCKWISE_POINTS)
            {
                __CleanError("Convex polygon defined with counter-clockwise coordinates\nConvex polygons should be defined using clockwise coodinates\n(Set CLEAN_CONVEX_ERROR_COUNTERCLOCKWISE_POINTS to <false> to turn off this error)\n(Set CLEAN_CONVEX_FIX_COUNTERCLOCKWISE_POINTS to <true> to *slowly* fix point ordering automatically)\n \n", _pointArray);
            }
            
            //Reverse the vertex oositions
            var _oldPointArray = _pointArray;
            _pointArray = array_create(_size);
            
            var _i = 0;
            var _j = _size - 2;
            repeat(_count)
            {
                _pointArray[@ _j  ] = _oldPointArray[_i  ];
                _pointArray[@ _j+1] = _oldPointArray[_i+1];
                
                _i += 2;
                _j -= 2;
            }
            
            //If the blend colour is an array, reverse that too
            if (_blendIsArray)
            {
                var _oldBlendArray = _blendArray;
                _blendArray = array_create(_size);
                
                var _i = 0;
                var _j = _size - 2;
                repeat(_count)
                {
                    _blendArray[@ _j  ] = _oldBlendArray[_i  ];
                    _blendArray[@ _j+1] = _oldBlendArray[_i+1];
                    
                    _i += 2;
                    _j -= 2;
                }
            }
            
            //And if the border colour is an array, reverse that as well!
            if (_borderIsArray)
            {
                var _oldBorderArray = _blendArray;
                _blendArray = array_create(_size);
                
                var _i = 0;
                var _j = _size - 2;
                repeat(_count)
                {
                    _borderArray[@ _j  ] = _oldBorderArray[_i  ];
                    _borderArray[@ _j+1] = _oldBorderArray[_i+1];
                    
                    _i += 2;
                    _j -= 2;
                }
            }
        }
        
        #endregion
        
        if (!_blendIsArray && !_borderIsArray)
        {
            #region Blend + Border are not arrays
            
            //Unpack the border colour/alpha into components for use when writing the vertex buffer
            var _border_r = colour_get_red(  __borderColour)/255;
            var _border_g = colour_get_green(__borderColour)/255;
            var _border_b = colour_get_blue( __borderColour)/255;
            var _border_a = __borderAlpha;
            
            //Find the centre of the polygon
            var _cx = 0;
            var _cy = 0;
            
            var _i = 0;
            repeat(_count)
            {
                _cx += _pointArray[_i  ];
                _cy += _pointArray[_i+1];
                _i += 2;
            }
            
            _cx /= _count;
            _cy /= _count;
            
            var _colour = __colour;
            var _alpha  = __alpha;
            
            //Build the polygon
            var _x0 = undefined;
            var _y0 = undefined;
            var _x1 = _pointArray[0];
            var _y1 = _pointArray[1];
            var _x2 = _pointArray[2];
            var _y2 = _pointArray[3];
            
            var _x01 = undefined;
            var _y01 = undefined;
            var _x12 = 0.5*(_x1 + _x2);
            var _y12 = 0.5*(_y1 + _y2);
            
            var _nx1 = undefined;
            var _ny1 = undefined;
            var _ds1 = undefined;
            
            var _nx2 = _x2 - _x1;
            var _ny2 = _y2 - _y1;
            var _n   = 1/sqrt(_nx2*_nx2 + _ny2*_ny2);
            var _tmp =  _nx2;
                _nx2 = -_ny2*_n;
                _ny2 =  _tmp*_n;
            var _ds2 = dot_product(_x2, _y2, _nx2, _ny2);
            
            var _i = 4 mod _size;
            repeat(_count)
            {
                _x0 = _x1;
                _y0 = _y1;
                _x1 = _x2;
                _y1 = _y2;
                _x2 = _pointArray[_i  ];
                _y2 = _pointArray[_i+1];
                
                _x01 = _x12;
                _y01 = _y12;
                
                _x12 = 0.5*(_x1 + _x2);
                _y12 = 0.5*(_y1 + _y2);
                
                _nx1 = _nx2;
                _ny1 = _ny2;
                _ds1 = _ds2;
                
                _nx2 = _x2 - _x1;
                _ny2 = _y2 - _y1;
                _n   = 1/sqrt(_nx2*_nx2 + _ny2*_ny2);
                _tmp =  _nx2;
                _nx2 = -_ny2*_n;
                _ny2 =  _tmp*_n;
                _ds2 = dot_product(_x2, _y2, _nx2, _ny2);
                
                vertex_position_3d(_vbuff, _cx,  _cy,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x01, _y01, 6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x1,  _y1,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                
                vertex_position_3d(_vbuff, _cx,  _cy,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x1,  _y1,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x12, _y12, 6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                
                _i = (_i + 2) mod _size;
            }
            
            #endregion
        }
        else if (!_blendIsArray && _borderIsArray)
        {
            #region  Border is an array but Blend is not
            
            //Calculate the inner border colour of the middle of the polygon by using a simple mean average
            //This seems a little silly - the inside of the shape will have no border obviously - but it ensures the interpolation works correctly
            var _border_r  = 0;
            var _border_g  = 0;
            var _border_b  = 0;
            var _border_ac = 0;
            
            var _i = 0;
            repeat(_count)
            {
                var _border_colour = _borderArray[_i];
                _border_r  += colour_get_red(_border_colour);
                _border_g  += colour_get_green(_border_colour);
                _border_b  += colour_get_blue(_border_colour);
                _border_ac += _borderArray[_i+1];
                
                _i += 2;
            }
            
            _border_r  /= _count;
            _border_g  /= _count;
            _border_b  /= _count;
            _border_ac /= _count;
            var _border_cc = make_colour_rgb(_border_r, _border_g, _border_b);
            
            //Set up border state variables
            var _border_c0 = undefined;
            var _border_a0 = undefined;
            var _border_c1 = _borderArray[0];
            var _border_a1 = _borderArray[1];
            var _border_c2 = _borderArray[2];
            var _border_a2 = _borderArray[3];
            
            var _border_c01 = undefined;
            var _border_a01 = undefined;
            
            var _border_c12 = merge_colour(_border_c1, _border_c2, 0.5);
            var _border_a12 = 0.5*(_border_a1 + _border_a2);
            
            //Find the centre of the polygon
            var _cx = 0;
            var _cy = 0;
            
            var _i = 0;
            repeat(_count)
            {
                _cx += _pointArray[_i  ];
                _cy += _pointArray[_i+1];
                _i += 2;
            }
            
            _cx /= _count;
            _cy /= _count;
            
            var _colour = __colour;
            var _alpha  = __alpha;
            
            //Build the polygon
            var _x0 = undefined;
            var _y0 = undefined;
            var _x1 = _pointArray[0];
            var _y1 = _pointArray[1];
            var _x2 = _pointArray[2];
            var _y2 = _pointArray[3];
            
            var _x01 = undefined;
            var _y01 = undefined;
            var _x12 = 0.5*(_x1 + _x2);
            var _y12 = 0.5*(_y1 + _y2);
            
            var _nx1 = undefined;
            var _ny1 = undefined;
            var _ds1 = undefined;
            
            var _nx2 = _x2 - _x1;
            var _ny2 = _y2 - _y1;
            var _n   = 1/sqrt(_nx2*_nx2 + _ny2*_ny2);
            var _tmp =  _nx2;
                _nx2 = -_ny2*_n;
                _ny2 =  _tmp*_n;
            var _ds2 = dot_product(_x2, _y2, _nx2, _ny2);
            
            var _i = 4 mod _size;
            repeat(_count)
            {
                _x0 = _x1;
                _y0 = _y1;
                _x1 = _x2;
                _y1 = _y2;
                _x2 = _pointArray[_i  ];
                _y2 = _pointArray[_i+1];
                
                _x01 = _x12;
                _y01 = _y12;
                
                _x12 = 0.5*(_x1 + _x2);
                _y12 = 0.5*(_y1 + _y2);
                
                _nx1 = _nx2;
                _ny1 = _ny2;
                _ds1 = _ds2;
                
                _nx2 = _x2 - _x1;
                _ny2 = _y2 - _y1;
                _n   = 1/sqrt(_nx2*_nx2 + _ny2*_ny2);
                _tmp =  _nx2;
                _nx2 = -_ny2*_n;
                _ny2 =  _tmp*_n;
                _ds2 = dot_product(_x2, _y2, _nx2, _ny2);
                
                _border_c0 = _border_c1;
                _border_a0 = _border_a1;
                _border_c1 = _border_c2;
                _border_a1 = _border_a2;
                _border_c2 = _borderArray[_i  ];
                _border_a2 = _borderArray[_i+1];
                
                _border_c01 = _border_c12;
                _border_a01 = _border_a12;
                
                _border_c12 = merge_colour(_border_c1, _border_c2, 0.5);
                _border_a12 = 0.5*(_border_a1 + _border_a2);
                
                vertex_position_3d(_vbuff, _cx,  _cy,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, colour_get_red(_border_cc )/255, colour_get_green(_border_cc )/255, colour_get_blue(_border_cc )/255, _border_ac ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x01, _y01, 6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, colour_get_red(_border_c01)/255, colour_get_green(_border_c01)/255, colour_get_blue(_border_c01)/255, _border_a01); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x1,  _y1,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, colour_get_red(_border_c1 )/255, colour_get_green(_border_c1 )/255, colour_get_blue(_border_c1 )/255, _border_a1 ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                
                vertex_position_3d(_vbuff, _cx,  _cy,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, colour_get_red(_border_cc )/255, colour_get_green(_border_cc )/255, colour_get_blue(_border_cc )/255, _border_ac ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x1,  _y1,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, colour_get_red(_border_c1 )/255, colour_get_green(_border_c1 )/255, colour_get_blue(_border_c1 )/255, _border_a1 ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x12, _y12, 6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, colour_get_red(_border_c12)/255, colour_get_green(_border_c12)/255, colour_get_blue(_border_c12)/255, _border_a12); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                
                _i = (_i + 2) mod _size;
            }
            
            #endregion
        }
        else if (_blendIsArray && !_borderIsArray)
        {
            #region  Blend is an array but Border is not
            
            //Unpack the border colour/alpha into components for use when writing the vertex buffer
            var _border_r = colour_get_red(  __borderColour)/255;
            var _border_g = colour_get_green(__borderColour)/255;
            var _border_b = colour_get_blue( __borderColour)/255;
            var _border_a = __borderAlpha;
            
            //Find the centre of the polygon, and also the colour of the centre of the polygon
            var _cx = 0;
            var _cy = 0;
            var _r  = 0;
            var _g  = 0;
            var _b  = 0;
            var _ac = 0;
            
            var _i = 0;
            repeat(_count)
            {
                _cx += _pointArray[_i  ];
                _cy += _pointArray[_i+1];
                
                var _colour = _blendArray[_i];
                _r  += colour_get_red(_colour);
                _g  += colour_get_green(_colour);
                _b  += colour_get_blue(_colour);
                _ac += _blendArray[_i+1];
                
                _i += 2;
            }
            
            _cx /= _count;
            _cy /= _count;
            _r  /= _count;
            _g  /= _count;
            _b  /= _count;
            _ac /= _count;
            var _cc = make_colour_rgb(_r, _g, _b);
            
            //Build the polygon
            var _x0 = undefined;
            var _y0 = undefined;
            var _x1 = _pointArray[0];
            var _y1 = _pointArray[1];
            var _x2 = _pointArray[2];
            var _y2 = _pointArray[3];
            
            var _c0 = undefined;
            var _a0 = undefined;
            var _c1 = _blendArray[0];
            var _a1 = _blendArray[1];
            var _c2 = _blendArray[2];
            var _a2 = _blendArray[3];
            
            var _x01 = undefined;
            var _y01 = undefined;
            var _c01 = undefined;
            var _a01 = undefined;
            
            var _x12 = 0.5*(_x1 + _x2);
            var _y12 = 0.5*(_y1 + _y2);
            var _c12 = merge_colour(_c1, _c2, 0.5);
            var _a12 = 0.5*(_a1 + _a2);
            
            var _nx1 = undefined;
            var _ny1 = undefined;
            var _ds1 = undefined;
            
            var _nx2 = _x2 - _x1;
            var _ny2 = _y2 - _y1;
            var _n   = 1/sqrt(_nx2*_nx2 + _ny2*_ny2);
            var _tmp =  _nx2;
                _nx2 = -_ny2*_n;
                _ny2 =  _tmp*_n;
            var _ds2 = dot_product(_x2, _y2, _nx2, _ny2);
            
            var _i = 4 mod _size;
            repeat(_count)
            {
                _x0 = _x1;
                _y0 = _y1;
                _x1 = _x2;
                _y1 = _y2;
                _x2 = _pointArray[_i  ];
                _y2 = _pointArray[_i+1];
                
                _c0 = _c1;
                _a0 = _a1;
                _c1 = _c2;
                _a1 = _a2;
                _c2 = _blendArray[_i  ];
                _a2 = _blendArray[_i+1];
                
                _x01 = _x12;
                _y01 = _y12;
                _c01 = _c12;
                _a01 = _a12;
                
                _x12 = 0.5*(_x1 + _x2);
                _y12 = 0.5*(_y1 + _y2);
                _c12 = merge_colour(_c1, _c2, 0.5);
                _a12 = 0.5*(_a1 + _a2);
                
                _nx1 = _nx2;
                _ny1 = _ny2;
                _ds1 = _ds2;
                
                _nx2 = _x2 - _x1;
                _ny2 = _y2 - _y1;
                _n   = 1/sqrt(_nx2*_nx2 + _ny2*_ny2);
                _tmp =  _nx2;
                _nx2 = -_ny2*_n;
                _ny2 =  _tmp*_n;
                _ds2 = dot_product(_x2, _y2, _nx2, _ny2);
                
                vertex_position_3d(_vbuff, _cx,  _cy,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _cc,  _ac ); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x01, _y01, 6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _c01, _a01); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x1,  _y1,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _c1,  _a1 ); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                
                vertex_position_3d(_vbuff, _cx,  _cy,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _cc,  _ac ); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x1,  _y1,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _c1,  _a1 ); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x12, _y12, 6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                
                _i = (_i + 2) mod _size;
            }
            
            #endregion
        }
        else
        {
            #region Blend + Border are both arrays
            
            //Calculate the inner border colour of the middle of the polygon by using a simple mean average
            //This seems a little silly - the inside of the shape will have no border obviously - but it ensures the interpolation works correctly
            var _border_r  = 0;
            var _border_g  = 0;
            var _border_b  = 0;
            var _border_ac = 0;
            
            var _i = 0;
            repeat(_count)
            {
                var _border_colour = _borderArray[_i];
                _border_r  += colour_get_red(_border_colour);
                _border_g  += colour_get_green(_border_colour);
                _border_b  += colour_get_blue(_border_colour);
                _border_ac += _borderArray[_i+1];
                
                _i += 2;
            }
            
            _border_r  /= _count;
            _border_g  /= _count;
            _border_b  /= _count;
            _border_ac /= _count;
            var _border_cc = make_colour_rgb(_border_r, _border_g, _border_b);
            
            var _border_c0 = undefined;
            var _border_a0 = undefined;
            var _border_c1 = _borderArray[0];
            var _border_a1 = _borderArray[1];
            var _border_c2 = _borderArray[2];
            var _border_a2 = _borderArray[3];
            
            var _border_c01 = undefined;
            var _border_a01 = undefined;
            
            var _border_c12 = merge_colour(_border_c1, _border_c2, 0.5);
            var _border_a12 = 0.5*(_border_a1 + _border_a2);
            
            //Find the centre of the polygon, and also the colour of the centre of the polygon
            var _cx = 0;
            var _cy = 0;
            var _r  = 0;
            var _g  = 0;
            var _b  = 0;
            var _ac = 0;
            
            var _i = 0;
            repeat(_count)
            {
                _cx += _pointArray[_i  ];
                _cy += _pointArray[_i+1];
                
                var _colour = _blendArray[_i];
                _r  += colour_get_red(_colour);
                _g  += colour_get_green(_colour);
                _b  += colour_get_blue(_colour);
                _ac += _blendArray[_i+1];
                
                _i += 2;
            }
            
            _cx /= _count;
            _cy /= _count;
            _r  /= _count;
            _g  /= _count;
            _b  /= _count;
            _ac /= _count;
            var _cc = make_colour_rgb(_r, _g, _b);
            
            //Build the polygon
            var _x0 = undefined;
            var _y0 = undefined;
            var _x1 = _pointArray[0];
            var _y1 = _pointArray[1];
            var _x2 = _pointArray[2];
            var _y2 = _pointArray[3];
            
            var _c0 = undefined;
            var _a0 = undefined;
            var _c1 = _blendArray[0];
            var _a1 = _blendArray[1];
            var _c2 = _blendArray[2];
            var _a2 = _blendArray[3];
            
            var _x01 = undefined;
            var _y01 = undefined;
            var _c01 = undefined;
            var _a01 = undefined;
            
            var _x12 = 0.5*(_x1 + _x2);
            var _y12 = 0.5*(_y1 + _y2);
            var _c12 = merge_colour(_c1, _c2, 0.5);
            var _a12 = 0.5*(_a1 + _a2);
            
            var _nx1 = undefined;
            var _ny1 = undefined;
            var _ds1 = undefined;
            
            var _nx2 = _x2 - _x1;
            var _ny2 = _y2 - _y1;
            var _n   = 1/sqrt(_nx2*_nx2 + _ny2*_ny2);
            var _tmp =  _nx2;
                _nx2 = -_ny2*_n;
                _ny2 =  _tmp*_n;
            var _ds2 = dot_product(_x2, _y2, _nx2, _ny2);
            
            var _i = 4 mod _size;
            repeat(_count)
            {
                _x0 = _x1;
                _y0 = _y1;
                _x1 = _x2;
                _y1 = _y2;
                _x2 = _pointArray[_i  ];
                _y2 = _pointArray[_i+1];
                
                _c0 = _c1;
                _a0 = _a1;
                _c1 = _c2;
                _a1 = _a2;
                _c2 = _blendArray[_i  ];
                _a2 = _blendArray[_i+1];
                
                _x01 = _x12;
                _y01 = _y12;
                _c01 = _c12;
                _a01 = _a12;
                
                _x12 = 0.5*(_x1 + _x2);
                _y12 = 0.5*(_y1 + _y2);
                _c12 = merge_colour(_c1, _c2, 0.5);
                _a12 = 0.5*(_a1 + _a2);
                
                _nx1 = _nx2;
                _ny1 = _ny2;
                _ds1 = _ds2;
                
                _nx2 = _x2 - _x1;
                _ny2 = _y2 - _y1;
                _n   = 1/sqrt(_nx2*_nx2 + _ny2*_ny2);
                _tmp =  _nx2;
                _nx2 = -_ny2*_n;
                _ny2 =  _tmp*_n;
                _ds2 = dot_product(_x2, _y2, _nx2, _ny2);
                
                _border_c0 = _border_c1;
                _border_a0 = _border_a1;
                _border_c1 = _border_c2;
                _border_a1 = _border_a2;
                _border_c2 = _borderArray[_i  ];
                _border_a2 = _borderArray[_i+1];
                
                _border_c01 = _border_c12;
                _border_a01 = _border_a12;
                
                _border_c12 = merge_colour(_border_c1, _border_c2, 0.5);
                _border_a12 = 0.5*(_border_a1 + _border_a2);
                
                vertex_position_3d(_vbuff, _cx,  _cy,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _cc,  _ac ); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, colour_get_red(_border_cc )/255, colour_get_green(_border_cc )/255, colour_get_blue(_border_cc )/255, _border_ac ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x01, _y01, 6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _c01, _a01); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, colour_get_red(_border_c01)/255, colour_get_green(_border_c01)/255, colour_get_blue(_border_c01)/255, _border_a01); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x1,  _y1,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _c1,  _a1 ); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, colour_get_red(_border_c1 )/255, colour_get_green(_border_c1 )/255, colour_get_blue(_border_c1 )/255, _border_a1 ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                
                vertex_position_3d(_vbuff, _cx,  _cy,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _cc,  _ac ); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, colour_get_red(_border_cc )/255, colour_get_green(_border_cc )/255, colour_get_blue(_border_cc )/255, _border_ac ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x1,  _y1,  6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _c1,  _a1 ); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, colour_get_red(_border_c1 )/255, colour_get_green(_border_c1 )/255, colour_get_blue(_border_c1 )/255, _border_a1 ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                vertex_position_3d(_vbuff, _x12, _y12, 6); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, colour_get_red(_border_c12)/255, colour_get_green(_border_c12)/255, colour_get_blue(_border_c12)/255, _border_a12); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                
                _i = (_i + 2) mod _size;
            }
            
            #endregion
        }
        
        return undefined;
    }
}