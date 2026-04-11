function CleanTransformReset()
{
    global.__cleanMatrixIdentity = true;
    
    global.__cleanMatrix        = matrix_build_identity();
    global.__cleanMatrixOriginX = 0;
    global.__cleanMatrixOriginY = 0;
}