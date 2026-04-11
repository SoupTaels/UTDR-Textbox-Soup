precision highp float;

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



float CircleDistance(vec2 p, vec2 ab)
{
    // symmetry
    p = abs( p );
    
    // determine in/out and initial omega value
    bool s = dot(p/ab,p/ab)>1.0;
    float w = s ? atan(p.y*ab.x, p.x*ab.y) : 
                  ((ab.x*(p.x-ab.x)<ab.y*(p.y-ab.y))? 1.5707963 : 0.0);
    
    // find root with Newton solver
    for( int i=0; i<4; i++ )
    {
        vec2 cs = vec2(cos(w),sin(w));
        vec2 u = ab*vec2( cs.x,cs.y);
        vec2 v = ab*vec2(-cs.y,cs.x);
        w = w + dot(p-u,v)/(dot(p-u,u)+dot(v,v));
    }
    
    // compute final point and distance
    return length(p-ab*vec2(cos(w),sin(w))) * (s?1.0:-1.0);
}

float RectangleDistance(vec2 pos, vec2 rectCentre, vec2 rectSize, float radius)
{
    pos -= rectCentre;
    
    vec2 vector = abs(pos) - 0.5*rectSize + radius;
    return length(max(vector, 0.0)) + min(max(vector.x, vector.y), 0.0) - radius;
}

float LineNoCapDistance( in vec2 p, in vec2 a, in vec2 b, float th )
{
    float l = length(b-a);
    vec2  d = (b-a)/l;
    vec2  q = (p-(a+b)*0.5);
          q = mat2(d.x,-d.y,d.y,d.x)*q;
          q = abs(q)-vec2(l,th)*0.5;
    return length(max(q,0.0)) + min(max(q.x,q.y),0.0);    
}

float LineRoundCapDistance(vec2 position, vec2 posA, vec2 posB, float thickness)
{
    vec2 pos  = position - posA;
    float len = length(posB - posA);
    vec2 para = (posB - posA)/len;
    
    return (length(pos - para*max(0.0, min(len, dot(pos, para)))) - 0.5*thickness);
}

float LineSquareCapDistance( in vec2 p, in vec2 a, in vec2 b, float th )
{
    float l = th + length(b-a);
    vec2  d = (b-a)/(l - th);
    vec2  q = (p-(a+b)*0.5);
          q = mat2(d.x,-d.y,d.y,d.x)*q;
          q = abs(q)-vec2(l,th)*0.5;
    return length(max(q,0.0)) + min(max(q.x,q.y),0.0);    
}

float BoundaryDistance(vec2 position, vec2 norm, float distanceFromOrigin)
{
    return (distanceFromOrigin - dot(norm, position));
}

float ConvexDistance(vec2 position, vec3 boundary1, vec3 boundary2, float rounding)
{
    vec2 delta = vec2(BoundaryDistance(position, boundary1.xy, boundary1.z),
                      BoundaryDistance(position, boundary2.xy, boundary2.z)) + rounding;
    return min(max(delta.x, delta.y), 0.0) + length(max(delta, 0.0)) - rounding;
}

float LineDistance(vec2 position, vec2 posA, vec2 posB)
{
    vec2 pos  = position - posA;
    vec2 para = normalize(posB - posA);
    
    return length(pos - para*dot(pos, para));
}

float PolylineMitreJoinDistance(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    float dist = min(LineDistance(position, posA, posB), LineDistance(position, posB, posC)) - 0.5*thickness;
    
    vec2 norm1 = normalize(posA - posB);
    vec2 norm2 = normalize(posB - posC);
    
    float crossSign = -sign(norm1.x*norm2.y - norm1.y*norm2.x);
    
    norm1 = crossSign*vec2(-norm1.y, norm1.x);
    float dot1 = dot(posB, norm1) - 0.5*thickness;
    
    norm2 = crossSign*vec2(-norm2.y, norm2.x);
    float dot2 = dot(posB, norm2) - 0.5*thickness;
    
    return max(dist, ConvexDistance(position, vec3(norm1, dot1), vec3(norm2, dot2), 0.0));
}

float PolylineBevelJoinDistance(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    float mitreDist = PolylineMitreJoinDistance(position, posA, posB, posC, thickness);
    
    vec2 norm = normalize(posB - posA) + normalize(posB - posC);
    if (length(norm) < 0.0001) return mitreDist;
    norm = normalize(norm);
    
    vec2 point = thickness*norm + posB;
    float pointDot = dot(point, norm) - 0.5*thickness;
    
    return max(mitreDist, -BoundaryDistance(position, norm, pointDot));
}

float PolylineRoundJoinDistance(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    return min(LineRoundCapDistance(position, posA, posB, thickness), LineRoundCapDistance(position, posC, posB, thickness));
}

float NgonDistance(vec2 pos, vec2 ngonXY, float radius, float sides, float angleDivisor, float angle, float rounding)
{
    pos -= ngonXY;
    pos = mat2(cos(-angle), -sin(-angle), sin(-angle), cos(-angle)) * pos;
    
    radius -= rounding;
    
    // next 4 lines can be precomputed for a given shape
    float an = 3.141593/sides;
    float en = 3.141593/angleDivisor;  // m is between 2 and n
    vec2  acs = vec2(cos(an),sin(an));
    vec2  ecs = vec2(cos(en),sin(en)); // ecs=vec2(0,1) for regular polygon

    float bn = mod(atan(pos.x, pos.y), 2.0*an) - an;
    pos = length(pos)*vec2(cos(bn), abs(sin(bn)));
    pos -= radius*acs;
    pos += ecs*clamp(-dot(pos, ecs), 0.0, radius*acs.y/ecs.y);
    return length(pos)*sign(pos.x) - rounding;
}

