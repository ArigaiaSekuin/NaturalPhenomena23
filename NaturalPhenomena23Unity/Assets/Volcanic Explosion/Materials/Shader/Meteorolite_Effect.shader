// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Simplified Additive Particle shader. Differences from regular Additive Particle one:
// - no Tint color
// - no Smooth particle support
// - no AlphaTest
// - no ColorMask

Shader "Tank/Particles/AdditiveV2" {
Properties {
	_MainTex ("Particle Texture", 2D) = "white" {}
	_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5) 
	_Exp ("Exp", Float) = 2
}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend SrcAlpha One
	Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }
	
	BindChannels {
		Bind "Color", color
		Bind "Vertex", vertex
		Bind "TexCoord", texcoord
	}
	
// ---- Dual texture cards
	SubShader {
		// ---- Dual texture cards
	Pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
	 
		sampler2D _MainTex;
		float4 _MainTex_ST;
		fixed4 _TintColor;
		uniform fixed _Exp;
		struct v2f {
		    float4 pos : SV_POSITION;
		    float2 uv : TEXCOORD0;
		    fixed4 color : COLOR;
		};

		v2f vert (appdata_full v)
		{
			v2f o;
			o.uv =TRANSFORM_TEX(v.texcoord.xy,_MainTex);
			o.pos = UnityObjectToClipPos(v.vertex);
			o.color = v.color;
			return o;
		}

		fixed4 frag (v2f i) : SV_Target
		{
			return _Exp * i.color * _TintColor * tex2D(_MainTex, i.uv);
		}
		ENDCG 
	}
	}
	
	// ---- Single texture cards (does not do color tint)
	SubShader {
		Pass {
			SetTexture [_MainTex] {
				combine texture * primary
			}
		}
	}
}
}