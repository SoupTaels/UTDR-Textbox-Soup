/// @param xScale
/// @param yScale

function CleanTransformAddScale(_xScale, _yScale)
{
    global.__cleanMatrixIdentity = false;
    
    global.__cleanMatrix = matrix_multiply(global.__cleanMatrix, matrix_build(0,0,0,   0,0,0,   _xScale, _yScale, 1));
}