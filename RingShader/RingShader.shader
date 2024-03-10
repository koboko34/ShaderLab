Shader"Unlit/RingShader"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,0,0,1)
        _ColorB ("Color B", Color) = (0,0,1,1)
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent"
               "Queue" = "Transparent"}

        Pass
        {
            ZWrite Off // don't write to zBuffer
            Cull Off // don't cull any faces
            Blend One One // additive blending


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.2831855

            struct MeshData // per-vertex
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f // fragment info
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            float4 _ColorA;
            float4 _ColorB;

            v2f vert (MeshData v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); // local to clip space
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {                                
                float offset = cos(i.uv.x * TAU * 8) * 0.01;
                float t = cos((i.uv.y + offset - _Time.y * 0.2) * TAU * 6) * 0.5 + 0.5;
                t *= (1 - i.uv.y);
    
                float topBottomRemover = (abs(i.normal.y) < 0.99);
                float waves = t * topBottomRemover;
                
                float4 outColor = lerp(_ColorA, _ColorB, i.uv.y);
    
                return waves * outColor;
            }
            ENDCG
        }
    }
}
