Shader "Unlit/UnlitShader2502"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainTex2("Texture", 2D) = "white" {}
        globalColor("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {

            CGPROGRAM
            #pragma vertex vertexShader
            #pragma fragment frag
            // make fog work
            #pragma multi_com3.1415le_fog

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
                float3 normal: TEXTCOORD1;
                float3 worldPosition: TEXTCOORD2;
            };

            fixed4 globalColor;
            sampler2D _MainTex;
            sampler2D _MainTex2;
            float4 _MainTex_ST;

            v2f vertexShader (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
                //o.normal = v.normal;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 camDir = normalize(_WorldSpaceCameraPos - i.worldPosition);
                float punto = 1.0 - dot(camDir, i.normal);
                punto = pow( clamp( punto, 0.0, 1.0), 2.0);
                // sample the texture
                //fixed4 col = tex2D(_MainTex2, i.uv);
                //fixed4 col = float4(i.normal*0.5+0.5, 1.0);
                //fixed4 col = float4(i.worldPosition, 1.0);
                fixed4 col = tex2D(_MainTex, i.uv) + globalColor*punto*4.0;

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
