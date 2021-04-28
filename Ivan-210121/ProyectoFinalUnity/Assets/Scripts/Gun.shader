Shader "Unlit/Gun"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
        SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            // note: no SV_POSITION in this struct
            struct v2f {
                float2 uv : TEXCOORD0;
                half3 worldNormal :TEXCOORD1;
            };

            v2f vert(
                float4 vertex : POSITION, // vertex position input
                float2 uv : TEXCOORD0, // texture coordinate input
                float3 normal : NORMAL,
                out float4 outpos : SV_POSITION // clip space position output
                )
            {
                v2f o;
                o.uv = uv;
                outpos = UnityObjectToClipPos(vertex);
                o.worldNormal = UnityObjectToWorldNormal(normal);
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag(v2f i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_Target
            {
                // screenPos.xy will contain pixel integer coordinates.
                // use them to implement a checkerboard pattern that skips rendering
                // 4x4 blocks of pixels

                // checker value will be negative for 4x4 blocks of pixels
                // in a checkerboard pattern
                //screenPos.xy = floor(screenPos.xy * 0.25) * 0.5;
                //float checker = -frac(screenPos.r + screenPos.g);

                // clip HLSL instruction stops rendering a pixel if value is negative
                //clip(checker);

                // for pixels that were kept, read the texture and output it
                float3 worldNormal = i.worldNormal * 0.5 + 0.5;
                float2 uv = screenPos.xy / _ScreenParams.xy;
                fixed4 c = tex2D(_MainTex, uv * 2.0 + worldNormal.g * 0.02);
                
                return c;
            }
            ENDCG
        }
    }
}
