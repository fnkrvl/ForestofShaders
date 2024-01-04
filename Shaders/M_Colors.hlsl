struct functions{
 
	float nsin(float2 UV, float time){
		
		return sin(UV.x*100.+time+sin(UV.y*100.+sin(UV.x*100.+time+sin(UV.y*20.))-time))*.5+.5;		
	}
 
	float4 main(float2 UV,
			    float3 col,
				float time,
				float speed,
				float3 pSpeed){
	
		float2 UV_2 = UV;
		//UV_2 = abs(frac(UV.x)*2.-1.);
	
		float forma = nsin(UV,time*speed);
		//float forma = nsin(UV_2,time*speed);
		
		float3 final = float3(forma,forma,forma) * col;
		
		final = pSpeed;
		return float4 (final,1.0);
	}
};

functions f;
emissive = float4(sin(time),-cos(time*+5.),-sin(time*5.)*3.,1.0);
return(f.main(UV,col,time,speed,pSpeed));