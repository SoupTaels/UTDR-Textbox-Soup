/// @param x
/// @param y

function CleanTransformAddMove(_x, _y)
{
    global.__cleanMatrixIdentity = false;
    
    global.__cleanMatrix = matrix_multiply(global.__cleanMatrix, matrix_build(_x, _y, 0,   0,0,0,   1,1,1));
}