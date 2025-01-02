// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "tears_shader"
{
	Properties
	{
		_Tex_mainTear1("Tex_mainTear", 2D) = "black" {}
		_LR_TimeoffsetXoffset("LR_Timeoffset&Xoffset", Vector) = (0,0,0,0)
		_tear_spead("tear_spead", Range( 0 , 2)) = 0.5
		_opacity("opacity", Range( 0 , 1)) = 1
		_fade_point("fade_point", Range( 0.2 , 0.3)) = 0.278
		_emissive("emissive", Range( 0 , 2)) = 2
		_scale("scale", Vector) = (1.4,5,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit alpha:fade keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float eyeDepth;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _Tex_mainTear1;
		uniform float _tear_spead;
		uniform float2 _scale;
		uniform float4 _LR_TimeoffsetXoffset;
		uniform float _fade_point;
		uniform float _opacity;
		uniform float _emissive;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float2 voronoihash330( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi330( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash330( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		float2 voronoihash254( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi254( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash254( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		float2 voronoihash231( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi231( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash231( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		float2 voronoihash411( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi411( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash411( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.500 * pow( ( pow( abs( r.x ), 1 ) + pow( abs( r.y ), 1 ) ), 1.000 );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 uv_TexCoord331 = i.uv_texcoord * float2( 2.1,1.91 ) + float2( -0.04,-0.05 );
			float time330 = -2.18;
			float2 voronoiSmoothId330 = 0;
			float2 uv_TexCoord365 = i.uv_texcoord * float2( 1.61,1.41 ) + float2( -0.04,0 );
			float2 panner364 = ( 1.0 * _Time.y * float2( -1,0 ) + uv_TexCoord365);
			float2 coords330 = panner364 * 2.12;
			float2 id330 = 0;
			float2 uv330 = 0;
			float fade330 = 0.5;
			float voroi330 = 0;
			float rest330 = 0;
			for( int it330 = 0; it330 <6; it330++ ){
			voroi330 += fade330 * voronoi330( coords330, time330, id330, uv330, 0,voronoiSmoothId330 );
			rest330 += fade330;
			coords330 *= 2;
			fade330 *= 0.5;
			}//Voronoi330
			voroi330 /= rest330;
			float cameraDepthFade369 = (( i.eyeDepth -_ProjectionParams.y - -0.1 ) / 0.45);
			float2 temp_output_333_0 = ( uv_TexCoord331 + ( voroi330 * ( cameraDepthFade369 * 0.2252712 ) ) );
			float4 tex2DNode334 = tex2D( _Tex_mainTear1, temp_output_333_0 );
			float2 appendResult279 = (float2(0.0 , _tear_spead));
			float2 tear_spead281 = appendResult279;
			float2 uv_TexCoord225 = i.uv_texcoord * _scale;
			float2 panner257 = ( 1.0 * _Time.y * tear_spead281 + uv_TexCoord225);
			float2 break260 = panner257;
			float2 appendResult258 = (float2(( break260.x + _LR_TimeoffsetXoffset.w ) , ( break260.y + _LR_TimeoffsetXoffset.y )));
			float time254 = ( _SinTime.z * 20.0 );
			float2 voronoiSmoothId254 = 0;
			float2 uv_TexCoord251 = i.uv_texcoord + float2( -0.04,0 );
			float2 coords254 = uv_TexCoord251 * -2.94;
			float2 id254 = 0;
			float2 uv254 = 0;
			float fade254 = 0.5;
			float voroi254 = 0;
			float rest254 = 0;
			for( int it254 = 0; it254 <6; it254++ ){
			voroi254 += fade254 * voronoi254( coords254, time254, id254, uv254, 0,voronoiSmoothId254 );
			rest254 += fade254;
			coords254 *= 2;
			fade254 *= 0.5;
			}//Voronoi254
			voroi254 /= rest254;
			float2 temp_output_256_0 = ( appendResult258 + ( voroi254 * 0.01 ) );
			float clampResult264 = clamp( ceil( ( i.uv_texcoord.x - 0.5 ) ) , 0.0 , 1.0 );
			float2 panner226 = ( 1.0 * _Time.y * tear_spead281 + uv_TexCoord225);
			float2 break245 = panner226;
			float2 appendResult249 = (float2(( break245.x + _LR_TimeoffsetXoffset.z ) , ( break245.y + _LR_TimeoffsetXoffset.x )));
			float time231 = ( _SinTime.z * 10.0 );
			float2 voronoiSmoothId231 = 0;
			float2 uv_TexCoord230 = i.uv_texcoord + float2( -0.04,0 );
			float2 coords231 = uv_TexCoord230 * -2.94;
			float2 id231 = 0;
			float2 uv231 = 0;
			float fade231 = 0.5;
			float voroi231 = 0;
			float rest231 = 0;
			for( int it231 = 0; it231 <6; it231++ ){
			voroi231 += fade231 * voronoi231( coords231, time231, id231, uv231, 0,voronoiSmoothId231 );
			rest231 += fade231;
			coords231 *= 2;
			fade231 *= 0.5;
			}//Voronoi231
			voroi231 /= rest231;
			float2 temp_output_234_0 = ( appendResult249 + ( voroi231 * 0.01 ) );
			float temp_output_267_0 = ( 1.0 - clampResult264 );
			float clampResult237 = clamp( abs( ( i.uv_texcoord.y - _fade_point ) ) , 0.0 , 1.0 );
			float temp_output_239_0 = ( 1.0 - ( clampResult237 * 4.88 ) );
			float mask94 = ( ( ( tex2D( _Tex_mainTear1, temp_output_256_0 ).g * clampResult264 ) + ( tex2D( _Tex_mainTear1, temp_output_234_0 ).g * temp_output_267_0 ) ) * temp_output_239_0 );
			float temp_output_431_0 = ( mask94 * 0.47 );
			float normalizeResult11 = normalize( ( i.uv_texcoord.y - 0.5 ) );
			float temp_output_5_0 = ceil( ( ( 1.0 - normalizeResult11 ) - 0.5 ) );
			float clampResult49 = clamp( ( temp_output_5_0 * temp_output_5_0 ) , 0.0 , 1.0 );
			float lerpResult8 = lerp( tex2DNode334.r , temp_output_431_0 , clampResult49);
			float clampResult160 = clamp( lerpResult8 , 0.0 , 1.0 );
			float temp_output_284_0 = ( clampResult160 * _opacity );
			float nomals92 = ( ( 0.0 * clampResult264 ) + ( 0.0 * temp_output_267_0 ) );
			float lerpResult435 = lerp( 0.0 , ( nomals92 * 0.7 ) , clampResult49);
			float time411 = _SinTime.z;
			float2 voronoiSmoothId411 = 0;
			float2 panner413 = ( 1.0 * _Time.y * float2( -1,0 ) + i.uv_texcoord);
			float2 coords411 = panner413 * 4.79;
			float2 id411 = 0;
			float2 uv411 = 0;
			float fade411 = 0.5;
			float voroi411 = 0;
			float rest411 = 0;
			for( int it411 = 0; it411 <7; it411++ ){
			voroi411 += fade411 * voronoi411( coords411, time411, id411, uv411, 0,voronoiSmoothId411 );
			rest411 += fade411;
			coords411 *= 2;
			fade411 *= 0.5;
			}//Voronoi411
			voroi411 /= rest411;
			float4 screenColor308 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_grabScreenPosNorm + ( ( ( temp_output_284_0 * lerpResult435 ) * ( clampResult49 + ( ( tex2DNode334.b * 9.5 ) * ( pow( voroi411 , 2.33 ) * 10.0 ) ) ) ) * 0.3 ) ).xy/( ase_grabScreenPosNorm + ( ( ( temp_output_284_0 * lerpResult435 ) * ( clampResult49 + ( ( tex2DNode334.b * 9.5 ) * ( pow( voroi411 , 2.33 ) * 10.0 ) ) ) ) * 0.3 ) ).w);
			float cameraDepthFade375 = (( i.eyeDepth -_ProjectionParams.y - -0.5 ) / 1.17);
			float clampResult428 = clamp( cameraDepthFade375 , -0.5 , 3.0 );
			float temp_output_376_0 = ( temp_output_284_0 * clampResult428 );
			float low_mask424 = normalizeResult11;
			float lowtear445 = temp_output_431_0;
			float clampResult448 = clamp( lowtear445 , 0.0 , 1.0 );
			float4 temp_cast_0 = (clampResult448).xxxx;
			float4 clampResult451 = clamp( ( ( ( ( screenColor308 + ( ( _emissive * 1.0 ) * temp_output_376_0 ) ) + ( temp_output_376_0 * ( ( tex2DNode334.b * low_mask424 ) * 4.1 ) ) ) - temp_cast_0 ) + clampResult448 ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			o.Emission = clampResult451.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.RangedFloatNode;280;-6768,1152;Inherit;False;Property;_tear_spead;tear_spead;5;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;279;-6495.819,1142.11;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;281;-6352,1152;Inherit;False;tear_spead;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;432;-6496,576;Inherit;False;Property;_scale;scale;9;0;Create;True;0;0;0;False;0;False;1.4,5;1.4,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;282;-5696,1648;Inherit;False;281;tear_spead;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;283;-5305.531,366.322;Inherit;False;281;tear_spead;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;225;-6064,560;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.4,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;228;-5280,2128;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;250;-5336.622,820.9464;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;226;-5488,1536;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;257;-5064.622,260.9464;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;230;-5056,1888;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.04,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;251;-5112.622,580.9464;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.04,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;252;-5096.622,868.9464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;260;-4824.622,276.9464;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;261;-3648,976;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;245;-5248,1552;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.Vector4Node;276;-5744,1136;Inherit;False;Property;_LR_TimeoffsetXoffset;LR_Timeoffset&Xoffset;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0.49,0.11,-0.6;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;-5040,2176;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;246;-4608,1728;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;254;-4856.622,724.9464;Inherit;False;0;0;1;0;6;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;-2.94;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;263;-3360,1040;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;277;-4848.546,1442.984;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;259;-4664.622,420.9464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;278;-4647.918,48.5293;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;231;-4800,2032;Inherit;False;0;0;1;0;6;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;-2.94;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;235;-3648,1584;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;242;-3664,1856;Inherit;False;Property;_fade_point;fade_point;7;0;Create;True;0;0;0;False;0;False;0.278;0.3;0.2;0.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;249;-4432,1568;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;258;-4488.622,260.9464;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CeilOpNode;262;-3104,992;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;240;-3376,1632;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.27;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;232;-4608,2032;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;255;-4664.622,724.9464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1968,96;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;234;-4224,1568;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;264;-2896,1024;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;236;-3184,1632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;256;-4320,608;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;10;-1712,144;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;267;-2640,1040;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;237;-3024,1632;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;244;-4000,784;Inherit;True;Property;_tear45;tear44;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;223;-3984,1328;Inherit;True;Property;_tear44;tear44;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;365;-2704,-1072;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.61,1.41;False;1;FLOAT2;-0.04,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;370;-2528,-608;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;0;False;0;False;0.45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;371;-2480,-400;Inherit;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;-0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;11;-1616,-64;Inherit;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;-2451.489,633.5916;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;238;-2784,1632;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4.88;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;-2432,1360;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;364;-2400,-1056;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;243;-2128,-624;Inherit;False;Constant;_noise_;noise_;4;0;Create;True;0;0;0;False;0;False;0.2252712;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;369;-2272,-768;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;12;-1408,144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;239;-2560,1632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;330;-2112,-1104;Inherit;False;0;0;1;0;6;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;-2.18;False;2;FLOAT;2.12;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;368;-1839.693,-900.9305;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-1216,144;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;382;-3984,1136;Inherit;True;Property;_tear_mask41;tear_mask4 1;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;384;-4016,576;Inherit;True;Property;_tear47;tear44;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;-1600,1424;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;332;-1744,-1376;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;331;-1904,-1792;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2.1,1.91;False;1;FLOAT2;-0.04,-0.05;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CeilOpNode;5;-1072,144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;414;-192,208;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;392;-4448,1216;Inherit;False;tex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;387;-2416,1120;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;386;-2448,400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;333;-1392,-1408;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-944,128;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;416;192,320;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;413;64,128;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;-1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;-384,640;Inherit;False;94;mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;393;-1520,-896;Inherit;False;392;tex;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ClampOpNode;49;-688,128;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;334;-1184,-896;Inherit;True;Property;_BaseTear_tex1;BaseTear_tex;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;411;416,64;Inherit;False;0;4;1;3;7;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;4.79;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;431;-144.3511,622.1398;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;388;-1520,-640;Inherit;True;Property;_Tex_mainNOr;Tex_mainNOr;2;0;Create;True;0;0;0;False;0;False;05a42f09af33e1f4da4b651d42aa58f7;05a42f09af33e1f4da4b651d42aa58f7;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;8;32,416;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;417;608,96;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2.33;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-272,-224;Inherit;False;92;nomals;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;434;-176,-16;Inherit;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;390;-1168,-592;Inherit;True;Property;_BaseTear_tex2;BaseTear_tex;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;408;800,112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;405;128,-336;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;9.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;433;-14.34753,-81.099;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;752,512;Inherit;False;Property;_opacity;opacity;6;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;160;480,400;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;435;1088,-560;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;401;1072,-48;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;398;1360,-384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;404;1072,-272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;403;1584,-112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;424;-1144.258,-76.2226;Inherit;False;low_mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;394;1680,-592;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;396;1744,-400;Inherit;False;Constant;_Float4;Float 4;9;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;425;1840,-256;Inherit;False;424;low_mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;307;1472,-768;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;395;1955.101,-564.1647;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;2000,0;Inherit;False;Property;_emissive;emissive;8;0;Create;True;0;0;0;False;0;False;2;0.113;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;428;2208,304;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.5;False;2;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;418;2176,-320;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;312;2048,-768;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;338;2400,-96;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;308;2336,-592;Float;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;0;False;0;False;Object;-1;False;True;False;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;426;2720,288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;400;2656,-144;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;445;118.7589,814.8849;Inherit;False;lowtear;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;429;3120,160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;326;2816,-464;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.09433961;False;1;COLOR;0
Node;AmplifyShaderEditor.CeilOpNode;297;896,-560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;296;352,-560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;363;-2049.339,-1436.804;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;329;-2528,-1360;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.04,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;383;-3680.619,-16.02625;Inherit;True;Property;_tear46;tear44;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;443;-2356.635,1658.427;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;295;-384,-848;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;193;4016,-720;Float;False;True;-1;4;ASEMaterialInspector;0;0;Unlit;tears_shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TexturePropertyNode;380;-4800,1056;Inherit;True;Property;_Tex_mainTear1;Tex_mainTear;0;0;Create;False;0;0;0;False;0;False;8b5e5f37e257f2d4a8d0401fc32e3754;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;7;3758.64,-694.3287;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;385;-4272,896;Inherit;True;Property;_Tex_dropNor;Tex_dropNor;1;0;Create;True;0;0;0;False;0;False;1dcddff6b05c76245be5992d68da0fab;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;273;-1931.85,1344.675;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;270;-1859.191,955.5168;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-1264,1072;Inherit;False;nomals;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-1248,1360;Inherit;False;mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;284;1180.482,313.6924;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;373;1735.2,288;Inherit;False;Constant;_Float2;Float 0;8;0;Create;True;0;0;0;False;0;False;1.17;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;374;1751.2,512;Inherit;False;Constant;_Float3;Float 1;8;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;375;1935.7,257.3;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;376;2420.38,608.9429;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;423;3161.401,-477.4999;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;446;3045,-203.7;Inherit;False;445;lowtear;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;448;3271.696,-138.7;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;450;4309.185,-313.937;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;449;3442,-490;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;447;3662,-476;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;451;3924.262,-255.9884;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
WireConnection;279;1;280;0
WireConnection;281;0;279;0
WireConnection;225;0;432;0
WireConnection;226;0;225;0
WireConnection;226;2;282;0
WireConnection;257;0;225;0
WireConnection;257;2;283;0
WireConnection;252;0;250;3
WireConnection;260;0;257;0
WireConnection;245;0;226;0
WireConnection;229;0;228;3
WireConnection;246;0;245;1
WireConnection;246;1;276;1
WireConnection;254;0;251;0
WireConnection;254;1;252;0
WireConnection;263;0;261;1
WireConnection;277;0;245;0
WireConnection;277;1;276;3
WireConnection;259;0;260;1
WireConnection;259;1;276;2
WireConnection;278;0;260;0
WireConnection;278;1;276;4
WireConnection;231;0;230;0
WireConnection;231;1;229;0
WireConnection;249;0;277;0
WireConnection;249;1;246;0
WireConnection;258;0;278;0
WireConnection;258;1;259;0
WireConnection;262;0;263;0
WireConnection;240;0;235;2
WireConnection;240;1;242;0
WireConnection;232;0;231;0
WireConnection;255;0;254;0
WireConnection;234;0;249;0
WireConnection;234;1;232;0
WireConnection;264;0;262;0
WireConnection;236;0;240;0
WireConnection;256;0;258;0
WireConnection;256;1;255;0
WireConnection;10;0;4;2
WireConnection;267;0;264;0
WireConnection;237;0;236;0
WireConnection;244;0;380;0
WireConnection;244;1;256;0
WireConnection;223;0;380;0
WireConnection;223;1;234;0
WireConnection;11;0;10;0
WireConnection;271;0;244;2
WireConnection;271;1;264;0
WireConnection;238;0;237;0
WireConnection;266;0;223;2
WireConnection;266;1;267;0
WireConnection;364;0;365;0
WireConnection;369;0;370;0
WireConnection;369;1;371;0
WireConnection;12;0;11;0
WireConnection;239;0;238;0
WireConnection;330;0;364;0
WireConnection;368;0;369;0
WireConnection;368;1;243;0
WireConnection;13;0;12;0
WireConnection;382;0;385;0
WireConnection;382;1;234;0
WireConnection;384;0;385;0
WireConnection;384;1;256;0
WireConnection;241;0;273;0
WireConnection;241;1;239;0
WireConnection;332;0;330;0
WireConnection;332;1;368;0
WireConnection;5;0;13;0
WireConnection;392;0;380;0
WireConnection;387;1;267;0
WireConnection;386;1;264;0
WireConnection;333;0;331;0
WireConnection;333;1;332;0
WireConnection;45;0;5;0
WireConnection;45;1;5;0
WireConnection;413;0;414;0
WireConnection;49;0;45;0
WireConnection;334;0;393;0
WireConnection;334;1;333;0
WireConnection;411;0;413;0
WireConnection;411;1;416;3
WireConnection;431;0;95;0
WireConnection;8;0;334;1
WireConnection;8;1;431;0
WireConnection;8;2;49;0
WireConnection;417;0;411;0
WireConnection;390;0;388;0
WireConnection;390;1;333;0
WireConnection;408;0;417;0
WireConnection;405;0;334;3
WireConnection;433;0;96;0
WireConnection;433;1;434;0
WireConnection;160;0;8;0
WireConnection;435;1;433;0
WireConnection;435;2;49;0
WireConnection;401;0;405;0
WireConnection;401;1;408;0
WireConnection;398;0;284;0
WireConnection;398;1;435;0
WireConnection;404;0;49;0
WireConnection;404;1;401;0
WireConnection;403;0;398;0
WireConnection;403;1;404;0
WireConnection;424;0;11;0
WireConnection;394;0;403;0
WireConnection;395;0;394;0
WireConnection;395;1;396;0
WireConnection;428;0;375;0
WireConnection;418;0;334;3
WireConnection;418;1;425;0
WireConnection;312;0;307;0
WireConnection;312;1;395;0
WireConnection;338;0;44;0
WireConnection;308;0;312;0
WireConnection;426;0;418;0
WireConnection;400;0;338;0
WireConnection;400;1;376;0
WireConnection;445;0;431;0
WireConnection;429;0;376;0
WireConnection;429;1;426;0
WireConnection;326;0;308;0
WireConnection;326;1;400;0
WireConnection;297;0;296;0
WireConnection;296;0;295;0
WireConnection;363;0;329;0
WireConnection;443;0;239;0
WireConnection;295;0;334;1
WireConnection;193;2;451;0
WireConnection;7;1;96;0
WireConnection;7;2;49;0
WireConnection;273;0;271;0
WireConnection;273;1;266;0
WireConnection;270;0;386;0
WireConnection;270;1;387;0
WireConnection;92;0;270;0
WireConnection;94;0;241;0
WireConnection;284;0;160;0
WireConnection;284;1;285;0
WireConnection;375;0;373;0
WireConnection;375;1;374;0
WireConnection;376;0;284;0
WireConnection;376;1;428;0
WireConnection;423;0;326;0
WireConnection;423;1;429;0
WireConnection;448;0;446;0
WireConnection;449;0;423;0
WireConnection;449;1;448;0
WireConnection;447;0;449;0
WireConnection;447;1;448;0
WireConnection;451;0;447;0
ASEEND*/
//CHKSM=3D002ED7A7888CA5D51D62D4276B8969A6F81119