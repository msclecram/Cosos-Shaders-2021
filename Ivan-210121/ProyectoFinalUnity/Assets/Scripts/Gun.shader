Shader "Unlit/Gun"
{
    Properties
    {
         _MainTex("Texture", 2D) = "white" {}
         _FresnelColor("Fresnel Color",Color) = (1,1,1,1)
         _FresnelExponent("Fresnel Exponent",Range(0,4)) = 1
    }
        SubShader
    {
        //Tags{"RenderType" = "Opaque" "Queue"="Geometry"}
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
                float3 viewDir:TEXCOORD2;
            };

            v2f vert(
                float4 vertex : POSITION, // vertex position input
                float2 uv : TEXCOORD0, // texture coordinate input
                float3 normal : NORMAL,
                float3 viewDir: TEXCOORD2,
                out float4 outpos : SV_POSITION // clip space position output
                )
            {
                v2f o;
                o.uv = uv;
                outpos = UnityObjectToClipPos(vertex);
                o.worldNormal = UnityObjectToWorldNormal(normal);
                o.viewDir = WorldSpaceViewDir(vertex);
                return o;
            }

            sampler2D _MainTex;
            float4 _FresnelColor;
            float _FresnelExponent;

            fixed4 frag(v2f i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_Target
            {
               
                float fresnel = dot(i.worldNormal,i.viewDir);
                fresnel = saturate(1 - fresnel);
                fresnel = pow(fresnel, _FresnelExponent);

                float4 fresnelColor = fresnel * _FresnelColor;
                float3 worldNormal = i.worldNormal * 0.5 + 0.5;
                float2 uv = screenPos.xy / _ScreenParams.xy;

                fixed4 c = tex2D(_MainTex, uv *2.0 + worldNormal.g * 0.02) + fresnelColor;
                
                return c;
            }
            ENDCG
        }
    }
}
