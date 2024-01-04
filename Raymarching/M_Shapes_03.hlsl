float result = 0;
float2 UV_2 = UV;
UV_2 = abs(frac(UV.x)*2.-1.);		
float nsin = sin(UV_2.y*0.2 + time*3 + tan(UV_2.y*-.8 + sin(UV.y*20. + time + cos(UV_2.x*5. - time*5.)) - cos(UV_2.y*-.4)+ time))*.5+.5;	

// Set the number of dots along its circunference
for (int i = 0; i < nSides; i++)
{
    // Set depth along dots normals from center to outside the circunference
    for (int j = 0; j < nCopies; j++)
    {
        float angle = (i / nSides) * (time) * PI;
        float2 pos = center + (j / nCopies) * radius * float2(cos(2 * angle), sin(-3 * angle));
        result += length(pos - UV_2.y - nsin) < size; // Draw circle
    }
}

roughness = float3(nsin*.2, nsin*.4, nsin*.5);
// Set colors patron
return(result * float3(cos(time*-.3), cos(time*.9), sin(time*.5)));
