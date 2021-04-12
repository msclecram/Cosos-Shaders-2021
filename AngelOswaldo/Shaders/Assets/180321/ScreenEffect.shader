Shader "Hidden/ScreenEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            sampler2D _CameraGBufferTexture0;
            sampler2D _CameraGBufferTexture1;
            sampler2D _CameraGBufferTexture2;
            sampler2D _CameraDepthTexture;

            float toonChannel(float c, float steps)
            {
                return floor(c * steps) / steps;
            }

            float isEdge(float2 uv)
            {
                float threshold = 0.003;
                float radius = 0.002;
                int slices = 8;
                float depthC = tex2D(_CameraDepthTexture, uv).r;

                for (int r = 0; r < slices; r++)
                {
                    float angle = (float(r) / float(slices)) * 2.0 * 3.1416;
                    float circlePoint = float2(cos(angle), sin(angle)) * radius;
                    float depth = tex2D(_CameraDepthTexture, uv + circlePoint).r;
                    if (abs(depthC - depth) > threshold)
                        return 0.0;
                }
                return 1.0;
            }

            fixed4 frag(v2f i) : SV_Target
            {

                //separar colores
                fixed4 col = tex2D(_MainTex, i.uv);
                float steps = 10.0;
                col.r = toonChannel(col.r, steps);
                col.g = toonChannel(col.g, steps);
                col.b = toonChannel(col.b, steps);
                
                //outline
                float outline = isEdge(i.uv);
                col = col * outline;
                return col;

            }

            /*fixed4 frag(v2f i) : SV_Target
            {
                float2 displacementR = float2(0.05,0.05);
                float2 displacementG = float2(0.05, -0.05);
                float2 displacementB = float2(-0.05, 0.5);
                float scale = 0.05;

                float row = sign(cos(i.uv.y*50.0)+ sin(i.uv.y * 100.0 + _Time.y * 100000.0) + cos(i.uv.y * 200.0 +_Time.y*100000.0));
                scale *= row;
                
                fixed4 colR = tex2D(_MainTex, i.uv + displacementR * scale);
                fixed4 colG = tex2D(_MainTex, i.uv+ displacementG * scale);
                fixed4 colB = tex2D(_MainTex, i.uv+ displacementB * scale);

                fixed4 col = fixed4(colR.r, colG.g, colB.b, 1.0);
                // just invert the colors
                //col.rgb = 1 - col.rgb;
                return col;
                //return float4(i.uv, 0.0, 1.0);
            }*/
            ENDCG
        }
    }
}
