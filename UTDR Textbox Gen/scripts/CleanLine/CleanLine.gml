/// @param x1
/// @param y1
/// @param x2
/// @param y2

function CleanLine(_x1, _y1, _x2, _y2)
{
    return new __CleanClassLine(_x1, _y1, _x2, _y2);
}

function __CleanClassLine(_x1, _y1, _x2, _y2) constructor
{
    __x1 = _x1;
    __y1 = _y1;
    __x2 = _x2;
    __y2 = _y2;
    
    __colour1 = CLEAN_DEFAULT_LINE_COLOUR;
    __alpha1  = CLEAN_DEFAULT_LINE_ALPHA;
    __colour2 = CLEAN_DEFAULT_LINE_COLOUR;
    __alpha2  = CLEAN_DEFAULT_LINE_ALPHA;
    
    __thickness = CLEAN_DEFAULT_LINE_THICKNESS;
    
    __capStart = CLEAN_DEFAULT_LINE_START_CAP;
    __capEnd   = CLEAN_DEFAULT_LINE_END_CAP;
    
    /// @param color
    /// @param alpha
    static Blend = function(_colour, _alpha)
    {
        __colour1 = _colour;
        __alpha1  = _alpha;
        __colour2 = _colour;
        __alpha2  = _alpha;
        
        return self;
    }
    
    /// @param color1
    /// @param alpha1
    /// @param color2
    /// @param alpha2
    static Blend2 = function(_colour1, _alpha1, _colour2, _alpha2)
    {
        __colour1 = _colour1;
        __alpha1  = _alpha1;
        __colour2 = _colour2;
        __alpha2  = _alpha2;
        
        return self;
    }
    
    static Thickness = function(_thickness)
    {
        if (_thickness <= 0) __CleanError("Line thickness must be greater than zero");
        
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
    
    static Draw = function()
    {
        __CleanDraw();
        return undefined;
    }
    
    /// @param vertexBuffer
    static __Build = function(_vbuff)
    {
        var _colour1   = __colour1;
        var _alpha1    = __alpha1;
        var _colour2   = __colour2;
        var _alpha2    = __alpha2;
        var _thickness = __thickness;
        
        var _ox1 = __x1;
        var _oy1 = __y1;
        var _ox2 = __x2;
        var _oy2 = __y2;
        
        //Calculate the size of the cap
        var _dx = _ox2 - _ox1;
        var _dy = _oy2 - _oy1;
        var _d  = _thickness / sqrt(_dx*_dx + _dy*_dy);
        _dx *= _d;
        _dy *= _d;
        
        var _cx1 = _ox1 - _dx;
        var _cy1 = _oy1 - _dy;
        var _cx2 = _ox2 + _dx;
        var _cy2 = _oy2 + _dy;
        
        var _x1 = _cx1 - _dy;
        var _y1 = _cy1 + _dx;
        var _x2 = _cx2 - _dy;
        var _y2 = _cy2 + _dx;
        var _x3 = _cx1 + _dy;
        var _y3 = _cy1 - _dx;
        var _x4 = _cx2 + _dy;
        var _y4 = _cy2 - _dx;
        
        var _mx1 = 0.5*(_x1 + _x2);
        var _my1 = 0.5*(_y1 + _y2);
        var _mx2 = 0.5*(_x3 + _x4);
        var _my2 = 0.5*(_y3 + _y4);
        
        var _cap1 = 5; //Default to rounded lines
        var _cap2 = 5;
        if (__capStart == "none"  ) _cap1 = 3;
        if (__capStart == "square") _cap1 = 4;
        if (__capEnd   == "none"  ) _cap2 = 3;
        if (__capEnd   == "square") _cap2 = 4;
        
        if (_cap1 == _cap2)
        {
            vertex_position_3d(_vbuff, _x1, _y1, _cap1); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colour1, _alpha1); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _x2, _y2, _cap1); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colour2, _alpha2); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _x4, _y4, _cap1); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colour2, _alpha2); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            
            vertex_position_3d(_vbuff, _x1, _y1, _cap1); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colour1, _alpha1); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _x4, _y4, _cap1); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colour2, _alpha2); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _x3, _y3, _cap1); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colour1, _alpha1); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        }
        else
        {
            var _colourM = merge_colour(_colour1, _colour2, 0.5);
            var _alphaM  = 0.5*(_alpha1 + _alpha2);
            
            vertex_position_3d(_vbuff,  _x1,  _y1, _cap1); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colour1, _alpha1); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _mx1, _my1, _cap1); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colourM, _alphaM); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _mx2, _my2, _cap1); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colourM, _alphaM); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            
            vertex_position_3d(_vbuff,  _x1,  _y1, _cap1); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colour1, _alpha1); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _mx2, _my2, _cap1); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colourM, _alphaM); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff,  _x3,  _y3, _cap1); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colour1, _alpha1); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            
            vertex_position_3d(_vbuff, _mx1, _my1, _cap2); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colourM, _alphaM); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff,  _x2,  _y2, _cap2); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colour2, _alpha2); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff,  _x4,  _y4, _cap2); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colour2, _alpha2); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            
            vertex_position_3d(_vbuff, _mx1, _my1, _cap2); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colourM, _alphaM); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff,  _x4,  _y4, _cap2); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colour2, _alpha2); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _mx2, _my2, _cap2); vertex_normal(_vbuff, _ox1, _oy1, 0); vertex_colour(_vbuff, _colourM, _alphaM); vertex_float3(_vbuff, _ox2, _oy2, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        }
    }
}