// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Volcano"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_CoreDarkness("CoreDarkness", Float) = 2
		_Power("Power", Float) = 5
		_EdgeBrightness("EdgeBrightness", Float) = 0
		_CoreEmissive("CoreEmissive", Float) = 40
		_ExternalEmissive("ExternalEmissive", Float) = 1428.65
		_DetailDisplace("DetailDisplace", Float) = 16
		_MacroDisplace("MacroDisplace", Float) = 8
		_MacroDisplaceSpeed("MacroDisplaceSpeed", Float) = -0.2
		_SpecularPower("Specular Power", Float) = 0.04
		_VolcanoSmokeTexBlur0("VolcanoSmokeTexBlur0", 2D) = "white" {}
		_Volcano_DispMask("Volcano_DispMask", 2D) = "gray" {}
		_TillingSmoke_2("TillingSmoke_2", 2D) = "white" {}
		_TillingNoise02("TillingNoise02", 2D) = "white" {}
		_EmissionMask01("Emission Mask01", 2D) = "white" {}
		_VolcanoSmokeTex("VolcanoSmokeTex", 2D) = "white" {}
		_EmissionMask_2("Emission Mask_2", 2D) = "white" {}
		_volcanoSmokeN("volcanoSmokeN", 2D) = "bump" {}
		_volcanoOcclussion("volcanoOcclussion", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 texcoord_0;
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float2 texcoord_1;
			float2 texcoord_2;
			float2 texcoord_3;
			float2 texcoord_4;
			float2 texcoord_5;
			float2 texcoord_6;
		};

		uniform sampler2D _volcanoSmokeN;
		uniform float _Power;
		uniform float _EdgeBrightness;
		uniform float _CoreDarkness;
		uniform sampler2D _VolcanoSmokeTex;
		uniform sampler2D _volcanoOcclussion;
		uniform float4 _volcanoOcclussion_ST;
		uniform float _CoreEmissive;
		uniform sampler2D _TillingSmoke_2;
		uniform sampler2D _TillingNoise02;
		uniform sampler2D _EmissionMask01;
		uniform sampler2D _VolcanoSmokeTexBlur0;
		uniform float _ExternalEmissive;
		uniform sampler2D _EmissionMask_2;
		uniform float4 _EmissionMask_2_ST;
		uniform float _SpecularPower;
		uniform float _DetailDisplace;
		uniform float _MacroDisplaceSpeed;
		uniform float _MacroDisplace;
		uniform sampler2D _Volcano_DispMask;
		uniform float4 _Volcano_DispMask_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord.xy * float2( 6,6 ) + float2( 0,0 );
			o.texcoord_1.xy = v.texcoord.xy * float2( 8,8 ) + float2( 0,0 );
			o.texcoord_2.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			o.texcoord_3.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			o.texcoord_4.xy = v.texcoord.xy * float2( 12,12 ) + float2( 0,0 );
			o.texcoord_5.xy = v.texcoord.xy * float2( 6,6 ) + float2( 0,0 );
			float4 tex2DNode3 = tex2Dlod( _VolcanoSmokeTexBlur0, float4( (abs( o.texcoord_5+_Time[1] * float2(0,-0.025 ))), 0.0 , 0.0 ) );
			float lerpResult14 = lerp( -0.15 , 1.0 , tex2DNode3.r);
			float clampResult15 = clamp( lerpResult14 , 0.0 , 1.0 );
			o.texcoord_6.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			float lerpResult10 = lerp( -0.15 , 1.0 , tex2Dlod( _VolcanoSmokeTexBlur0, float4( (abs( o.texcoord_6+( _Time.y * _MacroDisplaceSpeed ) * float2(-0.1,-0.1 ))), 0.0 , 0.0 ) ).r);
			float clampResult11 = clamp( lerpResult10 , 0.0 , 1.0 );
			float4 uv_Volcano_DispMask = float4(v.texcoord * _Volcano_DispMask_ST.xy + _Volcano_DispMask_ST.zw, 0 ,0);
			float3 ase_vertexNormal = v.normal.xyz;
			float4 appendResult196 = (float4(ase_vertexNormal , 0.0));
			float4 VertexOffset87 = ( 1.0 * mul( ( ( ( ( clampResult15 * _DetailDisplace ) + ( clampResult11 * _MacroDisplace ) ) * tex2Dlod( _Volcano_DispMask, uv_Volcano_DispMask ).r ) * mul( appendResult196 , unity_ObjectToWorld ) ) , unity_WorldToObject ) );
			v.vertex.xyz += VertexOffset87.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float4 normalizeResult105 = normalize( ( tex2D( _volcanoSmokeN, (abs( i.texcoord_0+_Time[1] * float2(0,-0.025 ))) ) + tex2D( _volcanoSmokeN, (abs( ( i.texcoord_0 * 1.5 )+_Time[1] * float2(0,-0.075 ))) ) ) );
			float4 mNormal108 = ( normalizeResult105 * float4(1,1,2,1) );
			o.Normal = mNormal108;
			float3 ase_worldPos = i.worldPos;
			float3 normalizeResult236 = normalize( ( ase_worldPos - _WorldSpaceCameraPos ) );
			float dotResult225 = dot( ( normalizeResult105 * float4(1,1,2,1) ) , float4( float3(0,0,1) , 0.0 ) );
			float ifLocalVar226 = 0;
			if( dotResult225 > 0.0 )
				ifLocalVar226 = 1.0;
			else if( dotResult225 == 0.0 )
				ifLocalVar226 = 1.0;
			else if( dotResult225 < 0.0 )
				ifLocalVar226 = -1.0;
			float3 appendResult228 = (float3(float2( 1,1 ) , ifLocalVar226));
			float dotResult237 = dot( normalizeResult236 , mul( float4( UnpackNormal( ( ( normalizeResult105 * float4(1,1,2,1) ) * float4( appendResult228 , 0.0 ) ) ) , 0.0 ) , unity_ObjectToWorld ) );
			float clampResult238 = clamp( dotResult237 , 0.0 , 1.0 );
			float4 tex2DNode74 = tex2D( _VolcanoSmokeTex, (abs( i.texcoord_0+_Time[1] * float2(0,-0.025 ))) );
			float2 uv_volcanoOcclussion = i.uv_texcoord * _volcanoOcclussion_ST.xy + _volcanoOcclussion_ST.zw;
			float4 tex2DNode110 = tex2D( _volcanoOcclussion, uv_volcanoOcclussion );
			o.Albedo = ( ( ( ( pow( ( 1.0 - clampResult238 ) , _Power ) * _EdgeBrightness ) + ( ( 1.0 - ( clampResult238 * _CoreDarkness ) ) + 0.0 ) ) * ( tex2DNode74 * 0.2 ) ) * tex2DNode110.r ).rgb;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelFinalVal153 = (0.0 + 1.0*pow( 1.0 - dot( ase_worldNormal, worldViewDir ) , 5.0));
			float4 tex2DNode121 = tex2D( _TillingSmoke_2, i.texcoord_1 );
			float4 tex2DNode117 = tex2D( _TillingNoise02, (abs( i.texcoord_2+_Time[1] * float2(0,-0.1 ))) );
			float4 tex2DNode145 = tex2D( _EmissionMask01, ( ( 0.5 * ( tex2DNode117.r + -0.2 ) ) + i.texcoord_3 ) );
			float4 tex2DNode3 = tex2D( _VolcanoSmokeTexBlur0, (abs( i.texcoord_0+_Time[1] * float2(0,-0.025 ))) );
			float4 lerpResult154 = lerp( tex2DNode74 , tex2DNode3 , 0.5);
			float4 tex2DNode124 = tex2D( _TillingSmoke_2, i.texcoord_4 );
			float3 normalizeResult135 = normalize( float3(0,-0.5,-1) );
			float dotResult138 = dot( ase_worldNormal , normalizeResult135 );
			float clampResult152 = clamp( ( ( dotResult138 + 1.0 ) * 0.5 ) , 0.0 , 1.0 );
			float2 uv_EmissionMask_2 = i.uv_texcoord * _EmissionMask_2_ST.xy + _EmissionMask_2_ST.zw;
			float4 Emissive172 = ( ( ( ( 1.0 - fresnelFinalVal153 ) * ( _CoreEmissive * ( ( ( 2.0 * ( ( 1.0 - ( ( sin( ( tex2DNode121.r + ( 1.0 * ( _Time.y + tex2DNode117.r ) ) ) ) + 1.0 ) * 0.5 ) ) * tex2DNode121.r ) ) * tex2DNode145 ) + tex2DNode145 ) ) ) * pow( ( float4( 1,1,1,0 ) - lerpResult154 ) , 3.0 ) ) + ( _ExternalEmissive * ( ( tex2DNode145 + ( tex2DNode145 * ( ( ( 1.0 - ( ( sin( ( ( 1.0 * ( _Time.y + tex2DNode117.r ) ) + tex2DNode124.r ) ) + 1.0 ) * 0.5 ) ) * tex2DNode124.r ) * 8.0 ) ) ) * ( pow( clampResult152 , 10.0 ) * tex2D( _EmissionMask_2, uv_EmissionMask_2 ).r ) ) ) );
			o.Emission = Emissive172.xyz;
			float3 temp_cast_7 = (_SpecularPower).xxx;
			o.Specular = temp_cast_7;
			float AO112 = tex2DNode110.r;
			o.Occlusion = AO112;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				float4 texcoords01 : TEXCOORD4;
				//UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
				surfIN.uv_texcoord.xy = IN.texcoords01.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=12101
