Shader "Custom/NewTypeShader"
{
    Properties
    {
        _edgeIntesity("Intesity", Range(0,1)) = 0.0
        _Color ("Color", Color) = (1,1,1,1)
        _EmissionColor("EmissionColor", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SkyBox("CubeMap",CUBE) = ""{}
        _EmissionTex("EmissionTex", 2D) = "white" {}
        _NormalTex("Normal", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        //sampler2D _EmissionTex;
        sampler2D _NormalTex;
        samplerCUBE _SkyBox;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMapTex;
            float3 worldPos;
            float3 worldNormal; INTERNAL_DATA
            float3 viewDir;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        half _edgeIntesity = 1.0;
        fixed4 _EmissionColor;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            //fixed4 e = tex2D (_EmissionTex, IN.uv_MainTex) * _EmissionColor;

            o.Albedo = c.rgb;
            float gray = (c.r +c.g +c.b)/3.0;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = gray;
            o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));
            o.Alpha = c.a;

            float3 camDir = normalize(_WorldSpaceCameraPos - IN.worldPos);
            float3 worldNormal = WorldNormalVector(IN, float3(0.0, 0.0, 1.0));


            float3 worldReflection = reflect(worldNormal, camDir);
            float4 colorReflect = texCUBE(_SkyBox, worldReflection);

            
            float edge = pow(clamp(1.0 - dot(worldNormal, camDir), 0.0, 1.0), 3.0);

           
            o.Emission = colorReflect * 2.0 * gray + edge * float4(1.0, 0.2, 0.2, 1.0) * 10.0 * _edgeIntesity;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
