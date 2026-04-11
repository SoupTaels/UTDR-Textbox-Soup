/// @param angle

function CleanTransformAddRotate(_angle)
{
    global.__cleanMatrixIdentity = false;
    
    global.__cleanMatrix = matrix_multiply(global.__cleanMatrix, matrix_build(0,0,0,   0, 0, _angle,   1,1,1));
}