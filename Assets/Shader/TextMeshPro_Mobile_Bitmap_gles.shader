Shader "TextMeshPro/Mobile/Bitmap" {
Properties {
_MainTex ("Font Atlas", 2D) = "white" { }
_Color ("Text Color", Color) = (1,1,1,1)
_DiffusePower ("Diffuse Power", Range(1, 4)) = 1
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
  GpuProgramID 41577
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ScreenParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
uniform highp float _DiffusePower;
uniform highp float _VertexOffsetX;
uniform highp float _VertexOffsetY;
uniform highp vec4 _ClipRect;
uniform highp float _MaskSoftnessX;
uniform highp float _MaskSoftnessY;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 vert_1;
  lowp vec4 tmpvar_2;
  vert_1.zw = _glesVertex.zw;
  vert_1.x = (_glesVertex.x + _VertexOffsetX);
  vert_1.y = (_glesVertex.y + _VertexOffsetY);
  vert_1.xy = (vert_1.xy + ((_glesVertex.w * 0.5) / _ScreenParams.xy));
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = vert_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 pos_5;
  pos_5.zw = tmpvar_3.zw;
  highp vec2 tmpvar_6;
  tmpvar_6 = (_ScreenParams.xy * 0.5);
  pos_5.xy = ((floor(
    (((tmpvar_3.xy / tmpvar_3.w) * tmpvar_6) + vec2(0.5, 0.5))
  ) / tmpvar_6) * tmpvar_3.w);
  tmpvar_2 = (_glesColor * _Color);
  tmpvar_2.xyz = (tmpvar_2.xyz * _DiffusePower);
  highp vec4 tmpvar_7;
  tmpvar_7 = clamp (_ClipRect, vec4(-2e+10, -2e+10, -2e+10, -2e+10), vec4(2e+10, 2e+10, 2e+10, 2e+10));
  highp vec2 tmpvar_8;
  tmpvar_8.x = _MaskSoftnessX;
  tmpvar_8.y = _MaskSoftnessY;
  highp vec4 tmpvar_9;
  tmpvar_9.xy = (((vert_1.xy * 2.0) - tmpvar_7.xy) - tmpvar_7.zw);
  tmpvar_9.zw = (0.25 / ((0.25 * tmpvar_8) + tmpvar_3.ww));
  gl_Position = pos_5;
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD2 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform highp vec4 _ClipRect;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.xyz = xlv_COLOR.xyz;
  tmpvar_2.w = (xlv_COLOR.w * texture2D (_MainTex, xlv_TEXCOORD0).w);
  mediump vec2 tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = clamp (((
    (_ClipRect.zw - _ClipRect.xy)
   - 
    abs(xlv_TEXCOORD2.xy)
  ) * xlv_TEXCOORD2.zw), 0.0, 1.0);
  tmpvar_3 = tmpvar_4;
  c_1 = (tmpvar_2 * (tmpvar_3.x * tmpvar_3.y));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ScreenParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
uniform highp float _DiffusePower;
uniform highp float _VertexOffsetX;
uniform highp float _VertexOffsetY;
uniform highp vec4 _ClipRect;
uniform highp float _MaskSoftnessX;
uniform highp float _MaskSoftnessY;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 vert_1;
  lowp vec4 tmpvar_2;
  vert_1.zw = _glesVertex.zw;
  vert_1.x = (_glesVertex.x + _VertexOffsetX);
  vert_1.y = (_glesVertex.y + _VertexOffsetY);
  vert_1.xy = (vert_1.xy + ((_glesVertex.w * 0.5) / _ScreenParams.xy));
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = vert_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 pos_5;
  pos_5.zw = tmpvar_3.zw;
  highp vec2 tmpvar_6;
  tmpvar_6 = (_ScreenParams.xy * 0.5);
  pos_5.xy = ((floor(
    (((tmpvar_3.xy / tmpvar_3.w) * tmpvar_6) + vec2(0.5, 0.5))
  ) / tmpvar_6) * tmpvar_3.w);
  tmpvar_2 = (_glesColor * _Color);
  tmpvar_2.xyz = (tmpvar_2.xyz * _DiffusePower);
  highp vec4 tmpvar_7;
  tmpvar_7 = clamp (_ClipRect, vec4(-2e+10, -2e+10, -2e+10, -2e+10), vec4(2e+10, 2e+10, 2e+10, 2e+10));
  highp vec2 tmpvar_8;
  tmpvar_8.x = _MaskSoftnessX;
  tmpvar_8.y = _MaskSoftnessY;
  highp vec4 tmpvar_9;
  tmpvar_9.xy = (((vert_1.xy * 2.0) - tmpvar_7.xy) - tmpvar_7.zw);
  tmpvar_9.zw = (0.25 / ((0.25 * tmpvar_8) + tmpvar_3.ww));
  gl_Position = pos_5;
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD2 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform highp vec4 _ClipRect;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.xyz = xlv_COLOR.xyz;
  tmpvar_2.w = (xlv_COLOR.w * texture2D (_MainTex, xlv_TEXCOORD0).w);
  mediump vec2 tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = clamp (((
    (_ClipRect.zw - _ClipRect.xy)
   - 
    abs(xlv_TEXCOORD2.xy)
  ) * xlv_TEXCOORD2.zw), 0.0, 1.0);
  tmpvar_3 = tmpvar_4;
  c_1 = (tmpvar_2 * (tmpvar_3.x * tmpvar_3.y));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ScreenParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
uniform highp float _DiffusePower;
uniform highp float _VertexOffsetX;
uniform highp float _VertexOffsetY;
uniform highp vec4 _ClipRect;
uniform highp float _MaskSoftnessX;
uniform highp float _MaskSoftnessY;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 vert_1;
  lowp vec4 tmpvar_2;
  vert_1.zw = _glesVertex.zw;
  vert_1.x = (_glesVertex.x + _VertexOffsetX);
  vert_1.y = (_glesVertex.y + _VertexOffsetY);
  vert_1.xy = (vert_1.xy + ((_glesVertex.w * 0.5) / _ScreenParams.xy));
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = vert_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 pos_5;
  pos_5.zw = tmpvar_3.zw;
  highp vec2 tmpvar_6;
  tmpvar_6 = (_ScreenParams.xy * 0.5);
  pos_5.xy = ((floor(
    (((tmpvar_3.xy / tmpvar_3.w) * tmpvar_6) + vec2(0.5, 0.5))
  ) / tmpvar_6) * tmpvar_3.w);
  tmpvar_2 = (_glesColor * _Color);
  tmpvar_2.xyz = (tmpvar_2.xyz * _DiffusePower);
  highp vec4 tmpvar_7;
  tmpvar_7 = clamp (_ClipRect, vec4(-2e+10, -2e+10, -2e+10, -2e+10), vec4(2e+10, 2e+10, 2e+10, 2e+10));
  highp vec2 tmpvar_8;
  tmpvar_8.x = _MaskSoftnessX;
  tmpvar_8.y = _MaskSoftnessY;
  highp vec4 tmpvar_9;
  tmpvar_9.xy = (((vert_1.xy * 2.0) - tmpvar_7.xy) - tmpvar_7.zw);
  tmpvar_9.zw = (0.25 / ((0.25 * tmpvar_8) + tmpvar_3.ww));
  gl_Position = pos_5;
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD2 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform highp vec4 _ClipRect;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.xyz = xlv_COLOR.xyz;
  tmpvar_2.w = (xlv_COLOR.w * texture2D (_MainTex, xlv_TEXCOORD0).w);
  mediump vec2 tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = clamp (((
    (_ClipRect.zw - _ClipRect.xy)
   - 
    abs(xlv_TEXCOORD2.xy)
  ) * xlv_TEXCOORD2.zw), 0.0, 1.0);
  tmpvar_3 = tmpvar_4;
  c_1 = (tmpvar_2 * (tmpvar_3.x * tmpvar_3.y));
  gl_FragData[0] = c_1;
}


#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
""
}
SubProgram "gles hw_tier01 " {
""
}
SubProgram "gles hw_tier02 " {
""
}
}
}
}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 117148
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 tmpvar_2;
  tmpvar_2 = clamp (_glesColor, 0.0, 1.0);
  tmpvar_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  xlv_COLOR0 = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 col_1;
  col_1.xyz = (_Color * xlv_COLOR0).xyz;
  col_1.w = (_Color.w * texture2D (_MainTex, xlv_TEXCOORD0).w);
  gl_FragData[0] = col_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 tmpvar_2;
  tmpvar_2 = clamp (_glesColor, 0.0, 1.0);
  tmpvar_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  xlv_COLOR0 = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 col_1;
  col_1.xyz = (_Color * xlv_COLOR0).xyz;
  col_1.w = (_Color.w * texture2D (_MainTex, xlv_TEXCOORD0).w);
  gl_FragData[0] = col_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 tmpvar_2;
  tmpvar_2 = clamp (_glesColor, 0.0, 1.0);
  tmpvar_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  xlv_COLOR0 = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 col_1;
  col_1.xyz = (_Color * xlv_COLOR0).xyz;
  col_1.w = (_Color.w * texture2D (_MainTex, xlv_TEXCOORD0).w);
  gl_FragData[0] = col_1;
}


#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
""
}
SubProgram "gles hw_tier01 " {
""
}
SubProgram "gles hw_tier02 " {
""
}
}
}
}
CustomEditor "TMPro.EditorUtilities.TMP_BitmapShaderGUI"
}