float SegmentDistance(vec2 pos, vec3 shapeXYR, float apertureCentre, float apertureSize, float rounding)
{
    pos -= shapeXYR.xy;
    pos = mat2(cos(-apertureCentre), -sin(-apertureCentre), sin(-apertureCentre), cos(-apertureCentre)) * pos;
    
    shapeXYR -= rounding;
    
    vec2 trigCoeffs = vec2(sin(apertureSize), cos(apertureSize));
    
    pos.x = abs(pos.x);
    float l = (length(pos) - shapeXYR.z);
    float m = length(pos - trigCoeffs*clamp(dot(pos, trigCoeffs), 0.0, shapeXYR.z)); // c=sin/cos of aperture
    
    return max(l, m*sign(trigCoeffs.y*pos.x - trigCoeffs.x*pos.y)) - rounding;
}

float RingDistance(vec2 position, vec2 centre, float apertureCentre, float apertureSize, float innerRadius, float outerRadius)
{
    float thickness = 0.5*(outerRadius - innerRadius);
    outerRadius -= thickness;
    
    vec2 sinCosA = vec2(sin(apertureCentre), cos(apertureCentre));
    vec2 sinCosB = vec2(sin(apertureSize),   cos(apertureSize)  );
    
    position -= centre;
    position *= mat2(sinCosA.x, sinCosA.y, -sinCosA.y, sinCosA.x);
    position.x = abs(position.x);
    
    float k = (sinCosB.y*position.x > sinCosB.x*position.y)? dot(position, sinCosB) : length(position);
    
    return sqrt(max(0.0, dot(position, position) + outerRadius*outerRadius - 2.0*outerRadius*k)) - thickness;
}

float Distance(vec2 position)
{    
    if (v_fMode == 1.0) //Circle
    {
        return CircleDistance(position, v_vCircleRadius);
    }
    else if (v_fMode == 2.0) //Rectangle + Capsule
    {
        return RectangleDistance(position, v_vRectangleXY, v_vRectangleWH, v_fRounding);
    }
    else if (v_fMode == 3.0) //Line with no cap
    {
        return LineNoCapDistance(position, v_vLineA, v_vLineB, v_fLineThickness);
    }
    else if (v_fMode == 4.0) //Line with square cap
    {
        return LineSquareCapDistance(position, v_vLineA, v_vLineB, v_fLineThickness);
    }
    else if (v_fMode == 5.0) //Line with round cap
    {
        return LineRoundCapDistance(position, v_vLineA, v_vLineB, v_fLineThickness);
    }
    else if (v_fMode == 6.0) //Triangle + Convex
    {
        return ConvexDistance(position, v_vLine1, v_vLine2, v_fRounding);
    }
    else if (v_fMode == 7.0) //Polyline with mitre joint
    {
        return PolylineMitreJoinDistance(position, v_vLineA, v_vLineB, v_vLineC, v_fLineThickness);
    }
    else if (v_fMode == 8.0) //Polyline with bevel joint
    {
        return PolylineBevelJoinDistance(position, v_vLineA, v_vLineB, v_vLineC, v_fLineThickness);
    }
    else if (v_fMode == 9.0) //Polyline with round joint
    {
        return PolylineRoundJoinDistance(position, v_vLineA, v_vLineB, v_vLineC, v_fLineThickness);
    }
    else if (v_fMode == 10.0) //N-gon
    {
        return NgonDistance(position, v_vNgonXYR.xy, v_vNgonXYR.z, v_fNgonSides, v_fNgonStarFactor, v_fNgonAngle, v_fRounding);
    }
    else if (v_fMode == 11.0) //Segment
    {
        return SegmentDistance(position, v_vSegmentXYR, v_vSegmentApertureCentre, v_vSegmentApertureSize, v_fRounding);
    }
    else if (v_fMode == 12.0) //Ring
    {
        return RingDistance(position, v_vRingCentre, v_fRingApertureCentre, v_fRingApertureSize, v_fRingInnerRadius, v_fRingOuterRadius);
    }
    
    return 0.0;
}

float Feather(float dist, float threshold)
{
    return step(threshold, dist);
}



void main()
{
    if (v_fMode <= 0.0)
    {
        gl_FragColor = v_vFillColour;
    }
    else
    {
        vec2 position = v_vPosition;
        vec4 fillColour = v_vFillColour;
        
        if (v_fMode == 1.0) // Circle
        {
            position = v_vCircleCoord;
            fillColour = mix(v_vCircleInnerColour, v_vFillColour, length(position/v_vCircleRadius));
        }
        
        float dist = Distance(position);
        
        vec4 borderColour = fillColour;
        if (v_fBorder < .5) // Border
        {
            borderColour = mix(v_vBorderColour, fillColour, Feather(-dist, v_fBorderThickness));
        }
        
        borderColour.a *= 1.0 - Feather(dist, 0.0); // Edge alpha
        gl_FragColor = borderColour;
    }
}