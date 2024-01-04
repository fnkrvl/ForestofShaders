struct functions{
 
	float nsin(float2 UV, float time){		
		float2 UV_2 = UV;
		UV_2 = abs(frac(UV.x)*2.-1.);		
		return sin(UV_2.x*10.+time+sin(UV_2.y*5.+sin(UV_2.x*2.+time+sin(UV_2.y*1.-time))-time))*.5+.5;		
	}
 
	float4 main(float2 UV,
			    float3 col,
				float time,
				float speed){
	
		float forma = nsin(UV,time*speed);
		
		float3 final = float3(forma,forma,forma) * col;
		
		return float4 (final,1.0);
	}
};


functions f;

float maxDistance = 1000.0;
float actualDistance = distance(cameraPos, pPos);

// Normalize the distance
float normalizeDistance = saturate(actualDistance / maxDistance);
emissive = 1.-normalizeDistance;


roughness = float3(f.nsin(frac(UV*2.),time*speed),f.nsin(frac(UV*2.),time*speed),f.nsin(frac(UV*2.),time*speed));


//return(f.main(UV,col,time,speed));
//return lerp(float3(1.0,0.0,0.0),float3(0.0,0.0,1.0),1.-normalizeDistance);
return lerp(float3(1.0,0.0,0.0),float3(0.0,0.0,1.0),sin(pRelativeTime*10.3+time));