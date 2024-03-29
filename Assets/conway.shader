﻿Shader "Custom/Conway"
{
	Properties{
		_MainTex("Texture", 2D) = "white" {} 
		_cI("ColInd", int) = 0
	}
	SubShader{
		Tags { "RenderType" = "Opaque" }
		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
            
			uniform float4 _MainTex_TexelSize;
			int _cI;
            
			struct appdata{
				float4 vertex : POSITION;
				float2 uv: TEXCOORD0;
			};

			struct v2f{
				float4 vertex : SV_POSITION;
				float2 uv: TEXCOORD0;
			};
  
			v2f vert(appdata v){
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
            
      sampler2D _MainTex;
            
			fixed4 frag(v2f i) : SV_Target{
				float2 texel = float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y);
				
				float cx = i.uv.x;
				float cy = i.uv.y;
				float4 c = tex2D(_MainTex, float2(cx, cy));
				
				float up = cy + texel.y * 2;
				float down = cy + texel.y * -2;
				float right = cx + texel.x * 2;
				float left = cx + texel.x * -2;
				
				float4 arr[8];
				
				arr[0] = tex2D(  _MainTex, float2( cx   , up ));   //N
				arr[1] = tex2D(  _MainTex, float2( cx + texel.x, cy + texel.y ));   //NE
				arr[2] = tex2D(  _MainTex, float2( right, cy ));   //E
				arr[3] = tex2D(  _MainTex, float2( cx + texel.x, cy - texel.y )); //SE
				arr[4] = tex2D(  _MainTex, float2( cx   , down )); //S
				arr[5] = tex2D(  _MainTex, float2( cx - texel.x , cy - texel.y )); //SW
				arr[6] = tex2D(  _MainTex, float2( left , cy ));   //W
				arr[7] = tex2D(  _MainTex, float2( cx - texel.x , cy + texel.y ));   //NW

				int count = 0;
				for(int i=0;i<8;i++)
					if (arr[i].r > 0 || arr[i].g > 0 || arr[i].b > 0)
						count++;

				float4 colour[6];
				colour[0] = float4(1,0,0,1);
				colour[1] = float4(.5,.5,0,1);
				colour[2] = float4(0,1,0,1);
				colour[3] = float4(0,.5,.5,1);
				colour[4] = float4(0,0,1,1);
				colour[5] = float4(.5,0,.5,1);
								
				return (c.r > 0 || c.g > 0 || c.b > 0) ? (count == 2 || count == 3)
							? colour[_cI] : float4(0.0,0.0,0.0,1.0) 
							: (count == 3) ? colour[_cI] : float4(0.0,0.0,0.0,1.0);
					
			}

			ENDCG
		}

	}
	FallBack "Diffuse"
}