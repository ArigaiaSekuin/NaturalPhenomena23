// Upgrade NOTE: replaced 'UNITY_INSTANCE_ID' with 'UNITY_VERTEX_INPUT_INSTANCE_ID'

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Huoshan_Yan"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_Color("Color", Color) = (0.6176471,0.4405277,0.4405277,0)
		_T_Thick_Smoke_Tile("T_Thick_Smoke_Tile", 2D) = "white" {}
		_T_Soft_Smoke2("T_Soft_Smoke2", 2D) = "white" {}
		_Touming("Touming", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 texcoord_0;
			float2 uv_texcoord;
		};

		uniform sampler2D _T_Thick_Smoke_Tile;
		uniform float4 _Color;
		uniform sampler2D _T_Soft_Smoke2;
		uniform float4 _T_Soft_Smoke2_ST;
		uniform float _Touming;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 appendResult11 = float4( 0 , 0 , 0 , 0 );
			o.Emission = ( tex2D( _T_Thick_Smoke_Tile,(abs( ( float4( ( i.texcoord_0 * 0.75 ), 0.0 , 0.0 ) + appendResult11 ).xy+_Time[1] * float2(0,-0.01 )))) * _Color ).rgb;
			float2 uv_T_Soft_Smoke2 = i.uv_texcoord * _T_Soft_Smoke2_ST.xy + _T_Soft_Smoke2_ST.zw;
			o.Alpha = ( tex2D( _T_Soft_Smoke2,uv_T_Soft_Smoke2).g * _Touming );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			# include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD6;
				float4 texcoords01 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.texcoords01 = float4( v.texcoord.xy, v.texcoord1.xy );
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.texcoords01.xy;
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=7003
291;293;1663;659;2813.275;469.757;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;8;-2511.619,-337.4938;Float;False;Constant;_Float0;Float 0;1;0;0.75;0;0;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-2587.619,-489.4938;Float;False;0;-1;2;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.AppendNode;11;-2344.319,-222.5938;Float;False;FLOAT4;0;0;0;0;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2304.619,-420.4938;Float;False;0;FLOAT2;0.0;False;1;FLOAT;0,0;False;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-2114.619,-337.4938;Float;True;0;FLOAT2;0.0;False;1;FLOAT4;0,0;False;FLOAT4
Node;AmplifyShaderEditor.PannerNode;18;-1864.319,-318.5938;Float;True;0;-0.01;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.ColorNode;23;-1565.418,-100.2939;Float;False;Property;_Color;Color;1;0;0.6176471,0.4405277,0.4405277,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;26;-1808.614,505.008;Float;False;Property;_Touming;Touming;3;0;1;0;0;FLOAT
Node;AmplifyShaderEditor.SamplerNode;24;-1860.195,187.7018;Float;True;Property;_T_Soft_Smoke2;T_Soft_Smoke2;2;0;Assets/_Content/T_Soft_Smoke2.TGA;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;6;-1592.818,-303.8938;Float;True;Property;_T_Thick_Smoke_Tile;T_Thick_Smoke_Tile;1;0;Assets/_Content/T_Thick_Smoke_Tile.TGA;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-956.418,-117.2939;Float;True;0;FLOAT4;0.0;False;1;COLOR;0.0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1307.696,245.4017;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-212,-7;Float;False;True;2;Float;ASEMaterialInspector;0;Standard;Huoshan_Yan;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Transparent;0.5;True;True;0;True;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;DstColor;Zero;1;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;Relative;0;;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
WireConnection;9;0;7;0
WireConnection;9;1;8;0
WireConnection;10;0;9;0
WireConnection;10;1;11;0
WireConnection;18;0;10;0
WireConnection;6;1;18;0
WireConnection;19;0;6;0
WireConnection;19;1;23;0
WireConnection;25;0;24;2
WireConnection;25;1;26;0
WireConnection;0;2;19;0
WireConnection;0;9;25;0
ASEEND*/
//CHKSM=E4BB24AE1FB8B8EE1E9A3569974189F1CF78FBB8