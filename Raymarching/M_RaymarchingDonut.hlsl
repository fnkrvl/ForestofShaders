// Raymarcher Rays
float3 rayOrigin = 1-(viewDir - worldPos);
float3 rayStep = viewDir * -1;

// Light Position
float3 lightDirection = normalize(lightPos);

struct sdfShapes
{   
    // Operations for SDF's
    float opUnion(float d1, float d2)
    {
        return min(d1, d2);
    }

    float opSubtraction(float d1, float d2)
    {
        return max(-d1, d2);
    }

    float opIntersection(float d1, float d2)
    {
        return max(d1, d2);
    }

    float opXor(float d1, float d2)
    {
        return max(min(d1, d2), -max(d1, d2));
    }

    float3x3 rotateZ3D(float angle)
    {
        float s = sin(angle);
        float c = cos(angle);
        return float3x3(
            c, -s, 0.0,
            s, c, 0.0,
            0.0, 0.0, 1.0
        );
    }

    // SDF's
    float donut(float3 p, float size, float cutout)
    {
        float2 q = float2(length(p.xz) - size, p.y);
        return length(q) - cutout;
    }

    float sdBoxFrame(float3 p, float3 b, float e)
    {
        p = abs(p) - b;
        float3 q = abs(p + e) - e;
        return min(min( length(max(float3(p.x, q.y, q.z), 0.0)) + min(max(p.x, max(q.y, q.z)), 0.0),
                        length(max(float3(q.x, p.y, q.z), 0.0)) + min(max(q.x, max(p.y, q.z)), 0.0)),
                        length(max(float3(q.x, q.y, p.z), 0.0)) + min(max(q.x, max(q.y, p.z)), 0.0));
    }

    float sdCutHollowSphere(float3 p, float r, float h, float t)
    {
        // Sampling-independent computations (only depend on shape)
        float w = sqrt(r * r - h * h);

        // Sampling-dependent computations
        float2 q = float2(length(p.xz), p.y);
        return ((h * q.x < w * q.y) ? length(q - float2(w, h)) :
                                    abs(length(q) - r)) - t;
    }

    // Apply 3D rotation to the donut with angle based on time
    float donutRotated(float3 p, float size, float cutout, float time)
    {
        float rotationAngleDegrees = time * 50.0;  // Adjust the multiplier for the rotation speed
        float rotationAngleRadians = radians(rotationAngleDegrees);
        p = mul(rotateZ3D(rotationAngleRadians), p);  // Apply rotation
        return donut(p, size, cutout);
    }
};
sdfShapes sdf;


// Raymarcher
for (int i = 0; i < 256; i++)
{    
    float dist = sdf.donutRotated(rayOrigin, 50, 25, sin(time));

    if(dist < 0.01)
    {
        float eps = 0.001;

        float3 normal = normalize(float3(sdf.donut(float3(rayOrigin.x + eps, rayOrigin.y      , rayOrigin.z      ), 50, 25)
                                       - sdf.donut(float3(rayOrigin.x - eps, rayOrigin.y      , rayOrigin.z      ), 50, 25),
                                         sdf.donut(float3(rayOrigin.x + eps, rayOrigin.y + eps, rayOrigin.z      ), 50, 25)
                                       - sdf.donut(float3(rayOrigin.x      , rayOrigin.y - eps, rayOrigin.z      ), 50, 25),
                                         sdf.donut(float3(rayOrigin.x      , rayOrigin.y      , rayOrigin.z + eps), 50, 25)
                                       - sdf.donut(float3(rayOrigin.x      , rayOrigin.y      , rayOrigin.z - eps), 50, 25)
        ));


        float diffuse = max(dot(normal, lightDirection), 0);
        float3 reflection = reflect(lightDirection, normal);
        float3 viewDirection = normalize(-worldPos - rayOrigin);
        float specular = pow(max(dot(reflection, viewDirection), 0), 256);

        return (diffuse *  float3(1, 0, 0)) + (specular * float3(1, 1, 1));
    }

    opacityMask = 1;
    rayOrigin += rayStep; 
}

opacityMask = 0;
return float3(0, 0, 0);