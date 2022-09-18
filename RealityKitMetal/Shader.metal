//
//  Shader.metal
//  RealityKitMetal
//
//  Created by ミズキ on 2022/09/18.
//

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>
using namespace metal;

[[ visible ]]
void basicShader(realitykit::surface_parameters shader)
{
    realitykit::surface::surface_properties shaderSurface = shader.surface();
    float time = shader.uniforms().time();
    half r = abs(cos(time * 2.5));
    half g = abs(sin(time * 2.5));
    half b = abs(r - (g * r));
    shaderSurface.set_base_color(half3(r, g, b));
    
    shaderSurface.set_metallic(half(1.0));
    shaderSurface.set_roughness(half(0.0));
    shaderSurface.set_clearcoat(half(1.0));
    shaderSurface.set_clearcoat_roughness(half(0.0));
}

[[ visible ]]
void basicModifier(realitykit::geometry_parameters modifier)
{
    float3 pose = modifier.geometry().model_position();
    float time = modifier.uniforms().time();
    float speed = 1.5;
    float amplitud = 0.1;
    float offset = 0.05;
    float cosTime = cos(time * speed) * amplitud;
    float sinTime = sin(sin(time * speed)) * (amplitud + offset);
    
    modifier.geometry().set_model_position_offset(float3(cosTime, sinTime, pose.z + 0.1));
}


