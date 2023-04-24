// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Yanjiang"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_T_Volcano_01_M("T_Volcano_01_M", 2D) = "white" {}
		_T_Volcano_01_E("T_Volcano_01_E", 2D) = "white" {}
		_T_Volcano_01_N("T_Volcano_01_N", 2D) = "white" {}
		_T_LavaSurface_06_D("T_LavaSurface_06_D", 2D) = "white" {}
		_T_SprayNoise("T_SprayNoise", 2D) = "white" {}
		_Liangdu("Liangdu", Float) = 15
		_QuantumArid_Diffuse_H("QuantumArid_Diffuse_H", 2D) = "white" {}
		_D("D", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float2 texcoord_0;
			float2 texcoord_1;
		};

		uniform sampler2D _T_Volcano_01_N;
		uniform float4 _T_Volcano_01_N_ST;
		uniform sampler2D _QuantumArid_Diffuse_H;
		uniform float4 _QuantumArid_Diffuse_H_ST;
		uniform float _D;
		uniform sampler2D _T_LavaSurface_06_D;
		uniform sampler2D _T_SprayNoise;
		uniform sampler2D _T_Volcano_01_E;
		uniform float4 _T_Volcano_01_E_ST;
		uniform float _Liangdu;
		uniform sampler2D _T_Volcano_01_M;
		uniform float4 _T_Volcano_01_M_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord.xy * float2( 3,1.5 ) + float2( 0,0 );
			o.texcoord_1.xy = v.texcoord.xy * float2( 2,2 ) + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_T_Volcano_01_N = i.uv_texcoord * _T_Volcano_01_N_ST.xy + _T_Volcano_01_N_ST.zw;
			float4 tex2DNode3 = tex2D( _T_Volcano_01_N,uv_T_Volcano_01_N);
			o.Normal = tex2DNode3.xyz;
			float2 uv_QuantumArid_Diffuse_H = i.uv_texcoord * _QuantumArid_Diffuse_H_ST.xy + _QuantumArid_Diffuse_H_ST.zw;
			o.Albedo = ( tex2D( _QuantumArid_Diffuse_H,uv_QuantumArid_Diffuse_H) * _D ).xyz;
			float2 temp_output_7_0 = (abs( i.texcoord_0+_Time[1] * float2(0,0.03 )));
			float2 uv_T_Volcano_01_E = i.uv_texcoord * _T_Volcano_01_E_ST.xy + _T_Volcano_01_E_ST.zw;
			o.Emission = ( ( ( 1.5 * ( tex2D( _T_LavaSurface_06_D,temp_output_7_0) * float4( float3(1,1,0) , 0.0 ) ) ) * tex2D( _T_SprayNoise,(abs( i.texcoord_1+_Time[1] * float2(0.01,0.04 )))) ) * ( tex2D( _T_Volcano_01_E,uv_T_Volcano_01_E) * _Liangdu ) ).xyz;
			float2 uv_T_Volcano_01_M = i.uv_texcoord * _T_Volcano_01_M_ST.xy + _T_Volcano_01_M_ST.zw;
			float4 tex2DNode1 = tex2D( _T_Volcano_01_M,uv_T_Volcano_01_M);
			o.Metallic = tex2DNode1.x;
			o.Occlusion = tex2DNode1.b;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=7003
-1808;130;1663;1004;2481.228;267.1955;1.6;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-3491.899,-372.3002;Float;True;0;-1;2;0;FLOAT2;3,1.5;False;1;FLOAT2;0,0;False;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.PannerNode;7;-3160.9,-361.3002;Float;True;0;0.03;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.Vector3Node;45;-2670.003,-215.1001;Float;False;Constant;_Vector1;Vector 1;7;0;1,1,0;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-3136.502,-24.29994;Float;True;0;-1;2;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;10;-2741.199,-556.5997;Float;True;Property;_T_LavaSurface_06_D;T_LavaSurface_06_D;3;0;Assets/_Content/T_LavaSurface_06_D.TGA;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;40;-2320.402,-321.8998;Float;False;Constant;_Float0;Float 0;6;0;1.5;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2416.098,-254.1996;Float;True;0;FLOAT4;0.0;False;1;FLOAT3;0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.PannerNode;17;-2730.503,-3.29994;Float;True;0.01;0.04;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;2;-2554.601,363;Float;True;Property;_T_Volcano_01_E;T_Volcano_01_E;1;0;Assets/_Content/T_Volcano_01_E.TGA;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;32;-2578.898,593.2;Float;False;Property;_Liangdu;Liangdu;5;0;15;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-2100.802,-250.6998;Float;True;0;FLOAT;0.0;False;1;FLOAT4;0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.SamplerNode;15;-2236.2,45.30023;Float;True;Property;_T_SprayNoise;T_SprayNoise;4;0;Assets/_Content/T_SprayNoise.TGA;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;56;-1555.951,-534.6694;Float;True;Property;_QuantumArid_Diffuse_H;QuantumArid_Diffuse_H;7;0;Assets/_Content/QuantumArid_Diffuse_H.bmp;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1853.3,-14.69989;Float;True;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-2112.898,441.2;Float;True;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;64;-1203.451,-299.27;Float;False;Property;_D;D;8;0;0.5;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-927.451,-380.27;Float;True;0;FLOAT4;0,0,0,0;False;1;FLOAT;0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.Vector3Node;44;-1383.803,1014.501;Float;False;Constant;_Vector0;Vector 0;7;0;1,1,0;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.Vector3Node;54;-1266.202,629.5;Float;False;Constant;_Vector2;Vector 2;7;0;2,2,0;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-871.1257,120.834;Float;True;Property;_T_Volcano_01_M;T_Volcano_01_M;0;0;Assets/_Content/T_Volcano_01_M.TGA;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-979.8019,595.7;Float;True;0;FLOAT4;0,0,0;False;1;FLOAT3;0.0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-719.5039,783.4998;Float;True;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0;False;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1149.451,866.0009;Float;True;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1643.5,354.7001;Float;True;0;FLOAT4;0.0;False;1;FLOAT4;0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.SamplerNode;41;-1674.502,865.7001;Float;True;Property;_T_LavaSurface_02_N;T_LavaSurface_02_N;6;0;Assets/_Content/T_LavaSurface_02_N.TGA;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;3;-1347.574,99.38237;Float;True;Property;_T_Volcano_01_N;T_Volcano_01_N;2;0;Assets/_Content/T_Volcano_01_N.TGA;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-226,95;Float;False;True;2;Float;ASEMaterialInspector;0;Standard;Yanjiang;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;Relative;0;;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
WireConnection;7;0;9;0
WireConnection;10;1;7;0
WireConnection;11;0;10;0
WireConnection;11;1;45;0
WireConnection;17;0;16;0
WireConnection;39;0;40;0
WireConnection;39;1;11;0
WireConnection;15;1;17;0
WireConnection;18;0;39;0
WireConnection;18;1;15;0
WireConnection;20;0;2;0
WireConnection;20;1;32;0
WireConnection;63;0;56;0
WireConnection;63;1;64;0
WireConnection;48;0;3;0
WireConnection;48;1;54;0
WireConnection;46;0;48;0
WireConnection;46;1;43;0
WireConnection;43;0;41;0
WireConnection;43;1;44;0
WireConnection;19;0;18;0
WireConnection;19;1;20;0
WireConnection;41;1;7;0
WireConnection;0;0;63;0
WireConnection;0;1;3;0
WireConnection;0;2;19;0
WireConnection;0;3;1;0
WireConnection;0;5;1;3
ASEEND*/
//CHKSM=B9141C3A6C2173110492A86FC34A972A8C89E352