202;191;1906;1004;1832.706;1633.4;3.4;True;True
Node;AmplifyShaderEditor.RangedFloatNode;101;-2157.597,142.2031;Float;False;Constant;_Float1;Float 1;10;0;1.5;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2421.701,-189.6;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;6,6;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-1823.397,4.70317;Float;False;2;2;0;FLOAT2;0.0;False;1;FLOAT;0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.CommentaryNode;115;-3086.721,-2749.329;Float;False;4097.301;1673.501;Comment;58;172;171;170;169;168;167;166;165;164;163;162;161;160;159;158;157;156;155;154;153;152;151;150;149;148;147;146;145;144;143;142;141;140;139;138;137;136;135;134;133;132;131;130;129;128;127;126;125;124;123;122;121;119;118;117;116;219;220;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;2;-2062.9,4.099998;Float;False;0;-0.025;2;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.PannerNode;102;-1608.698,35.40311;Float;False;0;-0.075;2;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.TextureCoordinatesNode;220;-2992.105,-1942.5;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.PannerNode;116;-2937.018,-2129.229;Float;False;0;-0.1;2;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;103;-1383.097,13.00313;Float;True;Property;_volcanoSmokeN2;volcanoSmokeN2;10;0;None;True;0;False;white;Auto;False;Instance;100;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;100;-1400.397,-268.9969;Float;True;Property;_volcanoSmokeN;volcanoSmokeN;16;0;None;True;0;False;bump;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;118;-2598.417,-2352.829;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;117;-2748.119,-2108.129;Float;True;Property;_TillingNoise02;TillingNoise02;12;0;Assets/_Content/Models/Quantum Theory/Quantum Arid/T_TilingNoise02.TGA;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;104;-830.2969,-13.79688;Float;False;2;2;0;FLOAT4;0.0;False;1;COLOR;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.CommentaryNode;221;120.167,-1000.896;Float;False;2595.25;1045.6;FuzzyShading;25;246;245;244;243;242;241;240;239;238;237;236;235;234;233;232;231;230;229;228;227;226;225;224;223;222;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;119;-2379.119,-2255.129;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.Vector4Node;106;-790.1967,210.6031;Float;False;Constant;_NormalSoftness;NormalSoftness;11;0;1,1,2,1;0;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.NormalizeNode;105;-648.2969,3.203125;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.TextureCoordinatesNode;219;-2989.105,-2589.9;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;8,8;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;121;-2694.918,-2642.53;Float;True;Property;_TillingSmoke_2;TillingSmoke_2;11;0;Assets/_Content/Models/Quantum Theory/Quantum Arid/T_TilingSmoke_2.TGA;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-2172.418,-2203.129;Float;False;2;2;0;FLOAT;1.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-493.0969,26.20313;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.TextureCoordinatesNode;122;-2920.521,-1639.827;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;12,12;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.Vector3Node;222;167.3671,-440.6954;Float;False;Constant;_Vector3;Vector 3;0;0;0,0,1;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;223;325.1671,-70.29556;Float;False;Constant;_Float5;Float 5;0;0;-1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;224;343.118,-178.9958;Float;False;Constant;_Float7;Float 7;0;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;125;-2027.519,-2665.729;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;124;-2439.62,-1563.827;Float;True;Property;_TextureSample5;Texture Sample 5;6;0;None;True;0;False;white;Auto;False;Instance;121;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DotProductOpNode;225;400.1672,-354.2956;Float;False;2;0;FLOAT4;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;6;-1921.497,887.1996;Float;False;Property;_MacroDisplaceSpeed;MacroDisplaceSpeed;7;0;-0.2;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SinOpNode;127;-1783.02,-2655.43;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ConditionalIfNode;226;556.1672,-219.2956;Float;False;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.Vector2Node;227;595.6161,-413.0956;Float;False;Constant;_Vector4;Vector 4;0;0;1,1;0;3;FLOAT2;FLOAT;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;173;-2631.998,382.0002;Float;False;2654.498;798.9995;Comment;7;11;8;3;10;203;208;218;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1888.297,730.2997;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;126;-2033.22,-1650.227;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1599.598,766.6996;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;228;888.5165,-290.1956;Float;False;FLOAT3;4;0;FLOAT2;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleAddOpNode;130;-1541.22,-2681.829;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.Vector3Node;128;-2394.521,-1272.327;Float;False;Constant;_Vector1;Vector 1;9;0;0,-0.5,-1;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;218;-2344.206,985.7001;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SinOpNode;129;-1849.22,-1663.027;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.WorldSpaceCameraPos;231;676.5165,-780.8954;Float;False;0;1;FLOAT3
Node;AmplifyShaderEditor.SimpleAddOpNode;133;-1649.219,-1655.027;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.NormalizeNode;135;-2103.32,-1235.627;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleAddOpNode;131;-2091.719,-2071.527;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;-0.2;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-1371.519,-2656.829;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.PannerNode;8;-2059.298,1015.199;Float;False;-0.1;-0.1;2;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.WorldNormalVector;134;-2069.52,-1445.527;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;979.6168,-506.6957;Float;False;2;2;0;FLOAT4;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.WorldPosInputsNode;230;729.5165,-950.8954;Float;False;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;234;1095.817,-900.3954;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.ObjectToWorldMatrixNode;232;1129.166,-432.8954;Float;False;0;1;FLOAT4x4
Node;AmplifyShaderEditor.UnpackScaleNormalNode;233;1111.966,-661.0954;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1.0;False;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;3;-1839.7,406.3996;Float;True;Property;_VolcanoSmokeTexBlur0;VolcanoSmokeTexBlur0;9;0;Assets/_Content/Models/Quantum Theory/Quantum Arid/T_volcanoSmokeTexBlur.TGA;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-1736.619,-2182.226;Float;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;136;-1944.319,-1776.527;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-1478.019,-1648.627;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;139;-1178.719,-2685.631;Float;False;2;0;FLOAT;1.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.DotProductOpNode;138;-1838.12,-1270.727;Float;False;2;0;FLOAT3;0.0;False;1;FLOAT3;0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;208;-1780.006,789.0991;Float;True;Property;_volcanoSmokeTexBlur_1;volcanoSmokeTexBlur_1;18;0;Assets/_Content/Models/Quantum Theory/Quantum Arid/T_volcanoSmokeTexBlur.TGA;True;0;False;white;Auto;False;Instance;3;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;142;-1313.219,-1671.027;Float;False;2;0;FLOAT;1.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;14;-779.9999,514.0001;Float;False;3;0;FLOAT;-0.15;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;10;-1443.9,797.9993;Float;False;3;0;FLOAT;-0.15;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.NormalizeNode;236;1189.116,-779.0953;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleAddOpNode;143;-1525.219,-2074.227;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT2;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;141;-1619.62,-1344.827;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;1398.166,-466.8954;Float;False;2;2;0;FLOAT3;0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT4x4;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-991.2191,-2534.329;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;145;-1331.518,-2089.827;Float;True;Property;_EmissionMask01;Emission Mask01;13;0;Assets/_Content/Models/Quantum Theory/Quantum Arid/T_Volcano_EmissiveMask01.TGA;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-1080.019,-1515.427;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-766.2191,-2560.029;Float;False;2;2;0;FLOAT;2.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;11;-1206,757.0005;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;17;-772.1989,710.7004;Float;False;Property;_DetailDisplace;DetailDisplace;5;0;16;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.DotProductOpNode;237;1518.717,-709.4955;Float;False;2;0;FLOAT3;0.0;False;1;FLOAT3;0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-1471.42,-1312.527;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;12;-522.8,1026.6;Float;False;Property;_MacroDisplace;MacroDisplace;6;0;8;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;15;-534.4,560.7004;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-982.0182,-1610.227;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;8.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;96;-801.9971,-336.397;Float;False;Property;_CoreDarkness;CoreDarkness;0;0;2;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.NormalVertexDataNode;174;-775.097,1293.002;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;152;-1287.12,-1320.127;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;197;-768.0021,1483.501;Float;False;Constant;_Float2;Float 2;18;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;238;1652.917,-773.8954;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;74;-1373.898,-595.9994;Float;True;Property;_VolcanoSmokeTex;VolcanoSmokeTex;14;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.WorldNormalVector;149;-551.3193,-2575.428;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-212.0004,911.6003;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-284.3,741.3005;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-729.6193,-2252.328;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT4;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;239;1992.018,-345.4959;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;240;1811.717,-884.2955;Float;False;2;0;FLOAT;1.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;97;-794.9971,-215.397;Float;False;Property;_Power;Power;1;0;5;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.ObjectToWorldMatrixNode;191;-449.3987,1535.298;Float;False;0;1;FLOAT4x4
Node;AmplifyShaderEditor.RangedFloatNode;158;-457.92,-2302.029;Float;False;Property;_CoreEmissive;CoreEmissive;3;0;40;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;154;-345.2182,-1279.628;Float;False;3;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0.5;False;1;FLOAT4
Node;AmplifyShaderEditor.DynamicAppendNode;196;-385.202,1315.3;Float;False;FLOAT4;4;0;FLOAT3;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.FresnelNode;153;-329.2202,-2570.827;Float;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;5.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;159;-538.5192,-2119.728;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.PowerNode;157;-1089.519,-1316.327;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;10.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-790.0182,-1653.427;Float;False;2;2;0;FLOAT4;0.0;False;1;FLOAT;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SamplerNode;156;-857.9193,-1262.628;Float;True;Property;_EmissionMask_2;Emission Mask_2;15;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;20;-95.79958,1012.3;Float;True;Property;_Volcano_DispMask;Volcano_DispMask;10;0;Assets/_Content/Models/Quantum Theory/Quantum Arid/T_Volcano_DispMask.TGA;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;18;142.5004,754.5004;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;164;-170.8192,-2035.829;Float;False;2;0;FLOAT4;1,1,1,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;343.5003,808.5004;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;163;-633.2181,-1714.227;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;-119.7986,1338.499;Float;False;2;2;0;FLOAT4;0.0;False;1;FLOAT4x4;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;-223.8201,-2207.128;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT4;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;-489.2191,-1456.628;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;242;2144.018,-363.6958;Float;False;2;0;FLOAT;1.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.PowerNode;241;2072.017,-800.7957;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;162;-46.62025,-2579.628;Float;False;2;0;FLOAT;1.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;98;-819.9971,-115.397;Float;False;Property;_EdgeBrightness;EdgeBrightness;2;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;167;-508.0182,-1821.027;Float;False;Property;_ExternalEmissive;ExternalEmissive;4;0;1428.65;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;243;2348.919,-345.9957;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;244;2243.518,-702.3957;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;91;-1011.698,-369.0978;Float;False;Constant;_Float0;Float 0;9;0;0.2;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-294.0182,-1629.427;Float;False;2;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.WorldToObjectMatrix;22;758.2002,1568.6;Float;False;0;1;FLOAT4x4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;123.6033,1346.602;Float;False;2;2;0;FLOAT;0.0,0,0;False;1;FLOAT4;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;118.6798,-2399.427;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT4;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.PowerNode;166;51.5808,-2052.429;Float;False;2;0;FLOAT4;0.0;False;1;FLOAT;3.0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;299.8797,-2136.926;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;989.0004,1415.2;Float;False;2;2;0;FLOAT4;0.0;False;1;FLOAT4x4;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-784.198,-483.4977;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;210;428.9966,1251.199;Float;False;Constant;_Float3;Float 3;19;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;245;2400.818,-637.3957;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-34.81826,-1706.227;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT4;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleAddOpNode;171;494.8798,-1923.727;Float;False;2;2;0;FLOAT4;0.0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;569.3966,1338.299;Float;False;2;2;0;FLOAT;1,1,1,0;False;1;FLOAT4;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;246;2546.418,-542.4958;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;110;3292.904,-43.5976;Float;True;Property;_volcanoOcclussion;volcanoOcclussion;17;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-280.0966,166.203;Float;False;mNormal;-1;True;1;0;FLOAT4;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.RegisterLocalVarNode;172;767.5801,-1899.027;Float;False;Emissive;-1;True;1;0;FLOAT4;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;604.5018,1093.501;Float;False;VertexOffset;-1;True;1;0;FLOAT4;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.GetLocalVarNode;88;3905.302,153.2019;Float;False;87;0;1;FLOAT4
Node;AmplifyShaderEditor.GetLocalVarNode;113;3913.904,65.10279;Float;False;112;0;1;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;3664.204,151.1028;Float;False;AO;-1;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;-131.7014,978.4012;Float;False;2;2;0;FLOAT;0,0,0;False;1;FLOAT3;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.GetLocalVarNode;109;3865.703,-39.19708;Float;False;108;0;1;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;176;3687.506,54.30009;Float;False;Property;_SpecularPower;Specular Power;8;0;0.04;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.NormalVertexDataNode;202;-379.7014,1052.001;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;89;3846.103,-134.8981;Float;False;172;0;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;3654.005,-206.8975;Float;False;2;2;0;COLOR;0;False;1;FLOAT;0.0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4195.4,-232.4;Float;False;True;4;Float;ASEMaterialInspector;0;StandardSpecular;Volcano;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;99;0;1;0
WireConnection;99;1;101;0
WireConnection;2;0;1;0
WireConnection;102;0;99;0
WireConnection;116;0;220;0
WireConnection;103;1;102;0
WireConnection;100;1;2;0
WireConnection;117;1;116;0
WireConnection;104;0;100;0
WireConnection;104;1;103;0
WireConnection;119;0;118;0
WireConnection;119;1;117;1
WireConnection;105;0;104;0
WireConnection;121;1;219;0
WireConnection;123;1;119;0
WireConnection;107;0;105;0
WireConnection;107;1;106;0
WireConnection;125;0;121;1
WireConnection;125;1;123;0
WireConnection;124;1;122;0
WireConnection;225;0;107;0
WireConnection;225;1;222;0
WireConnection;127;0;125;0
WireConnection;226;0;225;0
WireConnection;226;2;224;0
WireConnection;226;3;224;0
WireConnection;226;4;223;0
WireConnection;126;0;123;0
WireConnection;126;1;124;1
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;228;0;227;0
WireConnection;228;1;226;0
WireConnection;130;0;127;0
WireConnection;129;0;126;0
WireConnection;133;0;129;0
WireConnection;135;0;128;0
WireConnection;131;0;117;1
WireConnection;132;0;130;0
WireConnection;8;0;218;0
WireConnection;8;1;7;0
WireConnection;229;0;107;0
WireConnection;229;1;228;0
WireConnection;234;0;230;0
WireConnection;234;1;231;0
WireConnection;233;0;229;0
WireConnection;3;1;2;0
WireConnection;140;1;131;0
WireConnection;137;0;133;0
WireConnection;139;1;132;0
WireConnection;138;0;134;0
WireConnection;138;1;135;0
WireConnection;208;1;8;0
WireConnection;142;1;137;0
WireConnection;14;2;3;1
WireConnection;10;2;208;1
WireConnection;236;0;234;0
WireConnection;143;0;140;0
WireConnection;143;1;136;0
WireConnection;141;0;138;0
WireConnection;235;0;233;0
WireConnection;235;1;232;0
WireConnection;144;0;139;0
WireConnection;144;1;121;1
WireConnection;145;1;143;0
WireConnection;146;0;142;0
WireConnection;146;1;124;1
WireConnection;147;1;144;0
WireConnection;11;0;10;0
WireConnection;237;0;236;0
WireConnection;237;1;235;0
WireConnection;148;0;141;0
WireConnection;15;0;14;0
WireConnection;151;0;146;0
WireConnection;152;0;148;0
WireConnection;238;0;237;0
WireConnection;74;1;2;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;150;0;147;0
WireConnection;150;1;145;0
WireConnection;239;0;238;0
WireConnection;239;1;96;0
WireConnection;240;1;238;0
WireConnection;154;0;74;0
WireConnection;154;1;3;0
WireConnection;196;0;174;0
WireConnection;196;1;197;0
WireConnection;153;0;149;0
WireConnection;159;0;150;0
WireConnection;159;1;145;0
WireConnection;157;0;152;0
WireConnection;155;0;145;0
WireConnection;155;1;151;0
WireConnection;18;0;16;0
WireConnection;18;1;13;0
WireConnection;164;1;154;0
WireConnection;19;0;18;0
WireConnection;19;1;20;4
WireConnection;163;0;145;0
WireConnection;163;1;155;0
WireConnection;192;0;196;0
WireConnection;192;1;191;0
WireConnection;160;0;158;0
WireConnection;160;1;159;0
WireConnection;161;0;157;0
WireConnection;161;1;156;1
WireConnection;242;1;239;0
WireConnection;241;0;240;0
WireConnection;241;1;97;0
WireConnection;162;1;153;0
WireConnection;243;0;242;0
WireConnection;244;0;241;0
WireConnection;244;1;98;0
WireConnection;165;0;163;0
WireConnection;165;1;161;0
WireConnection;175;0;19;0
WireConnection;175;1;192;0
WireConnection;168;0;162;0
WireConnection;168;1;160;0
WireConnection;166;0;164;0
WireConnection;169;0;168;0
WireConnection;169;1;166;0
WireConnection;21;0;175;0
WireConnection;21;1;22;0
WireConnection;90;0;74;0
WireConnection;90;1;91;0
WireConnection;245;0;244;0
WireConnection;245;1;243;0
WireConnection;170;0;167;0
WireConnection;170;1;165;0
WireConnection;171;0;169;0
WireConnection;171;1;170;0
WireConnection;209;0;210;0
WireConnection;209;1;21;0
WireConnection;246;0;245;0
WireConnection;246;1;90;0
WireConnection;108;0;107;0
WireConnection;172;0;171;0
WireConnection;87;0;209;0
WireConnection;112;0;110;1
WireConnection;203;0;19;0
WireConnection;203;1;202;0
WireConnection;111;0;246;0
WireConnection;111;1;110;1
WireConnection;0;0;111;0
WireConnection;0;1;109;0
WireConnection;0;2;89;0
WireConnection;0;3;176;0
WireConnection;0;5;113;0
WireConnection;0;11;88;0
ASEEND*/
//CHKSM=FAE35CB5AE21A611E6FDFA36340F7BCF349E1905