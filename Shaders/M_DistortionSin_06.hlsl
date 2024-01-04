float4 color;
float emissive;

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

    float2 texDistortion(float2 uv, float time, float magnitude, float frequency, float speed)
    {
        float angle = atan2(uv.y - 0.5, uv.x - 0.5);
        float radius = length(uv - 0.5);

        float distortion = magnitude * sin(frequency * radius + speed * time);
        float primDist = sin(angle) * distortion;

        return texRotate(uv, primDist);
    }

    float nsin(float2 UV, float time){		
		float2 UV_2 = UV;
		UV_2 = abs(frac(UV.x)*2.-1.);		
		return sin(UV_2.x*8. - time - cos(UV.x*5. - cos(UV_2.x*3. + time - cos(UV_2.x*10. + time)) + time))*.5+.5;		
	}
};

texDistort txd;

float3 color_1 = float3(-sin(time * .9), sin(time * -.5), -cos(time * .1));
float3 color_2 = float3(cos(time*-.7), -sin(time*.3), -sin(time*-.5));
float s = sin(uv.x*10. - time + cos(uv.y*5. + sin(uv.x*2. + time - cos(uv.y*1. - time)) + time))*.5+.5;
float cf = lerp(color_2, color_1, txd.nsin(uv + frac(uv*2) + s * 2, time + s)); 

color = Texture2DSample(texObject, texObjectSampler, txd.texDistortion(uv, time, magnitude, frequency, speed));

return(color * float3(-sin(time*.9), -cos(time*-.5), -cos(time*.1)) * cf);
