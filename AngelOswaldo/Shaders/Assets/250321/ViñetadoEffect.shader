Shader "Hidden/ViñetadoEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _VRadius("Vignette Radius", Range(0.0, 1.0)) = 0.8
        _VSoft("Vignette Softness", Range(0.0, 1.0)) = 0.5
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
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
            float4 _Color;
            float _VRadius;
            float _VSoft;

            fixed4 frag (v2f_img i) : COLOR
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                
                float distFromCenter = distance(i.uv.xy, float2(0.5, 0.5));
                float vignette = smoothstep(_VRadius, _VRadius - _VSoft, distFromCenter);
                col = (col * vignette);

                return col;
            }
            ENDCG
        }
    }
}
