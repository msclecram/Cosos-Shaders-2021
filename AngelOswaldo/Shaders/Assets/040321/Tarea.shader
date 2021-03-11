Shader "Unlit/Tarea"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _MainTex2("Texture", 2D) = "white" {}
        _Blend("Blend Amount", Range(0,1)) = 0.5
        _globalColor("Color", Color) = (1,1,1,1)

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
                    float3 normal: NORMAL;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    UNITY_FOG_COORDS(1)
                    float4 vertex : SV_POSITION;
                    float3 normal: TEXCOORD1;
                    float3 worldPosition: TEXCOORD2;
                };

                fixed4 _globalColor;
                sampler2D _MainTex;
                sampler2D _MainTex2;
                float4 _MainTex_ST;
                float4 _MainTex2_ST;
                float _Blend;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    o.normal = UnityObjectToWorldNormal(v.normal);
                    o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
                    //o.o normal = v.normal;
                    UNITY_TRANSFER_FOG(o,o.vertex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    float3 camDir = normalize(_WorldSpaceCameraPos.y -i.worldPosition.y);
                    float punto = -dot(camDir, i.normal);
                    punto = pow(clamp(punto, 0.0, 1.0), 2.0);


                    // sample the texture
                    //fixed4 col = tex2D(_MainTex, i.uv);
                    //fixed4 col = float4(i.worldPosition,1.0);
                    float4 gradiant = 1.0 - clamp(i.worldPosition.y, 0.0, 0.5) / 0.5;
                    fixed4 col = lerp(tex2D(_MainTex, i.uv) + _globalColor* punto*4.0, tex2D(_MainTex2, i.uv), _Blend);
                    // apply fog
                    UNITY_APPLY_FOG(i.fogCoord, col);
                    return col;
                }
                ENDCG
            }
        }
}
