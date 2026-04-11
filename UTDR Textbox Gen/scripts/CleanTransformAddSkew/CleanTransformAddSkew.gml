/// @param xFactor
/// @param yFactor

function CleanTransformAddSkew(_x, _y)
{
    global.__cleanMatrixIdentity = false;
    
    var _matrix = [ 1,_y, 0, 0,
                   _x, 1, 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1];
    
    global.__cleanMatrix = matrix_multiply(global.__cleanMatrix, _matrix);
}