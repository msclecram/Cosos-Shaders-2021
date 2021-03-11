Shader "Custom/NewSurfaceShader090321"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _NormalTex("Normal (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
        _Skybox("Skymap",CUBE) = ""{}
        _edgeIntensity("Intensity", Range(0,1))=0.0
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma surface surf Standard fullforwardshadows

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0

            sampler2D _MainTex;
            sampler2D _NormalTex;
            samplerCUBE _Skybox;

            struct Input
            {
                float2 uv_NormalMapTex;
                float3 worldPos;
                float3 worldNormal; INTERNAL_DATA
                float3 viewDir;
                float2 uv_MainTex;
            };

            half _Glossiness;
            half _Metallic;
            fixed4 _Color;
            fixed4 _Color2;
            half _edgeIntensity = 0;
            half _rainIntensity = 1;

            // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
            // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
            // #pragma instancing_options assumeuniformscaling
            UNITY_INSTANCING_BUFFER_START(Props)
                // put more per-instance properties here
            UNITY_INSTANCING_BUFFER_END(Props)

            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                // Albedo comes from a texture tinted by color
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
                o.Albedo = c.rgb;
                float4 gray = (c.r + c.g + c.b) / 3.0;
                // Metallic and smoothness come from slider variables
                o.Metallic = _Metallic* _rainIntensity;
                o.Smoothness = gray*_rainIntensity;

                o.Alpha = c.a;
                

                float3 camDir = normalize(_WorldSpaceCameraPos - IN.worldPos);
                float3 worldNormal = WorldNormalVector(IN, float3(0.0, 0.0, 1.0));
                float edge = pow(clamp(1.0 - dot(worldNormal, camDir), 0.0, 1.0),3.0);
                //float edge = 1 - pow(clamp(dot(IN.viewDir, o.Normal),0.0,1.0),5.0);

                float3 worldReflection = reflect(worldNormal, camDir);
                float4 colorReflect = texCUBE(_Skybox, worldReflection);

                //o.Emission = edge * float4(1.0, 0.2, 0.2, 1.0) * 5.0;
                o.Emission = colorReflect * 3.0 * gray * _rainIntensity  + edge * float4(1.0, 0.2, 0.2, 1.0) * 5.0 * _edgeIntensity;
                o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));
                }
                ENDCG
        }
            FallBack "Diffuse"
}