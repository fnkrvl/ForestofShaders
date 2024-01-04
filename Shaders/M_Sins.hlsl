struct functions{
 
	float nsin(float2 UV, float time){		
		float2 UV_2 = UV;
		UV_2 = abs(frac(UV.x)*2.-1.);		
		
//return sin(UV_2.y*2.+sin(UV_2.x*3.+cos(UV_2.x*sin(time-UV_2.x)+time-sin(UV_2.y*50.))))*.5+.5;

return sin(UV_2.x*2+time);	
	}
 
	float4 main(float2 UV,
			                float3 baseColor,
                         float3 emissiveColor,
				               float time,
				               float speed){
	
		float forma = nsin(UV,time*speed);

       float eShape = nsin(UV,time*forma);

		//float3 final = float3(forma,forma,forma) * baseColor
       //                    + float3(eShape,eShape*.2,eShape*-.8) * emissiveColor;

       float3 final = float3(forma,forma,forma) * baseColor;
		
		return float4 (final,1.0);
	}
};


functions f;
return(f.main(UV,baseColor,emissiveColor,time,speed));