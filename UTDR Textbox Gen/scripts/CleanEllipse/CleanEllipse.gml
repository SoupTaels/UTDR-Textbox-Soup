/// @param x
/// @param y
/// @param radiusX
/// @param radiusY

function CleanEllipse(_x, _y, _radiusX, _radiusY)
{
    return new __CleanClassEllipse(_x, _y, _radiusX, _radiusY);
}

function __CleanClassEllipse(_x, _y, _radiusX, _radiusY) constructor
{
    __x       = _x;
    __y       = _y;
    __radiusX = _radiusX;
    __radiusY = _radiusY;
    
    __colourOuter = CLEAN_DEFAULT_CIRCLE_OUTER_COLOUR;
    __alphaOuter  = CLEAN_DEFAULT_CIRCLE_OUTER_ALPHA;
    __colourInner = CLEAN_DEFAULT_CIRCLE_INNER_COLOUR;
    __alphaInner  = CLEAN_DEFAULT_CIRCLE_INNER_ALPHA;
    
    __borderThickness = CLEAN_DEFAULT_CIRCLE_BORDER_THICKNESS;
    __borderColour    = CLEAN_DEFAULT_CIRCLE_BORDER_COLOUR;
    __borderAlpha     = CLEAN_DEFAULT_CIRCLE_BORDER_ALPHA;
    
    /// @param color
    /// @param alpha
    static Blend = function(_colour, _alpha)
    {
        __colourOuter = _colour;
        __alphaOuter  = _alpha;
        __colourInner = _colour;
        __alphaInner  = _alpha;
        
        return self;
    }
    
    /// @param colorInner
    /// @param alphaInner
    /// @param colorOuter
    /// @param alphaOuter
    static BlendRadial = function(_colourInner, _alphaInner, _colourOuter, _alphaOuter)
    {
        __colourOuter = _colourOuter;
        __alphaOuter  = _alphaOuter;
        __colourInner = _colourInner;
        __alphaInner  = _alphaInner;
        
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
    
    static Draw = function()
    {
        __CleanDraw();
        return undefined;
    }
    
    /// @param vertexBuffer
    static __Build = function(_vbuff)
    {
        var _x  = __x;
        var _y  = __y;
        var _rx = __radiusX;
        var _ry = __radiusY;
        
        var _outerRGB = __colourOuter;
        var _outerA   = __alphaOuter;
        
        var _innerR = colour_get_red(  __colourInner)/255;
        var _innerG = colour_get_green(__colourInner)/255;
        var _innerB = colour_get_blue( __colourInner)/255;
        var _innerA = __alphaInner;
        
        var _borderR = colour_get_red(  __borderColour)/255;
        var _borderG = colour_get_green(__borderColour)/255;
        var _borderB = colour_get_blue( __borderColour)/255;
        var _borderA = __borderAlpha;
        
        var _borderThickness = __borderThickness;
        
        vertex_position_3d(_vbuff, _x-_rx, _y-_ry, 1                  ); vertex_normal(_vbuff, _rx, _ry, 0); vertex_colour(_vbuff, _outerRGB, _outerA); vertex_float3(_vbuff, _innerR, _innerG, _innerB); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, _innerA, _borderThickness);
        vertex_position_3d(_vbuff, _x+_rx, _y-_ry, 1 + __CLEAN_FLAG_A ); vertex_normal(_vbuff, _rx, _ry, 0); vertex_colour(_vbuff, _outerRGB, _outerA); vertex_float3(_vbuff, _innerR, _innerG, _innerB); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, _innerA, _borderThickness);
        vertex_position_3d(_vbuff, _x-_rx, _y+_ry, 1 + __CLEAN_FLAG_B ); vertex_normal(_vbuff, _rx, _ry, 0); vertex_colour(_vbuff, _outerRGB, _outerA); vertex_float3(_vbuff, _innerR, _innerG, _innerB); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, _innerA, _borderThickness);
        
        vertex_position_3d(_vbuff, _x+_rx, _y-_ry, 1 + __CLEAN_FLAG_A ); vertex_normal(_vbuff, _rx, _ry, 0); vertex_colour(_vbuff, _outerRGB, _outerA); vertex_float3(_vbuff, _innerR, _innerG, _innerB); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, _innerA, _borderThickness);
        vertex_position_3d(_vbuff, _x-_rx, _y+_ry, 1 + __CLEAN_FLAG_B ); vertex_normal(_vbuff, _rx, _ry, 0); vertex_colour(_vbuff, _outerRGB, _outerA); vertex_float3(_vbuff, _innerR, _innerG, _innerB); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, _innerA, _borderThickness);
        vertex_position_3d(_vbuff, _x+_rx, _y+_ry, 1 + __CLEAN_FLAG_AB); vertex_normal(_vbuff, _rx, _ry, 0); vertex_colour(_vbuff, _outerRGB, _outerA); vertex_float3(_vbuff, _innerR, _innerG, _innerB); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, _innerA, _borderThickness);
        
        return undefined;
    }
}