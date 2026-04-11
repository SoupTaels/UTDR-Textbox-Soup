/// @param pointArray

function CleanPolyline(_array)
{
    return new __CleanClassPolyline(_array);
}

function __CleanClassPolyline(_array) constructor
{
    if (!is_array(_array)) __CleanError("Invalid datatype given for argument0 (", typeof(_array), "), was expecting an array");
    if ((array_length(_array) mod 2) != 0) __CleanError("Points array must have an even number of elements (x/y pairs)");
    
    __pointArray = _array;
    __colour     = CLEAN_DEFAULT_POLYLINE_COLOUR;
    __alpha      = CLEAN_DEFAULT_POLYLINE_ALPHA;
    __blendArray = undefined;
    
    __thickness = CLEAN_DEFAULT_POLYLINE_THICKNESS;
    
    __join     = CLEAN_DEFAULT_POLYLINE_JOIN;
    __capStart = CLEAN_DEFAULT_POLYLINE_START_CAP;
    __capEnd   = CLEAN_DEFAULT_POLYLINE_END_CAP;
    
    /// @param color
    /// @param alpha
    static Blend = function(_colour, _alpha)
    {
        __colour = _colour;
        __alpha  = _alpha;
        
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