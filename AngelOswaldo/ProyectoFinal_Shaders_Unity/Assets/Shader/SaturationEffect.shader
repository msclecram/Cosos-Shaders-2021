Shader "Hidden/SaturationEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color 0 to 0.5", Color) = (1, 1, 1, 1)
        _NearColor("Near Clip Color 0.6 to 0.7", Color) = (1, 1, 1, 1)
        _MediumColor("Medium Clip Color 0.7 to 0.8", Color) = (1, 1, 1, 1)
        _FarColor("Far Clip Color 0.8 to .9", Color) = (1, 1, 1, 1)
        _LightColor("Far Clip Color 0.9 to 1", Color) = (1, 1, 1, 1)
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
            sampler2D _CameraDepthTexture;
            fixed4 _Color;
            fixed4 _NearColor;
            fixed4 _MediumColor;
            fixed4 _FarColor;
            fixed4 _LightColor;

            fixed4 frag (v2f i) : SV_Target
            {
                /*float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
                depth = pow(Linear01Depth(depth), 1);
                return lerp(_NearColor, _FarColor, depth);*/
                fixed4 col = tex2D(_MainTex, i.uv);


                float RGB = (col.r + col.g + col.b) / 3;
                fixed4 newCol = fixed4(RGB, RGB, RGB, 1);

                if (RGB <= 0.5)
                {
                    return lerp(col, _Color, RGB);
                }
                else if (RGB > 0.5 && RGB <= 0.7)
                {
                    return lerp(col, _NearColor, RGB);
                }
                else if (RGB > 0.7 && RGB <= 0.8)
                {
                    return lerp(col, _MediumColor, RGB);
                }
                else if (RGB > 0.8 && RGB <= 0.9)
                {
                    return lerp(col, _FarColor, RGB);
                }
                else if (RGB > 0.9 && RGB <= 1)
                {
                    return lerp(col, _LightColor, RGB);
                }
                return col;
            }
            ENDCG
        }
    }
}
