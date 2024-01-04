// Declaración de variables para el color y el valor de emmisive
float4 color;
float emissive;

// Estructura que permite definir funciones que se van a usar dentro de un Custom node en Unreal Engine
struct texDistort
{
    // Función que permite escalar las coordenadas UV de texturas
    float2 texScale(float2 uv, float2 scale)
    {
        float2 texScale = (uv - 0.5) * scale + 0.5;
        return texScale;
    }

    // Función que permite rotar las coordenadas UV de texturas
    float2 texRotate(float2 uv, float angle)
    {
        float2x2 rotationMatrix = float2x2(cos(angle), sin(angle),
                                          -sin(angle), cos(angle));

        return mul(uv - 0.5, rotationMatrix) + 0.5;                                  
    }

    // Función que permite aplicar distorción a las coordenadas UV de texturas
    float2 texDistortion(float2 uv, float time, float magnitude, float frequency, float speed)
    {
        float angle = atan2(uv.y - 0.5, uv.x - 0.5);
        float radius = length(uv - 0.5);

        float distortion = magnitude * sin(frequency * radius + speed * time);
        float primDist = sin(angle) * distortion;

        return texRotate(uv, primDist);
    }

    // Función que crea un patrón de forma
    float nsin(float2 UV, float time){		
		float2 UV_2 = UV * texScale(UV, sin(time) * 10);
		UV_2 = abs(frac(UV.x)*2.-1.);		
		return sin(UV_2.x*10. + time+sin(UV_2.y*5. + sin(UV_2.x*2. + time+sin(UV_2.y*1. - time)) -time))*.5+.5;		
	}
};
// Crea una instancia del struct texDistort, llamada txd, que va a ser usada para acceder a cada una de las funciones dentro del struct
texDistort txd;

// Define un patrón de colores
float3 color_1 = float3(-sin(time * .9), sin(time * -.5), -cos(time * .1));
float3 color_2 = float3(cos(time*-.7), -sin(time*.3), -sin(time*-.5));
// Define un patrón de forma
float s = sin(uv.x*10. - time + cos(uv.y*5. + sin(uv.x*2. + time - cos(uv.y*1. - time)) + time))*.5+.5;
// Hace un mix entre el color_1 y el color_2, a través del patrón de forma nsin
float cf = lerp(color_1, color_2, txd.nsin(uv * -frac(uv) * s, time + s)); 
// Asigno a la variable color, una textura, definida como Input en el nodo Custom del material de Unreal
// Y le aplico una distorción con la función texDistortion, definida en el struct texDistort
color = Texture2DSample(texObject, texObjectSampler, txd.texDistortion(uv, time, magnitude, frequency, speed));

// Retorno el color, y lo multiplico por otro color float3, para generar más variación entre diferentes materiales.
return(color * float3(-sin(time*.9), -cos(time*-.5), -cos(time*.1)) * cf);
