﻿Shader "_Shaders/Rainbow" {
    Properties {
        _Saturation ("Saturation", Range(0.0, 1.0)) = 0.8
        _Luminosity ("Luminosity", Range(0.0, 1.0)) = 0.5
        _Spread ("Spread", Range(0.5, 10.0)) = 3.8
        _Speed ("Speed", Range(-10.0, 10.0)) = 2.4
        _TimeOffset ("TimeOffset", Range(0.0, 6.28318531)) = 0.0
    }
    SubShader {
        Pass {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "ShaderTools.cginc"

            fixed _Saturation;
            fixed _Luminosity;
            half _Spread;
            half _Speed;
            half _TimeOffset;

            struct appData {
                float4 vertex : POSITION;
                float4 texcoord0 : TEXCOORD0;
            };

            struct v2f {
                float4 position : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                fixed3 localPosition : TEXCOORD1;
            };

            v2f vert(appData i) {
                v2f o;
                o.position = UnityObjectToClipPos(i.vertex);
                o.texcoord0 = i.texcoord0;
                o.localPosition = i.vertex.xyz; + fixed3(0.5, 0.5, 0.5);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET {
                fixed2 lPos = i.localPosition / _Spread;
                half time = _Time.y * _Speed / _Spread;
                half timeWithOffset = time + _TimeOffset;
                fixed sine = sin(timeWithOffset);
                fixed cosine = cos(timeWithOffset);
                fixed hue = (lPos.x * sine + lPos.y * cosine) / 2.0;
                hue -= time;
                while (hue < 0.0) hue += 1.0;
                while (hue > 1.0) hue -= 1.0;
                fixed4 hsl = fixed4(hue, _Saturation, _Luminosity, 1.0);
                return HSLtoRGB(hsl) * 3;
            }

            ENDCG
        }
    } 
    FallBack "Diffuse"
}