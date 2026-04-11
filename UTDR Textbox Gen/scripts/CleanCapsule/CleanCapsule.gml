/// @param left
/// @param top
/// @param right
/// @param bottom
/// @param include

function CleanCapsule(_left, _top, _right, _bottom, _include)
{
    var _rounding = 0.5*(_bottom - _top);
    
    if (!_include)
    {
        _left  -= _rounding;
        _right += _rounding;
    }
    
    return CleanRectangle(_left, _top, _right, _bottom).Rounding(_rounding);
}