Shader "Hidden/SaturationLuminationEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _GBDarkest("GB (Darkest)", Color) = (0.06, 0.22, 0.06, 1.0)
        _GBDark("GB (Dark)", Color) = (0.19, 0.38, 0.19, 1.0)
        _GBLight("GB (Light)", Color) = (0.54, 0.67, 0.06, 1.0)
        _GBLightest("GB (Lightest)", Color) = (0.61, 0.73, 0.06, 1.0)
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float4 _GBDarkest;
            float4 _GBDark;
            float4 _GBLight;
            float4 _GBLightest;

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex, i.uv);
                float lum = dot(tex,float3(0.3,0.59,0.11));
                int gb = lum * 3;
                
                float3 col = lerp(_GBDarkest, _GBDark, saturate(gb));
                col = lerp(col, _GBLight, saturate(gb - 1.0));
                col = lerp(col, _GBLightest, saturate(gb - 2.0));

                return float4(col, 1.0);
            }
            ENDCG
        }
    }
}
