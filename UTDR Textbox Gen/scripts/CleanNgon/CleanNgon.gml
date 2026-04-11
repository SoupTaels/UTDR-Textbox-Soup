/// @param x
/// @param y
/// @param radius
/// @param sides

function CleanNgon(_x, _y, _radius, _sides)
{
    return new __CleanClassNgon(_x, _y, _radius, _sides);
}

function __CleanClassNgon(_x, _y, _radius, _sides) constructor
{
    __x      = _x;
    __y      = _y;
    __radius = _radius;
    __sides  = _sides;
    
    __colour = CLEAN_DEFAULT_NGON_COLOUR;
    __alpha  = CLEAN_DEFAULT_NGON_ALPHA;
    
    __borderThickness = CLEAN_DEFAULT_NGON_BORDER_THICKNESS;
    __borderColour    = CLEAN_DEFAULT_NGON_BORDER_COLOUR;
    __borderAlpha     = CLEAN_DEFAULT_NGON_BORDER_ALPHA;
    
    __rounding   = CLEAN_DEFAULT_NGON_ROUNDING;
    __starFactor = CLEAN_DEFAULT_NGON_STAR_FACTOR;
    __rotation   = 0;
    
    /// @param color
    /// @param alpha
    static Blend = function(_colour, _alpha)
    {
        __colour = _colour;
        __alpha  = _alpha;
        
        return self;
    }
    
    /// @param thickness
    /// @param colour
    /// @param alpha
    static Border = function(_thickness, _colour, _alpha)
    {
        __borderThickness = _thickness;
        __borderColour    = _colour;
        __borderAlpha     = _alpha;
        
        return self;
    }
    
    /// @param factor
    static Star = function(_factor)
    {
        __starFactor = _factor;
        
        return self;
    }
    
    /// @param angle
    static Rotate = function(_angle)
    {
        __rotation = _angle;
        
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
        var _x     = __x;
        var _y     = __y;
        var _r     = __radius;
        var _sides = __sides;
        
        var _colour = __colour;
        var _alpha  = __alpha;
        
        var _borderR = colour_get_red(  __borderColour)/255;
        var _borderG = colour_get_green(__borderColour)/255;
        var _borderB = colour_get_blue( __borderColour)/255;
        var _borderA = __borderAlpha;
        var _borderThickness = __borderThickness;
        
        var _rounding   = __rounding;
        var _starFactor = lerp(2, _sides, 0.9*__starFactor*__starFactor);
        var _rotation   = degtorad(__rotation);
        
        vertex_position_3d(_vbuff, _x-_r, _y-_r, 10); vertex_normal(_vbuff, _x, _y, _r); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _sides, _starFactor, _rotation); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x+_r, _y-_r, 10); vertex_normal(_vbuff, _x, _y, _r); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _sides, _starFactor, _rotation); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x-_r, _y+_r, 10); vertex_normal(_vbuff, _x, _y, _r); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _sides, _starFactor, _rotation); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        vertex_position_3d(_vbuff, _x+_r, _y-_r, 10); vertex_normal(_vbuff, _x, _y, _r); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _sides, _starFactor, _rotation); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x-_r, _y+_r, 10); vertex_normal(_vbuff, _x, _y, _r); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _sides, _starFactor, _rotation); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x+_r, _y+_r, 10); vertex_normal(_vbuff, _x, _y, _r); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _sides, _starFactor, _rotation); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        return undefined;
    }
}