// Inicializa a 0 la variable que va a acumular el valor del bucle siguiente
float result = 0;
// Crea una copia de las coordenadas UV
float2 UV_2 = UV;
// Ajusta UV_2 para que esté en el rango de -1 a 1. Esto se hace para simular el efecto de espejo y crear una apariencia simétrica.
UV_2 = abs(frac(UV.x)*2.-1.);
// Defino un patrón sinusoidal utilizando varias funciones sinusoidales, y jugando con ambas uvs (UV y UV_2) y el tiempo. Este valor se usará posteriormente para ajustar la rugosidad y los colores del material.
float nsin = sin(UV_2.x*0.2 + time*3 + sin(UV_2.y*-.8 + sin(UV_2.x*20. + time + sin(UV_2.y*10. - time*5.)) + time))*.5+.5;

// Define el número de puntos a lo largo de la circunferencia
for (int i = 0; i < nSides; i++)
{
    // Define el número de copias de cada uno de esos puntos, desde el centro hacia afuera
    for (int j = 0; j < nCopies; j++)
    {
        // Calcula el ángulo actual basado en el tiempo y el índice i.
        float angle = (i / nSides) * (time) * PI;
        // Calcula la posición en el espacio para la copia actual del puntos.
        float2 pos = center + (j / nCopies) * radius * float2(cos(angle), sin(angle));
        // Dibuja un patrón dependiendo de la posición calculada anteriormente
        result += length(pos - UV) < size;

        // Como el ángulo del vector float2(cos(angle), sin(angle)) es igual en ambos cos y sin, el movimiento será circular
        // Si por el cambio quiero definir un patrón no circular, sólo debo hacer que el ángulo varíe en uno o ambos parámetros
        // como hago en otra de las istancias de dicho tunel, logrando así una experiencia diferente a medida que se avanza por el mismo.
    }
}

// Doy valor al Roughness (seteado como output en el nodo Custom), basándome en el valor sinusoidal nsin, variando cada canal R, G, y B.
roughness = float3(nsin*.2, nsin*-.4, nsin*.5);
// Retorno el patrón circular multiplicado por un vector de colores que varían en función del tiempo.
return(result * float3(sin(time*-.3), -cos(time*.9), sin(time*.5)));