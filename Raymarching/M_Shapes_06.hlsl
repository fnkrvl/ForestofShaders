float result = 0;
float2 UV_2 = UV;
UV_2 = abs(frac(UV.x)*2.-1.);		
float nsin = sin(UV_2.y*0.2 + time + cos(UV.x*-18 + sin(UV_2.x*20 + tan(UV.y*2)) - time))*.5+.5;	

// Set the number of dots along its circunference
for (int i = 0; i < nSides; i++)
{
    // Set depth along dots normals from center to outside the circunference
    for (int j = 0; j < nCopies; j++)
    {
        float angle = (i / nSides) * (time) * PI;
        float2 pos = center + (j / nCopies) * radius * float2(cos(2 * angle), sin(-3 * angle));
        result += length(pos - UV.x * nsin) < size; // Draw circle
    }
}

roughness = float3(nsin*.2, nsin*.4, nsin*.5);
// Set colors patron
return(result * float3(-sin(time*.3) + nsin, -cos(time*-.7), -sin(time*-.1)));
