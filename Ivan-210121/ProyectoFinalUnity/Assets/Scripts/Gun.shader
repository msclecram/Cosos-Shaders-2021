Shader "Unlit/Gun"
{
    Properties
    {
         _MainTex("Texture", 2D) = "white" {}
         _FresnelColor("Fresnel Color",Color) = (1,1,1,1)
         _FresnelExponent("Fresnel Exponent",Range(0,10)) = 1
         _FresnelColor2("Fresnel Color2",Color) = (1,1,1,1)
         _FresnelExponent2("Fresnel Exponent2",Range(0,10)) = 1
         _FresnelColor3("Fresnel Color3",Color) = (1,1,1,1)
         _FresnelExponent3("Fresnel Exponent3",Range(0.25,4)) = 1

          intesity("Fresnel Intesity",Range(0.25,10.0)) = 1
          intesity2("Fresnel Intesity2",Range(0.25,10.0)) = 1
          intesity3("Fresnel Intesity3",Range(0.25,10.0)) = 1
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
                float4 worldPos:TEXCOORD2;
                float4 screenPos: TEXCOORD3;
                
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
                o.worldPos = mul(unity_ObjectToWorld, vertex);
                o.screenPos = ComputeScreenPos(outpos);
                return o;
            }

            sampler2D _MainTex;
            float4 _FresnelColor;
            float _FresnelExponent;

            float4 _FresnelColor2;
            float _FresnelExponent2;

            float4 _FresnelColor3;
            float _FresnelExponent3;

            float intesity;
            float intesity2;
            float intesity3;

            fixed4 frag(v2f i) : SV_Target
            {
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos.xyz);
                float fresnel = dot(i.worldNormal,viewDir);

                fresnel = saturate(1 - fresnel);
                fresnel = pow(fresnel, _FresnelExponent);
                //fresnel = clamp(fresnel, 0.2, 1.0);

                float fresnel2 = dot(i.worldNormal, viewDir);
                fresnel2 = saturate(1 - fresnel2);
                fresnel2 = pow(fresnel2, _FresnelExponent2);
                //fresnel2 = clamp(fresnel2, 0.2, 1.0);

                float fresnel3 = dot(i.worldNormal, viewDir);
                fresnel3 = saturate(1 - fresnel3);
                fresnel3 = pow(fresnel3, _FresnelExponent3);
                //fresnel3 = clamp(fresnel3, 0.2, 1.0);

                float4 fresnelColor = fresnel * _FresnelColor;
                float4 fresnelColor2 = fresnel2 * _FresnelColor2;
                float4 fresnelColor3 = fresnel3 * _FresnelColor3;

                float4  finalFresnel = fresnelColor*intesity + fresnelColor2*intesity2 + fresnelColor3*intesity3;

                float3 worldNormal = i.worldNormal ;
                float2 uv = i.screenPos.xy/i.screenPos.w;

                fixed4 c = tex2D(_MainTex, uv  + worldNormal.rg *0.02)  + finalFresnel ;
                
                return c;
            }
            ENDCG
        }
    }
}
