Shader "Hidden/Noise_Grain"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainTex2("Texture_Noise", 2D) = "white" {}
        _LerpValue("NoiseScale", Range(0.0, 1.0)) = 0.1
        _ScaleUV("UVScale", Range(0.0, 10.0)) = 1.0
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
            sampler2D _MainTex2;
            float _LerpValue;
            float _ScaleUV;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 noise = tex2D(_MainTex2, i.uv * _ScaleUV);
                // just invert the colors
                col = col + noise*_LerpValue;
                //fixed4 col = lerp(tex2D(_MainTex, i.uv) , tex2D(_MainTex2, i.uv*5.0), _LerpValue);
                return col;
            }
            ENDCG
        }
    }
}
