precision highp float;

//                  CIRCLE:                          SEGMENT:
//in_Position:      XY, type                         XY, type
//in_Normal:        Radius X, radius Y               Circle XY, radius
//in_Colour1:       Outer fill RGBA                  Outer fill RGBA
//in_Colour2:       Inner fill RGB                   Wedge centre, wedge size, unused
//in_Colour3:       Border colour                    Border colour
//in_TextureCoord:  Inner fill A, border thickness   Unused, border thickness
//
//                  RING:                            RECTANGLE:                
//in_Position:      XY, type                         XY, type                  
//in_Normal:        Shape XY, radius                 Unused      
//in_Colour1:       Fill RGBA                        Fill colour               
//in_Colour2:       Radius, angle, angle             Rect WH, unused           
//in_Colour3:       Border colour                    Border colour             
//in_TextureCoord:  Unused, border thickness         Rounding, border thickness
//
//                  LINE:                            CONVEX:
//in_Position:      XY, type                         XY, type
//in_Normal:        x1, y1, unused                   First boundary
//in_Colour1:       Fill colour                      Fill colour
//in_Colour2:       x2, y2, unused                   Second boundary
//in_Colour3:       Unused                           Border colour
//in_TextureCoord:  Thickness, unused                Rounding, border thickness
//
//                  POLYLINE:                        N-GON:
//in_Position:      XY, type                         XY, type
//in_Normal:        x1, y1, x3                       Centre XY, radius
//in_Colour1:       Fill colour                      Fill RGBA
//in_Colour2:       x2. y2, y3                       Sides, star factor, rotation
//in_Colour3:       Unused                           Border colour
//in_TextureCoord:  Thickness, unused                Rounding, border thickness



attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec4 in_Colour1;
attribute vec3 in_Colour2;
attribute vec4 in_Colour3;
attribute vec2 in_TextureCoord;



//Shared
varying vec2  v_vPosition;
varying float v_fMode;
varying vec4  v_vFillColour;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;
varying float v_fRounding;
varying float v_fBorder;

//Circle
varying vec2 v_vCircleRadius;
varying vec2 v_vCircleCoord;
varying vec4 v_vCircleInnerColour;

//Rectangle
varying vec2 v_vRectangleXY;
varying vec2 v_vRectangleWH;

//Line + Polyline
varying vec2  v_vLineA;
varying vec2  v_vLineB;
varying vec2  v_vLineC;
varying float v_fLineThickness;

//Convex
varying vec3 v_vLine1;
varying vec3 v_vLine2;

//N-gon
varying vec3  v_vNgonXYR;
varying float v_fNgonSides;
varying float v_fNgonStarFactor;
varying float v_fNgonAngle;

//Segment
varying vec3  v_vSegmentXYR;
varying float v_vSegmentApertureCentre;
varying float v_vSegmentApertureSize;

//Ring
varying vec2  v_vRingCentre;
varying float v_fRingApertureCentre;
varying float v_fRingApertureSize;
varying float v_fRingInnerRadius;
varying float v_fRingOuterRadius;



void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION]*vec4(in_Position.xy, 0.0, 1.0);
    
    //Shared
    v_vPosition        = in_Position.xy;
    v_fMode            = in_Position.z;
    v_vFillColour      = in_Colour1;
    v_vBorderColour    = in_Colour3;
    v_fRounding        = in_TextureCoord.x;
    v_fBorderThickness = in_TextureCoord.y;
    
    //Extract flags
    float flagA = 0.0;
    float flagB = 0.0;
    if (v_fMode >= 131072.0) { v_fMode -= 131072.0; flagB = 1.0; } // 2^17
    if (v_fMode >=  65536.0) { v_fMode -=  65536.0; flagA = 1.0; } // 2^16
    
    //Shapes with borders
    //TODO - Reorganise or use a flag
    v_fBorder = float(v_fMode == 3.0 || v_fMode == 4.0 || v_fMode == 5.0 || v_fMode == 7.0 || v_fMode == 8.0 || v_fMode == 9.0);
    
    //Circle
    v_vCircleRadius      = in_Normal.xy;
    v_vCircleCoord       = 2.0*v_vCircleRadius*(vec2(flagA, flagB) - 0.5);
    v_vCircleInnerColour = vec4(in_Colour2, in_TextureCoord.x);
    
    //Rectangle
    v_vRectangleWH = in_Colour2.xy;
    v_vRectangleXY = v_vPosition + v_vRectangleWH*(0.5 - vec2(flagA, flagB));
    
    //Line + Polyline
    v_vLineA         = in_Normal.xy;
    v_vLineB         = in_Colour2.xy;
    v_vLineC         = vec2(in_Normal.z, in_Colour2.z);
    v_fLineThickness = in_TextureCoord.x;
    
    //Polygon
    v_vLine1 = in_Normal;
    v_vLine2 = in_Colour2;
    
    //N-gon
    v_vNgonXYR        = in_Normal;
    v_fNgonSides      = in_Colour2.x;
    v_fNgonStarFactor = in_Colour2.y;
    v_fNgonAngle      = in_Colour2.z;
    
    //Segment
    v_vSegmentXYR             = in_Normal;
    v_vSegmentApertureCentre = in_Colour2.x;
    v_vSegmentApertureSize   = in_Colour2.y;
    
    //Ring
    v_vRingCentre         = in_Normal.xy;
    v_fRingApertureCentre = in_Colour2.y;
    v_fRingApertureSize   = in_Colour2.z;
    v_fRingInnerRadius    = in_Normal.z;
    v_fRingOuterRadius    = in_Colour2.x;
}