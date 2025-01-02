Shader "Custom/paryi_PhoneRender"
{
    Properties
    {
        [Toggle] _IS_VRCHAT_CAM_ONLY("Is VRChat Camera Only", Float) = 1
        _BarColor("Bar Color", Color) = (0, 0, 0, 1)
        _MainTex("Image", 2D) = "white" {}
        _Aspect("Aspect", Float) = 1.7777777
        _Distance("Distance", Float) = 1.0
        [Toggle] _Rotate90("Rotate 90 Degrees Clockwise", Float) = 0
        [Toggle] _Rotate180("Rotate 180 Degrees", Float) = 0
        [Toggle] _RotateMinus90("Rotate -90 Degrees Counterclockwise", Float) = 0
        _Scale("Scale", Float) = 1.0
        _ScreenScale("Screen Scale", Float) = 1.0 // 画面全体のスケール
    }
        SubShader
        {
            Tags { "RenderType" = "Transparent" "Queue" = "Overlay+6000" "IgnoreProjector" = "True" }
            LOD 100

            Pass
            {
                ZTest Always
                ZWrite Off
                Cull Off

                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma multi_compile_fog
                #include "UnityCG.cginc"
                #define PI 3.14159265
                #define DEG2RAD PI / 180.0f
                #define RAD2DEG 180.0f / UNITY_PI

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    UNITY_FOG_COORDS(1)
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;

                float _Distance;
                float _Aspect;
                float4 _BarColor;

                float _VRChatCameraMode;
                float _Rotate90;
                float _Rotate180;
                float _RotateMinus90;
                float _Scale;
                float _ScreenScale;

                #pragma shader_feature _IS_VRCHAT_CAM_ONLY_ON

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = float4(2 * v.uv.x + 1 - 2, 1 - 2 * v.uv.y, 1, 1);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    if (_ProjectionParams.x > 0)
                    {
                        o.uv.y = 1.0f - o.uv.y;
                    }
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    // カメラとの距離に基づくカリング
                    float sX = 1 / sqrt(pow(unity_WorldToObject[0].x, 2) + pow(unity_WorldToObject[0].y, 2) + pow(unity_WorldToObject[0].z, 2));
                    float sY = 1 / sqrt(pow(unity_WorldToObject[1].x, 2) + pow(unity_WorldToObject[1].y, 2) + pow(unity_WorldToObject[1].z, 2));
                    float size = (sX + sY) / 2;
                    float distance = length(mul(unity_ObjectToWorld, float4(0, 0, 0, 1)) - _WorldSpaceCameraPos) + size / 3;

                    if (distance > _Distance) discard;

                    // VRChatモードでの描画
                    #ifdef _IS_VRCHAT_CAM_ONLY_ON
                    if (_VRChatCameraMode == 0.0f) discard;
                    #endif

                    // アスペクト比調整
                    float aspectAdjustedY = _Aspect * _ScreenParams.y / _ScreenParams.x;
                    i.uv.y *= aspectAdjustedY;
                    i.uv.y -= (aspectAdjustedY - 1.0f) * 0.5f;

                    // 画面全体のスケール調整（画面の中心を基準にスケーリング）
                    float2 screenCenter = float2(0.5, 0.5);
                    i.uv -= screenCenter; // UV座標を中心に移動
                    i.uv *= _ScreenScale; // スケーリング
                    i.uv += screenCenter; // UV座標を元に戻す

                    // UVが範囲外の場合、背景色を表示
                    if (i.uv.x < 0.0f || i.uv.x > 1.0f || i.uv.y < 0.0f || i.uv.y > 1.0f)
                    {
                        return _BarColor; // 背景色を表示
                    }

                    // スケール調整
                    i.uv *= _Scale;

                    // 時計回りに90度回転
                    if (_Rotate90 == 1)
                    {
                        // UVの座標を90度回転
                        float temp = i.uv.x;
                        i.uv.x = 1.0f - i.uv.y;
                        i.uv.y = temp;
                    }

                    // 180度回転
                    if (_Rotate180 == 1)
                    {
                        // UVの座標を180度回転
                        i.uv.x = 1.0f - i.uv.x;
                        i.uv.y = 1.0f - i.uv.y;
                    }

                    // -90度回転
                    if (_RotateMinus90 == 1)
                    {
                        // UVの座標を-90度回転
                        float temp = i.uv.x;
                        i.uv.x = i.uv.y;
                        i.uv.y = 1.0f - temp;
                    }

                    // カメラ映像のサンプリング
                    fixed4 col = tex2D(_MainTex, i.uv);
                    return col;
                }
                ENDCG
            }
        }
            FallBack "Diffuse"
}