Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        unlitColor("Color", Color) = (1,1,1,1)
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 100

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                // make fog work
                #pragma multi_compile_fog

                #include "UnityCG.cginc"

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

            float4 unlitColor;
                sampler2D _MainTex;
                float4 _MainTex_ST;

                v2f vert(appdata v)
                {
                    v2f o;
                    float x = cos(v.vertex.x * 10.0 + _Time.y * 10.0);
                    float y = cos(v.vertex.y * 10.0 + _Time.y * 10.0);
                    float z = cos(v.vertex.z * 10.0 + _Time.y * 10.0);
                    float3 vert = v.vertex + float3(x , y, z) * 0.1;
                    o.vertex = UnityObjectToClipPos(vert);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    UNITY_TRANSFER_FOG(o,o.vertex);
                    return o;
                }

                float4 frag(v2f i) : SV_Target
                {
                    // sample the texture
                    float4 col = tex2D(_MainTex, i.uv) * unlitColor;
                    //float4 col = float4(0.1, 0.1, 0.1, 1.0);
                    // apply fog
                    UNITY_APPLY_FOG(i.fogCoord, col);
                    return col;
                }
                ENDCG
            }
        }
}