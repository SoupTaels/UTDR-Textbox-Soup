/// @param xCenter
/// @param yCenter
/// @param width
/// @param height

function CleanRectangleXYWH(_x, _y, _width, _height)
{
    return new __CleanClassRectangle(_x - _width/2, _y - _height/2, _x + _width/2, _y + _height/2);
}