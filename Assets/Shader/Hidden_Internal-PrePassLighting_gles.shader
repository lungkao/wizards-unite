Shader "Hidden/Internal-PrePassLighting" {
Properties {
_LightTexture0 ("", any) = "" { }
_LightTextureB0 ("", 2D) = "" { }
_ShadowMapTexture ("", any) = "" { }
}
SubShader {
 Pass {
  Tags { "SHADOWSUPPORT" = "true" }
  ZWrite Off
  GpuProgramID 60282
Program "vp" {
SubProgram "gles hw_tier00 " {
Keywords { "POINT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_14 = texture2D (_CameraNormalsTexture, P_15);
  nspec_5 = tmpvar_14;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow (max (0.0, dot (h_4, tmpvar_16)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_18;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_16)
  ) * atten_6));
  mediump vec3 rgb_19;
  rgb_19 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_19, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_20;
  tmpvar_20 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_20);
  mediump vec4 tmpvar_21;
  tmpvar_21 = exp2(-(res_2));
  tmpvar_1 = tmpvar_21;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_14 = texture2D (_CameraNormalsTexture, P_15);
  nspec_5 = tmpvar_14;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow (max (0.0, dot (h_4, tmpvar_16)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_18;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_16)
  ) * atten_6));
  mediump vec3 rgb_19;
  rgb_19 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_19, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_20;
  tmpvar_20 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_20);
  mediump vec4 tmpvar_21;
  tmpvar_21 = exp2(-(res_2));
  tmpvar_1 = tmpvar_21;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_14 = texture2D (_CameraNormalsTexture, P_15);
  nspec_5 = tmpvar_14;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow (max (0.0, dot (h_4, tmpvar_16)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_18;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_16)
  ) * atten_6));
  mediump vec3 rgb_19;
  rgb_19 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_19, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_20;
  tmpvar_20 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_20);
  mediump vec4 tmpvar_21;
  tmpvar_21 = exp2(-(res_2));
  tmpvar_1 = tmpvar_21;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  mediump vec4 tmpvar_19;
  tmpvar_19 = exp2(-(res_2));
  tmpvar_1 = tmpvar_19;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  mediump vec4 tmpvar_19;
  tmpvar_19 = exp2(-(res_2));
  tmpvar_1 = tmpvar_19;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  mediump vec4 tmpvar_19;
  tmpvar_19 = exp2(-(res_2));
  tmpvar_1 = tmpvar_19;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w);
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(res_2));
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w);
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(res_2));
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w);
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(res_2));
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_15.xyz, -8.0).w);
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23 = exp2(-(res_2));
  tmpvar_1 = tmpvar_23;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_15.xyz, -8.0).w);
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23 = exp2(-(res_2));
  tmpvar_1 = tmpvar_23;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_15.xyz, -8.0).w);
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23 = exp2(-(res_2));
  tmpvar_1 = tmpvar_23;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w;
  lowp vec4 tmpvar_15;
  highp vec2 P_16;
  P_16 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_15 = texture2D (_CameraNormalsTexture, P_16);
  nspec_5 = tmpvar_15;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.0, dot (h_4, tmpvar_17)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_19;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_17)
  ) * atten_6));
  mediump vec3 rgb_20;
  rgb_20 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_20, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_21;
  tmpvar_21 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22 = exp2(-(res_2));
  tmpvar_1 = tmpvar_22;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w;
  lowp vec4 tmpvar_15;
  highp vec2 P_16;
  P_16 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_15 = texture2D (_CameraNormalsTexture, P_16);
  nspec_5 = tmpvar_15;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.0, dot (h_4, tmpvar_17)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_19;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_17)
  ) * atten_6));
  mediump vec3 rgb_20;
  rgb_20 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_20, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_21;
  tmpvar_21 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22 = exp2(-(res_2));
  tmpvar_1 = tmpvar_22;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w;
  lowp vec4 tmpvar_15;
  highp vec2 P_16;
  P_16 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_15 = texture2D (_CameraNormalsTexture, P_16);
  nspec_5 = tmpvar_15;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.0, dot (h_4, tmpvar_17)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_19;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_17)
  ) * atten_6));
  mediump vec3 rgb_20;
  rgb_20 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_20, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_21;
  tmpvar_21 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22 = exp2(-(res_2));
  tmpvar_1 = tmpvar_22;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  if ((tmpvar_24.x < (tmpvar_22.z / tmpvar_22.w))) {
    tmpvar_25 = _LightShadowData.x;
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_23 = tmpvar_25;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_26;
  tmpvar_26 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  if ((tmpvar_24.x < (tmpvar_22.z / tmpvar_22.w))) {
    tmpvar_25 = _LightShadowData.x;
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_23 = tmpvar_25;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_26;
  tmpvar_26 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  if ((tmpvar_24.x < (tmpvar_22.z / tmpvar_22.w))) {
    tmpvar_25 = _LightShadowData.x;
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_23 = tmpvar_25;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_26;
  tmpvar_26 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 shadowVals_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  shadowVals_24.x = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_24.y = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_24.z = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_24.w = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_26;
  tmpvar_26 = lessThan (shadowVals_24, tmpvar_25.zzzz);
  mediump vec4 tmpvar_27;
  tmpvar_27 = _LightShadowData.xxxx;
  mediump float tmpvar_28;
  if (tmpvar_26.x) {
    tmpvar_28 = tmpvar_27.x;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_26.y) {
    tmpvar_29 = tmpvar_27.y;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_26.z) {
    tmpvar_30 = tmpvar_27.z;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_26.w) {
    tmpvar_31 = tmpvar_27.w;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump vec4 tmpvar_32;
  tmpvar_32.x = tmpvar_28;
  tmpvar_32.y = tmpvar_29;
  tmpvar_32.z = tmpvar_30;
  tmpvar_32.w = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = dot (tmpvar_32, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_33;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_34);
  lowp vec4 tmpvar_35;
  highp vec2 P_36;
  P_36 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_35 = texture2D (_CameraNormalsTexture, P_36);
  nspec_5 = tmpvar_35;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_39;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_37)
  ) * atten_6));
  mediump vec3 rgb_40;
  rgb_40 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_40, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_41;
  tmpvar_41 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_41);
  mediump vec4 tmpvar_42;
  tmpvar_42 = exp2(-(res_2));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 shadowVals_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  shadowVals_24.x = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_24.y = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_24.z = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_24.w = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_26;
  tmpvar_26 = lessThan (shadowVals_24, tmpvar_25.zzzz);
  mediump vec4 tmpvar_27;
  tmpvar_27 = _LightShadowData.xxxx;
  mediump float tmpvar_28;
  if (tmpvar_26.x) {
    tmpvar_28 = tmpvar_27.x;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_26.y) {
    tmpvar_29 = tmpvar_27.y;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_26.z) {
    tmpvar_30 = tmpvar_27.z;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_26.w) {
    tmpvar_31 = tmpvar_27.w;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump vec4 tmpvar_32;
  tmpvar_32.x = tmpvar_28;
  tmpvar_32.y = tmpvar_29;
  tmpvar_32.z = tmpvar_30;
  tmpvar_32.w = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = dot (tmpvar_32, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_33;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_34);
  lowp vec4 tmpvar_35;
  highp vec2 P_36;
  P_36 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_35 = texture2D (_CameraNormalsTexture, P_36);
  nspec_5 = tmpvar_35;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_39;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_37)
  ) * atten_6));
  mediump vec3 rgb_40;
  rgb_40 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_40, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_41;
  tmpvar_41 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_41);
  mediump vec4 tmpvar_42;
  tmpvar_42 = exp2(-(res_2));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 shadowVals_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  shadowVals_24.x = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_24.y = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_24.z = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_24.w = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_26;
  tmpvar_26 = lessThan (shadowVals_24, tmpvar_25.zzzz);
  mediump vec4 tmpvar_27;
  tmpvar_27 = _LightShadowData.xxxx;
  mediump float tmpvar_28;
  if (tmpvar_26.x) {
    tmpvar_28 = tmpvar_27.x;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_26.y) {
    tmpvar_29 = tmpvar_27.y;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_26.z) {
    tmpvar_30 = tmpvar_27.z;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_26.w) {
    tmpvar_31 = tmpvar_27.w;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump vec4 tmpvar_32;
  tmpvar_32.x = tmpvar_28;
  tmpvar_32.y = tmpvar_29;
  tmpvar_32.z = tmpvar_30;
  tmpvar_32.w = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = dot (tmpvar_32, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_33;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_34);
  lowp vec4 tmpvar_35;
  highp vec2 P_36;
  P_36 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_35 = texture2D (_CameraNormalsTexture, P_36);
  nspec_5 = tmpvar_35;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_39;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_37)
  ) * atten_6));
  mediump vec3 rgb_40;
  rgb_40 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_40, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_41;
  tmpvar_41 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_41);
  mediump vec4 tmpvar_42;
  tmpvar_42 = exp2(-(res_2));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  mediump vec4 tmpvar_26;
  tmpvar_26 = exp2(-(res_2));
  tmpvar_1 = tmpvar_26;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  mediump vec4 tmpvar_26;
  tmpvar_26 = exp2(-(res_2));
  tmpvar_1 = tmpvar_26;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  mediump vec4 tmpvar_26;
  tmpvar_26 = exp2(-(res_2));
  tmpvar_1 = tmpvar_26;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_10;
  highp vec4 tmpvar_20;
  tmpvar_20.zw = vec2(0.0, -8.0);
  tmpvar_20.xy = (unity_WorldToLight * tmpvar_19).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_20.xy, -8.0).w);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28 = exp2(-(res_2));
  tmpvar_1 = tmpvar_28;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_10;
  highp vec4 tmpvar_20;
  tmpvar_20.zw = vec2(0.0, -8.0);
  tmpvar_20.xy = (unity_WorldToLight * tmpvar_19).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_20.xy, -8.0).w);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28 = exp2(-(res_2));
  tmpvar_1 = tmpvar_28;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_10;
  highp vec4 tmpvar_20;
  tmpvar_20.zw = vec2(0.0, -8.0);
  tmpvar_20.xy = (unity_WorldToLight * tmpvar_19).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_20.xy, -8.0).w);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28 = exp2(-(res_2));
  tmpvar_1 = tmpvar_28;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  lowp vec4 tmpvar_25;
  highp vec2 P_26;
  P_26 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_25 = texture2D (_CameraNormalsTexture, P_26);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_27)
  ) * atten_6));
  mediump vec3 rgb_30;
  rgb_30 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_30, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_31);
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(res_2));
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  lowp vec4 tmpvar_25;
  highp vec2 P_26;
  P_26 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_25 = texture2D (_CameraNormalsTexture, P_26);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_27)
  ) * atten_6));
  mediump vec3 rgb_30;
  rgb_30 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_30, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_31);
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(res_2));
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  lowp vec4 tmpvar_25;
  highp vec2 P_26;
  P_26 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_25 = texture2D (_CameraNormalsTexture, P_26);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_27)
  ) * atten_6));
  mediump vec3 rgb_30;
  rgb_30 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_30, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_31);
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(res_2));
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  lowp vec4 tmpvar_40;
  highp vec2 P_41;
  P_41 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_40 = texture2D (_CameraNormalsTexture, P_41);
  nspec_5 = tmpvar_40;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = pow (max (0.0, dot (h_4, tmpvar_42)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_44;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_42)
  ) * atten_6));
  mediump vec3 rgb_45;
  rgb_45 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_45, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_46);
  mediump vec4 tmpvar_47;
  tmpvar_47 = exp2(-(res_2));
  tmpvar_1 = tmpvar_47;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  lowp vec4 tmpvar_40;
  highp vec2 P_41;
  P_41 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_40 = texture2D (_CameraNormalsTexture, P_41);
  nspec_5 = tmpvar_40;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = pow (max (0.0, dot (h_4, tmpvar_42)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_44;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_42)
  ) * atten_6));
  mediump vec3 rgb_45;
  rgb_45 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_45, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_46);
  mediump vec4 tmpvar_47;
  tmpvar_47 = exp2(-(res_2));
  tmpvar_1 = tmpvar_47;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  lowp vec4 tmpvar_40;
  highp vec2 P_41;
  P_41 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_40 = texture2D (_CameraNormalsTexture, P_41);
  nspec_5 = tmpvar_40;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = pow (max (0.0, dot (h_4, tmpvar_42)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_44;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_42)
  ) * atten_6));
  mediump vec3 rgb_45;
  rgb_45 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_45, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_46);
  mediump vec4 tmpvar_47;
  tmpvar_47 = exp2(-(res_2));
  tmpvar_1 = tmpvar_47;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_26.xyz, -8.0).w);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_26.xyz, -8.0).w);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_26.xyz, -8.0).w);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  highp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_10;
  highp vec4 tmpvar_41;
  tmpvar_41.w = -8.0;
  tmpvar_41.xyz = (unity_WorldToLight * tmpvar_40).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_41.xyz, -8.0).w);
  lowp vec4 tmpvar_42;
  highp vec2 P_43;
  P_43 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_42 = texture2D (_CameraNormalsTexture, P_43);
  nspec_5 = tmpvar_42;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = pow (max (0.0, dot (h_4, tmpvar_44)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_46;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_44)
  ) * atten_6));
  mediump vec3 rgb_47;
  rgb_47 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_47, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_48);
  mediump vec4 tmpvar_49;
  tmpvar_49 = exp2(-(res_2));
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  highp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_10;
  highp vec4 tmpvar_41;
  tmpvar_41.w = -8.0;
  tmpvar_41.xyz = (unity_WorldToLight * tmpvar_40).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_41.xyz, -8.0).w);
  lowp vec4 tmpvar_42;
  highp vec2 P_43;
  P_43 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_42 = texture2D (_CameraNormalsTexture, P_43);
  nspec_5 = tmpvar_42;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = pow (max (0.0, dot (h_4, tmpvar_44)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_46;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_44)
  ) * atten_6));
  mediump vec3 rgb_47;
  rgb_47 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_47, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_48);
  mediump vec4 tmpvar_49;
  tmpvar_49 = exp2(-(res_2));
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  highp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_10;
  highp vec4 tmpvar_41;
  tmpvar_41.w = -8.0;
  tmpvar_41.xyz = (unity_WorldToLight * tmpvar_40).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_41.xyz, -8.0).w);
  lowp vec4 tmpvar_42;
  highp vec2 P_43;
  P_43 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_42 = texture2D (_CameraNormalsTexture, P_43);
  nspec_5 = tmpvar_42;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = pow (max (0.0, dot (h_4, tmpvar_44)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_46;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_44)
  ) * atten_6));
  mediump vec3 rgb_47;
  rgb_47 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_47, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_48);
  mediump vec4 tmpvar_49;
  tmpvar_49 = exp2(-(res_2));
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
}
}
 Pass {
  Tags { "SHADOWSUPPORT" = "true" }
  ZWrite Off
  GpuProgramID 127399
Program "vp" {
SubProgram "gles hw_tier00 " {
Keywords { "POINT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_14 = texture2D (_CameraNormalsTexture, P_15);
  nspec_5 = tmpvar_14;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow (max (0.0, dot (h_4, tmpvar_16)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_18;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_16)
  ) * atten_6));
  mediump vec3 rgb_19;
  rgb_19 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_19, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_20;
  tmpvar_20 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_20);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_14 = texture2D (_CameraNormalsTexture, P_15);
  nspec_5 = tmpvar_14;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow (max (0.0, dot (h_4, tmpvar_16)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_18;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_16)
  ) * atten_6));
  mediump vec3 rgb_19;
  rgb_19 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_19, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_20;
  tmpvar_20 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_20);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_14 = texture2D (_CameraNormalsTexture, P_15);
  nspec_5 = tmpvar_14;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow (max (0.0, dot (h_4, tmpvar_16)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_18;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_16)
  ) * atten_6));
  mediump vec3 rgb_19;
  rgb_19 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_19, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_20;
  tmpvar_20 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_20);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w);
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w);
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w);
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_15.xyz, -8.0).w);
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_15.xyz, -8.0).w);
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_15.xyz, -8.0).w);
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w;
  lowp vec4 tmpvar_15;
  highp vec2 P_16;
  P_16 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_15 = texture2D (_CameraNormalsTexture, P_16);
  nspec_5 = tmpvar_15;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.0, dot (h_4, tmpvar_17)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_19;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_17)
  ) * atten_6));
  mediump vec3 rgb_20;
  rgb_20 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_20, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_21;
  tmpvar_21 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_21);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w;
  lowp vec4 tmpvar_15;
  highp vec2 P_16;
  P_16 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_15 = texture2D (_CameraNormalsTexture, P_16);
  nspec_5 = tmpvar_15;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.0, dot (h_4, tmpvar_17)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_19;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_17)
  ) * atten_6));
  mediump vec3 rgb_20;
  rgb_20 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_20, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_21;
  tmpvar_21 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_21);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w;
  lowp vec4 tmpvar_15;
  highp vec2 P_16;
  P_16 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_15 = texture2D (_CameraNormalsTexture, P_16);
  nspec_5 = tmpvar_15;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.0, dot (h_4, tmpvar_17)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_19;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_17)
  ) * atten_6));
  mediump vec3 rgb_20;
  rgb_20 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_20, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_21;
  tmpvar_21 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_21);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  if ((tmpvar_24.x < (tmpvar_22.z / tmpvar_22.w))) {
    tmpvar_25 = _LightShadowData.x;
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_23 = tmpvar_25;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_26;
  tmpvar_26 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  if ((tmpvar_24.x < (tmpvar_22.z / tmpvar_22.w))) {
    tmpvar_25 = _LightShadowData.x;
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_23 = tmpvar_25;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_26;
  tmpvar_26 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  if ((tmpvar_24.x < (tmpvar_22.z / tmpvar_22.w))) {
    tmpvar_25 = _LightShadowData.x;
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_23 = tmpvar_25;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_26;
  tmpvar_26 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 shadowVals_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  shadowVals_24.x = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_24.y = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_24.z = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_24.w = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_26;
  tmpvar_26 = lessThan (shadowVals_24, tmpvar_25.zzzz);
  mediump vec4 tmpvar_27;
  tmpvar_27 = _LightShadowData.xxxx;
  mediump float tmpvar_28;
  if (tmpvar_26.x) {
    tmpvar_28 = tmpvar_27.x;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_26.y) {
    tmpvar_29 = tmpvar_27.y;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_26.z) {
    tmpvar_30 = tmpvar_27.z;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_26.w) {
    tmpvar_31 = tmpvar_27.w;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump vec4 tmpvar_32;
  tmpvar_32.x = tmpvar_28;
  tmpvar_32.y = tmpvar_29;
  tmpvar_32.z = tmpvar_30;
  tmpvar_32.w = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = dot (tmpvar_32, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_33;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_34);
  lowp vec4 tmpvar_35;
  highp vec2 P_36;
  P_36 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_35 = texture2D (_CameraNormalsTexture, P_36);
  nspec_5 = tmpvar_35;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_39;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_37)
  ) * atten_6));
  mediump vec3 rgb_40;
  rgb_40 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_40, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_41;
  tmpvar_41 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_41);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 shadowVals_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  shadowVals_24.x = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_24.y = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_24.z = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_24.w = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_26;
  tmpvar_26 = lessThan (shadowVals_24, tmpvar_25.zzzz);
  mediump vec4 tmpvar_27;
  tmpvar_27 = _LightShadowData.xxxx;
  mediump float tmpvar_28;
  if (tmpvar_26.x) {
    tmpvar_28 = tmpvar_27.x;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_26.y) {
    tmpvar_29 = tmpvar_27.y;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_26.z) {
    tmpvar_30 = tmpvar_27.z;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_26.w) {
    tmpvar_31 = tmpvar_27.w;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump vec4 tmpvar_32;
  tmpvar_32.x = tmpvar_28;
  tmpvar_32.y = tmpvar_29;
  tmpvar_32.z = tmpvar_30;
  tmpvar_32.w = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = dot (tmpvar_32, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_33;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_34);
  lowp vec4 tmpvar_35;
  highp vec2 P_36;
  P_36 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_35 = texture2D (_CameraNormalsTexture, P_36);
  nspec_5 = tmpvar_35;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_39;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_37)
  ) * atten_6));
  mediump vec3 rgb_40;
  rgb_40 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_40, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_41;
  tmpvar_41 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_41);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 shadowVals_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  shadowVals_24.x = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_24.y = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_24.z = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_24.w = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_26;
  tmpvar_26 = lessThan (shadowVals_24, tmpvar_25.zzzz);
  mediump vec4 tmpvar_27;
  tmpvar_27 = _LightShadowData.xxxx;
  mediump float tmpvar_28;
  if (tmpvar_26.x) {
    tmpvar_28 = tmpvar_27.x;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_26.y) {
    tmpvar_29 = tmpvar_27.y;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_26.z) {
    tmpvar_30 = tmpvar_27.z;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_26.w) {
    tmpvar_31 = tmpvar_27.w;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump vec4 tmpvar_32;
  tmpvar_32.x = tmpvar_28;
  tmpvar_32.y = tmpvar_29;
  tmpvar_32.z = tmpvar_30;
  tmpvar_32.w = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = dot (tmpvar_32, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_33;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_34);
  lowp vec4 tmpvar_35;
  highp vec2 P_36;
  P_36 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_35 = texture2D (_CameraNormalsTexture, P_36);
  nspec_5 = tmpvar_35;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_39;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_37)
  ) * atten_6));
  mediump vec3 rgb_40;
  rgb_40 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_40, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_41;
  tmpvar_41 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_41);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_10;
  highp vec4 tmpvar_20;
  tmpvar_20.zw = vec2(0.0, -8.0);
  tmpvar_20.xy = (unity_WorldToLight * tmpvar_19).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_20.xy, -8.0).w);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_10;
  highp vec4 tmpvar_20;
  tmpvar_20.zw = vec2(0.0, -8.0);
  tmpvar_20.xy = (unity_WorldToLight * tmpvar_19).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_20.xy, -8.0).w);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_10;
  highp vec4 tmpvar_20;
  tmpvar_20.zw = vec2(0.0, -8.0);
  tmpvar_20.xy = (unity_WorldToLight * tmpvar_19).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_20.xy, -8.0).w);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  lowp vec4 tmpvar_25;
  highp vec2 P_26;
  P_26 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_25 = texture2D (_CameraNormalsTexture, P_26);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_27)
  ) * atten_6));
  mediump vec3 rgb_30;
  rgb_30 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_30, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_31);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  lowp vec4 tmpvar_25;
  highp vec2 P_26;
  P_26 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_25 = texture2D (_CameraNormalsTexture, P_26);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_27)
  ) * atten_6));
  mediump vec3 rgb_30;
  rgb_30 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_30, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_31);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  lowp vec4 tmpvar_25;
  highp vec2 P_26;
  P_26 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_25 = texture2D (_CameraNormalsTexture, P_26);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_27)
  ) * atten_6));
  mediump vec3 rgb_30;
  rgb_30 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_30, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_31);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  lowp vec4 tmpvar_40;
  highp vec2 P_41;
  P_41 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_40 = texture2D (_CameraNormalsTexture, P_41);
  nspec_5 = tmpvar_40;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = pow (max (0.0, dot (h_4, tmpvar_42)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_44;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_42)
  ) * atten_6));
  mediump vec3 rgb_45;
  rgb_45 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_45, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_46);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  lowp vec4 tmpvar_40;
  highp vec2 P_41;
  P_41 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_40 = texture2D (_CameraNormalsTexture, P_41);
  nspec_5 = tmpvar_40;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = pow (max (0.0, dot (h_4, tmpvar_42)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_44;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_42)
  ) * atten_6));
  mediump vec3 rgb_45;
  rgb_45 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_45, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_46);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  lowp vec4 tmpvar_40;
  highp vec2 P_41;
  P_41 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_40 = texture2D (_CameraNormalsTexture, P_41);
  nspec_5 = tmpvar_40;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = pow (max (0.0, dot (h_4, tmpvar_42)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_44;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_42)
  ) * atten_6));
  mediump vec3 rgb_45;
  rgb_45 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_45, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_46);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_26.xyz, -8.0).w);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_26.xyz, -8.0).w);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_26.xyz, -8.0).w);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  highp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_10;
  highp vec4 tmpvar_41;
  tmpvar_41.w = -8.0;
  tmpvar_41.xyz = (unity_WorldToLight * tmpvar_40).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_41.xyz, -8.0).w);
  lowp vec4 tmpvar_42;
  highp vec2 P_43;
  P_43 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_42 = texture2D (_CameraNormalsTexture, P_43);
  nspec_5 = tmpvar_42;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = pow (max (0.0, dot (h_4, tmpvar_44)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_46;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_44)
  ) * atten_6));
  mediump vec3 rgb_47;
  rgb_47 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_47, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_48);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  highp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_10;
  highp vec4 tmpvar_41;
  tmpvar_41.w = -8.0;
  tmpvar_41.xyz = (unity_WorldToLight * tmpvar_40).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_41.xyz, -8.0).w);
  lowp vec4 tmpvar_42;
  highp vec2 P_43;
  P_43 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_42 = texture2D (_CameraNormalsTexture, P_43);
  nspec_5 = tmpvar_42;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = pow (max (0.0, dot (h_4, tmpvar_44)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_46;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_44)
  ) * atten_6));
  mediump vec3 rgb_47;
  rgb_47 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_47, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_48);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  highp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_10;
  highp vec4 tmpvar_41;
  tmpvar_41.w = -8.0;
  tmpvar_41.xyz = (unity_WorldToLight * tmpvar_40).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_41.xyz, -8.0).w);
  lowp vec4 tmpvar_42;
  highp vec2 P_43;
  P_43 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_42 = texture2D (_CameraNormalsTexture, P_43);
  nspec_5 = tmpvar_42;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = pow (max (0.0, dot (h_4, tmpvar_44)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_46;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_44)
  ) * atten_6));
  mediump vec3 rgb_47;
  rgb_47 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_47, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_48);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
}
}
}
}