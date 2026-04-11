/// @param x1
/// @param y1
/// @param x2
/// @param y2
/// @param x3
/// @param y3

function CleanTriangle(_x1, _y1, _x2, _y2, _x3, _y3)
{
    return new __CleanClassTriangle(_x1, _y1, _x2, _y2, _x3, _y3);
}

function __CleanClassTriangle(_x1, _y1, _x2, _y2, _x3, _y3) constructor
{
    __x1 = _x1;
    __y1 = _y1;
    __x2 = _x2;
    __y2 = _y2;
    __x3 = _x3;
    __y3 = _y3;
    
    __colour1 = CLEAN_DEFAULT_TRIANGLE_COLOUR;
    __alpha1  = CLEAN_DEFAULT_TRIANGLE_ALPHA;
    __colour2 = CLEAN_DEFAULT_TRIANGLE_COLOUR;
    __alpha2  = CLEAN_DEFAULT_TRIANGLE_ALPHA;
    __colour3 = CLEAN_DEFAULT_TRIANGLE_COLOUR;
    __alpha3  = CLEAN_DEFAULT_TRIANGLE_ALPHA;
    
    __borderThickness = CLEAN_DEFAULT_TRIANGLE_BORDER_THICKNESS;
    __borderColour1   = CLEAN_DEFAULT_TRIANGLE_BORDER_COLOUR;
    __borderAlpha1    = CLEAN_DEFAULT_TRIANGLE_BORDER_ALPHA;
    __borderColour2   = CLEAN_DEFAULT_TRIANGLE_BORDER_COLOUR;
    __borderAlpha2    = CLEAN_DEFAULT_TRIANGLE_BORDER_ALPHA;
    __borderColour3   = CLEAN_DEFAULT_TRIANGLE_BORDER_COLOUR;
    __borderAlpha3    = CLEAN_DEFAULT_TRIANGLE_BORDER_ALPHA;
    
    __rounding = CLEAN_DEFAULT_TRIANGLE_ROUNDING;
    
    /// @param color
    /// @param alpha
    static Blend = function(_colour, _alpha)
    {
        __colour1 = _colour;
        __alpha1  = _alpha;
        __colour2 = _colour;
        __alpha2  = _alpha;
        __colour3 = _colour;
        __alpha3  = _alpha;
        
        return self;
    }
    
    /// @param color1
    /// @param alpha1
    /// @param color2
    /// @param alpha2
    /// @param color3
    /// @param alpha3
    static Blend3 = function(_colour1, _alpha1, _colour2, _alpha2, _colour3, _alpha3)
    {
        __colour1 = _colour1;
        __alpha1  = _alpha1;
        __colour2 = _colour2;
        __alpha2  = _alpha2;
        __colour3 = _colour3;
        __alpha3  = _alpha3;
        
        return self;
    }
    
    static Border = function(_thickness, _colour, _alpha)
    {
        __borderThickness = _thickness;
        __borderColour1    = _colour;
        __borderAlpha1     = _alpha;
        __borderColour2    = _colour;
        __borderAlpha2     = _alpha;
        __borderColour3    = _colour;
        __borderAlpha3     = _alpha;
        
        return self;
    }
    
    static Border3 = function(_thickness, _colour1, _alpha1, _colour2, _alpha2, _colour3, _alpha3)
    {
        __borderThickness = _thickness;
        __borderColour1    = _colour1;
        __borderAlpha1     = _alpha1;
        __borderColour2    = _colour2;
        __borderAlpha2     = _alpha2;
        __borderColour3    = _colour3;
        __borderAlpha3     = _alpha3;
        
        return self;
    }
    
    /// @param radius
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
        var _rounding        = __rounding;
        var _borderThickness = __borderThickness;
        
        if ((CLEAN_TRIANGLE_FIX_COUNTERCLOCKWISE_POINTS || CLEAN_TRIANGLE_ERROR_COUNTERCLOCKWISE_POINTS)
        &&  !__CleanIsClockwise(__x1, __y1, __x2, __y2, __x3, __y3))
        {
            if (CLEAN_TRIANGLE_ERROR_COUNTERCLOCKWISE_POINTS)
            {
                __CleanError("Triangle defined with counter-clockwise coordinates\nTriangles should be defined using clockwise coodinates\n(Set CLEAN_TRIANGLE_ERROR_COUNTERCLOCKWISE_POINTS to <false> to turn off this error)\n(Set CLEAN_TRIANGLE_FIX_COUNTERCLOCKWISE_POINTS to <true> to *slowly* fix point ordering automatically)\n \n{", __x1, ",", __y1, ",  ", __x2, ",", __y2, ",  ", __x3, ",", __y3, "}");
            }
            
            var _x1 = __x1;
            var _y1 = __y1;
            var _x2 = __x3;
            var _y2 = __y3;
            var _x3 = __x2;
            var _y3 = __y2;
            
            var _c1 = __colour1;
            var _a1 = __alpha1;
            var _c2 = __colour3;
            var _a2 = __alpha3;
            var _c3 = __colour2;
            var _a3 = __alpha2;
            
            var _border_c1 = __borderColour1;
            var _border_a1 = __borderAlpha1;
            var _border_c2 = __borderColour3;
            var _border_a2 = __borderAlpha3;
            var _border_c3 = __borderColour2;
            var _border_a3 = __borderAlpha2;
        }
        else
        {
            var _x1 = __x1;
            var _y1 = __y1;
            var _x2 = __x2;
            var _y2 = __y2;
            var _x3 = __x3;
            var _y3 = __y3;
            
            var _c1 = __colour1;
            var _c2 = __colour2;
            var _c3 = __colour3;
            var _a1 = __alpha1;
            var _a2 = __alpha2;
            var _a3 = __alpha3;
            
            var _border_c1 = __borderColour1;
            var _border_a1 = __borderAlpha1;
            var _border_c2 = __borderColour2;
            var _border_a2 = __borderAlpha2;
            var _border_c3 = __borderColour3;
            var _border_a3 = __borderAlpha3;
        }
        
        var _border_r1 = colour_get_red(  _border_c1)/255;
        var _border_g1 = colour_get_green(_border_c1)/255;
        var _border_b1 = colour_get_blue( _border_c1)/255;
        var _border_a1 = _border_a1;
        
        var _border_r2 = colour_get_red(  _border_c2)/255;
        var _border_g2 = colour_get_green(_border_c2)/255;
        var _border_b2 = colour_get_blue( _border_c2)/255;
        var _border_a2 = _border_a2;
        
        var _border_r3 = colour_get_red(  _border_c3)/255;
        var _border_g3 = colour_get_green(_border_c3)/255;
        var _border_b3 = colour_get_blue( _border_c3)/255;
        var _border_a3 = _border_a3;
        
        var _border_rc = 0.3333*(_border_r1 + _border_r2 + _border_r3);
        var _border_gc = 0.3333*(_border_g1 + _border_g2 + _border_g3);
        var _border_bc = 0.3333*(_border_b1 + _border_b2 + _border_b3);
        var _border_ac = 0.3333*(_border_a1 + _border_a2 + _border_a3);
        
        var _border_c12 = merge_colour(_border_c1, _border_c2, 0.5);
        var _border_c23 = merge_colour(_border_c2, _border_c3, 0.5);
        var _border_c31 = merge_colour(_border_c3, _border_c1, 0.5);
        
        var _border_r12 = colour_get_red(  _border_c12)/255;
        var _border_g12 = colour_get_green(_border_c12)/255;
        var _border_b12 = colour_get_blue( _border_c12)/255;
        var _border_a12 = lerp(_border_a1, _border_a2, 0.5);
        
        var _border_r23 = colour_get_red(  _border_c23)/255;
        var _border_g23 = colour_get_green(_border_c23)/255;
        var _border_b23 = colour_get_blue( _border_c23)/255;
        var _border_a23 = lerp(_border_a2, _border_a3, 0.5);
        
        var _border_r31 = colour_get_red(  _border_c31)/255;
        var _border_g31 = colour_get_green(_border_c31)/255;
        var _border_b31 = colour_get_blue( _border_c31)/255;
        var _border_a31 = lerp(_border_a3, _border_a1, 0.5);
        
        var _cx = 0.3333*(_x1 + _x2 + _x3);
        var _cy = 0.3333*(_y1 + _y2 + _y3);
        
        var _cc = make_colour_rgb(0.3333*(colour_get_red(  _c1) + colour_get_red(  _c2) + colour_get_red(  _c3)),
                                  0.3333*(colour_get_green(_c1) + colour_get_green(_c2) + colour_get_green(_c3)),
                                  0.3333*(colour_get_blue( _c1) + colour_get_blue( _c2) + colour_get_blue( _c3)));
        var _ac = 0.3333*(_a1 + _a2 + _a3);
        
        var _c12 = merge_colour(_c1, _c2, 0.5);
        var _c23 = merge_colour(_c2, _c3, 0.5);
        var _c31 = merge_colour(_c3, _c1, 0.5);
        
        var _a12 = 0.5*(_a1 + _a2);
        var _a23 = 0.5*(_a2 + _a3);
        var _a31 = 0.5*(_a3 + _a1);
        
        var _x12 = 0.5*(_x1 + _x2);
        var _y12 = 0.5*(_y1 + _y2);
        var _x23 = 0.5*(_x2 + _x3);
        var _y23 = 0.5*(_y2 + _y3);
        var _x31 = 0.5*(_x3 + _x1);
        var _y31 = 0.5*(_y3 + _y1);
        
        var _nx12 = _x2 - _x1;
        var _ny12 = _y2 - _y1;
        var _n    = 1/sqrt(_nx12*_nx12 + _ny12*_ny12);
        var _tmp  =  _nx12;
            _nx12 = -_ny12*_n;
            _ny12 =  _tmp*_n;
        var _ds12 = dot_product(_x2, _y2, _nx12, _ny12);
        
        var _nx23 = _x3 - _x2;
        var _ny23 = _y3 - _y2;
        var _n    = 1/sqrt(_nx23*_nx23 + _ny23*_ny23);
        var _tmp  =  _nx23;
            _nx23 = -_ny23*_n;
            _ny23 =  _tmp*_n;
        var _ds23 = dot_product(_x3, _y3, _nx23, _ny23);
        
        var _nx31 = _x1 - _x3;
        var _ny31 = _y1 - _y3;
        var _n    = 1/sqrt(_nx31*_nx31 + _ny31*_ny31);
        var _tmp  =  _nx31;
            _nx31 = -_ny31*_n;
           _ny31 =  _tmp*_n;
        var _ds31 = dot_product(_x1, _y1, _nx31, _ny31);
        
        //Corner 1
        vertex_position_3d(_vbuff,  _cx,  _cy, 6); vertex_normal(_vbuff, _nx31, _ny31, _ds31); vertex_colour(_vbuff, _cc,  _ac ); vertex_float3(_vbuff, _nx12, _ny12, _ds12); vertex_float4(_vbuff, _border_rc,  _border_gc,  _border_bc,  _border_ac ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x31, _y31, 6); vertex_normal(_vbuff, _nx31, _ny31, _ds31); vertex_colour(_vbuff, _c31, _a31); vertex_float3(_vbuff, _nx12, _ny12, _ds12); vertex_float4(_vbuff, _border_r31, _border_g31, _border_b31, _border_a31); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff,  _x1,  _y1, 6); vertex_normal(_vbuff, _nx31, _ny31, _ds31); vertex_colour(_vbuff, _c1,  _a1 ); vertex_float3(_vbuff, _nx12, _ny12, _ds12); vertex_float4(_vbuff, _border_r1,  _border_g1,  _border_b1,  _border_a1 ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        vertex_position_3d(_vbuff,  _cx,  _cy, 6); vertex_normal(_vbuff, _nx31, _ny31, _ds31); vertex_colour(_vbuff, _cc,  _ac ); vertex_float3(_vbuff, _nx12, _ny12, _ds12); vertex_float4(_vbuff, _border_rc,  _border_gc,  _border_bc,  _border_ac ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff,  _x1,  _y1, 6); vertex_normal(_vbuff, _nx31, _ny31, _ds31); vertex_colour(_vbuff, _c1,  _a1 ); vertex_float3(_vbuff, _nx12, _ny12, _ds12); vertex_float4(_vbuff, _border_r1,  _border_g1,  _border_b1,  _border_a1 ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x12, _y12, 6); vertex_normal(_vbuff, _nx31, _ny31, _ds31); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _nx12, _ny12, _ds12); vertex_float4(_vbuff, _border_r12, _border_g12, _border_b12, _border_a12); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        //Corner 2
        vertex_position_3d(_vbuff,  _cx,  _cy, 6); vertex_normal(_vbuff, _nx12, _ny12, _ds12); vertex_colour(_vbuff, _cc,  _ac ); vertex_float3(_vbuff, _nx23, _ny23, _ds23); vertex_float4(_vbuff, _border_rc,  _border_gc,  _border_bc,  _border_ac ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x12, _y12, 6); vertex_normal(_vbuff, _nx12, _ny12, _ds12); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _nx23, _ny23, _ds23); vertex_float4(_vbuff, _border_r12, _border_g12, _border_b12, _border_a12); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff,  _x2,  _y2, 6); vertex_normal(_vbuff, _nx12, _ny12, _ds12); vertex_colour(_vbuff, _c2,  _a2 ); vertex_float3(_vbuff, _nx23, _ny23, _ds23); vertex_float4(_vbuff, _border_r2,  _border_g2,  _border_b2,  _border_a2 ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        vertex_position_3d(_vbuff,  _cx,  _cy, 6); vertex_normal(_vbuff, _nx12, _ny12, _ds12); vertex_colour(_vbuff, _cc,  _ac ); vertex_float3(_vbuff, _nx23, _ny23, _ds23); vertex_float4(_vbuff, _border_rc,  _border_gc,  _border_bc,  _border_ac ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff,  _x2,  _y2, 6); vertex_normal(_vbuff, _nx12, _ny12, _ds12); vertex_colour(_vbuff, _c2,  _a2 ); vertex_float3(_vbuff, _nx23, _ny23, _ds23); vertex_float4(_vbuff, _border_r2,  _border_g2,  _border_b2,  _border_a2 ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x23, _y23, 6); vertex_normal(_vbuff, _nx12, _ny12, _ds12); vertex_colour(_vbuff, _c23, _a23); vertex_float3(_vbuff, _nx23, _ny23, _ds23); vertex_float4(_vbuff, _border_r23, _border_g23, _border_b23, _border_a23); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        //Corner 3
        vertex_position_3d(_vbuff,  _cx,  _cy, 6); vertex_normal(_vbuff, _nx23, _ny23, _ds23); vertex_colour(_vbuff, _cc,  _ac ); vertex_float3(_vbuff, _nx31, _ny31, _ds31); vertex_float4(_vbuff, _border_rc,  _border_gc,  _border_bc,  _border_ac ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x23, _y23, 6); vertex_normal(_vbuff, _nx23, _ny23, _ds23); vertex_colour(_vbuff, _c23, _a23); vertex_float3(_vbuff, _nx31, _ny31, _ds31); vertex_float4(_vbuff, _border_r23, _border_g23, _border_b23, _border_a23); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff,  _x3,  _y3, 6); vertex_normal(_vbuff, _nx23, _ny23, _ds23); vertex_colour(_vbuff, _c3,  _a3 ); vertex_float3(_vbuff, _nx31, _ny31, _ds31); vertex_float4(_vbuff, _border_r3,  _border_g3,  _border_b3,  _border_a3 ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        vertex_position_3d(_vbuff,  _cx,  _cy, 6); vertex_normal(_vbuff, _nx23, _ny23, _ds23); vertex_colour(_vbuff, _cc,  _ac ); vertex_float3(_vbuff, _nx31, _ny31, _ds31); vertex_float4(_vbuff, _border_rc,  _border_gc,  _border_bc,  _border_ac ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff,  _x3,  _y3, 6); vertex_normal(_vbuff, _nx23, _ny23, _ds23); vertex_colour(_vbuff, _c3,  _a3 ); vertex_float3(_vbuff, _nx31, _ny31, _ds31); vertex_float4(_vbuff, _border_r3,  _border_g3,  _border_b3,  _border_a3 ); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x31, _y31, 6); vertex_normal(_vbuff, _nx23, _ny23, _ds23); vertex_colour(_vbuff, _c31, _a31); vertex_float3(_vbuff, _nx31, _ny31, _ds31); vertex_float4(_vbuff, _border_r31, _border_g31, _border_b31, _border_a31); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        return undefined;
    }
}