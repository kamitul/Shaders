Shader "Custom/HeatHaze"
{
    Properties
    {
        _MainTex("Base (RGB), Alpha (A)", 2D) = "white" {}
        _NoiseMap("Noise (RG)", 2D) = "black" {}
        _Strength("Strength of distortion", Float) = 1
        _Noise("Noise of distortion", Float) = 1
        _Speed("Speed of haze", Float) = 1
    }
    SubShader
    {
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
                half4 color : COLOR;
            };

            sampler2D _MainTex, _NoiseMap;
            uniform float _Strength;
            uniform float _Noise;
            uniform float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 fVector = tex2D(_NoiseMap, i.uv).rg * 2 - 1;
                i.uv -= fVector * sin(_Time.x * _Noise * _Speed) * _Strength;
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
