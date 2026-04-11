/// @param left
/// @param top
/// @param right
/// @param bottom
/// @param include

function CleanCapsuleVertical(_left, _top, _right, _bottom, _include)
{
    var _rounding = 0.5*(_right - _left);
    
    if (!_include)
    {
        _top    -= _rounding;
        _bottom += _rounding;
    }
    
    return CleanRectangle(_left, _top, _right, _bottom).Rounding(_rounding);
}