Shader "TextMeshPro/Bitmap" {
Properties {
_MainTex ("Font Atlas", 2D) = "white" { }
_FaceTex ("Font Texture", 2D) = "white" { }
_FaceColor ("Text Color", Color) = (1,1,1,1)
_VertexOffsetX ("Vertex OffsetX", Float) = 0
_VertexOffsetY ("Vertex OffsetY", Float) = 0
_MaskSoftnessX ("Mask SoftnessX", Float) = 0
_MaskSoftnessY ("Mask SoftnessY", Float) = 0
_ClipRect ("Clip Rect", Vector) = (-32767,-32767,32767,32767)
_StencilComp ("Stencil Comparison", Float) = 8
_Stencil ("Stencil ID", Float) = 0
_StencilOp ("Stencil Operation", Float) = 0
_StencilWriteMask ("Stencil Write Mask", Float) = 255
_StencilReadMask ("Stencil Read Mask", Float) = 255
_ColorMask ("Color Mask", Float) = 15
}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
  ZTest Off
  ZWrite Off
  Cull Off
  GpuProgramID 45610
Program "vp" {
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ScreenParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_projection[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _FaceTex_ST;
uniform 	mediump vec4 _FaceColor;
uniform 	float _VertexOffsetX;
uniform 	float _VertexOffsetY;
uniform 	vec4 _ClipRect;
uniform 	float _MaskSoftnessX;
uniform 	float _MaskSoftnessY;
in highp vec4 in_POSITION0;
in mediump vec4 in_COLOR0;
in highp vec2 in_TEXCOORD0;
in highp vec2 in_TEXCOORD1;
out mediump vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec4 vs_TEXCOORD2;
vec2 u_xlat0;
vec4 u_xlat1;
vec4 u_xlat2;
vec2 u_xlat6;
void main()
{
    u_xlat0.x = in_POSITION0.w * 0.5;
    u_xlat0.xy = u_xlat0.xx / _ScreenParams.xy;
    u_xlat6.xy = in_POSITION0.xy + vec2(_VertexOffsetX, _VertexOffsetY);
    u_xlat0.xy = u_xlat0.xy + u_xlat6.xy;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat1 = u_xlat1 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
    u_xlat6.xy = u_xlat1.xy / u_xlat1.ww;
    u_xlat1.xy = _ScreenParams.xy * vec2(0.5, 0.5);
    u_xlat6.xy = u_xlat6.xy * u_xlat1.xy;
    u_xlat6.xy = roundEven(u_xlat6.xy);
    u_xlat6.xy = u_xlat6.xy / u_xlat1.xy;
    gl_Position.xy = u_xlat1.ww * u_xlat6.xy;
    gl_Position.zw = u_xlat1.zw;
    vs_COLOR0 = in_COLOR0 * _FaceColor;
    u_xlat6.x = in_TEXCOORD1.x * 0.000244140625;
    u_xlat6.x = floor(u_xlat6.x);
    u_xlat6.y = (-u_xlat6.x) * 4096.0 + in_TEXCOORD1.x;
    u_xlat6.xy = u_xlat6.xy * _FaceTex_ST.xy;
    vs_TEXCOORD1.xy = u_xlat6.xy * vec2(0.001953125, 0.001953125) + _FaceTex_ST.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    u_xlat2 = max(_ClipRect, vec4(-2e+10, -2e+10, -2e+10, -2e+10));
    u_xlat2 = min(u_xlat2, vec4(2e+10, 2e+10, 2e+10, 2e+10));
    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + (-u_xlat2.xy);
    vs_TEXCOORD2.xy = vec2((-u_xlat2.z) + u_xlat0.x, (-u_xlat2.w) + u_xlat0.y);
    u_xlat6.x = _ScreenParams.x * hlslcc_mtx4x4glstate_matrix_projection[0].x;
    u_xlat6.y = _ScreenParams.y * hlslcc_mtx4x4glstate_matrix_projection[1].y;
    u_xlat0.xy = u_xlat1.ww / abs(u_xlat6.xy);
    u_xlat0.xy = vec2(_MaskSoftnessX, _MaskSoftnessY) * vec2(0.25, 0.25) + u_xlat0.xy;
    vs_TEXCOORD2.zw = vec2(0.25, 0.25) / u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ClipRect;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _FaceTex;
in mediump vec4 vs_COLOR0;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec4 vs_TEXCOORD2;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec3 u_xlat16_0;
lowp vec3 u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_2;
mediump float u_xlat16_5;
void main()
{
    u_xlat10_0.xyz = texture(_FaceTex, vs_TEXCOORD1.xy).xyz;
    u_xlat16_0.xyz = u_xlat10_0.xyz * vs_COLOR0.xyz;
    u_xlat1.xy = vec2((-_ClipRect.x) + _ClipRect.z, (-_ClipRect.y) + _ClipRect.w);
    u_xlat1.xy = u_xlat1.xy + -abs(vs_TEXCOORD2.xy);
    u_xlat1.xy = vec2(u_xlat1.x * vs_TEXCOORD2.z, u_xlat1.y * vs_TEXCOORD2.w);
#ifdef UNITY_ADRENO_ES3
    u_xlat1.xy = min(max(u_xlat1.xy, 0.0), 1.0);
#else
    u_xlat1.xy = clamp(u_xlat1.xy, 0.0, 1.0);
#endif
    u_xlat16_2 = u_xlat1.y * u_xlat1.x;
    SV_Target0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_2);
    u_xlat10_0.x = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_5 = u_xlat10_0.x * vs_COLOR0.w;
    SV_Target0.w = u_xlat16_2 * u_xlat16_5;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ScreenParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_projection[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _FaceTex_ST;
uniform 	mediump vec4 _FaceColor;
uniform 	float _VertexOffsetX;
uniform 	float _VertexOffsetY;
uniform 	vec4 _ClipRect;
uniform 	float _MaskSoftnessX;
uniform 	float _MaskSoftnessY;
in highp vec4 in_POSITION0;
in mediump vec4 in_COLOR0;
in highp vec2 in_TEXCOORD0;
in highp vec2 in_TEXCOORD1;
out mediump vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec4 vs_TEXCOORD2;
vec2 u_xlat0;
vec4 u_xlat1;
vec4 u_xlat2;
vec2 u_xlat6;
void main()
{
    u_xlat0.x = in_POSITION0.w * 0.5;
    u_xlat0.xy = u_xlat0.xx / _ScreenParams.xy;
    u_xlat6.xy = in_POSITION0.xy + vec2(_VertexOffsetX, _VertexOffsetY);
    u_xlat0.xy = u_xlat0.xy + u_xlat6.xy;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat1 = u_xlat1 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
    u_xlat6.xy = u_xlat1.xy / u_xlat1.ww;
    u_xlat1.xy = _ScreenParams.xy * vec2(0.5, 0.5);
    u_xlat6.xy = u_xlat6.xy * u_xlat1.xy;
    u_xlat6.xy = roundEven(u_xlat6.xy);
    u_xlat6.xy = u_xlat6.xy / u_xlat1.xy;
    gl_Position.xy = u_xlat1.ww * u_xlat6.xy;
    gl_Position.zw = u_xlat1.zw;
    vs_COLOR0 = in_COLOR0 * _FaceColor;
    u_xlat6.x = in_TEXCOORD1.x * 0.000244140625;
    u_xlat6.x = floor(u_xlat6.x);
    u_xlat6.y = (-u_xlat6.x) * 4096.0 + in_TEXCOORD1.x;
    u_xlat6.xy = u_xlat6.xy * _FaceTex_ST.xy;
    vs_TEXCOORD1.xy = u_xlat6.xy * vec2(0.001953125, 0.001953125) + _FaceTex_ST.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    u_xlat2 = max(_ClipRect, vec4(-2e+10, -2e+10, -2e+10, -2e+10));
    u_xlat2 = min(u_xlat2, vec4(2e+10, 2e+10, 2e+10, 2e+10));
    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + (-u_xlat2.xy);
    vs_TEXCOORD2.xy = vec2((-u_xlat2.z) + u_xlat0.x, (-u_xlat2.w) + u_xlat0.y);
    u_xlat6.x = _ScreenParams.x * hlslcc_mtx4x4glstate_matrix_projection[0].x;
    u_xlat6.y = _ScreenParams.y * hlslcc_mtx4x4glstate_matrix_projection[1].y;
    u_xlat0.xy = u_xlat1.ww / abs(u_xlat6.xy);
    u_xlat0.xy = vec2(_MaskSoftnessX, _MaskSoftnessY) * vec2(0.25, 0.25) + u_xlat0.xy;
    vs_TEXCOORD2.zw = vec2(0.25, 0.25) / u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ClipRect;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _FaceTex;
in mediump vec4 vs_COLOR0;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec4 vs_TEXCOORD2;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec3 u_xlat16_0;
lowp vec3 u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_2;
mediump float u_xlat16_5;
void main()
{
    u_xlat10_0.xyz = texture(_FaceTex, vs_TEXCOORD1.xy).xyz;
    u_xlat16_0.xyz = u_xlat10_0.xyz * vs_COLOR0.xyz;
    u_xlat1.xy = vec2((-_ClipRect.x) + _ClipRect.z, (-_ClipRect.y) + _ClipRect.w);
    u_xlat1.xy = u_xlat1.xy + -abs(vs_TEXCOORD2.xy);
    u_xlat1.xy = vec2(u_xlat1.x * vs_TEXCOORD2.z, u_xlat1.y * vs_TEXCOORD2.w);
#ifdef UNITY_ADRENO_ES3
    u_xlat1.xy = min(max(u_xlat1.xy, 0.0), 1.0);
#else
    u_xlat1.xy = clamp(u_xlat1.xy, 0.0, 1.0);
#endif
    u_xlat16_2 = u_xlat1.y * u_xlat1.x;
    SV_Target0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_2);
    u_xlat10_0.x = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_5 = u_xlat10_0.x * vs_COLOR0.w;
    SV_Target0.w = u_xlat16_2 * u_xlat16_5;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ScreenParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_projection[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _FaceTex_ST;
uniform 	mediump vec4 _FaceColor;
uniform 	float _VertexOffsetX;
uniform 	float _VertexOffsetY;
uniform 	vec4 _ClipRect;
uniform 	float _MaskSoftnessX;
uniform 	float _MaskSoftnessY;
in highp vec4 in_POSITION0;
in mediump vec4 in_COLOR0;
in highp vec2 in_TEXCOORD0;
in highp vec2 in_TEXCOORD1;
out mediump vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec4 vs_TEXCOORD2;
vec2 u_xlat0;
vec4 u_xlat1;
vec4 u_xlat2;
vec2 u_xlat6;
void main()
{
    u_xlat0.x = in_POSITION0.w * 0.5;
    u_xlat0.xy = u_xlat0.xx / _ScreenParams.xy;
    u_xlat6.xy = in_POSITION0.xy + vec2(_VertexOffsetX, _VertexOffsetY);
    u_xlat0.xy = u_xlat0.xy + u_xlat6.xy;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat1 = u_xlat1 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
    u_xlat6.xy = u_xlat1.xy / u_xlat1.ww;
    u_xlat1.xy = _ScreenParams.xy * vec2(0.5, 0.5);
    u_xlat6.xy = u_xlat6.xy * u_xlat1.xy;
    u_xlat6.xy = roundEven(u_xlat6.xy);
    u_xlat6.xy = u_xlat6.xy / u_xlat1.xy;
    gl_Position.xy = u_xlat1.ww * u_xlat6.xy;
    gl_Position.zw = u_xlat1.zw;
    vs_COLOR0 = in_COLOR0 * _FaceColor;
    u_xlat6.x = in_TEXCOORD1.x * 0.000244140625;
    u_xlat6.x = floor(u_xlat6.x);
    u_xlat6.y = (-u_xlat6.x) * 4096.0 + in_TEXCOORD1.x;
    u_xlat6.xy = u_xlat6.xy * _FaceTex_ST.xy;
    vs_TEXCOORD1.xy = u_xlat6.xy * vec2(0.001953125, 0.001953125) + _FaceTex_ST.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    u_xlat2 = max(_ClipRect, vec4(-2e+10, -2e+10, -2e+10, -2e+10));
    u_xlat2 = min(u_xlat2, vec4(2e+10, 2e+10, 2e+10, 2e+10));
    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + (-u_xlat2.xy);
    vs_TEXCOORD2.xy = vec2((-u_xlat2.z) + u_xlat0.x, (-u_xlat2.w) + u_xlat0.y);
    u_xlat6.x = _ScreenParams.x * hlslcc_mtx4x4glstate_matrix_projection[0].x;
    u_xlat6.y = _ScreenParams.y * hlslcc_mtx4x4glstate_matrix_projection[1].y;
    u_xlat0.xy = u_xlat1.ww / abs(u_xlat6.xy);
    u_xlat0.xy = vec2(_MaskSoftnessX, _MaskSoftnessY) * vec2(0.25, 0.25) + u_xlat0.xy;
    vs_TEXCOORD2.zw = vec2(0.25, 0.25) / u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ClipRect;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _FaceTex;
in mediump vec4 vs_COLOR0;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec4 vs_TEXCOORD2;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec3 u_xlat16_0;
lowp vec3 u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_2;
mediump float u_xlat16_5;
void main()
{
    u_xlat10_0.xyz = texture(_FaceTex, vs_TEXCOORD1.xy).xyz;
    u_xlat16_0.xyz = u_xlat10_0.xyz * vs_COLOR0.xyz;
    u_xlat1.xy = vec2((-_ClipRect.x) + _ClipRect.z, (-_ClipRect.y) + _ClipRect.w);
    u_xlat1.xy = u_xlat1.xy + -abs(vs_TEXCOORD2.xy);
    u_xlat1.xy = vec2(u_xlat1.x * vs_TEXCOORD2.z, u_xlat1.y * vs_TEXCOORD2.w);
#ifdef UNITY_ADRENO_ES3
    u_xlat1.xy = min(max(u_xlat1.xy, 0.0), 1.0);
#else
    u_xlat1.xy = clamp(u_xlat1.xy, 0.0, 1.0);
#endif
    u_xlat16_2 = u_xlat1.y * u_xlat1.x;
    SV_Target0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_2);
    u_xlat10_0.x = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_5 = u_xlat10_0.x * vs_COLOR0.w;
    SV_Target0.w = u_xlat16_2 * u_xlat16_5;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles3 hw_tier00 " {
""
}
SubProgram "gles3 hw_tier01 " {
""
}
SubProgram "gles3 hw_tier02 " {
""
}
}
}
}
CustomEditor "TMPro.EditorUtilities.TMP_BitmapShaderGUI"
}