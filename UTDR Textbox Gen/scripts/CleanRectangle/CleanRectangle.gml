/// @param left
/// @param top
/// @param right
/// @param bottom

function CleanRectangle(_left, _top, _right, _bottom)
{
    return new __CleanClassRectangle(_left, _top, _right, _bottom);
}

function __CleanClassRectangle(_left, _top, _right, _bottom) constructor
{
    __left   = min(_left, _right);
    __top    = min(_top, _bottom);
    __right  = max(_left, _right);
    __bottom = max(_top, _bottom);
    
    __colour1 = CLEAN_DEFAULT_RECTANGLE_COLOUR;
    __alpha1  = CLEAN_DEFAULT_RECTANGLE_ALPHA;
    __colour2 = CLEAN_DEFAULT_RECTANGLE_COLOUR;
    __alpha2  = CLEAN_DEFAULT_RECTANGLE_ALPHA;
    __colour3 = CLEAN_DEFAULT_RECTANGLE_COLOUR;
    __alpha3  = CLEAN_DEFAULT_RECTANGLE_ALPHA;
    __colour4 = CLEAN_DEFAULT_RECTANGLE_COLOUR;
    __alpha4  = CLEAN_DEFAULT_RECTANGLE_ALPHA;
    
    __borderThickness = CLEAN_DEFAULT_RECTANGLE_BORDER_THICKNESS;
    __borderColour1    = CLEAN_DEFAULT_RECTANGLE_BORDER_COLOUR;
    __borderAlpha1     = CLEAN_DEFAULT_RECTANGLE_BORDER_ALPHA;
    __borderColour2    = CLEAN_DEFAULT_RECTANGLE_BORDER_COLOUR;
    __borderAlpha2     = CLEAN_DEFAULT_RECTANGLE_BORDER_ALPHA;
    __borderColour3    = CLEAN_DEFAULT_RECTANGLE_BORDER_COLOUR;
    __borderAlpha3     = CLEAN_DEFAULT_RECTANGLE_BORDER_ALPHA;
    __borderColour4    = CLEAN_DEFAULT_RECTANGLE_BORDER_COLOUR;
    __borderAlpha4     = CLEAN_DEFAULT_RECTANGLE_BORDER_ALPHA;
    
    __rounding = CLEAN_DEFAULT_RECTANGLE_ROUNDING;
    __rotation = 0;
    
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
        __colour4 = _colour;
        __alpha4  = _alpha;
        
        return self;
    }
    
    /// @param color1
    /// @param alpha1
    /// @param color2
    /// @param alpha2
    /// @param color3
    /// @param alpha3
    /// @param color4
    /// @param alpha4
    static Blend4 = function(_colour1, _alpha1, _colour2, _alpha2, _colour3, _alpha3, _colour4, _alpha4)
    {
        __colour1 = _colour1;
        __alpha1  = _alpha1;
        __colour2 = _colour2;
        __alpha2  = _alpha2;
        __colour3 = _colour3;
        __alpha3  = _alpha3;
        __colour4 = _colour4;
        __alpha4  = _alpha4;
        
        return self;
    }
    
    static Border = function(_thickness, _colour, _alpha)
    {
        __borderThickness = _thickness;
        __borderColour1 = _colour;
        __borderAlpha1  = _alpha;
        __borderColour2 = _colour;
        __borderAlpha2  = _alpha;
        __borderColour3 = _colour;
        __borderAlpha3  = _alpha;
        __borderColour4 = _colour;
        __borderAlpha4  = _alpha;
        
        return self;
    }
    
    static Border4 = function(_thickness, _colour1, _alpha1, _colour2, _alpha2, _colour3, _alpha3, _colour4, _alpha4)
    {
        __borderThickness = _thickness;
        __borderColour1 = _colour1;
        __borderAlpha1  = _alpha1;
        __borderColour2 = _colour2;
        __borderAlpha2  = _alpha2;
        __borderColour3 = _colour3;
        __borderAlpha3  = _alpha3;
        __borderColour4 = _colour4;
        __borderAlpha4  = _alpha4;
        
        return self;
    }
    
    /// @param radius
    static Rounding = function(_radius)
    {
        __rounding = _radius;
        
        return self;
    }
    
    /// @param angle
    static Rotate = function(_angle)
    {
        __rotation = _angle;
        
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
        var _rotation        = degtorad(__rotation);
        var _borderThickness = __borderThickness;
        
        var _border_r1 = colour_get_red(  __borderColour1)/255;
        var _border_g1 = colour_get_green(__borderColour1)/255;
        var _border_b1 = colour_get_blue( __borderColour1)/255;
        var _border_a1 = __borderAlpha1;
        var _border_r2 = colour_get_red(  __borderColour2)/255;
        var _border_g2 = colour_get_green(__borderColour2)/255;
        var _border_b2 = colour_get_blue( __borderColour2)/255;
        var _border_a2 = __borderAlpha2;
        var _border_r3 = colour_get_red(  __borderColour3)/255;
        var _border_g3 = colour_get_green(__borderColour3)/255;
        var _border_b3 = colour_get_blue( __borderColour3)/255;
        var _border_a3 = __borderAlpha3;
        var _border_r4 = colour_get_red(  __borderColour4)/255;
        var _border_g4 = colour_get_green(__borderColour4)/255;
        var _border_b4 = colour_get_blue( __borderColour4)/255;
        var _border_a4 = __borderAlpha4;
        
        var _c1  = __colour1;
        var _c2  = __colour2;
        var _c3  = __colour3;
        var _c4  = __colour4;
        var _a1  = __alpha1;
        var _a2  = __alpha2;
        var _a3  = __alpha3;
        var _a4  = __alpha4;
        
        var _l = __left;
        var _t = __top;
        var _r = __right;
        var _b = __bottom;
        
        var _w  = _r - _l;
        var _h  = _b - _t;
        var _cx = 0.5*(_l + _r);
        var _cy = 0.5*(_t + _b);
        
        if (__rotation == 0)
        {
            vertex_position_3d(_vbuff, _l, _t, 2                  ); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c1, _a1); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r1, _border_g1, _border_b1, _border_a1); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _r, _t, 2 + __CLEAN_FLAG_A ); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c2, _a2); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r2, _border_g2, _border_b2, _border_a2); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _r, _b, 2 + __CLEAN_FLAG_AB); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c4, _a4); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r4, _border_g4, _border_b4, _border_a4); vertex_texcoord(_vbuff, _rounding, _borderThickness);
                                                
            vertex_position_3d(_vbuff, _l, _t, 2                  ); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c1, _a1); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r1, _border_g1, _border_b1, _border_a1); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _r, _b, 2 + __CLEAN_FLAG_AB); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c4, _a4); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r4, _border_g4, _border_b4, _border_a4); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _l, _b, 2 + __CLEAN_FLAG_B ); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c3, _a3); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r3, _border_g3, _border_b3, _border_a3); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        }
        else
        {
            var _hw = 0.5*_w;
            var _hh = 0.5*_h;
            
            var _sin = sin(-_rotation);
            var _cos = cos(-_rotation);
            
            var _w_sin = _hw*_sin;
            var _w_cos = _hw*_cos;
            var _h_sin = _hh*_sin;
            var _h_cos = _hh*_cos;
            
            var _ox1 = _cx - _w_cos + _h_sin;
            var _oy1 = _cy - _w_sin - _h_cos;
            var _ox2 = _cx + _w_cos + _h_sin;
            var _oy2 = _cy + _w_sin - _h_cos;
            var _ox3 = _cx - _w_cos - _h_sin;
            var _oy3 = _cy - _w_sin + _h_cos;
            var _ox4 = _cx + _w_cos - _h_sin;
            var _oy4 = _cy + _w_sin + _h_cos;
            
            vertex_position_3d(_vbuff, _ox1, _oy1, 2                  ); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c1, _a1); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r1, _border_g1, _border_b1, _border_a1); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _ox2, _oy2, 2 + __CLEAN_FLAG_A ); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c2, _a2); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r2, _border_g2, _border_b2, _border_a2); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _ox4, _oy4, 2 + __CLEAN_FLAG_AB); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c4, _a4); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r4, _border_g4, _border_b4, _border_a4); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            
            vertex_position_3d(_vbuff, _ox1, _oy1, 2                  ); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c1, _a1); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r1, _border_g1, _border_b1, _border_a1); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _ox4, _oy4, 2 + __CLEAN_FLAG_AB); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c4, _a4); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r4, _border_g4, _border_b4, _border_a4); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _ox3, _oy3, 2 + __CLEAN_FLAG_B ); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c3, _a3); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r3, _border_g3, _border_b3, _border_a3); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        }
        
        return undefined;
    }
}