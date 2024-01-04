struct functions{
 
	float nsin1(float2 UV, float time){		
		float2 UV_2 = UV;
		UV_2 = abs(frac(UV.x)*2.-1.);		
		return sin(UV_2.x*10. + time+sin(UV_2.y*5. + sin(UV_2.x*2. + time+sin(UV_2.y*1. - time)) -time))*.5+.5;		
	}

    float nsin2(float2 UV, float time){
        // Define a point that will be at the center
        float2 p = float2(0.5, UV.x) - UV;
        // Radius
        float rad = length(p);
        // Angle
        float angle = atan2(p.x, p.y);

		float2 UV_2 = UV;
		UV_2 = abs(frac(UV.x)*2.-1.);		
		return sin(UV_2.x*10.*rad/6 + time + sin(UV_2.y*5. + sin(UV_2.x*2. + angle*time + sin(UV_2.y*1. - p.x+time)) -time))*.5+.5;		
	}
 
	float4 main(float2 UV,
			    float3 col,
				float time,
				float speed){                
		float s1 = nsin1(UV,time*speed);

        float s2 = nsin2(UV,time*speed);
		
		float3 final = float3(s1,s2,s1-s2) * col;
		
		return float4 (final,1.0);
	}
};


functions f;

float maxDistance = 1000.0;
float actualDistance = distance(cameraPos, pPos);

// Normalize the distance
float normalizeDistance = saturate(actualDistance / maxDistance);
emissive = 1.-normalizeDistance;


roughness = float3(f.nsin1(frac(UV*2.),time*speed),f.nsin2(frac(UV*2.),time*speed),f.nsin1(frac(UV*2.),time*speed));


return lerp(float3(0.1,0.1,0.1),float3(1,1,1),sin(pRelativeTime*10.3+time));