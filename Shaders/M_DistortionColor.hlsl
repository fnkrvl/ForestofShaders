float3 rayStep = viewDir * -1;
float4 color;

struct texDistort
{
    float2 texScale(float2 uv, float2 scale)
    {
        float2 texScale = (uv - 0.5) * scale + 0.5;
        return texScale;
    }

    float2 texRotate(float2 uv, float angle)
    {
        float2x2 rotationMatrix = float2x2(cos(angle), sin(angle),
                                          -sin(angle), cos(angle));

        return mul(uv - 0.5, rotationMatrix) + 0.5;                                  
    }

    float2 texDistortion(float2 uv, float time, float magnitude, float frequency, float speed, float3 color_1, float3 color_2)
    {
        float angle = atan2(uv.y - 0.5, uv.x - 0.5);
        float radius = length(uv - 0.5);

        float distortion = magnitude * sin(frequency * radius + speed * time);
        float primDist = sin(6.0 * angle) * distortion;

        return texRotate(uv, primDist);
    }
};

texDistort txd;

for (int i = 0; i < 5; i++)
{
    color = Texture2DSample(texObject, texObjectSampler, txd.texDistortion(uv, time, magnitude, frequency, speed, color_1, color_1));

    if (color.r > 0.1 && color.g > 0.1 && color.b > 0.1)
    {
        return color * color_1;
    }
    else if (color.r > 0.01 && color.g > 0.01 && color.b > 0.01)
    {
        return color * color_2;
    }    

    uv += rayStep * 1.5;
}

return(color);