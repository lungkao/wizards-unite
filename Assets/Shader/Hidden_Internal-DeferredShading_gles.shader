Shader "Hidden/Internal-DeferredShading" {
Properties {
_LightTexture0 ("", any) = "" { }
_LightTextureB0 ("", 2D) = "" { }
_ShadowMapTexture ("", any) = "" { }
_SrcBlend ("", Float) = 1
_DstBlend ("", Float) = 1
}
SubShader {
 Pass {
  Tags { "SHADOWSUPPORT" = "true" }
  ZWrite Off
  GpuProgramID 293
Program "vp" {
SubProgram "gles " {
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_15;
  mediump float tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_16 = gbuffer1_3.w;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_17 = tmpvar_18;
  highp vec3 viewDir_19;
  viewDir_19 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_20;
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_17, lightDir_7), 0.0, 1.0);
  tmpvar_21 = tmpvar_22;
  mediump float tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_17, viewDir_19), 0.0, 1.0);
  tmpvar_23 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = dot ((viewDir_19 - (2.0 * 
    (dot (tmpvar_17, viewDir_19) * tmpvar_17)
  )), lightDir_7);
  tmpvar_25.y = (1.0 - tmpvar_23);
  highp vec2 tmpvar_26;
  tmpvar_26 = ((tmpvar_25 * tmpvar_25) * (tmpvar_25 * tmpvar_25));
  rlPow4AndFresnelTerm_20 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = rlPow4AndFresnelTerm_20.x;
  mediump float specular_28;
  highp float smoothness_29;
  smoothness_29 = tmpvar_16;
  highp vec2 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = (1.0 - smoothness_29);
  highp float tmpvar_31;
  tmpvar_31 = (texture2D (unity_NHxRoughness, tmpvar_30).w * 16.0);
  specular_28 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = ((gbuffer0_4.xyz + (specular_28 * gbuffer1_3.xyz)) * (tmpvar_5 * tmpvar_21));
  mediump vec4 tmpvar_33;
  tmpvar_33 = exp2(-(tmpvar_32));
  tmpvar_1 = tmpvar_33;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_15;
  mediump float tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_16 = gbuffer1_3.w;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_17 = tmpvar_18;
  mediump vec3 color_19;
  highp float specularTerm_20;
  highp float a2_21;
  mediump float roughness_22;
  mediump float perceptualRoughness_23;
  highp vec3 tmpvar_24;
  highp vec3 inVec_25;
  inVec_25 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_24 = (inVec_25 * inversesqrt(max (0.001, 
    dot (inVec_25, inVec_25)
  )));
  mediump float tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_17, lightDir_7), 0.0, 1.0);
  tmpvar_26 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_17, tmpvar_24), 0.0, 1.0);
  highp float tmpvar_29;
  highp float smoothness_30;
  smoothness_30 = tmpvar_16;
  tmpvar_29 = (1.0 - smoothness_30);
  perceptualRoughness_23 = tmpvar_29;
  highp float tmpvar_31;
  highp float perceptualRoughness_32;
  perceptualRoughness_32 = perceptualRoughness_23;
  tmpvar_31 = (perceptualRoughness_32 * perceptualRoughness_32);
  roughness_22 = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = (roughness_22 * roughness_22);
  a2_21 = tmpvar_33;
  specularTerm_20 = ((roughness_22 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_24), 0.0, 1.0)) * (1.5 + roughness_22))
   * 
    (((tmpvar_28 * tmpvar_28) * (a2_21 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_34;
  tmpvar_34 = clamp (specularTerm_20, 0.0, 100.0);
  specularTerm_20 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (((gbuffer0_4.xyz + 
    (tmpvar_34 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_26);
  color_19 = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = color_19;
  mediump vec4 tmpvar_37;
  tmpvar_37 = exp2(-(tmpvar_36));
  tmpvar_1 = tmpvar_37;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_15;
  mediump float tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_16 = gbuffer1_3.w;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_17 = tmpvar_18;
  mediump vec3 color_19;
  highp float specularTerm_20;
  highp float a2_21;
  mediump float roughness_22;
  mediump float perceptualRoughness_23;
  highp vec3 tmpvar_24;
  highp vec3 inVec_25;
  inVec_25 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_24 = (inVec_25 * inversesqrt(max (0.001, 
    dot (inVec_25, inVec_25)
  )));
  mediump float tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_17, lightDir_7), 0.0, 1.0);
  tmpvar_26 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_17, tmpvar_24), 0.0, 1.0);
  highp float tmpvar_29;
  highp float smoothness_30;
  smoothness_30 = tmpvar_16;
  tmpvar_29 = (1.0 - smoothness_30);
  perceptualRoughness_23 = tmpvar_29;
  highp float tmpvar_31;
  highp float perceptualRoughness_32;
  perceptualRoughness_32 = perceptualRoughness_23;
  tmpvar_31 = (perceptualRoughness_32 * perceptualRoughness_32);
  roughness_22 = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = (roughness_22 * roughness_22);
  a2_21 = tmpvar_33;
  specularTerm_20 = ((roughness_22 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_24), 0.0, 1.0)) * (1.5 + roughness_22))
   * 
    (((tmpvar_28 * tmpvar_28) * (a2_21 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_34;
  tmpvar_34 = clamp (specularTerm_20, 0.0, 100.0);
  specularTerm_20 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (((gbuffer0_4.xyz + 
    (tmpvar_34 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_26);
  color_19 = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = color_19;
  mediump vec4 tmpvar_37;
  tmpvar_37 = exp2(-(tmpvar_36));
  tmpvar_1 = tmpvar_37;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles " {
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_9;
  tmpvar_5 = _LightColor.xyz;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_12;
  mediump float tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_13 = gbuffer1_3.w;
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_14 = tmpvar_15;
  highp vec3 viewDir_16;
  viewDir_16 = -(normalize((
    (unity_CameraToWorld * tmpvar_8)
  .xyz - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_17;
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_14, lightDir_6), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (dot (tmpvar_14, viewDir_16), 0.0, 1.0);
  tmpvar_20 = tmpvar_21;
  highp vec2 tmpvar_22;
  tmpvar_22.x = dot ((viewDir_16 - (2.0 * 
    (dot (tmpvar_14, viewDir_16) * tmpvar_14)
  )), lightDir_6);
  tmpvar_22.y = (1.0 - tmpvar_20);
  highp vec2 tmpvar_23;
  tmpvar_23 = ((tmpvar_22 * tmpvar_22) * (tmpvar_22 * tmpvar_22));
  rlPow4AndFresnelTerm_17 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = rlPow4AndFresnelTerm_17.x;
  mediump float specular_25;
  highp float smoothness_26;
  smoothness_26 = tmpvar_13;
  highp vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_24;
  tmpvar_27.y = (1.0 - smoothness_26);
  highp float tmpvar_28;
  tmpvar_28 = (texture2D (unity_NHxRoughness, tmpvar_27).w * 16.0);
  specular_25 = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = ((gbuffer0_4.xyz + (specular_25 * gbuffer1_3.xyz)) * (tmpvar_5 * tmpvar_18));
  mediump vec4 tmpvar_30;
  tmpvar_30 = exp2(-(tmpvar_29));
  tmpvar_1 = tmpvar_30;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_9;
  tmpvar_5 = _LightColor.xyz;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_12;
  mediump float tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_13 = gbuffer1_3.w;
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_14 = tmpvar_15;
  mediump vec3 color_16;
  highp float specularTerm_17;
  highp float a2_18;
  mediump float roughness_19;
  mediump float perceptualRoughness_20;
  highp vec3 tmpvar_21;
  highp vec3 inVec_22;
  inVec_22 = (lightDir_6 - normalize((
    (unity_CameraToWorld * tmpvar_8)
  .xyz - _WorldSpaceCameraPos)));
  tmpvar_21 = (inVec_22 * inversesqrt(max (0.001, 
    dot (inVec_22, inVec_22)
  )));
  mediump float tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_14, lightDir_6), 0.0, 1.0);
  tmpvar_23 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_14, tmpvar_21), 0.0, 1.0);
  highp float tmpvar_26;
  highp float smoothness_27;
  smoothness_27 = tmpvar_13;
  tmpvar_26 = (1.0 - smoothness_27);
  perceptualRoughness_20 = tmpvar_26;
  highp float tmpvar_28;
  highp float perceptualRoughness_29;
  perceptualRoughness_29 = perceptualRoughness_20;
  tmpvar_28 = (perceptualRoughness_29 * perceptualRoughness_29);
  roughness_19 = tmpvar_28;
  mediump float tmpvar_30;
  tmpvar_30 = (roughness_19 * roughness_19);
  a2_18 = tmpvar_30;
  specularTerm_17 = ((roughness_19 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_21), 0.0, 1.0)) * (1.5 + roughness_19))
   * 
    (((tmpvar_25 * tmpvar_25) * (a2_18 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_31;
  tmpvar_31 = clamp (specularTerm_17, 0.0, 100.0);
  specularTerm_17 = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (((gbuffer0_4.xyz + 
    (tmpvar_31 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_23);
  color_16 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 1.0;
  tmpvar_33.xyz = color_16;
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(tmpvar_33));
  tmpvar_1 = tmpvar_34;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_9;
  tmpvar_5 = _LightColor.xyz;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_12;
  mediump float tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_13 = gbuffer1_3.w;
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_14 = tmpvar_15;
  mediump vec3 color_16;
  highp float specularTerm_17;
  highp float a2_18;
  mediump float roughness_19;
  mediump float perceptualRoughness_20;
  highp vec3 tmpvar_21;
  highp vec3 inVec_22;
  inVec_22 = (lightDir_6 - normalize((
    (unity_CameraToWorld * tmpvar_8)
  .xyz - _WorldSpaceCameraPos)));
  tmpvar_21 = (inVec_22 * inversesqrt(max (0.001, 
    dot (inVec_22, inVec_22)
  )));
  mediump float tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_14, lightDir_6), 0.0, 1.0);
  tmpvar_23 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_14, tmpvar_21), 0.0, 1.0);
  highp float tmpvar_26;
  highp float smoothness_27;
  smoothness_27 = tmpvar_13;
  tmpvar_26 = (1.0 - smoothness_27);
  perceptualRoughness_20 = tmpvar_26;
  highp float tmpvar_28;
  highp float perceptualRoughness_29;
  perceptualRoughness_29 = perceptualRoughness_20;
  tmpvar_28 = (perceptualRoughness_29 * perceptualRoughness_29);
  roughness_19 = tmpvar_28;
  mediump float tmpvar_30;
  tmpvar_30 = (roughness_19 * roughness_19);
  a2_18 = tmpvar_30;
  specularTerm_17 = ((roughness_19 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_21), 0.0, 1.0)) * (1.5 + roughness_19))
   * 
    (((tmpvar_25 * tmpvar_25) * (a2_18 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_31;
  tmpvar_31 = clamp (specularTerm_17, 0.0, 100.0);
  specularTerm_17 = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (((gbuffer0_4.xyz + 
    (tmpvar_31 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_23);
  color_16 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 1.0;
  tmpvar_33.xyz = color_16;
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(tmpvar_33));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles " {
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_18;
  mediump float tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_19 = gbuffer1_3.w;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_20 = tmpvar_21;
  highp vec3 viewDir_22;
  viewDir_22 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_23;
  mediump float tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_20, lightDir_7), 0.0, 1.0);
  tmpvar_24 = tmpvar_25;
  mediump float tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_20, viewDir_22), 0.0, 1.0);
  tmpvar_26 = tmpvar_27;
  highp vec2 tmpvar_28;
  tmpvar_28.x = dot ((viewDir_22 - (2.0 * 
    (dot (tmpvar_20, viewDir_22) * tmpvar_20)
  )), lightDir_7);
  tmpvar_28.y = (1.0 - tmpvar_26);
  highp vec2 tmpvar_29;
  tmpvar_29 = ((tmpvar_28 * tmpvar_28) * (tmpvar_28 * tmpvar_28));
  rlPow4AndFresnelTerm_23 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = rlPow4AndFresnelTerm_23.x;
  mediump float specular_31;
  highp float smoothness_32;
  smoothness_32 = tmpvar_19;
  highp vec2 tmpvar_33;
  tmpvar_33.x = tmpvar_30;
  tmpvar_33.y = (1.0 - smoothness_32);
  highp float tmpvar_34;
  tmpvar_34 = (texture2D (unity_NHxRoughness, tmpvar_33).w * 16.0);
  specular_31 = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35.w = 1.0;
  tmpvar_35.xyz = ((gbuffer0_4.xyz + (specular_31 * gbuffer1_3.xyz)) * (tmpvar_5 * tmpvar_24));
  mediump vec4 tmpvar_36;
  tmpvar_36 = exp2(-(tmpvar_35));
  tmpvar_1 = tmpvar_36;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_18;
  mediump float tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_19 = gbuffer1_3.w;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_20 = tmpvar_21;
  mediump vec3 color_22;
  highp float specularTerm_23;
  highp float a2_24;
  mediump float roughness_25;
  mediump float perceptualRoughness_26;
  highp vec3 tmpvar_27;
  highp vec3 inVec_28;
  inVec_28 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_27 = (inVec_28 * inversesqrt(max (0.001, 
    dot (inVec_28, inVec_28)
  )));
  mediump float tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_20, lightDir_7), 0.0, 1.0);
  tmpvar_29 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp (dot (tmpvar_20, tmpvar_27), 0.0, 1.0);
  highp float tmpvar_32;
  highp float smoothness_33;
  smoothness_33 = tmpvar_19;
  tmpvar_32 = (1.0 - smoothness_33);
  perceptualRoughness_26 = tmpvar_32;
  highp float tmpvar_34;
  highp float perceptualRoughness_35;
  perceptualRoughness_35 = perceptualRoughness_26;
  tmpvar_34 = (perceptualRoughness_35 * perceptualRoughness_35);
  roughness_25 = tmpvar_34;
  mediump float tmpvar_36;
  tmpvar_36 = (roughness_25 * roughness_25);
  a2_24 = tmpvar_36;
  specularTerm_23 = ((roughness_25 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_27), 0.0, 1.0)) * (1.5 + roughness_25))
   * 
    (((tmpvar_31 * tmpvar_31) * (a2_24 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_37;
  tmpvar_37 = clamp (specularTerm_23, 0.0, 100.0);
  specularTerm_23 = tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_38 = (((gbuffer0_4.xyz + 
    (tmpvar_37 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_29);
  color_22 = tmpvar_38;
  mediump vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = color_22;
  mediump vec4 tmpvar_40;
  tmpvar_40 = exp2(-(tmpvar_39));
  tmpvar_1 = tmpvar_40;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_18;
  mediump float tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_19 = gbuffer1_3.w;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_20 = tmpvar_21;
  mediump vec3 color_22;
  highp float specularTerm_23;
  highp float a2_24;
  mediump float roughness_25;
  mediump float perceptualRoughness_26;
  highp vec3 tmpvar_27;
  highp vec3 inVec_28;
  inVec_28 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_27 = (inVec_28 * inversesqrt(max (0.001, 
    dot (inVec_28, inVec_28)
  )));
  mediump float tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_20, lightDir_7), 0.0, 1.0);
  tmpvar_29 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp (dot (tmpvar_20, tmpvar_27), 0.0, 1.0);
  highp float tmpvar_32;
  highp float smoothness_33;
  smoothness_33 = tmpvar_19;
  tmpvar_32 = (1.0 - smoothness_33);
  perceptualRoughness_26 = tmpvar_32;
  highp float tmpvar_34;
  highp float perceptualRoughness_35;
  perceptualRoughness_35 = perceptualRoughness_26;
  tmpvar_34 = (perceptualRoughness_35 * perceptualRoughness_35);
  roughness_25 = tmpvar_34;
  mediump float tmpvar_36;
  tmpvar_36 = (roughness_25 * roughness_25);
  a2_24 = tmpvar_36;
  specularTerm_23 = ((roughness_25 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_27), 0.0, 1.0)) * (1.5 + roughness_25))
   * 
    (((tmpvar_31 * tmpvar_31) * (a2_24 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_37;
  tmpvar_37 = clamp (specularTerm_23, 0.0, 100.0);
  specularTerm_23 = tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_38 = (((gbuffer0_4.xyz + 
    (tmpvar_37 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_29);
  color_22 = tmpvar_38;
  mediump vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = color_22;
  mediump vec4 tmpvar_40;
  tmpvar_40 = exp2(-(tmpvar_39));
  tmpvar_1 = tmpvar_40;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles " {
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.w = -8.0;
  tmpvar_14.xyz = (unity_WorldToLight * tmpvar_13).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_14.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_17;
  mediump float tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_18 = gbuffer1_3.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_19 = tmpvar_20;
  highp vec3 viewDir_21;
  viewDir_21 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_22;
  mediump float tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_19, lightDir_7), 0.0, 1.0);
  tmpvar_23 = tmpvar_24;
  mediump float tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_19, viewDir_21), 0.0, 1.0);
  tmpvar_25 = tmpvar_26;
  highp vec2 tmpvar_27;
  tmpvar_27.x = dot ((viewDir_21 - (2.0 * 
    (dot (tmpvar_19, viewDir_21) * tmpvar_19)
  )), lightDir_7);
  tmpvar_27.y = (1.0 - tmpvar_25);
  highp vec2 tmpvar_28;
  tmpvar_28 = ((tmpvar_27 * tmpvar_27) * (tmpvar_27 * tmpvar_27));
  rlPow4AndFresnelTerm_22 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = rlPow4AndFresnelTerm_22.x;
  mediump float specular_30;
  highp float smoothness_31;
  smoothness_31 = tmpvar_18;
  highp vec2 tmpvar_32;
  tmpvar_32.x = tmpvar_29;
  tmpvar_32.y = (1.0 - smoothness_31);
  highp float tmpvar_33;
  tmpvar_33 = (texture2D (unity_NHxRoughness, tmpvar_32).w * 16.0);
  specular_30 = tmpvar_33;
  mediump vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = ((gbuffer0_4.xyz + (specular_30 * gbuffer1_3.xyz)) * (tmpvar_5 * tmpvar_23));
  mediump vec4 tmpvar_35;
  tmpvar_35 = exp2(-(tmpvar_34));
  tmpvar_1 = tmpvar_35;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.w = -8.0;
  tmpvar_14.xyz = (unity_WorldToLight * tmpvar_13).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_14.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_17;
  mediump float tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_18 = gbuffer1_3.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_19 = tmpvar_20;
  mediump vec3 color_21;
  highp float specularTerm_22;
  highp float a2_23;
  mediump float roughness_24;
  mediump float perceptualRoughness_25;
  highp vec3 tmpvar_26;
  highp vec3 inVec_27;
  inVec_27 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_26 = (inVec_27 * inversesqrt(max (0.001, 
    dot (inVec_27, inVec_27)
  )));
  mediump float tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_19, lightDir_7), 0.0, 1.0);
  tmpvar_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_19, tmpvar_26), 0.0, 1.0);
  highp float tmpvar_31;
  highp float smoothness_32;
  smoothness_32 = tmpvar_18;
  tmpvar_31 = (1.0 - smoothness_32);
  perceptualRoughness_25 = tmpvar_31;
  highp float tmpvar_33;
  highp float perceptualRoughness_34;
  perceptualRoughness_34 = perceptualRoughness_25;
  tmpvar_33 = (perceptualRoughness_34 * perceptualRoughness_34);
  roughness_24 = tmpvar_33;
  mediump float tmpvar_35;
  tmpvar_35 = (roughness_24 * roughness_24);
  a2_23 = tmpvar_35;
  specularTerm_22 = ((roughness_24 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_26), 0.0, 1.0)) * (1.5 + roughness_24))
   * 
    (((tmpvar_30 * tmpvar_30) * (a2_23 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_36;
  tmpvar_36 = clamp (specularTerm_22, 0.0, 100.0);
  specularTerm_22 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (((gbuffer0_4.xyz + 
    (tmpvar_36 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_28);
  color_21 = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = color_21;
  mediump vec4 tmpvar_39;
  tmpvar_39 = exp2(-(tmpvar_38));
  tmpvar_1 = tmpvar_39;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.w = -8.0;
  tmpvar_14.xyz = (unity_WorldToLight * tmpvar_13).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_14.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_17;
  mediump float tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_18 = gbuffer1_3.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_19 = tmpvar_20;
  mediump vec3 color_21;
  highp float specularTerm_22;
  highp float a2_23;
  mediump float roughness_24;
  mediump float perceptualRoughness_25;
  highp vec3 tmpvar_26;
  highp vec3 inVec_27;
  inVec_27 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_26 = (inVec_27 * inversesqrt(max (0.001, 
    dot (inVec_27, inVec_27)
  )));
  mediump float tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_19, lightDir_7), 0.0, 1.0);
  tmpvar_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_19, tmpvar_26), 0.0, 1.0);
  highp float tmpvar_31;
  highp float smoothness_32;
  smoothness_32 = tmpvar_18;
  tmpvar_31 = (1.0 - smoothness_32);
  perceptualRoughness_25 = tmpvar_31;
  highp float tmpvar_33;
  highp float perceptualRoughness_34;
  perceptualRoughness_34 = perceptualRoughness_25;
  tmpvar_33 = (perceptualRoughness_34 * perceptualRoughness_34);
  roughness_24 = tmpvar_33;
  mediump float tmpvar_35;
  tmpvar_35 = (roughness_24 * roughness_24);
  a2_23 = tmpvar_35;
  specularTerm_22 = ((roughness_24 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_26), 0.0, 1.0)) * (1.5 + roughness_24))
   * 
    (((tmpvar_30 * tmpvar_30) * (a2_23 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_36;
  tmpvar_36 = clamp (specularTerm_22, 0.0, 100.0);
  specularTerm_22 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (((gbuffer0_4.xyz + 
    (tmpvar_36 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_28);
  color_21 = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = color_21;
  mediump vec4 tmpvar_39;
  tmpvar_39 = exp2(-(tmpvar_38));
  tmpvar_1 = tmpvar_39;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles " {
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  highp vec4 tmpvar_13;
  tmpvar_13.zw = vec2(0.0, -8.0);
  tmpvar_13.xy = (unity_WorldToLight * tmpvar_12).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_13.xy, -8.0).w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_16;
  mediump float tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_17 = gbuffer1_3.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_18 = tmpvar_19;
  highp vec3 viewDir_20;
  viewDir_20 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_21;
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_18, lightDir_7), 0.0, 1.0);
  tmpvar_22 = tmpvar_23;
  mediump float tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_18, viewDir_20), 0.0, 1.0);
  tmpvar_24 = tmpvar_25;
  highp vec2 tmpvar_26;
  tmpvar_26.x = dot ((viewDir_20 - (2.0 * 
    (dot (tmpvar_18, viewDir_20) * tmpvar_18)
  )), lightDir_7);
  tmpvar_26.y = (1.0 - tmpvar_24);
  highp vec2 tmpvar_27;
  tmpvar_27 = ((tmpvar_26 * tmpvar_26) * (tmpvar_26 * tmpvar_26));
  rlPow4AndFresnelTerm_21 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = rlPow4AndFresnelTerm_21.x;
  mediump float specular_29;
  highp float smoothness_30;
  smoothness_30 = tmpvar_17;
  highp vec2 tmpvar_31;
  tmpvar_31.x = tmpvar_28;
  tmpvar_31.y = (1.0 - smoothness_30);
  highp float tmpvar_32;
  tmpvar_32 = (texture2D (unity_NHxRoughness, tmpvar_31).w * 16.0);
  specular_29 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 1.0;
  tmpvar_33.xyz = ((gbuffer0_4.xyz + (specular_29 * gbuffer1_3.xyz)) * (tmpvar_5 * tmpvar_22));
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(tmpvar_33));
  tmpvar_1 = tmpvar_34;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  highp vec4 tmpvar_13;
  tmpvar_13.zw = vec2(0.0, -8.0);
  tmpvar_13.xy = (unity_WorldToLight * tmpvar_12).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_13.xy, -8.0).w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_16;
  mediump float tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_17 = gbuffer1_3.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_18 = tmpvar_19;
  mediump vec3 color_20;
  highp float specularTerm_21;
  highp float a2_22;
  mediump float roughness_23;
  mediump float perceptualRoughness_24;
  highp vec3 tmpvar_25;
  highp vec3 inVec_26;
  inVec_26 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  mediump float tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_18, lightDir_7), 0.0, 1.0);
  tmpvar_27 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_18, tmpvar_25), 0.0, 1.0);
  highp float tmpvar_30;
  highp float smoothness_31;
  smoothness_31 = tmpvar_17;
  tmpvar_30 = (1.0 - smoothness_31);
  perceptualRoughness_24 = tmpvar_30;
  highp float tmpvar_32;
  highp float perceptualRoughness_33;
  perceptualRoughness_33 = perceptualRoughness_24;
  tmpvar_32 = (perceptualRoughness_33 * perceptualRoughness_33);
  roughness_23 = tmpvar_32;
  mediump float tmpvar_34;
  tmpvar_34 = (roughness_23 * roughness_23);
  a2_22 = tmpvar_34;
  specularTerm_21 = ((roughness_23 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_25), 0.0, 1.0)) * (1.5 + roughness_23))
   * 
    (((tmpvar_29 * tmpvar_29) * (a2_22 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_35;
  tmpvar_35 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (((gbuffer0_4.xyz + 
    (tmpvar_35 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_27);
  color_20 = tmpvar_36;
  mediump vec4 tmpvar_37;
  tmpvar_37.w = 1.0;
  tmpvar_37.xyz = color_20;
  mediump vec4 tmpvar_38;
  tmpvar_38 = exp2(-(tmpvar_37));
  tmpvar_1 = tmpvar_38;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  highp vec4 tmpvar_13;
  tmpvar_13.zw = vec2(0.0, -8.0);
  tmpvar_13.xy = (unity_WorldToLight * tmpvar_12).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_13.xy, -8.0).w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_16;
  mediump float tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_17 = gbuffer1_3.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_18 = tmpvar_19;
  mediump vec3 color_20;
  highp float specularTerm_21;
  highp float a2_22;
  mediump float roughness_23;
  mediump float perceptualRoughness_24;
  highp vec3 tmpvar_25;
  highp vec3 inVec_26;
  inVec_26 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  mediump float tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_18, lightDir_7), 0.0, 1.0);
  tmpvar_27 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_18, tmpvar_25), 0.0, 1.0);
  highp float tmpvar_30;
  highp float smoothness_31;
  smoothness_31 = tmpvar_17;
  tmpvar_30 = (1.0 - smoothness_31);
  perceptualRoughness_24 = tmpvar_30;
  highp float tmpvar_32;
  highp float perceptualRoughness_33;
  perceptualRoughness_33 = perceptualRoughness_24;
  tmpvar_32 = (perceptualRoughness_33 * perceptualRoughness_33);
  roughness_23 = tmpvar_32;
  mediump float tmpvar_34;
  tmpvar_34 = (roughness_23 * roughness_23);
  a2_22 = tmpvar_34;
  specularTerm_21 = ((roughness_23 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_25), 0.0, 1.0)) * (1.5 + roughness_23))
   * 
    (((tmpvar_29 * tmpvar_29) * (a2_22 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_35;
  tmpvar_35 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (((gbuffer0_4.xyz + 
    (tmpvar_35 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_27);
  color_20 = tmpvar_36;
  mediump vec4 tmpvar_37;
  tmpvar_37.w = 1.0;
  tmpvar_37.xyz = color_20;
  mediump vec4 tmpvar_38;
  tmpvar_38 = exp2(-(tmpvar_37));
  tmpvar_1 = tmpvar_38;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles " {
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_ShadowMapTexture, tmpvar_21);
  mediump float tmpvar_24;
  if ((tmpvar_23.x < (tmpvar_21.z / tmpvar_21.w))) {
    tmpvar_24 = _LightShadowData.x;
  } else {
    tmpvar_24 = 1.0;
  };
  tmpvar_22 = tmpvar_24;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_25;
  tmpvar_25 = clamp ((shadowAttenuation_19 + tmpvar_17), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_25);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump float tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_29 = gbuffer1_3.w;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_30 = tmpvar_31;
  highp vec3 viewDir_32;
  viewDir_32 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_33;
  mediump float tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp (dot (tmpvar_30, lightDir_7), 0.0, 1.0);
  tmpvar_34 = tmpvar_35;
  mediump float tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_30, viewDir_32), 0.0, 1.0);
  tmpvar_36 = tmpvar_37;
  highp vec2 tmpvar_38;
  tmpvar_38.x = dot ((viewDir_32 - (2.0 * 
    (dot (tmpvar_30, viewDir_32) * tmpvar_30)
  )), lightDir_7);
  tmpvar_38.y = (1.0 - tmpvar_36);
  highp vec2 tmpvar_39;
  tmpvar_39 = ((tmpvar_38 * tmpvar_38) * (tmpvar_38 * tmpvar_38));
  rlPow4AndFresnelTerm_33 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = rlPow4AndFresnelTerm_33.x;
  mediump float specular_41;
  highp float smoothness_42;
  smoothness_42 = tmpvar_29;
  highp vec2 tmpvar_43;
  tmpvar_43.x = tmpvar_40;
  tmpvar_43.y = (1.0 - smoothness_42);
  highp float tmpvar_44;
  tmpvar_44 = (texture2D (unity_NHxRoughness, tmpvar_43).w * 16.0);
  specular_41 = tmpvar_44;
  mediump vec4 tmpvar_45;
  tmpvar_45.w = 1.0;
  tmpvar_45.xyz = ((gbuffer0_4.xyz + (specular_41 * gbuffer1_3.xyz)) * (tmpvar_5 * tmpvar_34));
  mediump vec4 tmpvar_46;
  tmpvar_46 = exp2(-(tmpvar_45));
  tmpvar_1 = tmpvar_46;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_ShadowMapTexture, tmpvar_21);
  mediump float tmpvar_24;
  if ((tmpvar_23.x < (tmpvar_21.z / tmpvar_21.w))) {
    tmpvar_24 = _LightShadowData.x;
  } else {
    tmpvar_24 = 1.0;
  };
  tmpvar_22 = tmpvar_24;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_25;
  tmpvar_25 = clamp ((shadowAttenuation_19 + tmpvar_17), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_25);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump float tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_29 = gbuffer1_3.w;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_30 = tmpvar_31;
  mediump vec3 color_32;
  highp float specularTerm_33;
  highp float a2_34;
  mediump float roughness_35;
  mediump float perceptualRoughness_36;
  highp vec3 tmpvar_37;
  highp vec3 inVec_38;
  inVec_38 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_37 = (inVec_38 * inversesqrt(max (0.001, 
    dot (inVec_38, inVec_38)
  )));
  mediump float tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_30, lightDir_7), 0.0, 1.0);
  tmpvar_39 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = clamp (dot (tmpvar_30, tmpvar_37), 0.0, 1.0);
  highp float tmpvar_42;
  highp float smoothness_43;
  smoothness_43 = tmpvar_29;
  tmpvar_42 = (1.0 - smoothness_43);
  perceptualRoughness_36 = tmpvar_42;
  highp float tmpvar_44;
  highp float perceptualRoughness_45;
  perceptualRoughness_45 = perceptualRoughness_36;
  tmpvar_44 = (perceptualRoughness_45 * perceptualRoughness_45);
  roughness_35 = tmpvar_44;
  mediump float tmpvar_46;
  tmpvar_46 = (roughness_35 * roughness_35);
  a2_34 = tmpvar_46;
  specularTerm_33 = ((roughness_35 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_37), 0.0, 1.0)) * (1.5 + roughness_35))
   * 
    (((tmpvar_41 * tmpvar_41) * (a2_34 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_47;
  tmpvar_47 = clamp (specularTerm_33, 0.0, 100.0);
  specularTerm_33 = tmpvar_47;
  highp vec3 tmpvar_48;
  tmpvar_48 = (((gbuffer0_4.xyz + 
    (tmpvar_47 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_39);
  color_32 = tmpvar_48;
  mediump vec4 tmpvar_49;
  tmpvar_49.w = 1.0;
  tmpvar_49.xyz = color_32;
  mediump vec4 tmpvar_50;
  tmpvar_50 = exp2(-(tmpvar_49));
  tmpvar_1 = tmpvar_50;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_ShadowMapTexture, tmpvar_21);
  mediump float tmpvar_24;
  if ((tmpvar_23.x < (tmpvar_21.z / tmpvar_21.w))) {
    tmpvar_24 = _LightShadowData.x;
  } else {
    tmpvar_24 = 1.0;
  };
  tmpvar_22 = tmpvar_24;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_25;
  tmpvar_25 = clamp ((shadowAttenuation_19 + tmpvar_17), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_25);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump float tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_29 = gbuffer1_3.w;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_30 = tmpvar_31;
  mediump vec3 color_32;
  highp float specularTerm_33;
  highp float a2_34;
  mediump float roughness_35;
  mediump float perceptualRoughness_36;
  highp vec3 tmpvar_37;
  highp vec3 inVec_38;
  inVec_38 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_37 = (inVec_38 * inversesqrt(max (0.001, 
    dot (inVec_38, inVec_38)
  )));
  mediump float tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_30, lightDir_7), 0.0, 1.0);
  tmpvar_39 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = clamp (dot (tmpvar_30, tmpvar_37), 0.0, 1.0);
  highp float tmpvar_42;
  highp float smoothness_43;
  smoothness_43 = tmpvar_29;
  tmpvar_42 = (1.0 - smoothness_43);
  perceptualRoughness_36 = tmpvar_42;
  highp float tmpvar_44;
  highp float perceptualRoughness_45;
  perceptualRoughness_45 = perceptualRoughness_36;
  tmpvar_44 = (perceptualRoughness_45 * perceptualRoughness_45);
  roughness_35 = tmpvar_44;
  mediump float tmpvar_46;
  tmpvar_46 = (roughness_35 * roughness_35);
  a2_34 = tmpvar_46;
  specularTerm_33 = ((roughness_35 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_37), 0.0, 1.0)) * (1.5 + roughness_35))
   * 
    (((tmpvar_41 * tmpvar_41) * (a2_34 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_47;
  tmpvar_47 = clamp (specularTerm_33, 0.0, 100.0);
  specularTerm_33 = tmpvar_47;
  highp vec3 tmpvar_48;
  tmpvar_48 = (((gbuffer0_4.xyz + 
    (tmpvar_47 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_39);
  color_32 = tmpvar_48;
  mediump vec4 tmpvar_49;
  tmpvar_49.w = 1.0;
  tmpvar_49.xyz = color_32;
  mediump vec4 tmpvar_50;
  tmpvar_50 = exp2(-(tmpvar_49));
  tmpvar_1 = tmpvar_50;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles " {
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 shadowVals_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_21.xyz / tmpvar_21.w);
  shadowVals_23.x = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_23.y = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_23.z = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_23.w = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_25;
  tmpvar_25 = lessThan (shadowVals_23, tmpvar_24.zzzz);
  mediump vec4 tmpvar_26;
  tmpvar_26 = _LightShadowData.xxxx;
  mediump float tmpvar_27;
  if (tmpvar_25.x) {
    tmpvar_27 = tmpvar_26.x;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_25.y) {
    tmpvar_28 = tmpvar_26.y;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_25.z) {
    tmpvar_29 = tmpvar_26.z;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_25.w) {
    tmpvar_30 = tmpvar_26.w;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump vec4 tmpvar_31;
  tmpvar_31.x = tmpvar_27;
  tmpvar_31.y = tmpvar_28;
  tmpvar_31.z = tmpvar_29;
  tmpvar_31.w = tmpvar_30;
  mediump float tmpvar_32;
  tmpvar_32 = dot (tmpvar_31, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_22 = tmpvar_32;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_33;
  tmpvar_33 = clamp ((shadowAttenuation_19 + tmpvar_17), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_33);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_36;
  mediump float tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_37 = gbuffer1_3.w;
  mediump vec3 tmpvar_39;
  tmpvar_39 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_38 = tmpvar_39;
  highp vec3 viewDir_40;
  viewDir_40 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_41;
  mediump float tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = clamp (dot (tmpvar_38, lightDir_7), 0.0, 1.0);
  tmpvar_42 = tmpvar_43;
  mediump float tmpvar_44;
  highp float tmpvar_45;
  tmpvar_45 = clamp (dot (tmpvar_38, viewDir_40), 0.0, 1.0);
  tmpvar_44 = tmpvar_45;
  highp vec2 tmpvar_46;
  tmpvar_46.x = dot ((viewDir_40 - (2.0 * 
    (dot (tmpvar_38, viewDir_40) * tmpvar_38)
  )), lightDir_7);
  tmpvar_46.y = (1.0 - tmpvar_44);
  highp vec2 tmpvar_47;
  tmpvar_47 = ((tmpvar_46 * tmpvar_46) * (tmpvar_46 * tmpvar_46));
  rlPow4AndFresnelTerm_41 = tmpvar_47;
  mediump float tmpvar_48;
  tmpvar_48 = rlPow4AndFresnelTerm_41.x;
  mediump float specular_49;
  highp float smoothness_50;
  smoothness_50 = tmpvar_37;
  highp vec2 tmpvar_51;
  tmpvar_51.x = tmpvar_48;
  tmpvar_51.y = (1.0 - smoothness_50);
  highp float tmpvar_52;
  tmpvar_52 = (texture2D (unity_NHxRoughness, tmpvar_51).w * 16.0);
  specular_49 = tmpvar_52;
  mediump vec4 tmpvar_53;
  tmpvar_53.w = 1.0;
  tmpvar_53.xyz = ((gbuffer0_4.xyz + (specular_49 * gbuffer1_3.xyz)) * (tmpvar_5 * tmpvar_42));
  mediump vec4 tmpvar_54;
  tmpvar_54 = exp2(-(tmpvar_53));
  tmpvar_1 = tmpvar_54;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 shadowVals_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_21.xyz / tmpvar_21.w);
  shadowVals_23.x = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_23.y = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_23.z = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_23.w = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_25;
  tmpvar_25 = lessThan (shadowVals_23, tmpvar_24.zzzz);
  mediump vec4 tmpvar_26;
  tmpvar_26 = _LightShadowData.xxxx;
  mediump float tmpvar_27;
  if (tmpvar_25.x) {
    tmpvar_27 = tmpvar_26.x;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_25.y) {
    tmpvar_28 = tmpvar_26.y;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_25.z) {
    tmpvar_29 = tmpvar_26.z;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_25.w) {
    tmpvar_30 = tmpvar_26.w;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump vec4 tmpvar_31;
  tmpvar_31.x = tmpvar_27;
  tmpvar_31.y = tmpvar_28;
  tmpvar_31.z = tmpvar_29;
  tmpvar_31.w = tmpvar_30;
  mediump float tmpvar_32;
  tmpvar_32 = dot (tmpvar_31, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_22 = tmpvar_32;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_33;
  tmpvar_33 = clamp ((shadowAttenuation_19 + tmpvar_17), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_33);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_36;
  mediump float tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_37 = gbuffer1_3.w;
  mediump vec3 tmpvar_39;
  tmpvar_39 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_38 = tmpvar_39;
  mediump vec3 color_40;
  highp float specularTerm_41;
  highp float a2_42;
  mediump float roughness_43;
  mediump float perceptualRoughness_44;
  highp vec3 tmpvar_45;
  highp vec3 inVec_46;
  inVec_46 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_45 = (inVec_46 * inversesqrt(max (0.001, 
    dot (inVec_46, inVec_46)
  )));
  mediump float tmpvar_47;
  highp float tmpvar_48;
  tmpvar_48 = clamp (dot (tmpvar_38, lightDir_7), 0.0, 1.0);
  tmpvar_47 = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = clamp (dot (tmpvar_38, tmpvar_45), 0.0, 1.0);
  highp float tmpvar_50;
  highp float smoothness_51;
  smoothness_51 = tmpvar_37;
  tmpvar_50 = (1.0 - smoothness_51);
  perceptualRoughness_44 = tmpvar_50;
  highp float tmpvar_52;
  highp float perceptualRoughness_53;
  perceptualRoughness_53 = perceptualRoughness_44;
  tmpvar_52 = (perceptualRoughness_53 * perceptualRoughness_53);
  roughness_43 = tmpvar_52;
  mediump float tmpvar_54;
  tmpvar_54 = (roughness_43 * roughness_43);
  a2_42 = tmpvar_54;
  specularTerm_41 = ((roughness_43 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_45), 0.0, 1.0)) * (1.5 + roughness_43))
   * 
    (((tmpvar_49 * tmpvar_49) * (a2_42 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_55;
  tmpvar_55 = clamp (specularTerm_41, 0.0, 100.0);
  specularTerm_41 = tmpvar_55;
  highp vec3 tmpvar_56;
  tmpvar_56 = (((gbuffer0_4.xyz + 
    (tmpvar_55 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_47);
  color_40 = tmpvar_56;
  mediump vec4 tmpvar_57;
  tmpvar_57.w = 1.0;
  tmpvar_57.xyz = color_40;
  mediump vec4 tmpvar_58;
  tmpvar_58 = exp2(-(tmpvar_57));
  tmpvar_1 = tmpvar_58;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 shadowVals_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_21.xyz / tmpvar_21.w);
  shadowVals_23.x = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_23.y = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_23.z = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_23.w = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_25;
  tmpvar_25 = lessThan (shadowVals_23, tmpvar_24.zzzz);
  mediump vec4 tmpvar_26;
  tmpvar_26 = _LightShadowData.xxxx;
  mediump float tmpvar_27;
  if (tmpvar_25.x) {
    tmpvar_27 = tmpvar_26.x;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_25.y) {
    tmpvar_28 = tmpvar_26.y;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_25.z) {
    tmpvar_29 = tmpvar_26.z;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_25.w) {
    tmpvar_30 = tmpvar_26.w;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump vec4 tmpvar_31;
  tmpvar_31.x = tmpvar_27;
  tmpvar_31.y = tmpvar_28;
  tmpvar_31.z = tmpvar_29;
  tmpvar_31.w = tmpvar_30;
  mediump float tmpvar_32;
  tmpvar_32 = dot (tmpvar_31, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_22 = tmpvar_32;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_33;
  tmpvar_33 = clamp ((shadowAttenuation_19 + tmpvar_17), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_33);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_36;
  mediump float tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_37 = gbuffer1_3.w;
  mediump vec3 tmpvar_39;
  tmpvar_39 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_38 = tmpvar_39;
  mediump vec3 color_40;
  highp float specularTerm_41;
  highp float a2_42;
  mediump float roughness_43;
  mediump float perceptualRoughness_44;
  highp vec3 tmpvar_45;
  highp vec3 inVec_46;
  inVec_46 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_45 = (inVec_46 * inversesqrt(max (0.001, 
    dot (inVec_46, inVec_46)
  )));
  mediump float tmpvar_47;
  highp float tmpvar_48;
  tmpvar_48 = clamp (dot (tmpvar_38, lightDir_7), 0.0, 1.0);
  tmpvar_47 = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = clamp (dot (tmpvar_38, tmpvar_45), 0.0, 1.0);
  highp float tmpvar_50;
  highp float smoothness_51;
  smoothness_51 = tmpvar_37;
  tmpvar_50 = (1.0 - smoothness_51);
  perceptualRoughness_44 = tmpvar_50;
  highp float tmpvar_52;
  highp float perceptualRoughness_53;
  perceptualRoughness_53 = perceptualRoughness_44;
  tmpvar_52 = (perceptualRoughness_53 * perceptualRoughness_53);
  roughness_43 = tmpvar_52;
  mediump float tmpvar_54;
  tmpvar_54 = (roughness_43 * roughness_43);
  a2_42 = tmpvar_54;
  specularTerm_41 = ((roughness_43 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_45), 0.0, 1.0)) * (1.5 + roughness_43))
   * 
    (((tmpvar_49 * tmpvar_49) * (a2_42 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_55;
  tmpvar_55 = clamp (specularTerm_41, 0.0, 100.0);
  specularTerm_41 = tmpvar_55;
  highp vec3 tmpvar_56;
  tmpvar_56 = (((gbuffer0_4.xyz + 
    (tmpvar_55 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_47);
  color_40 = tmpvar_56;
  mediump vec4 tmpvar_57;
  tmpvar_57.w = 1.0;
  tmpvar_57.xyz = color_40;
  mediump vec4 tmpvar_58;
  tmpvar_58 = exp2(-(tmpvar_57));
  tmpvar_1 = tmpvar_58;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles " {
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
uniform sampler2D _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((shadowAttenuation_15 + tmpvar_13), 0.0, 1.0);
  atten_6 = tmpvar_17;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_20;
  mediump float tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_21 = gbuffer1_3.w;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_22 = tmpvar_23;
  highp vec3 viewDir_24;
  viewDir_24 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_25;
  mediump float tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_22, lightDir_7), 0.0, 1.0);
  tmpvar_26 = tmpvar_27;
  mediump float tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_22, viewDir_24), 0.0, 1.0);
  tmpvar_28 = tmpvar_29;
  highp vec2 tmpvar_30;
  tmpvar_30.x = dot ((viewDir_24 - (2.0 * 
    (dot (tmpvar_22, viewDir_24) * tmpvar_22)
  )), lightDir_7);
  tmpvar_30.y = (1.0 - tmpvar_28);
  highp vec2 tmpvar_31;
  tmpvar_31 = ((tmpvar_30 * tmpvar_30) * (tmpvar_30 * tmpvar_30));
  rlPow4AndFresnelTerm_25 = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = rlPow4AndFresnelTerm_25.x;
  mediump float specular_33;
  highp float smoothness_34;
  smoothness_34 = tmpvar_21;
  highp vec2 tmpvar_35;
  tmpvar_35.x = tmpvar_32;
  tmpvar_35.y = (1.0 - smoothness_34);
  highp float tmpvar_36;
  tmpvar_36 = (texture2D (unity_NHxRoughness, tmpvar_35).w * 16.0);
  specular_33 = tmpvar_36;
  mediump vec4 tmpvar_37;
  tmpvar_37.w = 1.0;
  tmpvar_37.xyz = ((gbuffer0_4.xyz + (specular_33 * gbuffer1_3.xyz)) * (tmpvar_5 * tmpvar_26));
  mediump vec4 tmpvar_38;
  tmpvar_38 = exp2(-(tmpvar_37));
  tmpvar_1 = tmpvar_38;
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((shadowAttenuation_15 + tmpvar_13), 0.0, 1.0);
  atten_6 = tmpvar_17;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_20;
  mediump float tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_21 = gbuffer1_3.w;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_22 = tmpvar_23;
  mediump vec3 color_24;
  highp float specularTerm_25;
  highp float a2_26;
  mediump float roughness_27;
  mediump float perceptualRoughness_28;
  highp vec3 tmpvar_29;
  highp vec3 inVec_30;
  inVec_30 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_29 = (inVec_30 * inversesqrt(max (0.001, 
    dot (inVec_30, inVec_30)
  )));
  mediump float tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_22, lightDir_7), 0.0, 1.0);
  tmpvar_31 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_22, tmpvar_29), 0.0, 1.0);
  highp float tmpvar_34;
  highp float smoothness_35;
  smoothness_35 = tmpvar_21;
  tmpvar_34 = (1.0 - smoothness_35);
  perceptualRoughness_28 = tmpvar_34;
  highp float tmpvar_36;
  highp float perceptualRoughness_37;
  perceptualRoughness_37 = perceptualRoughness_28;
  tmpvar_36 = (perceptualRoughness_37 * perceptualRoughness_37);
  roughness_27 = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = (roughness_27 * roughness_27);
  a2_26 = tmpvar_38;
  specularTerm_25 = ((roughness_27 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_29), 0.0, 1.0)) * (1.5 + roughness_27))
   * 
    (((tmpvar_33 * tmpvar_33) * (a2_26 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_39;
  tmpvar_39 = clamp (specularTerm_25, 0.0, 100.0);
  specularTerm_25 = tmpvar_39;
  highp vec3 tmpvar_40;
  tmpvar_40 = (((gbuffer0_4.xyz + 
    (tmpvar_39 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_31);
  color_24 = tmpvar_40;
  mediump vec4 tmpvar_41;
  tmpvar_41.w = 1.0;
  tmpvar_41.xyz = color_24;
  mediump vec4 tmpvar_42;
  tmpvar_42 = exp2(-(tmpvar_41));
  tmpvar_1 = tmpvar_42;
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((shadowAttenuation_15 + tmpvar_13), 0.0, 1.0);
  atten_6 = tmpvar_17;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_20;
  mediump float tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_21 = gbuffer1_3.w;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_22 = tmpvar_23;
  mediump vec3 color_24;
  highp float specularTerm_25;
  highp float a2_26;
  mediump float roughness_27;
  mediump float perceptualRoughness_28;
  highp vec3 tmpvar_29;
  highp vec3 inVec_30;
  inVec_30 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_29 = (inVec_30 * inversesqrt(max (0.001, 
    dot (inVec_30, inVec_30)
  )));
  mediump float tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_22, lightDir_7), 0.0, 1.0);
  tmpvar_31 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_22, tmpvar_29), 0.0, 1.0);
  highp float tmpvar_34;
  highp float smoothness_35;
  smoothness_35 = tmpvar_21;
  tmpvar_34 = (1.0 - smoothness_35);
  perceptualRoughness_28 = tmpvar_34;
  highp float tmpvar_36;
  highp float perceptualRoughness_37;
  perceptualRoughness_37 = perceptualRoughness_28;
  tmpvar_36 = (perceptualRoughness_37 * perceptualRoughness_37);
  roughness_27 = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = (roughness_27 * roughness_27);
  a2_26 = tmpvar_38;
  specularTerm_25 = ((roughness_27 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_29), 0.0, 1.0)) * (1.5 + roughness_27))
   * 
    (((tmpvar_33 * tmpvar_33) * (a2_26 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_39;
  tmpvar_39 = clamp (specularTerm_25, 0.0, 100.0);
  specularTerm_25 = tmpvar_39;
  highp vec3 tmpvar_40;
  tmpvar_40 = (((gbuffer0_4.xyz + 
    (tmpvar_39 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_31);
  color_24 = tmpvar_40;
  mediump vec4 tmpvar_41;
  tmpvar_41.w = 1.0;
  tmpvar_41.xyz = color_24;
  mediump vec4 tmpvar_42;
  tmpvar_42 = exp2(-(tmpvar_41));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles " {
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((shadowAttenuation_15 + tmpvar_13), 0.0, 1.0);
  atten_6 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_10;
  highp vec4 tmpvar_19;
  tmpvar_19.zw = vec2(0.0, -8.0);
  tmpvar_19.xy = (unity_WorldToLight * tmpvar_18).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_19.xy, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  mediump float tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_23 = gbuffer1_3.w;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_24 = tmpvar_25;
  highp vec3 viewDir_26;
  viewDir_26 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_27;
  mediump float tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_24, lightDir_7), 0.0, 1.0);
  tmpvar_28 = tmpvar_29;
  mediump float tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp (dot (tmpvar_24, viewDir_26), 0.0, 1.0);
  tmpvar_30 = tmpvar_31;
  highp vec2 tmpvar_32;
  tmpvar_32.x = dot ((viewDir_26 - (2.0 * 
    (dot (tmpvar_24, viewDir_26) * tmpvar_24)
  )), lightDir_7);
  tmpvar_32.y = (1.0 - tmpvar_30);
  highp vec2 tmpvar_33;
  tmpvar_33 = ((tmpvar_32 * tmpvar_32) * (tmpvar_32 * tmpvar_32));
  rlPow4AndFresnelTerm_27 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = rlPow4AndFresnelTerm_27.x;
  mediump float specular_35;
  highp float smoothness_36;
  smoothness_36 = tmpvar_23;
  highp vec2 tmpvar_37;
  tmpvar_37.x = tmpvar_34;
  tmpvar_37.y = (1.0 - smoothness_36);
  highp float tmpvar_38;
  tmpvar_38 = (texture2D (unity_NHxRoughness, tmpvar_37).w * 16.0);
  specular_35 = tmpvar_38;
  mediump vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = ((gbuffer0_4.xyz + (specular_35 * gbuffer1_3.xyz)) * (tmpvar_5 * tmpvar_28));
  mediump vec4 tmpvar_40;
  tmpvar_40 = exp2(-(tmpvar_39));
  tmpvar_1 = tmpvar_40;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((shadowAttenuation_15 + tmpvar_13), 0.0, 1.0);
  atten_6 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_10;
  highp vec4 tmpvar_19;
  tmpvar_19.zw = vec2(0.0, -8.0);
  tmpvar_19.xy = (unity_WorldToLight * tmpvar_18).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_19.xy, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  mediump float tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_23 = gbuffer1_3.w;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_24 = tmpvar_25;
  mediump vec3 color_26;
  highp float specularTerm_27;
  highp float a2_28;
  mediump float roughness_29;
  mediump float perceptualRoughness_30;
  highp vec3 tmpvar_31;
  highp vec3 inVec_32;
  inVec_32 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_31 = (inVec_32 * inversesqrt(max (0.001, 
    dot (inVec_32, inVec_32)
  )));
  mediump float tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_24, lightDir_7), 0.0, 1.0);
  tmpvar_33 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp (dot (tmpvar_24, tmpvar_31), 0.0, 1.0);
  highp float tmpvar_36;
  highp float smoothness_37;
  smoothness_37 = tmpvar_23;
  tmpvar_36 = (1.0 - smoothness_37);
  perceptualRoughness_30 = tmpvar_36;
  highp float tmpvar_38;
  highp float perceptualRoughness_39;
  perceptualRoughness_39 = perceptualRoughness_30;
  tmpvar_38 = (perceptualRoughness_39 * perceptualRoughness_39);
  roughness_29 = tmpvar_38;
  mediump float tmpvar_40;
  tmpvar_40 = (roughness_29 * roughness_29);
  a2_28 = tmpvar_40;
  specularTerm_27 = ((roughness_29 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_31), 0.0, 1.0)) * (1.5 + roughness_29))
   * 
    (((tmpvar_35 * tmpvar_35) * (a2_28 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_41;
  tmpvar_41 = clamp (specularTerm_27, 0.0, 100.0);
  specularTerm_27 = tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_42 = (((gbuffer0_4.xyz + 
    (tmpvar_41 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_33);
  color_26 = tmpvar_42;
  mediump vec4 tmpvar_43;
  tmpvar_43.w = 1.0;
  tmpvar_43.xyz = color_26;
  mediump vec4 tmpvar_44;
  tmpvar_44 = exp2(-(tmpvar_43));
  tmpvar_1 = tmpvar_44;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((shadowAttenuation_15 + tmpvar_13), 0.0, 1.0);
  atten_6 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_10;
  highp vec4 tmpvar_19;
  tmpvar_19.zw = vec2(0.0, -8.0);
  tmpvar_19.xy = (unity_WorldToLight * tmpvar_18).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_19.xy, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  mediump float tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_23 = gbuffer1_3.w;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_24 = tmpvar_25;
  mediump vec3 color_26;
  highp float specularTerm_27;
  highp float a2_28;
  mediump float roughness_29;
  mediump float perceptualRoughness_30;
  highp vec3 tmpvar_31;
  highp vec3 inVec_32;
  inVec_32 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_31 = (inVec_32 * inversesqrt(max (0.001, 
    dot (inVec_32, inVec_32)
  )));
  mediump float tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_24, lightDir_7), 0.0, 1.0);
  tmpvar_33 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp (dot (tmpvar_24, tmpvar_31), 0.0, 1.0);
  highp float tmpvar_36;
  highp float smoothness_37;
  smoothness_37 = tmpvar_23;
  tmpvar_36 = (1.0 - smoothness_37);
  perceptualRoughness_30 = tmpvar_36;
  highp float tmpvar_38;
  highp float perceptualRoughness_39;
  perceptualRoughness_39 = perceptualRoughness_30;
  tmpvar_38 = (perceptualRoughness_39 * perceptualRoughness_39);
  roughness_29 = tmpvar_38;
  mediump float tmpvar_40;
  tmpvar_40 = (roughness_29 * roughness_29);
  a2_28 = tmpvar_40;
  specularTerm_27 = ((roughness_29 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_31), 0.0, 1.0)) * (1.5 + roughness_29))
   * 
    (((tmpvar_35 * tmpvar_35) * (a2_28 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_41;
  tmpvar_41 = clamp (specularTerm_27, 0.0, 100.0);
  specularTerm_27 = tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_42 = (((gbuffer0_4.xyz + 
    (tmpvar_41 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_33);
  color_26 = tmpvar_42;
  mediump vec4 tmpvar_43;
  tmpvar_43.w = 1.0;
  tmpvar_43.xyz = color_26;
  mediump vec4 tmpvar_44;
  tmpvar_44 = exp2(-(tmpvar_43));
  tmpvar_1 = tmpvar_44;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles " {
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = clamp ((tmpvar_22 + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_23);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_26;
  mediump float tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_27 = gbuffer1_3.w;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_28 = tmpvar_29;
  highp vec3 viewDir_30;
  viewDir_30 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_31;
  mediump float tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_28, lightDir_7), 0.0, 1.0);
  tmpvar_32 = tmpvar_33;
  mediump float tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp (dot (tmpvar_28, viewDir_30), 0.0, 1.0);
  tmpvar_34 = tmpvar_35;
  highp vec2 tmpvar_36;
  tmpvar_36.x = dot ((viewDir_30 - (2.0 * 
    (dot (tmpvar_28, viewDir_30) * tmpvar_28)
  )), lightDir_7);
  tmpvar_36.y = (1.0 - tmpvar_34);
  highp vec2 tmpvar_37;
  tmpvar_37 = ((tmpvar_36 * tmpvar_36) * (tmpvar_36 * tmpvar_36));
  rlPow4AndFresnelTerm_31 = tmpvar_37;
  mediump float tmpvar_38;
  tmpvar_38 = rlPow4AndFresnelTerm_31.x;
  mediump float specular_39;
  highp float smoothness_40;
  smoothness_40 = tmpvar_27;
  highp vec2 tmpvar_41;
  tmpvar_41.x = tmpvar_38;
  tmpvar_41.y = (1.0 - smoothness_40);
  highp float tmpvar_42;
  tmpvar_42 = (texture2D (unity_NHxRoughness, tmpvar_41).w * 16.0);
  specular_39 = tmpvar_42;
  mediump vec4 tmpvar_43;
  tmpvar_43.w = 1.0;
  tmpvar_43.xyz = ((gbuffer0_4.xyz + (specular_39 * gbuffer1_3.xyz)) * (tmpvar_5 * tmpvar_32));
  mediump vec4 tmpvar_44;
  tmpvar_44 = exp2(-(tmpvar_43));
  tmpvar_1 = tmpvar_44;
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = clamp ((tmpvar_22 + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_23);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_26;
  mediump float tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_27 = gbuffer1_3.w;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_28 = tmpvar_29;
  mediump vec3 color_30;
  highp float specularTerm_31;
  highp float a2_32;
  mediump float roughness_33;
  mediump float perceptualRoughness_34;
  highp vec3 tmpvar_35;
  highp vec3 inVec_36;
  inVec_36 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_35 = (inVec_36 * inversesqrt(max (0.001, 
    dot (inVec_36, inVec_36)
  )));
  mediump float tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = clamp (dot (tmpvar_28, lightDir_7), 0.0, 1.0);
  tmpvar_37 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (tmpvar_28, tmpvar_35), 0.0, 1.0);
  highp float tmpvar_40;
  highp float smoothness_41;
  smoothness_41 = tmpvar_27;
  tmpvar_40 = (1.0 - smoothness_41);
  perceptualRoughness_34 = tmpvar_40;
  highp float tmpvar_42;
  highp float perceptualRoughness_43;
  perceptualRoughness_43 = perceptualRoughness_34;
  tmpvar_42 = (perceptualRoughness_43 * perceptualRoughness_43);
  roughness_33 = tmpvar_42;
  mediump float tmpvar_44;
  tmpvar_44 = (roughness_33 * roughness_33);
  a2_32 = tmpvar_44;
  specularTerm_31 = ((roughness_33 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_35), 0.0, 1.0)) * (1.5 + roughness_33))
   * 
    (((tmpvar_39 * tmpvar_39) * (a2_32 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_45;
  tmpvar_45 = clamp (specularTerm_31, 0.0, 100.0);
  specularTerm_31 = tmpvar_45;
  highp vec3 tmpvar_46;
  tmpvar_46 = (((gbuffer0_4.xyz + 
    (tmpvar_45 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_37);
  color_30 = tmpvar_46;
  mediump vec4 tmpvar_47;
  tmpvar_47.w = 1.0;
  tmpvar_47.xyz = color_30;
  mediump vec4 tmpvar_48;
  tmpvar_48 = exp2(-(tmpvar_47));
  tmpvar_1 = tmpvar_48;
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = clamp ((tmpvar_22 + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_23);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_26;
  mediump float tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_27 = gbuffer1_3.w;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_28 = tmpvar_29;
  mediump vec3 color_30;
  highp float specularTerm_31;
  highp float a2_32;
  mediump float roughness_33;
  mediump float perceptualRoughness_34;
  highp vec3 tmpvar_35;
  highp vec3 inVec_36;
  inVec_36 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_35 = (inVec_36 * inversesqrt(max (0.001, 
    dot (inVec_36, inVec_36)
  )));
  mediump float tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = clamp (dot (tmpvar_28, lightDir_7), 0.0, 1.0);
  tmpvar_37 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (tmpvar_28, tmpvar_35), 0.0, 1.0);
  highp float tmpvar_40;
  highp float smoothness_41;
  smoothness_41 = tmpvar_27;
  tmpvar_40 = (1.0 - smoothness_41);
  perceptualRoughness_34 = tmpvar_40;
  highp float tmpvar_42;
  highp float perceptualRoughness_43;
  perceptualRoughness_43 = perceptualRoughness_34;
  tmpvar_42 = (perceptualRoughness_43 * perceptualRoughness_43);
  roughness_33 = tmpvar_42;
  mediump float tmpvar_44;
  tmpvar_44 = (roughness_33 * roughness_33);
  a2_32 = tmpvar_44;
  specularTerm_31 = ((roughness_33 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_35), 0.0, 1.0)) * (1.5 + roughness_33))
   * 
    (((tmpvar_39 * tmpvar_39) * (a2_32 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_45;
  tmpvar_45 = clamp (specularTerm_31, 0.0, 100.0);
  specularTerm_31 = tmpvar_45;
  highp vec3 tmpvar_46;
  tmpvar_46 = (((gbuffer0_4.xyz + 
    (tmpvar_45 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_37);
  color_30 = tmpvar_46;
  mediump vec4 tmpvar_47;
  tmpvar_47.w = 1.0;
  tmpvar_47.xyz = color_30;
  mediump vec4 tmpvar_48;
  tmpvar_48 = exp2(-(tmpvar_47));
  tmpvar_1 = tmpvar_48;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles " {
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = clamp ((dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_38);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_41;
  mediump float tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_42 = gbuffer1_3.w;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_43 = tmpvar_44;
  highp vec3 viewDir_45;
  viewDir_45 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_46;
  mediump float tmpvar_47;
  highp float tmpvar_48;
  tmpvar_48 = clamp (dot (tmpvar_43, lightDir_7), 0.0, 1.0);
  tmpvar_47 = tmpvar_48;
  mediump float tmpvar_49;
  highp float tmpvar_50;
  tmpvar_50 = clamp (dot (tmpvar_43, viewDir_45), 0.0, 1.0);
  tmpvar_49 = tmpvar_50;
  highp vec2 tmpvar_51;
  tmpvar_51.x = dot ((viewDir_45 - (2.0 * 
    (dot (tmpvar_43, viewDir_45) * tmpvar_43)
  )), lightDir_7);
  tmpvar_51.y = (1.0 - tmpvar_49);
  highp vec2 tmpvar_52;
  tmpvar_52 = ((tmpvar_51 * tmpvar_51) * (tmpvar_51 * tmpvar_51));
  rlPow4AndFresnelTerm_46 = tmpvar_52;
  mediump float tmpvar_53;
  tmpvar_53 = rlPow4AndFresnelTerm_46.x;
  mediump float specular_54;
  highp float smoothness_55;
  smoothness_55 = tmpvar_42;
  highp vec2 tmpvar_56;
  tmpvar_56.x = tmpvar_53;
  tmpvar_56.y = (1.0 - smoothness_55);
  highp float tmpvar_57;
  tmpvar_57 = (texture2D (unity_NHxRoughness, tmpvar_56).w * 16.0);
  specular_54 = tmpvar_57;
  mediump vec4 tmpvar_58;
  tmpvar_58.w = 1.0;
  tmpvar_58.xyz = ((gbuffer0_4.xyz + (specular_54 * gbuffer1_3.xyz)) * (tmpvar_5 * tmpvar_47));
  mediump vec4 tmpvar_59;
  tmpvar_59 = exp2(-(tmpvar_58));
  tmpvar_1 = tmpvar_59;
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = clamp ((dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_38);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_41;
  mediump float tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_42 = gbuffer1_3.w;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_43 = tmpvar_44;
  mediump vec3 color_45;
  highp float specularTerm_46;
  highp float a2_47;
  mediump float roughness_48;
  mediump float perceptualRoughness_49;
  highp vec3 tmpvar_50;
  highp vec3 inVec_51;
  inVec_51 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_50 = (inVec_51 * inversesqrt(max (0.001, 
    dot (inVec_51, inVec_51)
  )));
  mediump float tmpvar_52;
  highp float tmpvar_53;
  tmpvar_53 = clamp (dot (tmpvar_43, lightDir_7), 0.0, 1.0);
  tmpvar_52 = tmpvar_53;
  highp float tmpvar_54;
  tmpvar_54 = clamp (dot (tmpvar_43, tmpvar_50), 0.0, 1.0);
  highp float tmpvar_55;
  highp float smoothness_56;
  smoothness_56 = tmpvar_42;
  tmpvar_55 = (1.0 - smoothness_56);
  perceptualRoughness_49 = tmpvar_55;
  highp float tmpvar_57;
  highp float perceptualRoughness_58;
  perceptualRoughness_58 = perceptualRoughness_49;
  tmpvar_57 = (perceptualRoughness_58 * perceptualRoughness_58);
  roughness_48 = tmpvar_57;
  mediump float tmpvar_59;
  tmpvar_59 = (roughness_48 * roughness_48);
  a2_47 = tmpvar_59;
  specularTerm_46 = ((roughness_48 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_50), 0.0, 1.0)) * (1.5 + roughness_48))
   * 
    (((tmpvar_54 * tmpvar_54) * (a2_47 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_60;
  tmpvar_60 = clamp (specularTerm_46, 0.0, 100.0);
  specularTerm_46 = tmpvar_60;
  highp vec3 tmpvar_61;
  tmpvar_61 = (((gbuffer0_4.xyz + 
    (tmpvar_60 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_52);
  color_45 = tmpvar_61;
  mediump vec4 tmpvar_62;
  tmpvar_62.w = 1.0;
  tmpvar_62.xyz = color_45;
  mediump vec4 tmpvar_63;
  tmpvar_63 = exp2(-(tmpvar_62));
  tmpvar_1 = tmpvar_63;
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = clamp ((dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_38);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_41;
  mediump float tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_42 = gbuffer1_3.w;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_43 = tmpvar_44;
  mediump vec3 color_45;
  highp float specularTerm_46;
  highp float a2_47;
  mediump float roughness_48;
  mediump float perceptualRoughness_49;
  highp vec3 tmpvar_50;
  highp vec3 inVec_51;
  inVec_51 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_50 = (inVec_51 * inversesqrt(max (0.001, 
    dot (inVec_51, inVec_51)
  )));
  mediump float tmpvar_52;
  highp float tmpvar_53;
  tmpvar_53 = clamp (dot (tmpvar_43, lightDir_7), 0.0, 1.0);
  tmpvar_52 = tmpvar_53;
  highp float tmpvar_54;
  tmpvar_54 = clamp (dot (tmpvar_43, tmpvar_50), 0.0, 1.0);
  highp float tmpvar_55;
  highp float smoothness_56;
  smoothness_56 = tmpvar_42;
  tmpvar_55 = (1.0 - smoothness_56);
  perceptualRoughness_49 = tmpvar_55;
  highp float tmpvar_57;
  highp float perceptualRoughness_58;
  perceptualRoughness_58 = perceptualRoughness_49;
  tmpvar_57 = (perceptualRoughness_58 * perceptualRoughness_58);
  roughness_48 = tmpvar_57;
  mediump float tmpvar_59;
  tmpvar_59 = (roughness_48 * roughness_48);
  a2_47 = tmpvar_59;
  specularTerm_46 = ((roughness_48 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_50), 0.0, 1.0)) * (1.5 + roughness_48))
   * 
    (((tmpvar_54 * tmpvar_54) * (a2_47 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_60;
  tmpvar_60 = clamp (specularTerm_46, 0.0, 100.0);
  specularTerm_46 = tmpvar_60;
  highp vec3 tmpvar_61;
  tmpvar_61 = (((gbuffer0_4.xyz + 
    (tmpvar_60 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_52);
  color_45 = tmpvar_61;
  mediump vec4 tmpvar_62;
  tmpvar_62.w = 1.0;
  tmpvar_62.xyz = color_45;
  mediump vec4 tmpvar_63;
  tmpvar_63 = exp2(-(tmpvar_62));
  tmpvar_1 = tmpvar_63;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles " {
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = clamp ((tmpvar_22 + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_23);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25.w = -8.0;
  tmpvar_25.xyz = (unity_WorldToLight * tmpvar_24).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_25.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump float tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_29 = gbuffer1_3.w;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_30 = tmpvar_31;
  highp vec3 viewDir_32;
  viewDir_32 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_33;
  mediump float tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp (dot (tmpvar_30, lightDir_7), 0.0, 1.0);
  tmpvar_34 = tmpvar_35;
  mediump float tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_30, viewDir_32), 0.0, 1.0);
  tmpvar_36 = tmpvar_37;
  highp vec2 tmpvar_38;
  tmpvar_38.x = dot ((viewDir_32 - (2.0 * 
    (dot (tmpvar_30, viewDir_32) * tmpvar_30)
  )), lightDir_7);
  tmpvar_38.y = (1.0 - tmpvar_36);
  highp vec2 tmpvar_39;
  tmpvar_39 = ((tmpvar_38 * tmpvar_38) * (tmpvar_38 * tmpvar_38));
  rlPow4AndFresnelTerm_33 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = rlPow4AndFresnelTerm_33.x;
  mediump float specular_41;
  highp float smoothness_42;
  smoothness_42 = tmpvar_29;
  highp vec2 tmpvar_43;
  tmpvar_43.x = tmpvar_40;
  tmpvar_43.y = (1.0 - smoothness_42);
  highp float tmpvar_44;
  tmpvar_44 = (texture2D (unity_NHxRoughness, tmpvar_43).w * 16.0);
  specular_41 = tmpvar_44;
  mediump vec4 tmpvar_45;
  tmpvar_45.w = 1.0;
  tmpvar_45.xyz = ((gbuffer0_4.xyz + (specular_41 * gbuffer1_3.xyz)) * (tmpvar_5 * tmpvar_34));
  mediump vec4 tmpvar_46;
  tmpvar_46 = exp2(-(tmpvar_45));
  tmpvar_1 = tmpvar_46;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = clamp ((tmpvar_22 + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_23);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25.w = -8.0;
  tmpvar_25.xyz = (unity_WorldToLight * tmpvar_24).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_25.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump float tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_29 = gbuffer1_3.w;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_30 = tmpvar_31;
  mediump vec3 color_32;
  highp float specularTerm_33;
  highp float a2_34;
  mediump float roughness_35;
  mediump float perceptualRoughness_36;
  highp vec3 tmpvar_37;
  highp vec3 inVec_38;
  inVec_38 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_37 = (inVec_38 * inversesqrt(max (0.001, 
    dot (inVec_38, inVec_38)
  )));
  mediump float tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_30, lightDir_7), 0.0, 1.0);
  tmpvar_39 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = clamp (dot (tmpvar_30, tmpvar_37), 0.0, 1.0);
  highp float tmpvar_42;
  highp float smoothness_43;
  smoothness_43 = tmpvar_29;
  tmpvar_42 = (1.0 - smoothness_43);
  perceptualRoughness_36 = tmpvar_42;
  highp float tmpvar_44;
  highp float perceptualRoughness_45;
  perceptualRoughness_45 = perceptualRoughness_36;
  tmpvar_44 = (perceptualRoughness_45 * perceptualRoughness_45);
  roughness_35 = tmpvar_44;
  mediump float tmpvar_46;
  tmpvar_46 = (roughness_35 * roughness_35);
  a2_34 = tmpvar_46;
  specularTerm_33 = ((roughness_35 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_37), 0.0, 1.0)) * (1.5 + roughness_35))
   * 
    (((tmpvar_41 * tmpvar_41) * (a2_34 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_47;
  tmpvar_47 = clamp (specularTerm_33, 0.0, 100.0);
  specularTerm_33 = tmpvar_47;
  highp vec3 tmpvar_48;
  tmpvar_48 = (((gbuffer0_4.xyz + 
    (tmpvar_47 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_39);
  color_32 = tmpvar_48;
  mediump vec4 tmpvar_49;
  tmpvar_49.w = 1.0;
  tmpvar_49.xyz = color_32;
  mediump vec4 tmpvar_50;
  tmpvar_50 = exp2(-(tmpvar_49));
  tmpvar_1 = tmpvar_50;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = clamp ((tmpvar_22 + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_23);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25.w = -8.0;
  tmpvar_25.xyz = (unity_WorldToLight * tmpvar_24).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_25.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump float tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_29 = gbuffer1_3.w;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_30 = tmpvar_31;
  mediump vec3 color_32;
  highp float specularTerm_33;
  highp float a2_34;
  mediump float roughness_35;
  mediump float perceptualRoughness_36;
  highp vec3 tmpvar_37;
  highp vec3 inVec_38;
  inVec_38 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_37 = (inVec_38 * inversesqrt(max (0.001, 
    dot (inVec_38, inVec_38)
  )));
  mediump float tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_30, lightDir_7), 0.0, 1.0);
  tmpvar_39 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = clamp (dot (tmpvar_30, tmpvar_37), 0.0, 1.0);
  highp float tmpvar_42;
  highp float smoothness_43;
  smoothness_43 = tmpvar_29;
  tmpvar_42 = (1.0 - smoothness_43);
  perceptualRoughness_36 = tmpvar_42;
  highp float tmpvar_44;
  highp float perceptualRoughness_45;
  perceptualRoughness_45 = perceptualRoughness_36;
  tmpvar_44 = (perceptualRoughness_45 * perceptualRoughness_45);
  roughness_35 = tmpvar_44;
  mediump float tmpvar_46;
  tmpvar_46 = (roughness_35 * roughness_35);
  a2_34 = tmpvar_46;
  specularTerm_33 = ((roughness_35 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_37), 0.0, 1.0)) * (1.5 + roughness_35))
   * 
    (((tmpvar_41 * tmpvar_41) * (a2_34 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_47;
  tmpvar_47 = clamp (specularTerm_33, 0.0, 100.0);
  specularTerm_33 = tmpvar_47;
  highp vec3 tmpvar_48;
  tmpvar_48 = (((gbuffer0_4.xyz + 
    (tmpvar_47 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_39);
  color_32 = tmpvar_48;
  mediump vec4 tmpvar_49;
  tmpvar_49.w = 1.0;
  tmpvar_49.xyz = color_32;
  mediump vec4 tmpvar_50;
  tmpvar_50 = exp2(-(tmpvar_49));
  tmpvar_1 = tmpvar_50;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles " {
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = clamp ((dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_38);
  highp vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = tmpvar_10;
  highp vec4 tmpvar_40;
  tmpvar_40.w = -8.0;
  tmpvar_40.xyz = (unity_WorldToLight * tmpvar_39).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_40.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_42;
  lowp vec4 tmpvar_43;
  tmpvar_43 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_43;
  mediump float tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_44 = gbuffer1_3.w;
  mediump vec3 tmpvar_46;
  tmpvar_46 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_45 = tmpvar_46;
  highp vec3 viewDir_47;
  viewDir_47 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_48;
  mediump float tmpvar_49;
  highp float tmpvar_50;
  tmpvar_50 = clamp (dot (tmpvar_45, lightDir_7), 0.0, 1.0);
  tmpvar_49 = tmpvar_50;
  mediump float tmpvar_51;
  highp float tmpvar_52;
  tmpvar_52 = clamp (dot (tmpvar_45, viewDir_47), 0.0, 1.0);
  tmpvar_51 = tmpvar_52;
  highp vec2 tmpvar_53;
  tmpvar_53.x = dot ((viewDir_47 - (2.0 * 
    (dot (tmpvar_45, viewDir_47) * tmpvar_45)
  )), lightDir_7);
  tmpvar_53.y = (1.0 - tmpvar_51);
  highp vec2 tmpvar_54;
  tmpvar_54 = ((tmpvar_53 * tmpvar_53) * (tmpvar_53 * tmpvar_53));
  rlPow4AndFresnelTerm_48 = tmpvar_54;
  mediump float tmpvar_55;
  tmpvar_55 = rlPow4AndFresnelTerm_48.x;
  mediump float specular_56;
  highp float smoothness_57;
  smoothness_57 = tmpvar_44;
  highp vec2 tmpvar_58;
  tmpvar_58.x = tmpvar_55;
  tmpvar_58.y = (1.0 - smoothness_57);
  highp float tmpvar_59;
  tmpvar_59 = (texture2D (unity_NHxRoughness, tmpvar_58).w * 16.0);
  specular_56 = tmpvar_59;
  mediump vec4 tmpvar_60;
  tmpvar_60.w = 1.0;
  tmpvar_60.xyz = ((gbuffer0_4.xyz + (specular_56 * gbuffer1_3.xyz)) * (tmpvar_5 * tmpvar_49));
  mediump vec4 tmpvar_61;
  tmpvar_61 = exp2(-(tmpvar_60));
  tmpvar_1 = tmpvar_61;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = clamp ((dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_38);
  highp vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = tmpvar_10;
  highp vec4 tmpvar_40;
  tmpvar_40.w = -8.0;
  tmpvar_40.xyz = (unity_WorldToLight * tmpvar_39).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_40.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_42;
  lowp vec4 tmpvar_43;
  tmpvar_43 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_43;
  mediump float tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_44 = gbuffer1_3.w;
  mediump vec3 tmpvar_46;
  tmpvar_46 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_45 = tmpvar_46;
  mediump vec3 color_47;
  highp float specularTerm_48;
  highp float a2_49;
  mediump float roughness_50;
  mediump float perceptualRoughness_51;
  highp vec3 tmpvar_52;
  highp vec3 inVec_53;
  inVec_53 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_52 = (inVec_53 * inversesqrt(max (0.001, 
    dot (inVec_53, inVec_53)
  )));
  mediump float tmpvar_54;
  highp float tmpvar_55;
  tmpvar_55 = clamp (dot (tmpvar_45, lightDir_7), 0.0, 1.0);
  tmpvar_54 = tmpvar_55;
  highp float tmpvar_56;
  tmpvar_56 = clamp (dot (tmpvar_45, tmpvar_52), 0.0, 1.0);
  highp float tmpvar_57;
  highp float smoothness_58;
  smoothness_58 = tmpvar_44;
  tmpvar_57 = (1.0 - smoothness_58);
  perceptualRoughness_51 = tmpvar_57;
  highp float tmpvar_59;
  highp float perceptualRoughness_60;
  perceptualRoughness_60 = perceptualRoughness_51;
  tmpvar_59 = (perceptualRoughness_60 * perceptualRoughness_60);
  roughness_50 = tmpvar_59;
  mediump float tmpvar_61;
  tmpvar_61 = (roughness_50 * roughness_50);
  a2_49 = tmpvar_61;
  specularTerm_48 = ((roughness_50 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_52), 0.0, 1.0)) * (1.5 + roughness_50))
   * 
    (((tmpvar_56 * tmpvar_56) * (a2_49 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_62;
  tmpvar_62 = clamp (specularTerm_48, 0.0, 100.0);
  specularTerm_48 = tmpvar_62;
  highp vec3 tmpvar_63;
  tmpvar_63 = (((gbuffer0_4.xyz + 
    (tmpvar_62 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_54);
  color_47 = tmpvar_63;
  mediump vec4 tmpvar_64;
  tmpvar_64.w = 1.0;
  tmpvar_64.xyz = color_47;
  mediump vec4 tmpvar_65;
  tmpvar_65 = exp2(-(tmpvar_64));
  tmpvar_1 = tmpvar_65;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = clamp ((dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_38);
  highp vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = tmpvar_10;
  highp vec4 tmpvar_40;
  tmpvar_40.w = -8.0;
  tmpvar_40.xyz = (unity_WorldToLight * tmpvar_39).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_40.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_42;
  lowp vec4 tmpvar_43;
  tmpvar_43 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_43;
  mediump float tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_44 = gbuffer1_3.w;
  mediump vec3 tmpvar_46;
  tmpvar_46 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_45 = tmpvar_46;
  mediump vec3 color_47;
  highp float specularTerm_48;
  highp float a2_49;
  mediump float roughness_50;
  mediump float perceptualRoughness_51;
  highp vec3 tmpvar_52;
  highp vec3 inVec_53;
  inVec_53 = (lightDir_7 - normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  tmpvar_52 = (inVec_53 * inversesqrt(max (0.001, 
    dot (inVec_53, inVec_53)
  )));
  mediump float tmpvar_54;
  highp float tmpvar_55;
  tmpvar_55 = clamp (dot (tmpvar_45, lightDir_7), 0.0, 1.0);
  tmpvar_54 = tmpvar_55;
  highp float tmpvar_56;
  tmpvar_56 = clamp (dot (tmpvar_45, tmpvar_52), 0.0, 1.0);
  highp float tmpvar_57;
  highp float smoothness_58;
  smoothness_58 = tmpvar_44;
  tmpvar_57 = (1.0 - smoothness_58);
  perceptualRoughness_51 = tmpvar_57;
  highp float tmpvar_59;
  highp float perceptualRoughness_60;
  perceptualRoughness_60 = perceptualRoughness_51;
  tmpvar_59 = (perceptualRoughness_60 * perceptualRoughness_60);
  roughness_50 = tmpvar_59;
  mediump float tmpvar_61;
  tmpvar_61 = (roughness_50 * roughness_50);
  a2_49 = tmpvar_61;
  specularTerm_48 = ((roughness_50 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_52), 0.0, 1.0)) * (1.5 + roughness_50))
   * 
    (((tmpvar_56 * tmpvar_56) * (a2_49 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_62;
  tmpvar_62 = clamp (specularTerm_48, 0.0, 100.0);
  specularTerm_48 = tmpvar_62;
  highp vec3 tmpvar_63;
  tmpvar_63 = (((gbuffer0_4.xyz + 
    (tmpvar_62 * gbuffer1_3.xyz)
  ) * tmpvar_5) * tmpvar_54);
  color_47 = tmpvar_63;
  mediump vec4 tmpvar_64;
  tmpvar_64.w = 1.0;
  tmpvar_64.xyz = color_47;
  mediump vec4 tmpvar_65;
  tmpvar_65 = exp2(-(tmpvar_64));
  tmpvar_1 = tmpvar_65;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_14;
  mediump float tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_15 = gbuffer1_2.w;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_16 = tmpvar_17;
  highp vec3 viewDir_18;
  viewDir_18 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_19;
  mediump float tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (dot (tmpvar_16, lightDir_6), 0.0, 1.0);
  tmpvar_20 = tmpvar_21;
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_16, viewDir_18), 0.0, 1.0);
  tmpvar_22 = tmpvar_23;
  highp vec2 tmpvar_24;
  tmpvar_24.x = dot ((viewDir_18 - (2.0 * 
    (dot (tmpvar_16, viewDir_18) * tmpvar_16)
  )), lightDir_6);
  tmpvar_24.y = (1.0 - tmpvar_22);
  highp vec2 tmpvar_25;
  tmpvar_25 = ((tmpvar_24 * tmpvar_24) * (tmpvar_24 * tmpvar_24));
  rlPow4AndFresnelTerm_19 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = rlPow4AndFresnelTerm_19.x;
  mediump float specular_27;
  highp float smoothness_28;
  smoothness_28 = tmpvar_15;
  highp vec2 tmpvar_29;
  tmpvar_29.x = tmpvar_26;
  tmpvar_29.y = (1.0 - smoothness_28);
  highp float tmpvar_30;
  tmpvar_30 = (texture2D (unity_NHxRoughness, tmpvar_29).w * 16.0);
  specular_27 = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = ((gbuffer0_3.xyz + (specular_27 * gbuffer1_2.xyz)) * (tmpvar_4 * tmpvar_20));
  gl_FragData[0] = tmpvar_31;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_14;
  mediump float tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_15 = gbuffer1_2.w;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_16 = tmpvar_17;
  mediump vec3 color_18;
  highp float specularTerm_19;
  highp float a2_20;
  mediump float roughness_21;
  mediump float perceptualRoughness_22;
  highp vec3 tmpvar_23;
  highp vec3 inVec_24;
  inVec_24 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_23 = (inVec_24 * inversesqrt(max (0.001, 
    dot (inVec_24, inVec_24)
  )));
  mediump float tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_16, lightDir_6), 0.0, 1.0);
  tmpvar_25 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_16, tmpvar_23), 0.0, 1.0);
  highp float tmpvar_28;
  highp float smoothness_29;
  smoothness_29 = tmpvar_15;
  tmpvar_28 = (1.0 - smoothness_29);
  perceptualRoughness_22 = tmpvar_28;
  highp float tmpvar_30;
  highp float perceptualRoughness_31;
  perceptualRoughness_31 = perceptualRoughness_22;
  tmpvar_30 = (perceptualRoughness_31 * perceptualRoughness_31);
  roughness_21 = tmpvar_30;
  mediump float tmpvar_32;
  tmpvar_32 = (roughness_21 * roughness_21);
  a2_20 = tmpvar_32;
  specularTerm_19 = ((roughness_21 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_23), 0.0, 1.0)) * (1.5 + roughness_21))
   * 
    (((tmpvar_27 * tmpvar_27) * (a2_20 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_33;
  tmpvar_33 = clamp (specularTerm_19, 0.0, 100.0);
  specularTerm_19 = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (((gbuffer0_3.xyz + 
    (tmpvar_33 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_25);
  color_18 = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35.w = 1.0;
  tmpvar_35.xyz = color_18;
  gl_FragData[0] = tmpvar_35;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_14;
  mediump float tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_15 = gbuffer1_2.w;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_16 = tmpvar_17;
  mediump vec3 color_18;
  highp float specularTerm_19;
  highp float a2_20;
  mediump float roughness_21;
  mediump float perceptualRoughness_22;
  highp vec3 tmpvar_23;
  highp vec3 inVec_24;
  inVec_24 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_23 = (inVec_24 * inversesqrt(max (0.001, 
    dot (inVec_24, inVec_24)
  )));
  mediump float tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_16, lightDir_6), 0.0, 1.0);
  tmpvar_25 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_16, tmpvar_23), 0.0, 1.0);
  highp float tmpvar_28;
  highp float smoothness_29;
  smoothness_29 = tmpvar_15;
  tmpvar_28 = (1.0 - smoothness_29);
  perceptualRoughness_22 = tmpvar_28;
  highp float tmpvar_30;
  highp float perceptualRoughness_31;
  perceptualRoughness_31 = perceptualRoughness_22;
  tmpvar_30 = (perceptualRoughness_31 * perceptualRoughness_31);
  roughness_21 = tmpvar_30;
  mediump float tmpvar_32;
  tmpvar_32 = (roughness_21 * roughness_21);
  a2_20 = tmpvar_32;
  specularTerm_19 = ((roughness_21 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_23), 0.0, 1.0)) * (1.5 + roughness_21))
   * 
    (((tmpvar_27 * tmpvar_27) * (a2_20 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_33;
  tmpvar_33 = clamp (specularTerm_19, 0.0, 100.0);
  specularTerm_19 = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (((gbuffer0_3.xyz + 
    (tmpvar_33 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_25);
  color_18 = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35.w = 1.0;
  tmpvar_35.xyz = color_18;
  gl_FragData[0] = tmpvar_35;
}


#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_8;
  tmpvar_4 = _LightColor.xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_11;
  mediump float tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_12 = gbuffer1_2.w;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_13 = tmpvar_14;
  highp vec3 viewDir_15;
  viewDir_15 = -(normalize((
    (unity_CameraToWorld * tmpvar_7)
  .xyz - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_16;
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_13, lightDir_5), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = clamp (dot (tmpvar_13, viewDir_15), 0.0, 1.0);
  tmpvar_19 = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21.x = dot ((viewDir_15 - (2.0 * 
    (dot (tmpvar_13, viewDir_15) * tmpvar_13)
  )), lightDir_5);
  tmpvar_21.y = (1.0 - tmpvar_19);
  highp vec2 tmpvar_22;
  tmpvar_22 = ((tmpvar_21 * tmpvar_21) * (tmpvar_21 * tmpvar_21));
  rlPow4AndFresnelTerm_16 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = rlPow4AndFresnelTerm_16.x;
  mediump float specular_24;
  highp float smoothness_25;
  smoothness_25 = tmpvar_12;
  highp vec2 tmpvar_26;
  tmpvar_26.x = tmpvar_23;
  tmpvar_26.y = (1.0 - smoothness_25);
  highp float tmpvar_27;
  tmpvar_27 = (texture2D (unity_NHxRoughness, tmpvar_26).w * 16.0);
  specular_24 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((gbuffer0_3.xyz + (specular_24 * gbuffer1_2.xyz)) * (tmpvar_4 * tmpvar_17));
  gl_FragData[0] = tmpvar_28;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_8;
  tmpvar_4 = _LightColor.xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_11;
  mediump float tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_12 = gbuffer1_2.w;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_13 = tmpvar_14;
  mediump vec3 color_15;
  highp float specularTerm_16;
  highp float a2_17;
  mediump float roughness_18;
  mediump float perceptualRoughness_19;
  highp vec3 tmpvar_20;
  highp vec3 inVec_21;
  inVec_21 = (lightDir_5 - normalize((
    (unity_CameraToWorld * tmpvar_7)
  .xyz - _WorldSpaceCameraPos)));
  tmpvar_20 = (inVec_21 * inversesqrt(max (0.001, 
    dot (inVec_21, inVec_21)
  )));
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_13, lightDir_5), 0.0, 1.0);
  tmpvar_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_13, tmpvar_20), 0.0, 1.0);
  highp float tmpvar_25;
  highp float smoothness_26;
  smoothness_26 = tmpvar_12;
  tmpvar_25 = (1.0 - smoothness_26);
  perceptualRoughness_19 = tmpvar_25;
  highp float tmpvar_27;
  highp float perceptualRoughness_28;
  perceptualRoughness_28 = perceptualRoughness_19;
  tmpvar_27 = (perceptualRoughness_28 * perceptualRoughness_28);
  roughness_18 = tmpvar_27;
  mediump float tmpvar_29;
  tmpvar_29 = (roughness_18 * roughness_18);
  a2_17 = tmpvar_29;
  specularTerm_16 = ((roughness_18 / (
    (max (0.32, clamp (dot (lightDir_5, tmpvar_20), 0.0, 1.0)) * (1.5 + roughness_18))
   * 
    (((tmpvar_24 * tmpvar_24) * (a2_17 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_30;
  tmpvar_30 = clamp (specularTerm_16, 0.0, 100.0);
  specularTerm_16 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (((gbuffer0_3.xyz + 
    (tmpvar_30 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_22);
  color_15 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = color_15;
  gl_FragData[0] = tmpvar_32;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_8;
  tmpvar_4 = _LightColor.xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_11;
  mediump float tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_12 = gbuffer1_2.w;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_13 = tmpvar_14;
  mediump vec3 color_15;
  highp float specularTerm_16;
  highp float a2_17;
  mediump float roughness_18;
  mediump float perceptualRoughness_19;
  highp vec3 tmpvar_20;
  highp vec3 inVec_21;
  inVec_21 = (lightDir_5 - normalize((
    (unity_CameraToWorld * tmpvar_7)
  .xyz - _WorldSpaceCameraPos)));
  tmpvar_20 = (inVec_21 * inversesqrt(max (0.001, 
    dot (inVec_21, inVec_21)
  )));
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_13, lightDir_5), 0.0, 1.0);
  tmpvar_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_13, tmpvar_20), 0.0, 1.0);
  highp float tmpvar_25;
  highp float smoothness_26;
  smoothness_26 = tmpvar_12;
  tmpvar_25 = (1.0 - smoothness_26);
  perceptualRoughness_19 = tmpvar_25;
  highp float tmpvar_27;
  highp float perceptualRoughness_28;
  perceptualRoughness_28 = perceptualRoughness_19;
  tmpvar_27 = (perceptualRoughness_28 * perceptualRoughness_28);
  roughness_18 = tmpvar_27;
  mediump float tmpvar_29;
  tmpvar_29 = (roughness_18 * roughness_18);
  a2_17 = tmpvar_29;
  specularTerm_16 = ((roughness_18 / (
    (max (0.32, clamp (dot (lightDir_5, tmpvar_20), 0.0, 1.0)) * (1.5 + roughness_18))
   * 
    (((tmpvar_24 * tmpvar_24) * (a2_17 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_30;
  tmpvar_30 = clamp (specularTerm_16, 0.0, 100.0);
  specularTerm_16 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (((gbuffer0_3.xyz + 
    (tmpvar_30 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_22);
  color_15 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = color_15;
  gl_FragData[0] = tmpvar_32;
}


#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize(tmpvar_10);
  lightDir_6 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13 = (unity_WorldToLight * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (tmpvar_13.xy / tmpvar_13.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w * float((tmpvar_13.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_17;
  mediump float tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_18 = gbuffer1_2.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_19 = tmpvar_20;
  highp vec3 viewDir_21;
  viewDir_21 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_22;
  mediump float tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_19, lightDir_6), 0.0, 1.0);
  tmpvar_23 = tmpvar_24;
  mediump float tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_19, viewDir_21), 0.0, 1.0);
  tmpvar_25 = tmpvar_26;
  highp vec2 tmpvar_27;
  tmpvar_27.x = dot ((viewDir_21 - (2.0 * 
    (dot (tmpvar_19, viewDir_21) * tmpvar_19)
  )), lightDir_6);
  tmpvar_27.y = (1.0 - tmpvar_25);
  highp vec2 tmpvar_28;
  tmpvar_28 = ((tmpvar_27 * tmpvar_27) * (tmpvar_27 * tmpvar_27));
  rlPow4AndFresnelTerm_22 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = rlPow4AndFresnelTerm_22.x;
  mediump float specular_30;
  highp float smoothness_31;
  smoothness_31 = tmpvar_18;
  highp vec2 tmpvar_32;
  tmpvar_32.x = tmpvar_29;
  tmpvar_32.y = (1.0 - smoothness_31);
  highp float tmpvar_33;
  tmpvar_33 = (texture2D (unity_NHxRoughness, tmpvar_32).w * 16.0);
  specular_30 = tmpvar_33;
  mediump vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = ((gbuffer0_3.xyz + (specular_30 * gbuffer1_2.xyz)) * (tmpvar_4 * tmpvar_23));
  gl_FragData[0] = tmpvar_34;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize(tmpvar_10);
  lightDir_6 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13 = (unity_WorldToLight * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (tmpvar_13.xy / tmpvar_13.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w * float((tmpvar_13.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_17;
  mediump float tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_18 = gbuffer1_2.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_19 = tmpvar_20;
  mediump vec3 color_21;
  highp float specularTerm_22;
  highp float a2_23;
  mediump float roughness_24;
  mediump float perceptualRoughness_25;
  highp vec3 tmpvar_26;
  highp vec3 inVec_27;
  inVec_27 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_26 = (inVec_27 * inversesqrt(max (0.001, 
    dot (inVec_27, inVec_27)
  )));
  mediump float tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_19, lightDir_6), 0.0, 1.0);
  tmpvar_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_19, tmpvar_26), 0.0, 1.0);
  highp float tmpvar_31;
  highp float smoothness_32;
  smoothness_32 = tmpvar_18;
  tmpvar_31 = (1.0 - smoothness_32);
  perceptualRoughness_25 = tmpvar_31;
  highp float tmpvar_33;
  highp float perceptualRoughness_34;
  perceptualRoughness_34 = perceptualRoughness_25;
  tmpvar_33 = (perceptualRoughness_34 * perceptualRoughness_34);
  roughness_24 = tmpvar_33;
  mediump float tmpvar_35;
  tmpvar_35 = (roughness_24 * roughness_24);
  a2_23 = tmpvar_35;
  specularTerm_22 = ((roughness_24 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_26), 0.0, 1.0)) * (1.5 + roughness_24))
   * 
    (((tmpvar_30 * tmpvar_30) * (a2_23 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_36;
  tmpvar_36 = clamp (specularTerm_22, 0.0, 100.0);
  specularTerm_22 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (((gbuffer0_3.xyz + 
    (tmpvar_36 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_28);
  color_21 = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = color_21;
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize(tmpvar_10);
  lightDir_6 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13 = (unity_WorldToLight * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (tmpvar_13.xy / tmpvar_13.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w * float((tmpvar_13.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_17;
  mediump float tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_18 = gbuffer1_2.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_19 = tmpvar_20;
  mediump vec3 color_21;
  highp float specularTerm_22;
  highp float a2_23;
  mediump float roughness_24;
  mediump float perceptualRoughness_25;
  highp vec3 tmpvar_26;
  highp vec3 inVec_27;
  inVec_27 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_26 = (inVec_27 * inversesqrt(max (0.001, 
    dot (inVec_27, inVec_27)
  )));
  mediump float tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_19, lightDir_6), 0.0, 1.0);
  tmpvar_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_19, tmpvar_26), 0.0, 1.0);
  highp float tmpvar_31;
  highp float smoothness_32;
  smoothness_32 = tmpvar_18;
  tmpvar_31 = (1.0 - smoothness_32);
  perceptualRoughness_25 = tmpvar_31;
  highp float tmpvar_33;
  highp float perceptualRoughness_34;
  perceptualRoughness_34 = perceptualRoughness_25;
  tmpvar_33 = (perceptualRoughness_34 * perceptualRoughness_34);
  roughness_24 = tmpvar_33;
  mediump float tmpvar_35;
  tmpvar_35 = (roughness_24 * roughness_24);
  a2_23 = tmpvar_35;
  specularTerm_22 = ((roughness_24 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_26), 0.0, 1.0)) * (1.5 + roughness_24))
   * 
    (((tmpvar_30 * tmpvar_30) * (a2_23 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_36;
  tmpvar_36 = clamp (specularTerm_22, 0.0, 100.0);
  specularTerm_22 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (((gbuffer0_3.xyz + 
    (tmpvar_36 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_28);
  color_21 = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = color_21;
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13.w = -8.0;
  tmpvar_13.xyz = (unity_WorldToLight * tmpvar_12).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_13.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_16;
  mediump float tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_17 = gbuffer1_2.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_18 = tmpvar_19;
  highp vec3 viewDir_20;
  viewDir_20 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_21;
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_18, lightDir_6), 0.0, 1.0);
  tmpvar_22 = tmpvar_23;
  mediump float tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_18, viewDir_20), 0.0, 1.0);
  tmpvar_24 = tmpvar_25;
  highp vec2 tmpvar_26;
  tmpvar_26.x = dot ((viewDir_20 - (2.0 * 
    (dot (tmpvar_18, viewDir_20) * tmpvar_18)
  )), lightDir_6);
  tmpvar_26.y = (1.0 - tmpvar_24);
  highp vec2 tmpvar_27;
  tmpvar_27 = ((tmpvar_26 * tmpvar_26) * (tmpvar_26 * tmpvar_26));
  rlPow4AndFresnelTerm_21 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = rlPow4AndFresnelTerm_21.x;
  mediump float specular_29;
  highp float smoothness_30;
  smoothness_30 = tmpvar_17;
  highp vec2 tmpvar_31;
  tmpvar_31.x = tmpvar_28;
  tmpvar_31.y = (1.0 - smoothness_30);
  highp float tmpvar_32;
  tmpvar_32 = (texture2D (unity_NHxRoughness, tmpvar_31).w * 16.0);
  specular_29 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 1.0;
  tmpvar_33.xyz = ((gbuffer0_3.xyz + (specular_29 * gbuffer1_2.xyz)) * (tmpvar_4 * tmpvar_22));
  gl_FragData[0] = tmpvar_33;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13.w = -8.0;
  tmpvar_13.xyz = (unity_WorldToLight * tmpvar_12).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_13.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_16;
  mediump float tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_17 = gbuffer1_2.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_18 = tmpvar_19;
  mediump vec3 color_20;
  highp float specularTerm_21;
  highp float a2_22;
  mediump float roughness_23;
  mediump float perceptualRoughness_24;
  highp vec3 tmpvar_25;
  highp vec3 inVec_26;
  inVec_26 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  mediump float tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_18, lightDir_6), 0.0, 1.0);
  tmpvar_27 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_18, tmpvar_25), 0.0, 1.0);
  highp float tmpvar_30;
  highp float smoothness_31;
  smoothness_31 = tmpvar_17;
  tmpvar_30 = (1.0 - smoothness_31);
  perceptualRoughness_24 = tmpvar_30;
  highp float tmpvar_32;
  highp float perceptualRoughness_33;
  perceptualRoughness_33 = perceptualRoughness_24;
  tmpvar_32 = (perceptualRoughness_33 * perceptualRoughness_33);
  roughness_23 = tmpvar_32;
  mediump float tmpvar_34;
  tmpvar_34 = (roughness_23 * roughness_23);
  a2_22 = tmpvar_34;
  specularTerm_21 = ((roughness_23 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_25), 0.0, 1.0)) * (1.5 + roughness_23))
   * 
    (((tmpvar_29 * tmpvar_29) * (a2_22 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_35;
  tmpvar_35 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (((gbuffer0_3.xyz + 
    (tmpvar_35 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_27);
  color_20 = tmpvar_36;
  mediump vec4 tmpvar_37;
  tmpvar_37.w = 1.0;
  tmpvar_37.xyz = color_20;
  gl_FragData[0] = tmpvar_37;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13.w = -8.0;
  tmpvar_13.xyz = (unity_WorldToLight * tmpvar_12).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_13.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_16;
  mediump float tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_17 = gbuffer1_2.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_18 = tmpvar_19;
  mediump vec3 color_20;
  highp float specularTerm_21;
  highp float a2_22;
  mediump float roughness_23;
  mediump float perceptualRoughness_24;
  highp vec3 tmpvar_25;
  highp vec3 inVec_26;
  inVec_26 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  mediump float tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_18, lightDir_6), 0.0, 1.0);
  tmpvar_27 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_18, tmpvar_25), 0.0, 1.0);
  highp float tmpvar_30;
  highp float smoothness_31;
  smoothness_31 = tmpvar_17;
  tmpvar_30 = (1.0 - smoothness_31);
  perceptualRoughness_24 = tmpvar_30;
  highp float tmpvar_32;
  highp float perceptualRoughness_33;
  perceptualRoughness_33 = perceptualRoughness_24;
  tmpvar_32 = (perceptualRoughness_33 * perceptualRoughness_33);
  roughness_23 = tmpvar_32;
  mediump float tmpvar_34;
  tmpvar_34 = (roughness_23 * roughness_23);
  a2_22 = tmpvar_34;
  specularTerm_21 = ((roughness_23 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_25), 0.0, 1.0)) * (1.5 + roughness_23))
   * 
    (((tmpvar_29 * tmpvar_29) * (a2_22 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_35;
  tmpvar_35 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (((gbuffer0_3.xyz + 
    (tmpvar_35 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_27);
  color_20 = tmpvar_36;
  mediump vec4 tmpvar_37;
  tmpvar_37.w = 1.0;
  tmpvar_37.xyz = color_20;
  gl_FragData[0] = tmpvar_37;
}


#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(0.0, -8.0);
  tmpvar_12.xy = (unity_WorldToLight * tmpvar_11).xy;
  atten_5 = texture2D (_LightTexture0, tmpvar_12.xy, -8.0).w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_15;
  mediump float tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_16 = gbuffer1_2.w;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_17 = tmpvar_18;
  highp vec3 viewDir_19;
  viewDir_19 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_20;
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_17, lightDir_6), 0.0, 1.0);
  tmpvar_21 = tmpvar_22;
  mediump float tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_17, viewDir_19), 0.0, 1.0);
  tmpvar_23 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = dot ((viewDir_19 - (2.0 * 
    (dot (tmpvar_17, viewDir_19) * tmpvar_17)
  )), lightDir_6);
  tmpvar_25.y = (1.0 - tmpvar_23);
  highp vec2 tmpvar_26;
  tmpvar_26 = ((tmpvar_25 * tmpvar_25) * (tmpvar_25 * tmpvar_25));
  rlPow4AndFresnelTerm_20 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = rlPow4AndFresnelTerm_20.x;
  mediump float specular_28;
  highp float smoothness_29;
  smoothness_29 = tmpvar_16;
  highp vec2 tmpvar_30;
  tmpvar_30.x = tmpvar_27;
  tmpvar_30.y = (1.0 - smoothness_29);
  highp float tmpvar_31;
  tmpvar_31 = (texture2D (unity_NHxRoughness, tmpvar_30).w * 16.0);
  specular_28 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = ((gbuffer0_3.xyz + (specular_28 * gbuffer1_2.xyz)) * (tmpvar_4 * tmpvar_21));
  gl_FragData[0] = tmpvar_32;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(0.0, -8.0);
  tmpvar_12.xy = (unity_WorldToLight * tmpvar_11).xy;
  atten_5 = texture2D (_LightTexture0, tmpvar_12.xy, -8.0).w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_15;
  mediump float tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_16 = gbuffer1_2.w;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_17 = tmpvar_18;
  mediump vec3 color_19;
  highp float specularTerm_20;
  highp float a2_21;
  mediump float roughness_22;
  mediump float perceptualRoughness_23;
  highp vec3 tmpvar_24;
  highp vec3 inVec_25;
  inVec_25 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_24 = (inVec_25 * inversesqrt(max (0.001, 
    dot (inVec_25, inVec_25)
  )));
  mediump float tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_17, lightDir_6), 0.0, 1.0);
  tmpvar_26 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_17, tmpvar_24), 0.0, 1.0);
  highp float tmpvar_29;
  highp float smoothness_30;
  smoothness_30 = tmpvar_16;
  tmpvar_29 = (1.0 - smoothness_30);
  perceptualRoughness_23 = tmpvar_29;
  highp float tmpvar_31;
  highp float perceptualRoughness_32;
  perceptualRoughness_32 = perceptualRoughness_23;
  tmpvar_31 = (perceptualRoughness_32 * perceptualRoughness_32);
  roughness_22 = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = (roughness_22 * roughness_22);
  a2_21 = tmpvar_33;
  specularTerm_20 = ((roughness_22 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_24), 0.0, 1.0)) * (1.5 + roughness_22))
   * 
    (((tmpvar_28 * tmpvar_28) * (a2_21 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_34;
  tmpvar_34 = clamp (specularTerm_20, 0.0, 100.0);
  specularTerm_20 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (((gbuffer0_3.xyz + 
    (tmpvar_34 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_26);
  color_19 = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = color_19;
  gl_FragData[0] = tmpvar_36;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(0.0, -8.0);
  tmpvar_12.xy = (unity_WorldToLight * tmpvar_11).xy;
  atten_5 = texture2D (_LightTexture0, tmpvar_12.xy, -8.0).w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_15;
  mediump float tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_16 = gbuffer1_2.w;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_17 = tmpvar_18;
  mediump vec3 color_19;
  highp float specularTerm_20;
  highp float a2_21;
  mediump float roughness_22;
  mediump float perceptualRoughness_23;
  highp vec3 tmpvar_24;
  highp vec3 inVec_25;
  inVec_25 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_24 = (inVec_25 * inversesqrt(max (0.001, 
    dot (inVec_25, inVec_25)
  )));
  mediump float tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_17, lightDir_6), 0.0, 1.0);
  tmpvar_26 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_17, tmpvar_24), 0.0, 1.0);
  highp float tmpvar_29;
  highp float smoothness_30;
  smoothness_30 = tmpvar_16;
  tmpvar_29 = (1.0 - smoothness_30);
  perceptualRoughness_23 = tmpvar_29;
  highp float tmpvar_31;
  highp float perceptualRoughness_32;
  perceptualRoughness_32 = perceptualRoughness_23;
  tmpvar_31 = (perceptualRoughness_32 * perceptualRoughness_32);
  roughness_22 = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = (roughness_22 * roughness_22);
  a2_21 = tmpvar_33;
  specularTerm_20 = ((roughness_22 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_24), 0.0, 1.0)) * (1.5 + roughness_22))
   * 
    (((tmpvar_28 * tmpvar_28) * (a2_21 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_34;
  tmpvar_34 = clamp (specularTerm_20, 0.0, 100.0);
  specularTerm_20 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (((gbuffer0_3.xyz + 
    (tmpvar_34 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_26);
  color_19 = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = color_19;
  gl_FragData[0] = tmpvar_36;
}


#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_ShadowMapTexture, tmpvar_20);
  mediump float tmpvar_23;
  if ((tmpvar_22.x < (tmpvar_20.z / tmpvar_20.w))) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  tmpvar_21 = tmpvar_23;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((shadowAttenuation_18 + tmpvar_16), 0.0, 1.0);
  atten_5 = (atten_5 * tmpvar_24);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump float tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_28 = gbuffer1_2.w;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_29 = tmpvar_30;
  highp vec3 viewDir_31;
  viewDir_31 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_32;
  mediump float tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_29, lightDir_6), 0.0, 1.0);
  tmpvar_33 = tmpvar_34;
  mediump float tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = clamp (dot (tmpvar_29, viewDir_31), 0.0, 1.0);
  tmpvar_35 = tmpvar_36;
  highp vec2 tmpvar_37;
  tmpvar_37.x = dot ((viewDir_31 - (2.0 * 
    (dot (tmpvar_29, viewDir_31) * tmpvar_29)
  )), lightDir_6);
  tmpvar_37.y = (1.0 - tmpvar_35);
  highp vec2 tmpvar_38;
  tmpvar_38 = ((tmpvar_37 * tmpvar_37) * (tmpvar_37 * tmpvar_37));
  rlPow4AndFresnelTerm_32 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = rlPow4AndFresnelTerm_32.x;
  mediump float specular_40;
  highp float smoothness_41;
  smoothness_41 = tmpvar_28;
  highp vec2 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = (1.0 - smoothness_41);
  highp float tmpvar_43;
  tmpvar_43 = (texture2D (unity_NHxRoughness, tmpvar_42).w * 16.0);
  specular_40 = tmpvar_43;
  mediump vec4 tmpvar_44;
  tmpvar_44.w = 1.0;
  tmpvar_44.xyz = ((gbuffer0_3.xyz + (specular_40 * gbuffer1_2.xyz)) * (tmpvar_4 * tmpvar_33));
  gl_FragData[0] = tmpvar_44;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_ShadowMapTexture, tmpvar_20);
  mediump float tmpvar_23;
  if ((tmpvar_22.x < (tmpvar_20.z / tmpvar_20.w))) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  tmpvar_21 = tmpvar_23;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((shadowAttenuation_18 + tmpvar_16), 0.0, 1.0);
  atten_5 = (atten_5 * tmpvar_24);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump float tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_28 = gbuffer1_2.w;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_29 = tmpvar_30;
  mediump vec3 color_31;
  highp float specularTerm_32;
  highp float a2_33;
  mediump float roughness_34;
  mediump float perceptualRoughness_35;
  highp vec3 tmpvar_36;
  highp vec3 inVec_37;
  inVec_37 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_36 = (inVec_37 * inversesqrt(max (0.001, 
    dot (inVec_37, inVec_37)
  )));
  mediump float tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (tmpvar_29, lightDir_6), 0.0, 1.0);
  tmpvar_38 = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_29, tmpvar_36), 0.0, 1.0);
  highp float tmpvar_41;
  highp float smoothness_42;
  smoothness_42 = tmpvar_28;
  tmpvar_41 = (1.0 - smoothness_42);
  perceptualRoughness_35 = tmpvar_41;
  highp float tmpvar_43;
  highp float perceptualRoughness_44;
  perceptualRoughness_44 = perceptualRoughness_35;
  tmpvar_43 = (perceptualRoughness_44 * perceptualRoughness_44);
  roughness_34 = tmpvar_43;
  mediump float tmpvar_45;
  tmpvar_45 = (roughness_34 * roughness_34);
  a2_33 = tmpvar_45;
  specularTerm_32 = ((roughness_34 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_36), 0.0, 1.0)) * (1.5 + roughness_34))
   * 
    (((tmpvar_40 * tmpvar_40) * (a2_33 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_46;
  tmpvar_46 = clamp (specularTerm_32, 0.0, 100.0);
  specularTerm_32 = tmpvar_46;
  highp vec3 tmpvar_47;
  tmpvar_47 = (((gbuffer0_3.xyz + 
    (tmpvar_46 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_38);
  color_31 = tmpvar_47;
  mediump vec4 tmpvar_48;
  tmpvar_48.w = 1.0;
  tmpvar_48.xyz = color_31;
  gl_FragData[0] = tmpvar_48;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_ShadowMapTexture, tmpvar_20);
  mediump float tmpvar_23;
  if ((tmpvar_22.x < (tmpvar_20.z / tmpvar_20.w))) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  tmpvar_21 = tmpvar_23;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((shadowAttenuation_18 + tmpvar_16), 0.0, 1.0);
  atten_5 = (atten_5 * tmpvar_24);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump float tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_28 = gbuffer1_2.w;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_29 = tmpvar_30;
  mediump vec3 color_31;
  highp float specularTerm_32;
  highp float a2_33;
  mediump float roughness_34;
  mediump float perceptualRoughness_35;
  highp vec3 tmpvar_36;
  highp vec3 inVec_37;
  inVec_37 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_36 = (inVec_37 * inversesqrt(max (0.001, 
    dot (inVec_37, inVec_37)
  )));
  mediump float tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (tmpvar_29, lightDir_6), 0.0, 1.0);
  tmpvar_38 = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_29, tmpvar_36), 0.0, 1.0);
  highp float tmpvar_41;
  highp float smoothness_42;
  smoothness_42 = tmpvar_28;
  tmpvar_41 = (1.0 - smoothness_42);
  perceptualRoughness_35 = tmpvar_41;
  highp float tmpvar_43;
  highp float perceptualRoughness_44;
  perceptualRoughness_44 = perceptualRoughness_35;
  tmpvar_43 = (perceptualRoughness_44 * perceptualRoughness_44);
  roughness_34 = tmpvar_43;
  mediump float tmpvar_45;
  tmpvar_45 = (roughness_34 * roughness_34);
  a2_33 = tmpvar_45;
  specularTerm_32 = ((roughness_34 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_36), 0.0, 1.0)) * (1.5 + roughness_34))
   * 
    (((tmpvar_40 * tmpvar_40) * (a2_33 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_46;
  tmpvar_46 = clamp (specularTerm_32, 0.0, 100.0);
  specularTerm_32 = tmpvar_46;
  highp vec3 tmpvar_47;
  tmpvar_47 = (((gbuffer0_3.xyz + 
    (tmpvar_46 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_38);
  color_31 = tmpvar_47;
  mediump vec4 tmpvar_48;
  tmpvar_48.w = 1.0;
  tmpvar_48.xyz = color_31;
  gl_FragData[0] = tmpvar_48;
}


#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 shadowVals_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_20.xyz / tmpvar_20.w);
  shadowVals_22.x = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_22.y = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_22.z = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_22.w = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_22, tmpvar_23.zzzz);
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_21 = tmpvar_31;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_32;
  tmpvar_32 = clamp ((shadowAttenuation_18 + tmpvar_16), 0.0, 1.0);
  atten_5 = (atten_5 * tmpvar_32);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_35;
  mediump float tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_36 = gbuffer1_2.w;
  mediump vec3 tmpvar_38;
  tmpvar_38 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_37 = tmpvar_38;
  highp vec3 viewDir_39;
  viewDir_39 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_40;
  mediump float tmpvar_41;
  highp float tmpvar_42;
  tmpvar_42 = clamp (dot (tmpvar_37, lightDir_6), 0.0, 1.0);
  tmpvar_41 = tmpvar_42;
  mediump float tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = clamp (dot (tmpvar_37, viewDir_39), 0.0, 1.0);
  tmpvar_43 = tmpvar_44;
  highp vec2 tmpvar_45;
  tmpvar_45.x = dot ((viewDir_39 - (2.0 * 
    (dot (tmpvar_37, viewDir_39) * tmpvar_37)
  )), lightDir_6);
  tmpvar_45.y = (1.0 - tmpvar_43);
  highp vec2 tmpvar_46;
  tmpvar_46 = ((tmpvar_45 * tmpvar_45) * (tmpvar_45 * tmpvar_45));
  rlPow4AndFresnelTerm_40 = tmpvar_46;
  mediump float tmpvar_47;
  tmpvar_47 = rlPow4AndFresnelTerm_40.x;
  mediump float specular_48;
  highp float smoothness_49;
  smoothness_49 = tmpvar_36;
  highp vec2 tmpvar_50;
  tmpvar_50.x = tmpvar_47;
  tmpvar_50.y = (1.0 - smoothness_49);
  highp float tmpvar_51;
  tmpvar_51 = (texture2D (unity_NHxRoughness, tmpvar_50).w * 16.0);
  specular_48 = tmpvar_51;
  mediump vec4 tmpvar_52;
  tmpvar_52.w = 1.0;
  tmpvar_52.xyz = ((gbuffer0_3.xyz + (specular_48 * gbuffer1_2.xyz)) * (tmpvar_4 * tmpvar_41));
  gl_FragData[0] = tmpvar_52;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 shadowVals_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_20.xyz / tmpvar_20.w);
  shadowVals_22.x = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_22.y = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_22.z = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_22.w = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_22, tmpvar_23.zzzz);
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_21 = tmpvar_31;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_32;
  tmpvar_32 = clamp ((shadowAttenuation_18 + tmpvar_16), 0.0, 1.0);
  atten_5 = (atten_5 * tmpvar_32);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_35;
  mediump float tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_36 = gbuffer1_2.w;
  mediump vec3 tmpvar_38;
  tmpvar_38 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_37 = tmpvar_38;
  mediump vec3 color_39;
  highp float specularTerm_40;
  highp float a2_41;
  mediump float roughness_42;
  mediump float perceptualRoughness_43;
  highp vec3 tmpvar_44;
  highp vec3 inVec_45;
  inVec_45 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_44 = (inVec_45 * inversesqrt(max (0.001, 
    dot (inVec_45, inVec_45)
  )));
  mediump float tmpvar_46;
  highp float tmpvar_47;
  tmpvar_47 = clamp (dot (tmpvar_37, lightDir_6), 0.0, 1.0);
  tmpvar_46 = tmpvar_47;
  highp float tmpvar_48;
  tmpvar_48 = clamp (dot (tmpvar_37, tmpvar_44), 0.0, 1.0);
  highp float tmpvar_49;
  highp float smoothness_50;
  smoothness_50 = tmpvar_36;
  tmpvar_49 = (1.0 - smoothness_50);
  perceptualRoughness_43 = tmpvar_49;
  highp float tmpvar_51;
  highp float perceptualRoughness_52;
  perceptualRoughness_52 = perceptualRoughness_43;
  tmpvar_51 = (perceptualRoughness_52 * perceptualRoughness_52);
  roughness_42 = tmpvar_51;
  mediump float tmpvar_53;
  tmpvar_53 = (roughness_42 * roughness_42);
  a2_41 = tmpvar_53;
  specularTerm_40 = ((roughness_42 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_44), 0.0, 1.0)) * (1.5 + roughness_42))
   * 
    (((tmpvar_48 * tmpvar_48) * (a2_41 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_54;
  tmpvar_54 = clamp (specularTerm_40, 0.0, 100.0);
  specularTerm_40 = tmpvar_54;
  highp vec3 tmpvar_55;
  tmpvar_55 = (((gbuffer0_3.xyz + 
    (tmpvar_54 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_46);
  color_39 = tmpvar_55;
  mediump vec4 tmpvar_56;
  tmpvar_56.w = 1.0;
  tmpvar_56.xyz = color_39;
  gl_FragData[0] = tmpvar_56;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 shadowVals_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_20.xyz / tmpvar_20.w);
  shadowVals_22.x = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_22.y = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_22.z = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_22.w = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_22, tmpvar_23.zzzz);
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_21 = tmpvar_31;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_32;
  tmpvar_32 = clamp ((shadowAttenuation_18 + tmpvar_16), 0.0, 1.0);
  atten_5 = (atten_5 * tmpvar_32);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_35;
  mediump float tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_36 = gbuffer1_2.w;
  mediump vec3 tmpvar_38;
  tmpvar_38 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_37 = tmpvar_38;
  mediump vec3 color_39;
  highp float specularTerm_40;
  highp float a2_41;
  mediump float roughness_42;
  mediump float perceptualRoughness_43;
  highp vec3 tmpvar_44;
  highp vec3 inVec_45;
  inVec_45 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_44 = (inVec_45 * inversesqrt(max (0.001, 
    dot (inVec_45, inVec_45)
  )));
  mediump float tmpvar_46;
  highp float tmpvar_47;
  tmpvar_47 = clamp (dot (tmpvar_37, lightDir_6), 0.0, 1.0);
  tmpvar_46 = tmpvar_47;
  highp float tmpvar_48;
  tmpvar_48 = clamp (dot (tmpvar_37, tmpvar_44), 0.0, 1.0);
  highp float tmpvar_49;
  highp float smoothness_50;
  smoothness_50 = tmpvar_36;
  tmpvar_49 = (1.0 - smoothness_50);
  perceptualRoughness_43 = tmpvar_49;
  highp float tmpvar_51;
  highp float perceptualRoughness_52;
  perceptualRoughness_52 = perceptualRoughness_43;
  tmpvar_51 = (perceptualRoughness_52 * perceptualRoughness_52);
  roughness_42 = tmpvar_51;
  mediump float tmpvar_53;
  tmpvar_53 = (roughness_42 * roughness_42);
  a2_41 = tmpvar_53;
  specularTerm_40 = ((roughness_42 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_44), 0.0, 1.0)) * (1.5 + roughness_42))
   * 
    (((tmpvar_48 * tmpvar_48) * (a2_41 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_54;
  tmpvar_54 = clamp (specularTerm_40, 0.0, 100.0);
  specularTerm_40 = tmpvar_54;
  highp vec3 tmpvar_55;
  tmpvar_55 = (((gbuffer0_3.xyz + 
    (tmpvar_54 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_46);
  color_39 = tmpvar_55;
  mediump vec4 tmpvar_56;
  tmpvar_56.w = 1.0;
  tmpvar_56.xyz = color_39;
  gl_FragData[0] = tmpvar_56;
}


#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform sampler2D _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = clamp ((shadowAttenuation_14 + tmpvar_12), 0.0, 1.0);
  atten_5 = tmpvar_16;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_19;
  mediump float tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_20 = gbuffer1_2.w;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_21 = tmpvar_22;
  highp vec3 viewDir_23;
  viewDir_23 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_24;
  mediump float tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_21, lightDir_6), 0.0, 1.0);
  tmpvar_25 = tmpvar_26;
  mediump float tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_21, viewDir_23), 0.0, 1.0);
  tmpvar_27 = tmpvar_28;
  highp vec2 tmpvar_29;
  tmpvar_29.x = dot ((viewDir_23 - (2.0 * 
    (dot (tmpvar_21, viewDir_23) * tmpvar_21)
  )), lightDir_6);
  tmpvar_29.y = (1.0 - tmpvar_27);
  highp vec2 tmpvar_30;
  tmpvar_30 = ((tmpvar_29 * tmpvar_29) * (tmpvar_29 * tmpvar_29));
  rlPow4AndFresnelTerm_24 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = rlPow4AndFresnelTerm_24.x;
  mediump float specular_32;
  highp float smoothness_33;
  smoothness_33 = tmpvar_20;
  highp vec2 tmpvar_34;
  tmpvar_34.x = tmpvar_31;
  tmpvar_34.y = (1.0 - smoothness_33);
  highp float tmpvar_35;
  tmpvar_35 = (texture2D (unity_NHxRoughness, tmpvar_34).w * 16.0);
  specular_32 = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = ((gbuffer0_3.xyz + (specular_32 * gbuffer1_2.xyz)) * (tmpvar_4 * tmpvar_25));
  gl_FragData[0] = tmpvar_36;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = clamp ((shadowAttenuation_14 + tmpvar_12), 0.0, 1.0);
  atten_5 = tmpvar_16;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_19;
  mediump float tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_20 = gbuffer1_2.w;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_21 = tmpvar_22;
  mediump vec3 color_23;
  highp float specularTerm_24;
  highp float a2_25;
  mediump float roughness_26;
  mediump float perceptualRoughness_27;
  highp vec3 tmpvar_28;
  highp vec3 inVec_29;
  inVec_29 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_28 = (inVec_29 * inversesqrt(max (0.001, 
    dot (inVec_29, inVec_29)
  )));
  mediump float tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp (dot (tmpvar_21, lightDir_6), 0.0, 1.0);
  tmpvar_30 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_21, tmpvar_28), 0.0, 1.0);
  highp float tmpvar_33;
  highp float smoothness_34;
  smoothness_34 = tmpvar_20;
  tmpvar_33 = (1.0 - smoothness_34);
  perceptualRoughness_27 = tmpvar_33;
  highp float tmpvar_35;
  highp float perceptualRoughness_36;
  perceptualRoughness_36 = perceptualRoughness_27;
  tmpvar_35 = (perceptualRoughness_36 * perceptualRoughness_36);
  roughness_26 = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = (roughness_26 * roughness_26);
  a2_25 = tmpvar_37;
  specularTerm_24 = ((roughness_26 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_28), 0.0, 1.0)) * (1.5 + roughness_26))
   * 
    (((tmpvar_32 * tmpvar_32) * (a2_25 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_38;
  tmpvar_38 = clamp (specularTerm_24, 0.0, 100.0);
  specularTerm_24 = tmpvar_38;
  highp vec3 tmpvar_39;
  tmpvar_39 = (((gbuffer0_3.xyz + 
    (tmpvar_38 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_30);
  color_23 = tmpvar_39;
  mediump vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = color_23;
  gl_FragData[0] = tmpvar_40;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = clamp ((shadowAttenuation_14 + tmpvar_12), 0.0, 1.0);
  atten_5 = tmpvar_16;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_19;
  mediump float tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_20 = gbuffer1_2.w;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_21 = tmpvar_22;
  mediump vec3 color_23;
  highp float specularTerm_24;
  highp float a2_25;
  mediump float roughness_26;
  mediump float perceptualRoughness_27;
  highp vec3 tmpvar_28;
  highp vec3 inVec_29;
  inVec_29 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_28 = (inVec_29 * inversesqrt(max (0.001, 
    dot (inVec_29, inVec_29)
  )));
  mediump float tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp (dot (tmpvar_21, lightDir_6), 0.0, 1.0);
  tmpvar_30 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_21, tmpvar_28), 0.0, 1.0);
  highp float tmpvar_33;
  highp float smoothness_34;
  smoothness_34 = tmpvar_20;
  tmpvar_33 = (1.0 - smoothness_34);
  perceptualRoughness_27 = tmpvar_33;
  highp float tmpvar_35;
  highp float perceptualRoughness_36;
  perceptualRoughness_36 = perceptualRoughness_27;
  tmpvar_35 = (perceptualRoughness_36 * perceptualRoughness_36);
  roughness_26 = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = (roughness_26 * roughness_26);
  a2_25 = tmpvar_37;
  specularTerm_24 = ((roughness_26 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_28), 0.0, 1.0)) * (1.5 + roughness_26))
   * 
    (((tmpvar_32 * tmpvar_32) * (a2_25 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_38;
  tmpvar_38 = clamp (specularTerm_24, 0.0, 100.0);
  specularTerm_24 = tmpvar_38;
  highp vec3 tmpvar_39;
  tmpvar_39 = (((gbuffer0_3.xyz + 
    (tmpvar_38 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_30);
  color_23 = tmpvar_39;
  mediump vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = color_23;
  gl_FragData[0] = tmpvar_40;
}


#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = clamp ((shadowAttenuation_14 + tmpvar_12), 0.0, 1.0);
  atten_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_9;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, -8.0);
  tmpvar_18.xy = (unity_WorldToLight * tmpvar_17).xy;
  atten_5 = (atten_5 * texture2D (_LightTexture0, tmpvar_18.xy, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  mediump float tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_22 = gbuffer1_2.w;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_23 = tmpvar_24;
  highp vec3 viewDir_25;
  viewDir_25 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_26;
  mediump float tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_23, lightDir_6), 0.0, 1.0);
  tmpvar_27 = tmpvar_28;
  mediump float tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_23, viewDir_25), 0.0, 1.0);
  tmpvar_29 = tmpvar_30;
  highp vec2 tmpvar_31;
  tmpvar_31.x = dot ((viewDir_25 - (2.0 * 
    (dot (tmpvar_23, viewDir_25) * tmpvar_23)
  )), lightDir_6);
  tmpvar_31.y = (1.0 - tmpvar_29);
  highp vec2 tmpvar_32;
  tmpvar_32 = ((tmpvar_31 * tmpvar_31) * (tmpvar_31 * tmpvar_31));
  rlPow4AndFresnelTerm_26 = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = rlPow4AndFresnelTerm_26.x;
  mediump float specular_34;
  highp float smoothness_35;
  smoothness_35 = tmpvar_22;
  highp vec2 tmpvar_36;
  tmpvar_36.x = tmpvar_33;
  tmpvar_36.y = (1.0 - smoothness_35);
  highp float tmpvar_37;
  tmpvar_37 = (texture2D (unity_NHxRoughness, tmpvar_36).w * 16.0);
  specular_34 = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = ((gbuffer0_3.xyz + (specular_34 * gbuffer1_2.xyz)) * (tmpvar_4 * tmpvar_27));
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = clamp ((shadowAttenuation_14 + tmpvar_12), 0.0, 1.0);
  atten_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_9;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, -8.0);
  tmpvar_18.xy = (unity_WorldToLight * tmpvar_17).xy;
  atten_5 = (atten_5 * texture2D (_LightTexture0, tmpvar_18.xy, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  mediump float tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_22 = gbuffer1_2.w;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_23 = tmpvar_24;
  mediump vec3 color_25;
  highp float specularTerm_26;
  highp float a2_27;
  mediump float roughness_28;
  mediump float perceptualRoughness_29;
  highp vec3 tmpvar_30;
  highp vec3 inVec_31;
  inVec_31 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_30 = (inVec_31 * inversesqrt(max (0.001, 
    dot (inVec_31, inVec_31)
  )));
  mediump float tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_23, lightDir_6), 0.0, 1.0);
  tmpvar_32 = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_23, tmpvar_30), 0.0, 1.0);
  highp float tmpvar_35;
  highp float smoothness_36;
  smoothness_36 = tmpvar_22;
  tmpvar_35 = (1.0 - smoothness_36);
  perceptualRoughness_29 = tmpvar_35;
  highp float tmpvar_37;
  highp float perceptualRoughness_38;
  perceptualRoughness_38 = perceptualRoughness_29;
  tmpvar_37 = (perceptualRoughness_38 * perceptualRoughness_38);
  roughness_28 = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = (roughness_28 * roughness_28);
  a2_27 = tmpvar_39;
  specularTerm_26 = ((roughness_28 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_30), 0.0, 1.0)) * (1.5 + roughness_28))
   * 
    (((tmpvar_34 * tmpvar_34) * (a2_27 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_40;
  tmpvar_40 = clamp (specularTerm_26, 0.0, 100.0);
  specularTerm_26 = tmpvar_40;
  highp vec3 tmpvar_41;
  tmpvar_41 = (((gbuffer0_3.xyz + 
    (tmpvar_40 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_32);
  color_25 = tmpvar_41;
  mediump vec4 tmpvar_42;
  tmpvar_42.w = 1.0;
  tmpvar_42.xyz = color_25;
  gl_FragData[0] = tmpvar_42;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = clamp ((shadowAttenuation_14 + tmpvar_12), 0.0, 1.0);
  atten_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_9;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, -8.0);
  tmpvar_18.xy = (unity_WorldToLight * tmpvar_17).xy;
  atten_5 = (atten_5 * texture2D (_LightTexture0, tmpvar_18.xy, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  mediump float tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_22 = gbuffer1_2.w;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_23 = tmpvar_24;
  mediump vec3 color_25;
  highp float specularTerm_26;
  highp float a2_27;
  mediump float roughness_28;
  mediump float perceptualRoughness_29;
  highp vec3 tmpvar_30;
  highp vec3 inVec_31;
  inVec_31 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_30 = (inVec_31 * inversesqrt(max (0.001, 
    dot (inVec_31, inVec_31)
  )));
  mediump float tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_23, lightDir_6), 0.0, 1.0);
  tmpvar_32 = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_23, tmpvar_30), 0.0, 1.0);
  highp float tmpvar_35;
  highp float smoothness_36;
  smoothness_36 = tmpvar_22;
  tmpvar_35 = (1.0 - smoothness_36);
  perceptualRoughness_29 = tmpvar_35;
  highp float tmpvar_37;
  highp float perceptualRoughness_38;
  perceptualRoughness_38 = perceptualRoughness_29;
  tmpvar_37 = (perceptualRoughness_38 * perceptualRoughness_38);
  roughness_28 = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = (roughness_28 * roughness_28);
  a2_27 = tmpvar_39;
  specularTerm_26 = ((roughness_28 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_30), 0.0, 1.0)) * (1.5 + roughness_28))
   * 
    (((tmpvar_34 * tmpvar_34) * (a2_27 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_40;
  tmpvar_40 = clamp (specularTerm_26, 0.0, 100.0);
  specularTerm_26 = tmpvar_40;
  highp vec3 tmpvar_41;
  tmpvar_41 = (((gbuffer0_3.xyz + 
    (tmpvar_40 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_32);
  color_25 = tmpvar_41;
  mediump vec4 tmpvar_42;
  tmpvar_42.w = 1.0;
  tmpvar_42.xyz = color_25;
  gl_FragData[0] = tmpvar_42;
}


#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = clamp ((tmpvar_21 + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_22);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_25;
  mediump float tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_26 = gbuffer1_2.w;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_27 = tmpvar_28;
  highp vec3 viewDir_29;
  viewDir_29 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_30;
  mediump float tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_27, lightDir_6), 0.0, 1.0);
  tmpvar_31 = tmpvar_32;
  mediump float tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_27, viewDir_29), 0.0, 1.0);
  tmpvar_33 = tmpvar_34;
  highp vec2 tmpvar_35;
  tmpvar_35.x = dot ((viewDir_29 - (2.0 * 
    (dot (tmpvar_27, viewDir_29) * tmpvar_27)
  )), lightDir_6);
  tmpvar_35.y = (1.0 - tmpvar_33);
  highp vec2 tmpvar_36;
  tmpvar_36 = ((tmpvar_35 * tmpvar_35) * (tmpvar_35 * tmpvar_35));
  rlPow4AndFresnelTerm_30 = tmpvar_36;
  mediump float tmpvar_37;
  tmpvar_37 = rlPow4AndFresnelTerm_30.x;
  mediump float specular_38;
  highp float smoothness_39;
  smoothness_39 = tmpvar_26;
  highp vec2 tmpvar_40;
  tmpvar_40.x = tmpvar_37;
  tmpvar_40.y = (1.0 - smoothness_39);
  highp float tmpvar_41;
  tmpvar_41 = (texture2D (unity_NHxRoughness, tmpvar_40).w * 16.0);
  specular_38 = tmpvar_41;
  mediump vec4 tmpvar_42;
  tmpvar_42.w = 1.0;
  tmpvar_42.xyz = ((gbuffer0_3.xyz + (specular_38 * gbuffer1_2.xyz)) * (tmpvar_4 * tmpvar_31));
  gl_FragData[0] = tmpvar_42;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = clamp ((tmpvar_21 + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_22);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_25;
  mediump float tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_26 = gbuffer1_2.w;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_27 = tmpvar_28;
  mediump vec3 color_29;
  highp float specularTerm_30;
  highp float a2_31;
  mediump float roughness_32;
  mediump float perceptualRoughness_33;
  highp vec3 tmpvar_34;
  highp vec3 inVec_35;
  inVec_35 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_34 = (inVec_35 * inversesqrt(max (0.001, 
    dot (inVec_35, inVec_35)
  )));
  mediump float tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_27, lightDir_6), 0.0, 1.0);
  tmpvar_36 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = clamp (dot (tmpvar_27, tmpvar_34), 0.0, 1.0);
  highp float tmpvar_39;
  highp float smoothness_40;
  smoothness_40 = tmpvar_26;
  tmpvar_39 = (1.0 - smoothness_40);
  perceptualRoughness_33 = tmpvar_39;
  highp float tmpvar_41;
  highp float perceptualRoughness_42;
  perceptualRoughness_42 = perceptualRoughness_33;
  tmpvar_41 = (perceptualRoughness_42 * perceptualRoughness_42);
  roughness_32 = tmpvar_41;
  mediump float tmpvar_43;
  tmpvar_43 = (roughness_32 * roughness_32);
  a2_31 = tmpvar_43;
  specularTerm_30 = ((roughness_32 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_34), 0.0, 1.0)) * (1.5 + roughness_32))
   * 
    (((tmpvar_38 * tmpvar_38) * (a2_31 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_44;
  tmpvar_44 = clamp (specularTerm_30, 0.0, 100.0);
  specularTerm_30 = tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_45 = (((gbuffer0_3.xyz + 
    (tmpvar_44 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_36);
  color_29 = tmpvar_45;
  mediump vec4 tmpvar_46;
  tmpvar_46.w = 1.0;
  tmpvar_46.xyz = color_29;
  gl_FragData[0] = tmpvar_46;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = clamp ((tmpvar_21 + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_22);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_25;
  mediump float tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_26 = gbuffer1_2.w;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_27 = tmpvar_28;
  mediump vec3 color_29;
  highp float specularTerm_30;
  highp float a2_31;
  mediump float roughness_32;
  mediump float perceptualRoughness_33;
  highp vec3 tmpvar_34;
  highp vec3 inVec_35;
  inVec_35 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_34 = (inVec_35 * inversesqrt(max (0.001, 
    dot (inVec_35, inVec_35)
  )));
  mediump float tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_27, lightDir_6), 0.0, 1.0);
  tmpvar_36 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = clamp (dot (tmpvar_27, tmpvar_34), 0.0, 1.0);
  highp float tmpvar_39;
  highp float smoothness_40;
  smoothness_40 = tmpvar_26;
  tmpvar_39 = (1.0 - smoothness_40);
  perceptualRoughness_33 = tmpvar_39;
  highp float tmpvar_41;
  highp float perceptualRoughness_42;
  perceptualRoughness_42 = perceptualRoughness_33;
  tmpvar_41 = (perceptualRoughness_42 * perceptualRoughness_42);
  roughness_32 = tmpvar_41;
  mediump float tmpvar_43;
  tmpvar_43 = (roughness_32 * roughness_32);
  a2_31 = tmpvar_43;
  specularTerm_30 = ((roughness_32 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_34), 0.0, 1.0)) * (1.5 + roughness_32))
   * 
    (((tmpvar_38 * tmpvar_38) * (a2_31 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_44;
  tmpvar_44 = clamp (specularTerm_30, 0.0, 100.0);
  specularTerm_30 = tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_45 = (((gbuffer0_3.xyz + 
    (tmpvar_44 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_36);
  color_29 = tmpvar_45;
  mediump vec4 tmpvar_46;
  tmpvar_46.w = 1.0;
  tmpvar_46.xyz = color_29;
  gl_FragData[0] = tmpvar_46;
}


#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = clamp ((dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_37);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_40;
  mediump float tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_41 = gbuffer1_2.w;
  mediump vec3 tmpvar_43;
  tmpvar_43 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_42 = tmpvar_43;
  highp vec3 viewDir_44;
  viewDir_44 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_45;
  mediump float tmpvar_46;
  highp float tmpvar_47;
  tmpvar_47 = clamp (dot (tmpvar_42, lightDir_6), 0.0, 1.0);
  tmpvar_46 = tmpvar_47;
  mediump float tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = clamp (dot (tmpvar_42, viewDir_44), 0.0, 1.0);
  tmpvar_48 = tmpvar_49;
  highp vec2 tmpvar_50;
  tmpvar_50.x = dot ((viewDir_44 - (2.0 * 
    (dot (tmpvar_42, viewDir_44) * tmpvar_42)
  )), lightDir_6);
  tmpvar_50.y = (1.0 - tmpvar_48);
  highp vec2 tmpvar_51;
  tmpvar_51 = ((tmpvar_50 * tmpvar_50) * (tmpvar_50 * tmpvar_50));
  rlPow4AndFresnelTerm_45 = tmpvar_51;
  mediump float tmpvar_52;
  tmpvar_52 = rlPow4AndFresnelTerm_45.x;
  mediump float specular_53;
  highp float smoothness_54;
  smoothness_54 = tmpvar_41;
  highp vec2 tmpvar_55;
  tmpvar_55.x = tmpvar_52;
  tmpvar_55.y = (1.0 - smoothness_54);
  highp float tmpvar_56;
  tmpvar_56 = (texture2D (unity_NHxRoughness, tmpvar_55).w * 16.0);
  specular_53 = tmpvar_56;
  mediump vec4 tmpvar_57;
  tmpvar_57.w = 1.0;
  tmpvar_57.xyz = ((gbuffer0_3.xyz + (specular_53 * gbuffer1_2.xyz)) * (tmpvar_4 * tmpvar_46));
  gl_FragData[0] = tmpvar_57;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = clamp ((dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_37);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_40;
  mediump float tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_41 = gbuffer1_2.w;
  mediump vec3 tmpvar_43;
  tmpvar_43 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_42 = tmpvar_43;
  mediump vec3 color_44;
  highp float specularTerm_45;
  highp float a2_46;
  mediump float roughness_47;
  mediump float perceptualRoughness_48;
  highp vec3 tmpvar_49;
  highp vec3 inVec_50;
  inVec_50 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_49 = (inVec_50 * inversesqrt(max (0.001, 
    dot (inVec_50, inVec_50)
  )));
  mediump float tmpvar_51;
  highp float tmpvar_52;
  tmpvar_52 = clamp (dot (tmpvar_42, lightDir_6), 0.0, 1.0);
  tmpvar_51 = tmpvar_52;
  highp float tmpvar_53;
  tmpvar_53 = clamp (dot (tmpvar_42, tmpvar_49), 0.0, 1.0);
  highp float tmpvar_54;
  highp float smoothness_55;
  smoothness_55 = tmpvar_41;
  tmpvar_54 = (1.0 - smoothness_55);
  perceptualRoughness_48 = tmpvar_54;
  highp float tmpvar_56;
  highp float perceptualRoughness_57;
  perceptualRoughness_57 = perceptualRoughness_48;
  tmpvar_56 = (perceptualRoughness_57 * perceptualRoughness_57);
  roughness_47 = tmpvar_56;
  mediump float tmpvar_58;
  tmpvar_58 = (roughness_47 * roughness_47);
  a2_46 = tmpvar_58;
  specularTerm_45 = ((roughness_47 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_49), 0.0, 1.0)) * (1.5 + roughness_47))
   * 
    (((tmpvar_53 * tmpvar_53) * (a2_46 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_59;
  tmpvar_59 = clamp (specularTerm_45, 0.0, 100.0);
  specularTerm_45 = tmpvar_59;
  highp vec3 tmpvar_60;
  tmpvar_60 = (((gbuffer0_3.xyz + 
    (tmpvar_59 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_51);
  color_44 = tmpvar_60;
  mediump vec4 tmpvar_61;
  tmpvar_61.w = 1.0;
  tmpvar_61.xyz = color_44;
  gl_FragData[0] = tmpvar_61;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = clamp ((dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_37);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_40;
  mediump float tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_41 = gbuffer1_2.w;
  mediump vec3 tmpvar_43;
  tmpvar_43 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_42 = tmpvar_43;
  mediump vec3 color_44;
  highp float specularTerm_45;
  highp float a2_46;
  mediump float roughness_47;
  mediump float perceptualRoughness_48;
  highp vec3 tmpvar_49;
  highp vec3 inVec_50;
  inVec_50 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_49 = (inVec_50 * inversesqrt(max (0.001, 
    dot (inVec_50, inVec_50)
  )));
  mediump float tmpvar_51;
  highp float tmpvar_52;
  tmpvar_52 = clamp (dot (tmpvar_42, lightDir_6), 0.0, 1.0);
  tmpvar_51 = tmpvar_52;
  highp float tmpvar_53;
  tmpvar_53 = clamp (dot (tmpvar_42, tmpvar_49), 0.0, 1.0);
  highp float tmpvar_54;
  highp float smoothness_55;
  smoothness_55 = tmpvar_41;
  tmpvar_54 = (1.0 - smoothness_55);
  perceptualRoughness_48 = tmpvar_54;
  highp float tmpvar_56;
  highp float perceptualRoughness_57;
  perceptualRoughness_57 = perceptualRoughness_48;
  tmpvar_56 = (perceptualRoughness_57 * perceptualRoughness_57);
  roughness_47 = tmpvar_56;
  mediump float tmpvar_58;
  tmpvar_58 = (roughness_47 * roughness_47);
  a2_46 = tmpvar_58;
  specularTerm_45 = ((roughness_47 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_49), 0.0, 1.0)) * (1.5 + roughness_47))
   * 
    (((tmpvar_53 * tmpvar_53) * (a2_46 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_59;
  tmpvar_59 = clamp (specularTerm_45, 0.0, 100.0);
  specularTerm_45 = tmpvar_59;
  highp vec3 tmpvar_60;
  tmpvar_60 = (((gbuffer0_3.xyz + 
    (tmpvar_59 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_51);
  color_44 = tmpvar_60;
  mediump vec4 tmpvar_61;
  tmpvar_61.w = 1.0;
  tmpvar_61.xyz = color_44;
  gl_FragData[0] = tmpvar_61;
}


#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = clamp ((tmpvar_21 + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_22);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_9;
  highp vec4 tmpvar_24;
  tmpvar_24.w = -8.0;
  tmpvar_24.xyz = (unity_WorldToLight * tmpvar_23).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_24.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump float tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_28 = gbuffer1_2.w;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_29 = tmpvar_30;
  highp vec3 viewDir_31;
  viewDir_31 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_32;
  mediump float tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_29, lightDir_6), 0.0, 1.0);
  tmpvar_33 = tmpvar_34;
  mediump float tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = clamp (dot (tmpvar_29, viewDir_31), 0.0, 1.0);
  tmpvar_35 = tmpvar_36;
  highp vec2 tmpvar_37;
  tmpvar_37.x = dot ((viewDir_31 - (2.0 * 
    (dot (tmpvar_29, viewDir_31) * tmpvar_29)
  )), lightDir_6);
  tmpvar_37.y = (1.0 - tmpvar_35);
  highp vec2 tmpvar_38;
  tmpvar_38 = ((tmpvar_37 * tmpvar_37) * (tmpvar_37 * tmpvar_37));
  rlPow4AndFresnelTerm_32 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = rlPow4AndFresnelTerm_32.x;
  mediump float specular_40;
  highp float smoothness_41;
  smoothness_41 = tmpvar_28;
  highp vec2 tmpvar_42;
  tmpvar_42.x = tmpvar_39;
  tmpvar_42.y = (1.0 - smoothness_41);
  highp float tmpvar_43;
  tmpvar_43 = (texture2D (unity_NHxRoughness, tmpvar_42).w * 16.0);
  specular_40 = tmpvar_43;
  mediump vec4 tmpvar_44;
  tmpvar_44.w = 1.0;
  tmpvar_44.xyz = ((gbuffer0_3.xyz + (specular_40 * gbuffer1_2.xyz)) * (tmpvar_4 * tmpvar_33));
  gl_FragData[0] = tmpvar_44;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = clamp ((tmpvar_21 + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_22);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_9;
  highp vec4 tmpvar_24;
  tmpvar_24.w = -8.0;
  tmpvar_24.xyz = (unity_WorldToLight * tmpvar_23).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_24.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump float tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_28 = gbuffer1_2.w;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_29 = tmpvar_30;
  mediump vec3 color_31;
  highp float specularTerm_32;
  highp float a2_33;
  mediump float roughness_34;
  mediump float perceptualRoughness_35;
  highp vec3 tmpvar_36;
  highp vec3 inVec_37;
  inVec_37 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_36 = (inVec_37 * inversesqrt(max (0.001, 
    dot (inVec_37, inVec_37)
  )));
  mediump float tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (tmpvar_29, lightDir_6), 0.0, 1.0);
  tmpvar_38 = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_29, tmpvar_36), 0.0, 1.0);
  highp float tmpvar_41;
  highp float smoothness_42;
  smoothness_42 = tmpvar_28;
  tmpvar_41 = (1.0 - smoothness_42);
  perceptualRoughness_35 = tmpvar_41;
  highp float tmpvar_43;
  highp float perceptualRoughness_44;
  perceptualRoughness_44 = perceptualRoughness_35;
  tmpvar_43 = (perceptualRoughness_44 * perceptualRoughness_44);
  roughness_34 = tmpvar_43;
  mediump float tmpvar_45;
  tmpvar_45 = (roughness_34 * roughness_34);
  a2_33 = tmpvar_45;
  specularTerm_32 = ((roughness_34 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_36), 0.0, 1.0)) * (1.5 + roughness_34))
   * 
    (((tmpvar_40 * tmpvar_40) * (a2_33 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_46;
  tmpvar_46 = clamp (specularTerm_32, 0.0, 100.0);
  specularTerm_32 = tmpvar_46;
  highp vec3 tmpvar_47;
  tmpvar_47 = (((gbuffer0_3.xyz + 
    (tmpvar_46 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_38);
  color_31 = tmpvar_47;
  mediump vec4 tmpvar_48;
  tmpvar_48.w = 1.0;
  tmpvar_48.xyz = color_31;
  gl_FragData[0] = tmpvar_48;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = clamp ((tmpvar_21 + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_22);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_9;
  highp vec4 tmpvar_24;
  tmpvar_24.w = -8.0;
  tmpvar_24.xyz = (unity_WorldToLight * tmpvar_23).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_24.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump float tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_28 = gbuffer1_2.w;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_29 = tmpvar_30;
  mediump vec3 color_31;
  highp float specularTerm_32;
  highp float a2_33;
  mediump float roughness_34;
  mediump float perceptualRoughness_35;
  highp vec3 tmpvar_36;
  highp vec3 inVec_37;
  inVec_37 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_36 = (inVec_37 * inversesqrt(max (0.001, 
    dot (inVec_37, inVec_37)
  )));
  mediump float tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (tmpvar_29, lightDir_6), 0.0, 1.0);
  tmpvar_38 = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_29, tmpvar_36), 0.0, 1.0);
  highp float tmpvar_41;
  highp float smoothness_42;
  smoothness_42 = tmpvar_28;
  tmpvar_41 = (1.0 - smoothness_42);
  perceptualRoughness_35 = tmpvar_41;
  highp float tmpvar_43;
  highp float perceptualRoughness_44;
  perceptualRoughness_44 = perceptualRoughness_35;
  tmpvar_43 = (perceptualRoughness_44 * perceptualRoughness_44);
  roughness_34 = tmpvar_43;
  mediump float tmpvar_45;
  tmpvar_45 = (roughness_34 * roughness_34);
  a2_33 = tmpvar_45;
  specularTerm_32 = ((roughness_34 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_36), 0.0, 1.0)) * (1.5 + roughness_34))
   * 
    (((tmpvar_40 * tmpvar_40) * (a2_33 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_46;
  tmpvar_46 = clamp (specularTerm_32, 0.0, 100.0);
  specularTerm_32 = tmpvar_46;
  highp vec3 tmpvar_47;
  tmpvar_47 = (((gbuffer0_3.xyz + 
    (tmpvar_46 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_38);
  color_31 = tmpvar_47;
  mediump vec4 tmpvar_48;
  tmpvar_48.w = 1.0;
  tmpvar_48.xyz = color_31;
  gl_FragData[0] = tmpvar_48;
}


#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = clamp ((dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_37);
  highp vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = tmpvar_9;
  highp vec4 tmpvar_39;
  tmpvar_39.w = -8.0;
  tmpvar_39.xyz = (unity_WorldToLight * tmpvar_38).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_39.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_42;
  mediump float tmpvar_43;
  highp vec3 tmpvar_44;
  tmpvar_43 = gbuffer1_2.w;
  mediump vec3 tmpvar_45;
  tmpvar_45 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_44 = tmpvar_45;
  highp vec3 viewDir_46;
  viewDir_46 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump vec2 rlPow4AndFresnelTerm_47;
  mediump float tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = clamp (dot (tmpvar_44, lightDir_6), 0.0, 1.0);
  tmpvar_48 = tmpvar_49;
  mediump float tmpvar_50;
  highp float tmpvar_51;
  tmpvar_51 = clamp (dot (tmpvar_44, viewDir_46), 0.0, 1.0);
  tmpvar_50 = tmpvar_51;
  highp vec2 tmpvar_52;
  tmpvar_52.x = dot ((viewDir_46 - (2.0 * 
    (dot (tmpvar_44, viewDir_46) * tmpvar_44)
  )), lightDir_6);
  tmpvar_52.y = (1.0 - tmpvar_50);
  highp vec2 tmpvar_53;
  tmpvar_53 = ((tmpvar_52 * tmpvar_52) * (tmpvar_52 * tmpvar_52));
  rlPow4AndFresnelTerm_47 = tmpvar_53;
  mediump float tmpvar_54;
  tmpvar_54 = rlPow4AndFresnelTerm_47.x;
  mediump float specular_55;
  highp float smoothness_56;
  smoothness_56 = tmpvar_43;
  highp vec2 tmpvar_57;
  tmpvar_57.x = tmpvar_54;
  tmpvar_57.y = (1.0 - smoothness_56);
  highp float tmpvar_58;
  tmpvar_58 = (texture2D (unity_NHxRoughness, tmpvar_57).w * 16.0);
  specular_55 = tmpvar_58;
  mediump vec4 tmpvar_59;
  tmpvar_59.w = 1.0;
  tmpvar_59.xyz = ((gbuffer0_3.xyz + (specular_55 * gbuffer1_2.xyz)) * (tmpvar_4 * tmpvar_48));
  gl_FragData[0] = tmpvar_59;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = clamp ((dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_37);
  highp vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = tmpvar_9;
  highp vec4 tmpvar_39;
  tmpvar_39.w = -8.0;
  tmpvar_39.xyz = (unity_WorldToLight * tmpvar_38).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_39.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_42;
  mediump float tmpvar_43;
  highp vec3 tmpvar_44;
  tmpvar_43 = gbuffer1_2.w;
  mediump vec3 tmpvar_45;
  tmpvar_45 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_44 = tmpvar_45;
  mediump vec3 color_46;
  highp float specularTerm_47;
  highp float a2_48;
  mediump float roughness_49;
  mediump float perceptualRoughness_50;
  highp vec3 tmpvar_51;
  highp vec3 inVec_52;
  inVec_52 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_51 = (inVec_52 * inversesqrt(max (0.001, 
    dot (inVec_52, inVec_52)
  )));
  mediump float tmpvar_53;
  highp float tmpvar_54;
  tmpvar_54 = clamp (dot (tmpvar_44, lightDir_6), 0.0, 1.0);
  tmpvar_53 = tmpvar_54;
  highp float tmpvar_55;
  tmpvar_55 = clamp (dot (tmpvar_44, tmpvar_51), 0.0, 1.0);
  highp float tmpvar_56;
  highp float smoothness_57;
  smoothness_57 = tmpvar_43;
  tmpvar_56 = (1.0 - smoothness_57);
  perceptualRoughness_50 = tmpvar_56;
  highp float tmpvar_58;
  highp float perceptualRoughness_59;
  perceptualRoughness_59 = perceptualRoughness_50;
  tmpvar_58 = (perceptualRoughness_59 * perceptualRoughness_59);
  roughness_49 = tmpvar_58;
  mediump float tmpvar_60;
  tmpvar_60 = (roughness_49 * roughness_49);
  a2_48 = tmpvar_60;
  specularTerm_47 = ((roughness_49 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_51), 0.0, 1.0)) * (1.5 + roughness_49))
   * 
    (((tmpvar_55 * tmpvar_55) * (a2_48 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_61;
  tmpvar_61 = clamp (specularTerm_47, 0.0, 100.0);
  specularTerm_47 = tmpvar_61;
  highp vec3 tmpvar_62;
  tmpvar_62 = (((gbuffer0_3.xyz + 
    (tmpvar_61 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_53);
  color_46 = tmpvar_62;
  mediump vec4 tmpvar_63;
  tmpvar_63.w = 1.0;
  tmpvar_63.xyz = color_46;
  gl_FragData[0] = tmpvar_63;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = clamp ((dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_37);
  highp vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = tmpvar_9;
  highp vec4 tmpvar_39;
  tmpvar_39.w = -8.0;
  tmpvar_39.xyz = (unity_WorldToLight * tmpvar_38).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_39.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_42;
  mediump float tmpvar_43;
  highp vec3 tmpvar_44;
  tmpvar_43 = gbuffer1_2.w;
  mediump vec3 tmpvar_45;
  tmpvar_45 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_44 = tmpvar_45;
  mediump vec3 color_46;
  highp float specularTerm_47;
  highp float a2_48;
  mediump float roughness_49;
  mediump float perceptualRoughness_50;
  highp vec3 tmpvar_51;
  highp vec3 inVec_52;
  inVec_52 = (lightDir_6 - normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  tmpvar_51 = (inVec_52 * inversesqrt(max (0.001, 
    dot (inVec_52, inVec_52)
  )));
  mediump float tmpvar_53;
  highp float tmpvar_54;
  tmpvar_54 = clamp (dot (tmpvar_44, lightDir_6), 0.0, 1.0);
  tmpvar_53 = tmpvar_54;
  highp float tmpvar_55;
  tmpvar_55 = clamp (dot (tmpvar_44, tmpvar_51), 0.0, 1.0);
  highp float tmpvar_56;
  highp float smoothness_57;
  smoothness_57 = tmpvar_43;
  tmpvar_56 = (1.0 - smoothness_57);
  perceptualRoughness_50 = tmpvar_56;
  highp float tmpvar_58;
  highp float perceptualRoughness_59;
  perceptualRoughness_59 = perceptualRoughness_50;
  tmpvar_58 = (perceptualRoughness_59 * perceptualRoughness_59);
  roughness_49 = tmpvar_58;
  mediump float tmpvar_60;
  tmpvar_60 = (roughness_49 * roughness_49);
  a2_48 = tmpvar_60;
  specularTerm_47 = ((roughness_49 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_51), 0.0, 1.0)) * (1.5 + roughness_49))
   * 
    (((tmpvar_55 * tmpvar_55) * (a2_48 - 1.0)) + 1.00001)
  )) - 0.0001);
  highp float tmpvar_61;
  tmpvar_61 = clamp (specularTerm_47, 0.0, 100.0);
  specularTerm_47 = tmpvar_61;
  highp vec3 tmpvar_62;
  tmpvar_62 = (((gbuffer0_3.xyz + 
    (tmpvar_61 * gbuffer1_2.xyz)
  ) * tmpvar_4) * tmpvar_53);
  color_46 = tmpvar_62;
  mediump vec4 tmpvar_63;
  tmpvar_63.w = 1.0;
  tmpvar_63.xyz = color_46;
  gl_FragData[0] = tmpvar_63;
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
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
}
}
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 66195
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _LightBuffer;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = -(log2(texture2D (_LightBuffer, xlv_TEXCOORD0)));
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _LightBuffer;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = -(log2(texture2D (_LightBuffer, xlv_TEXCOORD0)));
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _LightBuffer;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = -(log2(texture2D (_LightBuffer, xlv_TEXCOORD0)));
  gl_FragData[0] = tmpvar_1;
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
}