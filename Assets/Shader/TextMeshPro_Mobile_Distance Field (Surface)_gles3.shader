Shader "TextMeshPro/Mobile/Distance Field (Surface)" {
Properties {
_FaceTex ("Fill Texture", 2D) = "white" { }
_FaceColor ("Fill Color", Color) = (1,1,1,1)
_FaceDilate ("Face Dilate", Range(-1, 1)) = 0
_OutlineColor ("Outline Color", Color) = (0,0,0,1)
_OutlineTex ("Outline Texture", 2D) = "white" { }
_OutlineWidth ("Outline Thickness", Range(0, 1)) = 0
_OutlineSoftness ("Outline Softness", Range(0, 1)) = 0
_GlowColor ("Color", Color) = (0,1,0,0.5)
_GlowOffset ("Offset", Range(-1, 1)) = 0
_GlowInner ("Inner", Range(0, 1)) = 0.05
_GlowOuter ("Outer", Range(0, 1)) = 0.05
_GlowPower ("Falloff", Range(1, 0)) = 0.75
_WeightNormal ("Weight Normal", Float) = 0
_WeightBold ("Weight Bold", Float) = 0.5
_ShaderFlags ("Flags", Float) = 0
_ScaleRatioA ("Scale RatioA", Float) = 1
_ScaleRatioB ("Scale RatioB", Float) = 1
_ScaleRatioC ("Scale RatioC", Float) = 1
_MainTex ("Font Atlas", 2D) = "white" { }
_TextureWidth ("Texture Width", Float) = 512
_TextureHeight ("Texture Height", Float) = 512
_GradientScale ("Gradient Scale", Float) = 5
_ScaleX ("Scale X", Float) = 1
_ScaleY ("Scale Y", Float) = 1
_PerspectiveFilter ("Perspective Correction", Range(0, 1)) = 0.875
_VertexOffsetX ("Vertex OffsetX", Float) = 0
_VertexOffsetY ("Vertex OffsetY", Float) = 0
}
SubShader {
 LOD 300
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Name "FORWARD"
  LOD 300
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
  ZWrite Off
  Cull Off
  GpuProgramID 42983
Program "vp" {
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" }
"#ifdef VERTEX
#version 300 es

uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ScreenParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
uniform 	vec4 unity_WorldTransformParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_projection[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	float _FaceDilate;
uniform 	vec4 hlslcc_mtx4x4_EnvMatrix[4];
uniform 	float _WeightNormal;
uniform 	float _WeightBold;
uniform 	float _ScaleRatioA;
uniform 	float _VertexOffsetX;
uniform 	float _VertexOffsetY;
uniform 	float _GradientScale;
uniform 	float _ScaleX;
uniform 	float _ScaleY;
uniform 	float _PerspectiveFilter;
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _FaceTex_ST;
uniform 	vec4 _OutlineTex_ST;
in highp vec4 in_POSITION0;
in highp vec4 in_TANGENT0;
in highp vec3 in_NORMAL0;
in highp vec4 in_TEXCOORD0;
in highp vec4 in_TEXCOORD1;
in mediump vec4 in_COLOR0;
out highp vec4 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD5;
out highp vec4 vs_TEXCOORD2;
out highp vec4 vs_TEXCOORD3;
out highp vec4 vs_TEXCOORD4;
out mediump vec4 vs_COLOR0;
out highp vec3 vs_TEXCOORD6;
vec3 u_xlat0;
int u_xlati0;
vec4 u_xlat1;
vec4 u_xlat2;
vec4 u_xlat3;
vec3 u_xlat4;
float u_xlat5;
int u_xlati5;
float u_xlat15;
bool u_xlatb15;
float u_xlat16;
float u_xlat17;
void main()
{
    u_xlat0.xy = vec2(in_POSITION0.x + float(_VertexOffsetX), in_POSITION0.y + float(_VertexOffsetY));
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat2 = u_xlat1 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat1.xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat2.zzzz + u_xlat3;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat2.wwww + u_xlat3;
    u_xlat15 = in_TEXCOORD1.x * 0.000244140625;
    u_xlat3.x = floor(u_xlat15);
    u_xlat3.y = (-u_xlat3.x) * 4096.0 + in_TEXCOORD1.x;
    u_xlat3.xy = u_xlat3.xy * vec2(0.001953125, 0.001953125);
    vs_TEXCOORD0.zw = u_xlat3.xy * _FaceTex_ST.xy + _FaceTex_ST.zw;
    vs_TEXCOORD1.xy = u_xlat3.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(0.0>=in_TEXCOORD1.y);
#else
    u_xlatb15 = 0.0>=in_TEXCOORD1.y;
#endif
    u_xlat15 = u_xlatb15 ? 1.0 : float(0.0);
    u_xlat16 = (-_WeightNormal) + _WeightBold;
    u_xlat15 = u_xlat15 * u_xlat16 + _WeightNormal;
    u_xlat15 = u_xlat15 * 0.25 + _FaceDilate;
    u_xlat15 = u_xlat15 * _ScaleRatioA;
    vs_TEXCOORD5.x = u_xlat15 * 0.5;
    u_xlat15 = u_xlat2.y * hlslcc_mtx4x4unity_MatrixVP[1].w;
    u_xlat15 = hlslcc_mtx4x4unity_MatrixVP[0].w * u_xlat2.x + u_xlat15;
    u_xlat15 = hlslcc_mtx4x4unity_MatrixVP[2].w * u_xlat2.z + u_xlat15;
    u_xlat15 = hlslcc_mtx4x4unity_MatrixVP[3].w * u_xlat2.w + u_xlat15;
    u_xlat2.xy = _ScreenParams.yy * hlslcc_mtx4x4glstate_matrix_projection[1].xy;
    u_xlat2.xy = hlslcc_mtx4x4glstate_matrix_projection[0].xy * _ScreenParams.xx + u_xlat2.xy;
    u_xlat2.xy = vec2(u_xlat2.x * float(_ScaleX), u_xlat2.y * float(_ScaleY));
    u_xlat2.xy = vec2(u_xlat15) / u_xlat2.xy;
    u_xlat15 = dot(u_xlat2.xy, u_xlat2.xy);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16 = abs(in_TEXCOORD1.y) * _GradientScale;
    u_xlat15 = u_xlat15 * u_xlat16;
    u_xlat16 = u_xlat15 * 1.5;
    u_xlat2.x = (-_PerspectiveFilter) + 1.0;
    u_xlat16 = u_xlat16 * u_xlat2.x;
    u_xlat15 = u_xlat15 * 1.5 + (-u_xlat16);
    u_xlat2.xyz = _WorldSpaceCameraPos.yyy * hlslcc_mtx4x4unity_WorldToObject[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat2.xyz + hlslcc_mtx4x4unity_WorldToObject[3].xyz;
    u_xlat0.z = in_POSITION0.z;
    u_xlat0.xyz = (-u_xlat0.xyz) + u_xlat2.xyz;
    u_xlat0.x = dot(in_NORMAL0.xyz, u_xlat0.xyz);
#ifdef UNITY_ADRENO_ES3
    { bool cond = 0.0<u_xlat0.x; u_xlati5 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati5 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0u));
#endif
#ifdef UNITY_ADRENO_ES3
    { bool cond = u_xlat0.x<0.0; u_xlati0 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0u));
#endif
    u_xlati0 = (-u_xlati5) + u_xlati0;
    u_xlat0.x = float(u_xlati0);
    u_xlat0.xyz = u_xlat0.xxx * in_NORMAL0.xyz;
    u_xlat2.y = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
    u_xlat2.z = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
    u_xlat2.x = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat2.xyz = (-u_xlat1.xyz) + _WorldSpaceCameraPos.xyz;
    u_xlat17 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat3.xyz = vec3(u_xlat17) * u_xlat2.xyz;
    u_xlat17 = dot(u_xlat0.yzx, u_xlat3.xyz);
    vs_TEXCOORD5.y = abs(u_xlat17) * u_xlat15 + u_xlat16;
    vs_TEXCOORD2.z = u_xlat0.y;
    u_xlat3.xyz = in_TANGENT0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].yzx;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * in_TANGENT0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * in_TANGENT0.zzz + u_xlat3.xyz;
    u_xlat15 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat3.xyz = vec3(u_xlat15) * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat0.xyz * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat0.zxy * u_xlat3.yzx + (-u_xlat4.xyz);
    u_xlat5 = in_TANGENT0.w * unity_WorldTransformParams.w;
    u_xlat4.xyz = vec3(u_xlat5) * u_xlat4.xyz;
    vs_TEXCOORD2.y = u_xlat4.x;
    vs_TEXCOORD2.w = u_xlat1.x;
    vs_TEXCOORD2.x = u_xlat3.z;
    vs_TEXCOORD3.z = u_xlat0.z;
    vs_TEXCOORD4.z = u_xlat0.x;
    vs_TEXCOORD3.x = u_xlat3.x;
    vs_TEXCOORD4.x = u_xlat3.y;
    vs_TEXCOORD3.w = u_xlat1.y;
    vs_TEXCOORD4.w = u_xlat1.z;
    vs_TEXCOORD3.y = u_xlat4.y;
    vs_TEXCOORD4.y = u_xlat4.z;
    vs_COLOR0 = in_COLOR0;
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4_EnvMatrix[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_EnvMatrix[0].xyz * u_xlat2.xxx + u_xlat0.xyz;
    vs_TEXCOORD6.xyz = hlslcc_mtx4x4_EnvMatrix[2].xyz * u_xlat2.zzz + u_xlat0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _Time;
uniform 	mediump vec4 _WorldSpaceLightPos0;
uniform 	mediump vec4 _LightColor0;
uniform 	float _FaceUVSpeedX;
uniform 	float _FaceUVSpeedY;
uniform 	mediump vec4 _FaceColor;
uniform 	float _OutlineSoftness;
uniform 	float _OutlineUVSpeedX;
uniform 	float _OutlineUVSpeedY;
uniform 	mediump vec4 _OutlineColor;
uniform 	float _OutlineWidth;
uniform 	float _ScaleRatioA;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _FaceTex;
uniform lowp sampler2D _OutlineTex;
in highp vec4 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec2 vs_TEXCOORD5;
in highp vec4 vs_TEXCOORD2;
in highp vec4 vs_TEXCOORD3;
in highp vec4 vs_TEXCOORD4;
in mediump vec4 vs_COLOR0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec3 u_xlat16_1;
mediump vec4 u_xlat16_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_3;
lowp vec4 u_xlat10_3;
mediump vec4 u_xlat16_4;
mediump vec4 u_xlat16_5;
mediump vec4 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_8;
mediump float u_xlat16_9;
float u_xlat10;
mediump float u_xlat16_15;
vec2 u_xlat16;
mediump float u_xlat16_22;
float u_xlat24;
void main()
{
    u_xlat10_0.x = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0.x = (-u_xlat10_0.x) + 0.5;
    u_xlat0.x = u_xlat16_0.x + (-vs_TEXCOORD5.x);
    u_xlat0.x = u_xlat0.x * vs_TEXCOORD5.y + 0.5;
    u_xlat7 = _OutlineWidth * _ScaleRatioA;
    u_xlat7 = u_xlat7 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat7 * 0.5 + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_8 = (-u_xlat7) * 0.5 + u_xlat0.x;
    u_xlat16_15 = min(u_xlat7, 1.0);
    u_xlat16_15 = sqrt(u_xlat16_15);
    u_xlat16_1.x = u_xlat16_15 * u_xlat16_1.x;
    u_xlat0.xy = vec2(_OutlineUVSpeedX, _OutlineUVSpeedY) * _Time.yy + vs_TEXCOORD1.xy;
    u_xlat10_0 = texture(_OutlineTex, u_xlat0.xy);
    u_xlat16_0.xyz = u_xlat10_0.xyz * _OutlineColor.xyz;
    u_xlat16_2.x = vs_COLOR0.w * _OutlineColor.w;
    u_xlat16_9 = u_xlat10_0.w * u_xlat16_2.x;
    u_xlat16.xy = vec2(_FaceUVSpeedX, _FaceUVSpeedY) * _Time.yy + vs_TEXCOORD0.zw;
    u_xlat10_3 = texture(_FaceTex, u_xlat16.xy);
    u_xlat16_4 = vs_COLOR0 * _FaceColor;
    u_xlat16_5 = u_xlat10_3 * u_xlat16_4;
    u_xlat16_6.xyz = u_xlat16_5.www * u_xlat16_5.xyz;
    u_xlat16_6.xyz = u_xlat16_0.xyz * vec3(u_xlat16_9) + (-u_xlat16_6.xyz);
    u_xlat16_6.w = u_xlat16_2.x * u_xlat10_0.w + (-u_xlat16_5.w);
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_6;
    u_xlat16_2.w = u_xlat16_4.w * u_xlat10_3.w + u_xlat16_0.w;
    u_xlat16_2.xyz = u_xlat16_5.xyz * u_xlat16_5.www + u_xlat16_0.xyz;
    u_xlat3.x = _OutlineSoftness * _ScaleRatioA;
    u_xlat10 = u_xlat3.x * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat3.x * vs_TEXCOORD5.y + 1.0;
    u_xlat16_8 = u_xlat10 * 0.5 + u_xlat16_8;
    u_xlat16_1.x = u_xlat16_8 / u_xlat16_1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_1.x = (-u_xlat16_1.x) + 1.0;
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_2;
    u_xlat16_3.x = max(u_xlat16_0.w, 9.99999975e-05);
    u_xlat16_3.xyz = u_xlat16_0.xyz / u_xlat16_3.xxx;
    SV_Target0.w = u_xlat16_0.w;
    u_xlat16_1.xyz = u_xlat16_3.xyz * _LightColor0.xyz;
    u_xlat3.x = vs_TEXCOORD2.z;
    u_xlat3.y = vs_TEXCOORD3.z;
    u_xlat3.z = vs_TEXCOORD4.z;
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = vec3(u_xlat24) * u_xlat3.xyz;
    u_xlat16_22 = dot(u_xlat3.xyz, _WorldSpaceLightPos0.xyz);
    u_xlat16_22 = max(u_xlat16_22, 0.0);
    SV_Target0.xyz = vec3(u_xlat16_22) * u_xlat16_1.xyz;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" }
"#ifdef VERTEX
#version 300 es

uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ScreenParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
uniform 	vec4 unity_WorldTransformParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_projection[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	float _FaceDilate;
uniform 	vec4 hlslcc_mtx4x4_EnvMatrix[4];
uniform 	float _WeightNormal;
uniform 	float _WeightBold;
uniform 	float _ScaleRatioA;
uniform 	float _VertexOffsetX;
uniform 	float _VertexOffsetY;
uniform 	float _GradientScale;
uniform 	float _ScaleX;
uniform 	float _ScaleY;
uniform 	float _PerspectiveFilter;
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _FaceTex_ST;
uniform 	vec4 _OutlineTex_ST;
in highp vec4 in_POSITION0;
in highp vec4 in_TANGENT0;
in highp vec3 in_NORMAL0;
in highp vec4 in_TEXCOORD0;
in highp vec4 in_TEXCOORD1;
in mediump vec4 in_COLOR0;
out highp vec4 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD5;
out highp vec4 vs_TEXCOORD2;
out highp vec4 vs_TEXCOORD3;
out highp vec4 vs_TEXCOORD4;
out mediump vec4 vs_COLOR0;
out highp vec3 vs_TEXCOORD6;
vec3 u_xlat0;
int u_xlati0;
vec4 u_xlat1;
vec4 u_xlat2;
vec4 u_xlat3;
vec3 u_xlat4;
float u_xlat5;
int u_xlati5;
float u_xlat15;
bool u_xlatb15;
float u_xlat16;
float u_xlat17;
void main()
{
    u_xlat0.xy = vec2(in_POSITION0.x + float(_VertexOffsetX), in_POSITION0.y + float(_VertexOffsetY));
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat2 = u_xlat1 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat1.xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat2.zzzz + u_xlat3;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat2.wwww + u_xlat3;
    u_xlat15 = in_TEXCOORD1.x * 0.000244140625;
    u_xlat3.x = floor(u_xlat15);
    u_xlat3.y = (-u_xlat3.x) * 4096.0 + in_TEXCOORD1.x;
    u_xlat3.xy = u_xlat3.xy * vec2(0.001953125, 0.001953125);
    vs_TEXCOORD0.zw = u_xlat3.xy * _FaceTex_ST.xy + _FaceTex_ST.zw;
    vs_TEXCOORD1.xy = u_xlat3.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(0.0>=in_TEXCOORD1.y);
#else
    u_xlatb15 = 0.0>=in_TEXCOORD1.y;
#endif
    u_xlat15 = u_xlatb15 ? 1.0 : float(0.0);
    u_xlat16 = (-_WeightNormal) + _WeightBold;
    u_xlat15 = u_xlat15 * u_xlat16 + _WeightNormal;
    u_xlat15 = u_xlat15 * 0.25 + _FaceDilate;
    u_xlat15 = u_xlat15 * _ScaleRatioA;
    vs_TEXCOORD5.x = u_xlat15 * 0.5;
    u_xlat15 = u_xlat2.y * hlslcc_mtx4x4unity_MatrixVP[1].w;
    u_xlat15 = hlslcc_mtx4x4unity_MatrixVP[0].w * u_xlat2.x + u_xlat15;
    u_xlat15 = hlslcc_mtx4x4unity_MatrixVP[2].w * u_xlat2.z + u_xlat15;
    u_xlat15 = hlslcc_mtx4x4unity_MatrixVP[3].w * u_xlat2.w + u_xlat15;
    u_xlat2.xy = _ScreenParams.yy * hlslcc_mtx4x4glstate_matrix_projection[1].xy;
    u_xlat2.xy = hlslcc_mtx4x4glstate_matrix_projection[0].xy * _ScreenParams.xx + u_xlat2.xy;
    u_xlat2.xy = vec2(u_xlat2.x * float(_ScaleX), u_xlat2.y * float(_ScaleY));
    u_xlat2.xy = vec2(u_xlat15) / u_xlat2.xy;
    u_xlat15 = dot(u_xlat2.xy, u_xlat2.xy);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16 = abs(in_TEXCOORD1.y) * _GradientScale;
    u_xlat15 = u_xlat15 * u_xlat16;
    u_xlat16 = u_xlat15 * 1.5;
    u_xlat2.x = (-_PerspectiveFilter) + 1.0;
    u_xlat16 = u_xlat16 * u_xlat2.x;
    u_xlat15 = u_xlat15 * 1.5 + (-u_xlat16);
    u_xlat2.xyz = _WorldSpaceCameraPos.yyy * hlslcc_mtx4x4unity_WorldToObject[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat2.xyz + hlslcc_mtx4x4unity_WorldToObject[3].xyz;
    u_xlat0.z = in_POSITION0.z;
    u_xlat0.xyz = (-u_xlat0.xyz) + u_xlat2.xyz;
    u_xlat0.x = dot(in_NORMAL0.xyz, u_xlat0.xyz);
#ifdef UNITY_ADRENO_ES3
    { bool cond = 0.0<u_xlat0.x; u_xlati5 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati5 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0u));
#endif
#ifdef UNITY_ADRENO_ES3
    { bool cond = u_xlat0.x<0.0; u_xlati0 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0u));
#endif
    u_xlati0 = (-u_xlati5) + u_xlati0;
    u_xlat0.x = float(u_xlati0);
    u_xlat0.xyz = u_xlat0.xxx * in_NORMAL0.xyz;
    u_xlat2.y = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
    u_xlat2.z = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
    u_xlat2.x = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat2.xyz = (-u_xlat1.xyz) + _WorldSpaceCameraPos.xyz;
    u_xlat17 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat3.xyz = vec3(u_xlat17) * u_xlat2.xyz;
    u_xlat17 = dot(u_xlat0.yzx, u_xlat3.xyz);
    vs_TEXCOORD5.y = abs(u_xlat17) * u_xlat15 + u_xlat16;
    vs_TEXCOORD2.z = u_xlat0.y;
    u_xlat3.xyz = in_TANGENT0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].yzx;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * in_TANGENT0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * in_TANGENT0.zzz + u_xlat3.xyz;
    u_xlat15 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat3.xyz = vec3(u_xlat15) * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat0.xyz * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat0.zxy * u_xlat3.yzx + (-u_xlat4.xyz);
    u_xlat5 = in_TANGENT0.w * unity_WorldTransformParams.w;
    u_xlat4.xyz = vec3(u_xlat5) * u_xlat4.xyz;
    vs_TEXCOORD2.y = u_xlat4.x;
    vs_TEXCOORD2.w = u_xlat1.x;
    vs_TEXCOORD2.x = u_xlat3.z;
    vs_TEXCOORD3.z = u_xlat0.z;
    vs_TEXCOORD4.z = u_xlat0.x;
    vs_TEXCOORD3.x = u_xlat3.x;
    vs_TEXCOORD4.x = u_xlat3.y;
    vs_TEXCOORD3.w = u_xlat1.y;
    vs_TEXCOORD4.w = u_xlat1.z;
    vs_TEXCOORD3.y = u_xlat4.y;
    vs_TEXCOORD4.y = u_xlat4.z;
    vs_COLOR0 = in_COLOR0;
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4_EnvMatrix[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_EnvMatrix[0].xyz * u_xlat2.xxx + u_xlat0.xyz;
    vs_TEXCOORD6.xyz = hlslcc_mtx4x4_EnvMatrix[2].xyz * u_xlat2.zzz + u_xlat0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _Time;
uniform 	mediump vec4 _WorldSpaceLightPos0;
uniform 	mediump vec4 _LightColor0;
uniform 	float _FaceUVSpeedX;
uniform 	float _FaceUVSpeedY;
uniform 	mediump vec4 _FaceColor;
uniform 	float _OutlineSoftness;
uniform 	float _OutlineUVSpeedX;
uniform 	float _OutlineUVSpeedY;
uniform 	mediump vec4 _OutlineColor;
uniform 	float _OutlineWidth;
uniform 	float _ScaleRatioA;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _FaceTex;
uniform lowp sampler2D _OutlineTex;
in highp vec4 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec2 vs_TEXCOORD5;
in highp vec4 vs_TEXCOORD2;
in highp vec4 vs_TEXCOORD3;
in highp vec4 vs_TEXCOORD4;
in mediump vec4 vs_COLOR0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec3 u_xlat16_1;
mediump vec4 u_xlat16_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_3;
lowp vec4 u_xlat10_3;
mediump vec4 u_xlat16_4;
mediump vec4 u_xlat16_5;
mediump vec4 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_8;
mediump float u_xlat16_9;
float u_xlat10;
mediump float u_xlat16_15;
vec2 u_xlat16;
mediump float u_xlat16_22;
float u_xlat24;
void main()
{
    u_xlat10_0.x = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0.x = (-u_xlat10_0.x) + 0.5;
    u_xlat0.x = u_xlat16_0.x + (-vs_TEXCOORD5.x);
    u_xlat0.x = u_xlat0.x * vs_TEXCOORD5.y + 0.5;
    u_xlat7 = _OutlineWidth * _ScaleRatioA;
    u_xlat7 = u_xlat7 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat7 * 0.5 + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_8 = (-u_xlat7) * 0.5 + u_xlat0.x;
    u_xlat16_15 = min(u_xlat7, 1.0);
    u_xlat16_15 = sqrt(u_xlat16_15);
    u_xlat16_1.x = u_xlat16_15 * u_xlat16_1.x;
    u_xlat0.xy = vec2(_OutlineUVSpeedX, _OutlineUVSpeedY) * _Time.yy + vs_TEXCOORD1.xy;
    u_xlat10_0 = texture(_OutlineTex, u_xlat0.xy);
    u_xlat16_0.xyz = u_xlat10_0.xyz * _OutlineColor.xyz;
    u_xlat16_2.x = vs_COLOR0.w * _OutlineColor.w;
    u_xlat16_9 = u_xlat10_0.w * u_xlat16_2.x;
    u_xlat16.xy = vec2(_FaceUVSpeedX, _FaceUVSpeedY) * _Time.yy + vs_TEXCOORD0.zw;
    u_xlat10_3 = texture(_FaceTex, u_xlat16.xy);
    u_xlat16_4 = vs_COLOR0 * _FaceColor;
    u_xlat16_5 = u_xlat10_3 * u_xlat16_4;
    u_xlat16_6.xyz = u_xlat16_5.www * u_xlat16_5.xyz;
    u_xlat16_6.xyz = u_xlat16_0.xyz * vec3(u_xlat16_9) + (-u_xlat16_6.xyz);
    u_xlat16_6.w = u_xlat16_2.x * u_xlat10_0.w + (-u_xlat16_5.w);
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_6;
    u_xlat16_2.w = u_xlat16_4.w * u_xlat10_3.w + u_xlat16_0.w;
    u_xlat16_2.xyz = u_xlat16_5.xyz * u_xlat16_5.www + u_xlat16_0.xyz;
    u_xlat3.x = _OutlineSoftness * _ScaleRatioA;
    u_xlat10 = u_xlat3.x * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat3.x * vs_TEXCOORD5.y + 1.0;
    u_xlat16_8 = u_xlat10 * 0.5 + u_xlat16_8;
    u_xlat16_1.x = u_xlat16_8 / u_xlat16_1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_1.x = (-u_xlat16_1.x) + 1.0;
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_2;
    u_xlat16_3.x = max(u_xlat16_0.w, 9.99999975e-05);
    u_xlat16_3.xyz = u_xlat16_0.xyz / u_xlat16_3.xxx;
    SV_Target0.w = u_xlat16_0.w;
    u_xlat16_1.xyz = u_xlat16_3.xyz * _LightColor0.xyz;
    u_xlat3.x = vs_TEXCOORD2.z;
    u_xlat3.y = vs_TEXCOORD3.z;
    u_xlat3.z = vs_TEXCOORD4.z;
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = vec3(u_xlat24) * u_xlat3.xyz;
    u_xlat16_22 = dot(u_xlat3.xyz, _WorldSpaceLightPos0.xyz);
    u_xlat16_22 = max(u_xlat16_22, 0.0);
    SV_Target0.xyz = vec3(u_xlat16_22) * u_xlat16_1.xyz;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" }
"#ifdef VERTEX
#version 300 es

uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ScreenParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
uniform 	vec4 unity_WorldTransformParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_projection[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	float _FaceDilate;
uniform 	vec4 hlslcc_mtx4x4_EnvMatrix[4];
uniform 	float _WeightNormal;
uniform 	float _WeightBold;
uniform 	float _ScaleRatioA;
uniform 	float _VertexOffsetX;
uniform 	float _VertexOffsetY;
uniform 	float _GradientScale;
uniform 	float _ScaleX;
uniform 	float _ScaleY;
uniform 	float _PerspectiveFilter;
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _FaceTex_ST;
uniform 	vec4 _OutlineTex_ST;
in highp vec4 in_POSITION0;
in highp vec4 in_TANGENT0;
in highp vec3 in_NORMAL0;
in highp vec4 in_TEXCOORD0;
in highp vec4 in_TEXCOORD1;
in mediump vec4 in_COLOR0;
out highp vec4 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD5;
out highp vec4 vs_TEXCOORD2;
out highp vec4 vs_TEXCOORD3;
out highp vec4 vs_TEXCOORD4;
out mediump vec4 vs_COLOR0;
out highp vec3 vs_TEXCOORD6;
vec3 u_xlat0;
int u_xlati0;
vec4 u_xlat1;
vec4 u_xlat2;
vec4 u_xlat3;
vec3 u_xlat4;
float u_xlat5;
int u_xlati5;
float u_xlat15;
bool u_xlatb15;
float u_xlat16;
float u_xlat17;
void main()
{
    u_xlat0.xy = vec2(in_POSITION0.x + float(_VertexOffsetX), in_POSITION0.y + float(_VertexOffsetY));
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat2 = u_xlat1 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat1.xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat2.zzzz + u_xlat3;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat2.wwww + u_xlat3;
    u_xlat15 = in_TEXCOORD1.x * 0.000244140625;
    u_xlat3.x = floor(u_xlat15);
    u_xlat3.y = (-u_xlat3.x) * 4096.0 + in_TEXCOORD1.x;
    u_xlat3.xy = u_xlat3.xy * vec2(0.001953125, 0.001953125);
    vs_TEXCOORD0.zw = u_xlat3.xy * _FaceTex_ST.xy + _FaceTex_ST.zw;
    vs_TEXCOORD1.xy = u_xlat3.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(0.0>=in_TEXCOORD1.y);
#else
    u_xlatb15 = 0.0>=in_TEXCOORD1.y;
#endif
    u_xlat15 = u_xlatb15 ? 1.0 : float(0.0);
    u_xlat16 = (-_WeightNormal) + _WeightBold;
    u_xlat15 = u_xlat15 * u_xlat16 + _WeightNormal;
    u_xlat15 = u_xlat15 * 0.25 + _FaceDilate;
    u_xlat15 = u_xlat15 * _ScaleRatioA;
    vs_TEXCOORD5.x = u_xlat15 * 0.5;
    u_xlat15 = u_xlat2.y * hlslcc_mtx4x4unity_MatrixVP[1].w;
    u_xlat15 = hlslcc_mtx4x4unity_MatrixVP[0].w * u_xlat2.x + u_xlat15;
    u_xlat15 = hlslcc_mtx4x4unity_MatrixVP[2].w * u_xlat2.z + u_xlat15;
    u_xlat15 = hlslcc_mtx4x4unity_MatrixVP[3].w * u_xlat2.w + u_xlat15;
    u_xlat2.xy = _ScreenParams.yy * hlslcc_mtx4x4glstate_matrix_projection[1].xy;
    u_xlat2.xy = hlslcc_mtx4x4glstate_matrix_projection[0].xy * _ScreenParams.xx + u_xlat2.xy;
    u_xlat2.xy = vec2(u_xlat2.x * float(_ScaleX), u_xlat2.y * float(_ScaleY));
    u_xlat2.xy = vec2(u_xlat15) / u_xlat2.xy;
    u_xlat15 = dot(u_xlat2.xy, u_xlat2.xy);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16 = abs(in_TEXCOORD1.y) * _GradientScale;
    u_xlat15 = u_xlat15 * u_xlat16;
    u_xlat16 = u_xlat15 * 1.5;
    u_xlat2.x = (-_PerspectiveFilter) + 1.0;
    u_xlat16 = u_xlat16 * u_xlat2.x;
    u_xlat15 = u_xlat15 * 1.5 + (-u_xlat16);
    u_xlat2.xyz = _WorldSpaceCameraPos.yyy * hlslcc_mtx4x4unity_WorldToObject[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat2.xyz + hlslcc_mtx4x4unity_WorldToObject[3].xyz;
    u_xlat0.z = in_POSITION0.z;
    u_xlat0.xyz = (-u_xlat0.xyz) + u_xlat2.xyz;
    u_xlat0.x = dot(in_NORMAL0.xyz, u_xlat0.xyz);
#ifdef UNITY_ADRENO_ES3
    { bool cond = 0.0<u_xlat0.x; u_xlati5 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati5 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0u));
#endif
#ifdef UNITY_ADRENO_ES3
    { bool cond = u_xlat0.x<0.0; u_xlati0 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0u));
#endif
    u_xlati0 = (-u_xlati5) + u_xlati0;
    u_xlat0.x = float(u_xlati0);
    u_xlat0.xyz = u_xlat0.xxx * in_NORMAL0.xyz;
    u_xlat2.y = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
    u_xlat2.z = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
    u_xlat2.x = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat2.xyz = (-u_xlat1.xyz) + _WorldSpaceCameraPos.xyz;
    u_xlat17 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat3.xyz = vec3(u_xlat17) * u_xlat2.xyz;
    u_xlat17 = dot(u_xlat0.yzx, u_xlat3.xyz);
    vs_TEXCOORD5.y = abs(u_xlat17) * u_xlat15 + u_xlat16;
    vs_TEXCOORD2.z = u_xlat0.y;
    u_xlat3.xyz = in_TANGENT0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].yzx;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * in_TANGENT0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * in_TANGENT0.zzz + u_xlat3.xyz;
    u_xlat15 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat3.xyz = vec3(u_xlat15) * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat0.xyz * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat0.zxy * u_xlat3.yzx + (-u_xlat4.xyz);
    u_xlat5 = in_TANGENT0.w * unity_WorldTransformParams.w;
    u_xlat4.xyz = vec3(u_xlat5) * u_xlat4.xyz;
    vs_TEXCOORD2.y = u_xlat4.x;
    vs_TEXCOORD2.w = u_xlat1.x;
    vs_TEXCOORD2.x = u_xlat3.z;
    vs_TEXCOORD3.z = u_xlat0.z;
    vs_TEXCOORD4.z = u_xlat0.x;
    vs_TEXCOORD3.x = u_xlat3.x;
    vs_TEXCOORD4.x = u_xlat3.y;
    vs_TEXCOORD3.w = u_xlat1.y;
    vs_TEXCOORD4.w = u_xlat1.z;
    vs_TEXCOORD3.y = u_xlat4.y;
    vs_TEXCOORD4.y = u_xlat4.z;
    vs_COLOR0 = in_COLOR0;
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4_EnvMatrix[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_EnvMatrix[0].xyz * u_xlat2.xxx + u_xlat0.xyz;
    vs_TEXCOORD6.xyz = hlslcc_mtx4x4_EnvMatrix[2].xyz * u_xlat2.zzz + u_xlat0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _Time;
uniform 	mediump vec4 _WorldSpaceLightPos0;
uniform 	mediump vec4 _LightColor0;
uniform 	float _FaceUVSpeedX;
uniform 	float _FaceUVSpeedY;
uniform 	mediump vec4 _FaceColor;
uniform 	float _OutlineSoftness;
uniform 	float _OutlineUVSpeedX;
uniform 	float _OutlineUVSpeedY;
uniform 	mediump vec4 _OutlineColor;
uniform 	float _OutlineWidth;
uniform 	float _ScaleRatioA;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _FaceTex;
uniform lowp sampler2D _OutlineTex;
in highp vec4 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec2 vs_TEXCOORD5;
in highp vec4 vs_TEXCOORD2;
in highp vec4 vs_TEXCOORD3;
in highp vec4 vs_TEXCOORD4;
in mediump vec4 vs_COLOR0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec3 u_xlat16_1;
mediump vec4 u_xlat16_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_3;
lowp vec4 u_xlat10_3;
mediump vec4 u_xlat16_4;
mediump vec4 u_xlat16_5;
mediump vec4 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_8;
mediump float u_xlat16_9;
float u_xlat10;
mediump float u_xlat16_15;
vec2 u_xlat16;
mediump float u_xlat16_22;
float u_xlat24;
void main()
{
    u_xlat10_0.x = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0.x = (-u_xlat10_0.x) + 0.5;
    u_xlat0.x = u_xlat16_0.x + (-vs_TEXCOORD5.x);
    u_xlat0.x = u_xlat0.x * vs_TEXCOORD5.y + 0.5;
    u_xlat7 = _OutlineWidth * _ScaleRatioA;
    u_xlat7 = u_xlat7 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat7 * 0.5 + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_8 = (-u_xlat7) * 0.5 + u_xlat0.x;
    u_xlat16_15 = min(u_xlat7, 1.0);
    u_xlat16_15 = sqrt(u_xlat16_15);
    u_xlat16_1.x = u_xlat16_15 * u_xlat16_1.x;
    u_xlat0.xy = vec2(_OutlineUVSpeedX, _OutlineUVSpeedY) * _Time.yy + vs_TEXCOORD1.xy;
    u_xlat10_0 = texture(_OutlineTex, u_xlat0.xy);
    u_xlat16_0.xyz = u_xlat10_0.xyz * _OutlineColor.xyz;
    u_xlat16_2.x = vs_COLOR0.w * _OutlineColor.w;
    u_xlat16_9 = u_xlat10_0.w * u_xlat16_2.x;
    u_xlat16.xy = vec2(_FaceUVSpeedX, _FaceUVSpeedY) * _Time.yy + vs_TEXCOORD0.zw;
    u_xlat10_3 = texture(_FaceTex, u_xlat16.xy);
    u_xlat16_4 = vs_COLOR0 * _FaceColor;
    u_xlat16_5 = u_xlat10_3 * u_xlat16_4;
    u_xlat16_6.xyz = u_xlat16_5.www * u_xlat16_5.xyz;
    u_xlat16_6.xyz = u_xlat16_0.xyz * vec3(u_xlat16_9) + (-u_xlat16_6.xyz);
    u_xlat16_6.w = u_xlat16_2.x * u_xlat10_0.w + (-u_xlat16_5.w);
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_6;
    u_xlat16_2.w = u_xlat16_4.w * u_xlat10_3.w + u_xlat16_0.w;
    u_xlat16_2.xyz = u_xlat16_5.xyz * u_xlat16_5.www + u_xlat16_0.xyz;
    u_xlat3.x = _OutlineSoftness * _ScaleRatioA;
    u_xlat10 = u_xlat3.x * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat3.x * vs_TEXCOORD5.y + 1.0;
    u_xlat16_8 = u_xlat10 * 0.5 + u_xlat16_8;
    u_xlat16_1.x = u_xlat16_8 / u_xlat16_1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_1.x = (-u_xlat16_1.x) + 1.0;
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_2;
    u_xlat16_3.x = max(u_xlat16_0.w, 9.99999975e-05);
    u_xlat16_3.xyz = u_xlat16_0.xyz / u_xlat16_3.xxx;
    SV_Target0.w = u_xlat16_0.w;
    u_xlat16_1.xyz = u_xlat16_3.xyz * _LightColor0.xyz;
    u_xlat3.x = vs_TEXCOORD2.z;
    u_xlat3.y = vs_TEXCOORD3.z;
    u_xlat3.z = vs_TEXCOORD4.z;
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = vec3(u_xlat24) * u_xlat3.xyz;
    u_xlat16_22 = dot(u_xlat3.xyz, _WorldSpaceLightPos0.xyz);
    u_xlat16_22 = max(u_xlat16_22, 0.0);
    SV_Target0.xyz = vec3(u_xlat16_22) * u_xlat16_1.xyz;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
"#ifdef VERTEX
#version 300 es

uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ScreenParams;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
uniform 	vec4 unity_WorldTransformParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_projection[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	float _FaceDilate;
uniform 	vec4 hlslcc_mtx4x4_EnvMatrix[4];
uniform 	float _WeightNormal;
uniform 	float _WeightBold;
uniform 	float _ScaleRatioA;
uniform 	float _VertexOffsetX;
uniform 	float _VertexOffsetY;
uniform 	float _GradientScale;
uniform 	float _ScaleX;
uniform 	float _ScaleY;
uniform 	float _PerspectiveFilter;
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _FaceTex_ST;
uniform 	vec4 _OutlineTex_ST;
in highp vec4 in_POSITION0;
in highp vec4 in_TANGENT0;
in highp vec3 in_NORMAL0;
in highp vec4 in_TEXCOORD0;
in highp vec4 in_TEXCOORD1;
in mediump vec4 in_COLOR0;
out highp vec4 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD5;
out highp vec4 vs_TEXCOORD2;
out highp vec4 vs_TEXCOORD3;
out highp vec4 vs_TEXCOORD4;
out mediump vec4 vs_COLOR0;
out highp vec3 vs_TEXCOORD6;
out mediump vec3 vs_TEXCOORD7;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
int u_xlati0;
vec4 u_xlat1;
vec4 u_xlat2;
vec4 u_xlat3;
vec3 u_xlat4;
mediump float u_xlat16_5;
mediump vec3 u_xlat16_6;
int u_xlati7;
float u_xlat21;
bool u_xlatb21;
float u_xlat22;
void main()
{
    u_xlat0.xy = vec2(in_POSITION0.x + float(_VertexOffsetX), in_POSITION0.y + float(_VertexOffsetY));
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat2 = u_xlat1 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat1.xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat2.zzzz + u_xlat3;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat2.wwww + u_xlat3;
    u_xlat21 = in_TEXCOORD1.x * 0.000244140625;
    u_xlat3.x = floor(u_xlat21);
    u_xlat3.y = (-u_xlat3.x) * 4096.0 + in_TEXCOORD1.x;
    u_xlat3.xy = u_xlat3.xy * vec2(0.001953125, 0.001953125);
    vs_TEXCOORD0.zw = u_xlat3.xy * _FaceTex_ST.xy + _FaceTex_ST.zw;
    vs_TEXCOORD1.xy = u_xlat3.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
#ifdef UNITY_ADRENO_ES3
    u_xlatb21 = !!(0.0>=in_TEXCOORD1.y);
#else
    u_xlatb21 = 0.0>=in_TEXCOORD1.y;
#endif
    u_xlat21 = u_xlatb21 ? 1.0 : float(0.0);
    u_xlat22 = (-_WeightNormal) + _WeightBold;
    u_xlat21 = u_xlat21 * u_xlat22 + _WeightNormal;
    u_xlat21 = u_xlat21 * 0.25 + _FaceDilate;
    u_xlat21 = u_xlat21 * _ScaleRatioA;
    vs_TEXCOORD5.x = u_xlat21 * 0.5;
    u_xlat21 = u_xlat2.y * hlslcc_mtx4x4unity_MatrixVP[1].w;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[0].w * u_xlat2.x + u_xlat21;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[2].w * u_xlat2.z + u_xlat21;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[3].w * u_xlat2.w + u_xlat21;
    u_xlat2.xy = _ScreenParams.yy * hlslcc_mtx4x4glstate_matrix_projection[1].xy;
    u_xlat2.xy = hlslcc_mtx4x4glstate_matrix_projection[0].xy * _ScreenParams.xx + u_xlat2.xy;
    u_xlat2.xy = vec2(u_xlat2.x * float(_ScaleX), u_xlat2.y * float(_ScaleY));
    u_xlat2.xy = vec2(u_xlat21) / u_xlat2.xy;
    u_xlat21 = dot(u_xlat2.xy, u_xlat2.xy);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat22 = abs(in_TEXCOORD1.y) * _GradientScale;
    u_xlat21 = u_xlat21 * u_xlat22;
    u_xlat22 = u_xlat21 * 1.5;
    u_xlat2.x = (-_PerspectiveFilter) + 1.0;
    u_xlat22 = u_xlat22 * u_xlat2.x;
    u_xlat21 = u_xlat21 * 1.5 + (-u_xlat22);
    u_xlat2.xyz = _WorldSpaceCameraPos.yyy * hlslcc_mtx4x4unity_WorldToObject[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat2.xyz + hlslcc_mtx4x4unity_WorldToObject[3].xyz;
    u_xlat0.z = in_POSITION0.z;
    u_xlat0.xyz = (-u_xlat0.xyz) + u_xlat2.xyz;
    u_xlat0.x = dot(in_NORMAL0.xyz, u_xlat0.xyz);
#ifdef UNITY_ADRENO_ES3
    { bool cond = 0.0<u_xlat0.x; u_xlati7 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati7 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0u));
#endif
#ifdef UNITY_ADRENO_ES3
    { bool cond = u_xlat0.x<0.0; u_xlati0 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0u));
#endif
    u_xlati0 = (-u_xlati7) + u_xlati0;
    u_xlat0.x = float(u_xlati0);
    u_xlat0.xyz = u_xlat0.xxx * in_NORMAL0.xyz;
    u_xlat2.x = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
    u_xlat2.y = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
    u_xlat2.z = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2 = u_xlat0.xxxx * u_xlat2.xyzz;
    u_xlat0.xyz = (-u_xlat1.xyz) + _WorldSpaceCameraPos.xyz;
    u_xlat3.x = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat3.x = inversesqrt(u_xlat3.x);
    u_xlat3.xyz = u_xlat0.xyz * u_xlat3.xxx;
    u_xlat3.x = dot(u_xlat2.xyw, u_xlat3.xyz);
    vs_TEXCOORD5.y = abs(u_xlat3.x) * u_xlat21 + u_xlat22;
    vs_TEXCOORD2.w = u_xlat1.x;
    u_xlat3.xyz = in_TANGENT0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].yzx;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * in_TANGENT0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * in_TANGENT0.zzz + u_xlat3.xyz;
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat21) * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat2.wxy * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat2.ywx * u_xlat3.yzx + (-u_xlat4.xyz);
    u_xlat21 = in_TANGENT0.w * unity_WorldTransformParams.w;
    u_xlat4.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    vs_TEXCOORD2.y = u_xlat4.x;
    vs_TEXCOORD2.z = u_xlat2.x;
    vs_TEXCOORD2.x = u_xlat3.z;
    vs_TEXCOORD3.x = u_xlat3.x;
    vs_TEXCOORD4.x = u_xlat3.y;
    vs_TEXCOORD3.w = u_xlat1.y;
    vs_TEXCOORD4.w = u_xlat1.z;
    vs_TEXCOORD3.z = u_xlat2.y;
    vs_TEXCOORD3.y = u_xlat4.y;
    vs_TEXCOORD4.y = u_xlat4.z;
    vs_TEXCOORD4.z = u_xlat2.w;
    vs_COLOR0 = in_COLOR0;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4_EnvMatrix[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4_EnvMatrix[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    vs_TEXCOORD6.xyz = hlslcc_mtx4x4_EnvMatrix[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat16_5 = u_xlat2.y * u_xlat2.y;
    u_xlat16_5 = u_xlat2.x * u_xlat2.x + (-u_xlat16_5);
    u_xlat16_0 = u_xlat2.ywzx * u_xlat2;
    u_xlat16_6.x = dot(unity_SHBr, u_xlat16_0);
    u_xlat16_6.y = dot(unity_SHBg, u_xlat16_0);
    u_xlat16_6.z = dot(unity_SHBb, u_xlat16_0);
    vs_TEXCOORD7.xyz = unity_SHC.xyz * vec3(u_xlat16_5) + u_xlat16_6.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _Time;
uniform 	mediump vec4 _WorldSpaceLightPos0;
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 _LightColor0;
uniform 	float _FaceUVSpeedX;
uniform 	float _FaceUVSpeedY;
uniform 	mediump vec4 _FaceColor;
uniform 	float _OutlineSoftness;
uniform 	float _OutlineUVSpeedX;
uniform 	float _OutlineUVSpeedY;
uniform 	mediump vec4 _OutlineColor;
uniform 	float _OutlineWidth;
uniform 	float _ScaleRatioA;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _FaceTex;
uniform lowp sampler2D _OutlineTex;
in highp vec4 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec2 vs_TEXCOORD5;
in highp vec4 vs_TEXCOORD2;
in highp vec4 vs_TEXCOORD3;
in highp vec4 vs_TEXCOORD4;
in mediump vec4 vs_COLOR0;
in mediump vec3 vs_TEXCOORD7;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec4 u_xlat16_1;
mediump vec4 u_xlat16_2;
float u_xlat3;
mediump vec3 u_xlat16_3;
lowp vec4 u_xlat10_3;
vec3 u_xlat4;
mediump vec4 u_xlat16_4;
mediump vec4 u_xlat16_5;
mediump vec4 u_xlat16_6;
float u_xlat7;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_9;
float u_xlat10;
mediump float u_xlat16_15;
vec2 u_xlat16;
float u_xlat24;
void main()
{
    u_xlat10_0.x = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0.x = (-u_xlat10_0.x) + 0.5;
    u_xlat0.x = u_xlat16_0.x + (-vs_TEXCOORD5.x);
    u_xlat0.x = u_xlat0.x * vs_TEXCOORD5.y + 0.5;
    u_xlat7 = _OutlineWidth * _ScaleRatioA;
    u_xlat7 = u_xlat7 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat7 * 0.5 + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = (-u_xlat7) * 0.5 + u_xlat0.x;
    u_xlat16_15 = min(u_xlat7, 1.0);
    u_xlat16_15 = sqrt(u_xlat16_15);
    u_xlat16_1.x = u_xlat16_15 * u_xlat16_1.x;
    u_xlat0.xy = vec2(_OutlineUVSpeedX, _OutlineUVSpeedY) * _Time.yy + vs_TEXCOORD1.xy;
    u_xlat10_0 = texture(_OutlineTex, u_xlat0.xy);
    u_xlat16_0.xyz = u_xlat10_0.xyz * _OutlineColor.xyz;
    u_xlat16_2.x = vs_COLOR0.w * _OutlineColor.w;
    u_xlat16_9 = u_xlat10_0.w * u_xlat16_2.x;
    u_xlat16.xy = vec2(_FaceUVSpeedX, _FaceUVSpeedY) * _Time.yy + vs_TEXCOORD0.zw;
    u_xlat10_3 = texture(_FaceTex, u_xlat16.xy);
    u_xlat16_4 = vs_COLOR0 * _FaceColor;
    u_xlat16_5 = u_xlat10_3 * u_xlat16_4;
    u_xlat16_6.xyz = u_xlat16_5.www * u_xlat16_5.xyz;
    u_xlat16_6.xyz = u_xlat16_0.xyz * vec3(u_xlat16_9) + (-u_xlat16_6.xyz);
    u_xlat16_6.w = u_xlat16_2.x * u_xlat10_0.w + (-u_xlat16_5.w);
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_6;
    u_xlat16_2.w = u_xlat16_4.w * u_xlat10_3.w + u_xlat16_0.w;
    u_xlat16_2.xyz = u_xlat16_5.xyz * u_xlat16_5.www + u_xlat16_0.xyz;
    u_xlat3 = _OutlineSoftness * _ScaleRatioA;
    u_xlat10 = u_xlat3 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat3 * vs_TEXCOORD5.y + 1.0;
    u_xlat16_8.x = u_xlat10 * 0.5 + u_xlat16_8.x;
    u_xlat16_1.x = u_xlat16_8.x / u_xlat16_1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_1.x = (-u_xlat16_1.x) + 1.0;
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_2;
    u_xlat16_3.x = max(u_xlat16_0.w, 9.99999975e-05);
    u_xlat16_3.xyz = u_xlat16_0.xyz / u_xlat16_3.xxx;
    SV_Target0.w = u_xlat16_0.w;
    u_xlat4.x = vs_TEXCOORD2.z;
    u_xlat4.y = vs_TEXCOORD3.z;
    u_xlat4.z = vs_TEXCOORD4.z;
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat16_1.x = dot(u_xlat0.xyz, _WorldSpaceLightPos0.xyz);
    u_xlat0.w = 1.0;
    u_xlat16_6.x = dot(unity_SHAr, u_xlat0);
    u_xlat16_6.y = dot(unity_SHAg, u_xlat0);
    u_xlat16_6.z = dot(unity_SHAb, u_xlat0);
    u_xlat16_1.yzw = u_xlat16_6.xyz + vs_TEXCOORD7.xyz;
    u_xlat16_1 = max(u_xlat16_1, vec4(0.0, 0.0, 0.0, 0.0));
    u_xlat16_4.xyz = log2(u_xlat16_1.yzw);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
    u_xlat16_4.xyz = exp2(u_xlat16_4.xyz);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_8.xyz = u_xlat16_3.xyz * u_xlat16_4.xyz;
    u_xlat16_6.xyz = u_xlat16_3.xyz * _LightColor0.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_1.xxx + u_xlat16_8.xyz;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
"#ifdef VERTEX
#version 300 es

uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ScreenParams;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
uniform 	vec4 unity_WorldTransformParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_projection[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	float _FaceDilate;
uniform 	vec4 hlslcc_mtx4x4_EnvMatrix[4];
uniform 	float _WeightNormal;
uniform 	float _WeightBold;
uniform 	float _ScaleRatioA;
uniform 	float _VertexOffsetX;
uniform 	float _VertexOffsetY;
uniform 	float _GradientScale;
uniform 	float _ScaleX;
uniform 	float _ScaleY;
uniform 	float _PerspectiveFilter;
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _FaceTex_ST;
uniform 	vec4 _OutlineTex_ST;
in highp vec4 in_POSITION0;
in highp vec4 in_TANGENT0;
in highp vec3 in_NORMAL0;
in highp vec4 in_TEXCOORD0;
in highp vec4 in_TEXCOORD1;
in mediump vec4 in_COLOR0;
out highp vec4 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD5;
out highp vec4 vs_TEXCOORD2;
out highp vec4 vs_TEXCOORD3;
out highp vec4 vs_TEXCOORD4;
out mediump vec4 vs_COLOR0;
out highp vec3 vs_TEXCOORD6;
out mediump vec3 vs_TEXCOORD7;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
int u_xlati0;
vec4 u_xlat1;
vec4 u_xlat2;
vec4 u_xlat3;
vec3 u_xlat4;
mediump float u_xlat16_5;
mediump vec3 u_xlat16_6;
int u_xlati7;
float u_xlat21;
bool u_xlatb21;
float u_xlat22;
void main()
{
    u_xlat0.xy = vec2(in_POSITION0.x + float(_VertexOffsetX), in_POSITION0.y + float(_VertexOffsetY));
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat2 = u_xlat1 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat1.xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat2.zzzz + u_xlat3;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat2.wwww + u_xlat3;
    u_xlat21 = in_TEXCOORD1.x * 0.000244140625;
    u_xlat3.x = floor(u_xlat21);
    u_xlat3.y = (-u_xlat3.x) * 4096.0 + in_TEXCOORD1.x;
    u_xlat3.xy = u_xlat3.xy * vec2(0.001953125, 0.001953125);
    vs_TEXCOORD0.zw = u_xlat3.xy * _FaceTex_ST.xy + _FaceTex_ST.zw;
    vs_TEXCOORD1.xy = u_xlat3.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
#ifdef UNITY_ADRENO_ES3
    u_xlatb21 = !!(0.0>=in_TEXCOORD1.y);
#else
    u_xlatb21 = 0.0>=in_TEXCOORD1.y;
#endif
    u_xlat21 = u_xlatb21 ? 1.0 : float(0.0);
    u_xlat22 = (-_WeightNormal) + _WeightBold;
    u_xlat21 = u_xlat21 * u_xlat22 + _WeightNormal;
    u_xlat21 = u_xlat21 * 0.25 + _FaceDilate;
    u_xlat21 = u_xlat21 * _ScaleRatioA;
    vs_TEXCOORD5.x = u_xlat21 * 0.5;
    u_xlat21 = u_xlat2.y * hlslcc_mtx4x4unity_MatrixVP[1].w;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[0].w * u_xlat2.x + u_xlat21;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[2].w * u_xlat2.z + u_xlat21;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[3].w * u_xlat2.w + u_xlat21;
    u_xlat2.xy = _ScreenParams.yy * hlslcc_mtx4x4glstate_matrix_projection[1].xy;
    u_xlat2.xy = hlslcc_mtx4x4glstate_matrix_projection[0].xy * _ScreenParams.xx + u_xlat2.xy;
    u_xlat2.xy = vec2(u_xlat2.x * float(_ScaleX), u_xlat2.y * float(_ScaleY));
    u_xlat2.xy = vec2(u_xlat21) / u_xlat2.xy;
    u_xlat21 = dot(u_xlat2.xy, u_xlat2.xy);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat22 = abs(in_TEXCOORD1.y) * _GradientScale;
    u_xlat21 = u_xlat21 * u_xlat22;
    u_xlat22 = u_xlat21 * 1.5;
    u_xlat2.x = (-_PerspectiveFilter) + 1.0;
    u_xlat22 = u_xlat22 * u_xlat2.x;
    u_xlat21 = u_xlat21 * 1.5 + (-u_xlat22);
    u_xlat2.xyz = _WorldSpaceCameraPos.yyy * hlslcc_mtx4x4unity_WorldToObject[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat2.xyz + hlslcc_mtx4x4unity_WorldToObject[3].xyz;
    u_xlat0.z = in_POSITION0.z;
    u_xlat0.xyz = (-u_xlat0.xyz) + u_xlat2.xyz;
    u_xlat0.x = dot(in_NORMAL0.xyz, u_xlat0.xyz);
#ifdef UNITY_ADRENO_ES3
    { bool cond = 0.0<u_xlat0.x; u_xlati7 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati7 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0u));
#endif
#ifdef UNITY_ADRENO_ES3
    { bool cond = u_xlat0.x<0.0; u_xlati0 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0u));
#endif
    u_xlati0 = (-u_xlati7) + u_xlati0;
    u_xlat0.x = float(u_xlati0);
    u_xlat0.xyz = u_xlat0.xxx * in_NORMAL0.xyz;
    u_xlat2.x = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
    u_xlat2.y = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
    u_xlat2.z = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2 = u_xlat0.xxxx * u_xlat2.xyzz;
    u_xlat0.xyz = (-u_xlat1.xyz) + _WorldSpaceCameraPos.xyz;
    u_xlat3.x = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat3.x = inversesqrt(u_xlat3.x);
    u_xlat3.xyz = u_xlat0.xyz * u_xlat3.xxx;
    u_xlat3.x = dot(u_xlat2.xyw, u_xlat3.xyz);
    vs_TEXCOORD5.y = abs(u_xlat3.x) * u_xlat21 + u_xlat22;
    vs_TEXCOORD2.w = u_xlat1.x;
    u_xlat3.xyz = in_TANGENT0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].yzx;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * in_TANGENT0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * in_TANGENT0.zzz + u_xlat3.xyz;
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat21) * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat2.wxy * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat2.ywx * u_xlat3.yzx + (-u_xlat4.xyz);
    u_xlat21 = in_TANGENT0.w * unity_WorldTransformParams.w;
    u_xlat4.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    vs_TEXCOORD2.y = u_xlat4.x;
    vs_TEXCOORD2.z = u_xlat2.x;
    vs_TEXCOORD2.x = u_xlat3.z;
    vs_TEXCOORD3.x = u_xlat3.x;
    vs_TEXCOORD4.x = u_xlat3.y;
    vs_TEXCOORD3.w = u_xlat1.y;
    vs_TEXCOORD4.w = u_xlat1.z;
    vs_TEXCOORD3.z = u_xlat2.y;
    vs_TEXCOORD3.y = u_xlat4.y;
    vs_TEXCOORD4.y = u_xlat4.z;
    vs_TEXCOORD4.z = u_xlat2.w;
    vs_COLOR0 = in_COLOR0;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4_EnvMatrix[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4_EnvMatrix[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    vs_TEXCOORD6.xyz = hlslcc_mtx4x4_EnvMatrix[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat16_5 = u_xlat2.y * u_xlat2.y;
    u_xlat16_5 = u_xlat2.x * u_xlat2.x + (-u_xlat16_5);
    u_xlat16_0 = u_xlat2.ywzx * u_xlat2;
    u_xlat16_6.x = dot(unity_SHBr, u_xlat16_0);
    u_xlat16_6.y = dot(unity_SHBg, u_xlat16_0);
    u_xlat16_6.z = dot(unity_SHBb, u_xlat16_0);
    vs_TEXCOORD7.xyz = unity_SHC.xyz * vec3(u_xlat16_5) + u_xlat16_6.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _Time;
uniform 	mediump vec4 _WorldSpaceLightPos0;
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 _LightColor0;
uniform 	float _FaceUVSpeedX;
uniform 	float _FaceUVSpeedY;
uniform 	mediump vec4 _FaceColor;
uniform 	float _OutlineSoftness;
uniform 	float _OutlineUVSpeedX;
uniform 	float _OutlineUVSpeedY;
uniform 	mediump vec4 _OutlineColor;
uniform 	float _OutlineWidth;
uniform 	float _ScaleRatioA;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _FaceTex;
uniform lowp sampler2D _OutlineTex;
in highp vec4 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec2 vs_TEXCOORD5;
in highp vec4 vs_TEXCOORD2;
in highp vec4 vs_TEXCOORD3;
in highp vec4 vs_TEXCOORD4;
in mediump vec4 vs_COLOR0;
in mediump vec3 vs_TEXCOORD7;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec4 u_xlat16_1;
mediump vec4 u_xlat16_2;
float u_xlat3;
mediump vec3 u_xlat16_3;
lowp vec4 u_xlat10_3;
vec3 u_xlat4;
mediump vec4 u_xlat16_4;
mediump vec4 u_xlat16_5;
mediump vec4 u_xlat16_6;
float u_xlat7;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_9;
float u_xlat10;
mediump float u_xlat16_15;
vec2 u_xlat16;
float u_xlat24;
void main()
{
    u_xlat10_0.x = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0.x = (-u_xlat10_0.x) + 0.5;
    u_xlat0.x = u_xlat16_0.x + (-vs_TEXCOORD5.x);
    u_xlat0.x = u_xlat0.x * vs_TEXCOORD5.y + 0.5;
    u_xlat7 = _OutlineWidth * _ScaleRatioA;
    u_xlat7 = u_xlat7 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat7 * 0.5 + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = (-u_xlat7) * 0.5 + u_xlat0.x;
    u_xlat16_15 = min(u_xlat7, 1.0);
    u_xlat16_15 = sqrt(u_xlat16_15);
    u_xlat16_1.x = u_xlat16_15 * u_xlat16_1.x;
    u_xlat0.xy = vec2(_OutlineUVSpeedX, _OutlineUVSpeedY) * _Time.yy + vs_TEXCOORD1.xy;
    u_xlat10_0 = texture(_OutlineTex, u_xlat0.xy);
    u_xlat16_0.xyz = u_xlat10_0.xyz * _OutlineColor.xyz;
    u_xlat16_2.x = vs_COLOR0.w * _OutlineColor.w;
    u_xlat16_9 = u_xlat10_0.w * u_xlat16_2.x;
    u_xlat16.xy = vec2(_FaceUVSpeedX, _FaceUVSpeedY) * _Time.yy + vs_TEXCOORD0.zw;
    u_xlat10_3 = texture(_FaceTex, u_xlat16.xy);
    u_xlat16_4 = vs_COLOR0 * _FaceColor;
    u_xlat16_5 = u_xlat10_3 * u_xlat16_4;
    u_xlat16_6.xyz = u_xlat16_5.www * u_xlat16_5.xyz;
    u_xlat16_6.xyz = u_xlat16_0.xyz * vec3(u_xlat16_9) + (-u_xlat16_6.xyz);
    u_xlat16_6.w = u_xlat16_2.x * u_xlat10_0.w + (-u_xlat16_5.w);
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_6;
    u_xlat16_2.w = u_xlat16_4.w * u_xlat10_3.w + u_xlat16_0.w;
    u_xlat16_2.xyz = u_xlat16_5.xyz * u_xlat16_5.www + u_xlat16_0.xyz;
    u_xlat3 = _OutlineSoftness * _ScaleRatioA;
    u_xlat10 = u_xlat3 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat3 * vs_TEXCOORD5.y + 1.0;
    u_xlat16_8.x = u_xlat10 * 0.5 + u_xlat16_8.x;
    u_xlat16_1.x = u_xlat16_8.x / u_xlat16_1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_1.x = (-u_xlat16_1.x) + 1.0;
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_2;
    u_xlat16_3.x = max(u_xlat16_0.w, 9.99999975e-05);
    u_xlat16_3.xyz = u_xlat16_0.xyz / u_xlat16_3.xxx;
    SV_Target0.w = u_xlat16_0.w;
    u_xlat4.x = vs_TEXCOORD2.z;
    u_xlat4.y = vs_TEXCOORD3.z;
    u_xlat4.z = vs_TEXCOORD4.z;
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat16_1.x = dot(u_xlat0.xyz, _WorldSpaceLightPos0.xyz);
    u_xlat0.w = 1.0;
    u_xlat16_6.x = dot(unity_SHAr, u_xlat0);
    u_xlat16_6.y = dot(unity_SHAg, u_xlat0);
    u_xlat16_6.z = dot(unity_SHAb, u_xlat0);
    u_xlat16_1.yzw = u_xlat16_6.xyz + vs_TEXCOORD7.xyz;
    u_xlat16_1 = max(u_xlat16_1, vec4(0.0, 0.0, 0.0, 0.0));
    u_xlat16_4.xyz = log2(u_xlat16_1.yzw);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
    u_xlat16_4.xyz = exp2(u_xlat16_4.xyz);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_8.xyz = u_xlat16_3.xyz * u_xlat16_4.xyz;
    u_xlat16_6.xyz = u_xlat16_3.xyz * _LightColor0.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_1.xxx + u_xlat16_8.xyz;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
"#ifdef VERTEX
#version 300 es

uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ScreenParams;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
uniform 	vec4 unity_WorldTransformParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_projection[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	float _FaceDilate;
uniform 	vec4 hlslcc_mtx4x4_EnvMatrix[4];
uniform 	float _WeightNormal;
uniform 	float _WeightBold;
uniform 	float _ScaleRatioA;
uniform 	float _VertexOffsetX;
uniform 	float _VertexOffsetY;
uniform 	float _GradientScale;
uniform 	float _ScaleX;
uniform 	float _ScaleY;
uniform 	float _PerspectiveFilter;
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _FaceTex_ST;
uniform 	vec4 _OutlineTex_ST;
in highp vec4 in_POSITION0;
in highp vec4 in_TANGENT0;
in highp vec3 in_NORMAL0;
in highp vec4 in_TEXCOORD0;
in highp vec4 in_TEXCOORD1;
in mediump vec4 in_COLOR0;
out highp vec4 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD5;
out highp vec4 vs_TEXCOORD2;
out highp vec4 vs_TEXCOORD3;
out highp vec4 vs_TEXCOORD4;
out mediump vec4 vs_COLOR0;
out highp vec3 vs_TEXCOORD6;
out mediump vec3 vs_TEXCOORD7;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
int u_xlati0;
vec4 u_xlat1;
vec4 u_xlat2;
vec4 u_xlat3;
vec3 u_xlat4;
mediump float u_xlat16_5;
mediump vec3 u_xlat16_6;
int u_xlati7;
float u_xlat21;
bool u_xlatb21;
float u_xlat22;
void main()
{
    u_xlat0.xy = vec2(in_POSITION0.x + float(_VertexOffsetX), in_POSITION0.y + float(_VertexOffsetY));
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat2 = u_xlat1 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat1.xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat2.zzzz + u_xlat3;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat2.wwww + u_xlat3;
    u_xlat21 = in_TEXCOORD1.x * 0.000244140625;
    u_xlat3.x = floor(u_xlat21);
    u_xlat3.y = (-u_xlat3.x) * 4096.0 + in_TEXCOORD1.x;
    u_xlat3.xy = u_xlat3.xy * vec2(0.001953125, 0.001953125);
    vs_TEXCOORD0.zw = u_xlat3.xy * _FaceTex_ST.xy + _FaceTex_ST.zw;
    vs_TEXCOORD1.xy = u_xlat3.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
#ifdef UNITY_ADRENO_ES3
    u_xlatb21 = !!(0.0>=in_TEXCOORD1.y);
#else
    u_xlatb21 = 0.0>=in_TEXCOORD1.y;
#endif
    u_xlat21 = u_xlatb21 ? 1.0 : float(0.0);
    u_xlat22 = (-_WeightNormal) + _WeightBold;
    u_xlat21 = u_xlat21 * u_xlat22 + _WeightNormal;
    u_xlat21 = u_xlat21 * 0.25 + _FaceDilate;
    u_xlat21 = u_xlat21 * _ScaleRatioA;
    vs_TEXCOORD5.x = u_xlat21 * 0.5;
    u_xlat21 = u_xlat2.y * hlslcc_mtx4x4unity_MatrixVP[1].w;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[0].w * u_xlat2.x + u_xlat21;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[2].w * u_xlat2.z + u_xlat21;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[3].w * u_xlat2.w + u_xlat21;
    u_xlat2.xy = _ScreenParams.yy * hlslcc_mtx4x4glstate_matrix_projection[1].xy;
    u_xlat2.xy = hlslcc_mtx4x4glstate_matrix_projection[0].xy * _ScreenParams.xx + u_xlat2.xy;
    u_xlat2.xy = vec2(u_xlat2.x * float(_ScaleX), u_xlat2.y * float(_ScaleY));
    u_xlat2.xy = vec2(u_xlat21) / u_xlat2.xy;
    u_xlat21 = dot(u_xlat2.xy, u_xlat2.xy);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat22 = abs(in_TEXCOORD1.y) * _GradientScale;
    u_xlat21 = u_xlat21 * u_xlat22;
    u_xlat22 = u_xlat21 * 1.5;
    u_xlat2.x = (-_PerspectiveFilter) + 1.0;
    u_xlat22 = u_xlat22 * u_xlat2.x;
    u_xlat21 = u_xlat21 * 1.5 + (-u_xlat22);
    u_xlat2.xyz = _WorldSpaceCameraPos.yyy * hlslcc_mtx4x4unity_WorldToObject[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat2.xyz + hlslcc_mtx4x4unity_WorldToObject[3].xyz;
    u_xlat0.z = in_POSITION0.z;
    u_xlat0.xyz = (-u_xlat0.xyz) + u_xlat2.xyz;
    u_xlat0.x = dot(in_NORMAL0.xyz, u_xlat0.xyz);
#ifdef UNITY_ADRENO_ES3
    { bool cond = 0.0<u_xlat0.x; u_xlati7 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati7 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0u));
#endif
#ifdef UNITY_ADRENO_ES3
    { bool cond = u_xlat0.x<0.0; u_xlati0 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0u));
#endif
    u_xlati0 = (-u_xlati7) + u_xlati0;
    u_xlat0.x = float(u_xlati0);
    u_xlat0.xyz = u_xlat0.xxx * in_NORMAL0.xyz;
    u_xlat2.x = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
    u_xlat2.y = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
    u_xlat2.z = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2 = u_xlat0.xxxx * u_xlat2.xyzz;
    u_xlat0.xyz = (-u_xlat1.xyz) + _WorldSpaceCameraPos.xyz;
    u_xlat3.x = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat3.x = inversesqrt(u_xlat3.x);
    u_xlat3.xyz = u_xlat0.xyz * u_xlat3.xxx;
    u_xlat3.x = dot(u_xlat2.xyw, u_xlat3.xyz);
    vs_TEXCOORD5.y = abs(u_xlat3.x) * u_xlat21 + u_xlat22;
    vs_TEXCOORD2.w = u_xlat1.x;
    u_xlat3.xyz = in_TANGENT0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].yzx;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * in_TANGENT0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * in_TANGENT0.zzz + u_xlat3.xyz;
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat21) * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat2.wxy * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat2.ywx * u_xlat3.yzx + (-u_xlat4.xyz);
    u_xlat21 = in_TANGENT0.w * unity_WorldTransformParams.w;
    u_xlat4.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    vs_TEXCOORD2.y = u_xlat4.x;
    vs_TEXCOORD2.z = u_xlat2.x;
    vs_TEXCOORD2.x = u_xlat3.z;
    vs_TEXCOORD3.x = u_xlat3.x;
    vs_TEXCOORD4.x = u_xlat3.y;
    vs_TEXCOORD3.w = u_xlat1.y;
    vs_TEXCOORD4.w = u_xlat1.z;
    vs_TEXCOORD3.z = u_xlat2.y;
    vs_TEXCOORD3.y = u_xlat4.y;
    vs_TEXCOORD4.y = u_xlat4.z;
    vs_TEXCOORD4.z = u_xlat2.w;
    vs_COLOR0 = in_COLOR0;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4_EnvMatrix[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4_EnvMatrix[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    vs_TEXCOORD6.xyz = hlslcc_mtx4x4_EnvMatrix[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat16_5 = u_xlat2.y * u_xlat2.y;
    u_xlat16_5 = u_xlat2.x * u_xlat2.x + (-u_xlat16_5);
    u_xlat16_0 = u_xlat2.ywzx * u_xlat2;
    u_xlat16_6.x = dot(unity_SHBr, u_xlat16_0);
    u_xlat16_6.y = dot(unity_SHBg, u_xlat16_0);
    u_xlat16_6.z = dot(unity_SHBb, u_xlat16_0);
    vs_TEXCOORD7.xyz = unity_SHC.xyz * vec3(u_xlat16_5) + u_xlat16_6.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _Time;
uniform 	mediump vec4 _WorldSpaceLightPos0;
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 _LightColor0;
uniform 	float _FaceUVSpeedX;
uniform 	float _FaceUVSpeedY;
uniform 	mediump vec4 _FaceColor;
uniform 	float _OutlineSoftness;
uniform 	float _OutlineUVSpeedX;
uniform 	float _OutlineUVSpeedY;
uniform 	mediump vec4 _OutlineColor;
uniform 	float _OutlineWidth;
uniform 	float _ScaleRatioA;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _FaceTex;
uniform lowp sampler2D _OutlineTex;
in highp vec4 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec2 vs_TEXCOORD5;
in highp vec4 vs_TEXCOORD2;
in highp vec4 vs_TEXCOORD3;
in highp vec4 vs_TEXCOORD4;
in mediump vec4 vs_COLOR0;
in mediump vec3 vs_TEXCOORD7;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec4 u_xlat16_1;
mediump vec4 u_xlat16_2;
float u_xlat3;
mediump vec3 u_xlat16_3;
lowp vec4 u_xlat10_3;
vec3 u_xlat4;
mediump vec4 u_xlat16_4;
mediump vec4 u_xlat16_5;
mediump vec4 u_xlat16_6;
float u_xlat7;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_9;
float u_xlat10;
mediump float u_xlat16_15;
vec2 u_xlat16;
float u_xlat24;
void main()
{
    u_xlat10_0.x = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0.x = (-u_xlat10_0.x) + 0.5;
    u_xlat0.x = u_xlat16_0.x + (-vs_TEXCOORD5.x);
    u_xlat0.x = u_xlat0.x * vs_TEXCOORD5.y + 0.5;
    u_xlat7 = _OutlineWidth * _ScaleRatioA;
    u_xlat7 = u_xlat7 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat7 * 0.5 + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = (-u_xlat7) * 0.5 + u_xlat0.x;
    u_xlat16_15 = min(u_xlat7, 1.0);
    u_xlat16_15 = sqrt(u_xlat16_15);
    u_xlat16_1.x = u_xlat16_15 * u_xlat16_1.x;
    u_xlat0.xy = vec2(_OutlineUVSpeedX, _OutlineUVSpeedY) * _Time.yy + vs_TEXCOORD1.xy;
    u_xlat10_0 = texture(_OutlineTex, u_xlat0.xy);
    u_xlat16_0.xyz = u_xlat10_0.xyz * _OutlineColor.xyz;
    u_xlat16_2.x = vs_COLOR0.w * _OutlineColor.w;
    u_xlat16_9 = u_xlat10_0.w * u_xlat16_2.x;
    u_xlat16.xy = vec2(_FaceUVSpeedX, _FaceUVSpeedY) * _Time.yy + vs_TEXCOORD0.zw;
    u_xlat10_3 = texture(_FaceTex, u_xlat16.xy);
    u_xlat16_4 = vs_COLOR0 * _FaceColor;
    u_xlat16_5 = u_xlat10_3 * u_xlat16_4;
    u_xlat16_6.xyz = u_xlat16_5.www * u_xlat16_5.xyz;
    u_xlat16_6.xyz = u_xlat16_0.xyz * vec3(u_xlat16_9) + (-u_xlat16_6.xyz);
    u_xlat16_6.w = u_xlat16_2.x * u_xlat10_0.w + (-u_xlat16_5.w);
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_6;
    u_xlat16_2.w = u_xlat16_4.w * u_xlat10_3.w + u_xlat16_0.w;
    u_xlat16_2.xyz = u_xlat16_5.xyz * u_xlat16_5.www + u_xlat16_0.xyz;
    u_xlat3 = _OutlineSoftness * _ScaleRatioA;
    u_xlat10 = u_xlat3 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat3 * vs_TEXCOORD5.y + 1.0;
    u_xlat16_8.x = u_xlat10 * 0.5 + u_xlat16_8.x;
    u_xlat16_1.x = u_xlat16_8.x / u_xlat16_1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_1.x = (-u_xlat16_1.x) + 1.0;
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_2;
    u_xlat16_3.x = max(u_xlat16_0.w, 9.99999975e-05);
    u_xlat16_3.xyz = u_xlat16_0.xyz / u_xlat16_3.xxx;
    SV_Target0.w = u_xlat16_0.w;
    u_xlat4.x = vs_TEXCOORD2.z;
    u_xlat4.y = vs_TEXCOORD3.z;
    u_xlat4.z = vs_TEXCOORD4.z;
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat16_1.x = dot(u_xlat0.xyz, _WorldSpaceLightPos0.xyz);
    u_xlat0.w = 1.0;
    u_xlat16_6.x = dot(unity_SHAr, u_xlat0);
    u_xlat16_6.y = dot(unity_SHAg, u_xlat0);
    u_xlat16_6.z = dot(unity_SHAb, u_xlat0);
    u_xlat16_1.yzw = u_xlat16_6.xyz + vs_TEXCOORD7.xyz;
    u_xlat16_1 = max(u_xlat16_1, vec4(0.0, 0.0, 0.0, 0.0));
    u_xlat16_4.xyz = log2(u_xlat16_1.yzw);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
    u_xlat16_4.xyz = exp2(u_xlat16_4.xyz);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_8.xyz = u_xlat16_3.xyz * u_xlat16_4.xyz;
    u_xlat16_6.xyz = u_xlat16_3.xyz * _LightColor0.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_1.xxx + u_xlat16_8.xyz;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ScreenParams;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
uniform 	vec4 unity_WorldTransformParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_projection[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	float _FaceDilate;
uniform 	vec4 hlslcc_mtx4x4_EnvMatrix[4];
uniform 	float _WeightNormal;
uniform 	float _WeightBold;
uniform 	float _ScaleRatioA;
uniform 	float _VertexOffsetX;
uniform 	float _VertexOffsetY;
uniform 	float _GradientScale;
uniform 	float _ScaleX;
uniform 	float _ScaleY;
uniform 	float _PerspectiveFilter;
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _FaceTex_ST;
uniform 	vec4 _OutlineTex_ST;
in highp vec4 in_POSITION0;
in highp vec4 in_TANGENT0;
in highp vec3 in_NORMAL0;
in highp vec4 in_TEXCOORD0;
in highp vec4 in_TEXCOORD1;
in mediump vec4 in_COLOR0;
out highp vec4 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD5;
out highp vec4 vs_TEXCOORD2;
out highp vec4 vs_TEXCOORD3;
out highp vec4 vs_TEXCOORD4;
out mediump vec4 vs_COLOR0;
out highp vec3 vs_TEXCOORD6;
out mediump vec3 vs_TEXCOORD7;
vec4 u_xlat0;
int u_xlati0;
vec4 u_xlat1;
vec4 u_xlat2;
mediump vec4 u_xlat16_2;
vec4 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_6;
int u_xlati7;
float u_xlat21;
bool u_xlatb21;
float u_xlat22;
void main()
{
    u_xlat0.xy = vec2(in_POSITION0.x + float(_VertexOffsetX), in_POSITION0.y + float(_VertexOffsetY));
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat2 = u_xlat1 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat1.xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat2.zzzz + u_xlat3;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat2.wwww + u_xlat3;
    u_xlat21 = in_TEXCOORD1.x * 0.000244140625;
    u_xlat3.x = floor(u_xlat21);
    u_xlat3.y = (-u_xlat3.x) * 4096.0 + in_TEXCOORD1.x;
    u_xlat3.xy = u_xlat3.xy * vec2(0.001953125, 0.001953125);
    vs_TEXCOORD0.zw = u_xlat3.xy * _FaceTex_ST.xy + _FaceTex_ST.zw;
    vs_TEXCOORD1.xy = u_xlat3.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
#ifdef UNITY_ADRENO_ES3
    u_xlatb21 = !!(0.0>=in_TEXCOORD1.y);
#else
    u_xlatb21 = 0.0>=in_TEXCOORD1.y;
#endif
    u_xlat21 = u_xlatb21 ? 1.0 : float(0.0);
    u_xlat22 = (-_WeightNormal) + _WeightBold;
    u_xlat21 = u_xlat21 * u_xlat22 + _WeightNormal;
    u_xlat21 = u_xlat21 * 0.25 + _FaceDilate;
    u_xlat21 = u_xlat21 * _ScaleRatioA;
    vs_TEXCOORD5.x = u_xlat21 * 0.5;
    u_xlat21 = u_xlat2.y * hlslcc_mtx4x4unity_MatrixVP[1].w;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[0].w * u_xlat2.x + u_xlat21;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[2].w * u_xlat2.z + u_xlat21;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[3].w * u_xlat2.w + u_xlat21;
    u_xlat2.xy = _ScreenParams.yy * hlslcc_mtx4x4glstate_matrix_projection[1].xy;
    u_xlat2.xy = hlslcc_mtx4x4glstate_matrix_projection[0].xy * _ScreenParams.xx + u_xlat2.xy;
    u_xlat2.xy = vec2(u_xlat2.x * float(_ScaleX), u_xlat2.y * float(_ScaleY));
    u_xlat2.xy = vec2(u_xlat21) / u_xlat2.xy;
    u_xlat21 = dot(u_xlat2.xy, u_xlat2.xy);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat22 = abs(in_TEXCOORD1.y) * _GradientScale;
    u_xlat21 = u_xlat21 * u_xlat22;
    u_xlat22 = u_xlat21 * 1.5;
    u_xlat2.x = (-_PerspectiveFilter) + 1.0;
    u_xlat22 = u_xlat22 * u_xlat2.x;
    u_xlat21 = u_xlat21 * 1.5 + (-u_xlat22);
    u_xlat2.xyz = _WorldSpaceCameraPos.yyy * hlslcc_mtx4x4unity_WorldToObject[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat2.xyz + hlslcc_mtx4x4unity_WorldToObject[3].xyz;
    u_xlat0.z = in_POSITION0.z;
    u_xlat0.xyz = (-u_xlat0.xyz) + u_xlat2.xyz;
    u_xlat0.x = dot(in_NORMAL0.xyz, u_xlat0.xyz);
#ifdef UNITY_ADRENO_ES3
    { bool cond = 0.0<u_xlat0.x; u_xlati7 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati7 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0u));
#endif
#ifdef UNITY_ADRENO_ES3
    { bool cond = u_xlat0.x<0.0; u_xlati0 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0u));
#endif
    u_xlati0 = (-u_xlati7) + u_xlati0;
    u_xlat0.x = float(u_xlati0);
    u_xlat0.xyz = u_xlat0.xxx * in_NORMAL0.xyz;
    u_xlat2.x = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
    u_xlat2.y = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
    u_xlat2.z = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2 = u_xlat0.xxxx * u_xlat2.xyzz;
    u_xlat0.xyz = (-u_xlat1.xyz) + _WorldSpaceCameraPos.xyz;
    u_xlat3.x = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat3.x = inversesqrt(u_xlat3.x);
    u_xlat3.xyz = u_xlat0.xyz * u_xlat3.xxx;
    u_xlat3.x = dot(u_xlat2.xyw, u_xlat3.xyz);
    vs_TEXCOORD5.y = abs(u_xlat3.x) * u_xlat21 + u_xlat22;
    u_xlat3.xyz = in_TANGENT0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].yzx;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * in_TANGENT0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * in_TANGENT0.zzz + u_xlat3.xyz;
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat21) * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat2.wxy * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat2.ywx * u_xlat3.yzx + (-u_xlat4.xyz);
    u_xlat21 = in_TANGENT0.w * unity_WorldTransformParams.w;
    u_xlat4.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    vs_TEXCOORD2.y = u_xlat4.x;
    vs_TEXCOORD2.z = u_xlat2.x;
    vs_TEXCOORD2.x = u_xlat3.z;
    vs_TEXCOORD2.w = u_xlat1.x;
    vs_TEXCOORD3.x = u_xlat3.x;
    vs_TEXCOORD4.x = u_xlat3.y;
    vs_TEXCOORD3.z = u_xlat2.y;
    vs_TEXCOORD3.y = u_xlat4.y;
    vs_TEXCOORD4.y = u_xlat4.z;
    vs_TEXCOORD3.w = u_xlat1.y;
    vs_TEXCOORD4.z = u_xlat2.w;
    vs_TEXCOORD4.w = u_xlat1.z;
    vs_COLOR0 = in_COLOR0;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4_EnvMatrix[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4_EnvMatrix[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    vs_TEXCOORD6.xyz = hlslcc_mtx4x4_EnvMatrix[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0 = (-u_xlat1.yyyy) + unity_4LightPosY0;
    u_xlat3 = u_xlat2.yyyy * u_xlat0;
    u_xlat0 = u_xlat0 * u_xlat0;
    u_xlat4 = (-u_xlat1.xxxx) + unity_4LightPosX0;
    u_xlat1 = (-u_xlat1.zzzz) + unity_4LightPosZ0;
    u_xlat3 = u_xlat4 * u_xlat2.xxxx + u_xlat3;
    u_xlat0 = u_xlat4 * u_xlat4 + u_xlat0;
    u_xlat0 = u_xlat1 * u_xlat1 + u_xlat0;
    u_xlat1 = u_xlat1 * u_xlat2.wwzw + u_xlat3;
    u_xlat0 = max(u_xlat0, vec4(9.99999997e-07, 9.99999997e-07, 9.99999997e-07, 9.99999997e-07));
    u_xlat3 = inversesqrt(u_xlat0);
    u_xlat0 = u_xlat0 * unity_4LightAtten0 + vec4(1.0, 1.0, 1.0, 1.0);
    u_xlat0 = vec4(1.0, 1.0, 1.0, 1.0) / u_xlat0;
    u_xlat1 = u_xlat1 * u_xlat3;
    u_xlat1 = max(u_xlat1, vec4(0.0, 0.0, 0.0, 0.0));
    u_xlat0 = u_xlat0 * u_xlat1;
    u_xlat1.xyz = u_xlat0.yyy * unity_LightColor[1].xyz;
    u_xlat1.xyz = unity_LightColor[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = unity_LightColor[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = unity_LightColor[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xyz = u_xlat0.xyz * vec3(0.305306017, 0.305306017, 0.305306017) + vec3(0.682171106, 0.682171106, 0.682171106);
    u_xlat1.xyz = u_xlat0.xyz * u_xlat1.xyz + vec3(0.0125228781, 0.0125228781, 0.0125228781);
    u_xlat16_5.x = u_xlat2.y * u_xlat2.y;
    u_xlat16_5.x = u_xlat2.x * u_xlat2.x + (-u_xlat16_5.x);
    u_xlat16_2 = u_xlat2.ywzx * u_xlat2;
    u_xlat16_6.x = dot(unity_SHBr, u_xlat16_2);
    u_xlat16_6.y = dot(unity_SHBg, u_xlat16_2);
    u_xlat16_6.z = dot(unity_SHBb, u_xlat16_2);
    u_xlat16_5.xyz = unity_SHC.xyz * u_xlat16_5.xxx + u_xlat16_6.xyz;
    vs_TEXCOORD7.xyz = u_xlat0.xyz * u_xlat1.xyz + u_xlat16_5.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _Time;
uniform 	mediump vec4 _WorldSpaceLightPos0;
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 _LightColor0;
uniform 	float _FaceUVSpeedX;
uniform 	float _FaceUVSpeedY;
uniform 	mediump vec4 _FaceColor;
uniform 	float _OutlineSoftness;
uniform 	float _OutlineUVSpeedX;
uniform 	float _OutlineUVSpeedY;
uniform 	mediump vec4 _OutlineColor;
uniform 	float _OutlineWidth;
uniform 	float _ScaleRatioA;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _FaceTex;
uniform lowp sampler2D _OutlineTex;
in highp vec4 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec2 vs_TEXCOORD5;
in highp vec4 vs_TEXCOORD2;
in highp vec4 vs_TEXCOORD3;
in highp vec4 vs_TEXCOORD4;
in mediump vec4 vs_COLOR0;
in mediump vec3 vs_TEXCOORD7;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec4 u_xlat16_1;
mediump vec4 u_xlat16_2;
float u_xlat3;
mediump vec3 u_xlat16_3;
lowp vec4 u_xlat10_3;
vec3 u_xlat4;
mediump vec4 u_xlat16_4;
mediump vec4 u_xlat16_5;
mediump vec4 u_xlat16_6;
float u_xlat7;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_9;
float u_xlat10;
mediump float u_xlat16_15;
vec2 u_xlat16;
float u_xlat24;
void main()
{
    u_xlat10_0.x = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0.x = (-u_xlat10_0.x) + 0.5;
    u_xlat0.x = u_xlat16_0.x + (-vs_TEXCOORD5.x);
    u_xlat0.x = u_xlat0.x * vs_TEXCOORD5.y + 0.5;
    u_xlat7 = _OutlineWidth * _ScaleRatioA;
    u_xlat7 = u_xlat7 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat7 * 0.5 + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = (-u_xlat7) * 0.5 + u_xlat0.x;
    u_xlat16_15 = min(u_xlat7, 1.0);
    u_xlat16_15 = sqrt(u_xlat16_15);
    u_xlat16_1.x = u_xlat16_15 * u_xlat16_1.x;
    u_xlat0.xy = vec2(_OutlineUVSpeedX, _OutlineUVSpeedY) * _Time.yy + vs_TEXCOORD1.xy;
    u_xlat10_0 = texture(_OutlineTex, u_xlat0.xy);
    u_xlat16_0.xyz = u_xlat10_0.xyz * _OutlineColor.xyz;
    u_xlat16_2.x = vs_COLOR0.w * _OutlineColor.w;
    u_xlat16_9 = u_xlat10_0.w * u_xlat16_2.x;
    u_xlat16.xy = vec2(_FaceUVSpeedX, _FaceUVSpeedY) * _Time.yy + vs_TEXCOORD0.zw;
    u_xlat10_3 = texture(_FaceTex, u_xlat16.xy);
    u_xlat16_4 = vs_COLOR0 * _FaceColor;
    u_xlat16_5 = u_xlat10_3 * u_xlat16_4;
    u_xlat16_6.xyz = u_xlat16_5.www * u_xlat16_5.xyz;
    u_xlat16_6.xyz = u_xlat16_0.xyz * vec3(u_xlat16_9) + (-u_xlat16_6.xyz);
    u_xlat16_6.w = u_xlat16_2.x * u_xlat10_0.w + (-u_xlat16_5.w);
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_6;
    u_xlat16_2.w = u_xlat16_4.w * u_xlat10_3.w + u_xlat16_0.w;
    u_xlat16_2.xyz = u_xlat16_5.xyz * u_xlat16_5.www + u_xlat16_0.xyz;
    u_xlat3 = _OutlineSoftness * _ScaleRatioA;
    u_xlat10 = u_xlat3 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat3 * vs_TEXCOORD5.y + 1.0;
    u_xlat16_8.x = u_xlat10 * 0.5 + u_xlat16_8.x;
    u_xlat16_1.x = u_xlat16_8.x / u_xlat16_1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_1.x = (-u_xlat16_1.x) + 1.0;
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_2;
    u_xlat16_3.x = max(u_xlat16_0.w, 9.99999975e-05);
    u_xlat16_3.xyz = u_xlat16_0.xyz / u_xlat16_3.xxx;
    SV_Target0.w = u_xlat16_0.w;
    u_xlat4.x = vs_TEXCOORD2.z;
    u_xlat4.y = vs_TEXCOORD3.z;
    u_xlat4.z = vs_TEXCOORD4.z;
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat16_1.x = dot(u_xlat0.xyz, _WorldSpaceLightPos0.xyz);
    u_xlat0.w = 1.0;
    u_xlat16_6.x = dot(unity_SHAr, u_xlat0);
    u_xlat16_6.y = dot(unity_SHAg, u_xlat0);
    u_xlat16_6.z = dot(unity_SHAb, u_xlat0);
    u_xlat16_1.yzw = u_xlat16_6.xyz + vs_TEXCOORD7.xyz;
    u_xlat16_1 = max(u_xlat16_1, vec4(0.0, 0.0, 0.0, 0.0));
    u_xlat16_4.xyz = log2(u_xlat16_1.yzw);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
    u_xlat16_4.xyz = exp2(u_xlat16_4.xyz);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_8.xyz = u_xlat16_3.xyz * u_xlat16_4.xyz;
    u_xlat16_6.xyz = u_xlat16_3.xyz * _LightColor0.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_1.xxx + u_xlat16_8.xyz;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ScreenParams;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
uniform 	vec4 unity_WorldTransformParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_projection[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	float _FaceDilate;
uniform 	vec4 hlslcc_mtx4x4_EnvMatrix[4];
uniform 	float _WeightNormal;
uniform 	float _WeightBold;
uniform 	float _ScaleRatioA;
uniform 	float _VertexOffsetX;
uniform 	float _VertexOffsetY;
uniform 	float _GradientScale;
uniform 	float _ScaleX;
uniform 	float _ScaleY;
uniform 	float _PerspectiveFilter;
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _FaceTex_ST;
uniform 	vec4 _OutlineTex_ST;
in highp vec4 in_POSITION0;
in highp vec4 in_TANGENT0;
in highp vec3 in_NORMAL0;
in highp vec4 in_TEXCOORD0;
in highp vec4 in_TEXCOORD1;
in mediump vec4 in_COLOR0;
out highp vec4 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD5;
out highp vec4 vs_TEXCOORD2;
out highp vec4 vs_TEXCOORD3;
out highp vec4 vs_TEXCOORD4;
out mediump vec4 vs_COLOR0;
out highp vec3 vs_TEXCOORD6;
out mediump vec3 vs_TEXCOORD7;
vec4 u_xlat0;
int u_xlati0;
vec4 u_xlat1;
vec4 u_xlat2;
mediump vec4 u_xlat16_2;
vec4 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_6;
int u_xlati7;
float u_xlat21;
bool u_xlatb21;
float u_xlat22;
void main()
{
    u_xlat0.xy = vec2(in_POSITION0.x + float(_VertexOffsetX), in_POSITION0.y + float(_VertexOffsetY));
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat2 = u_xlat1 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat1.xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat2.zzzz + u_xlat3;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat2.wwww + u_xlat3;
    u_xlat21 = in_TEXCOORD1.x * 0.000244140625;
    u_xlat3.x = floor(u_xlat21);
    u_xlat3.y = (-u_xlat3.x) * 4096.0 + in_TEXCOORD1.x;
    u_xlat3.xy = u_xlat3.xy * vec2(0.001953125, 0.001953125);
    vs_TEXCOORD0.zw = u_xlat3.xy * _FaceTex_ST.xy + _FaceTex_ST.zw;
    vs_TEXCOORD1.xy = u_xlat3.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
#ifdef UNITY_ADRENO_ES3
    u_xlatb21 = !!(0.0>=in_TEXCOORD1.y);
#else
    u_xlatb21 = 0.0>=in_TEXCOORD1.y;
#endif
    u_xlat21 = u_xlatb21 ? 1.0 : float(0.0);
    u_xlat22 = (-_WeightNormal) + _WeightBold;
    u_xlat21 = u_xlat21 * u_xlat22 + _WeightNormal;
    u_xlat21 = u_xlat21 * 0.25 + _FaceDilate;
    u_xlat21 = u_xlat21 * _ScaleRatioA;
    vs_TEXCOORD5.x = u_xlat21 * 0.5;
    u_xlat21 = u_xlat2.y * hlslcc_mtx4x4unity_MatrixVP[1].w;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[0].w * u_xlat2.x + u_xlat21;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[2].w * u_xlat2.z + u_xlat21;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[3].w * u_xlat2.w + u_xlat21;
    u_xlat2.xy = _ScreenParams.yy * hlslcc_mtx4x4glstate_matrix_projection[1].xy;
    u_xlat2.xy = hlslcc_mtx4x4glstate_matrix_projection[0].xy * _ScreenParams.xx + u_xlat2.xy;
    u_xlat2.xy = vec2(u_xlat2.x * float(_ScaleX), u_xlat2.y * float(_ScaleY));
    u_xlat2.xy = vec2(u_xlat21) / u_xlat2.xy;
    u_xlat21 = dot(u_xlat2.xy, u_xlat2.xy);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat22 = abs(in_TEXCOORD1.y) * _GradientScale;
    u_xlat21 = u_xlat21 * u_xlat22;
    u_xlat22 = u_xlat21 * 1.5;
    u_xlat2.x = (-_PerspectiveFilter) + 1.0;
    u_xlat22 = u_xlat22 * u_xlat2.x;
    u_xlat21 = u_xlat21 * 1.5 + (-u_xlat22);
    u_xlat2.xyz = _WorldSpaceCameraPos.yyy * hlslcc_mtx4x4unity_WorldToObject[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat2.xyz + hlslcc_mtx4x4unity_WorldToObject[3].xyz;
    u_xlat0.z = in_POSITION0.z;
    u_xlat0.xyz = (-u_xlat0.xyz) + u_xlat2.xyz;
    u_xlat0.x = dot(in_NORMAL0.xyz, u_xlat0.xyz);
#ifdef UNITY_ADRENO_ES3
    { bool cond = 0.0<u_xlat0.x; u_xlati7 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati7 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0u));
#endif
#ifdef UNITY_ADRENO_ES3
    { bool cond = u_xlat0.x<0.0; u_xlati0 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0u));
#endif
    u_xlati0 = (-u_xlati7) + u_xlati0;
    u_xlat0.x = float(u_xlati0);
    u_xlat0.xyz = u_xlat0.xxx * in_NORMAL0.xyz;
    u_xlat2.x = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
    u_xlat2.y = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
    u_xlat2.z = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2 = u_xlat0.xxxx * u_xlat2.xyzz;
    u_xlat0.xyz = (-u_xlat1.xyz) + _WorldSpaceCameraPos.xyz;
    u_xlat3.x = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat3.x = inversesqrt(u_xlat3.x);
    u_xlat3.xyz = u_xlat0.xyz * u_xlat3.xxx;
    u_xlat3.x = dot(u_xlat2.xyw, u_xlat3.xyz);
    vs_TEXCOORD5.y = abs(u_xlat3.x) * u_xlat21 + u_xlat22;
    u_xlat3.xyz = in_TANGENT0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].yzx;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * in_TANGENT0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * in_TANGENT0.zzz + u_xlat3.xyz;
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat21) * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat2.wxy * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat2.ywx * u_xlat3.yzx + (-u_xlat4.xyz);
    u_xlat21 = in_TANGENT0.w * unity_WorldTransformParams.w;
    u_xlat4.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    vs_TEXCOORD2.y = u_xlat4.x;
    vs_TEXCOORD2.z = u_xlat2.x;
    vs_TEXCOORD2.x = u_xlat3.z;
    vs_TEXCOORD2.w = u_xlat1.x;
    vs_TEXCOORD3.x = u_xlat3.x;
    vs_TEXCOORD4.x = u_xlat3.y;
    vs_TEXCOORD3.z = u_xlat2.y;
    vs_TEXCOORD3.y = u_xlat4.y;
    vs_TEXCOORD4.y = u_xlat4.z;
    vs_TEXCOORD3.w = u_xlat1.y;
    vs_TEXCOORD4.z = u_xlat2.w;
    vs_TEXCOORD4.w = u_xlat1.z;
    vs_COLOR0 = in_COLOR0;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4_EnvMatrix[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4_EnvMatrix[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    vs_TEXCOORD6.xyz = hlslcc_mtx4x4_EnvMatrix[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0 = (-u_xlat1.yyyy) + unity_4LightPosY0;
    u_xlat3 = u_xlat2.yyyy * u_xlat0;
    u_xlat0 = u_xlat0 * u_xlat0;
    u_xlat4 = (-u_xlat1.xxxx) + unity_4LightPosX0;
    u_xlat1 = (-u_xlat1.zzzz) + unity_4LightPosZ0;
    u_xlat3 = u_xlat4 * u_xlat2.xxxx + u_xlat3;
    u_xlat0 = u_xlat4 * u_xlat4 + u_xlat0;
    u_xlat0 = u_xlat1 * u_xlat1 + u_xlat0;
    u_xlat1 = u_xlat1 * u_xlat2.wwzw + u_xlat3;
    u_xlat0 = max(u_xlat0, vec4(9.99999997e-07, 9.99999997e-07, 9.99999997e-07, 9.99999997e-07));
    u_xlat3 = inversesqrt(u_xlat0);
    u_xlat0 = u_xlat0 * unity_4LightAtten0 + vec4(1.0, 1.0, 1.0, 1.0);
    u_xlat0 = vec4(1.0, 1.0, 1.0, 1.0) / u_xlat0;
    u_xlat1 = u_xlat1 * u_xlat3;
    u_xlat1 = max(u_xlat1, vec4(0.0, 0.0, 0.0, 0.0));
    u_xlat0 = u_xlat0 * u_xlat1;
    u_xlat1.xyz = u_xlat0.yyy * unity_LightColor[1].xyz;
    u_xlat1.xyz = unity_LightColor[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = unity_LightColor[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = unity_LightColor[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xyz = u_xlat0.xyz * vec3(0.305306017, 0.305306017, 0.305306017) + vec3(0.682171106, 0.682171106, 0.682171106);
    u_xlat1.xyz = u_xlat0.xyz * u_xlat1.xyz + vec3(0.0125228781, 0.0125228781, 0.0125228781);
    u_xlat16_5.x = u_xlat2.y * u_xlat2.y;
    u_xlat16_5.x = u_xlat2.x * u_xlat2.x + (-u_xlat16_5.x);
    u_xlat16_2 = u_xlat2.ywzx * u_xlat2;
    u_xlat16_6.x = dot(unity_SHBr, u_xlat16_2);
    u_xlat16_6.y = dot(unity_SHBg, u_xlat16_2);
    u_xlat16_6.z = dot(unity_SHBb, u_xlat16_2);
    u_xlat16_5.xyz = unity_SHC.xyz * u_xlat16_5.xxx + u_xlat16_6.xyz;
    vs_TEXCOORD7.xyz = u_xlat0.xyz * u_xlat1.xyz + u_xlat16_5.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _Time;
uniform 	mediump vec4 _WorldSpaceLightPos0;
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 _LightColor0;
uniform 	float _FaceUVSpeedX;
uniform 	float _FaceUVSpeedY;
uniform 	mediump vec4 _FaceColor;
uniform 	float _OutlineSoftness;
uniform 	float _OutlineUVSpeedX;
uniform 	float _OutlineUVSpeedY;
uniform 	mediump vec4 _OutlineColor;
uniform 	float _OutlineWidth;
uniform 	float _ScaleRatioA;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _FaceTex;
uniform lowp sampler2D _OutlineTex;
in highp vec4 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec2 vs_TEXCOORD5;
in highp vec4 vs_TEXCOORD2;
in highp vec4 vs_TEXCOORD3;
in highp vec4 vs_TEXCOORD4;
in mediump vec4 vs_COLOR0;
in mediump vec3 vs_TEXCOORD7;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec4 u_xlat16_1;
mediump vec4 u_xlat16_2;
float u_xlat3;
mediump vec3 u_xlat16_3;
lowp vec4 u_xlat10_3;
vec3 u_xlat4;
mediump vec4 u_xlat16_4;
mediump vec4 u_xlat16_5;
mediump vec4 u_xlat16_6;
float u_xlat7;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_9;
float u_xlat10;
mediump float u_xlat16_15;
vec2 u_xlat16;
float u_xlat24;
void main()
{
    u_xlat10_0.x = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0.x = (-u_xlat10_0.x) + 0.5;
    u_xlat0.x = u_xlat16_0.x + (-vs_TEXCOORD5.x);
    u_xlat0.x = u_xlat0.x * vs_TEXCOORD5.y + 0.5;
    u_xlat7 = _OutlineWidth * _ScaleRatioA;
    u_xlat7 = u_xlat7 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat7 * 0.5 + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = (-u_xlat7) * 0.5 + u_xlat0.x;
    u_xlat16_15 = min(u_xlat7, 1.0);
    u_xlat16_15 = sqrt(u_xlat16_15);
    u_xlat16_1.x = u_xlat16_15 * u_xlat16_1.x;
    u_xlat0.xy = vec2(_OutlineUVSpeedX, _OutlineUVSpeedY) * _Time.yy + vs_TEXCOORD1.xy;
    u_xlat10_0 = texture(_OutlineTex, u_xlat0.xy);
    u_xlat16_0.xyz = u_xlat10_0.xyz * _OutlineColor.xyz;
    u_xlat16_2.x = vs_COLOR0.w * _OutlineColor.w;
    u_xlat16_9 = u_xlat10_0.w * u_xlat16_2.x;
    u_xlat16.xy = vec2(_FaceUVSpeedX, _FaceUVSpeedY) * _Time.yy + vs_TEXCOORD0.zw;
    u_xlat10_3 = texture(_FaceTex, u_xlat16.xy);
    u_xlat16_4 = vs_COLOR0 * _FaceColor;
    u_xlat16_5 = u_xlat10_3 * u_xlat16_4;
    u_xlat16_6.xyz = u_xlat16_5.www * u_xlat16_5.xyz;
    u_xlat16_6.xyz = u_xlat16_0.xyz * vec3(u_xlat16_9) + (-u_xlat16_6.xyz);
    u_xlat16_6.w = u_xlat16_2.x * u_xlat10_0.w + (-u_xlat16_5.w);
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_6;
    u_xlat16_2.w = u_xlat16_4.w * u_xlat10_3.w + u_xlat16_0.w;
    u_xlat16_2.xyz = u_xlat16_5.xyz * u_xlat16_5.www + u_xlat16_0.xyz;
    u_xlat3 = _OutlineSoftness * _ScaleRatioA;
    u_xlat10 = u_xlat3 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat3 * vs_TEXCOORD5.y + 1.0;
    u_xlat16_8.x = u_xlat10 * 0.5 + u_xlat16_8.x;
    u_xlat16_1.x = u_xlat16_8.x / u_xlat16_1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_1.x = (-u_xlat16_1.x) + 1.0;
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_2;
    u_xlat16_3.x = max(u_xlat16_0.w, 9.99999975e-05);
    u_xlat16_3.xyz = u_xlat16_0.xyz / u_xlat16_3.xxx;
    SV_Target0.w = u_xlat16_0.w;
    u_xlat4.x = vs_TEXCOORD2.z;
    u_xlat4.y = vs_TEXCOORD3.z;
    u_xlat4.z = vs_TEXCOORD4.z;
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat16_1.x = dot(u_xlat0.xyz, _WorldSpaceLightPos0.xyz);
    u_xlat0.w = 1.0;
    u_xlat16_6.x = dot(unity_SHAr, u_xlat0);
    u_xlat16_6.y = dot(unity_SHAg, u_xlat0);
    u_xlat16_6.z = dot(unity_SHAb, u_xlat0);
    u_xlat16_1.yzw = u_xlat16_6.xyz + vs_TEXCOORD7.xyz;
    u_xlat16_1 = max(u_xlat16_1, vec4(0.0, 0.0, 0.0, 0.0));
    u_xlat16_4.xyz = log2(u_xlat16_1.yzw);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
    u_xlat16_4.xyz = exp2(u_xlat16_4.xyz);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_8.xyz = u_xlat16_3.xyz * u_xlat16_4.xyz;
    u_xlat16_6.xyz = u_xlat16_3.xyz * _LightColor0.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_1.xxx + u_xlat16_8.xyz;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ScreenParams;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
uniform 	vec4 unity_WorldTransformParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_projection[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	float _FaceDilate;
uniform 	vec4 hlslcc_mtx4x4_EnvMatrix[4];
uniform 	float _WeightNormal;
uniform 	float _WeightBold;
uniform 	float _ScaleRatioA;
uniform 	float _VertexOffsetX;
uniform 	float _VertexOffsetY;
uniform 	float _GradientScale;
uniform 	float _ScaleX;
uniform 	float _ScaleY;
uniform 	float _PerspectiveFilter;
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _FaceTex_ST;
uniform 	vec4 _OutlineTex_ST;
in highp vec4 in_POSITION0;
in highp vec4 in_TANGENT0;
in highp vec3 in_NORMAL0;
in highp vec4 in_TEXCOORD0;
in highp vec4 in_TEXCOORD1;
in mediump vec4 in_COLOR0;
out highp vec4 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD5;
out highp vec4 vs_TEXCOORD2;
out highp vec4 vs_TEXCOORD3;
out highp vec4 vs_TEXCOORD4;
out mediump vec4 vs_COLOR0;
out highp vec3 vs_TEXCOORD6;
out mediump vec3 vs_TEXCOORD7;
vec4 u_xlat0;
int u_xlati0;
vec4 u_xlat1;
vec4 u_xlat2;
mediump vec4 u_xlat16_2;
vec4 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_6;
int u_xlati7;
float u_xlat21;
bool u_xlatb21;
float u_xlat22;
void main()
{
    u_xlat0.xy = vec2(in_POSITION0.x + float(_VertexOffsetX), in_POSITION0.y + float(_VertexOffsetY));
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat2 = u_xlat1 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat1.xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat2.zzzz + u_xlat3;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat2.wwww + u_xlat3;
    u_xlat21 = in_TEXCOORD1.x * 0.000244140625;
    u_xlat3.x = floor(u_xlat21);
    u_xlat3.y = (-u_xlat3.x) * 4096.0 + in_TEXCOORD1.x;
    u_xlat3.xy = u_xlat3.xy * vec2(0.001953125, 0.001953125);
    vs_TEXCOORD0.zw = u_xlat3.xy * _FaceTex_ST.xy + _FaceTex_ST.zw;
    vs_TEXCOORD1.xy = u_xlat3.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
#ifdef UNITY_ADRENO_ES3
    u_xlatb21 = !!(0.0>=in_TEXCOORD1.y);
#else
    u_xlatb21 = 0.0>=in_TEXCOORD1.y;
#endif
    u_xlat21 = u_xlatb21 ? 1.0 : float(0.0);
    u_xlat22 = (-_WeightNormal) + _WeightBold;
    u_xlat21 = u_xlat21 * u_xlat22 + _WeightNormal;
    u_xlat21 = u_xlat21 * 0.25 + _FaceDilate;
    u_xlat21 = u_xlat21 * _ScaleRatioA;
    vs_TEXCOORD5.x = u_xlat21 * 0.5;
    u_xlat21 = u_xlat2.y * hlslcc_mtx4x4unity_MatrixVP[1].w;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[0].w * u_xlat2.x + u_xlat21;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[2].w * u_xlat2.z + u_xlat21;
    u_xlat21 = hlslcc_mtx4x4unity_MatrixVP[3].w * u_xlat2.w + u_xlat21;
    u_xlat2.xy = _ScreenParams.yy * hlslcc_mtx4x4glstate_matrix_projection[1].xy;
    u_xlat2.xy = hlslcc_mtx4x4glstate_matrix_projection[0].xy * _ScreenParams.xx + u_xlat2.xy;
    u_xlat2.xy = vec2(u_xlat2.x * float(_ScaleX), u_xlat2.y * float(_ScaleY));
    u_xlat2.xy = vec2(u_xlat21) / u_xlat2.xy;
    u_xlat21 = dot(u_xlat2.xy, u_xlat2.xy);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat22 = abs(in_TEXCOORD1.y) * _GradientScale;
    u_xlat21 = u_xlat21 * u_xlat22;
    u_xlat22 = u_xlat21 * 1.5;
    u_xlat2.x = (-_PerspectiveFilter) + 1.0;
    u_xlat22 = u_xlat22 * u_xlat2.x;
    u_xlat21 = u_xlat21 * 1.5 + (-u_xlat22);
    u_xlat2.xyz = _WorldSpaceCameraPos.yyy * hlslcc_mtx4x4unity_WorldToObject[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat2.xyz + hlslcc_mtx4x4unity_WorldToObject[3].xyz;
    u_xlat0.z = in_POSITION0.z;
    u_xlat0.xyz = (-u_xlat0.xyz) + u_xlat2.xyz;
    u_xlat0.x = dot(in_NORMAL0.xyz, u_xlat0.xyz);
#ifdef UNITY_ADRENO_ES3
    { bool cond = 0.0<u_xlat0.x; u_xlati7 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati7 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0u));
#endif
#ifdef UNITY_ADRENO_ES3
    { bool cond = u_xlat0.x<0.0; u_xlati0 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
#else
    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0u));
#endif
    u_xlati0 = (-u_xlati7) + u_xlati0;
    u_xlat0.x = float(u_xlati0);
    u_xlat0.xyz = u_xlat0.xxx * in_NORMAL0.xyz;
    u_xlat2.x = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
    u_xlat2.y = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
    u_xlat2.z = dot(u_xlat0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2 = u_xlat0.xxxx * u_xlat2.xyzz;
    u_xlat0.xyz = (-u_xlat1.xyz) + _WorldSpaceCameraPos.xyz;
    u_xlat3.x = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat3.x = inversesqrt(u_xlat3.x);
    u_xlat3.xyz = u_xlat0.xyz * u_xlat3.xxx;
    u_xlat3.x = dot(u_xlat2.xyw, u_xlat3.xyz);
    vs_TEXCOORD5.y = abs(u_xlat3.x) * u_xlat21 + u_xlat22;
    u_xlat3.xyz = in_TANGENT0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].yzx;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * in_TANGENT0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * in_TANGENT0.zzz + u_xlat3.xyz;
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat21) * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat2.wxy * u_xlat3.xyz;
    u_xlat4.xyz = u_xlat2.ywx * u_xlat3.yzx + (-u_xlat4.xyz);
    u_xlat21 = in_TANGENT0.w * unity_WorldTransformParams.w;
    u_xlat4.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    vs_TEXCOORD2.y = u_xlat4.x;
    vs_TEXCOORD2.z = u_xlat2.x;
    vs_TEXCOORD2.x = u_xlat3.z;
    vs_TEXCOORD2.w = u_xlat1.x;
    vs_TEXCOORD3.x = u_xlat3.x;
    vs_TEXCOORD4.x = u_xlat3.y;
    vs_TEXCOORD3.z = u_xlat2.y;
    vs_TEXCOORD3.y = u_xlat4.y;
    vs_TEXCOORD4.y = u_xlat4.z;
    vs_TEXCOORD3.w = u_xlat1.y;
    vs_TEXCOORD4.z = u_xlat2.w;
    vs_TEXCOORD4.w = u_xlat1.z;
    vs_COLOR0 = in_COLOR0;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4_EnvMatrix[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4_EnvMatrix[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    vs_TEXCOORD6.xyz = hlslcc_mtx4x4_EnvMatrix[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0 = (-u_xlat1.yyyy) + unity_4LightPosY0;
    u_xlat3 = u_xlat2.yyyy * u_xlat0;
    u_xlat0 = u_xlat0 * u_xlat0;
    u_xlat4 = (-u_xlat1.xxxx) + unity_4LightPosX0;
    u_xlat1 = (-u_xlat1.zzzz) + unity_4LightPosZ0;
    u_xlat3 = u_xlat4 * u_xlat2.xxxx + u_xlat3;
    u_xlat0 = u_xlat4 * u_xlat4 + u_xlat0;
    u_xlat0 = u_xlat1 * u_xlat1 + u_xlat0;
    u_xlat1 = u_xlat1 * u_xlat2.wwzw + u_xlat3;
    u_xlat0 = max(u_xlat0, vec4(9.99999997e-07, 9.99999997e-07, 9.99999997e-07, 9.99999997e-07));
    u_xlat3 = inversesqrt(u_xlat0);
    u_xlat0 = u_xlat0 * unity_4LightAtten0 + vec4(1.0, 1.0, 1.0, 1.0);
    u_xlat0 = vec4(1.0, 1.0, 1.0, 1.0) / u_xlat0;
    u_xlat1 = u_xlat1 * u_xlat3;
    u_xlat1 = max(u_xlat1, vec4(0.0, 0.0, 0.0, 0.0));
    u_xlat0 = u_xlat0 * u_xlat1;
    u_xlat1.xyz = u_xlat0.yyy * unity_LightColor[1].xyz;
    u_xlat1.xyz = unity_LightColor[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = unity_LightColor[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = unity_LightColor[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xyz = u_xlat0.xyz * vec3(0.305306017, 0.305306017, 0.305306017) + vec3(0.682171106, 0.682171106, 0.682171106);
    u_xlat1.xyz = u_xlat0.xyz * u_xlat1.xyz + vec3(0.0125228781, 0.0125228781, 0.0125228781);
    u_xlat16_5.x = u_xlat2.y * u_xlat2.y;
    u_xlat16_5.x = u_xlat2.x * u_xlat2.x + (-u_xlat16_5.x);
    u_xlat16_2 = u_xlat2.ywzx * u_xlat2;
    u_xlat16_6.x = dot(unity_SHBr, u_xlat16_2);
    u_xlat16_6.y = dot(unity_SHBg, u_xlat16_2);
    u_xlat16_6.z = dot(unity_SHBb, u_xlat16_2);
    u_xlat16_5.xyz = unity_SHC.xyz * u_xlat16_5.xxx + u_xlat16_6.xyz;
    vs_TEXCOORD7.xyz = u_xlat0.xyz * u_xlat1.xyz + u_xlat16_5.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _Time;
uniform 	mediump vec4 _WorldSpaceLightPos0;
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 _LightColor0;
uniform 	float _FaceUVSpeedX;
uniform 	float _FaceUVSpeedY;
uniform 	mediump vec4 _FaceColor;
uniform 	float _OutlineSoftness;
uniform 	float _OutlineUVSpeedX;
uniform 	float _OutlineUVSpeedY;
uniform 	mediump vec4 _OutlineColor;
uniform 	float _OutlineWidth;
uniform 	float _ScaleRatioA;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _FaceTex;
uniform lowp sampler2D _OutlineTex;
in highp vec4 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec2 vs_TEXCOORD5;
in highp vec4 vs_TEXCOORD2;
in highp vec4 vs_TEXCOORD3;
in highp vec4 vs_TEXCOORD4;
in mediump vec4 vs_COLOR0;
in mediump vec3 vs_TEXCOORD7;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec4 u_xlat16_1;
mediump vec4 u_xlat16_2;
float u_xlat3;
mediump vec3 u_xlat16_3;
lowp vec4 u_xlat10_3;
vec3 u_xlat4;
mediump vec4 u_xlat16_4;
mediump vec4 u_xlat16_5;
mediump vec4 u_xlat16_6;
float u_xlat7;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_9;
float u_xlat10;
mediump float u_xlat16_15;
vec2 u_xlat16;
float u_xlat24;
void main()
{
    u_xlat10_0.x = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0.x = (-u_xlat10_0.x) + 0.5;
    u_xlat0.x = u_xlat16_0.x + (-vs_TEXCOORD5.x);
    u_xlat0.x = u_xlat0.x * vs_TEXCOORD5.y + 0.5;
    u_xlat7 = _OutlineWidth * _ScaleRatioA;
    u_xlat7 = u_xlat7 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat7 * 0.5 + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = (-u_xlat7) * 0.5 + u_xlat0.x;
    u_xlat16_15 = min(u_xlat7, 1.0);
    u_xlat16_15 = sqrt(u_xlat16_15);
    u_xlat16_1.x = u_xlat16_15 * u_xlat16_1.x;
    u_xlat0.xy = vec2(_OutlineUVSpeedX, _OutlineUVSpeedY) * _Time.yy + vs_TEXCOORD1.xy;
    u_xlat10_0 = texture(_OutlineTex, u_xlat0.xy);
    u_xlat16_0.xyz = u_xlat10_0.xyz * _OutlineColor.xyz;
    u_xlat16_2.x = vs_COLOR0.w * _OutlineColor.w;
    u_xlat16_9 = u_xlat10_0.w * u_xlat16_2.x;
    u_xlat16.xy = vec2(_FaceUVSpeedX, _FaceUVSpeedY) * _Time.yy + vs_TEXCOORD0.zw;
    u_xlat10_3 = texture(_FaceTex, u_xlat16.xy);
    u_xlat16_4 = vs_COLOR0 * _FaceColor;
    u_xlat16_5 = u_xlat10_3 * u_xlat16_4;
    u_xlat16_6.xyz = u_xlat16_5.www * u_xlat16_5.xyz;
    u_xlat16_6.xyz = u_xlat16_0.xyz * vec3(u_xlat16_9) + (-u_xlat16_6.xyz);
    u_xlat16_6.w = u_xlat16_2.x * u_xlat10_0.w + (-u_xlat16_5.w);
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_6;
    u_xlat16_2.w = u_xlat16_4.w * u_xlat10_3.w + u_xlat16_0.w;
    u_xlat16_2.xyz = u_xlat16_5.xyz * u_xlat16_5.www + u_xlat16_0.xyz;
    u_xlat3 = _OutlineSoftness * _ScaleRatioA;
    u_xlat10 = u_xlat3 * vs_TEXCOORD5.y;
    u_xlat16_1.x = u_xlat3 * vs_TEXCOORD5.y + 1.0;
    u_xlat16_8.x = u_xlat10 * 0.5 + u_xlat16_8.x;
    u_xlat16_1.x = u_xlat16_8.x / u_xlat16_1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.x = min(max(u_xlat16_1.x, 0.0), 1.0);
#else
    u_xlat16_1.x = clamp(u_xlat16_1.x, 0.0, 1.0);
#endif
    u_xlat16_1.x = (-u_xlat16_1.x) + 1.0;
    u_xlat16_0 = u_xlat16_1.xxxx * u_xlat16_2;
    u_xlat16_3.x = max(u_xlat16_0.w, 9.99999975e-05);
    u_xlat16_3.xyz = u_xlat16_0.xyz / u_xlat16_3.xxx;
    SV_Target0.w = u_xlat16_0.w;
    u_xlat4.x = vs_TEXCOORD2.z;
    u_xlat4.y = vs_TEXCOORD3.z;
    u_xlat4.z = vs_TEXCOORD4.z;
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat16_1.x = dot(u_xlat0.xyz, _WorldSpaceLightPos0.xyz);
    u_xlat0.w = 1.0;
    u_xlat16_6.x = dot(unity_SHAr, u_xlat0);
    u_xlat16_6.y = dot(unity_SHAg, u_xlat0);
    u_xlat16_6.z = dot(unity_SHAb, u_xlat0);
    u_xlat16_1.yzw = u_xlat16_6.xyz + vs_TEXCOORD7.xyz;
    u_xlat16_1 = max(u_xlat16_1, vec4(0.0, 0.0, 0.0, 0.0));
    u_xlat16_4.xyz = log2(u_xlat16_1.yzw);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
    u_xlat16_4.xyz = exp2(u_xlat16_4.xyz);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_8.xyz = u_xlat16_3.xyz * u_xlat16_4.xyz;
    u_xlat16_6.xyz = u_xlat16_3.xyz * _LightColor0.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_1.xxx + u_xlat16_8.xyz;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
""
}
}
}
 Pass {
  Name "CASTER"
  LOD 300
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
  Cull Off
  Offset 1, 1
  GpuProgramID 87413
Program "vp" {
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_DEPTH" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _OutlineTex_ST;
uniform 	float _OutlineWidth;
uniform 	float _FaceDilate;
uniform 	float _ScaleRatioA;
in highp vec4 in_POSITION0;
in highp vec4 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD3;
out highp float vs_TEXCOORD2;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat1.x = unity_LightShadowBias.x / u_xlat0.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat4 = u_xlat0.z + u_xlat1.x;
    u_xlat1.x = max((-u_xlat0.w), u_xlat4);
    gl_Position.xyw = u_xlat0.xyw;
    u_xlat0.x = (-u_xlat4) + u_xlat1.x;
    gl_Position.z = unity_LightShadowBias.y * u_xlat0.x + u_xlat4;
    vs_TEXCOORD1.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD3.xy = in_TEXCOORD0.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    u_xlat0.x = (-_OutlineWidth) * _ScaleRatioA + 1.0;
    u_xlat0.x = (-_FaceDilate) * _ScaleRatioA + u_xlat0.x;
    vs_TEXCOORD2 = u_xlat0.x * 0.5;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in highp vec2 vs_TEXCOORD1;
in highp float vs_TEXCOORD2;
layout(location = 0) out highp vec4 SV_Target0;
float u_xlat0;
lowp float u_xlat10_0;
bool u_xlatb0;
void main()
{
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD1.xy).w;
    u_xlat0 = u_xlat10_0 + (-vs_TEXCOORD2);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0<0.0);
#else
    u_xlatb0 = u_xlat0<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_DEPTH" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _OutlineTex_ST;
uniform 	float _OutlineWidth;
uniform 	float _FaceDilate;
uniform 	float _ScaleRatioA;
in highp vec4 in_POSITION0;
in highp vec4 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD3;
out highp float vs_TEXCOORD2;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat1.x = unity_LightShadowBias.x / u_xlat0.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat4 = u_xlat0.z + u_xlat1.x;
    u_xlat1.x = max((-u_xlat0.w), u_xlat4);
    gl_Position.xyw = u_xlat0.xyw;
    u_xlat0.x = (-u_xlat4) + u_xlat1.x;
    gl_Position.z = unity_LightShadowBias.y * u_xlat0.x + u_xlat4;
    vs_TEXCOORD1.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD3.xy = in_TEXCOORD0.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    u_xlat0.x = (-_OutlineWidth) * _ScaleRatioA + 1.0;
    u_xlat0.x = (-_FaceDilate) * _ScaleRatioA + u_xlat0.x;
    vs_TEXCOORD2 = u_xlat0.x * 0.5;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in highp vec2 vs_TEXCOORD1;
in highp float vs_TEXCOORD2;
layout(location = 0) out highp vec4 SV_Target0;
float u_xlat0;
lowp float u_xlat10_0;
bool u_xlatb0;
void main()
{
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD1.xy).w;
    u_xlat0 = u_xlat10_0 + (-vs_TEXCOORD2);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0<0.0);
#else
    u_xlatb0 = u_xlat0<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_DEPTH" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _OutlineTex_ST;
uniform 	float _OutlineWidth;
uniform 	float _FaceDilate;
uniform 	float _ScaleRatioA;
in highp vec4 in_POSITION0;
in highp vec4 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD3;
out highp float vs_TEXCOORD2;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat1.x = unity_LightShadowBias.x / u_xlat0.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat4 = u_xlat0.z + u_xlat1.x;
    u_xlat1.x = max((-u_xlat0.w), u_xlat4);
    gl_Position.xyw = u_xlat0.xyw;
    u_xlat0.x = (-u_xlat4) + u_xlat1.x;
    gl_Position.z = unity_LightShadowBias.y * u_xlat0.x + u_xlat4;
    vs_TEXCOORD1.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD3.xy = in_TEXCOORD0.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    u_xlat0.x = (-_OutlineWidth) * _ScaleRatioA + 1.0;
    u_xlat0.x = (-_FaceDilate) * _ScaleRatioA + u_xlat0.x;
    vs_TEXCOORD2 = u_xlat0.x * 0.5;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in highp vec2 vs_TEXCOORD1;
in highp float vs_TEXCOORD2;
layout(location = 0) out highp vec4 SV_Target0;
float u_xlat0;
lowp float u_xlat10_0;
bool u_xlatb0;
void main()
{
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD1.xy).w;
    u_xlat0 = u_xlat10_0 + (-vs_TEXCOORD2);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0<0.0);
#else
    u_xlatb0 = u_xlat0<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_CUBE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _LightPositionRange;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _OutlineTex_ST;
uniform 	float _OutlineWidth;
uniform 	float _FaceDilate;
uniform 	float _ScaleRatioA;
in highp vec4 in_POSITION0;
in highp vec4 in_TEXCOORD0;
out highp vec3 vs_TEXCOORD0;
out highp float vs_TEXCOORD2;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat0.xyz;
    vs_TEXCOORD0.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
    u_xlat0.x = (-_OutlineWidth) * _ScaleRatioA + 1.0;
    u_xlat0.x = (-_FaceDilate) * _ScaleRatioA + u_xlat0.x;
    vs_TEXCOORD2 = u_xlat0.x * 0.5;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    vs_TEXCOORD1.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD3.xy = in_TEXCOORD0.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_LightShadowBias;
uniform lowp sampler2D _MainTex;
in highp vec3 vs_TEXCOORD0;
in highp float vs_TEXCOORD2;
in highp vec2 vs_TEXCOORD1;
layout(location = 0) out highp vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
bool u_xlatb0;
void main()
{
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD1.xy).w;
    u_xlat0.x = u_xlat10_0 + (-vs_TEXCOORD2);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0.x<0.0);
#else
    u_xlatb0 = u_xlat0.x<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    u_xlat0.x = dot(vs_TEXCOORD0.xyz, vs_TEXCOORD0.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = u_xlat0.x + unity_LightShadowBias.x;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = min(u_xlat0.x, 0.999000013);
    u_xlat0 = u_xlat0.xxxx * vec4(1.0, 255.0, 65025.0, 16581375.0);
    u_xlat0 = fract(u_xlat0);
    SV_Target0 = (-u_xlat0.yzww) * vec4(0.00392156886, 0.00392156886, 0.00392156886, 0.00392156886) + u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_CUBE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _LightPositionRange;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _OutlineTex_ST;
uniform 	float _OutlineWidth;
uniform 	float _FaceDilate;
uniform 	float _ScaleRatioA;
in highp vec4 in_POSITION0;
in highp vec4 in_TEXCOORD0;
out highp vec3 vs_TEXCOORD0;
out highp float vs_TEXCOORD2;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat0.xyz;
    vs_TEXCOORD0.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
    u_xlat0.x = (-_OutlineWidth) * _ScaleRatioA + 1.0;
    u_xlat0.x = (-_FaceDilate) * _ScaleRatioA + u_xlat0.x;
    vs_TEXCOORD2 = u_xlat0.x * 0.5;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    vs_TEXCOORD1.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD3.xy = in_TEXCOORD0.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_LightShadowBias;
uniform lowp sampler2D _MainTex;
in highp vec3 vs_TEXCOORD0;
in highp float vs_TEXCOORD2;
in highp vec2 vs_TEXCOORD1;
layout(location = 0) out highp vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
bool u_xlatb0;
void main()
{
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD1.xy).w;
    u_xlat0.x = u_xlat10_0 + (-vs_TEXCOORD2);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0.x<0.0);
#else
    u_xlatb0 = u_xlat0.x<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    u_xlat0.x = dot(vs_TEXCOORD0.xyz, vs_TEXCOORD0.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = u_xlat0.x + unity_LightShadowBias.x;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = min(u_xlat0.x, 0.999000013);
    u_xlat0 = u_xlat0.xxxx * vec4(1.0, 255.0, 65025.0, 16581375.0);
    u_xlat0 = fract(u_xlat0);
    SV_Target0 = (-u_xlat0.yzww) * vec4(0.00392156886, 0.00392156886, 0.00392156886, 0.00392156886) + u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_CUBE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _LightPositionRange;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 _OutlineTex_ST;
uniform 	float _OutlineWidth;
uniform 	float _FaceDilate;
uniform 	float _ScaleRatioA;
in highp vec4 in_POSITION0;
in highp vec4 in_TEXCOORD0;
out highp vec3 vs_TEXCOORD0;
out highp float vs_TEXCOORD2;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat0.xyz;
    vs_TEXCOORD0.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
    u_xlat0.x = (-_OutlineWidth) * _ScaleRatioA + 1.0;
    u_xlat0.x = (-_FaceDilate) * _ScaleRatioA + u_xlat0.x;
    vs_TEXCOORD2 = u_xlat0.x * 0.5;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    vs_TEXCOORD1.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD3.xy = in_TEXCOORD0.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_LightShadowBias;
uniform lowp sampler2D _MainTex;
in highp vec3 vs_TEXCOORD0;
in highp float vs_TEXCOORD2;
in highp vec2 vs_TEXCOORD1;
layout(location = 0) out highp vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
bool u_xlatb0;
void main()
{
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD1.xy).w;
    u_xlat0.x = u_xlat10_0 + (-vs_TEXCOORD2);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0.x<0.0);
#else
    u_xlatb0 = u_xlat0.x<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    u_xlat0.x = dot(vs_TEXCOORD0.xyz, vs_TEXCOORD0.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = u_xlat0.x + unity_LightShadowBias.x;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = min(u_xlat0.x, 0.999000013);
    u_xlat0 = u_xlat0.xxxx * vec4(1.0, 255.0, 65025.0, 16581375.0);
    u_xlat0 = fract(u_xlat0);
    SV_Target0 = (-u_xlat0.yzww) * vec4(0.00392156886, 0.00392156886, 0.00392156886, 0.00392156886) + u_xlat0;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_CUBE" }
""
}
}
}
}
CustomEditor "TMPro.EditorUtilities.TMP_SDFShaderGUI"
}