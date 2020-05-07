// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/EyeBlink"
{
    Properties
    {
        _Color("Color Tint", Color) = (1,1,1,1)
        _MainTex ("Base (RGB), Alpha (A)", 2D) = "white" {}
        _height("Height of elipse", Float) = 1
        _width("Width of elipse", Float) = 1
        _blurSize("Blur of image", Float) = 1
    }
    SubShader
    { 
        Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}

        Pass
        {
            Cull Off
            Lighting Off
            ZWrite Off
            ZTest Always
            ColorMask RGB
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            uniform float _height;
            uniform float _width;
            uniform float _blurSize;
            uniform float _sharpness;
            half4 _Color;

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = _Color;
                return o;
            }

            half4 frag (v2f i) : COLOR
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				float2 c = i.uv; 
                float4 resultCol = float4(0,0,0,0);
                float2 center = float2(0.5, 0.5);

                float p = (pow((c.x - center.x), 2) / pow(_width, 2)) + (pow((c.y - center.y), 2) / pow(_height, 2));

                if (p < 0.8)
                {
                    for (float i = 0; i < 10; i++) {
                        resultCol += tex2D(_MainTex, c + float2((i / 9 - 0.5) * _blurSize, 0));
                    }
                    resultCol = resultCol / 10;
                }
                else if(p > 0.8 && p < 1)
                {
                    half4 blur = 0;
                    for (float z = 0; z < 10; z++) {
                        blur += tex2D(_MainTex, c + float2((z / 9 - 0.5) * _blurSize, 0));
                    }
                    blur = blur / 10;

                    float div = (1 - p)/ 0.2f;
                    p = div * 1 * _sharpness;
                    resultCol.r = (i.color.r * (1 - p)) + blur.r * p;
                    resultCol.g = (i.color.g * (1 - p)) + blur.g * p;
                    resultCol.b = (i.color.b * (1 - p)) + blur.b * p;
                    resultCol.a = i.color.a;
                }
                else 
                {
                    resultCol.r = i.color.r;
                    resultCol.g = i.color.g;
                    resultCol.b = i.color.b;
                    resultCol.a = i.color.a;
                }
				
                return resultCol;
            }
            ENDCG
        }
    }
}
